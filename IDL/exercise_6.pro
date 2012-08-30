;+
; :Routine Name: exercise_6
;
; :Description:
;    Script to complete tasks in Chapter 6 of the IDL training manual.
;
; :Parameters:
;
;
; :Input:
;
; :Output:
;
; ;Keywords:
;
;
; :Author:
; 	leblanc
;
; :Date:
; 	Aug 20, 2012
;-
pro exercise_6

  ;set working directory
  path = "/Users/leblanc/Documents/IDLWorkspace/Training/IDL/"
  
  
  ;************************** Hubble **************************
  ;set input file
  infile = path + "hubble.dat"
  
  ;read in the fake hubble data
  frmt = '(f,f)'
  readcol, infile, dist, vel, format = frmt
    
  ;estimate the coefficients a and b using linfit
  coeff = linfit(dist, vel, sigma=sig)

  print, "Hubble Constant = ", strtrim(string(coeff[1]),2), " km/(sec*Mpc)"
  print, coeff
  print, sig
  
  ;set the plotting device to PostScript
  set_plot, "ps"
  
  ;setup the output plot
  outfile = path+"Hubble.ps"
  
  ;define the position and size of the plot, units in centimeters. 
  page_height = 27.94
  page_width = 21.59
  plot_left = 3.
  plot_bottom = 4
  xsize = 15.
  ysize = 15.

  ;We open the PostScript device: 
  device, filename = outfile, $  
  xsize = page_width, ysize = page_height, $ 
  xoffset = 0, yoffset = 0, $ 
  scale_factor = 1.0, /portrait
  
  ;define the plot position (for plot statement below)
  pos = [plot_left / page_width, plot_bottom / page_height, $
      (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]

  ;define the axes of the plot: 
  cgplot, dist, vel, $
  xcharsize = 0.8, ycharsize = 0.8, $
  thick = 2, xrange= [0., 18.], yrange= [0., 1200.], $
  xtitle = "Distance (Mpc)", $
  ytitle = "Velocity (km/sec)", xstyle = 1, ystyle = 1, $
  /nodata, position = pos

  ;plot the spectrum
  oplot, dist, vel, psym=symcat(16), color = cgcolor("Gold")
  oplot, dist, vel, psym=symcat(9), color = cgcolor("Black")
  
  ;calculate best-fit line that passes through all the data
  xx = [0., 18.]
  yy = (coeff[1]*xx)+coeff[0]
  
  oplot, xx, yy, color = cgcolor("Red"), linestyle = 0, thick = 2
  
  ;close the PostScript device and convert to PDF
  device, /close
  cgps2pdf, outfile
  ;************************** Hubble **************************

  ;************************** Gaussian **************************
  
  ;read in the spectrum
  infile = path + "o5bn02010_x1d.fits"
  spec = mrdfits(infile, 1, hdr)
  wave = spec.wavelength
  flux = spec.flux

  ;assign the flux and wavelength to IDL vectors
  wave = spec.wavelength
  flux = spec.flux

  ;sort the wavelength variable
  i = sort(wave)
  swave = wave[i]
  sflux = flux[i]

  ;scale the flux
  scaled_sflux = sflux / 1.e-13

 ;select the wavelength region around the spectral line of interest (1547 Å< λ <1549 Å ):
 wline = swave[34610: 34900]
 fline = scaled_sflux[34610: 34900]
 fit = gaussfit(wline, fline, coeff, nterms = 3)

 print, "A = " , coeff[0]
 print, "B = " , coeff[1]
 print, "C = " , coeff[2]
 
   ;setup the output plot
  outfile = path+"Gaussian.ps"
  
  ;define the position and size of the plot, units in centimeters. 
  page_height = 27.94
  page_width = 21.59
  plot_left = 3.
  plot_bottom = 4
  xsize = 16.
  ysize = 9.

  ;We open the PostScript device: 
  device, filename = outfile, $  
  xsize = page_width, ysize = page_height, $ 
  xoffset = 0, yoffset = 0, $ 
  scale_factor = 1.0, /portrait
  
  ;define the plot position (for plot statement below)
  pos = [plot_left / page_width, plot_bottom / page_height, $
      (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]

  ;define the axes of the plot: 
  cgplot, swave, sflux, $
  xcharsize = 0.8, ycharsize = 0.8, $
  thick = 2, xrange= [1547., 1549.], yrange= [-1., 12.], $
  xtitle = "Wavelength ("+tex2idl("$\AA$")+")", $
  ytitle = "Flux (10"+tex2idl("$^{-13} erg sec^{1} cm^2 \AA$"), $
    xstyle = 1, ystyle = 1, $
  /nodata, position = pos

  ;plot the spectrum
  oplot, wline, fline, linestyle=0, thick=3., color = cgcolor("Blue")
  
  ;calculate and plot the Gaussian estimate
  f = gaussian([wline], [coeff[0],coeff[1],coeff[2]])
  oplot, wline, f, linestyle = 2, thick = 2., color = cgcolor("Red")
  
  ;plot vertical line through the spectral line
  oplot, [coeff[1],coeff[1]], [-1., 12.], linestyle=2, thick=2., color = cgcolor("Black")
  
  fwhm = 2.*sqrt(2.*alog(2.))*coeff[2]
  print, "FWHM = ", strtrim(string(fwhm),2)
  
  ;close the PostScript device and convert to PDF
  device, /close
  cgps2pdf, outfile

  ;************************** Gaussian **************************

  
end