%主程序，在仿真环境中，得到离线指纹库，以及在线阶段的测试数据，用于以后的定位测试。

%% 基于射线跟踪技术生成仿真环境
if ~exist('radio_map_20_15.mat', 'file') %如果还没有生成仿真环境
    disp('正在模拟射线跟踪...');
    generate_radio_map(0.01);
end

clc
clear;
load radio_map_20_15.mat; 
%变量为fingerprint %默认尺寸为20m*15m * 6ap，网格大小为0.01m
%注意：这里的仿真环境（fingerprint）是一个精度很高的指纹库，后面从这个仿真环境中进行取样（采集数据）并生成用于定位的指纹库。

%% 获取离线指纹库
%如果要研究指纹库构建上的优化，在这部分改进
[offline_rss, offline_location] = get_offline_data_uniform(fingerprint); %均匀采样
save('offline_data_uniform', 'offline_rss', 'offline_location');
[offline_rss, offline_location] = get_offline_data_random(fingerprint); %随机采样
save('offline_data_random', 'offline_rss', 'offline_location');

%% 获取在线定位阶段的数据5
%前面默认的数据集的密度是0.01m，这样的话整个仿真系统的位置最小分辨率为0.01m，trace总是0.01的整数倍
roomLength = 20;
roomWidth = 15;
t = 10000;
[ trace, rss ] = get_online_data( fingerprint, 0.01, roomLength, roomWidth, t ); %得到轨迹与对应的RSS
save('online_data', 'trace', 'rss');
%%
clear fingerprint;