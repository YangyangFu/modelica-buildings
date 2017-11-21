within Buildings.Applications.DataCenters.ChillerCooled.Controls;
model HeadPressure "Head pressure control for chillers"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PID
    "Type of controller"
    annotation(Dialog(tab="Controller"));
  parameter Real k(min=0, unit="1") = 1
    "Gain of controller"
    annotation(Dialog(tab="Controller"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of Integrator block"
     annotation (Dialog(enable=
          (controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID),tab="Controller"));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of Derivative block"
     annotation (Dialog(enable=
          (controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID),tab="Controller"));
  parameter Real yMax(start=1)=1
   "Upper limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real yMin=0.2
   "Lower limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Boolean reverseAction = true
    "Set to true for throttling the water flow rate through a cooling coil controller"
    annotation(Dialog(tab="Controller"));

  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=yMax,
    yMin=yMin,
    reverseAction=reverseAction,
    reset=Buildings.Types.Reset.Parameter) "PID controller"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Modelica.Blocks.Interfaces.RealInput u_s "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.IntegerInput cooMod
    "Cooling mode signal, integer value of
    Buildings.Applications.DataCenters.Types.CoolingMode"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Sources.BooleanExpression pmcMod(
    y= cooMod == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.PartialMechanical))
    "Partially mechanical cooling mode"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
protected
  Modelica.Blocks.Logical.Switch swi "Switch " annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={10,10})));
public
  Modelica.Blocks.Sources.Constant uni(k=1) "Unit"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.BooleanInput on "On signal for the chiller"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
protected
  Modelica.Blocks.Logical.Switch swi1
                                     "Switch " annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={50,-30})));
public
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
equation
  connect(conPID.u_s, u_s) annotation (Line(points={{-52,60},{-80,60},{-80,80},
          {-120,80}},color={0,0,127}));
  connect(conPID.u_m, u_m)
    annotation (Line(points={{-40,48},{-40,20},{-120,20}}, color={0,0,127}));
  connect(pmcMod.y, swi.u2) annotation (Line(points={{-59,0},{-30,0},{-30,10},{-2,
          10}},               color={255,0,255}));
  connect(conPID.y, swi.u1) annotation (Line(points={{-29,60},{-20,60},{-20,18},
          {-2,18}},
                  color={0,0,127}));
  connect(uni.y, swi.u3) annotation (Line(points={{-39,-30},{-20,-30},{-20,2},{-2,
          2}},     color={0,0,127}));
  connect(pmcMod.y, conPID.trigger) annotation (Line(points={{-59,0},{-48,0},{
          -48,0},{-48,0},{-48,48}}, color={255,0,255}));
  connect(on, swi1.u2) annotation (Line(points={{-120,-90},{-60,-90},{-60,-60},{
          -18,-60},{-18,-30},{38,-30}}, color={255,0,255}));
  connect(swi.y, swi1.u1) annotation (Line(points={{21,10},{28,10},{28,-22},{38,
          -22}}, color={0,0,127}));
  connect(zer.y, swi1.u3) annotation (Line(points={{21,-70},{28,-70},{28,-38},{38,
          -38}}, color={0,0,127}));
  connect(swi1.y, y) annotation (Line(points={{61,-30},{80,-30},{80,0},{110,0}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block implements a head pressure PID controller for chillers used during 
Partial Mechanical Cooling mode when the condenser water temperature is lower
than the required minimum. This controller can be used with a three-way valve 
to adjust the condenser water flowrate in order to statisfy the minimum temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
November 16, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeadPressure;
