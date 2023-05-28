Variables x,of;
Binary Variables y;
Equations
eq1
eq2
eq3;
eq1 .. -3*x+2*y =g= 1;
eq2 .. -8*x+10*y =l= 10;
eq3 .. x+y =e= of;
model MIP1 /all/;
x.up=0.3;
Solve MIP1 US MIP max of;
display x.l,y.l,of.l;