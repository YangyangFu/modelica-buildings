within Buildings.Applications.DataCenters.ChillerCooled.Paper;
model NormalOperation
  extends Modelica.Icons.Example;
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses.PartialDataCenter(
    redeclare Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide chiWSE(
      addPowerToMedium=false,
      perPum=perPumPri),
    weaData(filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")));

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
  Modelica.Blocks.Sources.RealExpression powCooTow(y(unit="W")=cooTow[1].PFan + cooTow[2].PFan)
    "Power in cooling towers"
    annotation (Placement(transformation(extent={{180,160},{200,180}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaPowCW(mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Electrical load in condenser water pumps"
    annotation (Placement(transformation(extent={{240,120},{220,140}})));
  Modelica.Blocks.Sources.RealExpression powPumCW(y(unit="W") = pumCW[1].P +
      pumCW[2].P) "Power in condenser water pumps"
    annotation (Placement(transformation(extent={{180,120},{200,140}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaChi(mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Electrical load in chillers"
    annotation (Placement(transformation(extent={{240,30},{220,50}})));
  Modelica.Blocks.Sources.RealExpression powChi(y(unit="W") =  sum(chiWSE.powChi))
    "Power in chillers"
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaPumCHW(mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Electrical load in chilled water pumps"
    annotation (Placement(transformation(extent={{240,-10},{220,10}})));
  Modelica.Blocks.Sources.RealExpression powPumCHW(y(unit="W") = sum(chiWSE.powPum))
    "Power in chilled water pumps"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaAHU(mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Electrical load in AHUs"
    annotation (Placement(transformation(extent={{240,-50},{220,-30}})));
  Modelica.Blocks.Sources.RealExpression powAHU(y(unit="W") = ahu.PFan + ahu.PHea)
    "Power in AHUs"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loaIT(mode=Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Electrical load in IT equipment"
    annotation (Placement(transformation(extent={{240,-190},{220,-170}})));
  Modelica.Blocks.Sources.RealExpression powIT(y(unit="W") = roo.QRoo_flow)
    "Power in IT equipment"
    annotation (Placement(transformation(extent={{180,-190},{200,-170}})));
  Electrical.AC.ThreePhasesBalanced.Sources.FixedVoltage fixVol
    annotation (Placement(transformation(extent={{304,208},{284,188}})));
equation
  connect(pumSpeSig.y, chiWSE.yPum)
    annotation (Line(
      points={{-99,-10},{-60,-10},{-60,25.6},{-1.6,25.6}},
      color={0,0,127}));
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
   end for;
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
          {-190,110},{-190,182.444},{-172,182.444}}, color={255,127,0}));
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
  connect(powIT.y, loaIT.Pow)
    annotation (Line(points={{201,-180},{220,-180}}, color={0,0,127}));
  connect(fixVol.terminal, loaCooTow.terminal) annotation (Line(points={{284,
          198},{260,198},{260,170},{240,170}}, color={0,120,120}));
  connect(fixVol.terminal, loaPowCW.terminal) annotation (Line(points={{284,198},
          {260,198},{260,130},{240,130}}, color={0,120,120}));
  connect(fixVol.terminal, loaChi.terminal) annotation (Line(points={{284,198},
          {260,198},{260,40},{240,40}}, color={0,120,120}));
  connect(fixVol.terminal, loaPumCHW.terminal) annotation (Line(points={{284,
          198},{260,198},{260,0},{240,0}}, color={0,120,120}));
  connect(fixVol.terminal, loaAHU.terminal) annotation (Line(points={{284,198},
          {260,198},{260,-40},{240,-40}}, color={0,120,120}));
  connect(fixVol.terminal, loaIT.terminal) annotation (Line(points={{284,198},{
          260,198},{260,-180},{240,-180}}, color={0,120,120}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-380,-220},{260,220}})));
end NormalOperation;
