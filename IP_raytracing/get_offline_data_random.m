function [data, labels] = get_offline_data_random(fingerprint, data_num)
%模拟离线数据采集，随机采样
    if nargin == 1
        data_num = 30000;  %默认30000个数据
    end
    [size_x, size_y, size_ap] = size(fingerprint);
    data = reshape(fingerprint, [], size_ap);
    [x, y] = meshgrid(1:size_x, 1:size_y);
    x = x';
    y = y';
    labels = [x(:), y(:)];
    
    %从所有数据中随机选择一部分
    idx = randperm(size(data, 1), data_num);
    data = data(idx, :);
    labels = labels(idx, :);
end