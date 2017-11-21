within Buildings.Applications.DataCenters.ChillerCooled.Controls.Validation;
model HeadPressure "Test the head pressure control for chillers"
  extends Modelica.Icons.Example;

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
  parameter Real yMin=0
   "Lower limit of output"
    annotation(Dialog(tab="Controller"));

  Buildings.Applications.DataCenters.ChillerCooled.Controls.HeadPressure heaPreCon(
      controllerType=Modelica.Blocks.Types.SimpleController.PI, Ti=60)
    "Head pressure controller"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant CWRTSet(k=273.15 + 20)
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Sine CWST(
    amplitude=5,
    freqHz=1/360,
    offset=273.15 + 20)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.IntegerTable cooMod(table=[0,1; 360,2; 720,3])
    "Cooling mode"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.BooleanStep on "On"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
equation
  connect(cooMod.y, heaPreCon.cooMod) annotation (Line(points={{-59,-50},{-40,
          -50},{-40,-4},{-2,-4}}, color={255,127,0}));
  connect(CWRTSet.y, heaPreCon.u_s) annotation (Line(points={{-59,70},{-40,70},
          {-40,8},{-2,8}}, color={0,0,127}));
  connect(CWST.y, heaPreCon.u_m) annotation (Line(points={{-59,10},{-42,10},{
          -42,2},{-2,2}}, color={0,0,127}));
  connect(on.y, heaPreCon.on) annotation (Line(points={{-59,-90},{-34,-90},{-34,
          -9},{-2,-9}}, color={255,0,255}));
  annotation (    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Controls/Validation/HeadPressure.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example tests the controller for the head pressure in chillers. Detailed control logic can be found in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.HeadPressure\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.HeadPressure</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 16, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=1080,
      Tolerance=1e-06));
end HeadPressure;
