within Buildings.Applications.DataCenters.ChillerCooled.Paper;
model NormalOperation
  import Buildings;
  extends Modelica.Icons.Example;
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.PartialDataCenter(
    redeclare Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide chiWSE(
      addPowerToMedium=false,
      perPum=perPumPri),
    weaData(filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")),
    roo(rooVol(mSenFac=10)),
    ahu(tauFan=10),
    val(use_inputFilter=true),
    pumCW(use_inputFilter=true));

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumPri(
    each pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp2_chi_nominal+dp2_wse_nominal+18000)*{1.5,1.3,1.0,0.6}))
    "Performance data for primary pumps";

  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingMode
    cooModCon(
    tWai=tWai,
    deaBan1=1.1,
    deaBan2=0.5,
    deaBan3=1.1,
    deaBan4=0.5)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-214,100},{-194,120}})));
  Modelica.Blocks.Sources.RealExpression towTApp(y=cooTow[1].TApp_nominal)
    "Cooling tower approach temperature"
    annotation (Placement(transformation(extent={{-320,100},{-300,120}})));
  Modelica.Blocks.Sources.RealExpression yVal5(
    y=if cooModCon.y == Integer(
    Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical)
    then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Modelica.Blocks.Sources.RealExpression yVal6(
    y=if cooModCon.y == Integer(
    Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling)
    then 1 else 0)
    "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{-160,14},{-140,34}})));

  Modelica.Blocks.Sources.RealExpression cooLoaChi(
    y=-chiWSE.port_a2.m_flow*4180*(chiWSE.TCHWSupWSE - TCHWSupSet.y))
    "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-320,130},{-300,150}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaCooTow(mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Electrical load in cooling towers"
    annotation (Placement(transformation(extent={{240,160},{220,180}})));
  Modelica.Blocks.Sources.RealExpression powCooTow(y(unit="W")=-(cooTow[1].PFan + cooTow[2].PFan))
    "Power in cooling towers"
    annotation (Placement(transformation(extent={{180,160},{200,180}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaPowCW(mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Electrical load in condenser water pumps"
    annotation (Placement(transformation(extent={{240,120},{220,140}})));
  Modelica.Blocks.Sources.RealExpression powPumCW(y(unit="W") = -(pumCW[1].P +
      pumCW[2].P)) "Power in condenser water pumps"
    annotation (Placement(transformation(extent={{180,120},{200,140}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaChi(mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Electrical load in chillers"
    annotation (Placement(transformation(extent={{240,30},{220,50}})));
  Modelica.Blocks.Sources.RealExpression powChi(y(unit="W") =  -sum(chiWSE.powChi))
    "Power in chillers"
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaPumCHW(mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Electrical load in chilled water pumps"
    annotation (Placement(transformation(extent={{240,-10},{220,10}})));
  Modelica.Blocks.Sources.RealExpression powPumCHW(y(unit="W") = -sum(chiWSE.powPum))
    "Power in chilled water pumps"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaAHU(mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Electrical load in AHUs"
    annotation (Placement(transformation(extent={{240,-50},{220,-30}})));
  Modelica.Blocks.Sources.RealExpression powAHU(y(unit="W") = -(ahu.PFan + ahu.PHea))
    "Power in AHUs"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}})));
  Modelica.Blocks.Sources.RealExpression powIT(y(unit="W") = -roo.QRoo_flow)
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
  Modelica.Blocks.Logical.And orChi
                                  [numChi]
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Modelica.Blocks.Math.RealToBoolean swiBoo
    annotation (Placement(transformation(extent={{180,242},{160,262}})));
  Modelica.Blocks.Logical.And orWSE
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Storage.Battery bat(
    SOC_start=0,
    EMax=900000000,
    V_nominal=480)
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
  Buildings.Electrical.AC.OnePhase.Basics.Ground gnd1
    annotation (Placement(transformation(extent={{446,144},{466,164}})));
equation
  connect(TCHWSup.port_b, ahu.port_a1)
    annotation (Line(
      points={{-36,0},{-40,0},{-40,0},{-40,-114},{0,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.TCHWSupWSE, cooModCon.TCHWSupWSE)
    annotation (Line(
      points={{21,34},{148,34},{148,200},{-226,200},{-226,106},{-216,106}},
      color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(
      points={{-299,140},{-172,140}},
      color={0,0,127}));
   for i in 1:numChi loop
    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{-50,110},{-50,140},{-42,140}},
        color={0,127,255},
        thickness=0.5));
    connect(swiRea.y, sigCWLoo[i].u1) annotation (Line(points={{199,230},{-280,230},
          {-280,96},{-148,96},{-148,76},{-142,76}}, color={0,0,127}));
    connect(swiBoo.y, orChi[i].u2) annotation (Line(points={{159,252},{-110,252},
            {-110,132},{-102,132}},
                                 color={255,0,255}));
    connect(orChi[i].y, chiWSE.on[i]) annotation (Line(points={{-79,140},{-60,140},
          {-60,120},{-8,120},{-8,37.6},{-1.6,37.6}}, color={255,0,255}));
    connect(swiRea.y, sigPumCHW[i].u1) annotation (Line(points={{199,230},{-280,230},
          {-280,16},{-92,16},{-92,-4},{-82,-4}}, color={0,0,127}));
   end for;

    connect(orWSE.y, chiWSE.on[numChi+1]) annotation (Line(points={{-79,110},{-60,110},{-60,
          120},{-10,120},{-10,37.6},{-1.6,37.6}}, color={255,0,255}));
  connect(TCHWSupSet.y, cooModCon.TCHWSupSet)
    annotation (Line(
      points={{-239,160},{-222,160},{-222,118},{-216,118}},
      color={0,0,127}));
  connect(towTApp.y, cooModCon.TApp)
    annotation (Line(
      points={{-299,110},{-216,110}},
      color={0,0,127}));
  connect(weaBus.TWetBul.TWetBul, cooModCon.TWetBul)
    annotation (Line(
      points={{-328,-20},{-340,-20},{-340,200},{-224,200},{-224,114},{-216,114}},
      color={255,204,51},thickness=0.5));
  connect(TCHWRet.port_b, chiWSE.port_a2)
    annotation (Line(
      points={{80,0},{40,0},{40,24},{20,24}},
      color={0,127,255},
      thickness=0.5));
  connect(cooModCon.TCHWRetWSE, TCHWRet.T)
    annotation (Line(
      points={{-216,102},{-228,102},{-228,206},{152,206},{152,20},{90,20},{90,
          11}},
    color={0,0,127}));

  connect(cooModCon.y, chiStaCon.cooMod)
    annotation (Line(
      points={{-193,110},{-190,110},{-190,146},{-172,146}},
      color={255,127,0}));
  connect(cooModCon.y,intToBoo.u)
    annotation (Line(
      points={{-193,110},{-172,110}},
      color={255,127,0}));
  connect(TCHWSup.T, chiStaCon.TCHWSup)
    annotation (Line(
      points={{-26,11},{-26,18},{-182,18},{-182,134},{-172,134}},
      color={0,0,127}));
  connect(yVal5.y, chiWSE.yVal5) annotation (Line(points={{-139,40},{-84,40},{
          -84,33},{-1.6,33}}, color={0,0,127}));
  connect(yVal6.y, chiWSE.yVal6) annotation (Line(points={{-139,24},{-84,24},{
          -84,29.8},{-1.6,29.8}}, color={0,0,127}));
  connect(cooModCon.y, cooTowSpeCon.cooMod) annotation (Line(points={{-193,110},
          {-190,110},{-190,182},{-172,182}},         color={255,127,0}));
  connect(cooModCon.y, CWPumCon.cooMod) annotation (Line(points={{-193,110},{
          -190,110},{-190,75},{-174,75}}, color={255,127,0}));

  connect(powCooTow.y, loaCooTow.Pow)
    annotation (Line(points={{201,170},{220,170}}, color={0,0,127}));
  connect(powPumCW.y, loaPowCW.Pow)
    annotation (Line(points={{201,130},{220,130}}, color={0,0,127}));
  connect(powChi.y, loaChi.Pow)
    annotation (Line(points={{201,40},{220,40}}, color={0,0,127}));
  connect(powPumCHW.y, loaPumCHW.Pow)
    annotation (Line(points={{201,0},{220,0}}, color={0,0,127}));
  connect(powAHU.y, loaAHU.Pow)
    annotation (Line(points={{201,-40},{220,-40}}, color={0,0,127}));
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
  connect(sigPumCHW.y, chiWSE.yPum)
    annotation (Line(points={{-59,-10},{-50,-10},
          {-50,25.6},{-1.6,25.6}}, color={0,0,127}));
  connect(chiOn.y, orChi.u1)
    annotation (Line(points={{-119,140},{-102,140}}, color={255,0,255}));
  connect(swiRea.y, swiBoo.u) annotation (Line(points={{199,230},{188,230},{188,
          252},{182,252}}, color={0,0,127}));
  connect(wseOn.y, orWSE.u1)
    annotation (Line(points={{-119,110},{-102,110}}, color={255,0,255}));
  connect(swiBoo.y, orWSE.u2) annotation (Line(points={{159,252},{-112,252},{-112,
          102},{-102,102}}, color={255,0,255}));
  connect(sigCWLoo.y, val.y) annotation (Line(points={{-119,70},{-110,70},{-110,
          90},{-72,90},{-72,198},{60,198},{60,152}}, color={0,0,127}));
  connect(batCon.pow, bat.P) annotation (Line(points={{310,119},{310,100},{326,
          100},{326,84}}, color={0,0,127}));
  connect(bat.SOC, batCon.SOC) annotation (Line(points={{337,80},{356,80},{356,
          158},{304,158},{304,142}}, color={0,0,127}));
  connect(powAHU.y, criPow.u[1]) annotation (Line(points={{201,-40},{212,-40},{
          212,-16},{276,-16},{276,43.5},{298,43.5}}, color={0,0,127}));
  connect(powIT.y, criPow.u[2]) annotation (Line(points={{201,-88},{212,-88},{
          212,-58},{278,-58},{278,36.5},{298,36.5}}, color={0,0,127}));
  connect(criPow.y, batCon.powDis) annotation (Line(points={{321.7,40},{360,40},
          {360,154},{316,154},{316,142}}, color={0,0,127}));
  connect(powCha.y, batCon.powCha) annotation (Line(points={{321,0},{358,0},{
          358,156},{312,156},{312,142}}, color={0,0,127}));
  connect(idealClosingSwitch.terminal_n, loaCooTow.terminal) annotation (Line(
        points={{312,190},{264,190},{264,170},{240,170}}, color={0,120,120}));
  connect(idealClosingSwitch.terminal_n, loaPowCW.terminal) annotation (Line(
        points={{312,190},{264,190},{264,130},{240,130}}, color={0,120,120}));
  connect(idealClosingSwitch.terminal_n, loaChi.terminal) annotation (Line(
        points={{312,190},{264,190},{264,40},{240,40}}, color={0,120,120}));
  connect(idealClosingSwitch.terminal_n, loaPumCHW.terminal) annotation (Line(
        points={{312,190},{264,190},{264,0},{240,0}}, color={0,120,120}));
  connect(idealClosingSwitch.terminal_n, loaAHU.terminal) annotation (Line(
        points={{312,190},{264,190},{264,-40},{240,-40}}, color={0,120,120}));
  connect(bat.terminal, idealClosingSwitch.terminal_n) annotation (Line(points=
          {{316,74},{268,74},{268,190},{312,190}}, color={0,120,120}));
  connect(idealClosingSwitch.terminal_n, traACAC.terminal_n) annotation (Line(
        points={{312,190},{264,190},{264,-38},{364,-38},{364,-88},{350,-88}},
        color={0,120,120}));
  connect(booleanStep.y, con.u1) annotation (Line(points={{339,252},{328,252},{
          328,220},{316,220}}, color={255,0,255}));
  connect(booleanStep1.y, con.u2) annotation (Line(points={{339,220},{332,220},
          {332,212},{316,212}}, color={255,0,255}));
  connect(con.y, idealClosingSwitch.control) annotation (Line(points={{293,220},
          {288,220},{288,204},{322,204},{322,200}}, color={255,0,255}));
  connect(con.y, swiRea.u2) annotation (Line(points={{293,220},{272,220},{272,
          230},{222,230}}, color={255,0,255}));
  connect(con.y, batCon.connected) annotation (Line(points={{293,220},{288,220},
          {288,166},{308,166},{308,142}}, color={255,0,255}));
  connect(gri.terminal, idealClosingSwitch.terminal_p) annotation (Line(points=
          {{376,166},{376,162},{336,162},{336,190},{332,190}}, color={0,120,120}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-380,-220},{260,220}})), experiment(StopTime=86400));
end NormalOperation;
