within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Examples;
model BatteryControl "Example that tests battery control"
  import Buildings;
   extends Modelica.Icons.Example;

  Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.BatteryControl
    batCon(SOCLow=0.01, SOCHig=0.99)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanStep conGri(startTime=120, startValue=true)
    "Connected to grid"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Constant PCha(k=1e4) "Charging power"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Constant PDis(k=-1e4) "Discharging power"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Sources.Sine SOC(
    amplitude=0.5,
    offset=0.5,
    freqHz=1/120) "SOC"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
equation
  connect(conGri.y, batCon.connected) annotation (Line(points={{-79,30},{-40,30},
          {-40,2},{-12,2}}, color={255,0,255}));
  connect(PCha.y, batCon.powCha) annotation (Line(points={{-79,-10},{-40,-10},{
          -40,-2},{-12,-2}}, color={0,0,127}));
  connect(PDis.y, batCon.powDis) annotation (Line(points={{-79,-50},{-38,-50},{
          -38,-6},{-12,-6}}, color={0,0,127}));
  connect(SOC.y, batCon.SOC) annotation (Line(points={{-79,70},{-34,70},{-34,6},
          {-12,6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=240));
end BatteryControl;
