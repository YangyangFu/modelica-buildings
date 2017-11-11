within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model Merkel "Example that validate the Merkel model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Package of medium water";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=122720*1.2/3600
    "Nominal flowrate of air";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=92.7*1000/3600
    "Nominal flowrate of water";
  parameter Modelica.SIunits.Temperature T_a1_nominal=298.75
    "Nominal wetbulb temperature of intet air";
  parameter Modelica.SIunits.Temperature T_a2_nominal=310.93
    "Nominal temperature of inlet water";

  Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel tow1(
    redeclare package Medium = Medium,
    dp_nominal=6000,
    UA_nominal=50000,
    UACor(
      mAir_flow_nominal=m1_flow_nominal,
      mWat_flow_nominal=m2_flow_nominal,
      TAirInWB_nominal=T_a1_nominal,
      TWatIn_nominal=T_a2_nominal),
    PFan_nominal=47208) "Merkel cooling tower"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.Constant y(k=0.5)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-66,40},{-46,60}})));
  Sources.MassFlowSource_T sou(nPorts=2,
    redeclare package Medium = Medium,
    m_flow=m2_flow_nominal)
    "Source"
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
  Sources.Boundary_pT sin(
    nPorts=2,
    redeclare package Medium = Medium)
    "Sink"
    annotation (Placement(transformation(extent={{90,-20},{70,0}})));
  Sensors.TemperatureTwoPort senTem1(redeclare package Medium = Medium,
      m_flow_nominal=m2_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc tow2(
    redeclare package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=6000,
    TAirInWB_nominal=T_a1_nominal,
    TApp_nominal=4.4,
    TRan_nominal=8.3) "York cooling tower"
    annotation (Placement(transformation(extent={{-12,-58},{8,-38}})));
  Sensors.TemperatureTwoPort senTem2(redeclare package Medium = Medium,
      m_flow_nominal=m2_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{22,-58},{42,-38}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,50},{-56,50}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TWetBul, tow1.TAir) annotation (Line(
      points={{-56,50},{-40,50},{-40,4},{-14,4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(y.y, tow1.y) annotation (Line(points={{-39,80},{-20,80},{-20,8},{
          -14,8}}, color={0,0,127}));
  connect(sou.ports[1], tow1.port_a) annotation (Line(points={{-60,-10},{-40,
          -10},{-40,0},{-12,0}}, color={0,127,255}));
  connect(tow1.port_b, senTem1.port_a)
    annotation (Line(points={{8,0},{20,0}}, color={0,127,255}));
  connect(senTem1.port_b, sin.ports[1]) annotation (Line(points={{40,0},{54,
          0},{54,-8},{70,-8}}, color={0,127,255}));
  connect(y.y, tow2.y) annotation (Line(points={{-39,80},{-18,80},{-18,-40},
          {-14,-40}}, color={0,0,127}));
  connect(weaBus.TWetBul, tow2.TAir) annotation (Line(
      points={{-56,50},{-38,50},{-38,-44},{-14,-44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sou.ports[2], tow2.port_a) annotation (Line(points={{-60,-14},{-52,
          -14},{-52,-48},{-12,-48}}, color={0,127,255}));
  connect(tow2.port_b, senTem2.port_a)
    annotation (Line(points={{8,-48},{22,-48}}, color={0,127,255}));
  connect(senTem2.port_b, sin.ports[2]) annotation (Line(points={{42,-48},{
          56,-48},{56,-12},{70,-12}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Examples/Merkel.mos"
        "Simulate and Plot"));
end Merkel;
