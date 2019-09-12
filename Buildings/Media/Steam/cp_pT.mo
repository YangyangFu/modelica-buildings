within Buildings.Media.Steam;
function cp_pT
  "Specific heat capacity at constant pressure as function of pressure and temperature"

  extends Modelica.Icons.Function;
  input Modelica.SIunits.Pressure p "Pressure";
  input Modelica.SIunits.Temperature T "Temperature";
  input Integer region=0
    "If 0, region is unknown, otherwise known and this input";
  output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
algorithm
  cp := Modelica.Media.Water.IF97_Utilities.cp_props_pT(
    p,
    T,
    Buildings.Media.Steam.waterBaseProp_pT(
      p,
      T,
      region));
  annotation (Inline=true,smoothOrder=5);
end cp_pT;
