Sets
t /t1*t24/,
Area /A1*A3/,
i /g1*g10/,
w /w1*w2/,
set AreaGen(area,i);
AreaGen(area,i) = no;
AreaGen('A1',i)$(ord(i)<5)=yes;
AreaGen('A2',i)$(ord(i)>4 and ord(i)<8)=yes;
AreaGen('A3',i)$(ord(i)>7)=yes;
Table winddata ( t ,w)
         w1                      w2
t1       0.989432703003337       0.515610651974288
t2       0.932703003337041       0.701561065197429
t3       0.890989988876529       0.740128558310376
t4       0.889877641824249       0.676308539944904
t5       0.914905450500556       0.770431588613407
t6       0.937708565072303       0.785123966942149
t7       0.954393770856507       0.849403122130395
t8       0.956618464961068       0.895316804407714
t24      0.937152391546162       0.557392102846648;
Parameter Windcap(w)
/ w1     250
  w2     350/;
Parameter AreaWind (area ,w);
AreaWind ('A1' , 'w1') = yes;
AreaWind ('A3' , 'w2') = yes;
table Tielim (area , region)
         a1      a2      a3
a1       0       100     400
a2       100     0       500
a3       400     500     0;
table gendata (i ,);
table demand ( t , area );
Variables Tie(area,region,t),OF,P(i,t),Pw(w,t);
Tie.lo(area,region,t) = -Tielim(area,region);
Tie.up(area,region,t) = +Tielim(area,region);
Tie.fx(area,region,t)$(Tielim(area,region)=0)=0;
Tie.fx(area,area,t)=0;
Pw.lo(w,t)=0;
Pw.up(w,t)=winddata(t,w)*Windcap(w);
P.up(i,t) = gendata(i,'Pmax');
P.lo(i,t) = gendata(i,'Pmin');
Equations tieconst , balance , RampUp , RampDn , cost;
tieconst( area , region , t ) .. Tie ( area , region, t)=e=-Tie(region ,area , t ) ;
balance ( area , t ) .. sum (i$AreaGen ( area , i ) ,p( i , t ))+sum (w$AreaWind( area ,w),Pw(w, t ) ) =e= demand ( t , a r e a ) +sum ( region , Tie ( area , region , t ) ) ;
RampUp ( i , t ) .. p ( i , t )-p(i ,t-1) =l= gendata( i , 'RU');
RampDn ( i , t ) .. p ( i , t-1)-p ( i , t ) =l= gendata( i , 'RD');
cost .. OF=e= sum (( i , t ) ,gendata (i , 'a')*p(i , t)*p(i , t )+gendata (i , 'b')*p(i , t)
+gendata (i , 'c') ) ;
Model edc / all / ;
Solve edc min OF us QCP ;