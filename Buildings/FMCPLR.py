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

# change the working directory
path = "c:/Users/fuya744/github/modelica-buildings/Buildings/"
os.chdir(path)

# set up interested period (outage in FC mode)
ts = (5150*60-5)*60
te = (5150.5*60+5)*60
tim_Nor = np.arange(ts,te+1,60)

# constant values
SOC_Nor = 1
TRooAirSet = 273.15 + 25

## read results
# -------------------------------------------------------------------------
### PLR = 1
# -------------------------
#***** normal operation
#*************************
nameResNor = "PLR100" +".mat"
resNor = Reader(path+nameResNor,"dymola")
tim_Nor_raw, TRooAir_Nor_raw = resNor.values("roo.TRooAir")
# interplote to every minute
t = np.arange(0,365*24*3600,60)
print len(t)
print tim_Nor_raw
int = interpolate.interp1d(tim_Nor_raw,TRooAir_Nor_raw, kind='linear')
TRooAir_Nor = int(t)[np.logical_and(t>=ts,t<=te)]
print len(TRooAir_Nor)
print len(tim_Nor)

#**** Critical equipment: AHU
#*************************
nameResCriAHU100 = "FMC_AHU_PLR1.mat"
resCriAHU100 = Reader(path+nameResCriAHU100,"dymola")
tim_CriAHU100, SOC_CriAHU100 = resCriAHU100.values("bat.SOC")
tim_CriAHU100, TRooAir_CriAHU100 = resCriAHU100.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriAHU100,SOC_CriAHU100, kind='linear')
SOC_CriAHU100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriAHU100,TRooAir_CriAHU100, kind='linear')
TRooAir_CriAHU100 = int(tim_Nor)

#**** critical equipment: AHU + Pumps
#*************************
nameResCriPum100 = "FMC_Pump_PLR1.mat"
resCriPum100 = Reader(path+nameResCriPum100,"dymola")
tim_CriPum100, SOC_CriPum100 = resCriPum100.values("bat.SOC")
tim_CriPum100, TRooAir_CriPum100 = resCriPum100.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriPum100,SOC_CriPum100, kind='linear')
SOC_CriPum100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum100,TRooAir_CriPum100, kind='linear')
TRooAir_CriPum100 = int(tim_Nor)

#**** critical equipment: Pumps to AHU
#*************************
nameResCriPumAHU100 = "FMC_PumpToAHU_PLR1.mat"
resCriPumAHU100 = Reader(path+nameResCriPumAHU100,"dymola")
tim_CriPumAHU100, SOC_CriPumAHU100 = resCriPumAHU100.values("bat.SOC")
tim_CriPumAHU100, TRooAir_CriPumAHU100 = resCriPumAHU100.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriPumAHU100,SOC_CriPumAHU100, kind='linear')
SOC_CriPumAHU100 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPumAHU100,TRooAir_CriPumAHU100, kind='linear')
TRooAir_CriPumAHU100 = int(tim_Nor)
# ----------------------------------------------------------------------------
## PLR = 0.75
# normal operation

#**** Critical equipment: AHU
#*************************
nameResCriAHU075 = "FMC_AHU_PLR075.mat"
resCriAHU075 = Reader(path+nameResCriAHU075,"dymola")
tim_CriAHU075, SOC_CriAHU075 = resCriAHU075.values("bat.SOC")
tim_CriAHU075, TRooAir_CriAHU075 = resCriAHU075.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriAHU075,SOC_CriAHU075, kind='linear')
SOC_CriAHU075 = int(tim_Nor)
int = interpolate.interp1d(tim_CriAHU075,TRooAir_CriAHU075, kind='linear')
TRooAir_CriAHU075 = int(tim_Nor)

#**** critical equipment: AHU + Pumps
#*************************
nameResCriPum075 = "FMC_Pump_PLR075.mat"
resCriPum075 = Reader(path+nameResCriPum075,"dymola")
tim_CriPum075, SOC_CriPum075 = resCriPum075.values("bat.SOC")
tim_CriPum075, TRooAir_CriPum075 = resCriPum075.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriPum075,SOC_CriPum075, kind='linear')
SOC_CriPum075 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum075,TRooAir_CriPum075, kind='linear')
TRooAir_CriPum075 = int(tim_Nor)

#**** critical equipment: Pumps to AHU
#*************************
nameResCriPumAHU075 = "FMC_PumpToAHU_PLR075.mat"
resCriPumAHU075 = Reader(path+nameResCriPumAHU075,"dymola")
tim_CriPumAHU075, SOC_CriPumAHU075 = resCriPumAHU075.values("bat.SOC")
tim_CriPumAHU075, TRooAir_CriPumAHU075 = resCriPumAHU075.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriPumAHU075,SOC_CriPumAHU075, kind='linear')
SOC_CriPumAHU075 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPumAHU075,TRooAir_CriPumAHU075, kind='linear')
TRooAir_CriPumAHU075 = int(tim_Nor)
# ----------------------------------------------------------------------------
## PLR = 0.50
# normal operation

#**** Critical equipment: AHU
#*************************
nameResCriAHU050 = "FMC_AHU_PLR050.mat"
resCriAHU050 = Reader(path+nameResCriAHU050,"dymola")
tim_CriAHU050, SOC_CriAHU050 = resCriAHU050.values("bat.SOC")
tim_CriAHU050, TRooAir_CriAHU050 = resCriAHU050.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriAHU050,SOC_CriAHU050, kind='linear')
SOC_CriAHU050 = int(tim_Nor)
int = interpolate.interp1d(tim_CriAHU050,TRooAir_CriAHU050, kind='linear')
TRooAir_CriAHU050 = int(tim_Nor)

#**** critical equipment: AHU + Pumps
#*************************
nameResCriPum050 = "FMC_Pump_PLR050.mat"
resCriPum050 = Reader(path+nameResCriPum050,"dymola")
tim_CriPum050, SOC_CriPum050 = resCriPum050.values("bat.SOC")
tim_CriPum050, TRooAir_CriPum050 = resCriPum050.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriPum050,SOC_CriPum050, kind='linear')
SOC_CriPum050 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum050,TRooAir_CriPum050, kind='linear')
TRooAir_CriPum050 = int(tim_Nor)

#**** critical equipment: Pumps to AHU
#*************************
nameResCriPumAHU050 = "FMC_PumpToAHU_PLR050.mat"
resCriPumAHU050 = Reader(path+nameResCriPumAHU050,"dymola")
tim_CriPumAHU050, SOC_CriPumAHU050 = resCriPumAHU050.values("bat.SOC")
tim_CriPumAHU050, TRooAir_CriPumAHU050 = resCriPumAHU050.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriPumAHU050,SOC_CriPumAHU050, kind='linear')
SOC_CriPumAHU050 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPumAHU050,TRooAir_CriPumAHU050, kind='linear')
TRooAir_CriPumAHU050 = int(tim_Nor)


# ----------------------------------------------------------------------------
## PLR = 0.25
# normal operation

#**** Critical equipment: AHU
#*************************
nameResCriAHU025 = "FMC_AHU_PLR025.mat"
resCriAHU025 = Reader(path+nameResCriAHU025,"dymola")
tim_CriAHU025, SOC_CriAHU025 = resCriAHU025.values("bat.SOC")
tim_CriAHU025, TRooAir_CriAHU025 = resCriAHU025.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriAHU025,SOC_CriAHU025, kind='linear')
SOC_CriAHU025 = int(tim_Nor)
int = interpolate.interp1d(tim_CriAHU025,TRooAir_CriAHU025, kind='linear')
TRooAir_CriAHU025 = int(tim_Nor)

#**** critical equipment: AHU + Pumps
#*************************
nameResCriPum025 = "FMC_Pump_PLR025.mat"
resCriPum025 = Reader(path+nameResCriPum025,"dymola")
tim_CriPum025, SOC_CriPum025 = resCriPum025.values("bat.SOC")
tim_CriPum025, TRooAir_CriPum025 = resCriPum025.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriPum025,SOC_CriPum025, kind='linear')
SOC_CriPum025 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPum025,TRooAir_CriPum025, kind='linear')
TRooAir_CriPum025 = int(tim_Nor)

#**** critical equipment: Pumps to AHU
#*************************
nameResCriPumAHU025 = "FMC_PumpToAHU_PLR025.mat"
resCriPumAHU025 = Reader(path+nameResCriPumAHU025,"dymola")
tim_CriPumAHU025, SOC_CriPumAHU025 = resCriPumAHU025.values("bat.SOC")
tim_CriPumAHU025, TRooAir_CriPumAHU025 = resCriPumAHU025.values("roo.TRooAir")
# interplote to every minute
int = interpolate.interp1d(tim_CriPumAHU025,SOC_CriPumAHU025, kind='linear')
SOC_CriPumAHU025 = int(tim_Nor)
int = interpolate.interp1d(tim_CriPumAHU025,TRooAir_CriPumAHU025, kind='linear')
TRooAir_CriPumAHU025 = int(tim_Nor)
### ------------------------------------------------------------------------------
###           setup time axis
### ------------------------------------------------------------------------------
simStart = pd.Timestamp(2018,1,1,0,0,0)
simEnd = pd.Timestamp(2018,12,31,23,59,0)

datetimelist = pd.date_range(simStart,simEnd,freq = 'T')
print datetimelist
print len(datetimelist)
timeindex = datetimelist[np.logical_and(t>=ts,t<=te)]
print timeindex
print timeindex.time
a = timeindex.time[np.arange(5,len(timeindex.time)+1,10)]
print a

####-----------------------------------------------------------------------------
##              start to plot
#### -----------------------------------------------------------------------------
fig,ax=plt.subplots(2,1,figsize=(8,6))
plt.subplot(211)
plt.plot(timeindex.time,TRooAir_CriAHU100-273.15,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,TRooAir_CriPum100-273.15,'k-..',markersize=8,alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,TRooAir_CriPumAHU100-273.15,'k:')
plt.plot(timeindex.time,TRooAir_Nor-273.15,'k-',alpha=0.8)

plt.ylabel('Room Temperature[$\circ$C]')
plt.xticks(a,[]) # set location and ticklabel(none)
plt.xlabel('')
plt.grid(True)
plt.legend(["CE: AHU","CE: AHU+Pump","C3","Normal"])

plt.subplot(212)
plt.plot(timeindex.time,SOC_CriAHU100,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,SOC_CriPum100,'k-..',markersize=8,alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,SOC_CriPumAHU100,'k:')
plt.plot(timeindex.time,SOC_Nor*np.ones(len(timeindex)),'k-',alpha=0.8)
plt.grid(True)
plt.ylabel('SOC')
plt.xticks(a)
plt.xlabel ('Time')
plt.legend(["CE: AHU","CE: AHU+Pump","C3","Normal"],loc=3)
plt.savefig('FMCPLR100.svg')
plt.savefig('FMCPLR100.eps')
plt.show()

### -------------------------------------------------------
###               plot for PLR = 0.75
###---------------------------------------------------------
fig,ax=plt.subplots(2,1,figsize=(8,6))
plt.subplot(211)
plt.plot(timeindex.time,TRooAir_CriAHU075-273.15,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,TRooAir_CriPum075-273.15,'k-..',markersize=8,alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,TRooAir_CriPumAHU075-273.15,'k:')
plt.plot(timeindex.time,TRooAir_Nor-273.15,'k-',alpha=0.8)

plt.ylabel('Room Temperature[$\circ$C]')
plt.xticks(a,[]) # set location and ticklabel(none)
plt.xlabel('')
plt.grid(True)
plt.legend(["CE: AHU","CE: AHU+Pump","C3","Normal"])

plt.subplot(212)
plt.plot(timeindex.time,SOC_CriAHU075,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,SOC_CriPum075,'k-..',markersize=8,alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,SOC_CriPumAHU075,'k:')
plt.plot(timeindex.time,SOC_Nor*np.ones(len(timeindex)),'k-',alpha=0.8)
plt.grid(True)
plt.ylabel('SOC')
plt.xticks(a)
plt.xlabel ('Time')
plt.legend(["CE: AHU","CE: AHU+Pump","C3","Normal"],loc=3)
plt.savefig('FMCPLR075.svg')
plt.savefig('FMCPLR075.eps')
plt.show()

### -------------------------------------------------------
###               plot for PLR = 0.50
###---------------------------------------------------------
fig,ax=plt.subplots(2,1,figsize=(8,6))
plt.subplot(211)
plt.plot(timeindex.time,TRooAir_CriAHU050-273.15,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,TRooAir_CriPum050-273.15,'k-..',markersize=8,alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,TRooAir_CriPumAHU050-273.15,'k:')
plt.plot(timeindex.time,TRooAir_Nor-273.15,'k-',alpha=0.8)

plt.ylabel('Room Temperature[$\circ$C]')
plt.xticks(a,[]) # set location and ticklabel(none)
plt.xlabel('')
plt.grid(True)
plt.legend(["CE: AHU","CE: AHU+Pump","C3","Normal"])

plt.subplot(212)
plt.plot(timeindex.time,SOC_CriAHU050,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,SOC_CriPum050,'k-..',markersize=8,alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,SOC_CriPumAHU050,'k:')
plt.plot(timeindex.time,SOC_Nor*np.ones(len(timeindex)),'k-',alpha=0.8)
plt.grid(True)
plt.ylabel('SOC')
plt.xticks(a)
plt.xlabel ('Time')
plt.legend(["CE: AHU","CE: AHU+Pump","C3","Normal"],loc=3)
plt.savefig('FMCPLR050.svg')
plt.savefig('FMCPLR050.eps')
plt.show()

### -------------------------------------------------------
###               plot for PLR = 0.25
###---------------------------------------------------------
fig,ax=plt.subplots(2,1,figsize=(8,6))
plt.subplot(211)
plt.plot(timeindex.time,TRooAir_CriAHU025-273.15,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,TRooAir_CriPum025-273.15,'k-..',markersize=8,alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,TRooAir_CriPumAHU025-273.15,'k:')
plt.plot(timeindex.time,TRooAir_Nor-273.15,'k-',alpha=0.8)

plt.ylabel('Room Temperature[$\circ$C]')
plt.xticks(a,[]) # set location and ticklabel(none)
plt.xlabel('')
plt.grid(True)
plt.legend(["CE: AHU","CE: AHU+Pump","C3","Normal"])

plt.subplot(212)
plt.plot(timeindex.time,SOC_CriAHU025,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,SOC_CriPum025,'k-..',markersize=8,alpha=0.8,markevery=range(0,len(timeindex),3))
plt.plot(timeindex.time,SOC_CriPumAHU025,'k:')
plt.plot(timeindex.time,SOC_Nor*np.ones(len(timeindex)),'k-',alpha=0.8)
plt.grid(True)
plt.ylabel('SOC')
plt.xticks(a)
plt.xlabel ('Time')
plt.legend(["CE: AHU","CE: AHU+Pump","C3","Normal"],loc=3)
plt.savefig('FMCPLR025.svg')
plt.savefig('FMCPLR025.eps')
plt.show()