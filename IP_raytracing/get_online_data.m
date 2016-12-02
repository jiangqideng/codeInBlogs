function [ trace, rss ] = get_online_data( fingerprint, gridSize, roomLength, roomWidth, t )
%得到仿真位置指纹法的数据
%输入：rss仿真环境数据集，这个数据集的gridSize，房间尺寸，生成数据的个数
%输出：位置点轨迹，以及轨迹上每个点上的rss
    trace = get_random_trace(roomLength, roomWidth, t);
    rss = zeros(size(trace, 1), size(fingerprint, 3));
    for i = 1 : size(trace, 1);
        x = round(trace(i, 1) / gridSize);
        y = round(trace(i, 2) / gridSize);
        if x < 1
            x = 1;
        elseif x > size(fingerprint, 1)
            x = size(fingerprint, 1);
        end
        if y < 1
            x = 1;
        elseif y > size(fingerprint, 2)
            y = size(fingerprint, 2);
        end
        rss(i, :) = fingerprint(x, y, :);
        trace(i, :) = [x, y];
    end
end

