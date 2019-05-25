within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses;
partial model IdealSwitchOnePhase
  extends Buildings.Electrical.Interfaces.PartialTwoPort(
    redeclare package PhaseSystem_p =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n terminal_n,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_p terminal_p);
  parameter Modelica.SIunits.Resistance Ron(final min=0) = 1e-5
    "Closed switch resistance";
  parameter Modelica.SIunits.Conductance Goff(final min=0) = 1e-5
    "Opened switch conductance";
  Modelica.SIunits.Voltage v[PhaseSystem_p.n] "Voltage drop between two terminals";
  Modelica.SIunits.Current i[PhaseSystem_p.n] "Current flowing from p to n";
protected
  Boolean off "Indicates off-state";

equation
  //Basic equations
  Connections.branch(terminal_p.theta, terminal_n.theta);
  terminal_p.theta = terminal_n.theta;
  terminal_p.i = - terminal_n.i;

  v = terminal_n.v - terminal_p.v;
  i = terminal_p.i;

  if off then
    i = v*Goff;
  else
    v = i*Ron;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{-90,0},{-40,0}}, color={0,0,0}),
        Line(points={{40,0},{90,0}}, color={0,0,0}),
        Ellipse(extent={{-40,6},{-28,-6}}, lineColor={0,0,0}),
        Line(points={{-30,4},{28,38}}, color={0,0,0}),
          Text(
            extent={{-140,80},{140,40}},
            lineColor={0,0,0},
          textString="%name")}),                                 Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Partial model of an ideal switch.</p>
<p>It has two terminals: positive terminal p and negative terminal n. The switching behaviour is controlled by the boolean signal off. If off is true, terminal p is not connected with terminal n. Otherwise, terminal p is connected with terminal n.</p>
<p>In order to prevent singularities during switching, the opened switch has a (very low) conductance Goff and the closed switch has a (very low) resistance Ron. The limiting case is also allowed, i.e., the resistance Ron of the closed switch could be exactly zero and the conductance Goff of the open switch could be also exactly zero. Note, there are circuits, where a description with zero Ron or zero Goff is not possible. </p>
<p>For now, use of HeatPort is not enabled in this model.</p>
</html>"));
end IdealSwitchOnePhase;
