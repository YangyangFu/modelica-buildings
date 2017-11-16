within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model PartialParallelElectricEIR
  "Partial model for electric chiller parallel"
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialPlantParallel(
    final numVal = 2,
    final m_flow_nominal = {m1_flow_nominal,m2_flow_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
      Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)},
    val2(each final dpFixed_nominal=dp2_nominal),
    val1(each final dpFixed_nominal=dp1_nominal));
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.ThreeWayValveParameters;

  parameter Modelica.SIunits.Time tau1 = 30
    "Time constant at nominal flow in chillers"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition",
       enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Modelica.SIunits.Time tau2 = 30
    "Time constant at nominal flow in chillers"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition",
       enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium1.AbsolutePressure p1_start = Medium1.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.Temperature T1_start = Medium1.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.MassFraction X1_start[Medium1.nX] = Medium1.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nXi > 0));
  parameter Medium1.ExtraProperty C1_start[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames)=fill(0, Medium1.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));
  parameter Medium1.ExtraProperty C1_nominal[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames) = fill(1E-2, Medium1.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));
  parameter Medium2.AbsolutePressure p2_start = Medium2.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.Temperature T2_start = Medium2.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.MassFraction X2_start[Medium2.nX] = Medium2.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nXi > 0));
  parameter Medium2.ExtraProperty C2_start[Medium2.nC](
    final quantity=Medium2.extraPropertiesNames)=fill(0, Medium2.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));
  parameter Medium2.ExtraProperty C2_nominal[Medium2.nC](
    final quantity=Medium2.extraPropertiesNames) = fill(1E-2, Medium2.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));
  parameter Modelica.SIunits.Time tau_ThrWayVal=10
    "Time constant at nominal flow for dynamic energy and momentum balance of the three-way valve"
    annotation(Dialog(tab="Dynamics", group="Nominal condition",
               enable=(activate_ThrWayVal and not energyDynamics ==
               Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Real yThrWayVal_start=1
    "Initial value of output"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
      enable=activate_ThrWayVal and use_inputFilter));

  // Temperature sensor
  parameter Modelica.SIunits.Time tauSenT=1
    "Time constant at nominal flow rate (use tau=0 for steady-state sensor,
    but see user guide for potential problems)"
   annotation(Dialog(tab="Dynamics", group="Temperature Sensor",
     enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Modelica.Blocks.Types.Init initTSenor = Modelica.Blocks.Types.Init.InitialState
    "Type of initialization of the temperature sensor (InitialState and InitialOutput are identical)"
  annotation(Evaluate=true, Dialog(tab="Dynamics", group="Temperature Sensor"));


  Modelica.Blocks.Interfaces.RealInput TSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Set point for leaving water temperature"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput yHeaPreCon[num] if activate_ThrWayVal
    "Actuator position for head pressure control in chillers (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput P[num](
    each final quantity="Power",
    each final unit="W")
    "Electric power consumed by chiller compressor"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  replaceable Buildings.Fluid.Chillers.BaseClasses.PartialElectric chi[num](
    redeclare each replaceable package Medium1 = Medium1,
    redeclare each replaceable package Medium2 = Medium2,
    each final allowFlowReversal1=allowFlowReversal1,
    each final allowFlowReversal2=allowFlowReversal2,
    each final show_T=show_T,
    each final from_dp1=from_dp1,
    each final dp1_nominal=0,
    each final linearizeFlowResistance1=linearizeFlowResistance1,
    each final deltaM1=deltaM1,
    each final from_dp2=from_dp2,
    each final dp2_nominal=0,
    each final linearizeFlowResistance2=linearizeFlowResistance2,
    each final deltaM2=deltaM2,
    each final homotopyInitialization=homotopyInitialization,
    each final m1_flow_nominal=m1_flow_nominal,
    each final m2_flow_nominal=m2_flow_nominal,
    each final m1_flow_small=m1_flow_small,
    each final m2_flow_small=m2_flow_small,
    each final tau1=tau1,
    each final tau2=tau2,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p1_start=p1_start,
    each final T1_start=T1_start,
    each final X1_start=X1_start,
    each final C1_start=C1_start,
    each final C1_nominal=C1_nominal,
    each final p2_start=p2_start,
    each final T2_start=T2_start,
    each final X2_start=X2_start,
    each final C2_start=C2_start,
    each final C2_nominal=C2_nominal)
    "Identical chillers"
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valHeaPreCon[num](
    redeclare package Medium = Medium1,
    each final dpValve_nominal=6000,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final tau=tau_ThrWayVal,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final deltaM=deltaM,
    each final dpFixed_nominal={0,0},
    each final l=l_ThrWayVal,
    each final R=R,
    each final delta0=delta0,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTimeValve,
    each final init=initValve,
    each final y_start=yThrWayVal_start,
    each final p_start=p1_start,
    each final T_start=T1_start,
    each final X_start=X1_start,
    each final C_start=C1_start,
    each final C_nominal=C1_nominal,
    each final m_flow_nominal=m1_flow_nominal,
    each final fraK=fraK_ThrWayVal,
    each final from_dp=from_dp1,
    each final portFlowDirection_1=portFlowDirection_1,
    each final portFlowDirection_2=portFlowDirection_2,
    each final portFlowDirection_3=portFlowDirection_3,
    each final linearized={linearizeFlowResistance1,linearizeFlowResistance1},
    each final homotopyInitialization=homotopyInitialization,
    final rhoStd=rhoStd) if                                      activate_ThrWayVal
    "Three way valve for head pressure control in chillers, activated only when activate_ThrWayVal=true"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,30})));

  Fluid.Sensors.TemperatureTwoPort senT[num](
    redeclare each final replaceable package Medium = Medium2,
    each final m_flow_nominal=m1_flow_nominal,
    each final tau=tauSenT,
    each final initType=initTSenor,
    each final T_start=T1_start,
    each final allowFlowReversal=allowFlowReversal1,
    each final m_flow_small=m1_flow_small)
    "Temperature sensor of leaving condenser water in chillers" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={34,4})));
  Modelica.Blocks.Interfaces.RealOutput TCWLea[num]
    "Temperature of the leaving condenser water"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
equation
  for i in 1:num loop
  connect(TSet, chi[i].TSet)
    annotation (Line(points={{-120,-30},{-90,-30},{-90,-5},{-12,-5}},
      color={0,0,127}));
  connect(chi[i].port_a2, port_a2)
    annotation (Line(points={{10,-8},{60,-8},{60,-60},{100,-60}},
      color={0,127,255}));
  end for;
  connect(chi.port_b2, val2.port_a)
    annotation (Line(points={{-10,-8},{-60,-8},{-60,-30}},
      color={0,127,255}));
  connect(chi.P, P)
    annotation (Line(points={{11,7},{14,7},{14,68},{80,68},{80,40},{110,40}},
        color={0,0,127}));
  if activate_ThrWayVal then
    for i in 1:num loop
    connect(port_a1, valHeaPreCon[i].port_1)
      annotation (Line(points={{-100,60},{-40,60},{-40,40}}, color={0,127,255}));
    end for;
    connect(valHeaPreCon.port_3, val1.port_a)
      annotation (Line(points={{-30,30},{60,30}}, color={0,127,255}));
    connect(valHeaPreCon.port_2, chi.port_a1)
      annotation (Line(points={{-40,20},{-40,4},{-10,4}}, color={0,127,255}));
    connect(valHeaPreCon.y, yHeaPreCon)
      annotation (Line(points={{-52,30},{-88,30},
          {-88,80},{-120,80}}, color={0,0,127}));
  else
    for i in 1:num loop
      connect(port_a1, chi[i].port_a1)
        annotation (Line(points={{-100,60},{-24,60},{
          -24,4},{-10,4}}, color={0,127,255}));
    end for;
  end if;
  connect(on, chi.on)
    annotation (Line(points={{-120,20},{-90,20},{-90,1},{-12,1}},
        color={255,0,255}));
  connect(senT.T, TCWLea)
    annotation (Line(points={{34,15},{34,20},{110,20}}, color={0,0,127}));
  connect(chi.port_b1, senT.port_a)
    annotation (Line(points={{10,4},{24,4}}, color={0,127,255}));
  connect(senT.port_b, val1.port_a)
    annotation (Line(points={{44,4},{60,4},{60,30}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Partial model that implements the parallel electric chillers with associated valves.
The parallel have <code>num</code> identical chillers.
</p>
</html>",
        revisions="<html>
<ul>
<li>
November 15, 2017, by Yangyang Fu:<br/>
Add three-way valves for head pressure control.
</li>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          extent={{-44,74},{-40,56}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,76},{60,72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          radius=45),
        Rectangle(
          extent={{38,72},{42,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,20},{60,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          radius=45),
        Polygon(
          points={{-42,48},{-52,36},{-32,36},{-42,48}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,36},{-40,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,46},{-52,58},{-32,58},{-42,46}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{28,60},{52,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,60},{30,42},{50,42},{40,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-58},{60,-62}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          radius=45),
        Rectangle(
          extent={{38,-6},{42,-58}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{28,-18},{52,-42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-18},{30,-36},{50,-36},{40,-18}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-2},{60,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          radius=45),
        Rectangle(
          extent={{-44,-6},{-40,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,-32},{-52,-20},{-32,-20},{-42,-32}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,-30},{-52,-42},{-32,-42},{-42,-30}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-42},{-40,-58}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PartialParallelElectricEIR;
