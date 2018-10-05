# pue plot for different PLR
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
# PLR =1
nam100= "PLR100" +".mat"
res100 = Reader(path+nam100,"dymola")
EIT100 = -res100.integral("powIT.y")
ETot100 = res100.integral("gri.P.real")
pue100 = ETot100/EIT100

#PLR = 0.75
nam075= "PLR075" +".mat"
res075 = Reader(path+nam075,"dymola")
EIT075 = -res075.integral("powIT.y")
ETot075 = res075.integral("gri.P.real")
pue075 = ETot075/EIT075

# PLR = 0.5
nam050= "PLR050" +".mat"
res050 = Reader(path+nam050,"dymola")
EIT050 = -res050.integral("powIT.y")
ETot050 = res050.integral("gri.P.real")
pue050 = ETot050/EIT050

# PLR = 0.25
nam025= "PLR025" +".mat"
res025 = Reader(path+nam025,"dymola")
EIT025 = -res025.integral("powIT.y")
ETot025 = res025.integral("gri.P.real")
pue025 = ETot025/EIT025

print pue100 
print pue075 
print pue050 
print pue025