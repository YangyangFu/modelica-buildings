# author: Yangyang Fu
# plot simulation results to compare different cases

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
rcParams['font.size'] = 14

# change the working directory
path = "C:/Github/modelica-buildings/Buildings/"
os.chdir(path)

# set up interested period (outage in FC mode)
ts = (8510*60-5)*60
te = (8510.5*60+5)*60
tim_Nor = np.arange(ts,te+1,60)


## read results
# -------------------------------------------------------------------------
### PLR = 1
# -------------------------
#***** normal operation
#*************************
name = "VariableSpeedEnergyPlusPartLoad" +".mat"
res = Reader(path+name,"dymola")
time,Tout_M = res.values("varSpeDX.eva.vol.T")
time,Tout_E = res.values("TOutEPlu.y")

time,Xout_M = res.values("varSpeDX.eva.vol.Xi[1]")
time,Xout_E = res.values("XEvaOutEPluMod.y")

time,TConOut_M = res.values("TConOut.T")
time,TConOut_E = res.values("TCOutEPlu.y")

time,Q_M = res.values("varSpeDX.watCooCon.Q_flow")
time,Q_E = res.values("Q_flowConEPlu.y")

time,P_M = res.values("varSpeDX.P")
time,P_E = res.values("PEPlu.y")

print Q_M
print time
# interplote to every minute
t = np.arange(0,24*3600+1,60)
#print len(t)

int = interpolate.interp1d(time,Tout_M, kind='linear')
Tout_M = int(t)
int = interpolate.interp1d(time,Tout_E, kind='linear')
Tout_E = int(t)
print t.shape
print Tout_M.shape

int = interpolate.interp1d(time,Xout_M, kind='linear')
Xout_M = int(t)
int = interpolate.interp1d(time,Xout_E, kind='linear')
Xout_E = int(t)

int = interpolate.interp1d(time,Q_M, kind='linear')
Q_M = int(t)
int = interpolate.interp1d(time,Q_E, kind='linear')
Q_E = int(t)

int = interpolate.interp1d(time,P_M, kind='linear')
P_M = int(t)
int = interpolate.interp1d(time,P_E, kind='linear')
P_E = int(t)
### -------------------------------------------------------
###               plot 
###---------------------------------------------------------
print t

simStart = pd.Timestamp(2018,1,1,0,0,0)
simEnd = pd.Timestamp(2018,1,2,0,0,0)
datetimelist = pd.date_range(simStart,simEnd,freq = 'H')
print datetimelist.time

fig = plt.figure(figsize=(10,6))
plt.plot(t,Tout_E,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=1.0/12)
plt.plot(t,Tout_M-273.15,'k-..',markersize=8,alpha=0.8,markevery=1.0/12)
plt.grid(True)
plt.ylabel('Temperature [$\circ$C]')
plt.ylim([5,30])
plt.xticks(np.arange(0,25,3)*3600,datetimelist.time[np.arange(0,25,3)], rotation=20,fontsize=12)
plt.xlabel ('Time')
plt.legend(["EnergyPlus Model","Modelica Model"],loc=5)
plt.savefig('Figure7-1-Tout.eps')
plt.savefig('Figure7-1-Tout.svg')
plt.show()
plt.close()


fig = plt.figure(figsize=(10,6))
plt.plot(t,Xout_E,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=1.0/12)
plt.plot(t,Xout_M,'k-..',markersize=8,alpha=0.8,markevery=1.0/12)
plt.grid(True)
plt.ylabel('Humidity [kg/kg]')
plt.ylim([0.002,0.012])
plt.xticks(np.arange(0,25,3)*3600,datetimelist.time[np.arange(0,25,3)], rotation=20,fontsize=12)
plt.xlabel ('Time')
plt.legend(["EnergyPlus Model","Modelica Model"],loc=5)
plt.savefig("Figure7-2-Xout.eps")
plt.savefig("Figure7-2-Xout.svg")
plt.show()

fig = plt.figure(figsize=(10,6))
plt.plot(t,Q_E,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=1./12)
plt.plot(t,Q_M,'k-..',markersize=8,alpha=0.8,markevery=1./12)
plt.grid(True)
plt.ylabel('Heat Rate [W]')
plt.ylim([-2000,8000])
plt.xticks(np.arange(0,25,3)*3600,datetimelist.time[np.arange(0,25,3)], rotation=20,fontsize=12)
plt.xlabel ('Time')
plt.legend(["EnergyPlus Model","Modelica Model"],loc=5)
plt.savefig("Figure7-3-Q.eps")
plt.savefig("Figure7-3-Q.svg")
plt.show()

fig = plt.figure(figsize=(10,6))
plt.plot(t,P_E,'k--o',markersize=6,markeredgecolor = 'k',
         markeredgewidth=1,markerfacecolor="none",alpha=0.8,markevery=1./12)
plt.plot(t,P_M,'k-..',markersize=8,alpha=0.8,markevery=1./12)
plt.grid(True)
plt.ylabel('Power [W]')
plt.ylim([-200,1200])
plt.xticks(np.arange(0,25,3)*3600,datetimelist.time[np.arange(0,25,3)], rotation=20,fontsize=12)
plt.xlabel ('Time')
plt.legend(["EnergyPlus Model","Modelica Model"],loc=5)
plt.savefig("Figure7-4-P.eps")
plt.savefig("Figure7-4-P.svg")
plt.show()
