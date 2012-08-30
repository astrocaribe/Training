;+
; :Routine Name: exercise_4
;
; :Description:
;    Describe the procedure.
;
; :Parameters:
;
;
; :Input:
;   - j8hm01xaq_flt.fits
;
; :Output:
;  - photometry_01.ps
;  - photomerty_02.ps
;  - photometry.fits
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
pro exercise_4

  ;setup path and output filename
  path = "/Users/leblanc/Documents/IDLWorkspace/Training/IDL/"
  fname = path + "photometry_02.ps"
  
  ;read in FITS image, and display info
  infile = path + "j8hm01xaq_flt.fits"
 
  ;extract principal header information
  head = headfits(infile, exten=0)
  print, "Number of Extensions = ", sxpar(head, "NEXTEND")
  
  ;find the number of pixels per science chip, output from the mrdfits
  ;procedure. Only a subset of the image will be used
  image = mrdfits(infile, 4, hdr)
  image500 = image[900:1399, 800:1299]
  help, image500
  print, "Image created on: ", strtrim(sxpar(head, "Date"),2)
  print, "Principal Investigator: ", strtrim(sxpar(head ,"PR_INV_F"), 2), " ", $
         strtrim(sxpar(head ,"PR_INV_M"), 2), " ",  strtrim(sxpar(head ,"PR_INV_L"), 2)
  print, "Exposure Time = ", strtrim(sxpar(head, "EXPTIME"), 2)

  ;define the position and plot size (units in cm)
  page_height = 27.94
  page_width = 21.59
  plot_left = 5.
  plot_bottom = 5.
  xsize = 14.
  ysize = 14.

  ;open the PostScript device
  device, $
  filename = fname, xsize = page_width, $
  ysize = page_height, xoffset = 0, $
  yoffset = 0, scale_factor = 1.0, /portrait

  ;select a sub-array and scale the image:
  data = 255b - bytscl(image500, min = 1., max = 40.)
  ss = size(data, /dimensions)

  ;load a color table:
  cgloadct, 0
  tvlct, redvector, greenvector, bluevector, /get
  
  ;display the image
  pos = [plot_left / page_width, plot_bottom / page_height, $
        (plot_left + xsize) / page_width, (plot_bottom + ysize) / page_height]

  cgimage, data, position = pos
  
  ;draw the axes
  cgplot, [0], [0], xcharsize = 1, ycharsize = 1, thick = 2, $
          xrange= [0, ss[0]], yrange= [0, ss[1]], $
          xtitle = "x pixels", ytitle = "y pixels", $
          xstyle = 1, ystyle = 1, $
          /nodata, /normal, /noerase, position = pos
  
  ;find sources
  find, image500, xcoo, ycoo
  
  ;overplot the sources on our original plot
  oplot, [xcoo], [ycoo], color = cgcolor("Red"), psym = symcat(9)
  
  ;close the device
  device, /close  


  ;compute photometry
  aper, image500, xcoo, ycoo, flux, eflux, fsky, fesky, /flux
  
  ;create a structure to store data in FITS format
  target = {x:xcoo, y:ycoo, f:flux, fe:eflux, s:fsky, se:fesky}
  outfile = "photometry.fits"
  mwrfits, target, outfile, /create
    
  ;close the device
  device, /close  

  ;plot the flux error as a function of flux
  fname = path+"flux_vs_fluxerr.ps"
  device, $
  filename = fname, xsize = page_width, $
  ysize = page_height, xoffset = 0, $
  yoffset = 0, scale_factor = 1.0, /portrait
  
  cgplot, flux, eflux, xcharsize = 1, ycharsize = 1, thick = 2, $
          ;xrange= [min(flux), max(flux)], yrange= [min(eflux), max(eflux)], $
          xtitle = "Flux (Flux Units)", ytitle = "Flux Error (Flux Units)", $
          xstyle = 1, ystyle = 1, psym=symcat(9), color=cgcolor("blue"), $
          /normal, position = pos
  
  
  
  ;close the device
  device, /close
  
end