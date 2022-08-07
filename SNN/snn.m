function counts = snn(X, k, method, parallel)
%snn - Returns the number of shared neighbours between samples in X
% Syntax:  counts = snn(X, k, method, use_parallel )
%
% Inputs:
%    X - NxD matrix of samples
%    method - Method used in the distance calculations (default='euclidean')
%    use_parallel - Will parallel similarity calculations be performed? (default=true)
%
% Outputs:
%    counts - Number of shared neighbours between samples in X
%
% Example:
%    snn(X,20)
%
n = size(X,1); %the number of the dataset
counts = zeros(n,n);

if ~exist('k', 'var')
    k = 10;
end

if ~exist('method', 'var')
method = 'euclidean';
end

if ~exist('parallel', 'var')
        parallel = true;
end

distances = squareform(pdist(X,method));
distances(isinf(distances)) = 0;
distances(isnan(distances)) = 0;
[sorted, indexes] = sort(distances,2,'ascend');

if parallel
    parfor i = 1:n
        for j = 1:n		
            C = intersect(indexes(i,2:k+1), indexes(j,2:k+1) );
            counts(i,j) = size(C,2);
        end
    end
else
        for i = 1:n
            for j = i:n
                C = intersect(indexes(i,2:k+1), indexes(j,2:k+1) );
                counts(i,j) = size(C,2); 
            end
        end

end

end
