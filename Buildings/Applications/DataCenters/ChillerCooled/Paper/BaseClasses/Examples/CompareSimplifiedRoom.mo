within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Examples;
model CompareSimplifiedRoom "Simplified data center room with thermal mass"

  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  parameter Modelica.SIunits.Power QRoo_flow_nominal = 2e6
    "Heat generation of the computer room";
  parameter Modelica.SIunits.Power QRoo_flow = 2e6
    "Heat generation of the computer room";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal= QRoo_flow_nominal/1008/(25-16)
    "Nominal mass flow rate";

  SimplifiedRoomThermalMass roo2(
    nPorts=2,
    redeclare package Medium = Medium,
    QRoo_flow=QRoo_flow,
    m_flow_nominal=m_flow_nominal) "Data center room with thermal mass"
    annotation (Placement(transformation(extent={{-8,-50},{12,-70}})));
  Fluid.Sources.MassFlowSource_T sou(
    nPorts=2,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=m_flow,
    use_m_flow_in=true) "Source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.Sources.FixedBoundary sin(nPorts=2, redeclare package Medium = Medium)
                                            "Sink"
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));

  Modelica.Blocks.Sources.Step ste(
    height=1,
    offset=273.15 + 12,
    startTime=30*3600*24) "Step signal"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  SimplifiedRoom roo1(
    nPorts=2,
    redeclare package Medium = Medium,
    QRoo_flow=QRoo_flow,
    m_flow_nominal=m_flow_nominal) "Data center room without thermal mass"
    annotation (Placement(transformation(extent={{-8,40},{12,60}})));
  Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-22,30})));
  Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-22,-40})));
  parameter Modelica.SIunits.MassFlowRate m_flow=2*m_flow_nominal
    "Fixed mass flow rate going out of the fluid port";
  Modelica.Blocks.Sources.Step mas(
    startTime=30*3600*24,
    height=-m_flow,
    offset=m_flow) "Flowrate"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
equation
  connect(sin.ports[1], roo2.airPorts[1]) annotation (Line(points={{62,2},{40,2},
          {40,-40},{4.475,-40},{4.475,-51.3}}, color={0,127,255}));
  connect(ste.y, sou.T_in) annotation (Line(points={{-79,50},{-70,50},{-70,30},
          {-92,30},{-92,4},{-82,4}}, color={0,0,127}));
  connect(sin.ports[2], roo1.airPorts[1]) annotation (Line(points={{62,-2},{40,
          -2},{40,30},{4.475,30},{4.475,41.3}}, color={0,127,255}));
  connect(sou.ports[1], res1.port_a) annotation (Line(points={{-60,2},{-40,2},{
          -40,30},{-32,30}}, color={0,127,255}));
  connect(res1.port_b, roo1.airPorts[2]) annotation (Line(points={{-12,30},{
          0.425,30},{0.425,41.3}}, color={0,127,255}));
  connect(sou.ports[2], res2.port_a) annotation (Line(points={{-60,-2},{-40,-2},
          {-40,-40},{-32,-40}}, color={0,127,255}));
  connect(res2.port_b, roo2.airPorts[2]) annotation (Line(points={{-12,-40},{
          0.425,-40},{0.425,-51.3}}, color={0,127,255}));
  connect(mas.y, sou.m_flow_in) annotation (Line(points={{-79,-30},{-70,-30},{
          -70,-10},{-94,-10},{-94,8},{-82,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CompareSimplifiedRoom;
