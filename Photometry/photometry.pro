;+
; :Routine Name: photometry
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
; 	Sep 12, 2012
;-
pro photometry

  ;Working directory
  path = '/Users/leblanc/Documents/Training_Documents/Photometry/images/'
  save_path = '/Users/leblanc/Documents/IDLWorkspace/Training/Photometry/'
  
  ;Input files
  ifile1 = path+'f606w.phot'
  ifile2 = path+'f814w.phot'
  
  ac05 = [0., 0.]
  AC5 = [0.088, 0.087]
  
;  ;**************************** F606W ****************************
;  ;Input format for incoming data. Since the invalid data might be used,
;  ;all data will be read in as a string, and converted to either float
;  ;(for valid data) or 99.999 for invalid 'INDEF' data.
;  frmt = '(a,a,a,a)'
;  readcol, ifile1, f606w_x, f606w_y, f606w_a5, f606w_a16, format = frmt
;
;    
;  ;Change the invalid data 'INDEF' to '99.999', then convert the structure
;  ;to float for both F606W and F814W lists
;  
;  indef = where(f606w_a5 eq 'INDEF')
;  f606w_a5[indef] = '99.999'
;  f606w_a5 = float(f606w_a5)
;  indef = where(f606w_a16 eq 'INDEF')
;  f606w_a16[indef] = '99.999'
;  f606w_a16 = float(f606w_a16)
;
;  ;Display an interactive plot for the data
;  ;p1 = plot(f606w_a5, f606w_a5-f606w_a16, '.k2')
;  
;  ;plot a hardcopy of the above plot
;  ytitle = Greek('delta', /CAPITAL)+' mag ('+tex2idl('$m_3$')+'-'+tex2idl('$m_{16}$')+')'
;  
;  sp, 0, 1, /eps, /color, file=save_path+'f606w_ac', plotsize = [6,6,1,1]
;  plot, f606w_a5, f606w_a5-f606w_a16, psym=symcat(3), xtit=tex2idl('$m_5$'), $
;        ytit=ytitle, xr=[18,29], yr=[-0.4,1.0], xstyle=1, ystyle=1
;        
;  oplot, [18, 29], [0., 0.], linestyle=2, thick=2. ; y=0 line for comparion
;  oplot, [18, 29], [0.1232, 0.1232], linestyle=0, color=cgColor('red'), thick=2.
;  
;  xyouts, 19., 0.09, 'Ap_corr = 0.1232', charsize = 0.5, /data
;  xyouts, 26., 0.8, 'F606W', charsize=0.75, charthick=2., /data
;       
;  device, /close
;  
;  ;aperture correction (from plot above)
;  ac05[0] = 0.1232
;  
;  ;**************************** F606W ****************************
;
;  ;**************************** F814W ****************************
;  frmt = '(a,a,a,a)'
;  readcol, ifile2, f814w_x, f814w_y, f814w_a5, f814w_a16, format = frmt
;
;    
;  ;Change the invalid data 'INDEF' to '99.999', then convert the structure
;  ;to float for both F606W and F814W lists
;  
;  indef = where(f814w_a5 eq 'INDEF')
;  f814w_a5[indef] = '99.999'
;  f814w_a5 = float(f814w_a5)
;  indef = where(f814w_a16 eq 'INDEF')
;  f814w_a16[indef] = '99.999'
;  f814w_a16 = float(f814w_a16)
;
;  ;Display an interactive plot for the data
;  ;p1 = plot(f814w_a5, f814w_a5-f814w_a16, '.k2')
;  
;  ;plot a hardcopy of the above plot
;  ytitle = Greek('delta', /CAPITAL)+' mag ('+tex2idl('$m_3$')+'-'+tex2idl('$m_{16}$')+')'
;  
;  sp, 0, 1, /eps, /color, file=save_path+'f814w_ac', plotsize = [6,6,1,1]
;  plot, f814w_a5, f814w_a5-f814w_a16, psym=symcat(3), xtit=tex2idl('$m_5$'), $
;        ytit=ytitle, xr=[17,28], yr=[-0.4,1.0], xstyle=1, ystyle=1
;        
;  oplot, [17, 28], [0., 0.], linestyle=2, thick=2. ; y=0 line for comparion
;  oplot, [17, 28], [0.1654, 0.1654], linestyle=0, color=cgColor('blue'), thick=2.
;  
;  xyouts, 18., 0.11, 'Ap_corr = 0.1654', charsize = 0.5, /data
;  xyouts, 25., 0.8, 'F814W', charsize=0.75, charthick=2., /data
;       
;  device, /close
;  
;  ;aperture correction (from plot above)
;  ac05[1] = 0.1654
;
;  ;**************************** F814W ****************************



  ;**************************** Combined ****************************
  ;read in the combined F606W/F814W catalogue
  frmt = '(f,f,f,f,f,f,f,f)'
  infile = path+'combined_table.dat'
  readcol, infile, f606w_x, f606w_y, f606w_a5, f606w_a16, f814w_x, f814w_y, f814w_a5, f814w_a16, format = frmt
;  ;change invalid 'INDEF' entries to 99.999 and convert string arrays
;  ;to float for plotting
;  indef = where(f606w_a5 eq 'INDEF')
;  f606w_a5[indef] = '99.999'
;  f606w_a5 = float(f606w_a5)
;  indef = where(f606w_a16 eq 'INDEF')
;  f606w_a16[indef] = '99.999'
;  f606w_a16 = float(f606w_a16)
;  indef = where(f814w_a5 eq 'INDEF')
;  f814w_a5[indef] = '99.999'
;  f814w_a5 = float(f814w_a5)
;  indef = where(f814w_a16 eq 'INDEF')
;  f814w_a16[indef] = '99.999'
;  f814w_a16 = float(f814w_a16)


  ;calculate aperture correction for F606W and F814W smaller (5.)
  ;apertures
  f606w_mag = f606w_a5-ac05[0]-AC5[0]
  f814w_mag = f814w_a5-ac05[1]-AC5[1]
  
  ;p1 = plot(f606w_mag-f814w_mag, f606w_mag, '.k2')

  sp, 0, 1, /eps, file=save_path+'NGC6791_CMD', plotsize=[6,6,1,1]
  
  plot, f606w_mag-f814w_mag, f606w_mag, psym=symcat(3), color=cgcolor('black'), $
        xr = [-2.,2.5], yr = [30,18], xstyle = 1, ystyle = 1, $
        xtit = '[F606W - F814W]', ytit = 'F606W (mag)'
  xyouts, 1.5, 20., 'NGC6791', charthick = 2., /data
  
  device, /close

  ;**************************** Combined ****************************

  print
  print, 'Script done!'

end