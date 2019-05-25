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
startTime = 300*24*3600
stopTime = 365*24*3600
solver = "dassl"
tolerance = 0.0001

## Change system parameters: 
def simulateCase(s):
	""" Set common parameters and run a simulation.

	:param s: A simulator object.

	"""
	s.setStopTime(stopTime)
	s.setStartTime(startTime)
	#s.setResultFile(resultName)
	s.setSolver(solver)
	s.setTolerance(tolerance)
	s.printModelAndTime()
	s.simulate()
	#s.translate()
	#s.simulate_translated()

# main loop

def main():
	""" Main method that configures and runs all simulations
	"""
	import shutil
	# Build list of cases to run
	li = []
	# set output directory -- very important to reasonably utilize the disk
	outDirectory = os.path.dirname(path)
	# read mo file and change the weather file in the source code for each case	
	

	# main loop for exhaustive search
	# sweeping parameters
	case = 'FC'
	scaPV = [0,0.2,0.4,0.6,0.8,1.0]
	PLR = [0.25,0.5,0.75,1.0]
	for i in range(len(scaPV)):
		for j in range(len(PLR)):
			# need determine the model
			# name the model based on cases
			modelName = case + str(scaPV[i])+str(PLR[j])
			model = "Buildings.Applications.DataCenters.ChillerCooled.Paper.Case4.FC_Pump_RDC_Time"
			# simulator in buildingspy
			s = Simulator(model, "dymola", outDirectory+'/'+modelName)	
			#s.addParameters({'weaFilNam': weaFil})
			s.addParameters({'scaPV':scaPV[i]})
			s.addParameters({'PLR':PLR[j]})
			# collect all possible cases in a pool
			li.append(s)

	# Run all cases in parallel
	po = Pool(processes=4)
	po.map(simulateCase, li)


# Main function
if __name__ == '__main__':
    main()

## Read simulation results
