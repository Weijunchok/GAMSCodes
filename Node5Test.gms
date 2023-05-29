Sets
Gen /g1*g5/,
bus /1*5/,
slack(bus) /1/;
Scalars
Sbase /100/;
alias (bus,node);
Table GenData(Gen,*)
         b       Pmin    Pmax
G1       14      0       40
G2       15      0       170
G3       30      0       520
G4       40      0       200
G5       10      0       600;
set GBconnect(bus,Gen)
/ 1      .       g1
  1      .       g2
  3      .       g3
  4      .       g4
  5      .       g5  /;
Table BusData(bus,*)
         Pd
2        300
3        300
4        400;
set conex
/ 1      .       2
  2      .       3
  1      .       4
  1      .       5
  3      .       4
  4      .       5 /;
conex(bus,node)$(conex(node,bus))=1;
Table branch(bus,node,*)
                         x       Limit
1        .       2       0.0281  400
2        .       3       0.0108  400
1        .       4       0.0304  400
1        .       5       0.0064  400
3        .       4       0.0297  400
4        .       5       0.0297  240;
branch(bus,node,'x')$(branch(bus,node,'x')=0)=branch(node,bus,'x');
branch(bus,node,'Limit')$(branch(bus,node,'Limit')=0)=branch(node,bus,'Limit');
branch(bus,node,'bij')$conex(bus,node)=1/branch(bus,node,'x');
Variables Pg(gen),of,delta(bus),Pij(bus,node);
Equations
const1,
const2,
const3;
const1(bus,node)$conex(bus,node) .. Pij(bus,node) =e= branch(bus,node,'bij')*(delta(bus)-delta(node));
const2(bus) .. +sum(Gen$GBconnect(bus,Gen),Pg(Gen))-BusData(bus,'Pd')/Sbase =e=
               +sum(node$conex(node,bus),Pij(bus,node));
const3 .. of=g=sum(Gen,Pg(gen)*GenData(Gen,'b')*Sbase);
model loadflow /all/;
Pg.lo(gen) = Gendata(gen,'Pmin')/Sbase;
Pg.up(gen) = Gendata(gen,'Pmax')/Sbase;
delta.up(bus) = pi;
delta.lo(bus) = -pi;
delta.fx(slack) = 0;
Pij.up(bus,node)$((conex(bus,node)))=1*branch(bus,node,'Limit')/Sbase;
Pij.lo(bus,node)$((conex(bus,node)))=-1*branch(bus,node,'Limit')/Sbase;
Solve loadflow minimizing of using lp;
parameter report(bus,*),Congestioncost;
report(bus,'Gen(MW)') = sum(Gen$GBconnect(bus,Gen),Pg.l(Gen))*Sbase;
report(bus,'Angle') = delta.l(bus);
report(bus,'Load(MW)')= Busdata(bus,'Pd');
report(bus,'LMP($/MWh)')=const2.m(bus)/Sbase;
Congestioncost = sum((bus,node),Pij.l(bus,node)*(-const2.m(bus)+const2.m(node)))/2;
display report,Pij.l,Congestioncost;