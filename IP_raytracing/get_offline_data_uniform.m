function [data, labels] = get_offline_data_uniform(fingerprint, grid_size)
%模拟离线数据采集，均匀间隔采样
    if nargin == 1
        grid_size = 10;  %默认10 --> 1m
    end
    [size_x, size_y, size_ap] = size(fingerprint);
    fp = fingerprint(grid_size:grid_size:size_x, grid_size:grid_size:size_y, :);
    data = reshape(fp, [], size_ap);
    [x, y] = meshgrid(grid_size:grid_size:size_x, grid_size:grid_size:size_y);
    x = x';
    y = y';
    labels = [x(:), y(:)];
end