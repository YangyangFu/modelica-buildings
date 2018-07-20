within Buildings.Applications.DataCenters.ChillerCooled.Paper;
model NormalOperation1
  import Buildings;
  extends Modelica.Icons.Example;
  extends
    Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.PartialDataCenter(
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
  Buildings.Controls.OBC.CDL.Logical.Switch swiRea
    annotation (Placement(transformation(extent={{220,220},{200,240}})));
  Modelica.Blocks.Sources.Constant uni(k=1) "Unit"
    annotation (Placement(transformation(extent={{260,240},{240,260}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{260,200},{240,220}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{300,220},{280,240}})));
  Modelica.Blocks.Logical.Or orChi[numChi]
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Modelica.Blocks.Math.RealToBoolean swiBoo
    annotation (Placement(transformation(extent={{180,242},{160,262}})));
  Modelica.Blocks.Logical.Or orWSE
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
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

  connect(uni.y, swiRea.u1) annotation (Line(points={{239,250},{232,250},{232,238},
          {222,238}}, color={0,0,127}));
  connect(zer.y, swiRea.u3) annotation (Line(points={{239,210},{232,210},{232,222},
          {222,222}}, color={0,0,127}));
  connect(booleanConstant.y, swiRea.u2)
    annotation (Line(points={{279,230},{222,230}}, color={255,0,255}));
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-380,-220},{260,220}})));
end NormalOperation1;
