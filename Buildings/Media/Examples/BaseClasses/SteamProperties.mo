within Buildings.Media.Examples.BaseClasses;
partial model SteamProperties
  "Model that tests the implementation of the fluid properties"

  replaceable package Medium = Buildings.Media.Steam;

  parameter Modelica.SIunits.Temperature TMin
    "Minimum temperature for the simulation";
  parameter Modelica.SIunits.Temperature TMax
    "Maximum temperature for the simulation";
  parameter Modelica.SIunits.Pressure p = Medium.p_default "Pressure";
  parameter Modelica.SIunits.MassFraction X[Medium.nX]=
    Medium.X_default "Mass fraction";
  Medium.Temperature T "Temperature";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC
    "Celsius temperature";

  Medium.ThermodynamicState state_pTX "Medium state";

  Modelica.SIunits.Density d "Density";
  Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
  Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
  Modelica.SIunits.SpecificInternalEnergy u "Specific internal energy";
  Modelica.SIunits.SpecificEntropy s "Specific entropy";
  Modelica.SIunits.SpecificEnergy g "Specific Gibbs energy";
  Modelica.SIunits.SpecificEnergy f "Specific Helmholtz energy";

  Modelica.SIunits.SpecificEnthalpy hIse "Isentropic enthalpy";

  Modelica.Media.Interfaces.Types.IsobaricExpansionCoefficient beta
    "Isobaric expansion coefficient";
  Modelica.SIunits.IsothermalCompressibility kappa "Isothermal compressibility";

  Modelica.Media.Interfaces.Types.DerDensityByPressure ddph
    "Density derivative w.r.t. pressure";
  Modelica.Media.Interfaces.Types.DerDensityByEnthalpy ddhp
    "Density derivative w.r.t. enthalpy";

  Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
  Modelica.SIunits.SpecificHeatCapacity cv "Specific heat capacity";
  Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity";

  Modelica.SIunits.AbsolutePressure pMed "Pressure";
  Medium.Temperature TMed "Temperature";
  Modelica.SIunits.MolarMass MM "Mixture molar mass";

  Medium.BaseProperties basPro "Medium base properties";

  Integer region;
  Modelica.Media.Common.IF97BaseTwoPhase aux;

protected
  constant Real conv(unit="1/s") = 1 "Conversion factor to satisfy unit check";

equation
    // Check the water region
    aux = Modelica.Media.Water.IF97_Utilities.waterBaseProp_pT(p=p,T=T);
    region = aux.region;

    // Compute temperatures that are used as input to the functions
    T = TMin + conv*time * (TMax-TMin);
    T_degC = Modelica.SIunits.Conversions.to_degC(T);

    // Check setting the states
    state_pTX = Medium.setState_pTX(p=p, T=T, X=X);

    // Check the implementation of the functions
    d = Medium.density(state_pTX);
    eta = Medium.dynamicViscosity(state_pTX);
    h = Medium.specificEnthalpy(state_pTX);

    u = Medium.specificInternalEnergy(state_pTX);
    s = Medium.specificEntropy(state_pTX);
    g = Medium.specificGibbsEnergy(state_pTX);
    f = Medium.specificHelmholtzEnergy(state_pTX);
    hIse = Medium.isentropicEnthalpy(p, state_pTX);
    beta = Medium.isobaricExpansionCoefficient(state_pTX);
    kappa = Medium.isothermalCompressibility(state_pTX);

    ddhp = Medium.density_derh_p(state_pTX);
    ddph = Medium.density_derp_h(state_pTX);

    cp = Medium.specificHeatCapacityCp(state_pTX);
    cv = Medium.specificHeatCapacityCv(state_pTX);
    lambda = Medium.thermalConductivity(state_pTX);
    pMed = Medium.pressure(state_pTX);
    assert(abs(p-pMed) < 1e-8, "Error in pressure computation.");
    TMed = Medium.temperature(state_pTX);
    assert(abs(T-TMed) < 1e-8, "Error in temperature computation.");
    MM = Medium.molarMass(state_pTX);
    // Check the implementation of the base properties
    assert(abs(h-basPro.h) < 1e-8, "Error in enthalpy computation in BaseProperties.");
    assert(abs(u-basPro.u) < 1e-8, "Error in internal energy computation in BaseProperties.");

   annotation (
Documentation(info="<html>
<p>
This example checks thermophysical properties of the steam medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 12, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamProperties;
