within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model MerkelControl
  "Example that demonstrate the control of Merkel cooling tower"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel tow(
      UA_nominal=50000,
      PFan_nominal=20000,
      UACor(
        mAir_flow_nominal=m1_flow_nominal,
        mWat_flow_nominal=m2_flow_nominal,
        TAirInWB_nominal=T_a1_nominal,
        TWatIn_nominal=T_a2_nominal)),
    pum(m_flow_nominal=m2_flow_nominal),
    vol(m_flow_nominal=m2_flow_nominal, V=300),
    mWat_flow(k=m2_flow_nominal),
    fixHeaFlo(Q_flow=0.5*m2_flow_nominal*4200*5),
    onOffController(bandwidth=2));
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=122720*1.2/3600
    "Nominal flowrate of air";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=92.7*1000/3600
    "Nominal flowrate of water";
  parameter Modelica.SIunits.Temperature T_a1_nominal=298.75
    "Nominal wetbulb temperature of intet air";
  parameter Modelica.SIunits.Temperature T_a2_nominal=310.93
    "Nominal temperature of inlet water";

  Buildings.Controls.Continuous.LimPID conFan(
    Td=10,
    reverseAction=true,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    Ti=120,
    k=1)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Sources.Constant TSetLea(k=273.15 + 18)
    "Setpoint for leaving temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(wetBulTem.TWetBul, tow.TAir) annotation (Line(points={{1,50},{12,50},{
          12,-46},{22,-46}}, color={0,0,127}));
  connect(TSetLea.y, conFan.u_s)
    annotation (Line(points={{-39,-10},{-22,-10}}, color={0,0,127}));
  connect(conFan.y, tow.y) annotation (Line(points={{1,-10},{16,-10},{16,-42},{22,
          -42}}, color={0,0,127}));
  connect(conFan.u_m, tow.TLvg) annotation (Line(points={{-10,-22},{-10,-30},{54,
          -30},{54,-56},{45,-56}}, color={0,0,127}));

 annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,-260},
            {140,100}})), __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Examples/MerkelControl.mos"
        "Simulate and Plot"));
end MerkelControl;
