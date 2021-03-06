temp_old_pathname = cd;
temp_pathname = mfilename('fullpath');
temp = strfind(temp_pathname,'\');
temp_pathname = temp_pathname(1:temp(end));
cd(temp_pathname)
%%
modelname = 'RefModel_SystemArchitecture';
infofilename = 'SystemInfo.mat';
%% 载入模型
load_system(modelname);
open_system([modelname,'/SystemInfo/']);
%%
try
    load(infofilename);
    SystemInfo.version = num2str(str2num(SystemInfo.version) + 0.001);
    SystemInfo.task_version = num2str(str2num(SystemInfo.task_version) + 0.001);
    SystemInfo.control_version = num2str(str2num(SystemInfo.control_version) + 0.001);
catch
    SystemInfo.version = '';
    SystemInfo.date = '';
    SystemInfo.task_version = '';
    SystemInfo.control_version = '';
end
tempTime = clock;
SystemInfo.date = [ num2str(tempTime(1)),...年
                    num2str(tempTime(2)),...月
                    num2str(tempTime(3));];%日
prompt = {'飞控版本号','时间','任务等模型版本号','控制模型版本号'};
dlgtitle = '系统信息';
dims = [1 55];

definput = {SystemInfo.version,SystemInfo.date,SystemInfo.task_version,SystemInfo.control_version};
answer = inputdlg(prompt,dlgtitle,dims,definput);
%%
SystemInfo.version = answer{1};
SystemInfo.date = answer{2};
SystemInfo.task_version = answer{3};
SystemInfo.control_version = answer{4};
set_param([modelname,'/SystemInfo/version'],'value',SystemInfo.version)
set_param([modelname,'/SystemInfo/date'],'value',SystemInfo.date)
set_param([modelname,'/SystemInfo/task_version'],'value',SystemInfo.task_version)
set_param([modelname,'/SystemInfo/control_version'],'value',SystemInfo.control_version)
save_system(modelname);
pause(2);
%% 编译
rtwbuild(modelname)
%% 保存系统信息
save(infofilename,'SystemInfo')
%% 跳转回原目录
cd(temp_old_pathname)
