within Buildings.Fluid.HeatExchangers.CoolingTowers;
model EffectivenessNTU
  "A variable speed cooling tower model based on epsilon-NTU approach developed in Mercel theory"
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower;

  Modelica.SIunits.SpecificHeatCapacity cpw
    "Heat capacity of water";
  Modelica.SIunits.SpecificHeatCapacity cpe
    "Heat capacity of effective air";

  Modelica.Blocks.Interfaces.RealInput TAir(
    min=0,
    unit="K",
    displayUnit="degC")
    "Entering air wet bulb temperature"
     annotation (Placement(transformation(
          extent={{-140,20},{-100,60}})));

protected
  package Water =  Buildings.Media.Water "Medium package for water";
  package Air = Buildings.Media.Air "Medium pakcage for air";
  Modelica.SIunits.Temperature T_a "Temperature in port_a";
  Modelica.SIunits.Temperature T_b "Temperature in port_b";
  Air.ThermodynamicState state_1=
    Air.setState_pTX(101325, TAir, inStream(port_a.Xi_outflow))
    "state for medium inflowing through port_a1";
equation
  // Get states at the inlet and outlet
   if allowFlowReversal then
    if homotopyInitialization then
      T_a=Water.temperature(Water.setState_phX(p=port_a.p,
                                 h=homotopy(actual=actualStream(port_a.h_outflow),
                                            simplified=inStream(port_a.h_outflow)),
                                 X=homotopy(actual=actualStream(port_a.Xi_outflow),
                                            simplified=inStream(port_a.Xi_outflow))));
      T_b=Water.temperature(Water.setState_phX(p=port_b.p,
                                 h=homotopy(actual=actualStream(port_b.h_outflow),
                                            simplified=port_b.h_outflow),
                                 X=homotopy(actual=actualStream(port_b.Xi_outflow),
                                            simplified=port_b.Xi_outflow)));
      cpw=Water.specificHeatCapacityCp(Water.setState_phX(p=port_a.p,
                                 h=homotopy(actual=actualStream(port_a.h_outflow),
                                            simplified=inStream(port_a.h_outflow)),
                                 X=homotopy(actual=actualStream(port_a.Xi_outflow),
                                            simplified=inStream(port_a.Xi_outflow))));
    else
      T_a=Water.temperature(Water.setState_phX(p=port_a.p,
                                 h=actualStream(port_a.h_outflow),
                                 X=actualStream(port_a.Xi_outflow)));
      T_b=Water.temperature(Water.setState_phX(p=port_b.p,
                                 h=actualStream(port_b.h_outflow),
                                 X=actualStream(port_b.Xi_outflow)));
      cpw=Water.specificHeatCapacityCp(Water.setState_phX(p=port_a.p,
                                 h=actualStream(port_a.h_outflow),
                                 X=actualStream(port_a.Xi_outflow)));
    end if; // homotopyInitialization

  else // reverse flow not allowed
    T_a=Water.temperature(Water.setState_phX(p=port_a.p,
                               h=inStream(port_a.h_outflow),
                               X=inStream(port_a.Xi_outflow)));
    T_b=Water.temperature(Water.setState_phX(p=port_b.p,
                               h=inStream(port_b.h_outflow),
                               X=inStream(port_b.Xi_outflow)));
    cpw=Water.specificHeatCapacityCp(Water.setState_phX(p=port_a.p,
                               h=inStream(port_a.h_outflow),
                               X=inStream(port_a.Xi_outflow)));
  end if;





  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EffectivenessNTU;
