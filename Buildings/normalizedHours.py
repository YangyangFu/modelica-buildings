# author: Yangyang Fu
# plot simulation results to compare normalized hours at different PLRs
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
rcParams['font.size'] = 16
rcParams['lines.linewidth'] = 1

# change the working directory
path = "c:/github/modelica-buildings/Buildings/"
os.chdir(path)

# set up interested period (outage in FC mode)
# constant values

## read results
# -------------------------------------------------------------------------
### PLR = 1
# interplote to every minute
t = np.arange(0,365*24*3600,60)

#*************************
name1 = "PLR100.mat"
res1 = Reader(path+name1,"dymola")
t1, cooMod1 = res1.values("cooModCon.y")
fc1 = np.zeros([len(cooMod1)])
print fc1 

pmc1 = np.zeros([len(cooMod1)])
fmc1 = np.zeros([len(cooMod1)])
for i in range(len(cooMod1)):
	if cooMod1[i]<1.5:
		fc1[i] = 1
	elif np.logical_and(cooMod1[i]>1.5,cooMod1[i]<2.5):
		pmc1[i] = 1
	elif cooMod1[i]>2.5:
		fmc1[i] = 1

print len(t1)
print len(fc1)
		
# interplote to every minute
int = interpolate.interp1d(t1, fc1, kind='linear')
fc1 = int(t)
int = interpolate.interp1d(t1, pmc1, kind='linear')
pmc1 = int(t)
int = interpolate.interp1d(t1, fmc1, kind='linear')
fmc1 = int(t)
fc1_tim = sum(fc1)/60
pmc1_tim = sum(pmc1)/60
fmc1_tim = sum(fmc1)/60


### PLR = 0.75
name2 = "PLR075.mat"
res2 = Reader(path+name2,"dymola")
t2, cooMod2 = res2.values("cooModCon.y")
fc2 = np.zeros([len(cooMod2)])
pmc2 = np.zeros([len(cooMod2)])
fmc2 = np.zeros([len(cooMod2)])
for i in range(len(cooMod2)):
	if cooMod2[i]<1.5:
		fc2[i] = 1
	elif np.logical_and(cooMod2[i]>1.5,cooMod2[i]<2.5):
		pmc2[i] = 1
	elif cooMod2[i]>2.5:
		fmc2[i] = 1
		
# interplote to every minute
int = interpolate.interp1d(t2, fc2, kind='linear')
fc2 = int(t)
int = interpolate.interp1d(t2, pmc2, kind='linear')
pmc2 = int(t)
int = interpolate.interp1d(t2, fmc2, kind='linear')
fmc2 = int(t)
fc2_tim = sum(fc2)/60
pmc2_tim = sum(pmc2)/60
fmc2_tim = sum(fmc2)/60


### PLR = 0.50
name3 = "PLR050.mat"
res3 = Reader(path+name3,"dymola")
t3, cooMod3 = res3.values("cooModCon.y")
fc3 = np.zeros([len(cooMod3)])
pmc3 = np.zeros([len(cooMod3)])
fmc3 = np.zeros([len(cooMod3)])
for i in range(len(cooMod3)):
	if cooMod3[i]<1.5:
		fc3[i] = 1
	elif np.logical_and(cooMod3[i]>1.5,cooMod3[i]<2.5):
		pmc3[i] = 1
	elif cooMod3[i]>2.5:
		fmc3[i] = 1
		
# interplote to every minute
int = interpolate.interp1d(t3, fc3, kind='linear')
fc3 = int(t)
int = interpolate.interp1d(t3, pmc3, kind='linear')
pmc3 = int(t)
int = interpolate.interp1d(t3, fmc3, kind='linear')
fmc3 = int(t)
fc3_tim = sum(fc3)/60
pmc3_tim = sum(pmc3)/60
fmc3_tim = sum(fmc3)/60

### PLR = 0.25
name4 = "PLR025.mat"
res4 = Reader(path+name4,"dymola")
t4, cooMod4 = res4.values("cooModCon.y")
fc4 = np.zeros([len(cooMod4)])
pmc4 = np.zeros([len(cooMod4)])
fmc4 = np.zeros([len(cooMod4)])
for i in range(len(cooMod4)):
	if cooMod4[i]<1.5:
		fc4[i] = 1
	elif np.logical_and(cooMod4[i]>1.5,cooMod4[i]<2.5):
		pmc4[i] = 1
	elif cooMod4[i]>2.5:
		fmc4[i] = 1
		
# interplote to every minute
int = interpolate.interp1d(t4, fc4, kind='linear')
fc4 = int(t)
int = interpolate.interp1d(t4, pmc4, kind='linear')
pmc4 = int(t)
int = interpolate.interp1d(t4, fmc4, kind='linear')
fmc4 = int(t)
fc4_tim = sum(fc4)/60
pmc4_tim = sum(pmc4)/60
fmc4_tim = sum(fmc4)/60

dic={'PLR100':[fc1_tim,pmc1_tim,fmc1_tim],'PLR075':[fc2_tim,pmc2_tim,fmc2_tim],'PLR050':[fc3_tim,pmc3_tim,fmc3_tim],'PLR025':[fc4_tim,pmc4_tim,fmc4_tim]}

df = pd.DataFrame(dic,index = ['FC','PMC','FMC'])
print df

df_norm = df/8760
print df_norm
df= df_norm.T

ax = plt.figure(figsize=(8, 6)).add_subplot(111)
df.plot(ax=ax, kind='bar', fill=False, stacked = True, legend=False)

bars = ax.patches
hatches = ''.join(h*len(df) for h in '\O/.')

for bar, hatch in zip(bars, hatches):
    bar.set_hatch(hatch)

ax.legend(loc='center right', bbox_to_anchor=(1, 1), ncol=4)

plt.xticks([0,1,2,3],[0.25,0.50,0.75,1.00], rotation=0)
#plt.ylim([0,1.2])
#plt.legend(loc=1, ncol=3)
ax.grid(axis='y',alpha=0.4)
plt.xlabel('PLR')
plt.ylabel('Normalized Hours')
plt.savefig('normalizedHours.svg')
plt.savefig('normalizedHours.eps')
plt.show()
