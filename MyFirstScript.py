#! /usr/bin/env python

'''
ABOUT:
This is a program to read in the Gordon et  al. 2005
Figure 16 information in order to recreate the plot.

DEPENDS:
Python 2.7.1

AUTHOR:
T.S. Le Blanc for STScI, 2012

HISTORY:
2012, Aug:	Initial script

USE:
python MyFirstScript.py
'''

import numpy as np
import pylab as pl

infile = 'Gordon2005_Fig16.txt'
outfile = 'fig16_log.pdf'

slope, ran_slope_unc, corr_slope_unc, both_slope_unc, \
	eqn_slope_unc = np.loadtxt(infile, 
	usecols = (0,1,2,3,4), unpack=True)

pl.loglog(slope, ran_slope_unc, 'b--', slope, corr_slope_unc, 'r:', \
	slope, both_slope_unc, 'g-', slope, eqn_slope_unc, 'm-.', linewidth=2)
pl.legend(('Random Uncertainty','Correlated Uncertainty','Both','Equation'), \
	'best')
pl.xlabel('Slope [e-/s]')
pl.ylabel('Slope Unc. [e-/s]')
pl.savefig('fig16_log.pdf')
pl.clf()