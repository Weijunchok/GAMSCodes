Variables x1,x2,x3,of;
Equations
eq1
eq2
eq3
eq4;
eq1 .. x1+2*x2 =g= 3;
eq2 .. x3+x2 =g= 5;
eq3 .. x1+x3 =e= 4;
eq4 .. x1+3*x2+3*x3 =e= of;
model LP1 /all/;
Solve LP1 US LP min of;
display x1.l,x2.l,x3.l,of.l;