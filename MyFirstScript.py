#! /usr/bin/env python

#Header

__author__ = 'T.S. Le Blanc'
__version__ = 0.2

import numpy as np
import pylab as pl

def mkplot(outfile,xx,yy1,yy2,yy3,yy4,ylab='Slope Unc. [e-/s]'):
	pl.loglog(xx, yy1, 'b--', xx, yy2, 'r:', xx, yy3, 'g-', xx, \
		yy4, 'm-.', linewidth=3)
	pl.legend(('Random Uncertainty','Correlated Uncertainty', \
		'Both','Equation'), 'best')
	pl.xlabel('Slope [e-/s]')
	pl.ylabel(ylab)
	pl.savefig(outfile)
	pl.clf()
	print 'File saved to: ', outfile
	return

if __name__=='__main__':
	infile = 'Gordon2005_Fig16.txt'
	slope_outfile = 'fig16_slope.pdf'
	yint_outfile = 'fig16_yint.pdf'
	
	slope, ran_slope_unc, corr_slope_unc, both_slope_unc, \
	  eqn_slope_unc, ran_yint_unc, corr_yint_unc, both_yint_unc, \
	  eqn_yint_unc = np.loadtxt(infile, unpack=True)
		
	mkplot(slope_outfile, slope, ran_slope_unc, corr_slope_unc, \
	  both_slope_unc, eqn_slope_unc)
	mkplot(yint_outfile, slope, ran_yint_unc, corr_yint_unc, \
	  both_yint_unc, eqn_yint_unc, ylab='Y-Intercept Unc. [e-]')
