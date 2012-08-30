; Generate a cmd using the ACS data for filters F606W and F814W (for Proposal ID #10775)
; For this exercise, the results for the DAOphot catalogue will be used
;
; Coded by: Tommy LeBlanc
; Coded on: 02-Aug-2012
; Project : Archive Training with Michael Wolfe
 
pro hla_cmd

  ;set startup preferences
  setplotprefs
  

  ;setup running directories
  basedir='/Users/leblanc/Documents/'
  workdir='IDLWorkspace/Training/Archive/'
  datadir1=basedir+'Training_Documents/Archive/HLA\ Search/HLADATA-112721766/'+$
           'hst_10775_63_wfpc2_f606w_wf/'
  datadir2=basedir+'Training_Documents/Archive/HLA\ Search/HLADATA-112721766/'+$
           'hst_10775_63_wfpc2_f814w_wf/'
  
  ;setup input files
  infile1 = datadir1+'hst_10775_63_wfpc2_f606w_wf_daophot_trm.cat'
  infile2 = datadir2+'hst_10775_63_wfpc2_f814w_wf_daophot_trm.cat'
  infile3 = datadir1+'hst_10775_63_wfpc2_f606w_wf_sexphot_trm.cat'
  infile4 = datadir2+'hst_10775_63_wfpc2_f814w_wf_sexphot_trm.cat'

  ;set the format for reading in the appropriate fields from readcol operation below
  frmt = '(x,x,d,d,a,d,d,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x)'
  frmt2 ='(x,x,d,d,a,x,x,x,x,d,d,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x)'
  
  ;read in the data files; for now, only the ids (for matching) and photometry (in mags)
  ;is necessary (for the DAOphot data). In both cases, the 0.1 aperture magnitudes
  ;were used
  readcol, infile1, f6ra, f6dec, f6id, f6mag, f6err, format=frmt, comment='#'
  readcol, infile2, f8ra, f8dec, f8id, f8mag, f8err, format=frmt, comment='#'

  ;For the SExtractor data
  readcol, infile3, f6raS, f6decS, f6idS, f6magS, f6errS, format=frmt, comment='#'
  readcol, infile4, f8raS, f8decS, f8idS, f8magS, f8errS, format=frmt, comment='#'
  
  n_f6 = n_elements(f6id)		;total records for the F606W filter (DAOphot)
  n_f6S = n_elements(f6idS)		;total records for the F606W filter (SExtractor)
  t_count = 0					;counter for total number of matches
  n_match = 608					;total number of matches (known beforehand)
  n_matchS = 721				;same for SExtractor data
    
  ;Create an arrays to store the matches found in the for loop below. Total matches
  ;were known beforehand using the t_count variable
  mag = make_array(n_match, /double, value=0.0)
  colour = make_array(n_match, /double, value=0.0)
  
  magS = make_array(n_matchS, /double, value=0.0)
  colourS = make_array(n_matchS, /double, value=0.0)
   
  ;Iteratively look for ID matched to calculate the colour for found targets
  ;for the CMD (This is for the DAOphot data)
  for ii=0, n_f6-1 do begin
    match = where(f6id[ii] eq f8id)		;is there a match?

    ;If no match is found, move on to the next target
    if match eq -1 then begin
      print, 'No match found for '+f6id[ii]
      continue			;skips to the next iteration
    endif  

    ;If there is only one match, then verify RA and Dec using gcirc. And increment the
    ;total count. Also calculate the colour for matched target
    if n_elements(match) eq 1 then begin
      gcirc, 2, f6ra[ii], f6dec[ii], f8ra[match[0]], f8dec[match[0]], matchdist
            
      print, 'Match found for ', f6id[ii], ' ; dist: ', matchdist

      ;Store the mag and colour once a match is found! [F606W - F814W]
      mag[t_count] = f8mag[match[0]]
      colour[t_count] = f6mag[ii]-f8mag[match[0]]
    endif

    t_count+=1    		;increment total match count
  endfor

  ;Plot the CMD for the matches found in the previous step
  o1 = basedir+workdir+'CMD_DAOphot'
  sp, 0, 1, /eps, /color, file=o1, plotsize = [6,6,1,1]
  
  plotsym, 0, 0.5, /fill, color=cgColor("Gold")
  plot, colour, mag, xtit='[F606W-F814W]', ytit='F814W mag', yr=[16,24], xr=[-0.5,2.5],$
        psym=8, tit='DAOphot CMD'

  plotsym, 0, 0.5, color=cgColor("Black")
  oplot, colour, mag, psym=8

  device, /close

  t_count = 0			;reset the match counter
  
  ;Iteratively look for ID matched to calculate the colour for found targets
  ;for the CMD (This is for the SExtractor data)
  for ii=0, n_f6S-1 do begin
    match = where(f6idS[ii] eq f8idS)		;is there a match?

    ;If no match is found, move on to the next target
    if match eq -1 then begin
      print, 'No match found for '+f6idS[ii]
      continue			;skips to the next iteration
    endif  

    ;If there is only one match, then verify RA and Dec using gcirc. And increment the
    ;total count. Also calculate the colour for matched target
    if n_elements(match) eq 1 then begin
      gcirc, 2, f6raS[ii], f6decS[ii], f8raS[match[0]], f8decS[match[0]], matchdist
            
      print, 'Match found for ', f6idS[ii], ' ; dist: ', matchdist

      ;Store the mag and colour once a match is found! [F606W - F814W]
      magS[t_count] = f8magS[match[0]]
      colourS[t_count] = f6magS[ii]-f8magS[match[0]]
    endif

    t_count+=1    		;increment total match count
  endfor

  ;Plot the CMD for the matches found in the previous step
  o2 = basedir+workdir+'CMD_SExtractor'
  sp, 0, 1, /eps, /color, file=o2, plotsize = [6,6,1,1]	;open device for (e)ps plotting
  
  plotsym, 0, 0.5, /fill, color=cgColor("TG2")
  plot, colourS, magS, xtit='[F606W-F814W]', ytit='F814W mag', yr=[16,24], xr=[-0.5,2.5],$
        psym=8, tit='SExtractor CMD'

  plotsym, 0, 0.5, color=cgColor("Black")
  oplot, colourS, magS, psym=8

  
  device, /close		;close (e)ps device...
  set_plot, 'x'			;and set plotting device back to XWindows environment

  print
  print, "hla_cmd.pro script done!"
    
end