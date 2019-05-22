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
path = "c:/github/modelica-buildings/paper/"
os.chdir(path)

# set up interested period (outage in FC mode)
tse = 8748*60 #minute
tee = 8749*60
ts = (tse-5)*60 # second
te = (tee-1)*60
tim_Nor = np.arange(ts,te+1,1)
t = np.arange(0,365*24*3600,1)
# constant values
SOC_Nor = 1
TRooAirSet = 273.15 + 25

## read results
# -------------------------------------------------------------------------
# ----------------------------------------------------------------------------
## PLR = 0.50
# normal operation

#**** critical equipment: Pumps in RDC
#*************************
nameResCriPum075 = "FC_Pump_PLR075_RDC_Time.mat"
resCriPum075 = Reader(path+nameResCriPum075,"dymola")
tim_CriPum075, SOC_CriPum075 = resCriPum075.values("bat.SOC")
tim_CriPum075, bat_CriPum075 = resCriPum075.values("bat.terminal.i[1]")
tim_CriPum075, pv_CriPum075 = resCriPum075.values("pv.terminal.i[1]")
tim_CriPum075, gri_CriPum075 = resCriPum075.values("gri.terminal.i[1]")

# interplote to every minute
int = interpolate.interp1d(tim_CriPum075,SOC_CriPum075, kind='linear')
SOC_CriPum075 = int(tim_Nor)

int = interpolate.interp1d(tim_CriPum075,bat_CriPum075, kind='linear')
bat_CriPum075 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum075,pv_CriPum075, kind='linear')
pv_CriPum075 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum075,gri_CriPum075, kind='linear')
gri_CriPum075 = int(tim_Nor)

# **** results from conventional DC
nameResCriPum075c = "FC_Pump_PLR075_Time.mat"
resCriPum075c = Reader(path+nameResCriPum075c,"dymola")
tim_CriPum075c, SOC_CriPum075c = resCriPum075c.values("bat.SOC")
tim_CriPum075c, bat_CriPum075c = resCriPum075c.values("bat.terminal.i[1]")
tim_CriPum075c, gri_CriPum075c = resCriPum075c.values("gri.terminal.i[1]")

# interplote to every minute
int = interpolate.interp1d(tim_CriPum075c,SOC_CriPum075c, kind='linear')
SOC_CriPum075c = int(tim_Nor)

int = interpolate.interp1d(tim_CriPum075c,bat_CriPum075c, kind='linear')
bat_CriPum075c = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum075c,gri_CriPum075c, kind='linear')
gri_CriPum075c = int(tim_Nor)

print bat_CriPum075c
bat_CriPum075c[0:300]=0
bat_CriPum075c[23*60:]=0
print bat_CriPum075c


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
a = timeindex.time[np.arange(300,len(timeindex.time)+1,300)]
print a

####-----------------------------------------------------------------------------
##              start to plot
#### -----------------------------------------------------------------------------
linestyles = ['-','-.','--']

### -------------------------------------------------------
###               plot for PLR = 0.50
###---------------------------------------------------------
fig,ax=plt.subplots(figsize=(10,6))
plt.subplot(211)
plt.plot(timeindex.time,SOC_CriPum075,color = 'k',linestyle=linestyles[0],label='Renewable')
plt.plot(timeindex.time,SOC_CriPum075c,color = 'k',linestyle=linestyles[1],label='Conventional')
plt.grid(True,linestyle=':',linewidth=0.5)
plt.ylabel('SOC')
plt.xticks(a,[])
plt.xlabel ('')
plt.legend(loc=1)
plt.ylim([-0.2,1.2])


plt.subplot(212)
plt.plot(timeindex.time,bat_CriPum075,color = 'k',linestyle=linestyles[0],label='UPS Renewable')
plt.plot(timeindex.time,pv_CriPum075,color = 'k',linestyle=linestyles[1],label='PV Renewable')
plt.plot(timeindex.time,bat_CriPum075c,color = 'k',linestyle=linestyles[2],label='UPS Conventional')
plt.grid(True,linestyle=':',linewidth=0.5)
plt.ylabel('Current [A]')
plt.xticks(a,fontsize=12,rotation='30')
plt.legend(loc=4)
plt.ylim()
plt.xlabel ('Time')
plt.savefig('UPSTime-RDC.svg')
plt.savefig('UPSTime-RDC.pdf')
plt.savefig('UPSTime-RDC.eps')
plt.show()