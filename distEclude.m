function distance = distEclude(dataSet,center)
%calculate the distance of two dataset
dataNum = size(dataSet,1);
centerNum = size(center,1);
distance = zeros(dataNum,centerNum);
for i = 1:centerNum
    difference = dataSet - repmat(center(i,:),dataNum,1);
    sum_of = sum(difference .* difference,2);
    distance(:,i) = sum_of;
end
end