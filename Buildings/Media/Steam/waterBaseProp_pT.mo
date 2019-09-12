within Buildings.Media.Steam;
function waterBaseProp_pT
  "Intermediate property record for water (p and T preferred states)"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Pressure p "Pressure";
  input Modelica.SIunits.Temperature T "Temperature";
  input Integer region=0
    "If 0, do region computation, otherwise assume the region is this input";
  output Modelica.Media.Common.IF97BaseTwoPhase aux "Auxiliary record";
protected
  Modelica.Media.Common.GibbsDerivs g
    "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
  Modelica.Media.Common.HelmholtzDerivs f
    "Dimensionless Helmholtz function and derivatives w.r.t. delta and tau";
  Integer error "Error flag for inverse iterations";
algorithm
  aux.phase := 1;
  aux.region := if region == 0 then
    Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.region_pT(p=p, T=T)
     else region;
  aux.R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
  aux.p := p;
  aux.T := T;
  aux.vt := 0.0 "initialized in case it is not needed";
  aux.vp := 0.0 "initialized in case it is not needed";
  if (aux.region == 1) then
    g := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.g1(p, T);
    aux.h := aux.R*aux.T*g.tau*g.gtau;
    aux.s := aux.R*(g.tau*g.gtau - g.g);
    aux.rho := p/(aux.R*T*g.pi*g.gpi);
    aux.vt := aux.R/p*(g.pi*g.gpi - g.tau*g.pi*g.gtaupi);
    aux.vp := aux.R*T/(p*p)*g.pi*g.pi*g.gpipi;
    aux.cp := -aux.R*g.tau*g.tau*g.gtautau;
    aux.cv := aux.R*(-g.tau*g.tau*g.gtautau + ((g.gpi - g.tau*g.gtaupi)*(g.gpi
       - g.tau*g.gtaupi)/g.gpipi));
    aux.x := 0.0;
    aux.dpT := -aux.vt/aux.vp;
    aux.pt := -g.p/g.T*(g.gpi - g.tau*g.gtaupi)/(g.gpipi*g.pi);
    aux.pd := -g.R*g.T*g.gpi*g.gpi/(g.gpipi);
  elseif (aux.region == 2) then
    g := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.g2(p, T);
    aux.h := aux.R*aux.T*g.tau*g.gtau;
    aux.s := aux.R*(g.tau*g.gtau - g.g);
    aux.rho := p/(aux.R*T*g.pi*g.gpi);
    aux.vt := aux.R/p*(g.pi*g.gpi - g.tau*g.pi*g.gtaupi);
    aux.vp := aux.R*T/(p*p)*g.pi*g.pi*g.gpipi;
    aux.pt := -g.p/g.T*(g.gpi - g.tau*g.gtaupi)/(g.gpipi*g.pi);
    aux.pd := -g.R*g.T*g.gpi*g.gpi/(g.gpipi);
    aux.cp := -aux.R*g.tau*g.tau*g.gtautau;
    aux.cv := aux.R*(-g.tau*g.tau*g.gtautau + ((g.gpi - g.tau*g.gtaupi)*(g.gpi
       - g.tau*g.gtaupi)/g.gpipi));
    aux.x := 1.0;
    aux.dpT := -aux.vt/aux.vp;
  elseif (aux.region == 3) then
    (aux.rho,error) :=
      Modelica.Media.Water.IF97_Utilities.BaseIF97.Inverses.dofpt3(
      p=p,
      T=T,
      delp=1.0e-7);
    f := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.f3(aux.rho, T);
    aux.h := aux.R*T*(f.tau*f.ftau + f.delta*f.fdelta);
    aux.s := aux.R*(f.tau*f.ftau - f.f);
    aux.pd := aux.R*T*f.delta*(2.0*f.fdelta + f.delta*f.fdeltadelta);
    aux.pt := aux.R*aux.rho*f.delta*(f.fdelta - f.tau*f.fdeltatau);
    aux.cv := aux.R*(-f.tau*f.tau*f.ftautau);
    aux.x := 0.0;
    aux.dpT := aux.pt;
    /*safety against div-by-0 in initialization*/
  elseif (aux.region == 5) then
    g := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.g5(p, T);
    aux.h := aux.R*aux.T*g.tau*g.gtau;
    aux.s := aux.R*(g.tau*g.gtau - g.g);
    aux.rho := p/(aux.R*T*g.pi*g.gpi);
    aux.vt := aux.R/p*(g.pi*g.gpi - g.tau*g.pi*g.gtaupi);
    aux.vp := aux.R*T/(p*p)*g.pi*g.pi*g.gpipi;
    aux.pt := -g.p/g.T*(g.gpi - g.tau*g.gtaupi)/(g.gpipi*g.pi);
    aux.pd := -g.R*g.T*g.gpi*g.gpi/(g.gpipi);
    aux.cp := -aux.R*g.tau*g.tau*g.gtautau;
    aux.cv := aux.R*(-g.tau*g.tau*g.gtautau + ((g.gpi - g.tau*g.gtaupi)*(g.gpi
       - g.tau*g.gtaupi)/g.gpipi));
    aux.x := 1.0;
    aux.dpT := -aux.vt/aux.vp;
  else
    assert(false, "Error in region computation of IF97 steam tables" +
      "(p = " + String(p) + ", T = " + String(T) + ")");
  end if;
  annotation(smoothOrder=5,Inline=true);
end waterBaseProp_pT;
