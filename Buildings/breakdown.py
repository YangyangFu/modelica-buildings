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
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['Times New Roman']
rcParams['font.size'] = 20
rcParams['lines.linewidth'] = 1

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

labels = 'Cooling Tower','Pump','Chiller','CRAH Fans'
sizes = [ECooTow,ECWPum+ECHWPum,EChi,EAHU]
explode = (0,0.1,0,0)

fig1, ax1 = plt.subplots()
ax1.pie(sizes, labels=labels, autopct='%1.1f%%',
        shadow=True, startangle=90)
ax1.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.

plt.savefig(path+'breakdown.eps')
plt.show()
