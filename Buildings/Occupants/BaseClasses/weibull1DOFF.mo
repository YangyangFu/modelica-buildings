within Buildings.Occupants.BaseClasses;
function weibull1DOFF "Mapping a continuous input to a binary output through a Weibull Distribution Relation"
    input Real x "Continous variable";
    input Real u=1.0 "Parameter defining the Weibull Distribution: threshold";
    input Real L=1.0 "Parameter defining the Weibull Distribution: normalization factor";
    input Real k=1.0 "Parameter defining the Weibull Distribution: shape factor";
    input Real dt=60 "Time step length";
    input Integer globalSeed "Seed for the random number generator";
    output Boolean y "Binary variable 0/1";
protected
    Real p =  if x<=u then 1 - Modelica.Math.exp(-((u-x)/L)^k*dt) else 0;
algorithm
    y := Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=p,globalSeed=globalSeed);
  annotation (Documentation(info="<html>
<p>
This function generates a random binary variable with a continuous inputs x from a Weibull 
Distribution relation.
</p>
<p>
The probability of being 1 is calculated from the input x from a Weibull Distribution relation with 
three predefined parameters u (threshold, the output would be 0 if x is bigger than u), 
L (normalization faction) and k (shape factor). Then a random generator generates the output, 
which should be a binary variable.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end weibull1DOFF;
