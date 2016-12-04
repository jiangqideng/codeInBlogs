function predictions = online_loc(offline_rss, offline_location, online_rss, type)
%模拟在线定位
%offline_location和offline_rss是离线指纹库，每行为一组指纹
%online_rss为在线RSS，每行为一个RSS向量

    predictions = zeros(size(online_rss, 1), size(offline_location, 2));
    disp(type);
    if type == 'knn_reg'  %常用的knn定位
        tic;
        lasttime = 0;
        for i = 1:size(online_rss, 1) %分别对每个RSS向量进行定位
            curtime = toc;
            if curtime - lasttime > 1
                fprintf('进度：%f%%\n', i / size(online_rss, 1) * 100);
                lasttime = curtime;
            end
            % knn回归
            prediction = loc_knn_reg(offline_rss, offline_location, online_rss(i, :));
            predictions(i, :) = prediction;
        end
    end

    % knn分类器(label仅仅是名字，作为网格的标号，不作为数值型)
    if type == 'knn_cls'
        k = 40;
        predictions = loc_knn_cls(offline_rss, offline_location, online_rss, k);
    end
end