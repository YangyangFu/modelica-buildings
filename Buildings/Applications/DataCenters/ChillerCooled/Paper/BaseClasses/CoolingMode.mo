within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses;
model CoolingMode
  "Mode controller for integrated waterside economizer and chiller"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Time tWai "Waiting time";
  parameter Modelica.SIunits.TemperatureDifference deaBan1
    "Dead band width 1 for switching chiller on ";
  parameter Modelica.SIunits.TemperatureDifference deaBan2
    "Dead band width 2 for switching waterside economizer off";
  parameter Modelica.SIunits.TemperatureDifference deaBan3
    "Dead band width 3 for switching waterside economizer on ";
  parameter Modelica.SIunits.TemperatureDifference deaBan4
    "Dead band width 4 for switching chiller off";

  Modelica.Blocks.Interfaces.RealInput TCHWRetWSE(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature of entering chilled water that flows to waterside economizer "
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupWSE(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature of leaving chilled water that flows out from waterside economizer"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Supply chilled water temperature setpoint "
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TApp(
    final quantity="TemperatureDifference",
    final unit="K",
    displayUnit="degC") "Approach temperature in the cooling tower"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.IntegerOutput y
    "Cooling mode signal, integer value of Buildings.Applications.DataCenters.Types.CoolingMode"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=on and connected and TCHWSupWSE > TCHWSupSet + deaBan1)
    "Fire condition 2: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,10})));
  Modelica.StateGraph.StepWithSignal parMecCoo(nIn=2, nOut=4)
    "Partial mechanical cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,-20})));
  Modelica.StateGraph.StepWithSignal        freCoo(nIn=2, nOut=3)
    "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,40})));
  Modelica.StateGraph.StepWithSignal fulMecCoo(nOut=3)
    "Fully mechanical cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,-82})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=on and connected and TCHWRetWSE < TCHWSupWSE + deaBan2)
    "Fire condition 3: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,-50})));
  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=on and connected and TCHWRetWSE > TWetBul + TApp + deaBan3)
    "Fire condition 4: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-54})));
  Modelica.StateGraph.Transition con5(
    enableTimer=true,
    waitTime=tWai,
    condition=on and connected and TCHWSupWSE <= TCHWSupSet + deaBan4)
    "Fire condition 5: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-24,10})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Wet bulb temperature of outdoor air"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.MathInteger.MultiSwitch swi(
    y_default=0,
    nu=5,
    expr={Integer(Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.Off),
        Integer(Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.FreeCooling),
        Integer(Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.PartialMechanical),
        Integer(Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.FullMechanical),
        Integer(Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.Outage)})
    "Switch boolean signals to real signal"
    annotation (Placement(transformation(extent={{64,-6},{88,6}})));

  Modelica.Blocks.Interfaces.BooleanInput connected "Connected to grid or not"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-20,120})));
  Modelica.StateGraph.InitialStepWithSignal off(nIn=4, nOut=2)
    "off mode when connected to power grid" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,90})));
  Modelica.StateGraph.StepWithSignal disPow(nIn=3)
    "Disconnected from power grid" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-30,-180})));
  Modelica.StateGraph.Transition con1(condition=connected and on)
    "Fire condition 1: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,68})));
  Modelica.StateGraph.Transition con6(
    enableTimer=true,
    waitTime=tWai,
    condition=not on)
    "Fire condition 6: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-8,60})));
  Modelica.StateGraph.Transition con7(condition=not connected)
    "Fire condition 6: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,-120})));
  Modelica.StateGraph.Transition con8(condition=not connected)
    "Fire condition 6: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-82,-156})));
  Modelica.StateGraph.Transition con9(condition=not connected)
    "Fire condition 6: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,-200})));
  Modelica.StateGraph.Transition con10(condition=connected)
    "Fire condition 4: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={10,-140})));
  Modelica.Blocks.Interfaces.BooleanInput on "System scheduled on" annotation (
      Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-80,120})));
  Modelica.StateGraph.Transition con11(
    enableTimer=true,
    waitTime=tWai,
    condition=not on)
    "Fire condition 6: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-28})));
  Modelica.StateGraph.Transition con12(
    enableTimer=true,
    waitTime=tWai,
    condition=not on)
    "Fire condition 6: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={26,20})));
equation
  connect(freCoo.outPort[1],con2. inPort)
    annotation (Line(
      points={{-50.3333,29.5},{-50.3333,20},{-80,20},{-80,14}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, parMecCoo.inPort[1])
    annotation (Line(
      points={{-80,8.5},{-80,0},{-50.5,0},{-50.5,-9}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.inPort, parMecCoo.outPort[1])
    annotation (Line(
      points={{-80,-46},{-80,-40},{-50.375,-40},{-50.375,-30.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.outPort, fulMecCoo.inPort[1])
    annotation (Line(
      points={{-80,-51.5},{-80,-64},{-50,-64},{-50,-71}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(swi.y, y)
    annotation (Line(points={{88.6,0},{110,0}}, color={255,127,0}));
  connect(off.outPort[1], con1.inPort) annotation (Line(points={{-50.25,79.5},{-50.25,
          76},{-80,76},{-80,72}}, color={0,0,0}));
  connect(con1.outPort, freCoo.inPort[1]) annotation (Line(points={{-80,66.5},{-80,
          60},{-50.5,60},{-50.5,51}}, color={0,0,0}));
  connect(fulMecCoo.outPort[1], con4.inPort) annotation (Line(points={{-50.3333,
          -92.5},{-50.3333,-100},{-20,-100},{-20,-58}}, color={0,0,0}));
  connect(con4.outPort, parMecCoo.inPort[2]) annotation (Line(points={{-20,-52.5},
          {-20,-2},{-49.5,-2},{-49.5,-9}}, color={0,0,0}));
  connect(parMecCoo.outPort[2], con5.inPort) annotation (Line(points={{-50.125,-30.5},
          {-50.125,-40},{-24,-40},{-24,6}}, color={0,0,0}));
  connect(con5.outPort, freCoo.inPort[2]) annotation (Line(points={{-24,11.5},{-24,
          60},{-50,60},{-50,51},{-49.5,51}}, color={0,0,0}));
  connect(freCoo.outPort[2], con6.inPort) annotation (Line(points={{-50,29.5},{-50,
          20},{-8,20},{-8,56}}, color={0,0,0}));
  connect(con6.outPort, off.inPort[1]) annotation (Line(points={{-8,61.5},{-8,108},
          {-50.75,108},{-50.75,101}}, color={0,0,0}));
  connect(freCoo.outPort[3], con7.inPort) annotation (Line(points={{-49.6667,
          29.5},{-49.6667,16},{-100,16},{-100,-100},{-80,-100},{-80,-116}},
                                                                      color={0,0,
          0}));
  connect(con7.outPort, disPow.inPort[1]) annotation (Line(points={{-80,-121.5},
          {-80,-132},{-30.6667,-132},{-30.6667,-169}}, color={0,0,0}));
  connect(parMecCoo.outPort[3], con8.inPort) annotation (Line(points={{-49.875,-30.5},
          {-49.875,-38},{-98,-38},{-98,-142},{-82,-142},{-82,-152}}, color={0,0,
          0}));
  connect(con8.outPort, disPow.inPort[2]) annotation (Line(points={{-82,-157.5},
          {-82,-180},{-60,-180},{-60,-138},{-30,-138},{-30,-169}}, color={0,0,0}));
  connect(fulMecCoo.outPort[3], con9.inPort) annotation (Line(points={{-49.6667,
          -92.5},{-49.6667,-98},{-104,-98},{-104,-184},{-80,-184},{-80,-196}},
        color={0,0,0}));
  connect(con9.outPort, disPow.inPort[3]) annotation (Line(points={{-80,-201.5},
          {-80,-220},{-60,-220},{-60,-140},{-29.3333,-140},{-29.3333,-169}},
        color={0,0,0}));
  connect(disPow.outPort[1], con10.inPort) annotation (Line(points={{-30,-190.5},
          {-30,-204},{10,-204},{10,-144}}, color={0,0,0}));
  connect(con10.outPort, off.inPort[4]) annotation (Line(points={{10,-138.5},{10,
          110},{-49.25,110},{-49.25,101}}, color={0,0,0}));
  connect(fulMecCoo.outPort[2], con11.inPort) annotation (Line(points={{-50,-92.5},
          {-50,-112},{0,-112},{0,-32}}, color={0,0,0}));
  connect(con11.outPort, off.inPort[3]) annotation (Line(points={{0,-26.5},{0,108},
          {-49.75,108},{-49.75,101}}, color={0,0,0}));
  connect(parMecCoo.outPort[4], con12.inPort) annotation (Line(points={{-49.625,
          -30.5},{-48,-30.5},{-48,-40},{-10,-40},{-10,6},{26,6},{26,16}}, color=
         {0,0,0}));
  connect(con12.outPort, off.inPort[2]) annotation (Line(points={{26,21.5},{26,112},
          {-48,112},{-48,101},{-50.25,101}}, color={0,0,0}));
  connect(off.active, swi.u[1]) annotation (Line(points={{-39,90},{50,90},{50,1.44},
          {64,1.44}}, color={255,0,255}));
  connect(freCoo.active, swi.u[2]) annotation (Line(points={{-39,40},{48,40},{48,
          0.72},{64,0.72}}, color={255,0,255}));
  connect(parMecCoo.active, swi.u[3]) annotation (Line(points={{-39,-20},{48,-20},
          {48,0},{64,0}}, color={255,0,255}));
  connect(fulMecCoo.active, swi.u[4]) annotation (Line(points={{-39,-82},{50,-82},
          {50,-0.72},{64,-0.72}}, color={255,0,255}));
  connect(disPow.active, swi.u[5]) annotation (Line(points={{-19,-180},{10,-180},
          {10,-182},{52,-182},{52,-1.44},{64,-1.44}}, color={255,0,255}));
  annotation (    Documentation(info="<html>
<p>
Controller that outputs if the chilled water system is in Free Cooling (FC) mode,
Partially Mechanical Cooling (PMC) mode or Fully Mechanical Cooling (FMC) mode.
</p>
<p>The waterside economizer is enabled when </p>
<ol>
 <li>
    The waterside economizer has been disabled for at least 20 minutes, and
 </li>
 <li>
    <i>T<sub>CHWR</sub> &gt; T<sub>WetBul</sub> + T<sub>TowApp</sub> + deaBan1 </i>
 </li>
</ol>
<p>The waterside economizer is disabled when </p>
<ol>
  <li>
    The waterside economizer has been enabled for at least 20 minutes, and
  </li>
  <li>
    <i>T<sub>WSE_CHWST</sub> &gt; T<sub>WSE_CHWRT</sub> - deaBan2 </i>
  </li>
</ol>
<p>The chiller is enabled when </p>
<ol>
  <li>
    The chiller has been disabled for at leat 20 minutes, and
  </li>
  <li>
    <i>T<sub>WSE_CHWST</sub> &gt; T<sub>CHWSTSet</sub> + deaBan3 </i>
  </li>
</ol>
<p>The chiller is disabled when </p>
<ol>
  <li>
    The chiller has been enabled for at leat 20 minutes, and
  </li>
  <li>
    <i>T<sub>WSE_CHWST</sub> &le; T<sub>CHWSTSet</sub> + deaBan4 </i>
  </li>
</ol>
<p>
where <i>T<sub>WSE_CHWST</sub></i> is the chilled water supply temperature for the WSE,
<i>T<sub>WetBul</sub></i> is the wet bulb temperature,
<i>T<sub>TowApp</sub></i> is the cooling tower approach, <i>T<sub>WSE_CHWRT</sub></i>
is the chilled water return temperature for the WSE, and <i>T<sub>CHWSTSet</sub></i>
is the chilled water supply temperature setpoint for the system.
<i>deaBan 1-4</i> are deadbands for each switching point.
</p>
<h4>References</h4>
<ul>
  <li>
    Stein, Jeff. Waterside Economizing in Data Centers: Design and Control Considerations.
    ASHRAE Transactions 115.2 (2009).
  </li>
</ul>
</html>",        revisions="<html>
<ul>
<li>
July 24, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-240},{100,100}})));
end CoolingMode;
