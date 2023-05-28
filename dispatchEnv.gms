set Gen /g1*g5/;
Parameters report(gen,*);
scalar Load /400/
Eprice /0.1/
Elim /90000/;
Table data(Gen,*)
         a       b       c       d       e       f       Pmin    Pmax
g1       3       20      100     2       -5      3       28      206
g2       4.05    18.07   98.87   3.82    -4.24   6.09    90      284
g3       4.05    15.55   104.26  5.01    -2.15   5.69    68.00   189.00
g4       3.99    19.21   107.21  1.10    -3.99   6.20    76.00   266.00
g5       3.88    26.18   95.31   3.55    -6.88   5.57    19.00   53.00;
Variables P(gen),of,Te,Tc;
equations
eq1,
eq2,
eq3,
eq4;
eq1 .. Tc =e= sum(gen,data(gen,'a')*P(gen)*P(gen)+data(gen,'b')*P(gen)+data(gen,'c'));
eq2 .. sum(gen,P(gen)) =g= Load;
eq3 .. Te =e= sum(gen,data(gen,'d')*P(gen)*P(gen)+data(gen,'e')*P(gen)+data(gen,'f'));
eq4 .. of =e= Tc+Te*Eprice;
P.lo(gen) = data(gen,'Pmin');
P.up(gen) = data(gen,'Pmax');
model END /eq1,eq2,eq3,eq4/;
solve END us QCP min Tc;
report(gen,'ED')=P.l(gen);
solve END us QCP min Te;
report(gen,'END')=P.l(gen);
solve END us QCP min of;
report(gen,'penalty')=P.l(gen);
Te.up=Elim;
solve END us QCP min Tc;
report(gen,'limit')=P.l(gen);
display report;