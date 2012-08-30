;+
; :Routine Name: plot3_2
;
; :Description:
;    This procedure is for Exercise 3.2 in the IDL training manual.
;    Three different functions (of my choice will be plotted). I choose to
;    use the previous function from the example 3.2 as the basis for the
;    following three:
;    i)   y = exp(-x/30.)*sin(x)
;    ii)  y = exp(-x/30.)
;    iii) y = sin(x)
;    
;    The purpose is to use ii) and iii) to vizualize how the cumulative changes
;    manifest in i)
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
pro plot3_2
  ;define the working path and filename
  path = "/Users/leblanc/Documents/IDLWorkspace/Training/IDL/"
  fname = path + "plot3_2.ps"
  
  ;define position and plot size, units in cm
  page_height = 27.94
  page_width = 21.59

  ;set PostScript environment
  set_plot, 'ps'

  ;open the post script device
  device, filename = fname, xsize = page_width, ysize = page_height, $
          xoffset = 0, yoffset = 0, scale_factor = 1.0, /portrait

  ;define variables and functions for the three plots
  x = findgen(2001)*0.1
  u = exp(-x/30.)
  y = sin(x)

  ;set position of left plot
  plot_left = 3.
  plot_bottom = 5.
  xsize = 5.
  ysize = 5.
  
  ;define the axes, w/o priting the data for left plot
  pos = [plot_left / page_width, plot_bottom / page_height, $
         (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]
  
  cgplot, x, y*u, /noerase, /nodata, xrange = [0.,30.], $
          yrange = [1.5,-1.5], xstyle = 1, ystyle = 1, $
          color = cgcolor("black"), xtit = "x", ytit = "y = f(x) = exp(-x/30.)*sin(x)", $
          tit = "", position = pos, charsize=.5

  ;plot the function in red
  oplot, x, y*u, color = cgcolor("Red")


  ;set position of center plot
  plot_left = 9.
  plot_bottom = 5.
  xsize = 5.
  ysize = 5.
  
  ;define the axes, w/o priting the data for left plot
  pos = [plot_left / page_width, plot_bottom / page_height, $
         (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]
  
  cgplot, x, y, /noerase, /nodata, xrange = [0.,30.], $
          yrange = [1.5,-1.5], xstyle = 1, ystyle = 1, $
          color = cgcolor("black"), xtit = "x", ytit = "y = f(x) = sin(x)", $
          tit = "", position = pos, charsize=.5

  ;plot the function in blue
  oplot, x, y, color = cgcolor("blue")


  ;set position of right plot
  plot_left = 15.
  plot_bottom = 5.
  xsize = 5.
  ysize = 5.
  
  ;define the axes, w/o priting the data for left plot
  pos = [plot_left / page_width, plot_bottom / page_height, $
         (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]
  
  cgplot, x, u, /noerase, /nodata, xrange = [0.,30.], $
          yrange = [1.5,-1.5], xstyle = 1, ystyle = 1, $
          color = cgcolor("black"), xtit = "x", ytit = "y = f(x) = exp(-x/30.)", $
          tit = "", position = pos, charsize=.5

  ;plot the function in green
  oplot, x, u, color = cgcolor("green")


  ;close device
  device,/close

  ;convert ps file to a PFD
  cgps2pdf, fname
  
  ;set plot back to X Windows environment
  set_plot, 'x'
end