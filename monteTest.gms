scalar
low /0/,
High /1/,
pistimate;
set counter /c1*c200/;
parameter report(counter,*);
report(counter,'x') = uniform(low,high);
report(counter,'y') = uniform(low,high);
pistimate = 4*sum(counter$(power(report(counter,'x')-0.5,2)+power(report(counter,'y')-0.5,2)<=0.25),1)/card(counter);
display report,pistimate;