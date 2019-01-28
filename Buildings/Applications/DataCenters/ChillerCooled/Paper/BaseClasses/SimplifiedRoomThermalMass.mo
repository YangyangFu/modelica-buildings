within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses;
model SimplifiedRoomThermalMass "Simplified data center room with thermal mass"
  import Buildings;
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  parameter Integer nPorts=0 "Number of parts" annotation (Evaluate=true,
      Dialog(
      connectorSizing=true,
      tab="General",
      group="Ports"));
  parameter Modelica.SIunits.Length rooLen = 49 "Length of the room";
  parameter Modelica.SIunits.Length rooWid = 20 "Width of the room";
  parameter Modelica.SIunits.Height rooHei= 3.5 "Height of the room";
  //parameter Modelica.SIunits.Power QRoo_flow
  //  "Heat generation of the computer room";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  // interior mass

  parameter Integer n = 1 "Number of RC-elements"
    annotation(Dialog(group="Mass"));
  parameter Modelica.SIunits.Area AInt= numUni*2.22 "Thermal mass area"
    annotation(Dialog(group="Mass"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaInt = 100
    "Convective coefficient of heat transfer of interior walls (indoor)"
    annotation(Dialog(group="Mass"));
  parameter Modelica.SIunits.ThermalResistance RExt[n] = fill(0.01,n)
    "Vector of resistors, from port to capacitor"
      annotation(Dialog(group="Mass"));
  parameter Modelica.SIunits.HeatCapacity CExt[n]=fill(numUni*7277.2/n,n)
    "Vector of heat capacitors, from port to center"
      annotation(Dialog(group="Mass"));
  parameter Integer numUni = 7089 "Number of IT equipment";

  Buildings.Fluid.MixingVolumes.MixingVolume rooVol(
    redeclare package Medium = Medium,
    nPorts=nPorts,
    V=rooLen*rooWid*rooHei,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final prescribedHeatFlowRate=true,
    final T_start=293.15,
    mSenFac=30)
    "Volume of air in the room" annotation (Placement(
        transformation(extent={{41,-10},{61,10}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b airPorts[nPorts](
      redeclare each package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(
        extent={{-38,-12},{38,12}},
        rotation=180,
        origin={0,-100}), iconTransformation(
        extent={{-40.5,-13},{40.5,13}},
        rotation=180,
        origin={4.5,-87})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QSou
    "Heat source of the room"
    annotation (Placement(transformation(extent={{-58,76},{-38,96}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAir(unit="K", displayUnit="degC")
    "Room air temperature" annotation (Placement(transformation(extent={{100,-10},
            {120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Thermal.HeatTransfer.Components.Convection convIntWall2 if
                                                                     AInt > 0
    "Convective heat transfer of interior walls"
    annotation (Placement(transformation(extent={{0,50},{20,30}})));
  Modelica.Blocks.Sources.Constant alphaIntWall2(k=AInt*alphaInt) if
                                                                    AInt > 0
    "Coefficient of convective heat transfer for interior walls" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-30})));

  ThermalZones.ReducedOrder.RC.BaseClasses.ExteriorWall intMas(
    final n=n,
    final T_start=273.15 + 20,
    RExt=RExt,
    CExt=CExt,
    RExtRem=0.05) if           AInt > 0 "RC-element for interior mass"
    annotation (Placement(transformation(extent={{-10,30},{-30,52}})));

  Modelica.Blocks.Interfaces.RealInput QRoo_flow "Load"
    annotation (Placement(transformation(extent={{-140,66},{-100,106}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(threshold=1e-4)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{-14,-30},{6,-10}})));
equation
  connect(rooVol.ports, airPorts) annotation (Line(
      points={{51,-10},{50,-10},{50,-60},{0,-60},{0,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TAir.port, rooVol.heatPort) annotation (Line(points={{60,20},{34,20},{
          34,0},{41,0}},     color={191,0,0}));
  connect(TAir.T, TRooAir) annotation (Line(points={{80,20},{96,20},{96,0},{110,
          0}}, color={0,0,127}));
  connect(intMas.port_a, convIntWall2.solid)
    annotation (Line(points={{-10,40},{0,40}}, color={191,0,0}));
  connect(convIntWall2.fluid, rooVol.heatPort)
    annotation (Line(points={{20,40},{30,40},{30,0},{41,0}}, color={191,0,0}));
  connect(QSou.port, intMas.port_b) annotation (Line(points={{-38,86},{-34,86},{
          -34,40},{-30,40}}, color={191,0,0}));
  connect(QSou.Q_flow, QRoo_flow)
    annotation (Line(points={{-58,86},{-120,86}}, color={0,0,127}));
  connect(QRoo_flow, greThr.u) annotation (Line(points={{-120,86},{-90,86},{-90,
          10},{-82,10}}, color={0,0,127}));
  connect(greThr.y, booToRea.u)
    annotation (Line(points={{-59,10},{-52,10}}, color={255,0,255}));
  connect(booToRea.y, pro.u1) annotation (Line(points={{-29,10},{-26,10},{-26,
          -14},{-16,-14}}, color={0,0,127}));
  connect(alphaIntWall2.y, pro.u2) annotation (Line(points={{-59,-30},{-24,-30},
          {-24,-26},{-16,-26}}, color={0,0,127}));
  connect(pro.y, convIntWall2.Gc)
    annotation (Line(points={{7,-20},{10,-20},{10,30}}, color={0,0,127}));
  annotation (defaultComponentName="roo",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=1)}),
    Documentation(info="<html>
<p>
This is a simplified room model for a data center. There is no heat exchange between the room and ambient environment through the building envelope since it is negligible compared to the heat released by the servers.
</p></html>", revisions="<html>
<ul>
<li>
July 17, 2015, by Michael Wetter:<br/>
Added <code>prescribedHeatFlowRate=false</code> for both volumes.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/282\">
issue 282</a> of the Annex 60 library.
</li>
<li>
July 21, 2011 by Wangda Zuo:<br/>
Merge to library.
</li>
<li>
December 10, 2010 by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimplifiedRoomThermalMass;
