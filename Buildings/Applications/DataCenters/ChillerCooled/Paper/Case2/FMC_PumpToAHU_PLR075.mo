within Buildings.Applications.DataCenters.ChillerCooled.Paper.Case2;
model FMC_PumpToAHU_PLR075
  import Buildings;
  extends Modelica.Icons.Example;
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.PartialDataCenter(
    redeclare Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide chiWSE(
      addPowerToMedium=false,
      perPum=perPumPri,
      use_inputFilter=true),
    roo(rooVol(mSenFac=25)),
    ahu(tauFan=10),
    val(use_inputFilter=true),
    pumCW(use_inputFilter=true),
    PLR = 0.75);

  Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.CoolingMode
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
    Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.FullMechanical)
    then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Modelica.Blocks.Sources.RealExpression yVal6(
    y=if cooModCon.y == Integer(
    Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.FreeCooling) or
      cooModCon.y == Integer(
    Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.Types.CoolingModes.Outage)
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
    XoverR=8,
    Zperc=0.03,
    VABase=QRoo_flow_nominal)
    annotation (Placement(transformation(extent={{350,-98},{330,-78}})));
  Electrical.DC.Loads.Conductor conductor(mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      V_nominal=12)
    annotation (Placement(transformation(extent={{240,-98},{220,-78}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiRea
    annotation (Placement(transformation(extent={{220,220},{200,240}})));
  Modelica.Blocks.Sources.Constant uni(k=1) "Unit"
    annotation (Placement(transformation(extent={{280,240},{260,260}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{280,190},{260,210}})));
  Modelica.Blocks.Logical.And orChi
                                  [numChi]
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Modelica.Blocks.Math.RealToBoolean swiBoo
    annotation (Placement(transformation(extent={{180,242},{160,262}})));
  Modelica.Blocks.Logical.And orWSE
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Storage.Battery bat(
    SOC_start=0,
    V_nominal=480,
    EMax=EMax)
    annotation (Placement(transformation(extent={{316,64},{336,84}})));
  Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.BatteryControl
    batCon(SOCLow=0.01, SOCHig=0.99) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={310,130})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum criPow(nin=5) "Critical power"
    annotation (Placement(transformation(extent={{300,30},{320,50}})));
  Modelica.Blocks.Sources.Constant powCha(k=500000) "Charging power"
    annotation (Placement(transformation(extent={{300,-10},{320,10}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep(startValue=true, startTime(
        displayUnit="h") = 18540000)
    annotation (Placement(transformation(extent={{360,220},{340,240}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep1(startTime(displayUnit="h")=
         18541800)
    annotation (Placement(transformation(extent={{360,180},{340,200}})));
  Modelica.Blocks.Logical.Or con
    annotation (Placement(transformation(extent={{314,210},{294,230}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid gri
    annotation (Placement(transformation(extent={{320,180},{300,200}})));
  Modelica.Blocks.Math.RealToBoolean criEqu "Critical equipment "
    annotation (Placement(transformation(extent={{180,280},{160,300}})));
  Modelica.Blocks.Sources.BooleanConstant sch
    annotation (Placement(transformation(extent={{-340,220},{-320,240}})));
  parameter Buildings.Fluid.Movers.Data.Generic[numChi]  perPumPri(each
      pressure=
        Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
        V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2}, dp=(dp2_chi_nominal +
        dp2_wse_nominal + ahu.dp1_nominal + 18000 + pipCHW.dp_nominal +
        dpSetPoi)*{1.2,1.1,1.0,0.6}))
    "Performance data for primary chilled water pump"
    annotation (Placement(transformation(extent={{-238,-200},{-218,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch for outage and out of battery"
    annotation (Placement(transformation(extent={{226,280},{206,300}})));
  Modelica.Blocks.Logical.And powCri "Power all critical equipment"
    annotation (Placement(transformation(extent={{314,270},{294,290}})));
  Modelica.Blocks.Logical.Not notCon "Not connected to grid"
    annotation (Placement(transformation(extent={{294,242},{314,262}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr(threshold=
        0.5)
    annotation (Placement(transformation(extent={{354,294},{334,314}})));
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
    connect(swiBoo.y, orChi[i].u2) annotation (Line(points={{159,252},{-110,252},
            {-110,132},{-102,132}},
                                 color={255,0,255}));
    connect(orChi[i].y, chiWSE.on[i]) annotation (Line(points={{-79,140},{-60,140},
            {-60,120},{-10,120},{-10,37.6},{-1.6,37.6}},
                                                     color={255,0,255}));
  connect(swi.y, sigCWLoo[i].u1) annotation (Line(points={{205,290},{202,290},{
            202,278},{-186,278},{-186,92},{-148,92},{-148,76},{-142,76}},
                                                                    color={0,0,127}));
  connect(swi.y, sigPumCHW[i].u1) annotation (Line(points={{205,290},{202,290},
            {202,278},{-186,278},{-186,16},{-90,16},{-90,-4},{-82,-4}},
                                                                     color={0,0,
          127}));

   end for;

    connect(orWSE.y, chiWSE.on[numChi+1]) annotation (Line(points={{-79,110},{-60,
          110},{-60,116},{-14,116},{-14,37.6},{-1.6,37.6}},
                                                  color={255,0,255}));
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
  connect(cooModCon.TCHWRetWSE, TCHWRet.T)
    annotation (Line(
      points={{-216,102},{-228,102},{-228,206},{152,206},{152,20},{90,20},{90,
          11}},
    color={0,0,127}));

  connect(cooModCon.y, chiStaCon.cooMod)
    annotation (Line(
      points={{-193,110},{-190,110},{-190,146},{-172,146}},
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
  connect(uni.y, swiRea.u1) annotation (Line(points={{259,250},{238,250},{238,238},
          {222,238}}, color={0,0,127}));
  connect(zer.y, swiRea.u3) annotation (Line(points={{259,200},{232,200},{232,222},
          {222,222}}, color={0,0,127}));
  connect(sigPumCHW.y, chiWSE.yPum)
    annotation (Line(points={{-59,-10},{-50,-10},
          {-50,25.6},{-1.6,25.6}}, color={0,0,127}));
  connect(chiOn.y, orChi.u1)
    annotation (Line(points={{-119,140},{-102,140}}, color={255,0,255}));
  connect(swiRea.y, swiBoo.u) annotation (Line(points={{199,230},{188,230},{188,
          252},{182,252}}, color={0,0,127}));
  connect(sigCWLoo.y, val.y) annotation (Line(points={{-119,70},{-110,70},{-110,
          90},{-72,90},{-72,198},{60,198},{60,152}}, color={0,0,127}));
  connect(batCon.pow, bat.P) annotation (Line(points={{310,119},{310,100},{326,
          100},{326,84}}, color={0,0,127}));
  connect(bat.SOC, batCon.SOC) annotation (Line(points={{337,80},{356,80},{356,
          158},{304,158},{304,142}}, color={0,0,127}));
  connect(powAHU.y, criPow.u[1]) annotation (Line(points={{201,-40},{212,-40},{
          212,-16},{276,-16},{276,45.6},{298,45.6}}, color={0,0,127}));
  connect(powIT.y, criPow.u[2]) annotation (Line(points={{201,-88},{212,-88},{
          212,-58},{278,-58},{278,42.8},{298,42.8}}, color={0,0,127}));
  connect(criPow.y, batCon.powDis) annotation (Line(points={{321.7,40},{360,40},
          {360,154},{316,154},{316,142}}, color={0,0,127}));
  connect(powCha.y, batCon.powCha) annotation (Line(points={{321,0},{358,0},{
          358,156},{312,156},{312,142}}, color={0,0,127}));
  connect(booleanStep.y, con.u1) annotation (Line(points={{339,230},{328,230},{328,
          220},{316,220}},     color={255,0,255}));
  connect(booleanStep1.y, con.u2) annotation (Line(points={{339,190},{332,190},{
          332,212},{316,212}},  color={255,0,255}));
  connect(con.y, swiRea.u2) annotation (Line(points={{293,220},{272,220},{272,
          230},{222,230}}, color={255,0,255}));
  connect(con.y, batCon.connected) annotation (Line(points={{293,220},{288,220},
          {288,166},{308,166},{308,142}}, color={255,0,255}));
  connect(gri.terminal, loaCooTow.terminal) annotation (Line(points={{310,180},
          {310,170},{240,170}}, color={0,120,120}));
  connect(gri.terminal, loaPowCW.terminal) annotation (Line(points={{310,180},{
          310,170},{260,170},{260,130},{240,130}}, color={0,120,120}));
  connect(gri.terminal, loaChi.terminal) annotation (Line(points={{310,180},{
          310,170},{260,170},{260,40},{240,40}}, color={0,120,120}));
  connect(gri.terminal, loaPumCHW.terminal) annotation (Line(points={{310,180},
          {310,170},{260,170},{260,0},{240,0}}, color={0,120,120}));
  connect(gri.terminal, loaAHU.terminal) annotation (Line(points={{310,180},{
          310,170},{260,170},{260,-40},{240,-40}}, color={0,120,120}));
  connect(gri.terminal, traACAC.terminal_n) annotation (Line(points={{310,180},
          {310,170},{260,170},{260,-40},{362,-40},{362,-88},{350,-88}}, color={
          0,120,120}));
  connect(gri.terminal, bat.terminal) annotation (Line(points={{310,180},{310,
          170},{272,170},{272,74},{316,74}}, color={0,120,120}));
  connect(pipCHW.port_b, chiWSE.port_a2) annotation (Line(points={{48,0},{38,0},
          {38,24},{20,24}}, color={0,127,255}));
  connect(criEqu.y, orWSE.u2) annotation (Line(points={{159,290},{-112,290},{-112,
          102},{-102,102}}, color={255,0,255}));
  connect(sch.y, cooModCon.on) annotation (Line(points={{-319,230},{-212,230},{-212,
          122}}, color={255,0,255}));
  connect(con.y, cooModCon.connected) annotation (Line(points={{293,220},{288,220},
          {288,314},{-206,314},{-206,122}}, color={255,0,255}));
  connect(cooModCon.y, wseSta.cooMod) annotation (Line(points={{-193,110},{-172,
          110},{-172,116},{-162,116}}, color={255,127,0}));
  connect(wseSta.y, orWSE.u1)
    annotation (Line(points={{-139,110},{-102,110}}, color={255,0,255}));

  connect(powPumCHW.y, criPow.u[3]) annotation (Line(points={{201,0},{212,0},{
          212,20},{284,20},{284,40},{298,40}}, color={0,0,127}));
  connect(powPumCW.y, criPow.u[4]) annotation (Line(points={{201,130},{212,130},
          {212,60},{276,60},{276,37.2},{298,37.2}}, color={0,0,127}));
  connect(powCooTow.y, criPow.u[5]) annotation (Line(points={{201,170},{214,170},
          {214,62},{278,62},{278,34.4},{298,34.4}}, color={0,0,127}));
  connect(lesEquThr.y,powCri. u1) annotation (Line(points={{333,304},{328,304},{
          328,280},{316,280}}, color={255,0,255}));
  connect(notCon.y,powCri. u2) annotation (Line(points={{315,252},{328,252},{328,
          272},{316,272}}, color={255,0,255}));
  connect(con.y,notCon. u) annotation (Line(points={{293,220},{284,220},{284,252},
          {292,252}}, color={255,0,255}));
  connect(powCri.y,swi. u2) annotation (Line(points={{293,280},{272,280},{272,290},
          {228,290}}, color={255,0,255}));
  connect(uni.y,swi. u3) annotation (Line(points={{259,250},{238,250},{238,282},
          {228,282}}, color={0,0,127}));
  connect(zer.y,swi. u1) annotation (Line(points={{259,200},{248,200},{248,298},
          {228,298}}, color={0,0,127}));
  connect(swi.y, criEqu.u)
    annotation (Line(points={{205,290},{182,290}}, color={0,0,127}));
  connect(bat.SOC, lesEquThr.u) annotation (Line(points={{337,80},{368,80},{368,
          304},{356,304}}, color={0,0,127}));
 annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-380,-220},{260,220}}), graphics={Rectangle(
          extent={{154,326},{280,190}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{176,340},{270,300}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Critical Equipment")}),
                                      experiment(
      StartTime=18403200,
      StopTime=18576000,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Paper/Case2/FMC_PumpToAHU_PLR075.mos"
        "Simulate and Plot"));
end FMC_PumpToAHU_PLR075;
