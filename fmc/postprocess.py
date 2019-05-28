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

## Get the current package path of the script
path = os.path.dirname(os.path.abspath(__file__))

## Set simulation parameters
startTime = 150*24*3600
stopTime = 215*24*3600

# set up interested period (outage in FC mode)
tse = 5150*60 #minute
tee = 5154*60
ts = (tse-5)*60 # second
te = tee*60
tim_Nor = np.arange(ts,te+1,1)
t = np.arange(0,365*24*3600,1)

## Read simulation results
indArr = []
dtAll = pd.DataFrame()
# main loop for exhaustive search
# sweeping parameters
case = 'FMC'
scaPV = [0,0.2,0.4,0.6,0.8]
PLR = [0.25,0.5,0.75,1.0]
for i in range(len(scaPV)):
	for j in range(len(PLR)):
		# need determine the model
		# name the model based on cases
		modelName = case + '_pv'+str(scaPV[i])+'_plr'+str(PLR[j])
		model = case+'_Pump_RDC_Time'
		res = Reader(modelName+'/'+model+'.mat','dymola')
		ind = np.array([scaPV[i],PLR[j]])
		indArr.append(ind)
		# read results
		tim,soc = res.values('bat.SOC')
		# need post-process results
		int = interpolate.interp1d(tim,soc,kind='linear')
		soc = int(tim_Nor)
		print(soc)
		# find time instance when soc=0
		true = np.array(soc)>0.011
		print(true)
		# find the first False which means the battery is depleted
		if all(true):
			dt = float('nan')
		else:
			falseIndex = list(true).index(False)
			depTim=falseIndex
			print ("================Depelte at:",depTim)
			dt = depTim - 300
		dic_dt = {'pv':scaPV[i],'plr':PLR[j],'dt':dt}
		df_dt = pd.DataFrame(dic_dt,index=[modelName])
		
		dtAll = dtAll.append(df_dt)

dtAll.to_csv('results.csv')

## multiple index array
indArr = np.array(indArr).transpose()
print(indArr)			
tup = list(zip(*indArr))
print(tup)

mulIndex = pd.MultiIndex.from_tuples(tup, names = ['pv','plr'])
		
results = dtAll.set_index(mulIndex)
results.to_csv('results.csv')		


		
