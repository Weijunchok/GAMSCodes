Sets
Gen /g1*g3/,
bus /1*3/,
slack(bus) /3/;
Scalars
Sbase /100/;
alias (bus,node);
Table GenData(Gen,*)
         b       Pmin    Pmax
G1       10      0       65
G2       11      0       100;
set GBconnect(bus,Gen)
/ 1      .       g1
  3      .       g2  /;
Table BusData(bus,*)
         Pd
2        100;
set conex
/ 1      .       2
  2      .       3
  1      .       3 /;
conex(bus,node)$(conex(node,bus))=1;
Table branch(bus,node,*)
                         x       Limit
1        .       2       0.2     100
2        .       3       0.25    100
1        .       3       0.4     100;
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