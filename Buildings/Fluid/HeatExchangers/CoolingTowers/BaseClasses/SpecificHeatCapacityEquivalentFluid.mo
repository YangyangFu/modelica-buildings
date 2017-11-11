within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses;
block SpecificHeatCapacityEquivalentFluid
  "Specific heat capacity for equivalent fluid"
  Modelica.Blocks.Interfaces.RealInput T1 "Inlet temperature"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput T2 "Outlet temperature"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.h_TWetBul h1(use_p_in=false)
    "Specific enthalpy pf equivalent fluid at inlet "
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.h_TWetBul h2(use_p_in=false)
    "Specific enthalpy of equvilaent fluid at outlet"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k1=1, final k2=-1) "Addition 1"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=1, final k2=-1) "Addition 1"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput cpe(
    quantity="SpecificHeatCapacity",
    unit="J/(kg.K)",
    start = 1006)
    "Specific heat capacity for the equavilalent fluid"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(T1, h1.TWetBul)
    annotation (Line(points={{-120,50},{-82,50}}, color={0,0,127}));
  connect(T2, h2.TWetBul)
    annotation (Line(points={{-120,-50},{-82,-50}}, color={0,0,127}));
  connect(h2.h, add1.u2)
    annotation (Line(points={{-59,-50},{-50,-50},{-50,24},{
          -22,24}}, color={0,0,127}));
  connect(h1.h, add1.u1)
    annotation (Line(points={{-59,50},{-40,50},{-40,36},{-22,
          36}}, color={0,0,127}));
  connect(T1, add2.u1)
    annotation (Line(points={{-120,50},{-88,50},{-88,-10},{-32,
          -10},{-32,-24},{-22,-24}}, color={0,0,127}));
  connect(T2, add2.u2)
    annotation (Line(points={{-120,-50},{-88,-50},{-88,-16},{
          -40,-16},{-40,-36},{-22,-36}}, color={0,0,127}));
  connect(add1.y, div.u1)
    annotation (Line(points={{1,30},{20,30},{20,6},{38,6}}, color={0,0,127}));
  connect(add2.y, div.u2)
    annotation (Line(points={{1,-30},{20,-30},{20,-6},{38,
          -6}}, color={0,0,127}));
  connect(div.y, cpe)
    annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
        Text(
          extent={{-54,36},{54,-26}},
          lineColor={0,0,0},
          textString="Cpe")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block calculates the specific heat capacity for an equivalent fluid used in Merkel's cooling tower model.
The cooling tower model can be modeled by an equivalent counterflow heat exchanger. The first fluid is water and
the second fluid is an equivalent fluid entering the heat exchanger at Twb,in and specific heat cpe. The <i>Cp<sub>e</sub></i> 
is calculated as following:
</p>
<p align='center'>
 <i>
 Cp<sub>e</sub> = (T<sub>wb,in</sub> - T<sub>wb,out</sub>) / (h<sub>in</sub> - h<sub>out</sub>)
 </i>
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2017, by Yangyang Fu:<br/>
First implementation
</li>
</ul>
</html>"));
end SpecificHeatCapacityEquivalentFluid;
