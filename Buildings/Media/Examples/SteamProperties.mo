within Buildings.Media.Examples;
model SteamProperties
  "Model that tests the implementation of the fluid properties"
  extends Modelica.Icons.Example;
  extends Buildings.Media.Examples.BaseClasses.SteamProperties(
    redeclare package Medium = Modelica.Media.Water.WaterIF97_ph,
    TMin=293.15,
    TMax=673.15);
equation
  // Check the implementation of the base properties
  basPro.state.p=p;
  basPro.state.h=h;
   annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Examples/WaterProperties.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks thermophysical properties of the medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 19, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamProperties;
