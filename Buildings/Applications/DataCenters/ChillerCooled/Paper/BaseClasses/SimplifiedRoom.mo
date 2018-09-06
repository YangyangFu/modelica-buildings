within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses;
model SimplifiedRoom "Simplified data center room"
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  parameter Integer nPorts=0 "Number of parts" annotation (Evaluate=true,
      Dialog(
      connectorSizing=true,
      tab="General",
      group="Ports"));
  parameter Modelica.SIunits.Length rooLen "Length of the room";
  parameter Modelica.SIunits.Length rooWid "Width of the room";
  parameter Modelica.SIunits.Height rooHei "Height of the room";
  parameter Modelica.SIunits.Power QRoo_flow
    "Heat generation of the computer room";

  Buildings.Fluid.MixingVolumes.MixingVolume rooVol(
    redeclare package Medium = Medium,
    nPorts=nPorts,
    V=rooLen*rooWid*rooHei,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final T_start=293.15,
    final prescribedHeatFlowRate=true) "Volume of air in the room" annotation (Placement(
        transformation(extent={{-11,-30},{9,-10}})));
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
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=QRoo_flow,
    offset=0,
    duration=36000,
    startTime=0)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAir(unit="K", displayUnit="degC")
    "Room air temperature" annotation (Placement(transformation(extent={{100,-10},
            {120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
protected
  Modelica.Thermal.HeatTransfer.Components.Convection convIntWall if AInt > 0
    "Convective heat transfer of interior walls"
    annotation (Placement(transformation(extent={{24,80},{4,60}})));
  Modelica.Blocks.Sources.Constant alphaIntWall(k=AInt*alphaInt) if AInt > 0
    "Coefficient of convective heat transfer for interior walls"
    annotation (Placement(transformation(
    extent={{5,-5},{-5,5}},
    rotation=-90,
    origin={14,39})));
public
  ThermalZones.ReducedOrder.RC.BaseClasses.InteriorWall
                           intWallRC(
    final n=nInt,
    final RInt=RInt,
    final CInt=CInt,
    final T_start=T_start) if AInt > 0 "RC-element for interior walls"
    annotation (Placement(transformation(extent={{58,60},{78,82}})));
equation
  connect(rooVol.ports, airPorts) annotation (Line(
      points={{-1,-30},{0,-30},{0,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(QSou.port, rooVol.heatPort) annotation (Line(
      points={{-38,0},{-20,0},{-20,-20},{-11,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ramp.y, QSou.Q_flow) annotation (Line(
      points={{-79,0},{-58,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TAir.port, rooVol.heatPort) annotation (Line(points={{40,0},{-14,0},{
          -14,-20},{-11,-20}},
                             color={191,0,0}));
  connect(TAir.T, TRooAir) annotation (Line(points={{60,0},{76,0},{110,0}},
               color={0,0,127}));
  connect(intWallRC.port_a, convIntWall.solid)
    annotation (Line(points={{58,70},{24,70}}, color={191,0,0}));
  connect(convIntWall.fluid, rooVol.heatPort) annotation (Line(points={{4,70},{
          -18,70},{-18,-20},{-11,-20}}, color={191,0,0}));
  connect(alphaIntWall.y, convIntWall.Gc)
    annotation (Line(points={{14,44.5},{14,60}}, color={0,0,127}));
  annotation (
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
end SimplifiedRoom;
