within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Examples;
model h_TWetBul
  "Example that shows how to get mass fraction from wetbulb temperature "
  import Buildings;
  extends Modelica.Icons.Example;

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.h_TWetBul h_TWetBul(
      use_p_in=false)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,70},{-58,70},{-58,70},{-56,70},{-56,70},{-50,70}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TWetBul, h_TWetBul.TWetBul) annotation (Line(
      points={{-50,70},{-40,70},{-40,0},{-22,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/BaseClasses/Examples/h_TWetBul.mos"
        "Simulate and Plot"));
end h_TWetBul;
