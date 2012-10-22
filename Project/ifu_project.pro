;+
; :Routine Name: ifu_project
;
; :Description:
;    Describe the procedure.
;
; :Parameters:
; 	:Params:
;    infile - input file needed to complete the project
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
; 	Sep 21, 2012
;-
pro ifu_project, infile

  ;set working directory
  path = '/Users/leblanc/Documents/IDLWorkspace/Training/Project/'
  
  ;read in the 3D image
  cube = mrdfits(infile, 1, hdr)
  print   ;space after priting MRDFITS read message
  
  ;create an array to store the pixel calibrations
  pixel = dindgen(2040)+1.
  
  n_x = n_elements(cube[*, 1, 1])
  n_y = n_elements(cube[1, *, 1])
  n_lam = n_elements(cube[1, 1, *])
      
  ;calibrate the 3 dimensions of the image...
  ;for x...
  crpix1 = sxpar(hdr, 'CRPIX1')
  cdelt1 = sxpar(hdr, 'CDELT1')
  crval1 = sxpar(hdr, 'CRVAL1')
  cunit1 = sxpar(hdr, 'CUNIT1')
  x = crval1 + (pixel - crpix1) * cdelt1

  ;for y...
  crpix2 = sxpar(hdr, 'CRPIX2')
  cdelt2 = sxpar(hdr, 'CDELT2')
  crval2 = sxpar(hdr, 'CRVAL2')
  cunit2 = sxpar(hdr, 'CUNIT2')
  y = crval2 + (pixel - crpix2) * cdelt2

  ;and lambda...
  crpix3 = sxpar(hdr, 'CRPIX3')
  cdelt3 = sxpar(hdr, 'CDELT3')
  crval3 = sxpar(hdr, 'CRVAL3')
  cunit3 = sxpar(hdr, 'CUNIT3')
  lambda = crval3 + (pixel - crpix3) * cdelt3
  
  ;print calibration values for verification
  print, 'Calibration values (Pix, Delta, Value, Unit):'
  print, crpix1, cdelt1, crval1, ' ', cunit1
  print, crpix2, cdelt2, crval2, ' ', cunit2
  print, crpix3, cdelt3, crval3, ' ', cunit3
  
  ;pixel position
  pp = [30, 30]
  
  ;generate the spectrum of a given pixel,
  ;select the central pixel (x=y=30)
  img = cube[pp[0], pp[1], 100:1900]

  ;convert wavelengths from angs to micron
  wavelength = lambda[100:1900] / 1.e4

  ;shortened ***** Test *****
  ;cont_sub = specline(path, wavelength, img)
  ;shortened ***** Test *****

  ;compute an estimate for the continuum
  p = linfit(wavelength, img)
  print, 'Gradien and y-intercept:'
  print, p[1], p[0]
  y = p[1] * wavelength + p[0]
  
  ;compute continuum-substrated spectrum
  wavez = wavelength
  z = img - y
  
;*************** Test ***************  
;Testing the line_strength function
;r = [602, 790]
;r = [771, 933]
;r = [1165, 1359]
r = [1515, 1809]
ofile = path+'Spec_line'
idx = where(wavez gt frame_conv(r[0]) AND wavez lt frame_conv(r[1]))
fwhm = line_strength(ofile, wavez[idx], z[idx])
;*************** Test ***************

;;*************** FeII-Continuum Subtracted FITS ***************
;  feII_image = make_array(n_x, n_y, n_lam, /float, value = 0)
;  cont = make_array(n_x, n_y, /float, value = 0)
;  
;
;  ;continuum range
;  tr1 = [1055,1065]
;  tr2 = [1175,1221]
;  
;  ;estimate the continuum before and after the above feature
;  cont[*, *] = avg(cube[*, *, tr2[0]:tr2[1]], 2)
;
;  ofile = path+"FeIIcontinuum.fits"
;  for ii = 0, n_lam - 1 do begin
;    feII_image[*,*,ii] = cube[*,*,ii] - cont
;  endfor
;mwrfits, feII_image, "FeIIcontinuum.fits", /create
;mwrfits, avg(feII_image[*,*,1063:1086],2), "FeIICont_Avg.fits", /create
;
;;*************** FeII-Continuum Subtracted FITS ***************
  
  ;plot the original spectrum, as well as the continuum-
  ;subtracted
  outfile = path + 'Spectrum';+strtrim(string(counter),2)
  leg = ['Spectrum', 'Continuum', 'Continuum-Subtracted']
  sp, 0, 1, /eps, /color, file=outfile, plotsize = [6, 6, 1, 1]
  plot, wavelength, img, xr = [1.45,1.8], yr = [-200,1200], $
        xstyle = 1, ystyle = 1, xtitle = 'Wavelength (µm)' , $
        ytitle = 'Flux', /nodata
  oplot, [1.644, 1.644], [-200, 1200], linestyle = 2, thick = 0.5    
  oplot, wavelength, img, linestyle = 0, color = cgColor('red')
  oplot, wavelength, y, linestyle = 2, color = cgColor('black')
  oplot, wavelength, z, linestyle = 0, color = cgColor('blue')
  
  xyouts, 1.75, 1000., 'pp = ['+strtrim(string(pp[0]),2) $
    +','+strtrim(string(pp[1]),2)+']', /data, charsize = 0.5, $
    charthick = 1.5

  al_Legend, leg, psym=[-0,-0, -0], linestyle=[0,2,0], $
             color=['red','black','blue'], position=[1.47,1100]
                 
  device, /close
  

;***************** Continuum + Redshift Test *****************
;test_spec = cube[30, 30, *]
;idx = where(wavez gt frame_conv(tr1[0]) AND wavez lt frame_conv(tr1[1]))
;coeff1 = poly_fit(wavez[idx], test_spec[idx], 3, y_fit)
;
;  p1 = plot(wavelength, img, '-r1')
;  p2 = plot(wavelength, y, '--k1', /overplot)
;  p3 = plot(wavelength, z, '-b1', /overplot)
;  
;  ;retall
;  stop
;***************** Continuum + Redshift Test *****************
  
  ;Create a new continuum-subtracted cube
  ;Compressed image ~ 1.644 µm, including double-peaked 
  ;feature (frame[0] to frame[1])
  frame = [1070,1083]
  cmp_image = make_array(n_x, n_y, /float, value = 0)
  cmp_image[*, *] = avg(cube[*, *, frame[0]:frame[1]], 2)

  ;continuum ranges
  tr1 = [1055,1065]
  tr2 = [1175,1221]
  
  ;estimate the continuum before and after the above feature
  cont_1 = make_array(n_x, n_y, /float, value = 0)
  cont_2 = make_array(n_x, n_y, /float, value = 0)
  cont_1[*, *] = avg(cube[*, *, tr1[0]:tr1[1]], 2)
  cont_2[*, *] = avg(cube[*, *, tr2[0]:tr2[1]], 2)
  
  ;save an abbreviated version of the original cube, centered
  ;around the [Fe II] 1.644µm line
  range = [1050,1110]
  mwrfits, cube[*,*,range[0]:range[1]], "NGC4151_Short.fits", /create
;***************** Continuum + Redshift Test *****************

  
  ;add the continuum estimates, and subtract from the compressed
  ;(averaged) frame
  cmp_image = cmp_image - (cont_1+cont_2)/2.
    
  ;producing an ".alias: No such file or dir" error
  ;cgps2pdf, path+'Spectrum.eps', path+'Spectrum.pdf'
  
  ;generate a contour plot of the 1.64 µm wavelength continuum-
  ;subtraced image
  outfile = path + 'Contour'
;  sp, 0, 1, /eps, /color, file = outfile, plotsize = [6, 6, 1, 1]
  pos = idl_setplot(outfile, 15., 15.)
  
  ;load color table
  cgloadct, 3, ncolors = 256, bottom = 0, clip = [0, 256], /reverse
  tvlct, redvector, greenvector, bluevector, /get
  
  ;scale the continuum-subtracted spectrum in the above range and 
  ;scale image
  img = 255b - bytscl(cmp_image, min = 0, max = 30)
  ss = size(img, /dimensions)
  
  ;display image and calculate contours
  cgimage, img, position = pos
  contour_x = findgen(ss[0])
  contour_y = findgen(ss[1])
  colors = ['green','green','green','black','black','black']
  
  cgcontour, cmp_image, contour_x, contour_y, $
    levels = [5,10,15,20,25,30], $
    xstyle = 1, ystyle = 1, axiscolor = 'white', $
    xcharsize = 0.8, ycharsize = 0.8, thick=5.,$
    c_colors = cgcolor(colors), /noerase, position = pos
    
  arrows, hdr, 4., 49., /data, color = cgColor('white'), thick=3.0
  
  device, /close
 
  ;having issues with dissapearing axes, seeming to stem from
  ;previous cgloadct and/or tvlct commands above. Reloading
  ;0th color table seems to fix the issue, but I need a better
  ;fix
  cgloadct, 0 
  
  print, 'Script done!'
end