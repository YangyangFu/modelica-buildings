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
tse = 8748*60
tee = 8748.25*60
ts = (tse-5)*60
te = (tee+5)*60
tim_Nor = np.arange(ts,te+1,10)
t = np.arange(0,365*24*3600,10)
# constant values
SOC_Nor = 1
TRooAirSet = 273.15 + 25

## read results
# -------------------------------------------------------------------------
# ----------------------------------------------------------------------------
## PLR = 0.50
# normal operation

#**** critical equipment: AHU + Pumps
#*************************
nameResCriPum050 = "FC_Pump_PLR050_RDC.mat"
resCriPum050 = Reader(path+nameResCriPum050,"dymola")
tim_CriPum050, SOC_CriPum050 = resCriPum050.values("bat.SOC")
tim_CriPum050, TRooAir_CriPum050 = resCriPum050.values("roo.TRooAir")
tim_CriPum050, bat_CriPum050 = resCriPum050.values("bat.terminal.i[1]")
tim_CriPum050, pv_CriPum050 = resCriPum050.values("pv.terminal.i[1]")
tim_CriPum050, gri_CriPum050 = resCriPum050.values("gri.terminal.i[1]")

# interplote to every minute
int = interpolate.interp1d(tim_CriPum050,SOC_CriPum050, kind='linear')
SOC_CriPum050 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum050,TRooAir_CriPum050, kind='linear')
TRooAir_CriPum050 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum050,bat_CriPum050, kind='linear')
bat_CriPum050 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum050,pv_CriPum050, kind='linear')
pv_CriPum050 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum050,gri_CriPum050, kind='linear')
gri_CriPum050 = int(tim_Nor)

print gri_CriPum050
gri_CriPum050[30:121]=0
print gri_CriPum050

### ------------------------------------------------------------------------------
###           setup time axis
### ------------------------------------------------------------------------------
simStart = pd.Timestamp(2018,1,1,0,0,0)
simEnd = pd.Timestamp(2018,12,31,23,59,0)

datetimelist = pd.date_range(simStart,simEnd,freq = '10s')
timeindex = datetimelist[np.logical_and(t>=ts,t<=te)]
timeEvent = datetimelist[np.logical_and(t>=tse*60,t<=tee*60)]
print timeEvent
# sticks every 5 minutes
a = timeindex.time[np.arange(30,len(timeindex.time)+1,30)]
print a

####-----------------------------------------------------------------------------
##              start to plot
#### -----------------------------------------------------------------------------
linestyles = ['-','-.','--']

### -------------------------------------------------------
###               plot for PLR = 0.50
###---------------------------------------------------------
fig,ax=plt.subplots(figsize=(10,6))
plt.subplot()
plt.plot(timeindex.time,gri_CriPum050,color = 'k',linestyle=linestyles[0],label='Gird')
plt.plot(timeindex.time,pv_CriPum050,color = 'k',linestyle=linestyles[1],label='PV')
plt.plot(timeindex.time,bat_CriPum050,color = 'k',linestyle=linestyles[2],label='UPS')
plt.grid(True,linestyle=':',linewidth=0.5)
plt.ylabel('Current[A]')
plt.xticks(a,fontsize=12,rotation='30')
plt.legend(loc=2)
plt.xlabel ('Time')
plt.ylim([-3000,1000])
plt.yticks(np.arange(-3000,1001,500))
plt.savefig('FCPLR050-RDC.svg')
plt.savefig('FCPLR050-RDC.pdf')
plt.savefig('FCPLR050-RDC.eps')
plt.show()