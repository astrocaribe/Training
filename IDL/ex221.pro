
pro ex221
path = "/Users/leblanc/Documents/IDLWorkspace/Training/IDL/images/"
file_root = ["ib3p11p7q","ib3p11p8q","ib3p11phq","ib3p11q9q"]
file_tail = "_flt.fits"
filename = path+file_root+file_tail

for ii = 0,3 do begin
  ;recursively read EXTEN=0 header...
  image = mrdfits(filename[ii], 0, head)
  
  ;and print appropriate information
  print, "ROOTNAME: ", sxpar(head, "ROOTNAME")
  print, "TARGNAME: ", sxpar(head, "TARGNAME")
  print, "FILTER:   ", sxpar(head, "FILTER")
  print, "EXPTIME:  ", sxpar(head, "EXPTIME")
  print, "DATE-OBS: ", sxpar(head, "DATE-OBS")
  print    
endfor  
end