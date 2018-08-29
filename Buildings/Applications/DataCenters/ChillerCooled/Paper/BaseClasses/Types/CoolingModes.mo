within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types;
type CoolingModes = enumeration(
    FreeCooling "Free cooling mode",
    PartialMechanical "Partial mechanical cooling",
    FullMechanical "Full mechanical cooling",
    Outage "Disconnected from power grid",
    Off "Off mode when connected to power grid")
    "Cooling modes" annotation (
    Documentation(info="<html>
<p>
Enumeration for the type cooling mode.
</p>
<ol>
<li>
FreeCooling
</li>
<li>
PartialMechanical
</li>
<li>
FullMechanical
</li>
</ol>
</html>", revisions=
                  "<html>
<ul>
<li>
August 29, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
