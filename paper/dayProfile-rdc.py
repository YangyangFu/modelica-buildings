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
ts = 364*24*3600
te = 365*24*3600
tim_Nor = np.arange(ts,te,1800)

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
nameResCriAHU100 = "PLR075SolarData.mat"
resCriAHU100 = Reader(path+nameResCriAHU100,"dymola")

tim_CriAHU100, bat_CriAHU100 = resCriAHU100.values("bat.terminal.i[1]")
tim_CriAHU100, pv_CriAHU100 = resCriAHU100.values("pv.terminal.i[1]")
tim_CriAHU100, gri_CriAHU100 = resCriAHU100.values("gri.terminal.i[1]")

print tim_CriAHU100
print tim_Nor

# interplote to every minute
int = interpolate.interp1d(tim_CriAHU100,gri_CriAHU100, kind='linear')
gri_CriAHU100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriAHU100,pv_CriAHU100, kind='linear')
pv_CriAHU100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriAHU100,bat_CriAHU100, kind='linear')
bat_CriAHU100 = int(tim_Nor)


# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------

### ------------------------------------------------------------------------------
###           setup time axis
### ------------------------------------------------------------------------------
simStart = pd.Timestamp(2018,1,1,0,0,0)
simEnd = pd.Timestamp(2018,12,31,23,59,0)

datetimelist = pd.date_range(simStart,simEnd,freq = '30min')
# interplote to every 1800 s
t = np.arange(0,365*24*3600,1800)
timeindex = datetimelist[np.logical_and(t>=ts,t<te)]

# sticks every 60 minutes
a = timeindex.time[np.arange(0,len(timeindex.time),2)]

####-----------------------------------------------------------------------------
##              start to plot
#### -----------------------------------------------------------------------------
# manupilate the data
linestyles = ['-','-.','--']

fig,ax=plt.subplots(figsize=(10,6))

plt.subplot()
plt.plot(timeindex.time,gri_CriAHU100,color = 'k',linestyle=linestyles[0],label='Gird')
plt.plot(timeindex.time,pv_CriAHU100,color = 'k',linestyle=linestyles[1],label='PV')
plt.plot(timeindex.time,bat_CriAHU100,color = 'k',linestyle=linestyles[2],label='UPS')
plt.grid(True,linestyle=':',linewidth=0.5)
plt.ylabel('Current[A]')
plt.ylim([-4000,1000])
plt.xticks(a,fontsize=12,rotation='30')
plt.legend()
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
