set Gen /g1*g5/;
scalar Load /400/;
Table data(Gen,*)
         a       b       c       d       e       f       Pmin    Pmax
g1       3       20      100     2       -5      3       28      206
g2       4.05    18.07   98.87   3.82    -4.24   6.09    90      284
g3       4.05    15.55   104.26  5.01    -2.15   5.69    68.00   189.00
g4       3.99    19.21   107.21  1.10    -3.99   6.20    76.00   266.00
g5       3.88    26.18   95.31   3.55    -6.88   5.57    19.00   53.00;
Variables P(gen),of;
equations
eq1,
eq2;
eq1 .. sum(gen,data(gen,'a')*P(gen)*P(gen)+data(gen,'b')*P(gen)+data(gen,'c')) =e= of;
eq2 .. sum(gen,P(gen)) =g= Load;
P.lo(gen) = data(gen,'Pmin');
P.up(gen) = data(gen,'Pmax');
model ECD /all/;
solve ECD us QCP min of;
display P.l,of.l;