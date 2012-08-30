; Generate short- and long-cadence light curves from a Kepler search exercise form our
; Archive Training.
;
; Project:	Archive Training with Michael Wolfe
;
; Input:	Kepler light curve FITS files 
; Output:	Light Curves
; Coded by: Tommy LeBlanc
; Coded on: 10-Aug-2012

pro kepler_lc

  ;setup running directories
  r_dir='/Users/leblanc/Documents/'				;root directory
  w_dir='IDLWorkspace/Training/Archive/'				;working directory
  d_dir='Training_Documents/Archive/Kepler/'	;data directory

  ;set up the input files
  frmt = '(a,a,x,x,x,x,x,x,x,x)'
  filein = r_dir+d_dir+'kepler_header_keyword_values.txt'
  readcol, filein, f_name, object, format=frmt, /silent
  
  ;i1  = 'kplr002557430-2009201121230_slc.fits'
  ;i2  = 'kplr003526481-2009131105131_llc.fits'
  ;i3  = 'kplr004671547-2009259162342_slc.fits'
  ;i4  = 'kplr006192231-2009166043257_llc.fits'
  ;i5  = 'kplr007047141-2010265121752_llc.fits'
  ;i6  = 'kplr007940546-2009231120729_slc.fits'
  ;i7  = 'kplr008515227-2010265121752_llc.fits'
  ;i8  = 'kplr009116222-2009259160929_llc.fits'
  ;i9  = 'kplr010666510-2009259160929_llc.fits'
  ;i10 = 'kplr011551430-2009201121230_slc.fits'
  
  
  
  ;read in the fits file and extract the light curve info
  data_path = r_dir+d_dir  

  for ii=0, 9 do begin

    spect = mrdfits(data_path+f_name[ii], 1, hdr)

    ;extract the time and flux measurements
    time = spect.time
    flux = spect.sap_flux
  
    ;Output directory, and set up eps plotting device
    out_dir = r_dir+w_dir
    fname = 'lc_'				;prefix for filename
  
    sp, 0, 1, /eps, file=out_dir+fname+strtrim(string(ii),2), plotsize=[6,3,1.,1.]
  
    plotsym, 0, 0.25, /fill, color=cgcolor("Black")
    plot, time, flux, psym=8, xtit='Time(JD)', ytit='Flux(e-/s)', xcharsize=0.75, ycharsize=0.75, $
          tit=object[ii]
  
    ;close (e)ps plotting device, and return it to the x11 window plotting device
    device, /close
  endfor
  
  set_plot, 'x'
  
  print, "kepler_lc.pro script is done!"
end
