within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples;
model MultiSpeed "Test model for multi speed water-cooled DX coil"
  import Buildings;
  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
  extends Modelica.Icons.Example;
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";
 parameter Modelica.SIunits.PressureDifference dpEva_nominal = 1000
    "Pressure drop at m_flow_nominal";
 parameter Modelica.SIunits.PressureDifference dpCon_nominal = 40000
    "Pressure drop at mCon_flow_nominal";

  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumAir,
    nPorts=1,
    p(displayUnit="Pa"))
              "Sink on air side"
    annotation (Placement(transformation(extent={{52,30},{32,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                      souAir(
    redeclare package Medium = MediumAir,
    use_T_in=true,
    nPorts=1,
    m_flow=1.5,
    T=299.85) "Source on air side"
    annotation (Placement(transformation(extent={{-48,28},{-28,48}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=600,
    startTime=2400,
    height=-5,
    offset=273.15 + 23) "Temperature"
    annotation (Placement(transformation(extent={{-100,42},{-80,62}})));
  Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.MultiSpeed  mulSpeDX(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    datCoi=datCoi,
    show_T=true,
    dpCon_nominal=dpCon_nominal,
    dpEva_nominal=dpEva_nominal) "Multi-speed DX coil"
    annotation (Placement(transformation(extent={{-6,-6},{14,14}})));

  Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi(nSta=4, sta={
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9,
          mCon_flow_nominal=0.57143,
          TEvaIn_nominal=273.15+26.67,
          TConIn_nominal=273.15+29.4),
        perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2,
          mCon_flow_nominal=0.85714,
          TEvaIn_nominal=273.15+26.67,
          TConIn_nominal=273.15+29.4),
        perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5,
          mCon_flow_nominal=1,
          TEvaIn_nominal=273.15+26.67,
          TConIn_nominal=273.15+29.4),
        perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8,
          mCon_flow_nominal=1.42857,
          TEvaIn_nominal=273.15+26.67,
          TConIn_nominal=273.15+29.4),
        perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I())}) "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Ramp     mCon_flow(
    duration=600,
    startTime=6000,
    height=0,
    offset=1)                                     "Condensor inlet mass flow"
    annotation (Placement(transformation(extent={{100,-40},{80,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                      souWat(
    redeclare package Medium = MediumWater,
    nPorts=1,
    use_T_in=false,
    use_m_flow_in=true,
    T=298.15) "Source on water side"
    annotation (Placement(transformation(extent={{52,-56},{32,-36}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWater,
    nPorts=1,
    p(displayUnit="Pa"))
              "Sink on water side"
    annotation (Placement(transformation(extent={{-44,-60},{-24,-40}})));
  Modelica.Blocks.Sources.IntegerTable speRat(table=[
    0.0,0.0;
    900,1;
    1800,4;
    2700,3;
    3600,2]) "Speed ratio "
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
equation
  connect(TEvaIn.y, souAir.T_in) annotation (Line(
      points={{-79,52},{-58,52},{-58,42},{-50,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mulSpeDX.port_a2, souWat.ports[1]) annotation (Line(points={{14,-2},{
          28,-2},{28,-46},{32,-46}},
                                  color={0,127,255}));
  connect(mulSpeDX.port_b2, sinWat.ports[1]) annotation (Line(points={{-6,-2},{
          -12,-2},{-12,-50},{-24,-50}},
                                    color={0,127,255}));
  connect(souAir.ports[1],mulSpeDX. port_a1) annotation (Line(points={{-28,38},
          {-12,38},{-12,10},{-6,10}},
                                    color={0,127,255}));
  connect(sinAir.ports[1],mulSpeDX. port_b1) annotation (Line(points={{32,40},{
          28,40},{28,10},{14,10}},
                                color={0,127,255}));
  connect(mCon_flow.y, souWat.m_flow_in) annotation (Line(points={{79,-30},{68,-30},
          {68,-38},{52,-38}},      color={0,0,127}));
  connect(speRat.y,mulSpeDX. stage) annotation (Line(points={{-79,0},{-60,0},{-60,
          12},{-7.2,12}}, color={255,127,0}));
  annotation (             __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/WaterCooled/Examples/MultiSpeed.mos"
        "Simulate and plot"),
    experiment(StopTime=3600),
            Documentation(info="<html>
<p>
This is a test model for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.MultiSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.MultiSpeed</a>.
The model has open-loop control and time-varying input conditions.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultiSpeed;
