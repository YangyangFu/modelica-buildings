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


# set up interested period (outage in FC mode)
tse = 5150*60 #minute
tee = 5151*60
ts = (tse-5)*60 # second
te = tee*60
tim_Nor = np.arange(ts,te+1,1)
t = np.arange(0,365*24*3600,1)

# constant values
# sweeping parameters
case = 'FMC'
scaPV6 = 0.6
scaPV0 = 0
PLR = 0.75

## PV=0
modelName0 = case + '_pv'+str(scaPV0)+'_plr'+str(PLR)
model = case+'_Pump_RDC_Time'

## PV =0.6
modelName6 = case + '_pv'+str(scaPV6)+'_plr'+str(PLR)

## read results
# -------------------------------------------------------------------------
# ----------------------------------------------------------------------------
res0 = Reader(modelName0+'/'+model+'.mat',"dymola")
tim_0, SOC_0 = res0.values("bat.SOC")
tim_0, bat_0 = res0.values("bat.terminal.i[1]")
tim_0, pv_0 = res0.values("pv.terminal.i[1]")
tim_0, gri_0 = res0.values("gri.terminal.i[1]")

# interplote to every minute
int = interpolate.interp1d(tim_0,SOC_0, kind='linear')
SOC_0 = int(tim_Nor)

int = interpolate.interp1d(tim_0,bat_0, kind='linear')
bat_0 = int(tim_Nor)
#int = interpolate.interp1d(tim_0,pv_0, kind='linear')
pv_0 = np.zeros(len(bat_0))
print(pv_0)

int = interpolate.interp1d(tim_0,gri_0, kind='linear')
gri_0 = int(tim_Nor)

# **** results from conventional DC
res0c = Reader(modelName6+'/'+model+'.mat',"dymola")
tim_0c, SOC_0c = res0c.values("bat.SOC")
tim_0c, bat_0c = res0c.values("bat.terminal.i[1]")
tim_0cp, pv_0c = res0c.values("pv.terminal.i[1]")
tim_0c, gri_0c = res0c.values("gri.terminal.i[1]")

# interplote to every minute
int = interpolate.interp1d(tim_0c,SOC_0c, kind='linear')
SOC_0c = int(tim_Nor)

int = interpolate.interp1d(tim_0c,bat_0c, kind='linear')
bat_0c = int(tim_Nor)
int = interpolate.interp1d(tim_0cp,pv_0c, kind='linear')
pv_0c = int(tim_Nor)
int = interpolate.interp1d(tim_0c,gri_0c, kind='linear')
gri_0c = int(tim_Nor)

print bat_0c
bat_0c[0:300]=0
print bat_0c

print(SOC_0)
print(SOC_0c)
### ------------------------------------------------------------------------------
###           setup time axis
### ------------------------------------------------------------------------------
simStart = pd.Timestamp(2018,1,1,0,0,0)
simEnd = pd.Timestamp(2018,12,31,23,59,0)

datetimelist = pd.date_range(simStart,simEnd,freq = '1s')
timeindex = datetimelist[np.logical_and(t>=ts,t<=te)]
timeEvent = datetimelist[np.logical_and(t>=tse*60,t<=tee*60)]
print timeEvent
# sticks every 5 minutes
a = timeindex.time[np.arange(300,len(timeindex.time)+1,900)]
print a

####-----------------------------------------------------------------------------
##              start to plot
#### -----------------------------------------------------------------------------
linestyles = ['-','-.','--']

### -------------------------------------------------------
###               plot for PLR = 0.50
###---------------------------------------------------------
fig,ax=plt.subplots(figsize=(10,6))
plt.subplot(311)
plt.plot(timeindex.time,SOC_0,color = 'k',linestyle=linestyles[0],label=u'$r_{pv}=0$')
plt.plot(timeindex.time,SOC_0c,color = 'k',linestyle=linestyles[1],label=u'$r_{pv}=0.6$')
plt.grid(True,linestyle=':',linewidth=0.5)
plt.ylabel('SOC')
plt.xticks(a,[])
plt.xlabel ('')
plt.legend(loc=1)
plt.ylim([-0.2,1.2])


plt.subplot(312)
plt.plot(timeindex.time,bat_0,color = 'k',linestyle=linestyles[0])
plt.plot(timeindex.time,bat_0c,color = 'k',linestyle=linestyles[1])
plt.grid(True,linestyle=':',linewidth=0.5)
plt.ylabel('UPS Current [A]')
plt.xticks(a,[])
plt.legend(loc=4)
plt.ylim()
plt.xlabel ('')

plt.subplot(313)
plt.plot(timeindex.time,pv_0,color = 'k',linestyle=linestyles[0])
plt.plot(timeindex.time,pv_0c,color = 'k',linestyle=linestyles[1])
plt.grid(True,linestyle=':',linewidth=0.5)
plt.ylabel('PV Current [A]')
plt.xticks(a,fontsize=12,rotation='30')
plt.legend(loc=4)
plt.ylim()
plt.xlabel ('Time')
plt.savefig('SOC-RDC.svg')
plt.savefig('SOC-RDC.pdf')
plt.savefig('SOC-RDC.eps')
plt.show()
