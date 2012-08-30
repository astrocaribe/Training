;+
; :Routine Name: exercise_s1
;
; :Description:
;    Script to complete tasks for Exercise #1 of the Spectroscopy training document.
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
; 	Aug 21, 2012
;-
pro exercise_s1

  ;setup the working directory
  path = "/Users/leblanc/Documents/Training_Documents/Spectroscopy/"
  save_path = '/Users/leblanc/Documents/IDLWorkspace/Training/Spectroscopy/'
  
  ;read in the fits files for examination
  infile1 = path + "data/lbgu17qnq_x1d.fits"
  infile2 = path + "data/o8k401010_x1d.fits"
  infile3 = path + "data/lbgu17qnq_rawtag_a.fits"
  infile4 = path + "data/lbgu17qnq_rawtag_b.fits"
  infile5 = path + "data/o8k401010_raw.fits"
  

  ;show general information about the opened FITS files
  data1 = mrdfits(infile1, 1, hdr1)
  help, data1, /str
;stop

  data2 = mrdfits(infile2, 1, hdr2)
  help, data2, /str
;stop

  data3 = mrdfits(infile3, 1, hdr3)
  help, data3, /str
;stop
    
  data4 = mrdfits(infile4, 1, hdr4)
  help, data4, /str
;stop

  data5 = mrdfits(infile5, 1, hdr5)
  help, data5, /str
;stop

  ;Exercise 3
  ;testdata files
  infile6 = path + "testdata/lbgu17qnq_x1d.fits"
  infile7 = path + "testdata/o8k401010_x1d.fits"

  ;plot the COS spectra from computed (from MAST) and the recalibrated by myself
  
  ;************************** COS SPECTRA **************************
  ;read in the COS spectra
  data6 = mrdfits(infile6, 1, hdr6)
  
  ;assign the wavelength and flux to IDL vectors
  wave1 = data1.wavelength
  flux1 = data1.flux
  wave6 = data6.wavelength
  flux6 = data6.flux
  
  ;sort the wavelengths
  h = sort(wave1)
  s_wave1 = wave1[h]
  s_flux1 = flux1[h]
  i = sort(wave6)
  s_wave6 = wave6[i]
  s_flux6 = flux6[i]

  
  ;scale the flux
  scaled_s_flux1 = s_flux1/1.e-13
  scaled_s_flux6 = s_flux6/1.e-13

  ;set the plotting device to PostScript
  set_plot, "ps"
  
  ;setup the output plot
  outfile = save_path+"COScompare.ps"
  
  ;define the position and size of the plot, units in centimeters. 
  page_height = 27.94
  page_width = 21.59
  plot_left = 3.
  plot_bottom = 4
  xsize = 17.
  ysize = 7.

  ;We open the PostScript device: 
  device, filename = outfile, $  
  xsize = page_width, ysize = page_height, $ 
  xoffset = 0, yoffset = 0, $ 
  scale_factor = 1.0, /portrait
  
;  ;select the pixel with IDL coordinates x = 30 and y = 30 
;  ;and we reject some xy planes from the beginning and end of the cube.
;  image = cube[30, 30, 100:1900]

  ;translate the wavelength from Å to microns
  lambda_microns = data6.wavelength/1.e4

  ;define the plot position (for plot statement below)
  pos = [plot_left / page_width, plot_bottom / page_height, $
      (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]


  ;define the axes of the plot: 
  cgplot, s_wave6, scaled_s_flux6, $
  xcharsize = 0.8, ycharsize = 0.8, $
  thick = 2, xrange= [min(s_wave6), max(s_wave6)], $
  title="COS Calibration Comparisons", $
  yrange= [-1., max(scaled_s_flux6)], xtitle = "Wavelength ("+tex2idl("$\AA$")+")", $
  ytitle = 'Flux (10!E-13!N erg sec!E-1!N cm!E-2!N !3'+STRING(197B)+'!X!E-1!N)', $
  xstyle = 1, ystyle = 1, /nodata, /normal, /noerase, position = pos

  ;plot the spectrum
  oplot, s_wave6, scaled_s_flux6, color = cgcolor("black"), thick = 5.0
  oplot, s_wave1, scaled_s_flux1, color = cgcolor("red"), thick = 1.0, linestyle=0
  
  ;close the PostScript device
  device, /close
  cgps2pdf, outfile
  ;************************** COS SPECTRA **************************


  ;************************** STIS SPECTRA **************************
  ;read in the COS spectra
  data7 = mrdfits(infile7, 1, hdr7)
  
  ;assign the wavelength and flux to IDL vectors
  wave2 = data2.wavelength
  flux2 = data2.flux
  wave7 = data7.wavelength
  flux7 = data7.flux
  
  ;sort the wavelengths
  h = sort(wave2)
  s_wave2 = wave2[h]
  s_flux2 = flux2[h]
  i = sort(wave7)
  s_wave7 = wave7[i]
  s_flux7 = flux7[i]

  
  ;scale the flux
  scaled_s_flux2 = s_flux2/1.e-13
  scaled_s_flux7 = s_flux7/1.e-13

  ;set the plotting device to PostScript
  set_plot, "ps"
  
  ;setup the output plot
  outfile = save_path+"STIScompare.ps"
  
  ;define the position and size of the plot, units in centimeters. 
  page_height = 27.94
  page_width = 21.59
  plot_left = 3.
  plot_bottom = 4
  xsize = 17.
  ysize = 7.

  ;We open the PostScript device: 
  device, filename = outfile, $  
  xsize = page_width, ysize = page_height, $ 
  xoffset = 0, yoffset = 0, $ 
  scale_factor = 1.0, /portrait
  
;  ;select the pixel with IDL coordinates x = 30 and y = 30 
;  ;and we reject some xy planes from the beginning and end of the cube.
;  image = cube[30, 30, 100:1900]

  ;translate the wavelength from Å to microns
  lambda_microns = data7.wavelength/1.e4

  ;define the plot position (for plot statement below)
  pos = [plot_left / page_width, plot_bottom / page_height, $
      (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]


  ;define the axes of the plot: 
  cgplot, s_wave7, scaled_s_flux7, $
  xcharsize = 0.8, ycharsize = 0.8, $
  thick = 2, xrange= [min(s_wave7), max(s_wave7)], $
  title="STIS Calibration Comparisons", $
  yrange= [-0.5, max(scaled_s_flux7)+1.], xtitle = "Wavelength ("+tex2idl("$\AA$")+")", $
  ytitle = 'Flux (10!E-13!N erg sec!E-1!N cm!E-2!N !3'+STRING(197B)+'!X!E-1!N)', $
  xstyle = 1, ystyle = 1, /nodata, /normal, /noerase, position = pos

  ;plot the spectrum
  oplot, s_wave7, scaled_s_flux7, color = cgcolor("black"), thick = 5.0
  oplot, s_wave2, scaled_s_flux2, color = cgcolor("red"), thick = 1., linestyle=0
  
  ;close the PostScript device
  device, /close
  cgps2pdf, outfile
  ;************************** STIS SPECTRA **************************


  print, "Script done!"
  
end

