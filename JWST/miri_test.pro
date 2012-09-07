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
  sub_data = data
  
  for ii=0, n_elements(xcoo)-1 do begin
    sub_data[*,*,ii] = data[*,*,ii] - frame1 
  endfor  

stop

  print, 'Script done!'

  ;stop
end