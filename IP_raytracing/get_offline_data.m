function fp = get_offline_data(fingerprint)
%模拟离线数据采集，这里用最简单的方法，直接均匀间隔采样
    fp = fingerprint(10:10:end, 10:10:end, :);
end

