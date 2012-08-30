;+
; :Routine Name: plot3_3
;
; :Description:
;    Script for Exercise 3.3 in IDL training packet. This script will read in
;    magnitude data in the F336W for NGC4214, and generate a histogram.
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
pro plot3_3
  ;define the working path and filename
  path = "/Users/leblanc/Documents/IDLWorkspace/Training/IDL/"
  fname = path + "plot3_3.ps"
  
  ;define position and plot size, units in cm
  page_height = 27.94
  page_width = 21.59
  plot_left = 3.
  plot_bottom = 5.
  xsize = 10.
  ysize = 10.

  ;set PostScript environment
  set_plot, 'ps'

  ;read in the first column of the magnitude data file
  infile = path+"ngc4214_336.dat"
  frmt = '(f,x,x)'
  
  readcol, infile, mags, format=frmt, /silent

  ;open the post script device
  device, filename = fname, xsize = page_width, ysize = page_height, $
          xoffset = 0, yoffset = 0, scale_factor = 1.0, /portrait


  ;plot the histogram with the data read in previously
  pos = [plot_left / page_width, plot_bottom / page_height, $
         (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]
  
  cghistoplot, mags, binsize = 0.05, charsize = 0.5, xrange = [17., 25.], $
          yrange = [0., 500.], xstyle = 9, ystyle = 1, polycolor="Green", $
          datacolorname = "Black", xcharsize = 1.5, ycharsize = 1.5, $
          xtit = "Magnitude (F336W)", ytit = "Density", /normal, $
          tit = "NGC4214", position = pos


  ;close device
  device,/close

  ;convert ps file to a PFD
  cgps2pdf, fname
  
  ;set plot back to X Windows environment
  set_plot, 'x'
end