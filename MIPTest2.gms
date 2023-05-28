Sets
i /1*4/,
j /1*4/;
alias (i,row);
alias (j,col);
Variable of;
Binary Variable x(i,j);
Equations
eq1,
eq2,
eq3,
eq4,
eq5;
eq1(j) .. sum(i,x(i,j)) =l= 1;
eq2(i) .. sum(j,x(i,j)) =l= 1;
eq3 .. sum((i,j),x(i,j)) =e= of;
eq4(i,j) .. sum((row,col)$((ord(i)-ord(row))=(ord(j)-ord(col))),x(row,col)) =l= 1;
eq5(i,j) .. sum((row,col)$((ord(i)-ord(row))=-(ord(j)-ord(col))),x(row,col)) =l= 1;
Model MIP2a /eq1,eq2,eq3/;
Model MIP2b /all/;
Solve MIP2a US MIP max of;
display x.l,of.l;
Solve MIP2b US MIP max of;
display x.l,of.l;