clear,clc
proj = currentProject;
SetGlobalParam();
tspan0 = [0,inf]; % sec
% dataFileNames = {[proj.RootFolder{1},'20200430\日志数据_log_6_V1000 24# V31137固件调参全流程飞行']};
% dataFileNames = {[proj.RootFolder{1},'\SubFolder_飞行数据\20200618\仿真数据_log_2020年6月18日 V1000-27# 毫米波v1']};
% dataFileNames = {[proj.RootFolder{1},'\SubFolder_飞行数据\20200618\仿真数据_2020-06-18 15-53-05 起落1']};
% dataFileNames = {[proj.RootFolder{1},'\SubFolder_飞行数据\20200618\仿真数据_2020-06-18 15-56-04 起落2']};
% dataFileNames = {[proj.RootFolder{1},'\SubFolder_飞行数据\20200618\仿真数据_2020-06-18 15-59-02 起落3']};
% dataFileNames = {[proj.RootFolder{1},'\SubFolder_飞行数据\20200618\仿真数据_2020-06-18 16-02-53 起落4']};
dataFileNames = {[proj.RootFolder{1},'\SubFolder_飞行数据\20200820\4+1 起降\仿真数据_log 6 2020-08-20 11-40-02']};
dataFileNames = {[proj.RootFolder{1},'\SubFolder_飞行数据\20200820\4+1 起降\仿真数据_log 5 2020-08-20 11-36-49']};
dataFileNames = {[proj.RootFolder{1},'\SubFolder_飞行数据\20200820\仿真数据_长航时 2 2020-08-20 12-32-56']};

nFlightDataFile = length(dataFileNames);
for i = 1:nFlightDataFile
    [IN_SENSOR(i),IN_SENSOR_SIM(i),sensors(i),tspan_set{i}] = step1_loadFlightData(tspan0,dataFileNames{i},BUS_SENSOR);
end
tspan = tspan_set{1};
INIT_Navi
INIT_SensorIntegrity
INIT_SensorAlignment
INIT_SensorFault

figure;
plot(IN_SENSOR.radar1.time,IN_SENSOR.radar1.Range);hold on;
plot(IN_SENSOR.radar1.time,IN_SENSOR.radar1.Flag);hold on;

%% 运行模型
sim('TESTENV_SignalIntegrity')