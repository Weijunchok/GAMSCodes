Sets
t /t1*t24/,
H /h1*h4/,
i /g1*g5/;
Scalar zeta /14/;
Table data(H,*)
         c1      c2      c3      c4      c5      c6
h1       -0.0042 -0.44   0.040   0.80    11.0    -53
h2       -0.0043 -0.32   0.013   1.24    9.7     -71
h3       -0.0015 -0.31   0.012   0.54    5.7     -42
h4       -0.0032 -0.33   0.025   1.43    14.1    -91;
Table gendata(i,*)
         a       b       c       Pmin    Pmax    RU      RD
g1       0.00043 16.6    900     100     400     60      60
g2       0.00073 15.5    800     130     400     40      40
g3       0.00059 14.8    700     70      300     60      60
g4       0.00075 15.9    470     60      300     30      30
g5       0.00079 16.6    200     80      250     50      50;
Alias(H,Hhat);
set upstream(H,Hhat);
upstream('h3',Hhat)$(ord(Hhat)<3)=yes;
upstream('h4','h3')=yes;
Parameter delay(H)
/ h1 2
  h2 1
  h3 4
  h4 0/;
Table inflow(t,H)
         h1      h2      h3      h4
t1       10      8       8.1     2.8
t2       9       8       8.2     2.4
t3       8       9       4       1.6
t4       7       9       2       0
t5       6       8       3       0
t6       7       7       4       0
t7       8       6       3       0
t8       9       7       2       0
t9       10      8       1       0
t10      11      9       1       0
t11      12      9       1       0
t12      10      8       2       0
t13      11      8       4       0
t14      12      9       3       0
t15      11      9       3       0
t16      10      8       2       0
t17      9       7       2       0
t18      8       6       2       0
t19      7       7       1       0
t20      6       8       1       0
t21      7       9       2       0
t22      8       9       2       0
t23      9       8       1       0
t24      10      8       0       0;
Parameter demand(t)
/
t1       1275
t2       1326
t3       1190
t4       1105
t5       1139
t6       1360
t7       1615
t8       1717
t9       1853
t10      1836
t11      1870
t12      1955
t13      1887
t14      1751
t15      1717
t16      1802
t17      1785
t18      1904
t19      1819
t20      1785
t21      1547
t22      1462
t23      1445
t24      1360/;
Table charac (H,*)
         Vmin    Vmax    Vini    Vfin    Qmin    Qmax    Pmin    Pmax
h1       80      150     100     120     5       15      0       500
h2       60      120     80      70      6       15      0       500
h3       100     240     170     170     10      30      0       500
h4       70      160     120     140     6       20      0       500;
Variables V(H,t),R(H,t),Spill(H,t),OF,PH(H,t),costThermal,P(i,t);
P.up(i,t) = gendata(i,'Pmax');
P.lo(i,t) = gendata(i,'Pmin');
V.lo(H,t) = charac(H,'Vmin');
V.up(H,t) = charac(H,'Vmax');
V.fx(H,'t24') = charac(H,'Vfin');
PH.lo(H,t) = charac(H,'Pmin');
PH.up(H,t) = charac(H,'Qmax');
R.lo(H,t) = charac(H,'Qmin');
R.up(H,t) = charac(H,'Qmax');
Spill.lo(H,t) = 0;

Equations
Waterlevel,
pcalc,
genconst3,
genconst4,
costThermalcalc,
balance,
ofdef;
costThermalcalc .. costThermal =e= sum((t,i),gendata(i,'a')*power(P(i,t),2)+gendata(i,'b')*P(i,t)+gendata(i,'c'));
Genconst3(i,t) .. P(i,t+1)-P(i,t) =l= gendata(i,'RU');
Genconst4(i,t) .. P(i,t-1)-P(i,t) =l= gendata(i,'RD');
Waterlevel(H,t+1) .. V(H,t+1) =e= charac(H,'Vini')$(ord(t)=1)+V(H,t)$(ord(t)>1)
+inflow(t+1,H)-R(H,t+1)-Spill(H,t+1)
+0.9*sum(Hhat$upstream(H,Hhat),R(Hhat,t-delay(H))+Spill(Hhat,t-delay(H)));
pcalc(H,t) .. Ph(H,t) =e= data(H,'c1')*V(H,t)*V(H,t)+data(H,'c2')*R(H, t)*R(H, t)
+data(H,'c3')*V(H, t)*R(H, t)
+data(H,'c4')*V(H, t)+data(H,'c5')*R(H, t)
+data (H,'c6');
balance(t) .. sum(i,P(i,t))+sum(H,Ph(H,t)) =g= demand(t);
ofdef .. of =e= zeta*sum((H,t),Ph(H,t))+costThermal;
model hydro /all/;
solve hydro us nlp min of;
display Ph.l,P.l;
