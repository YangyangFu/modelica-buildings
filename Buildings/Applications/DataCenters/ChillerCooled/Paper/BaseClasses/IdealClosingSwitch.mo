within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses;
model IdealClosingSwitch
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.IdealSwitchOnePhase;
  Modelica.Blocks.Interfaces.BooleanInput control
    "true => p--n connected, false => switch open" annotation (Placement(
        transformation(
        origin={0,100},
        extent={{-10,-10},{10,10}},
        rotation=270)));
equation
  off = not control;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{0,90},{0,22}}, color={255,85,255})}),      Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<p>The switching behaviour of the ideal closing switch is controlled by the input signal control: off = not control.</p>
</html>"));
end IdealClosingSwitch;
