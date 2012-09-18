#! /usr/bin/env python
#Header

__author__ = 'T.S. Le Blanc'
__version__ = 0.1

'''
ABOUT:
Automate the daofind and phot tasks for the F606W and F814W
images for the Photometry training exercise. The images used
are from the training (2 of them); thus this daofind taks is
executed twice. I've also added the ability to remove
previously created lists (and create them based on the input
file), as well as added a few parameters for the task itself.
'''

#load needed packages
import pyraf, os, glob
from pyraf import iraf
from iraf import noao, digiphot, daophot

#generate list of all fits files in current directory
file_list = glob.glob('*_cts.fits')
print file_list

#loops through all FITS files
for file in file_list:
    #look for old files, and remove if they exist
    file_query = os.access('starlist_' + file.replace('.fits', ''), \
      os.R_OK)
    if file_query == True:
        os.remove('starlist_' + file.replace('.fits', ''))
    
    #execute daofind on one image
    print 'DAOFind on image ', file
    outfile = 'starlist_' + file.replace('.fits', '')
    iraf.daofind.unlearn()
    iraf.daofind(
        image = file,
        output = outfile,
        fwhmpsf = 3,
        readnoise = 7.6424,
        itime = 7024.,
        threshold = 4.0,
        interactive = 'no',
        verify = 'no') 