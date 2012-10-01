#! /usr/bin/env python

#Header

__author__ = 'T.S. Le Blanc'
__version__ = 0.1

'''
ABOUT:
This script will be used to demonstrate how IRAF/PyRAF tasks can
be executed in Python.

'''

#load needed packages
import pyraf, os, glob
from pyraf import iraf
from iraf import noao, digiphot, daophot

#generate list of all fits files in current directory
file_list = glob.glob('*_ima.fits')
print file_list

#loops through all FITS files
for file in file_list:
    #look for old files, and remove if they exist
    file_query = os.access(file + '1.coo.1', os.R_OK)
    if file_query == True:
        os.remove(file + '1.coo.1')

    #execute daofind on one image
    iraf.daofind.unlearn()
    iraf.daofind(
        image = file + '[1]',
        output = 'star_catalogue',
        interactive = 'no',
        verify = 'no')