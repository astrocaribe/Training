;+
; :Routine Name: exercise_5
;
; :Description:
;    Script to complete the tasks in Chapter 5 of the IDL training manual.
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
pro exercise_5

  ;define working directory
  path = "/Users/leblanc/Documents/IDLWorkspace/Training/IDL/"
  
  ;setup the input file
  infile = path+"ngc4151_hband.fits"
  
  ;read the header to find and print the number of extensions
  f = headfits(infile, exten=0)
  print,sxpar(f, "NSCIEXT")

  ;read in the image in the 1st extension
  cube = readfits("ngc4151_hband.fits", hdr, exten=1)

  ;create an array to store the pixel calibrations
  pixel = findgen(2040)+1.
  
  ;calibrate the 3 dimensions of the images...
  ;for x...
  crpix1 = sxpar(hdr, "CRPIX1")
  cdelt1 = sxpar(hdr, "CDELT1")
  crval1 = sxpar(hdr, "CRVAL1")
  cunit1 = sxpar(hdr, "CUNIT1")
  x = crval1 + (pixel - crpix1) * cdelt1
  
  ;y ...
  crpix2 = sxpar(hdr, "CRPIX2")
  cdelt2 = sxpar(hdr, "CDELT2")
  crval2 = sxpar(hdr, "CRVAL2")
  cunit2 = sxpar(hdr, "CUNIT2")
  y = crval2 + (pixel - crpix2) * cdelt2
  
  ;and lambda ...
  crpix3 = sxpar(hdr, "CRPIX3")
  cdelt3 = sxpar(hdr, "CDELT3")
  crval3 = sxpar(hdr, "CRVAL3")
  cunit3 = sxpar(hdr, "CUNIT3")
  lambda = crval3 + (pixel - crpix3) * cdelt3
  
  print, crpix3, cdelt3, crval3, cunit3 
  

  ;************************** SPECTRA **************************
  ;set the plotting device to PostScript
  set_plot, "ps"
  
  ;setup the output plot
  outfile = path+"Dcube.ps"
  
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
  
  ;select the pixel with IDL coordinates x = 30 and y = 30 
  ;and we reject some xy planes from the beginning and end of the cube.
  image = cube[30, 30, 100:1900]

  ;translate the wavelength from Å to microns
  lambda_microns = lambda[100:1900] / 1.e4

  ;define the plot position (for plot statement below)
  pos = [plot_left / page_width, plot_bottom / page_height, $
      (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]

  ;define the axes of the plot: 
  cgplot, [0], [0], $
  xcharsize = 0.8, ycharsize = 0.8, $
  thick = 2, xrange= [min(lambda_microns), max(lambda_microns)], $
  yrange= [500, 1100.], xtitle = "wavelength ($\mu$m)", $
  ytitle = "flux", xstyle = 1, ystyle = 1, yminor = 1, $
  /nodata, /normal, /noerase, position = pos

  ;plot the spectrum
  oplot, lambda_microns, image, color = cgcolor("red")
  
  ;close the PostScript device
  device, /close
  ;************************** SPECTRA **************************



  ;************************** IMAGES **************************
  ;setup the output plot
  outfile = path+"Image.ps"
  
  ;define the position and size of the plot, units in centimeters. 
  page_height = 27.94
  page_width = 21.59
  plot_left = 3.
  plot_bottom = 4
  xsize = 15.
  ysize = 15.
  
  ;define the plot position (for plot statements below)
  pos = [plot_left / page_width, plot_bottom / page_height, $
      (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]

  ;We open the PostScript device: 
  device, filename = outfile, $  
  xsize = page_width, ysize = page_height, $ 
  xoffset = 0, yoffset = 0, $ 
  scale_factor = 1.0, /portrait

  ;load a color table
  cgloadct, 33, ncolors = 256, bottom = 0, clip = [0, 256], /reverse
  tvlct, redvector, greenvector, bluevector, /get
  
  ;select the plane with λ = 1.65 μm and scale the image
  image = 255b - bytscl(cube[*,*,1067.], min = 0, max = 100)
  ss = size(image, /dimensions)
  
  ;display the image and calculate contours
  cgimage, image, position = pos
  contour_x = findgen(ss[0])
  contour_y = findgen(ss[1])

  ;over plot a contour:
  cgcontour, cube[*,*,1067.], contour_x, contour_y, $
  levels = [5, 10, 20, 30, 40, 50, 100, 200, 600] , $
  xstyle = 1, $
  ystyle = 1, $
  axiscolor = "black", $
  xcharsize = 0.8, ycharsize = 0.8, $
  c_colors = cgcolor("white"), /noerase, $
  position = pos
  
  ;close the device
  device, /close
 
  ;use to search for another interesting IR wavelength 
  ;spawn, "ds9 -multiframe 'ngc4151_hband.fits' &"
  
  ;************************** IMAGES **************************
  ;setup the output plot
  outfile = path+"Image2.ps"
  
  ;define the position and size of the plot, units in centimeters. 
  page_height = 27.94
  page_width = 21.59
  plot_left = 3.
  plot_bottom = 4
  xsize = 15.
  ysize = 15.
  
  ;define the plot position (for plot statements below)
  pos = [plot_left / page_width, plot_bottom / page_height, $
      (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]

  ;We open the PostScript device: 
  device, filename = outfile, $  
  xsize = page_width, ysize = page_height, $ 
  xoffset = 0, yoffset = 0, $ 
  scale_factor = 1.0, /portrait

  ;load a color table
  cgloadct, 33, ncolors = 256, bottom = 0, clip = [0, 256], /reverse
  tvlct, redvector, greenvector, bluevector, /get
  
  ;select the plane with λ = 1.65 μm and scale the image
  image = 255b - bytscl(cube[*,*,1096.], min = 0, max = 100)
  ss = size(image, /dimensions)
  
  ;display the image and calculate contours
  cgimage, image, position = pos
  contour_x = findgen(ss[0])
  contour_y = findgen(ss[1])

  ;over plot a contour:
  cgcontour, cube[*,*,1096.], contour_x, contour_y, $
  levels = [5, 10, 20, 30, 40, 50, 100, 200, 600] , $
  xstyle = 1, $
  ystyle = 1, $
  axiscolor = "black", $
  xcharsize = 0.8, ycharsize = 0.8, $
  c_colors = cgcolor("white"), /noerase, $
  position = pos
  
  ;************************** IMAGES **************************  
  
  ;close the device
  device, /close


  ;************************** IMAGES **************************
  
  print, "Script done!"
  set_plot, "ps"    ;reset plotting device to X Windows
  
end