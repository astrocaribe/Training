;+
; :Routine Name: plot3_4
;
; :Description:
;    Script for Exercise 3.4 in the IDL training handbook. This script displays the example
;    for Cahpter 3.9, but without the background FITS file. It will plot the cotours w/
;    different intensities as well as in different colours from the example.
;
; :Parameters:
;
;
; ;Keywords:
;
;
; :Author:
; 	leblanc
;
; :Date:
; 	Aug 17, 2012
;-
pro plot3_4

  ;set the PostScript environment: 
  set_plot, "ps"


  ;set the path and filename
  path = "/Users/leblanc/Documents/IDLWorkspace/Training/IDL/"
  fname = path+"plot3_4.ps"


  ;define the position and plot size (units in cm)
  page_height = 27.94
  page_width = 21.59
  plot_left = 4.
  plot_bottom = 5
  xsize = 14.
  ysize = 14.

  ;open the PostScript device
  device, $
  filename = fname, xsize = page_width, $
  ysize = page_height, xoffset = 0, $
  yoffset = 0, scale_factor = 1.0, /portrait

  ;read in FITS file:
  infile = path+"m101_blue.fits"
  image = mrdfits(infile, 0, hdr)

  ;select a sub-array and scale the image:
  image = image[300:800,300:800]
  data = 255b - bytscl(image, min = 0.0, max = 18000.)

  ;load a color table:
  cgloadct, 3, ncolors = 256, bottom=0, clip = [90, 200]
  tvlct, redvector, greenvector, bluevector, /get
  
  ;display the image
  pos = [plot_left / page_width, plot_bottom / page_height, $
        (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]

  ;cgimage, data, position = pos
  
  ;retrieve size of the image
  tam = size(image, /dim)
  contour_x = findgen(tam[0])
  contour_y = findgen(tam[1])

  ;create the contour plot
  cgcontour, image, contour_x, contour_y, $
  levels = [6000, 12000, 18000], $
  xstyle = 1, $
  ystyle = 1, $
  axiscolor = "black", $
  label = 0, $
  xtickformat = "(a1)", ytickformat = "(a1)", $
  c_colors = cgcolor(["Lawn Green","Dark Green", "Black"]), /noerase, $
  position = pos
  
  ;close the PostScript device and convert to PDF
  device, /close
  cgps2pdf, fname
  
end