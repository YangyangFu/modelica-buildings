within Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses;
partial model PartialDataCenter
  "Partial model that impliments cooling system for data centers"
  import Buildings;
  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";

  // Chiller parameters

  parameter
   Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
   perChi [numChi](TEvaLvg_nominal=273.15 + 7)
    "Performance data for chillers"
    annotation (choicesAllMatching=true,Dialog(group="Chiller"),
                Placement(transformation(extent={{-360,-200},{-340,-180}})));
  parameter Integer numChi=2 "Number of chillers";
  parameter Modelica.SIunits.MassFlowRate m1_flow_chi_nominal= perChi[1].mCon_flow_nominal
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate m2_flow_chi_nominal= perChi[1].mEva_flow_nominal
    "Nominal mass flow rate at evaporator water in the chillers";
  parameter Modelica.SIunits.PressureDifference dp1_chi_nominal = 46.2*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dp2_chi_nominal = 44.8*1000
    "Nominal pressure";
  parameter Modelica.SIunits.Power QEva_nominal = perChi[1].QEva_flow_nominal
    "Nominal cooling capaciaty(Negative means cooling)";

 // WSE parameters
  parameter Modelica.SIunits.MassFlowRate m1_flow_wse_nominal= numChi*m1_flow_chi_nominal
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate m2_flow_wse_nominal= numChi*m2_flow_chi_nominal
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.PressureDifference dp1_wse_nominal = dp1_chi_nominal
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dp2_wse_nominal = dp2_chi_nominal
    "Nominal pressure";

  parameter Buildings.Fluid.Movers.Data.Generic[numChi]  perPumCW(
      each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m1_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp1_chi_nominal+60000+6000+pipCW.dp_nominal)*{1.2,1.1,1.0,0.6}))
    "Performance data for condenser water pump"
    annotation (Placement(transformation(extent={{-320,-200},{-300,-180}})));

  parameter Modelica.SIunits.Time tWai=1200 "Waiting time";

  // AHU
  parameter Modelica.SIunits.Power QRoo_flow_nominal=-0.8*numChi*QEva_nominal
    "Heat generation of the computer room";
  parameter Real PLR = 0.25 "Part load ratio of the data center";
  parameter Modelica.SIunits.Power QRoo_flow = PLR*QRoo_flow_nominal
    "Real heat generated in data center room";

  parameter Buildings.Fluid.Movers.Data.Generic perFan(
    motorCooledByFluid=false, pressure(V_flow=mAir_flow_nominal/1.29*{0,0.41,0.54,
          0.66,0.77,0.89,1,1.12,1.19}, dp=1300*{1.461,1.455,1.407,1.329,1.234,1.126,
          1.0,0.85,0.731}))
    "Performance data for the fan"
    annotation (Placement(transformation(extent={{-280,-200},{-260,-180}})));

  parameter Modelica.SIunits.ThermalConductance UA_nominal=numChi*QEva_nominal/
     Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        7,
        12,
        16,
        25)
    "Thermal conductance at nominal flow for sensible heat, used to compute time constant";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal = QRoo_flow_nominal/1008/(25-16)
    "Nominal air mass flowrate";
  parameter Real yValMinAHU(min=0,max=1,unit="1")=0.1
    "Minimum valve openning position";
  // Set point
  parameter Modelica.SIunits.Temperature TCHWSet = 273.15 + 8
    "Chilled water temperature setpoint";
  parameter Modelica.SIunits.Temperature TSupAirSet = TCHWSet + 8
    "Supply air temperature setpoint";
  parameter Modelica.SIunits.Temperature TRetAirSet = 273.15 + 25
    "Supply air temperature setpoint";
  parameter Modelica.SIunits.Pressure dpSetPoi = 80000
    "Differential pressure setpoint";

 // UPS
  parameter Modelica.SIunits.Energy EMax = 900*1.51*QRoo_flow_nominal "Maximum available charge";

  replaceable Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialChillerWSE chiWSE(
    redeclare replaceable package Medium1 = MediumW,
    redeclare replaceable package Medium2 = MediumW,
    numChi=numChi,
    m1_flow_chi_nominal=m1_flow_chi_nominal,
    m2_flow_chi_nominal=m2_flow_chi_nominal,
    m1_flow_wse_nominal=m1_flow_wse_nominal,
    m2_flow_wse_nominal=m2_flow_wse_nominal,
    dp1_chi_nominal=dp1_chi_nominal,
    dp1_wse_nominal=dp1_wse_nominal,
    dp2_chi_nominal=dp2_chi_nominal,
    dp2_wse_nominal=dp2_wse_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_controller=false,
    perChi=perChi,
    use_inputFilter=true)
    "Chillers and waterside economizer"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.Sources.Boundary_pT expVesCW(
    redeclare replaceable package Medium = MediumW,
    nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-9,-9.5},{9,9.5}},
        rotation=180,
        origin={131,140.5})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow[numChi](
    redeclare each replaceable package Medium = MediumW,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    each dp_nominal=30000,
    each m_flow_nominal=m1_flow_chi_nominal,
    each TAirInWB_nominal(displayUnit="degC"),
    each PFan_nominal=36000)
    "Cooling tower"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      origin={10,140})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWSup(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-16,-10},{-36,10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3  weaData(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/4C_Salem-McNary.Field.726940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-360,-80},{-340,-60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-338,-30},{-318,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWSup(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m1_flow_chi_nominal)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-22,130},{-42,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWRet(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m1_flow_chi_nominal)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{82,50},{102,70}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW[numChi](
    redeclare each replaceable package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each addPowerToMedium=false,
    per=perPumCW,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each use_inputFilter=true)
    "Condenser water pump"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,100})));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.CoolingCoilHumidifyingHeating ahu(
    redeclare replaceable package Medium1 = MediumW,
    redeclare replaceable package Medium2 = MediumA,
    m1_flow_nominal=numChi*m2_flow_chi_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    dpValve_nominal=6000,
    mWatMax_flow=0.01,
    UA_nominal=UA_nominal,
    addPowerToMedium=false,
    yValSwi=yValMinAHU + 0.1,
    yValDeaBan=0.05,
    QHeaMax_flow=30000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp1_nominal=30000,
    perFan=perFan,
    riseTimeFan=5,
    dp2_nominal=1000,
    use_inputFilterFan=false)
    "Air handling unit"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Buildings.Fluid.Sources.Boundary_pT expVesChi(
    redeclare replaceable package Medium = MediumW,
    nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={132,-113})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare replaceable package Medium =MediumW)
    "Differential pressure"
    annotation (Placement(transformation(extent={{-2,-86},{18,-106}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(
    redeclare replaceable package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,-160})));
  Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.SimplifiedRoomThermalMass
    roo(
    redeclare replaceable package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    nPorts=2)            "Room model" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, origin={4,-180})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val[numChi](
    redeclare each package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each dpValve_nominal=6000)
    "Shutoff valves"
    annotation (Placement(transformation(extent={{70,130},{50,150}})));

  Modelica.Blocks.Sources.Constant TCHWSupSet(k=TCHWSet)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));
  Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.ChillerStage
    chiStaCon(
    QEva_nominal=QEva_nominal,
    criPoiTem=TCHWSet + 1,
    tWai=1200)
    "Chiller staging control"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));
  Modelica.Blocks.Math.RealToBoolean chiOn[numChi]
    "Real value to boolean value"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.ConstantSpeedPumpStage
                                                                                   CWPumCon(tWai=30)
    "Condenser water pump controller"
    annotation (Placement(transformation(extent={{-172,60},{-152,80}})));
  Modelica.Blocks.Sources.IntegerExpression chiNumOn(y=
        Modelica.Math.BooleanVectors.countTrue(chiWSE.on[1:numChi]))
    "The number of running chillers"
    annotation (Placement(transformation(extent={{-260,54},{-238,76}})));
  Modelica.Blocks.Math.Gain gai[numChi](
    each k=m1_flow_chi_nominal) "Gain effect"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingTowerSpeed cooTowSpeCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0,
    Ti=60,
    k=0.1)
    "Cooling tower speed control"
    annotation (Placement(transformation(extent={{-170,168},{-150,186}})));
  Modelica.Blocks.Sources.RealExpression TCWSupSet(
    y(unit="K")=min(29.44 + 273.15, max(273.15 + 15.56, cooTow[1].TAir + 6)))
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-260,176},{-240,196}})));

  Modelica.Blocks.Sources.Constant TAirSupSet(k=TSupAirSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage varSpeCon(
    tWai=tWai,
    m_flow_nominal=m2_flow_chi_nominal,
    deaBanSpe=0.45)
    "Speed controller"
    annotation (Placement(transformation(extent={{-168,-14},{-148,6}})));
  Modelica.Blocks.Sources.RealExpression mPum_flow(y=ahu.port_a1.m_flow)
    "Mass flowrate of variable speed pumps"
    annotation (Placement(transformation(extent={{-220,-6},{-200,14}})));
  Buildings.Controls.Continuous.LimPID pumSpe(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=40,
    yMin=0.2,
    k=0.1)
    "Pump speed controller"
    annotation (Placement(transformation(extent={{-246,-30},{-226,-10}})));
  Modelica.Blocks.Sources.Constant dpSetSca(k=1)
    "Scaled differential pressure setpoint"
    annotation (Placement(transformation(extent={{-280,-30},{-260,-10}})));
  Modelica.Blocks.Math.Product pumSpeSig[numChi]
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.Continuous.LimPID ahuValSig(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=40,
    reverseAction=true,
    yMin=yValMinAHU,
    k=0.01)          "Valve position signal for the AHU"
    annotation (Placement(transformation(extent={{-82,-90},{-62,-70}})));
  Modelica.Blocks.Math.Product cooTowSpe[numChi] "Cooling tower speed"
    annotation (Placement(transformation(extent={{-60,162},{-40,182}})));

  Buildings.Controls.Continuous.LimPID ahuFanSpeCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    reverseAction=true,
    yMin=0.2,
    Ti=240)   "Fan speed controller "
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Modelica.Blocks.Sources.Constant TAirRetSet(k=TRetAirSet)
    "Return air temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Utilities.Psychrometrics.X_pTphi XAirSupSet(use_p_in=false)
    "Mass fraction setpoint of supply air "
    annotation (Placement(transformation(extent={{-140,-100},{-120,-120}})));
  Modelica.Blocks.Sources.Constant phiAirRetSet(k=0.5)
    "Return air relative humidity setpoint"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  Modelica.Blocks.Math.Gain gai1(each k=1/dpSetPoi) "Gain effect"
    annotation (Placement(transformation(extent={{-200,-70},{-220,-50}})));
  Modelica.Blocks.Math.Product sigCWLoo[numChi] "Singal for CW loop"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Modelica.Blocks.Math.Product sigPumCHW[numChi] "Singal for CHW pump"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Fluid.FixedResistances.Pipe pipCW(
    redeclare package Medium = MediumW,
    nSeg=4,
    thicknessIns=0.02,
    lambdaIns=0.01,
    length=1000,
    m_flow_nominal=numChi*m1_flow_chi_nominal,
    v_nominal=0.5,
    dp_nominal=180000)
    annotation (Placement(transformation(extent={{48,50},{68,70}})));
  Buildings.Fluid.FixedResistances.Pipe pipCHW(
    redeclare package Medium = MediumW,
    nSeg=4,
    thicknessIns=0.02,
    lambdaIns=0.01,
    length=1000,
    m_flow_nominal=numChi*m2_flow_chi_nominal,
    v_nominal=1,
    dp_nominal=360000)
    annotation (Placement(transformation(extent={{68,-10},{48,10}})));


  Buildings.Applications.DataCenters.ChillerCooled.Paper.BaseClasses.wseStage
    wseSta
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Fluid.FixedResistances.PressureDrop duc(
    m_flow_nominal=mAir_flow_nominal,
    redeclare package Medium = MediumA,
    dp_nominal=200)                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={32,-162})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{80,-180},{60,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant loa(k=QRoo_flow)
    annotation (Placement(transformation(extent={{120,-200},{100,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1
    annotation (Placement(transformation(extent={{-90,-148},{-70,-128}})));
  Modelica.Blocks.Continuous.Filter filter(f_cut=1/0.01)
    annotation (Placement(transformation(extent={{120,-170},{100,-150}})));
equation
  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{0,24},{-8,24},{-8,0},{-16,0}},
      color={0,127,255},
      thickness=0.5));
  for i in 1:numChi loop
    connect(cooTow[i].TAir, weaBus.TWetBul.TWetBul)
      annotation (Line(points={{22,144},{44,144},{44,200},{-340,200},{-340,-20},
            {-328,-20}},
            color={255,204,51},
        thickness=0.5));
    connect(TCWSup.port_a, cooTow[i].port_b)
      annotation (Line(
        points={{-22,140},{0,140}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{-50,110},{-50,140},{-42,140}},
        color={0,127,255},
        thickness=0.5));
    connect(TCWRet.port_b, val[i].port_a) annotation (Line(points={{102,60},{
            110,60},{110,140},{70,140}},
            color={0,127,255},
            thickness=0.5));
  end for;
  connect(senRelPre.port_b, ahu.port_b1)
    annotation (Line(points={{18,-96},{30,-96},{30,-114},{20,-114}},
                color={0,127,255},thickness=0.5));
  connect(cooTow.port_a, val.port_b)
    annotation (Line(points={{20,140},{50,140}},
      color={0,127,255},
      thickness=0.5));

  connect(TCWRet.port_b, expVesCW.ports[1])
    annotation (Line(points={{102,60},{110,60},{110,140.5},{122,140.5}},
    color={0,127,255},
    thickness=0.5));
  connect(ahu.port_b1, expVesChi.ports[1])
    annotation (Line(
      points={{20,-114},{122,-114},{122,-113}},
      color={0,127,255},
      thickness=0.5));

  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{0,24},{-8,24},{-8,0},{-16,0}},
      color={0,127,255},
      thickness=0.5));
  connect(weaData.weaBus, weaBus.TWetBul)
    annotation (Line(
      points={{-340,-70},{-328,-70},{-328,-20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
   for i in 1:numChi loop
    connect(TCWSup.port_a, cooTow[i].port_b)
      annotation (Line(
        points={{-22,140},{0,140}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_b, chiWSE.port_a1)
      annotation (Line(
        points={{-50,90},{-50,64},{-12,64},{-12,36},{0,36}},
        color={0,127,255},
        thickness=0.5));
   connect(cooTowSpeCon.y, cooTowSpe[i].u1)
     annotation (Line(
       points={{-149,178},{-62,178}},
       color={0,0,127}));
   end for;
  connect(chiStaCon.y, chiOn.u)
    annotation (Line(
      points={{-149,140},{-142,140}},
      color={0,0,127}));
  connect(TCWSupSet.y, cooTowSpeCon.TCWSupSet)
    annotation (Line(
      points={{-239,186},{-172,186}},
      color={0,0,127}));
  connect(TCHWSupSet.y, cooTowSpeCon.TCHWSupSet)
    annotation (Line(
      points={{-239,160},{-184,160},{-184,178},{-172,178}},
      color={0,0,127}));
  connect(TCWSup.T, cooTowSpeCon.TCWSup)
    annotation (Line(
      points={{-32,151},{-32,160},{-182,160},{-182,174},{-172,174}},
      color={0,0,127}));
  connect(TCHWSup.T, cooTowSpeCon.TCHWSup)
    annotation (Line(
      points={{-26,11},{-26,18},{-180,18},{-180,170},{-172,170}},
      color={0,0,127}));
  connect(chiWSE.TSet, TCHWSupSet.y)
    annotation (Line(
      points={{-1.6,40.8},{-20,40.8},{-20,52},{-230,52},{-230,160},{-239,160}},
      color={0,0,127}));
  connect(mPum_flow.y, varSpeCon.masFloPum)
    annotation (Line(
      points={{-199,4},{-170,4}},
      color={0,0,127}));
  connect(senRelPre.port_a, ahu.port_a1)
    annotation (Line(
      points={{-2,-96},{-14,-96},{-14,-114},{0,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(pumSpe.y, varSpeCon.speSig)
    annotation (Line(
      points={{-225,-20},{-196,-20},{-196,0},{-170,0}},
      color={0,0,127}));
  connect(dpSetSca.y, pumSpe.u_s)
    annotation (Line(points={{-259,-20},{-248,-20}}, color={0,0,127}));
  connect(pumSpe.y, pumSpeSig[1].u2)
    annotation (Line(
      points={{-225,-20},{-196,-20},{-196,-36},{-136,-36},{-136,-16},{-122,-16}},
      color={0,0,127}));
  connect(pumSpe.y, pumSpeSig[2].u2)
    annotation (Line(
      points={{-225,-20},{-196,-20},{-196,-36},{-136,-36},{-136,-16},{-122,-16}},
      color={0,0,127}));
  connect(varSpeCon.y, pumSpeSig.u1)
    annotation (Line(
      points={{-147,-4},{-122,-4}},
      color={0,0,127}));
  connect(TAirSupSet.y, ahuValSig.u_s)
    annotation (Line(
      points={{-119,-80},{-84,-80}},
      color={0,0,127}));
  connect(TAirSup.port_a, ahu.port_b2)
    annotation (Line(
      points={{-50,-150},{-50,-126},{0,-126}},
      color={0,127,255},
      thickness=0.5));
  connect(TAirSup.T, ahuValSig.u_m)
    annotation (Line(
      points={{-61,-160},{-72,-160},{-72,-92}},
      color={0,0,127}));
  connect(ahuValSig.y, ahu.uVal)
    annotation (Line(
      points={{-61,-80},{-52,-80},{-52,-116},{-1,-116}},
      color={0,0,127}));
  connect(TAirSupSet.y, ahu.TSet)
    annotation (Line(
      points={{-119,-80},{-100,-80},{-100,-121},{-1,-121}},
      color={0,0,127}));
  connect(TCHWRet.port_a, ahu.port_b1)
    annotation (Line(
      points={{100,0},{110,0},{110,-114},{20,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(chiNumOn.y, CWPumCon.numOnChi)
    annotation (Line(
      points={{-236.9,65},{-174,65}},
      color={255,127,0}));

  connect(roo.airPorts[1], TAirSup.port_b)
    annotation (Line(
      points={{1.525,-188.7},{1.525,-196},{-50,-196},{-50,-170}},
      color={0,127,255},
      thickness=0.5));
  connect(roo.TRooAir, ahuFanSpeCon.u_m)
    annotation (Line(
      points={{-7,-180},{-110,-180},{-110,-172}},
      color={0,0,127}));
  connect(TAirRetSet.y, ahuFanSpeCon.u_s)
    annotation (Line(
      points={{-159,-160},{-122,-160}},
      color={0,0,127}));
  connect(phiAirRetSet.y, XAirSupSet.phi)
    annotation (Line(
      points={{-159,-90},{-150,-90},{-150,-104},{-142,-104}},
      color={0,0,127}));
  connect(XAirSupSet.X[1], ahu.XSet_w)
    annotation (Line(
      points={{-119,-110},{-60,-110},{-60,-119},{-1,-119}},
      color={0,0,127}));
  connect(TAirRetSet.y, XAirSupSet.T)
    annotation (Line(
      points={{-159,-160},{-150,-160},{-150,-110},{-142,-110}},
      color={0,0,127}));
  connect(gai1.y, pumSpe.u_m) annotation (Line(points={{-221,-60},{-236,-60},{
          -236,-32}}, color={0,0,127}));
  connect(gai1.u, senRelPre.p_rel)
    annotation (Line(points={{-198,-60},{8,-60},{8,-87}}, color={0,0,127}));
  connect(CWPumCon.y, sigCWLoo.u2) annotation (Line(points={{-151,70},{-146,70},
          {-146,64},{-142,64}}, color={0,0,127}));
  connect(sigCWLoo.y, cooTowSpe.u2) annotation (Line(points={{-119,70},{-110,70},
          {-110,90},{-72,90},{-72,166},{-62,166}}, color={0,0,127}));
  connect(sigCWLoo.y, gai.u)
    annotation (Line(points={{-119,70},{-102,70}}, color={0,0,127}));
  connect(gai.y, pumCW.m_flow_in) annotation (Line(points={{-79,70},{-70,70},{
          -70,100},{-62,100}}, color={0,0,127}));
  connect(cooTowSpe.y, cooTow.y) annotation (Line(points={{-39,172},{32,172},{
          32,148},{22,148}}, color={0,0,127}));
  connect(pumSpeSig.y, sigPumCHW.u2) annotation (Line(points={{-99,-10},{-92,
          -10},{-92,-16},{-82,-16}}, color={0,0,127}));
  connect(chiWSE.port_b1, pipCW.port_a) annotation (Line(points={{20,36},{40,36},
          {40,60},{48,60}}, color={0,127,255}));
  connect(pipCW.port_b, TCWRet.port_a)
    annotation (Line(points={{68,60},{82,60}}, color={0,127,255}));
  connect(pipCHW.port_a, TCHWRet.port_b)
    annotation (Line(points={{68,0},{80,0}}, color={0,127,255}));
  connect(ahu.port_a2, duc.port_b) annotation (Line(points={{20,-126},{32,-126},
          {32,-152}}, color={0,127,255}));
  connect(duc.port_a, roo.airPorts[2]) annotation (Line(points={{32,-172},{32,-196},
          {5.575,-196},{5.575,-188.7}}, color={0,127,255}));
  connect(loa.y, pro.u2) annotation (Line(points={{99,-190},{94,-190},{94,-176},
          {82,-176}}, color={0,0,127}));
  connect(pro.y, roo.QRoo_flow) annotation (Line(points={{59,-170},{52,-170},{
          52,-184},{24,-184},{24,-171.4},{16,-171.4}}, color={0,0,127}));
  connect(ahuFanSpeCon.y, pro1.u2) annotation (Line(points={{-99,-160},{-98,
          -160},{-98,-144},{-92,-144}}, color={0,0,127}));
  connect(pro1.y, ahu.uFan) annotation (Line(points={{-69,-138},{-36,-138},{-36,
          -124},{-1,-124}}, color={0,0,127}));
  connect(filter.y, pro.u1) annotation (Line(points={{99,-160},{92,-160},{92,
          -164},{82,-164}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-360,-200},{160,220}})),
    Documentation(info="<html>
<p>
This is a partial model that describes the chilled water cooling system in a data center. The sizing data
are collected from the reference.
</p>
<h4>Reference </h4>
<ul>
<li>
Taylor, S. T. (2014). How to design &amp; control waterside economizers. ASHRAE Journal, 56(6), 30-36.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
December 1, 2017, by Yangyang Fu:<br/>
Used scaled differential pressure to control the speed of pumps. This can avoid retuning gains 
in PID when changing the differential pressure setpoint.
</li>
<li>
September 2, 2017, by Michael Wetter:<br/>
Changed expansion vessel to use the more efficient implementation.
</li>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialDataCenter;
