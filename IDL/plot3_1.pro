;+
; :Routine Name: plot3_1
;
; :Description:
;    Plotting exercise for Exercise 3.1 in the IDL training manual.
;    This procedure will plot the function y = f(x) = exp(x)*x^(-2), 
;    and create a PDF from the resulting PostScript file.
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
; 	Aug 16, 2012
;-
pro plot3_1
  ;define the working path and filename
  path = "/Users/leblanc/Documents/IDLWorkspace/Training/IDL/"
  fname = path + "plot3_1.ps"
  
  ;define position and plot size, units in cm
  page_height = 27.94
  page_width = 21.59
  plot_left = 5.
  plot_bottom = 5.
  xsize = 14.
  ysize = 10.

  ;set PostScript environment
  set_plot, 'ps'

  ;open the post script device
  device, filename = fname, xsize = page_width, ysize = page_height, $
          xoffset = 0, yoffset = 0, scale_factor = 1.0, /portrait

  ;define variables and function
  x = findgen(800)*0.1
  y = exp(x)*x^(-2.)

  ;define the axes, w/o priting the data
  pos = [plot_left / page_width, plot_bottom / page_height, $
         (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]
  
  cgplot, x, y, /noerase, /nodata, xrange = [0. , 10.], $
          yrange = [0., 250.], xstyle = 1, ystyle = 1, $
          color = cgcolor("black"), xtit = "x title", ytit = "ytitle", $
          tit = "title", position = pos

  ;plot the function in blue
  oplot, x, y, color = cgcolor("Blue")

  ;close device
  device,/close

  ;convert ps file to a PFD
  cgps2pdf, fname
  
  ;set plot back to X Windows environment
  set_plot, 'x'
end