within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses;
model BatteryControl "Battery control"
  parameter Real SOCLow "Lower limit of SOC";
  parameter Real SOCHig "High limit of SOC";

  Modelica.StateGraph.InitialStep off "Off state" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={-30,82},
        rotation=90)));
  Modelica.StateGraph.Transition           toOn(condition=SOC < SOCHig and
        connected)                              "Transition to on" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-70,60},
        rotation=90)));
  Modelica.StateGraph.StepWithSignal charge "State to charge battery"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-30,40})));
  Modelica.StateGraph.Transition           toHold(condition=SOC >= SOCHig and
        connected)                                "Transition to hold"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-70,20})));
  Modelica.StateGraph.Step hold "Battery charge is hold"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-2})));
  Modelica.StateGraph.Transition           toDischarge(condition=not connected)
    "Transition to discharge"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-70,-24})));
  Modelica.StateGraph.StepWithSignal discharge "State to discharge battery"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-30,-50})));
  Modelica.StateGraph.Transition           toOff(condition=SOC < SOCLow or
        connected)                               "Transition to off"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-60,-70})));
  Modelica.Blocks.Interfaces.RealInput SOC "State of charge"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.BooleanInput connected
    "Battery connected to grid or not"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput powCha "Power of charge (positve)"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput powDis "Pow of discharge (negative)"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Logical.Switch disSwi "Switch to discharge battery"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Logical.Switch chaSwi "Switch to charge battery"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Sources.Constant POff(k=0) "Off power"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Modelica.Blocks.Interfaces.RealOutput pow
    "Power(positive for charging, negative for discharging)"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(discharge.outPort[1],toOff. inPort)
    annotation (Line(points={{-30,-60.5},{-30,-64},{-60,-64},{-60,-66}},
                                                 color={0,0,0}));
  connect(off.outPort[1],toOn. inPort) annotation (Line(points={{-30,71.5},{-30,
          66},{-70,66},{-70,64}},
                          color={0,0,0}));
  connect(toOn.outPort,charge. inPort[1])
    annotation (Line(points={{-70,58.5},{-70,54},{-30,54},{-30,51}},
                                                            color={0,0,0}));
  connect(charge.outPort[1],toHold. inPort)
    annotation (Line(points={{-30,29.5},{-30,26},{-70,26},{-70,24}},
                                                            color={0,0,0}));
  connect(toHold.outPort,hold. inPort[1])
    annotation (Line(points={{-70,18.5},{-70,14},{-30,14},{-30,9}},
                                                            color={0,0,0}));
  connect(hold.outPort[1],toDischarge. inPort)
    annotation (Line(points={{-30,-12.5},{-30,-16},{-70,-16},{-70,-20}},
                                                       color={0,0,0}));
  connect(toDischarge.outPort,discharge. inPort[1])
    annotation (Line(points={{-70,-25.5},{-70,-34},{-30,-34},{-30,-39}},
                                                         color={0,0,0}));
  connect(toOff.outPort,off. inPort[1]) annotation (Line(points={{-60,-71.5},{-60,
          -80},{-10,-80},{-10,96},{-30,96},{-30,93}},
                                                    color={0,0,0}));
  connect(charge.active, chaSwi.u2)
    annotation (Line(points={{-19,40},{38,40}}, color={255,0,255}));
  connect(POff.y, chaSwi.u3)
    annotation (Line(points={{21,0},{28,0},{28,32},{38,32}}, color={0,0,127}));
  connect(POff.y, disSwi.u3) annotation (Line(points={{21,0},{28,0},{28,-58},{38,
          -58}}, color={0,0,127}));
  connect(discharge.active, disSwi.u2)
    annotation (Line(points={{-19,-50},{38,-50}}, color={255,0,255}));
  connect(powCha, chaSwi.u1) annotation (Line(points={{-120,-20},{-92,-20},{-92,
          100},{26,100},{26,48},{38,48}}, color={0,0,127}));
  connect(powDis, disSwi.u1) annotation (Line(points={{-120,-60},{-90,-60},{-90,
          98},{24,98},{24,-42},{38,-42}}, color={0,0,127}));
  connect(chaSwi.y, add.u1)
    annotation (Line(points={{61,40},{64,40},{64,6},{70,6}}, color={0,0,127}));
  connect(disSwi.y, add.u2) annotation (Line(points={{61,-50},{64,-50},{64,-6},{
          70,-6}}, color={0,0,127}));
  connect(add.y, pow)
    annotation (Line(points={{93,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                 Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BatteryControl;
