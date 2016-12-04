function acc = accuracy( predictions, labels )
%计算定位误差
%labels是实际的位置轨迹，predictions是估计的位置轨迹
    acc = mean(sqrt(sum((predictions - labels).^2, 2)));
end