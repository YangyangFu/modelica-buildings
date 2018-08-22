﻿within Buildings.Occupants.BaseClasses;
function exponentialVariableGeneration "Random variable generator from the exponential distribution"
    input Real mu  "mean of exponential distribution";
    output Real y "duration of event";
protected
    Integer globalSeed = Modelica.Math.Random.Utilities.automaticGlobalSeed();
    Integer localSeed;
    Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState];
    Real r "Generated random numberin the range 0 < random ≤ 1";
algorithm
    state := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
    (r, state) := Modelica.Math.Random.Generators.Xorshift1024star.random(state);
    y := -mu*Modelica.Math.log(1 - r);
  annotation (Documentation(info="<html>
<p>
This function generates a random variable, from a exponentuial distribution with the input of mean 
mu. The random variable might be the duration of a specific event, for instance the time to keep 
the HVAC on.
</p>
<p>
The input mu denotes the mean value of the exponential distribution. Higher mu indicates a higher 
chance to generate a larger output y. 
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end exponentialVariableGeneration;
