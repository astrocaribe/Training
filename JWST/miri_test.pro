;+
; :Routine Name: miri_test
;
; :Description:
;    Describe the procedure.
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
; 	Sep 5, 2012
;-
pro miri_test

  path = '/Users/leblanc/Documents/Training_Documents/JWST/'
  save_path = '/Users/leblanc/Documents/IDLWorkspace/Training/JWST/'
  
  ;input files
  ifile1 = 'MIRI_VM2T00003329_1_IM_S_2008-09-11T10h04m18.fits'
  ifile2 = 'MIRI_VM2T00003582_1_IM_S_2008-09-14T11h02m41.fits'

  
  ;read in the second MIRI datacube, convert from UINT to DOUBLE,
  ;and extract necessary data
  data = readfits(path+ifile2, hdr, exten=0)
  data = double(data)
  frames = sxpar(hdr, 'NFRAME')
  groups = sxpar(hdr, 'NGROUP')
  ints = sxpar(hdr, 'NINT')
  
  ;assign the x, y coordinates and time dimension information
  data = double(data)
  xcoo = 1 + findgen(frames*groups*ints)
  xtime = xcoo * sxpar(hdr, 'TFRAME')
  
  ;plot the response of the following three pixels in the
  ;datacube
  o1 = save_path+'Miri_Pix_Test'
  sp, 0, 3, /eps, /color, file=o1, plotsize = [6,6,1,1]
  
  ytitle = 'Pix Value (x'+ tex2idl('$10^4$')+')'
  
  y = data[2,657,*]/1.e4
  plot, xtime, y, xtit='Integration Time (s)', ytit=ytitle, $
        tit='Pix Response for (x,y) = (2,657)', xr=[0,110], $
        xstyle = 1

  y = data[376,693,*]/1.e4
  plot, xtime, y, xtit='Integration Time (s)', ytit=ytitle, $
        tit='Pix Response for (x,y) = (376,693)', xr=[0,110], $
        xstyle = 1

  y = data[282,441,*]/1.e4
  plot, xtime, y, xtit='Integration Time (s)', ytit=ytitle, $
        tit='Pix Response for (x,y) = (282,441)', xr=[0,110], $
        xstyle = 1
  
  ;close the PS device
  device, /close

  ;subtract the first frame from all the others
  frame1 = data[*,*,0]
  sub_data = data   ;create a copy to preserve original cube
  
  for ii=0, n_elements(xcoo)-1 do begin
    sub_data[*,*,ii] = data[*,*,ii] - frame1 
  endfor  

  ;find the slope from line fitting for every pixel
  working_data = data
  xdim = sxpar(hdr, 'NAXIS1')
  ydim = sxpar(hdr, 'NAXIS2')
  t_frames = sxpar(hdr, 'NAXIS3')

  ;create an 2D array to hold the final slope image
  slope_data = make_array(xdim, ydim, /float, val=0.)

t = systime(1)

  ;ignore the 1st and last frames due to weird effects,
  ;and calculate slope. Load the slope array.
  for jj=0, ydim - 1 do begin
    for ii=0, xdim - 1 do begin
;      coeff = linfit(xcoo[1:-2], sub_data[ii,jj,1:t_frames-2], sigma=sig)
      coeff = linfit(xcoo, sub_data[ii,jj,*], sigma=sig)
      slope_data[ii,jj] = coeff[1]

;********** Test Area **********      
;ytest = coeff[0] + coeff[1]*xtime      

;yupper = max(data[ii,jj,*])
;ylower = min(sub_data[ii,jj,*])

;set_plot, 'x'
;!p.multi = 0
;window, 1, xsize=500, ysize=500, xpos=1500
;plot, xtime, sub_data[ii,jj,*], yr=[ylower,yupper]
;oplot, xtime, data[ii,jj,*], color=cgcolor('red')
;oplot, xtime, ytest, linestyle=1, thick=2,color=cgColor('Gold')
;print, 'x: ', strtrim(string(ii),2), ' y: ', strtrim(string(jj),2)
;wait, .5
;********** Test Area **********      
      
    endfor
  endfor     
  
  ;write the final slope image to a FITS file
  slope_file = save_path+'slope_img.fits'
  mwrfits, slope_data, slope_file, /lscale 
  
  print
  print, 'Median = ', strtrim(string(median(slope_data)), 2), ' counts/frame.'
  print, 'Average = ', strtrim(string(avg(slope_data)), 2), ' counts/frame.'
  print, 'Stand. Dev. = ', strtrim(string(stddev(slope_data)),2), ' counts/frame.'
  
  ;set_plot, 'x'
  ;!p.multi = 0
  ;window, 1, xsize=500, ysize=500, xpos=1500
  
  sp, 0, 1, /eps, file=save_path+'miri_histogram', plotsize = [6,6,1,1]
  plothist, slope_data, xhist, yhist, xtit='Pixel counts/frame', ytit='Frequency (Normalized to 1)', peak=1

  print
  print, 'Time to complete slope calcs. fits: ', systime(1)-t, ' secs.'
  print, 'Script done!'
  
  device, /close


end