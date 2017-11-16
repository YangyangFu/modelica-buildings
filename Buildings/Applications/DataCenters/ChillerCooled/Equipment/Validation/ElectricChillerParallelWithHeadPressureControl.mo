within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model ElectricChillerParallelWithHeadPressureControl
  "Model that test electric chiller parallel with head pressure control activated"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water "Medium model";
  package Medium2 = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.Power P_nominal=-per1.QEva_flow_nominal/per1.COP_nominal
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per1.mEva_flow_nominal
    "Nominal mass flow rate at evaporator";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per1.mCon_flow_nominal
    "Nominal mass flow rate at condenser";
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
    per1 "Chiller performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_563kW_10_61COP_Vanes
    per2 "Chiller performance data"
    annotation (Placement(transformation(extent={{32,80},{52,100}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.ElectricChillerParallel chiPar(
    num=2,
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=mEva_flow_nominal,
    m2_flow_nominal=mCon_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000,
    dpValve_nominal={6000,6000},
    per={per1,per2},
    activate_ThrWayVal=true)
    "Identical chillers"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID heaPreCon[2](
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each yMax=1,
    each reset=Buildings.Controls.OBC.CDL.Types.Reset.Disabled,
    each reverseAction=true,
    each yMin=0.3,
    each Ti=60,
    each k=0.1)              "Head pressure PI controller"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add TCWLeaSet[2]
    "Leaving condenser water temperature setpoint for head pressure control"
    annotation (Placement(transformation(extent={{-90,-10},{-70,-30}})));
  Modelica.Blocks.Sources.Constant temDif(k=11)
    "Temperature lift for head pressure control"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    m_flow=mCon_flow_nominal,
    T=298.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,68},{-40,88}})));
  Modelica.Blocks.Sources.Constant TCon_in(k=273.15 + 10)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-98,72},{-78,92}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=mEva_flow_nominal,
    T=291.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,-58},{40,-38}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium1,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{32,30},{52,50}})));
  Buildings.Fluid.Sources.FixedBoundary sin1(
    redeclare package Medium = Medium1,
    nPorts=1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={70,40})));
  Buildings.Fluid.Sources.FixedBoundary sin2(
    redeclare package Medium = Medium2,
    nPorts=1)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-90,-70})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    dp_nominal=6000,
    redeclare package Medium = Medium2,
    m_flow_nominal=mEva_flow_nominal)
    "Flow resistance"
    annotation (Placement(transformation(extent={{-40,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=5,
    startTime=3600,
    duration=3600,
    offset=273.15 + 16)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,-54},{80,-34}})));
  Modelica.Blocks.Sources.Ramp TSet(
    duration=3600,
    startTime=3*3600,
    height=8,
    offset=273.15 + 7)
    "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Sources.BooleanConstant on "On signal"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
equation
  connect(chiPar.port_b1, res1.port_a)
    annotation (Line(points={{10,16},{26,16},{26,40},{32,40}},
                            color={0,127,255}));
  connect(res2.port_a, chiPar.port_b2)
    annotation (Line(points={{-40,-70},{-24,-70},{-24,4},{-10,4}},
                            color={0,127,255}));
  connect(TSet.y, chiPar.TSet)
    annotation (Line(points={{-99,0},{-18,0},{-18,7},{-12,7}},
      color={0,0,127}));
  connect(chiPar.TCWLea, heaPreCon.u_m) annotation (Line(points={{11,12},{20,12},
          {20,-40},{-50,-40},{-50,-32}}, color={0,0,127}));
  connect(TCWLeaSet.y, heaPreCon.u_s)
    annotation (Line(points={{-69,-20},{-62,-20}},
                                                color={0,0,127}));
  connect(heaPreCon.y, chiPar.yHeaPreCon) annotation (Line(points={{-39,-20},{-20,
          -20},{-20,18},{-12,18}}, color={0,0,127}));
  connect(temDif.y, TCWLeaSet[1].u1) annotation (Line(points={{-99,-40},{-96,-40},
          {-96,-26},{-92,-26}},
                              color={0,0,127}));
  connect(temDif.y, TCWLeaSet[2].u1) annotation (Line(points={{-99,-40},{-96,-40},
          {-96,-26},{-92,-26}},
                              color={0,0,127}));
  connect(TSet.y, TCWLeaSet[1].u2) annotation (Line(points={{-99,0},{-96,0},{-96,
          -14},{-92,-14}},color={0,0,127}));
  connect(TSet.y, TCWLeaSet[2].u2) annotation (Line(points={{-99,0},{-96,0},{-96,
          -14},{-92,-14}},color={0,0,127}));
  connect(sin2.ports[1], res2.port_b)
    annotation (Line(points={{-80,-70},{-60,-70}}, color={0,127,255}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{79,-44},{62,-44}}, color={0,0,127}));
  connect(TCon_in.y, sou1.T_in) annotation (Line(points={{-77,82},{-62,82}},
                         color={0,0,127}));
  connect(res1.port_b, sin1.ports[1])
    annotation (Line(points={{52,40},{60,40}}, color={0,127,255}));
  connect(on.y, chiPar.on[1]) annotation (Line(points={{-99,50},{-18,50},{-18,11},
          {-12,11}}, color={255,0,255}));
  connect(on.y, chiPar.on[2]) annotation (Line(points={{-99,50},{-18,50},{-18,13},
          {-12,13}}, color={255,0,255}));
  connect(chiPar.port_a2, sou2.ports[1]) annotation (Line(points={{10,4},{18,4},
          {18,4},{26,4},{26,-48},{40,-48}}, color={0,127,255}));
  connect(sou1.ports[1], chiPar.port_a1) annotation (Line(points={{-40,78},{-24,
          78},{-24,16},{-10,16}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-120,-100},{100,100}})),
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/ElectricChillerParallelWithHeadPressureControl.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example demonstrates how the head pressure control can be implemented in a chiller parallel.
</p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=14400,
      Tolerance=1e-06));
end ElectricChillerParallelWithHeadPressureControl;
