function prediction = loc_knn_reg(data, labels, test_data, k)
%基于knn的定位，回归（lable，坐标x和y看作是数值型的，可以进行数值计算取k个的平均）
    if nargin == 3
        k = 40;
    end
    %根据定位里最常用的方法做的knn，找最近的k个label取平均，有些细节可以做调整，这里并没有使用matlab带的knn分类器
    distance = sqrt(sum((data - repmat(test_data, size(data, 1), 1)).^2, 2));
    [~, idx] = sort(distance);
    prediction = mean(labels(idx(1:k), :));
end

