within Buildings.Applications.DataCenters.ChillerCooled.Paper;
model tes
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep(startTime=120, startValue=
        true) annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep1(startTime=180)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(booleanStep.y, or1.u1) annotation (Line(points={{-59,10},{-40,10},{
          -40,0},{-22,0}}, color={255,0,255}));
  connect(booleanStep1.y, or1.u2) annotation (Line(points={{-59,-30},{-40,-30},
          {-40,-8},{-22,-8}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end tes;
