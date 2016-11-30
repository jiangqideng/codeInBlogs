function fingerprint = generate_radio_map(grid_size)
% 生成“RSS仿真环境数据集”
% 返回的fingerprint是一个三维数组，记录计算出的RSS值，第一维和第二维是房间的尺寸，第三维代表不同的AP。
    %% 环境配置
    if nargin == 0
        grid_size = 0.01;
    end
    room_x = 20;
    room_y = 15;
    room_z = 4;
    f = 2400; %信号频率
    % 各个AP的位置
    APs = [
        1, 1
        10, 1
        19, 1
        1, 14
        10, 14
        19, 14
    ];
    %% 计算fingerprint
    fingerprint = zeros(room_x / grid_size - 1, room_y / grid_size - 1, size(APs, 1));
    for i = 1 : size(APs, 1)
        source_x = APs(i, 1);
        source_y = APs(i, 2);
        source_z = 1; %默认信号源的高度为1m
        rss = get_rss_by_ray_tracing(room_x, room_y, room_z, source_x, source_y, source_z, grid_size, f); %调用射线跟踪计算RSS
        fingerprint(:, :, i) = rss;
%         figure;
%         mesh(fingerprint(:, :, i));
    end
    save('radio_map_20_15', 'fingerprint');
end

