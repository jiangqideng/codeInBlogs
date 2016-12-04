function [predictions, model] = loc_knn_cls(data, labels, test_data, k)
    % knn分类器(label仅仅是名字，不作为数值型)
    labels = round(labels(:, 1)/100)*100 + round(labels(:, 2)/100); %把坐标xy转换成一个label
    model = ClassificationKNN.fit(data, labels, 'NumNeighbors', k);
    label_predict = predict(model, test_data);
    predictions = [floor(label_predict/100), label_predict - floor(label_predict/100) * 100]; %把预测出来的label转换为坐标xy
    predictions = predictions * 100;
end