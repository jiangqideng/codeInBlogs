addpath('./filters');
addpath('./IP_raytracing');
%% 模拟一条运动轨迹，然后加上高斯观察噪声，作为观测位置轨迹。然后使用卡尔曼滤波得到滤波后的结果。
% 速度为均值0.6m标准差0.05的高斯分布
% 观测噪声标准差为2

%% 画出实际的真实路径
roomLength = 1000;
roomWidth = 1000;
t = 500;
trace_real = get_random_trace(roomLength, roomWidth, t);
figure; 
subplot(1, 3, 1); plot(trace_real(:, 1), trace_real(:, 2), '.');
title('实际的真实路径');

%% 有观测噪声时的路径
noise = 2; %2m的位置波动噪声
trace = trace_real + normrnd(0, noise, size(trace_real));
subplot(1, 3, 2); plot(trace(:, 1), trace(:, 2), '.');
title('有噪声时的路径');
fprintf('卡尔曼滤波之前的定位精度： %f m\n', accuracy(trace, trace_real));

%% 对有噪声的路径进行卡尔曼滤波
kf_params_record = zeros(size(trace, 1), 4);
for i = 1 : t
    if i == 1
        kf_params = kf_init(trace(i, 1), trace(i, 2), 0, 0); % 初始化
    else
        kf_params.z = trace(i, 1:2)'; %设置当前时刻的观测位置
        kf_params = kf_update(kf_params); % 卡尔曼滤波
    end
    kf_params_record(i, :) = kf_params.x';
end
kf_trace = kf_params_record(:, 1:2);
subplot(1, 3, 3); plot(kf_trace(:, 1), kf_trace(:, 2), '.');
title('卡尔曼滤波后的效果');
fprintf('卡尔曼滤波之后的定位精度： %f m\n', accuracy(kf_trace, trace_real));
