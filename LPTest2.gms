Variables x1,x2,x3,of;
Equations
eq1
eq2
eq3
eq4;
eq1 .. x1+2*x2 =l= 3;
eq2 .. x3+x2 =l= 2;
eq3 .. x1+x2+x3 =e= 4;
eq4 .. x1+2*x2-3*x3 =e= of;
model LP1 /all/;
x1.lo=0;
x1.up=5;
x2.lo=0;
x2.up=3;
x3.lo=0;
x3.up=2;
Solve LP1 US LP max of;
display x1.l,x2.l,x3.l,of.l;
Solve LP1 US LP min of;
display x1.l,x2.l,x3.l,of.l;