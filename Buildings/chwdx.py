# -*- coding: utf-8 -*-
"""
Author: Yangyang Fu
Email: yangyang.fu@colorado.edu
Date: 11/3/2017

"""
from buildingspy.simulate.Simulator import Simulator
from buildingspy.io.outputfile import Reader
import pandas as pd
import datetime as dt
import scipy.interpolate as interpolate
import matplotlib.pyplot as plt
import numpy as np
import math 
import seaborn as sns
from scipy import stats
import matplotlib as mlp


def integral(t, v):
    '''Get the integral of the data series.
    '''

    import numpy as np
    
    val=0.0
    val=np.trapz(v,t)
    return val
    
def autolabel(rects):
    """
    Attach a text label above each bar displaying its height
    """
    for rect in rects:
        height = rect.get_height()
        ax.text(rect.get_x() + rect.get_width()/2., 1.02*height,
                '%.2f' % height,
                ha='center', va='bottom')


# Specify package path
path = "/home/yangyangfu/github/modelica-buildings/Buildings"

# Set simulation parameters
startTime = 0
stopTime = 365*24*3600
solver = "cvode"

# calculate the chilled water system
model1 = "Buildings.Applications.DataCenters.ChillerCooled.Examples.IntegratedPrimarySecondaryEconomizer"

s1 = Simulator(model1, "dymola", packagePath = path)
s1.setStopTime(stopTime)
s1.setStartTime(startTime)
s1.setResultFile('System1')
s1.setSolver(solver)
s1.showProgressBar(show=True)
#s1.simulate()


# calculate the dx cooling system
model2 = "Buildings.Applications.DataCenters.ChillerCooled.Examples.NonIntegratedPrimarySecondaryEconomizer"

s2 = Simulator(model2, "dymola", packagePath = path)
s2.setStopTime(stopTime)
s2.setStartTime(startTime)
s2.setResultFile('System2')
s2.setSolver(solver)
s2.showProgressBar(show=True)
#s2.simulate()

"""
----------------------Read simulation results--------------------------

"""
r1 = Reader('System1.mat',"dymola")
t1,switchTimes1 = r1.values('swiTim.y')
t1,freeCoolingHours1 = r1.values('FCTim.y')
t1,partialMechanicalHours1 = r1.values('PMCTim.y')
t1,fullMechanicalHours1 = r1.values('FMCTim.y')
t1,hvacKWH1 = r1.values('EHVAC.y')
t1,itKWH1 = r1.values('EIT.y')



r2 = Reader('System2.mat',"dymola")
t2,switchTimes2 = r2.values('swiTim.y')
t2,freeCoolingHours2 = r2.values('FCTim.y')
t2,partialMechanicalHours2 = r2.values('PMCTim.y')
t2,fullMechanicalHours2 = r2.values('FMCTim.y')
t2,hvacKWH2 = r2.values('EHVAC.y')
t2,itKWH2 = r2.values('EIT.y')

"""
------------------------- Interpolate ---------------------------------------
"""               
baseDay = dt.datetime(2017,1,1,0,0,0)  
endDay = dt.datetime(2018,1,1,0,0,0)     
datetimeBase = baseDay.toordinal() 
datetimeEnd = endDay.toordinal() 
datetime1 = datetimeBase + t1
datetime2 = datetimeBase + t2

# Generate evenly spaced samp;e data by interpolation for system 1
t1_new = range(0,31536001,3600)

f1_switchTimes = interpolate.interp1d(t1,switchTimes1, kind='linear')
switchTimes1_new = f1_switchTimes(t1_new)
f1_freeCoolingHours = interpolate.interp1d(t1,freeCoolingHours1, kind='linear')
freeCoolingHours1_new = f1_freeCoolingHours(t1_new)/3600
f1_partialMechanicalHours = interpolate.interp1d(t1,partialMechanicalHours1, kind='linear')
partialMechanicalHours1_new = f1_partialMechanicalHours(t1_new)/3600
f1_fullMechanicalHours = interpolate.interp1d(t1,fullMechanicalHours1, kind='linear')
fullMechanicalHours1_new = f1_fullMechanicalHours(t1_new)/3600
result1=pd.DataFrame({'switchTimes':switchTimes1_new,
                      'freeCoolingHours':freeCoolingHours1_new,
                      'partialMechanicalHours':partialMechanicalHours1_new,
                      'fullMechanicalHours':fullMechanicalHours1_new},index=t1_new)
                      
# Generate evenly spaced samp;e data by interpolation for system 2
t2_new = t1_new

f2_switchTimes = interpolate.interp1d(t2,switchTimes2, kind='linear')
switchTimes2_new = f2_switchTimes(t2_new)
f2_freeCoolingHours = interpolate.interp1d(t2,freeCoolingHours2, kind='linear')
freeCoolingHours2_new = f2_freeCoolingHours(t2_new)/3600
f2_partialMechanicalHours = interpolate.interp1d(t2,partialMechanicalHours2, kind='linear')
partialMechanicalHours2_new = f2_partialMechanicalHours(t2_new)/3600
f2_fullMechanicalHours = interpolate.interp1d(t2,fullMechanicalHours2, kind='linear')
fullMechanicalHours2_new = f2_fullMechanicalHours(t2_new)/3600
result2 = pd.DataFrame({'switchTimes':switchTimes2_new,
                      'freeCoolingHours':freeCoolingHours2_new,
                      'partialMechanicalHours':partialMechanicalHours2_new,
                      'fullMechanicalHours':fullMechanicalHours2_new},index=t2_new)


"""
--------------------------- Plotting ------------------------------------------

"""
days=[31,28,31,30,31,30,31,31,30,31,30,31]
months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

# 1. Switch times
pre1 = 0
pre2 = 0
dfs1=[]
dfs2=[]
for i in range(0,12,1): 
    startT = 0
    endT = sum(days[0:i+1])*24
    loc1 = result1[endT:endT+1]
    loc2 = result2[endT:endT+1]
    if i >0:
        pre1.index = [endT*3600]
        pre2.index = [endT*3600]
    data1 = loc1 - pre1
    pre1 = loc1
    dfs1.append(data1)  
    
    data2 = loc2 - pre2
    pre2 = loc2
    dfs2.append(data2)     
result1_month = pd.concat(dfs1)
result2_month = pd.concat(dfs2)  

result1_month.index = months
result2_month.index = months  
    
    
'''------------------------ Bar charts for switch times -----------------------
'''    
## plot bar chart 
N = 12

x1 = result1_month['switchTimes']
ind = np.arange(N)  # the x locations for the groups
width = 0.35       # the width of the bars

fig, ax = plt.subplots(figsize=(10.0,8.0),dpi=100)
rects1 = ax.bar(ind, x1, width, color='r',hatch='o',alpha=0.6)

x2 = result2_month['switchTimes']
rects2 = ax.bar(ind + width, x2, width, color='y',hatch='-',alpha=0.6)

# add some text for labels, title and axes ticks
ax.set_ylabel('Switch Times',fontsize=12)
#ax.set_title('Switch Times in Two Systems')
ax.set_xticks(ind + width / 2)
ax.set_xticklabels(months,fontsize=12)

ax.legend((rects1[0], rects2[0]), ('System 1', 'System 2'),fontsize=12,loc="upper center")

autolabel(rects1)
autolabel(rects2)

plt.savefig('plot1.eps',dpi=300)
plt.savefig('plot1.svg',dpi=600)
plt.show()
    
'''-------------------- Bar charts for economizing hours ------------------------
'''
mlp.style.use('seaborn')
sns.set(font_scale = 1.4)
fig = plt.figure(figsize=(6,4),dpi=100)
freeCooling = result1_month['freeCoolingHours']/8760
partialMechanical =result1_month['partialMechanicalHours']/8760
fullMechanical = result1_month['fullMechanicalHours']/8760

p1 = plt.bar(ind, freeCooling, width, color = '#7f6d5f',hatch='///',alpha=0.7)
p2 = plt.bar(ind, partialMechanical, width, bottom=freeCooling, hatch='...',alpha=0.7)
p3 = plt.bar(ind, fullMechanical, width, bottom=partialMechanical+freeCooling, hatch = 'xxx',alpha=0.7)

plt.ylabel('Normalized time [-]')
plt.xticks(ind,months)
plt.yticks(0.01*np.arange(0,12))
plt.legend((p1[0], p2[0],p3[0]), ('FC', 'PMC','FMC'),loc='upper center',ncol=3,mode='expand')

plt.savefig('plot2.eps',dpi=300)
plt.savefig('plot2.svg',dpi=600)
plt.savefig('plot2.tif',dpi=600)
plt.show()


fig = plt.figure(figsize=(6,4),dpi=100)
freeCooling = result2_month['freeCoolingHours']/8760
partialMechanical =result2_month['partialMechanicalHours']/8760
fullMechanical = result2_month['fullMechanicalHours']/8760

p4 = plt.bar(ind, freeCooling, width,color = '#7f6d5f', hatch='///',alpha=0.7)
p5 = plt.bar(ind, partialMechanical, width, bottom=freeCooling, hatch='...',alpha=0.7)
p6 = plt.bar(ind, fullMechanical, width, bottom=partialMechanical+freeCooling, hatch = 'xxx',alpha=0.7)

plt.ylabel('Normalized time [-]')
plt.xticks(ind,months)
plt.yticks(0.01*np.arange(0,12))
plt.legend((p4[0], p5[0],p6[0]), ('FC', 'PMC','FMC'),loc='upper center',ncol=3,mode='expand')

plt.savefig('plot3.eps',dpi=300)
plt.savefig('plot3.svg',dpi=600)
plt.savefig('plot3.tif',dpi=600)
plt.show()

'''-------------------------- plotting for PUE ------------------------------
'''
ITEnergy1 = itKWH1[-1]
hvacEnergy1 = hvacKWH1[-1] 
PUE1 = 1 + hvacEnergy1/ITEnergy1

ITEnergy2 = itKWH2[-1]
hvacEnergy2 = hvacKWH2[-1] 
PUE2 = 1 + hvacEnergy2/ITEnergy2

ind = [0,1]
width = 0.4
fig, ax = plt.subplots()
p = ax.bar(ind, [PUE1,PUE2], width, color='C9',hatch='/',edgecolor = "k")
plt.title('PUE for Two Systems')
plt.xticks(ind,['System 1','System 2'],fontsize=12,fontname='monospace')
plt.yticks(np.arange(0,1.6,0.2))
plt.ylabel('PUE',fontsize=12,fontname='monospace')

autolabel(p)

plt.savefig('plot4.eps',dpi=300)
plt.savefig('plot4.svg',dpi=600)
plt.savefig('plot4.tif',dpi=600)
plt.show()    

#
##'''-------------------------------Compare energy consumption
##'''
##
### Read chiller power
##chi1 = (r1.integral('chiWSE.powChi[1]')+r1.integral('chiWSE.powChi[2]'))/3600/1e6
##chi2 = (r2.integral('chiWSE.powChi[1]')+r2.integral('chiWSE.powChi[2]'))/3600/1e6
##
##       
### Total energy       
##E1 = r1.max("EHVAC.y")/3600/1e6
##E2 = r2.max("EHVAC.y")/3600/1e6
##        
### AHU Total= Pfan + Pheat
##ahu1 = (r1.integral('ahu.PHea') + r1.integral('ahu.PFan'))/3600/1e6 
##ahu2 = (r2.integral('ahu.PHea') + r2.integral('ahu.PFan'))/3600/1e6 
##          
### cooling tower
##ct1 =  (r1.integral('cooTow[1].PFan') + r1.integral('cooTow[2].PFan'))/3600/1e6
##ct2 =  (r2.integral('cooTow[1].PFan') + r2.integral('cooTow[2].PFan'))/3600/1e6 
##      
### primary pumps
##pripump1 = (r1.integral('chiWSE.powPum[1]') + r1.integral('chiWSE.powPum[2]'))/3600/1e6
##pripump2 = (r2.integral('priPum.P[1]') + r2.integral('priPum.P[2]'))/3600/1e6
##
### secondary pumps
##secpump1 = (r1.integral('secPum.P[1]') + r1.integral('secPum.P[2]'))/3600/1e6
##secpump2 = (r2.integral('secPum.P[1]') + r2.integral('secPum.P[2]'))/3600/1e6
##
### condenser pump
##conpump1 = (r1.integral('pumCW.P[1]') + r1.integral('pumCW.P[2]'))/3600/1e6
##conpump2 = (r2.integral('pumCW.P[1]') + r2.integral('pumCW.P[2]'))/3600/1e6
##         
### store data in a data frame
##dic = {'Chiller':[chi1,chi2],'AHU Reheater':[ahu1,ahu2],'Primary Pump':[pripump1,pripump2],
##       'Condenser Pump':[conpump1,conpump2],'Cooling Tower':[ct1,ct2], 
##       'Secondary Pump':[secpump1,secpump2]}
##
##df = pd.DataFrame(data=dic,index=['System 1','System 2F'])
##df = df.transpose()
##ax = plt.figure(figsize=(8,6)).add_subplot(111)
##df.plot(ax =ax, kind='bar',width=0.8,alpha=0.7)
##bars = ax.patches
##hatches = ''.join(h*len(df) for h in 'x/O.')
##for bar, hatch in zip(bars, hatches):
##    bar.set_hatch(hatch)
##    
##plt.xticks(rotation=15,fontsize=12)
###[0,1.5,3,4.5,6,7.5]
##plt.ylabel('Energy [MWh]',fontsize=12)
##plt.ylim([0,400])
##plt.legend(fontsize=12)
##rects = ax.patches
##autolabel(rects)
##plt.savefig('System1VSSystem2-power.svg')
##plt.savefig('System1VSSystem2-power.eps')
#
#
#'''------------------------------- runtime------------------------------
#'''
#
#'''
#---------------------- Runing time ------------------------------ 
#'''
#FC1 = r1.max('FCTim.y')/3600
#PMC1 = r1.max('PMCTim.y')/3600
#FMC1 = r1.max('FMCTim.y')/3600
#
#FC2 = r2.max('FCTim.y')/3600
#PMC2 = r2.max('PMCTim.y')/3600
#FMC2 = r2.max('FMCTim.y')/3600
#         
#runTime = pd.DataFrame({'FC':[FC1,FC2],
#                        'PMC':[PMC1,PMC2],
#                        'FMC':[FMC1,FMC2]},
#        index=['System 1','System 2'])
#
#ax = plt.figure(figsize=(8,6)).add_subplot(111)
#runtime=runTime.transpose()
#runtime.plot(ax=ax, kind='bar',width=0.8,alpha=0.5)
#bars = ax.patches
#hatches = ''.join(h*len(runtime) for h in 'x/O.')
#for bar, hatch in zip(bars, hatches):
#    bar.set_hatch(hatch)
#
#plt.xticks(rotation=15,fontsize=12)
#plt.ylabel('Hours',fontsize=12)
#plt.ylim([0,8000])
#plt.legend(fontsize=12)
#plt.grid(False)
#rects = ax.patches
#autolabel(rects)
#plt.savefig('System1VSSystem2-runtime.svg')
#
#
#'''---------------------- get data for Twb and cooMod
#'''
#t1,Twb1_raw = r1.values("weaData.weaBus.TWetBul")
#t1,Tdb1_raw = r1.values("weaData.weaBus.TDryBul")
#t1,cooMod1_raw = r1.values("cooModCon.y")
#FC1_raw = cooMod1_raw<1.5
#FC1_raw = [int(x) for x in FC1_raw]
#PMC1_raw = []
#for sig in cooMod1_raw:
#    if sig>=1.5 and sig<2.5:
#        PMC1_raw.append(1)
#    else:
#        PMC1_raw.append(0)
#FMC1_raw = cooMod1_raw>=2.5
#FMC1_raw = [int(x) for x in FMC1_raw]
## interplote to get evenly distributed data
#fTwb1 = interpolate.interp1d(t1,Twb1_raw, kind='linear')
#Twb1 = fTwb1(t1_new)-273.15
#fTdb1 = interpolate.interp1d(t1,Tdb1_raw, kind='linear')
#Tdb1 = fTdb1(t1_new)-273.15
#fFC1 = interpolate.interp1d(t1,FC1_raw, kind='linear')
#FC1 = [int(x) for x in fFC1(t1_new)]
#fPMC1 = interpolate.interp1d(t1,PMC1_raw, kind='linear')
#PMC1 = [int(x) for x in fPMC1(t1_new)]
#fFMC1 = interpolate.interp1d(t1,FMC1_raw, kind='linear')
#FMC1 = [int(x) for x in fFMC1(t1_new)]
#fcooMod1 = interpolate.interp1d(t1,cooMod1_raw, kind='linear')
#cooMod1_int = fcooMod1(t1_new)
#cooMod1 = ['' for i in range(len(cooMod1_int))]
#for i in range(0,len(cooMod1_int)):
#    if cooMod1_int[i] < 1.5:
#        cooMod1[i]='FC'
#    elif cooMod1_int[i]>2.5:
#        cooMod1[i]='FMC'
#    else: 
#        cooMod1[i]='PMC'
#        
#dic1 = {"Twb":Twb1,"FC":FC1,"PMC":PMC1,"FMC":FMC1,"mode":cooMod1,"Tdb":Tdb1}
#
#t2,Twb2_raw = r2.values("weaBus.TWetBul")
#t2,Tdb2_raw = r2.values("weaBus.TDryBul")
#t2,cooMod2_raw = r2.values("cooModCon.y")
#FC2_raw = cooMod2_raw<1.5
#FC2_raw = [int(x) for x in FC2_raw]
#PMC2_raw = []
#for sig in cooMod2_raw:
#    if sig>=1.5 and sig<2.5:
#        PMC2_raw.append(1)
#    else:
#        PMC2_raw.append(0)
#FMC2_raw = cooMod2_raw>=2.5
#FMC2_raw = [int(x) for x in FMC2_raw]
## interplote to get evenly distributed data
#fTwb2 = interpolate.interp1d(t2,Twb2_raw, kind='linear')
#Twb2 = fTwb2(t2_new)-273.15
#fTdb2 = interpolate.interp1d(t2,Tdb2_raw, kind='linear')
#Tdb2 = fTdb2(t2_new)-273.15
#fFC2 = interpolate.interp1d(t2,FC2_raw, kind='linear')
#FC2 = [int(x) for x in fFC2(t2_new)]
#fPMC2 = interpolate.interp1d(t2,PMC2_raw, kind='linear')
#PMC2 = [int(x) for x in fPMC2(t2_new)]
#fFMC2 = interpolate.interp1d(t2,FMC2_raw, kind='linear')
#FMC2 = [int(x) for x in fFMC2(t2_new)]
#fcooMod2 = interpolate.interp1d(t2,cooMod2_raw, kind='linear')
#cooMod2_int = fcooMod2(t2_new)
#cooMod2 = ['' for i in range(len(cooMod2_int))]
#for i in range(0,len(cooMod2_int)):
#    if cooMod2_int[i] < 1.5:
#        cooMod2[i]='FC'
#    elif cooMod2_int[i]>2.5:
#        cooMod2[i]='FMC'
#    else: 
#        cooMod2[i]='PMC'
#        
#dic2 = {"Twb":Twb2,"FC":FC2,"PMC":PMC2,"FMC":FMC2,"mode":cooMod2,"Tdb":Tdb2}
#
####### data frame
#dat1 = pd.DataFrame.from_dict(dic1)
#dat2 = pd.DataFrame.from_dict(dic2)
#
#'''-------------------
#'''
#sns.set(style="ticks")
#g = sns.FacetGrid(dat1, col="FC")
#g.map(plt.hist, "Twb");
#
#'''------------------------- plot distribution
#'''
#sns.set(font_scale = 1.2)
#g = sns.FacetGrid(dat1, row="mode",size=1.5, aspect=4)
#g.map(sns.distplot, "Twb", hist=True, rug=True);
#g.set(ylim=(0,0.5))
#g.set_axis_labels(u'$T_{wb}$ [$^\circ$C]',u'frequency')
#plt.savefig('cooModevsTwb-System1.svg')
#
#g = sns.FacetGrid(dat2, row="mode",size=1.5, aspect=4)
#g.map(sns.distplot, "Twb", hist=True, rug=True);
#g.set(ylim=(0,0.5))
#g.set_axis_labels(u'$T_{wb}$ [$^\circ$C]',u'frequency')
#plt.savefig('cooModevsTwb-System2.svg')
#
#'''---------------------------- plot hexbin 
#'''
#def hexbin(x, y, color, **kwargs):
#    cmap = sns.light_palette(color, as_cmap=True)
#    plt.hexbin(x, y, gridsize=15, cmap=cmap, **kwargs)
#
#with sns.axes_style("dark"):
#    sns.set(font_scale = 2)
#    g = sns.FacetGrid(dat1, hue="mode", col="mode", size=4)
#g=g.map(hexbin, "Twb", "Tdb", extent=[-25, 25, -25, 35])
#g.set_axis_labels(u'$T_{wb}$ [$^\circ$C]',u'$T_{db}$ [$^\circ$C]')
#plt.xticks(np.arange(-20,26,10))
#plt.yticks(np.arange(-20,35,10))
#g.savefig('TwbTdb-System1.svg')
#
#
#with sns.axes_style("dark"):
#    sns.set(font_scale = 2)
#    g = sns.FacetGrid(dat2, hue="mode", col="mode", size=4)
#g=g.map(hexbin, "Twb", "Tdb", extent=[-25, 25, -25, 35])
#g.set_axis_labels(u'$T_{wb}$ [$^\circ$C]',u'$T_{db}$ [$^\circ$C]')
#plt.xticks(np.arange(-20,26,10))
#plt.yticks(np.arange(-20,35,10))
#g.savefig('TwbTdb-System2.svg')
#
#'''-------------------------- plot voilin
#'''
#fig = plt.figure(figsize=(8,6))
#ax1 = fig.add_subplot(121)
#ax2 = fig.add_subplot(122)
#
#with sns.axes_style("darkgrid"):
#    sns.violinplot(data=dat1,x="mode",y="Twb",ax=ax1,palette="pastel",aspect=0.75,size=8)    
#    sns.violinplot(data=dat2,x="mode",y="Twb",ax=ax2,palette="pastel",aspect=0.75,size=8)
#    ax2.legend(['System 2'],loc="lower right",fontsize=12)
#    ax1.legend(['System 1'],loc="lower right",fontsize=12)
#    ax1.xaxis.set_tick_params(labelsize=12)
#    ax1.yaxis.set_tick_params(labelsize=12)
#    ax2.set_yticks([])
#    ax2.set_ylabel('')
#    ax1.set_ylabel(u'$T_{wb}$ [$^\circ$C]',fontsize=14)
##    
#    
#'''----------------------------- room temperature/RH comparison
#'''
#t1,TRoo1_raw = r1.values("TAirSup.T")
#t2,TRoo2_raw = r2.values("senTemSupAir.T")
#fTRoo1 = interpolate.interp1d(t1,TRoo1_raw, kind='linear')
#TRoo1 = fTRoo1(t1_new)-273.15
#fTRoo2 = interpolate.interp1d(t2,TRoo2_raw, kind='linear')
#TRoo2 = fTRoo2(t2_new)-273.15
#
#t1,RHRoo1_raw = r1.values("relHumSupAir.phi")
#t2,RHRoo2_raw = r2.values("relHumSupAir.phi")
#fRHRoo1 = interpolate.interp1d(t1,RHRoo1_raw, kind='linear')
#RHRoo1 = fRHRoo1(t1_new)*100
#fRHRoo2 = interpolate.interp1d(t2,RHRoo2_raw, kind='linear')
#RHRoo2 = fRHRoo2(t2_new)*100
#
#t1,TCHW1_raw = r1.values("TCHWSup.T")
#fTCHW1 = interpolate.interp1d(t1,TCHW1_raw, kind='linear')
#TCHW1 = fTCHW1(t1_new)-273.15
#
###########  Update data frame
#dat1['TSA']=TRoo1
#dat2['TSA']=TRoo2
#
#dat1['RH']=RHRoo1
#dat2['RH']=RHRoo2
#
#dat1['CHWST']=TCHW1
#
##mlp.style.use('seaborn')
##fig = plt.figure(figsize=(8,6))
##ax1 = fig.add_subplot(121)
##ax2 = fig.add_subplot(122)
##
###sns.boxplot(data=dat1,x="mode",y="RH",ax=ax1,palette="pastel") 
##sns.swarmplot(data=dat1,x="mode",y="RH",ax=ax1,color=".25")   
###sns.boxplot(data=dat2,x="mode",y="RH",ax=ax2,palette="pastel")
##sns.swarmplot(data=dat2,x="mode",y="RH",ax=ax2,color=".25")   
##ax2.legend(['System 2'],loc="upper center",fontsize=12)
##ax1.legend(['System 1'],loc="upper center",fontsize=12)
##ax1.xaxis.set_tick_params(labelsize=12)
##ax1.yaxis.set_tick_params(labelsize=12)
##ax2.set_yticks([])
##ax2.set_ylabel('')
##ax1.set_ylabel(u'Relative humidity [%]',fontsize=14)
#
#dat1=dat1.iloc[24:-1]
#dat2=dat2.iloc[24:-1]
#    
#sns.set(font_scale = 1.5)
#g = sns.FacetGrid(dat1, col="mode",size=4, aspect=0.75)
#g.map(plt.scatter, "TSA",'RH')
#g.set_axis_labels(u'SA Temperature [$^\circ$C]',u'RH [%]')
#g.set(xlim=(15,21),ylim=(0,100))
#plt.savefig('cooModevsRH-System1.svg')
#
#g = sns.FacetGrid(dat2, col="mode",size=4, aspect=0.75)
#g.map(plt.scatter, "TSA",'RH')
#g.set(xlim=(15,21),ylim=(0,100))
#g.set_axis_labels(u'SA Temperature [$^\circ$C]',u'RH [%]')
#plt.savefig('cooModevsRH-System2.svg')
#
#    
#sns.set(font_scale = 1.2)
#g = sns.FacetGrid(dat1, col="mode",size=4, aspect=0.75)
#g.map(plt.scatter, "TSA",'CHWST')
#g.set_axis_labels(u'SA Temperature [$^\circ$C]',u'RH [%]')
#g.set(xlim=(15,21),ylim=(4,12))
#plt.savefig('cooModevsCHWST-System1.svg')
