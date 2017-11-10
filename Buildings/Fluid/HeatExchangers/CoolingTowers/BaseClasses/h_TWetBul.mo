within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses;
model h_TWetBul "Enthalpy as a function of wetbulb temperature"
  extends
    Buildings.Utilities.Psychrometrics.BaseClasses.HumidityRatioVaporPressure;
  Modelica.Blocks.Interfaces.RealInput TWetBul "Wetbulb temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Utilities.Psychrometrics.X_pTphi X_TWet(
    final use_p_in=use_p_in,
    final p=p)
    "Mass fraction as a function of wetbulb temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Interfaces.RealOutput h(
    quantity="SpecificEnergy",
    min=-1.0e10,
    max=1.0e10,
    displayUnit="J/kg")
    "Steam mass fraction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  package Medium = Buildings.Media.Air "Medium model";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=1)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  h = Medium.specificEnthalpy_pTX(
    p=p_in_internal,
    T=TWetBul,
    X=X_TWet.X);
  connect(p_in, X_TWet.p_in) annotation (Line(points={{-120,60},{-52,60},{-52,6},
          {-42,6}}, color={0,0,127}));
  connect(TWetBul, X_TWet.T)
    annotation (Line(points={{-120,0},{-42,0}}, color={0,0,127}));
  connect(con.y, X_TWet.phi) annotation (Line(points={{-59,-50},{-52,-50},{-52,-6},
          {-42,-6}}, color={0,0,127}));
   annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end h_TWetBul;
