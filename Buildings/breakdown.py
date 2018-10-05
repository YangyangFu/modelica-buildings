# Breakdown chart
# Author: Yangyang Fu
# Email: yangyang.fu@colorado.edu
# Description:
#	This script aims to plot the electricity breakdown of the cooling system in design conditions for a data center.

import os
from buildingspy.io.outputfile import Reader
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy.interpolate as interpolate

from datetime import datetime

from matplotlib import rcParams
import seaborn as sns
sns.set(style='whitegrid')

#rcParams['font.family'] = 'sans-serif'
#rcParams['font.sans-serif'] = ['Times New Roman']
#rcParams['font.size'] = 20
#rcParams['lines.linewidth'] = 1

# change the working directory
path = "c:/github/modelica-buildings/Buildings/"
os.chdir(path)

# read results from Dymola
nameRes= "PLR100" +".mat"
res = Reader(path+nameRes,"dymola")
ECooTow = -res.integral("loaCooTow.P")
ECWPum = -res.integral("loaPowCW.P")
EChi = -res.integral("loaChi.P")
ECHWPum = -res.integral("loaPumCHW.P")
EAHU = -res.integral("loaAHU.P")

labels = 'Cooling Tower','Pump','Chiller','CRAH'
sizes = [ECooTow,ECWPum+ECHWPum,EChi,EAHU]
explode = (0,0.1,0,0)


colors = ['lightgray','lightgray','lightgray','lightgray']
fig1, ax1 = plt.subplots()
patches=plt.pie(sizes, labels=labels, colors = colors, wedgeprops = {'linewidth': 3},autopct='%1.1f%%', pctdistance=1.2, labeldistance=1.1, startangle=90)[0]
ax1.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.

print patches
print len(patches)
patches[0].set_hatch('/')
patches[1].set_hatch('-')
patches[2].set_hatch('\\')
patches[3].set_hatch('.')

plt.savefig(path+'breakdown.eps')
plt.savefig(path+'breakdown.svg')
plt.show()





