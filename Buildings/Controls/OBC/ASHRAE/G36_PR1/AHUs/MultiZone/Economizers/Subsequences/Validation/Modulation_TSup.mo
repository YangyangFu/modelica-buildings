within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Validation;
model Modulation_TSup
  "Validation model for multi zone VAV AHU outdoor and return air damper position modulation sequence"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Temperature TSupSet=291.15
    "Supply air temperature setpoint";

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Modulation ecoMod
    "Economizer modulation sequence"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSetSig(
    final k=TSupSet) "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Ramp TSup(
    final duration=900,
    final height=4,
    final offset=TSupSet - 2) "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMin(final k=0)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMax(final k=1)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant RetDamPosMin(final k=0)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant RetDamPosMax(final k=1)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation
  connect(TSup.y,ecoMod.TSup)  annotation (Line(points={{-39,70},{-30,70},{-30,36},
          {39,36}},color={0,0,127}));
  connect(RetDamPosMax.y, ecoMod.uRetDamPosMax) annotation (Line(points={{-59,-40},
          {-20,-40},{-20,24},{-6,24},{39,24}}, color={0,0,127}));
  connect(RetDamPosMin.y, ecoMod.uRetDamPosMin) annotation (Line(points={{-59,-70},
          {8,-70},{8,16},{8,21},{39,21}},color={0,0,127}));
  connect(outDamPosMax.y, ecoMod.uOutDamPosMax) annotation (Line(points={{-59,20},
          {-48,20},{-30,20},{-30,31},{39,31}}, color={0,0,127}));
  connect(outDamPosMin.y, ecoMod.uOutDamPosMin) annotation (Line(points={{-59,-10},
          {-34,-10},{-24,-10},{-24,28},{39,28}}, color={0,0,127}));
  connect(TSupSetSig.y,ecoMod.TSupSet)  annotation (Line(points={{1,70},{20,70},{20,39},{39,39}}, color={0,0,127}));
  annotation (
  experiment(StopTime=900.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/Economizers/Subsequences/Validation/Modulation_TSup.mos"
    "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Modulation\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Modulation</a>
for supply air temeperature <code>TSup</code> and supply air temperature heating setpoint <code>TSupSet</code>
control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Modulation_TSup;
