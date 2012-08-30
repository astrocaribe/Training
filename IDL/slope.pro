;+
; :Routine Name: slope
;
; :Description:
;    This procedure returns the slope (m) and intercept(c) given two points, using the
;    equation for a line y = mx+c.
;
; :Parameters:
; 	:Params:
;    P - first point (x_0, y_0)
;    Q - second point (x_1, y_1)
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
function slope, P, Q
  ;create a floating array to return m and c
  var = dblarr(2)
  
  ;use the given points P and Q to determine m first; assuming a vertical line (c=0)
  m = (P[1]-Q[1])/(P[0]-Q[0])
  
  ;now use m and the first point to calculate the intercept
  c = P[1]-m*P[0]
  
  ;store the calculated values into an array...
  var[0] = m
  var[1] = c
  
  ;and pass them out of the function to the calling program, etc.
  return, var
end