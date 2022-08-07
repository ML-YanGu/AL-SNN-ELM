function index=ensure_maxdensity(oneclass_snn)
    [m,~]=size(oneclass_snn);
    k=ceil(sqrt(m));%kNN
    [sorted, ~] = sort(oneclass_snn,2,'ascend');%sort by row
    distance_mat=sorted(:,1:k+1);
    sum_distance=sum(distance_mat,2);
    [~,index]=min(sum_distance);
end