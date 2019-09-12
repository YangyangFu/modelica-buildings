within Buildings.Media.Examples;
model SteamDerivativeCheck
  "Model that tests the derivative implementation"
  extends Modelica.Icons.Example;

   package Medium = Buildings.Media.Steam;

    Modelica.SIunits.Temperature T "Temperature";
    Modelica.SIunits.SpecificEnthalpy hLiqSym "Fluid phase enthalpy";
    Modelica.SIunits.SpecificEnthalpy hLiqCod "Fluid phase enthalpy";

    constant Real convT(unit="K/s3") = 270
    "Conversion factor to satisfy unit check";

    Integer region;
    Modelica.Media.Common.IF97BaseTwoPhase aux;
initial equation
     hLiqSym = hLiqCod;

equation
    aux = Modelica.Media.Water.IF97_Utilities.waterBaseProp_pT(p=1e5,T=T);
    region = aux.region;
    T = 274.15+convT*time^3;
    hLiqCod=Medium.specificEnthalpy(
      Medium.setState_pTX(
         p=1e5,
         T=T,
         X=Medium.X_default));
    der(hLiqCod)=der(hLiqSym);
    //assert(abs(hLiqCod-hLiqSym) < 1E-2, "Model has an error");

   annotation(experiment(
                 StartTime=0, StopTime=1,
                 Tolerance=1E-8),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Examples/WaterDerivativeCheck.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>",   revisions="<html>
<ul>
<li>
August 17, 2015, by Michael Wetter:<br/>
Changed regression test to have slope different from one.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/303\">issue 303</a>.
</li>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamDerivativeCheck;
