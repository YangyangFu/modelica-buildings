within Buildings.Applications.DataCenters.ChillerCooled.Paper;
model NormalOperation3
  import Buildings;


  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaCooTow(mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      linearized=true)
    "Electrical load in cooling towers"
    annotation (Placement(transformation(extent={{230,160},{210,180}})));
  Modelica.Blocks.Sources.RealExpression powCooTow(y(unit="W")=-1000)
    "Power in cooling towers"
    annotation (Placement(transformation(extent={{180,160},{200,180}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaPowCW(mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      linearized=true)
    "Electrical load in condenser water pumps"
    annotation (Placement(transformation(extent={{230,120},{210,140}})));
  Modelica.Blocks.Sources.RealExpression powPumCW(y(unit="W") = -1000) "Power in condenser water pumps"
    annotation (Placement(transformation(extent={{180,120},{200,140}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaChi(mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      linearized=true)
    "Electrical load in chillers"
    annotation (Placement(transformation(extent={{230,30},{210,50}})));
  Modelica.Blocks.Sources.RealExpression powChi(y(unit="W") =  -2000)
    "Power in chillers"
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaPumCHW(mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      linearized=true)
    "Electrical load in chilled water pumps"
    annotation (Placement(transformation(extent={{228,-10},{208,10}})));
  Modelica.Blocks.Sources.RealExpression powPumCHW(y(unit="W") = -2000)
    "Power in chilled water pumps"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaAHU(mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      linearized=true)
    "Electrical load in AHUs"
    annotation (Placement(transformation(extent={{232,-50},{212,-30}})));
  Modelica.Blocks.Sources.RealExpression powAHU(y(unit="W") = -2000)
    "Power in AHUs"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}})));
  Modelica.Blocks.Sources.RealExpression powIT(y(unit="W") = -500000)
    "Power in IT equipment"
    annotation (Placement(transformation(extent={{180,-98},{200,-78}})));
  Electrical.AC.ThreePhasesBalanced.Conversion.ACDCConverter conACDC(eta=0.95,
      conversionFactor=380/120)
    annotation (Placement(transformation(extent={{308,-98},{288,-78}})));
  Electrical.DC.Conversion.DCDCConverter dCDCConverter(
    VHigh=380,
    VLow=12,
    eta=0.96,
    ground_1=false)
    annotation (Placement(transformation(extent={{272,-98},{252,-78}})));
  Electrical.AC.ThreePhasesBalanced.Conversion.ACACTransformer traACAC(
    VHigh=480,
    VLow=120,
    VABase=40000,
    XoverR=8,
    Zperc=0.03)
    annotation (Placement(transformation(extent={{350,-98},{330,-78}})));
  Electrical.DC.Loads.Conductor conductor(mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      V_nominal=12)
    annotation (Placement(transformation(extent={{240,-98},{220,-78}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiRea
    annotation (Placement(transformation(extent={{220,220},{200,240}})));
  Modelica.Blocks.Sources.Constant uni(k=1) "Unit"
    annotation (Placement(transformation(extent={{260,240},{240,260}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{260,200},{240,220}})));
  Modelica.Blocks.Math.RealToBoolean swiBoo
    annotation (Placement(transformation(extent={{180,242},{160,262}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Storage.Battery bat(SOC_start=0,
    EMax=900000000,
    linearized=true)
    annotation (Placement(transformation(extent={{316,64},{336,84}})));
  Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.BatteryControl
    batCon(SOCLow=0.01, SOCHig=0.99) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={310,130})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum criPow(nin=2) "Critical power"
    annotation (Placement(transformation(extent={{300,30},{320,50}})));
  Modelica.Blocks.Sources.Constant powCha(k=500000) "Charging power"
    annotation (Placement(transformation(extent={{300,-10},{320,10}})));
  Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.IdealClosingSwitch
    idealClosingSwitch
    annotation (Placement(transformation(extent={{312,180},{332,200}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep(startValue=true, startTime(
        displayUnit="h") = 129600)
    annotation (Placement(transformation(extent={{360,242},{340,262}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep1(startTime(displayUnit="h")=
         131400)
    annotation (Placement(transformation(extent={{360,210},{340,230}})));
  Modelica.Blocks.Logical.Or con
    annotation (Placement(transformation(extent={{314,210},{294,230}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid gri
    annotation (Placement(transformation(extent={{366,166},{386,186}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.FixedVoltage fixVol
    annotation (Placement(transformation(extent={{350,46},{330,66}})));
equation


  connect(powCooTow.y, loaCooTow.Pow)
    annotation (Line(points={{201,170},{210,170}}, color={0,0,127}));
  connect(powPumCW.y, loaPowCW.Pow)
    annotation (Line(points={{201,130},{210,130}}, color={0,0,127}));
  connect(powChi.y, loaChi.Pow)
    annotation (Line(points={{201,40},{210,40}}, color={0,0,127}));
  connect(powPumCHW.y, loaPumCHW.Pow)
    annotation (Line(points={{201,0},{208,0}}, color={0,0,127}));
  connect(powAHU.y, loaAHU.Pow)
    annotation (Line(points={{201,-40},{212,-40}}, color={0,0,127}));
  connect(conACDC.terminal_p, dCDCConverter.terminal_n)
    annotation (Line(points={{288,-88},{272,-88}},   color={0,0,255}));
  connect(traACAC.terminal_p, conACDC.terminal_n)
    annotation (Line(points={{330,-88},{308,-88}},   color={0,120,120}));
  connect(powIT.y, conductor.Pow)
    annotation (Line(points={{201,-88},{220,-88}},   color={0,0,127}));
  connect(conductor.terminal, dCDCConverter.terminal_p)
    annotation (Line(points={{240,-88},{252,-88}},   color={0,0,255}));
  connect(uni.y, swiRea.u1) annotation (Line(points={{239,250},{232,250},{232,238},
          {222,238}}, color={0,0,127}));
  connect(zer.y, swiRea.u3) annotation (Line(points={{239,210},{232,210},{232,222},
          {222,222}}, color={0,0,127}));
  connect(swiRea.y, swiBoo.u) annotation (Line(points={{199,230},{188,230},{188,
          252},{182,252}}, color={0,0,127}));
  connect(batCon.pow, bat.P) annotation (Line(points={{310,119},{310,100},{326,100},
          {326,84}}, color={0,0,127}));
  connect(bat.SOC, batCon.SOC) annotation (Line(points={{337,80},{356,80},{356,158},
          {304,158},{304,142}}, color={0,0,127}));
  connect(powAHU.y, criPow.u[1]) annotation (Line(points={{201,-40},{208,-40},{
          208,-18},{276,-18},{276,43.5},{298,43.5}},
                                                 color={0,0,127}));
  connect(powIT.y, criPow.u[2]) annotation (Line(points={{201,-88},{212,-88},{212,
          -58},{278,-58},{278,36.5},{298,36.5}}, color={0,0,127}));
  connect(criPow.y, batCon.powDis) annotation (Line(points={{321.7,40},{360,40},
          {360,154},{316,154},{316,142}}, color={0,0,127}));
  connect(powCha.y, batCon.powCha) annotation (Line(points={{321,0},{358,0},{358,
          156},{312,156},{312,142}}, color={0,0,127}));
  connect(bat.terminal, idealClosingSwitch.terminal_n) annotation (Line(points={
          {316,74},{268,74},{268,190},{312,190}}, color={0,120,120}));
  connect(booleanStep.y, con.u1) annotation (Line(points={{339,252},{328,252},{328,
          220},{316,220}}, color={255,0,255}));
  connect(booleanStep1.y, con.u2) annotation (Line(points={{339,220},{332,220},{
          332,212},{316,212}}, color={255,0,255}));
  connect(con.y, idealClosingSwitch.control) annotation (Line(points={{293,220},
          {288,220},{288,204},{322,204},{322,200}}, color={255,0,255}));
  connect(con.y, swiRea.u2) annotation (Line(points={{293,220},{272,220},{272,230},
          {222,230}}, color={255,0,255}));
  connect(con.y, batCon.connected) annotation (Line(points={{293,220},{288,220},
          {288,166},{308,166},{308,142}}, color={255,0,255}));
  connect(gri.terminal, idealClosingSwitch.terminal_p) annotation (Line(points={
          {376,166},{376,162},{336,162},{336,190},{332,190}}, color={0,120,120}));
  connect(idealClosingSwitch.terminal_n, loaCooTow.terminal) annotation (Line(
        points={{312,190},{240,190},{240,170},{230,170}}, color={0,120,120}));
  connect(idealClosingSwitch.terminal_n, loaPowCW.terminal) annotation (Line(
        points={{312,190},{240,190},{240,130},{230,130}}, color={0,120,120}));
  connect(idealClosingSwitch.terminal_n, loaChi.terminal) annotation (Line(
        points={{312,190},{240,190},{240,40},{230,40},{230,40}}, color={0,120,
          120}));
  connect(idealClosingSwitch.terminal_n, loaPumCHW.terminal) annotation (Line(
        points={{312,190},{240,190},{240,0},{228,0}}, color={0,120,120}));
  connect(idealClosingSwitch.terminal_n, traACAC.terminal_n) annotation (Line(
        points={{312,190},{240,190},{240,0},{268,0},{268,-56},{362,-56},{362,
          -88},{350,-88}}, color={0,120,120}));
  connect(idealClosingSwitch.terminal_n, loaAHU.terminal) annotation (Line(
        points={{312,190},{240,190},{240,-40},{232,-40}}, color={0,120,120}));
  connect(fixVol.terminal, bat.terminal) annotation (Line(points={{330,56},{320,
          56},{320,62},{310,62},{310,74},{316,74}}, color={0,120,120}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-380,-220},{260,220}})), experiment(StopTime=86400));
end NormalOperation3;
