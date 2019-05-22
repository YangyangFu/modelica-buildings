# author: Yangyang Fu
# plot simulation results to compare different cases
# PLR = 1
# PLR = 0.75
# PLR = 0.5
# PLR = 0.25

import os
from buildingspy.io.outputfile import Reader
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy.interpolate as interpolate

from datetime import datetime

from matplotlib import rcParams
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['Times New Roman']
rcParams['font.size'] = 12
rcParams['lines.linewidth'] = 1

# change the working directory
path = "c:/github/modelica-buildings/Buildings/"
os.chdir(path)

# set up interested period (outage in FC mode)
ts = 202*24*3600
te = 203*24*3600
tim_Nor = np.arange(ts,te,60)

# constant values
SOC_Nor = 1
TRooAirSet = 273.15 + 25

## read results
# variabels to be considered
# grid current
# battery current
# pv current
# -------------------------------------------------------------------------
### PLR = 1
# -------------------------

#**** Critical equipment: AHU
#*************************
nameResCriAHU100 = "FC_AHU_PLR075.mat"
resCriAHU100 = Reader(path+nameResCriAHU100,"dymola")

tim_CriAHU100, bat_CriAHU100 = resCriAHU100.values("bat.terminal.i[1]")
tim_CriAHU100, pv_CriAHU100 = resCriAHU100.values("pv.terminal.i[1]")
tim_CriAHU100, gri_CriAHU100 = resCriAHU100.values("gri.terminal.i[1]")


# interplote to every minute
int = interpolate.interp1d(tim_CriAHU100,gri_CriAHU100, kind='linear')
gri_CriAHU100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriAHU100,pv_CriAHU100, kind='linear')
pv_CriAHU100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriAHU100,bat_CriAHU100, kind='linear')
bat_CriAHU100 = int(tim_Nor)

#**** critical equipment: AHU + Pumps
#*************************
nameResCriPum100 = "FC_Pump_PLR075.mat"
resCriPum100 = Reader(path+nameResCriPum100,"dymola")
tim_CriPum100, gri_CriPum100 = resCriPum100.values("gri.terminal.i[1]")
tim_CriPum100, pv_CriPum100 = resCriPum100.values("pv.terminal.i[1]")
tim_CriPum100, bat_CriPum100 = resCriPum100.values("bat.terminal.i[1]")
# interplote to every minute
int = interpolate.interp1d(tim_CriPum100,gri_CriPum100, kind='linear')
gri_CriPum100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum100,pv_CriPum100, kind='linear')
pv_CriPum100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum100,bat_CriPum100, kind='linear')
bat_CriPum100 = int(tim_Nor)

#**** critical equipment: Pumps to AHU
#*************************
nameResCriPumAHU100 = "FC_PumpToAHU_PLR075.mat"
resCriPumAHU100 = Reader(path+nameResCriPumAHU100,"dymola")
tim_CriPumAHU100, gri_CriPumAHU100 = resCriPumAHU100.values("gri.terminal.i[1]")
tim_CriPumAHU100, pv_CriPumAHU100 = resCriPumAHU100.values("pv.terminal.i[1]")
tim_CriPumAHU100, bat_CriPumAHU100 = resCriPumAHU100.values("bat.terminal.i[1]")
# interplote to every minute
int = interpolate.interp1d(tim_CriPumAHU100,gri_CriPumAHU100, kind='linear')
gri_CriPumAHU100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPumAHU100,pv_CriPumAHU100, kind='linear')
pv_CriPumAHU100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPumAHU100,bat_CriPumAHU100, kind='linear')
bat_CriPumAHU100 = int(tim_Nor)
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------

### ------------------------------------------------------------------------------
###           setup time axis
### ------------------------------------------------------------------------------
simStart = pd.Timestamp(2018,1,1,0,0,0)
simEnd = pd.Timestamp(2018,12,31,23,59,0)

datetimelist = pd.date_range(simStart,simEnd,freq = '1min')
# interplote to every 60 s
t = np.arange(0,365*24*3600,60)
timeindex = datetimelist[np.logical_and(t>=ts,t<=te)]

# sticks every 5 minutes
a = timeindex.time[np.arange(0,len(timeindex.time)+1,60)]

####-----------------------------------------------------------------------------
##              start to plot
#### -----------------------------------------------------------------------------
# manupilate the data
gri_CriAHU100 = np.array(gri_CriAHU100)
zeros = np.zeros(len(gri_CriAHU100))
c = np.array([gri_CriAHU100,zeros])
gri_CriAHU100 = np.amin(c,axis=0)

gri_CriPum100 = np.array(gri_CriPum100)
zeros = np.zeros(len(gri_CriPum100))
c = np.array([gri_CriPum100,zeros])
gri_CriPum100 = np.amin(c,axis=0)

gri_CriPumAHU100 = np.array(gri_CriPumAHU100)
zeros = np.zeros(len(gri_CriPumAHU100))
c = np.array([gri_CriPumAHU100,zeros])
gri_CriPumAHU100 = np.amin(c,axis=0)

linestyles = ['-','--','-.']

fig,ax=plt.subplots(3,1,figsize=(10,8))
plt.subplot(311)
plt.plot(timeindex.time,gri_CriAHU100,color = 'k',linestyle=linestyles[0])
plt.plot(timeindex.time,pv_CriAHU100,color = 'k',linestyle=linestyles[1])
plt.plot(timeindex.time,bat_CriAHU100,color = 'k',linestyle=linestyles[2])

plt.ylabel('Current[A]')
plt.xticks(a,[]) # set location and ticklabel(none)
plt.xlabel('')
plt.ylim([-5000,2000])
plt.grid(True,linestyle=':',linewidth=1)
plt.legend(["Grid","PV","UPS"],fontsize=12,ncol=3,bbox_to_anchor=(0., 1.02, 1., .102), loc='lower left', borderaxespad=0.)

plt.subplot(312)
plt.plot(timeindex.time,gri_CriPum100,color = 'k',linestyle=linestyles[0])
plt.plot(timeindex.time,pv_CriPum100,color = 'k',linestyle=linestyles[1])
plt.plot(timeindex.time,bat_CriPum100,color = 'k',linestyle=linestyles[2])
plt.grid(True,linestyle=':',linewidth=1)
plt.ylabel('Current[A]')
plt.ylim([-5000,2000])
plt.xticks(a,[]) # set location and ticklabel(none)
plt.xlabel('')

plt.subplot(313)
plt.plot(timeindex.time,gri_CriPumAHU100,color = 'k',linestyle=linestyles[0])
plt.plot(timeindex.time,pv_CriPumAHU100,color = 'k',linestyle=linestyles[1])
plt.plot(timeindex.time,bat_CriPumAHU100,color = 'k',linestyle=linestyles[2])
plt.grid(True,linestyle=':',linewidth=1)
plt.ylabel('Current[A]')
plt.ylim([-5000,2000])
plt.xticks(a,fontsize=12)
plt.xlabel ('Time')
plt.savefig('dayProfile075-rdc.svg')
plt.savefig('dayProfile075-rdc.pdf')
plt.savefig('dayProfile075-rdc.eps')
plt.show()

### -------------------------------------------------------
###               plot for PLR = 0.25
###---------------------------------------------------------
#fig,ax=plt.subplots(3,1,figsize=(8,6))
#plt.subplot(311)
#plt.plot(timeindex.time,gri_CriAHU025,color = 'k',linestyle=linestyles[0],marker = 'o',markersize=12,markeredgecolor = 'k',
#         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),18))
#plt.plot(timeindex.time,pv_CriAHU025,color = 'k',linestyle=linestyles[1],marker = '.',markersize=14,alpha=0.8,markevery=range(0,len(timeindex),18))
#plt.plot(timeindex.time,bat_CriAHU025,color = 'k',linestyle=linestyles[2],marker = 'v',markersize=12,markeredgecolor = 'k',
#         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(2,len(timeindex),18))

#plt.ylabel('Current[A]')
#plt.xticks(a,[]) # set location and ticklabel(none)
#plt.xlabel('')
#plt.grid(True,linestyle=':',linewidth=1)
#plt.legend(["Grid","PV","UPS"],fontsize=12)

#plt.subplot(312)
#plt.plot(timeindex.time,gri_CriPum025,color = 'k',linestyle=linestyles[0],marker = 'o',markersize=12,markeredgecolor = 'k',
#         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),18))
#plt.plot(timeindex.time,pv_CriPum025,color = 'k',linestyle=linestyles[1],marker = '.',markersize=14,alpha=0.8,markevery=range(0,len(timeindex),18))
#plt.plot(timeindex.time,bat_CriPum025,color = 'k',linestyle=linestyles[2],marker = 'v',markersize=12,markeredgecolor = 'k',
#         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(2,len(timeindex),18))
#plt.grid(True,linestyle=':',linewidth=1)
#plt.ylabel('Current[A]')
#plt.xticks(a,[]) # set location and ticklabel(none)
#plt.xlabel('')

#plt.subplot(313)
#plt.plot(timeindex.time,gri_CriPumAHU025,color = 'k',linestyle=linestyles[0],marker = 'o',markersize=12,markeredgecolor = 'k',
#         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),18))
#plt.plot(timeindex.time,pv_CriPumAHU025,color = 'k',linestyle=linestyles[1],marker = '.',markersize=14,alpha=0.8,markevery=range(0,len(timeindex),18))
#plt.plot(timeindex.time,bat_CriPumAHU025,color = 'k',linestyle=linestyles[2],marker = 'v',markersize=12,markeredgecolor = 'k',
#         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(2,len(timeindex),18))
#plt.grid(True,linestyle=':',linewidth=1)
#plt.ylabel('Current[A]')
#plt.xticks(a,fontsize=12)
#plt.xlabel ('Time')
#plt.savefig('FCPLR025-rdc.svg')
#plt.savefig('FCPLR025-rdc.eps')
#plt.show()
