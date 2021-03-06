function InfoTable = SingPlot_PowerConsumer(baseTime,structData,altStruct)
fprintf('----------------------------------------------\n')
% time = baseTime;
time = structData.time_cal;
children = fieldnames(structData);
nChildren = length(children);
nrow = ceil(sqrt(nChildren));
ncol = ceil(nChildren/nrow);
fig = figure;
fig.Name = mfilename;
ylabelstr = {...
    '全程电压','全程电流','全程功率','GroundStandby功率','TakeOff功率','HoverAdjust功率',...
    'Rotor2fix功率','HoverUp功率','PathFollow功率','GoHome功率','HoverDown功率','Fix2Rotor功率','Land功率','time'};
idx_nz = 1:length(structData.(children{1}));
for i = 1:nChildren
    subplot(nrow,ncol,i)
    plot(time,structData.(children{i}));
    grid on;
    xlabel('time (sec)');
    ylabel(ylabelstr{i})
end
%%
unit_current = 'A';
unit_voltage = 'V';
unit_power = 'W';
%% 显示信息
alt = altStruct.value;
time_alt = altStruct.time;
temp = max(alt);
maxAlt = temp(1);
temp = min(alt);
minAlt = temp(1);
maxFlightHeight = maxAlt - minAlt;
val_TakeOff = structData.TakeOff;
val_HoverAdjust = structData.HoverAdjust;
val_Rotor2fix = structData.Rotor2fix;
val_HoverUp = structData.HoverUp;
val_PathFollow = structData.PathFollow;
val_GoHome = structData.GoHome;
val_HoverDown = structData.HoverDown;
val_Fix2Rotor = structData.Fix2Rotor;
val_GroundStandby = structData.GroundStandby;
val_Land = structData.Land;
% val_AirStandBy = structData.AirStandBy;
% TakeOff    --------------------------------------------------------------
Struct_TakeOff = calParam(time,val_TakeOff,structData);
% Rotor2fix    ------------------------------------------------------------
Struct_Rotor2fix = calParam(time,val_Rotor2fix,structData);
% HoverUp    --------------------------------------------------------------
Struct_HoverUp = calParam(time,val_HoverUp,structData);
% PathFollow --------------------------------------------------------------
Struct_PathFollow = calParam(time,val_PathFollow,structData);
% GoHome     --------------------------------------------------------------
Struct_GoHome = calParam(time,val_GoHome,structData);
% HoverDown    ------------------------------------------------------------
Struct_HoverDown = calParam(time,val_HoverDown,structData);
% Fix2Rotor    ------------------------------------------------------------
Struct_Fix2Rotor = calParam(time,val_Fix2Rotor,structData);
% Land      ---------------------------------------------------------------
Struct_Land = calParam(time,val_Land,structData);
% HoverAdjust -------------------------------------------------------------
Struct_HoverAdjust = calParam(time,val_HoverAdjust,structData);
% GroundStandby -----------------------------------------------------------
Struct_GroundStandby = calParam(time,val_GroundStandby,structData);
% 全局
Struct_InAir.t0 = Struct_TakeOff(1).t0;
Struct_InAir.tf = Struct_Land(end).tf;
Struct_InAir.du = Struct_InAir.tf - Struct_InAir.t0;

Struct_InAir.p0 = structData.AllTheTimePowerConsume(Struct_TakeOff.idx(1));
Struct_InAir.pf = structData.AllTheTimePowerConsume(Struct_Land.idx(end));
Struct_InAir.pErr = Struct_InAir.p0-Struct_InAir.pf;
% 单位时间耗电量 [%/sec]
Struct_InAir.powerPerSec_up = round((Struct_InAir.pErr+0.9)/Struct_InAir.du,3);
Struct_InAir.powerPerSec_mid = round((Struct_InAir.pErr)/Struct_InAir.du,3);
Struct_InAir.powerPerSec_low = round(max(0.1,Struct_InAir.pErr-0.9)/Struct_InAir.du,3);
% 单位电量的续航时间 [sec/%]
Struct_InAir.duPerPower_low = 1/Struct_InAir.powerPerSec_up;
Struct_InAir.duPerPower_mid = 1/Struct_InAir.powerPerSec_mid;
Struct_InAir.duPerPower_up = 1/Struct_InAir.powerPerSec_low;
% 平均电流、电压、功率
Struct_InAir.averageCurrent = 0;
Struct_InAir.averageVoltage = 0;
Struct_InAir.averagePower = 0;
% 构造数据table
Info_duration = [...
    Struct_TakeOff.du;...
    Struct_Rotor2fix.du;...
    Struct_HoverUp.du;...
    Struct_PathFollow.du;...
    Struct_GoHome.du;...
    Struct_HoverDown.du;...
    Struct_Fix2Rotor.du;...
    Struct_Land.du;...
    Struct_HoverAdjust.du;...
    Struct_GroundStandby.du;...
    Struct_InAir.du;];
Info_pErr = [...
    Struct_TakeOff.pErr;...
    Struct_Rotor2fix.pErr;...
    Struct_HoverUp.pErr;...
    Struct_PathFollow.pErr;...
    Struct_GoHome.pErr;...
    Struct_HoverDown.pErr;...
    Struct_Fix2Rotor.pErr;...
    Struct_Land.pErr;...
    Struct_HoverAdjust.pErr;...
    Struct_GroundStandby.pErr;...   
    Struct_InAir.pErr;];
Info_powerPerSec = {...
    mat2str([Struct_TakeOff.powerPerSec_low,       Struct_TakeOff.powerPerSec_mid,       Struct_TakeOff.powerPerSec_up]);...
    mat2str([Struct_Rotor2fix.powerPerSec_low,     Struct_Rotor2fix.powerPerSec_mid,     Struct_Rotor2fix.powerPerSec_up]);...
    mat2str([Struct_HoverUp.powerPerSec_low,       Struct_HoverUp.powerPerSec_mid,       Struct_HoverUp.powerPerSec_up]);...
    mat2str([Struct_PathFollow.powerPerSec_low,    Struct_PathFollow.powerPerSec_mid,    Struct_PathFollow.powerPerSec_up]);...
    mat2str([Struct_GoHome.powerPerSec_low,        Struct_GoHome.powerPerSec_mid,        Struct_GoHome.powerPerSec_up]);...
    mat2str([Struct_HoverDown.powerPerSec_low,     Struct_HoverDown.powerPerSec_mid,     Struct_HoverDown.powerPerSec_up]);...
    mat2str([Struct_Fix2Rotor.powerPerSec_low,     Struct_Fix2Rotor.powerPerSec_mid,     Struct_Fix2Rotor.powerPerSec_up]);...
    mat2str([Struct_Land.powerPerSec_low,          Struct_Land.powerPerSec_mid,          Struct_Land.powerPerSec_up]);...
    mat2str([Struct_HoverAdjust.powerPerSec_low,   Struct_HoverAdjust.powerPerSec_mid,   Struct_HoverAdjust.powerPerSec_up]);...
    mat2str([Struct_GroundStandby.powerPerSec_low, Struct_GroundStandby.powerPerSec_mid, Struct_GroundStandby.powerPerSec_up]);...
    mat2str([Struct_InAir.powerPerSec_low,         Struct_InAir.powerPerSec_mid,         Struct_InAir.powerPerSec_up]);};

Info_duPerPower = {...
    mat2str(round([Struct_TakeOff.duPerPower_low,       Struct_TakeOff.duPerPower_mid,       Struct_TakeOff.duPerPower_up],0));...
    mat2str(round([Struct_Rotor2fix.duPerPower_low,     Struct_Rotor2fix.duPerPower_mid,     Struct_Rotor2fix.duPerPower_up],0));...
    mat2str(round([Struct_HoverUp.duPerPower_low,       Struct_HoverUp.duPerPower_mid,       Struct_HoverUp.duPerPower_up],0));...
    mat2str(round([Struct_PathFollow.duPerPower_low,    Struct_PathFollow.duPerPower_mid,    Struct_PathFollow.duPerPower_up],0));...
    mat2str(round([Struct_GoHome.duPerPower_low,        Struct_GoHome.duPerPower_mid,        Struct_GoHome.duPerPower_up],0));...
    mat2str(round([Struct_HoverDown.duPerPower_low,     Struct_HoverDown.duPerPower_mid,     Struct_HoverDown.duPerPower_up],0));...
    mat2str(round([Struct_Fix2Rotor.duPerPower_low,     Struct_Fix2Rotor.duPerPower_mid,     Struct_Fix2Rotor.duPerPower_up],0));...
    mat2str(round([Struct_Land.duPerPower_low,          Struct_Land.duPerPower_mid,          Struct_Land.duPerPower_up],0));...
    mat2str(round([Struct_HoverAdjust.duPerPower_low,   Struct_HoverAdjust.duPerPower_mid,   Struct_HoverAdjust.duPerPower_up],0));...
    mat2str(round([Struct_GroundStandby.duPerPower_low, Struct_GroundStandby.duPerPower_mid, Struct_GroundStandby.duPerPower_up],0));...    
    mat2str(round([Struct_InAir.duPerPower_low,         Struct_InAir.duPerPower_mid,         Struct_InAir.duPerPower_up],0));};

Info_AveCurrent = [...
    Struct_TakeOff.averageCurrent;...
    Struct_Rotor2fix.averageCurrent;...
    Struct_HoverUp.averageCurrent;...
    Struct_PathFollow.averageCurrent;...
    Struct_GoHome.averageCurrent;...
    Struct_HoverDown.averageCurrent;...
    Struct_Fix2Rotor.averageCurrent;...
    Struct_Land.averageCurrent;...
    Struct_HoverAdjust.averageCurrent;...
    Struct_GroundStandby.averageCurrent;];
Struct_InAir.averageCurrent = mean(Info_AveCurrent(1:end-1));
Info_AveCurrent = [Info_AveCurrent;Struct_InAir.averageCurrent];

Info_AveVoltage = [...
    Struct_TakeOff.averageVoltage;...
    Struct_Rotor2fix.averageVoltage;...
    Struct_HoverUp.averageVoltage;...
    Struct_PathFollow.averageVoltage;...
    Struct_GoHome.averageVoltage;...
    Struct_HoverDown.averageVoltage;...
    Struct_Fix2Rotor.averageVoltage;...
    Struct_Land.averageVoltage;...
    Struct_HoverAdjust.averageVoltage;...
    Struct_GroundStandby.averageVoltage];
Struct_InAir.averageVoltage = mean(Info_AveVoltage(1:end-1));
Info_AveVoltage = [Info_AveVoltage;Struct_InAir.averageVoltage];

Info_AvePower = [...
    Struct_TakeOff.averagePower;...
    Struct_Rotor2fix.averagePower;...
    Struct_HoverUp.averagePower;...
    Struct_PathFollow.averagePower;...
    Struct_GoHome.averagePower;...
    Struct_HoverDown.averagePower;...
    Struct_Fix2Rotor.averagePower;...
    Struct_Land.averagePower;...
    Struct_HoverAdjust.averagePower;...
    Struct_GroundStandby.averagePower];
Struct_InAir.averagePower = mean(Info_AvePower(1:end-1));
Info_AvePower = [Info_AvePower;Struct_InAir.averagePower];

Info_AvePowerRatio = Info_AvePower./Struct_PathFollow.averagePower;

Info_estWh = [...
    Struct_TakeOff.estimateWh;...
    Struct_Rotor2fix.estimateWh;...
    Struct_HoverUp.estimateWh;...
    Struct_PathFollow.estimateWh;...
    Struct_GoHome.estimateWh;...
    Struct_HoverDown.estimateWh;...
    Struct_Fix2Rotor.estimateWh;...
    Struct_Land.estimateWh;...
    Struct_HoverAdjust.estimateWh;...
    Struct_GroundStandby.estimateWh;];
Struct_InAir.estimateWh = sum(Info_estWh(1:end-1));
Info_estWh = [Info_estWh;Struct_InAir.estimateWh];
%
% InfoTable = table(TakeOff,Rotor2fix,HoverUp,PathFollow,GoHome,HoverDown,Fix2Rotor,Land,InAir);
% InfoTable.Row = {'飞行时间[sec]','耗电量[%]','每秒耗电[%/sec]','单位电量续航[sec/%]'};
% InfoTable

InfoTable = table(Info_duration,Info_pErr,Info_powerPerSec,Info_duPerPower,Info_AveCurrent,Info_AveVoltage,Info_AvePower,Info_AvePowerRatio,Info_estWh);
InfoTable.Row = {'TakeOff','Rotor2fix','HoverUp','PathFollow','GoHome','HoverDown','Fix2Rotor','Land','HoverAdjust','GroundStandby','全程'};
InfoTable.Properties.VariableNames = {'续航时间[sec]','耗电量[%]','每秒耗电量[%/sec]','单位电量续航[sec/%]','平均电流','平均电压','平均功耗','平均功耗比','估计Wh'};
InfoTable
%% 子函数
function Struct = calParam(time,val,structData)
idxAll = find(val~=0);
varname = inputname(2);
flagIdx = strfind(varname,'_');
modeName = varname(flagIdx+1:end);
if isempty(idxAll)
    fprintf('该数据没有%s模式\n',modeName);
    idxAll = 1;
end
timeAll = time(idxAll);
timeDiff = diff(timeAll);
idxPhase = find(timeDiff>5); % 当时间间隔大于5s时，认为是两个阶段
if ~isempty(idxPhase)
    nPhase = length(idxPhase)+1;
    fprintf('该数据有%d个%s模式\n',nPhase,modeName);
    idxSel{1} = [1:idxPhase(1)];
    for i = 2:nPhase
        if i == nPhase
            temp = length(timeAll)-1;
            idxSel{i} = [idxPhase(i-1)+1:temp]; 
        else
            idxSel{i} = [idxPhase(i-1)+1:idxPhase(i)]; 
        end
    end
    test = 1;
else
    nPhase = 1;
    if length(timeAll) > 1
        temp = length(timeAll)-1;
        idxSel{1} = 1:temp;
    else
        idxSel{1} = 1;
    end
end
for i_p = 1:nPhase
    tempStruct(i_p).time = timeAll(idxSel{i_p});
    tempStruct(i_p).idx = idxAll(idxSel{i_p});
    
    tempStruct(i_p).t0 = tempStruct(i_p).time(1);
    tempStruct(i_p).tf = tempStruct(i_p).time(end);
    tempStruct(i_p).du = tempStruct(i_p).tf - tempStruct(i_p).t0;
    tempStruct(i_p).p0 = structData.AllTheTimePowerConsume(tempStruct(i_p).idx(1));
    tempStruct(i_p).pf = structData.AllTheTimePowerConsume(tempStruct(i_p).idx(end));
    tempStruct(i_p).pErr = tempStruct(i_p).p0-tempStruct(i_p).pf;
    tempStruct(i_p).powerPerSec_up = round((tempStruct(i_p).pErr+0.9)/(tempStruct(i_p).du+0.1),3);
    tempStruct(i_p).powerPerSec_mid = round(max(0.1,tempStruct(i_p).pErr)/(tempStruct(i_p).du+0.1),3);
    tempStruct(i_p).powerPerSec_low = round(max(0.1,tempStruct(i_p).pErr-0.9)/(tempStruct(i_p).du+0.1),3);
    tempStruct(i_p).duPerPower_low = 1/tempStruct(i_p).powerPerSec_up;
    tempStruct(i_p).duPerPower_mid = 1/tempStruct(i_p).powerPerSec_mid;
    tempStruct(i_p).duPerPower_up = 1/tempStruct(i_p).powerPerSec_low;
    tempStruct(i_p).averageCurrent = mean(structData.AllTheTimeCurrent(tempStruct(i_p).idx(1):tempStruct(i_p).idx(end)));
    tempStruct(i_p).averageVoltage = mean(structData.AllTheTimeVoltage(tempStruct(i_p).idx(1):tempStruct(i_p).idx(end)));
    tempStruct(i_p).averagePower = mean(structData.AllTheTimeCurrent(tempStruct(i_p).idx(1):tempStruct(i_p).idx(end)).*...
        structData.AllTheTimeVoltage(tempStruct(i_p).idx(1):tempStruct(i_p).idx(end)));
    if i_p == 1
        Struct = tempStruct;
    else
        Struct.du = [Struct.du, tempStruct(i_p).du];
        Struct.pErr = [Struct.pErr, tempStruct(i_p).pErr];
        Struct.powerPerSec_up = [Struct.powerPerSec_up, tempStruct(i_p).powerPerSec_up];
        Struct.powerPerSec_mid = [Struct.powerPerSec_mid, tempStruct(i_p).powerPerSec_mid];
        Struct.powerPerSec_low = [Struct.powerPerSec_low, tempStruct(i_p).powerPerSec_low];
        Struct.duPerPower_low = [Struct.duPerPower_low, tempStruct(i_p).duPerPower_low];
        Struct.powerPerSec_mid = [Struct.powerPerSec_mid, tempStruct(i_p).powerPerSec_mid];
        Struct.duPerPower_up = [Struct.duPerPower_up, tempStruct(i_p).duPerPower_up];
        Struct.averageCurrent = [Struct.averageCurrent tempStruct(i_p).averageCurrent];
        Struct.averageVoltage = [Struct.averageVoltage tempStruct(i_p).averageVoltage];
        Struct.averagePower = [Struct.averagePower tempStruct(i_p).averagePower];
    end    
end
Struct.t0 = tempStruct(1).t0;
Struct.tf = tempStruct(end).tf;
Struct.du = round(sum(Struct.du),2);
Struct.pErr = round(sum(Struct.pErr),2);
Struct.powerPerSec_up = round(mean(Struct.powerPerSec_up),3);
Struct.powerPerSec_mid = round(mean(Struct.powerPerSec_mid),3);
Struct.powerPerSec_low = round(mean(Struct.powerPerSec_low),3);
Struct.duPerPower_low = round(mean(Struct.duPerPower_low),3);
Struct.powerPerSec_mid = round(mean(Struct.powerPerSec_mid),3);
Struct.duPerPower_up = round(mean(Struct.duPerPower_up),3);
Struct.averageCurrent = round(abs(mean(Struct.averageCurrent)/1000),3);
Struct.averageVoltage = round(mean(Struct.averageVoltage)/1000,3);
Struct.averagePower = round(abs(mean(Struct.averagePower)/1000/1000),3);
Struct.estimateWh = round(1/3600 * Struct.du * abs(Struct.averagePower),3);