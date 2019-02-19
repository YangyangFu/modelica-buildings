within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses;
model wseStage "Waterside economizer stage control"
  Modelica.StateGraph.InitialStepWithSignal off(nIn=2) "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-30,40})));
  Modelica.Blocks.Interfaces.IntegerInput cooMod
    "Cooling mode signal, integer value of
    Buildings.Applications.DataCenters.Types.CoolingMode"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.StateGraph.StepWithSignal on(nIn=2, nOut=2) "WSE is commanded on"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-30,-40})));
  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=0,
    condition=cooMod == Integer(Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.PartialMechanical)
         or cooMod == Integer(Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.FreeCooling)
         or cooMod == Integer(Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.Outage))
    "Fire condition 1: off to on"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,10})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=0,
    condition=cooMod == Integer(Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.FullMechanical)
         or cooMod == Integer(Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.Off))
    "Fire condition 2: on to off"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={10,10})));
  Modelica.Blocks.Interfaces.BooleanOutput y "WSE on/off signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(off.outPort[1], con1.inPort) annotation (Line(points={{-30,29.5},{-30,
          24},{-70,24},{-70,14}}, color={0,0,0}));
  connect(con1.outPort, on.inPort[1]) annotation (Line(points={{-70,8.5},{-70,
          -18},{-30.5,-18},{-30.5,-29}},
                                   color={0,0,0}));
  connect(on.outPort[1], con2.inPort) annotation (Line(points={{-30.25,-50.5},{
          -30.25,-58},{10,-58},{10,6}},
                                  color={0,0,0}));
  connect(con2.outPort, off.inPort[1]) annotation (Line(points={{10,11.5},{10,
          66},{-30.5,66},{-30.5,51}},
                                  color={0,0,0}));
  connect(on.active, y) annotation (Line(points={{-19,-40},{60,-40},{60,0},{110,
          0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end wseStage;
