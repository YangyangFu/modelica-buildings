within Buildings.Fluid.HeatExchangers.CoolingTowers.Data.BaseClasses;
record CoolingTower "Base classes for chiller models"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal
    "Nominal mass flow at air side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal
    "Nominal mass flow at water side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TAirInWB_nominal
    "Temperature of air entering cooling tower at nominal condition"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TWatIn_nominal
    "Temperature of water entering cooling tower at nominal condition"
    annotation (Dialog(group="Nominal condition"));

  parameter Real FRAirMin(min=0) = 0.2 "Minimum value for air flow fraction"
    annotation (Dialog(group="Performance curves"));
  parameter Real FRAirMax(min=0)= 1.0 "Maximum value for ari flow fraction"
    annotation (Dialog(group="Performance curves"));
  parameter Real FRWatMin(min=0) = 0.3 "Minimum value for water flow fraction"
    annotation (Dialog(group="Performance curves"));
  parameter Real FRWatMax(min=0) = 1.0 "Maximum value for water flow fraction"
    annotation (Dialog(group="Performance curves"));
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This is the base record for chiller models.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 27, 2016, by Michael Wetter:<br/>
Corrected wrong documentation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/545\">issue 545</a>.
</li>
<li>
September 15, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTower;
