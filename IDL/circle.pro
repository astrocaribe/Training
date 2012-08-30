;+
; :Routine Name: circle
;
; :Description:
;    Return the area of a circle given the radius r.
;
; :Parameters:
; 	:Params:
;    r - the radius used to calculate the area of the circle
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
function circle, r
  a = !pi*r^2
 
  return, a
end