function minpts=ensure_minpts(DistMat,eps)
    [m,~]=size(DistMat);
    min_pts=zeros(1,m);%averge the neighboring instances for each instance
    for i = 1 : m
        min_pts(1,i)=sum(DistMat(:, i) <= eps);   
    end
    minpts=ceil(sum(min_pts)/m);
end