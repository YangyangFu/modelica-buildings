## -*- coding: utf-8 -*-
#"""
#Author: Yangyang Fu
#Email: yangyang.fu@colorado.edu
#Date: 11/5/2018
#
#"""
# import from future to make Python2 behave like Python3
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals
from future import standard_library
standard_library.install_aliases()
from builtins import *
from io import open
# end of from future import

from multiprocessing import Pool
from buildingspy.simulate.Simulator import Simulator
from buildingspy.io.outputfile import Reader
import pandas as pd
import datetime as dt
import scipy.interpolate as interpolate
import matplotlib.pyplot as plt
import numpy as np
import os
# plot
from matplotlib import rcParams
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['Times New Roman']
rcParams['font.size'] = 20
rcParams['lines.linewidth'] = 1

## Get the current package path of the script
df = pd.read_csv('results.csv',index_col=[0,1])
df=df.sort_index(level=0)/60
## fill nan with 4 hours
df = df.fillna(240)

print(df.index.levels)
pv = df.index.levels[1]
plr = df.index.levels[0]

df1 = df.loc[0.25].values
print(df1)
df2 = df.loc[0.50].values
df3 = df.loc[0.75].values
df4 = df.loc[1.00].values

print(pv)
print(plr)
plt.figure(figsize=(9,6))
plt.plot(pv,df1,'k-',label='PLR=0.25',marker='o')
plt.plot(pv,df2,'k-',label='PLR=0.50',marker='v')
plt.plot(pv,df3,'k-',label='PLR=0.75',marker='p')
plt.plot(pv,df4,'k-',label='PLR=1.00',marker='^')
plt.legend(fontsize=13)
plt.xlabel('PV System Size Factor')
plt.ylabel('Time (min)')
plt.savefig('result.eps')
plt.show()
