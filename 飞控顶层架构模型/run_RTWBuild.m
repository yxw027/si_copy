modelname = 'RefModel_SystemArchitecture';
infofilename = 'SystemInfo.mat';
%% 载入模型
load_system(modelname);
open_system([modelname,'/SystemInfo/']);
%%
try
    load(infofilename);
    SystemInfo.version = num2str(str2num(SystemInfo.version) + 0.001);
catch
    SystemInfo.version = '';
    SystemInfo.date = '';
end
tempTime = clock;
SystemInfo.date = [ num2str(tempTime(1)),...年
                    num2str(tempTime(2)),...月
                    num2str(tempTime(3));];%日
prompt = {'版本号','时间'};
dlgtitle = '系统信息';
dims = [1 55];

definput = {SystemInfo.version,SystemInfo.date};
answer = inputdlg(prompt,dlgtitle,dims,definput);
%%
SystemInfo.version = answer{1};
SystemInfo.date = answer{2};
set_param([modelname,'/SystemInfo/version'],'value',SystemInfo.version)
set_param([modelname,'/SystemInfo/date'],'value',SystemInfo.date)
save_system(modelname);
pause(2);
%% 编译
rtwbuild(modelname)
%% 保存系统信息
save(infofilename,'SystemInfo')