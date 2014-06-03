within Buildings.Electrical.Interfaces;
partial model PartialInductiveLoad "Partial model of an inductive load"
  extends PartialLoad;
  parameter Real pf(min=0, max=1) = 0.8 "Power factor"  annotation(Evaluate=true,Dialog(group="Nominal conditions"));
protected
  function j = PhaseSystem.j;
  Modelica.SIunits.MagneticFlux psi[2](each stateSelect=StateSelect.prefer);
  Modelica.SIunits.Impedance Z[2];
  Modelica.SIunits.AngularVelocity omega;
  Modelica.SIunits.Power Q = P*tan(acos(pf));
  annotation (Documentation(revisions="<html>
<ul>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included into the Buildings library.
</li>
</ul>
</html>", info="<html>
<p>
This is a model of a generic inductive load. This model is an extension of the base load model
<a href=\"Buildings.Electrical.Interfaces.PartialLoad\">Buildings.Electrical.Interfaces.PartialLoad</a>.
</p>
<p>
This model assumes a fixed power factor <code>pf</code> that is used to compute the reactive power 
<code>Q</code> given the active power <code>P</code>
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q = P * tan(arccos(pf))
</p>
</html>"));
end PartialInductiveLoad;