function similarities = snns(X, k, primary_method, use_parallel )
%snns - Returns the shared nearest neighbour similarities between samples in X
% Syntax:  similarities = snns(X, k, primary_method, secondary_method, use_parallel )
%
% Inputs:
%    X - NxD matrix of samples
%    k - Neighbourhood size (default = 10)
%    primary_method - Method used in the primary distance calculations (default='euclidean')
%    use_parallel = Will parallel similarity calculations be performed? (default=true)
%
% Outputs:
%    similarities - Shared neighbour similarities between samples in X
%
% Example:
%    snns(X,20)
%
% Other m-files required: snn.m

if ~exist('k', 'var')
            k = 10;
end
if ~exist('primary_method', 'var')
        primary_method  = 'euclidean';
end
if ~exist('use_parallel', 'var')
        use_parallel = true;
end
%Calculate the number of shared nearest neighbours between each par of samples
counts = snn(X,k,primary_method, use_parallel);
similarities = counts / k;
end
