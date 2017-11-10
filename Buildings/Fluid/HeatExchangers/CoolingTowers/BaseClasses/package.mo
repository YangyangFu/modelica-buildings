within Buildings.Fluid.HeatExchangers.CoolingTowers;
package BaseClasses "Package with base classes for Buildings.Fluid.HeatExchangers.CoolingTowers"
  extends Modelica.Icons.BasesPackage;

  model MerkelCoolingTower
    "Partial cooling tower model based on Merkel's theory"
    extends Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower(
      QWat_flow(
        y=eps*QMax_flow));

    import con = Buildings.Fluid.Types.HeatExchangerConfiguration;
    import flo = Buildings.Fluid.Types.HeatExchangerFlowRegime;

    parameter Modelica.SIunits.MassFlowRate m1_flow "Air mass flowrate";

    parameter con configuration "Heat exchanger configuration"
      annotation (Evaluate=true);
    parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)
      "Nominal mass flow rate"
      annotation(Dialog(group = "Nominal condition"));
    parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0)
      "Nominal mass flow rate"
      annotation(Dialog(group = "Nominal condition"));
    parameter Modelica.SIunits.ThermalConductance UA_nominal(min=0)
      "Thermal conductance at nominal flow, used to compute heat capacity"
      annotation (Dialog(tab="General", group="Nominal condition"));

    parameter Modelica.SIunits.Temperature T_a1_nominal
      "Nominal temperature at port a1"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.Temperature T_a2_nominal
      "Nominal temperature at port a2"
      annotation (Dialog(group="Nominal condition"));
    Modelica.Blocks.Interfaces.RealInput TAir(
      min=0,
      unit="K",
      displayUnit="degC")
      "Entering air wet bulb temperature"
       annotation (Placement(transformation(
            extent={{-140,20},{-100,60}})));

    Modelica.SIunits.SpecificHeatCapacity cpw
      "Heat capacity of water";
    SpecificHeatCapacityEquivalentFluid cpe
      "Specific heat capacity for equivalent fluid"
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    Modelica.SIunits.SpecificHeatCapacity cpa = 1006
      "Heat capacity of air";

    Modelica.SIunits.MassFlowRate m2_flow = port_a.m_flow
      "Mass flow rate from port_a to port_b (mWat_flow > 0 is design flow direction)";

    Modelica.SIunits.Temperature Ta1 = TAir "Inlet temperature medium 1";
    Modelica.SIunits.Temperature Ta2 "Inlet temperature medium 2";
    Modelica.SIunits.Temperature Tb1 "Outlet temperature medium 1";
    Modelica.SIunits.Temperature Tb2 "Outlet temperature medium 2";

    Modelica.SIunits.ThermalConductance C1_flow
      "Heat capacity flow rate medium 1";
    Modelica.SIunits.ThermalConductance C2_flow
      "Heat capacity flow rate medium 2";
    Modelica.SIunits.ThermalConductance CMin_flow(min=0)
      "Minimum heat capacity flow rate";
    Modelica.SIunits.HeatFlowRate QMax_flow
      "Maximum heat flow rate into medium 1";
    flo flowRegime=flo.CounterFlow
      "Heat exchanger flow regime";
    Modelica.SIunits.ThermalConductance UAe(min=0)
      "Thermal conductance for equivalent fluid";
    Real eps(min=0, max=1) "Heat exchanger effectiveness";
    Real Z(min=0) "Ratio of capacity flow rate (CMin/CMax)";

    parameter Modelica.SIunits.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(m1_flow_nominal)
      "Small mass flow rate for regularization of zero flow"
      annotation(Dialog(tab = "Advanced"));
    parameter Modelica.SIunits.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(m2_flow_nominal)
      "Small mass flow rate for regularization of zero flow"
      annotation(Dialog(tab = "Advanced"));

protected
    final package Air = Buildings.Media.Air "Package of medium air";
    parameter Real delta=1E-3 "Parameter used for smoothing";

    final parameter Air.ThermodynamicState sta1_default = Air.setState_pTX(
       T=T_a1_nominal,
       p=Air.p_default,
       X=Air.X_default[1:Air.nXi]) "Default state for medium 1";
    final parameter Medium.ThermodynamicState sta2_default = Medium.setState_pTX(
       T=T_a2_nominal,
       p=Medium.p_default,
       X=Medium.X_default[1:Medium.nXi]) "Default state for medium 2";

    parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal(fixed=false)
      "Specific heat capacity of medium 1 at nominal condition";
    parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal(fixed=false)
      "Specific heat capacity of medium 2 at nominal condition";
    parameter Modelica.SIunits.ThermalConductance C1_flow_nominal(fixed=false)
      "Nominal capacity flow rate of Medium 1";
    parameter Modelica.SIunits.ThermalConductance C2_flow_nominal(fixed=false)
      "Nominal capacity flow rate of Medium 2";
    parameter Modelica.SIunits.ThermalConductance CMin_flow_nominal(fixed=false)
      "Minimal capacity flow rate at nominal condition";
    parameter Modelica.SIunits.ThermalConductance CMax_flow_nominal(fixed=false)
      "Maximum capacity flow rate at nominal condition";

    Modelica.Blocks.Interfaces.RealInput Tb1_internal
      "Needed to connect to conditional connector";

  initial equation
    cp1_nominal = Air.specificHeatCapacityCp(sta1_default);
    cp2_nominal = Medium.specificHeatCapacityCp(sta2_default);

    // Heat transferred from fluid 1 to 2 at nominal condition
    C1_flow_nominal = m1_flow_nominal*cp1_nominal;
    C2_flow_nominal = m2_flow_nominal*cp2_nominal;
    CMin_flow_nominal = min(C1_flow_nominal, C2_flow_nominal);
    CMax_flow_nominal = max(C1_flow_nominal, C2_flow_nominal);

  equation
     if allowFlowReversal then
      if homotopyInitialization then
        Ta2=Medium.temperature(Medium.setState_phX(p=port_a.p,
                                   h=homotopy(actual=actualStream(port_a.h_outflow),
                                              simplified=inStream(port_a.h_outflow)),
                                   X=homotopy(actual=actualStream(port_a.Xi_outflow),
                                              simplified=inStream(port_a.Xi_outflow))));
        Tb2=Medium.temperature(Medium.setState_phX(p=port_b.p,
                                   h=homotopy(actual=actualStream(port_b.h_outflow),
                                              simplified=port_b.h_outflow),
                                   X=homotopy(actual=actualStream(port_b.Xi_outflow),
                                              simplified=port_b.Xi_outflow)));
        cpw=Medium.specificHeatCapacityCp(Medium.setState_phX(p=port_a.p,
                                   h=homotopy(actual=actualStream(port_a.h_outflow),
                                              simplified=inStream(port_a.h_outflow)),
                                   X=homotopy(actual=actualStream(port_a.Xi_outflow),
                                              simplified=inStream(port_a.Xi_outflow))));
      else
        Ta2=Medium.temperature(Medium.setState_phX(p=port_a.p,
                                   h=actualStream(port_a.h_outflow),
                                   X=actualStream(port_a.Xi_outflow)));
        Tb2=Medium.temperature(Medium.setState_phX(p=port_b.p,
                                   h=actualStream(port_b.h_outflow),
                                   X=actualStream(port_b.Xi_outflow)));
        cpw=Medium.specificHeatCapacityCp(Medium.setState_phX(p=port_a.p,
                                   h=actualStream(port_a.h_outflow),
                                   X=actualStream(port_a.Xi_outflow)));
      end if; // homotopyInitialization

    else // reverse flow not allowed
      Ta2=Medium.temperature(Medium.setState_phX(p=port_a.p,
                                 h=inStream(port_a.h_outflow),
                                 X=inStream(port_a.Xi_outflow)));
      Tb2=Medium.temperature(Medium.setState_phX(p=port_b.p,
                                 h=inStream(port_b.h_outflow),
                                 X=inStream(port_b.Xi_outflow)));
      cpw=Medium.specificHeatCapacityCp(Medium.setState_phX(p=port_a.p,
                                 h=inStream(port_a.h_outflow),
                                 X=inStream(port_a.Xi_outflow)));
     end if;

    // UA for equivalent fluid
    UAe = UA_nominal*cpe.cpe/cpa;

    // Capacity for air and water
    C1_flow = abs(m1_flow)*cpe.cpe;
    C2_flow = abs(m2_flow)*cpw;
    CMin_flow = min(C1_flow, C2_flow);

    // Calculate epsilon
    (eps, Z) = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C(
      UA=UAe,
      C1_flow=C1_flow,
      C2_flow=C2_flow,
      flowRegime=Integer(flowRegime),
      CMin_flow_nominal=CMin_flow_nominal,
      CMax_flow_nominal=CMax_flow_nominal,
      delta=delta);
    // QMax_flow is maximum heat transfer into medium 1
      QMax_flow = CMin_flow*(Ta2 - Ta1);

        TAppAct=Tb2-TAir;
        TAirHT=TAir;

      Tb1 = Ta1 + eps*QMax_flow/C1_flow;
      Tb1_internal = Tb1;

    connect(TAir, cpe.T1) annotation (Line(points={{-120,40},{-80,40},{-80,75},{-62,
            75}}, color={0,0,127}));
    connect(Tb1_internal,cpe.T2);

  end MerkelCoolingTower;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers\">Buildings.Fluid.HeatExchangers.CoolingTowers</a>.
</p>
</html>"));
end BaseClasses;
