function [min_conf,conf]=ConfidenceEstimation(beta_matrix,Unlabeled_set)
%%%%%%%%%%%%
%Unlabeled_set£ºthe output of the hidden layer
%%%%%%%%%%%%%%%%
T=Unlabeled_set*beta_matrix;
[S1,~]=size(T);
for i=1:S1
 [A,~]=sort(T(i,:));
 C(1,i)=A(1,end)-A(1,end-1); 
end
clear A;
clear B;
[A,B]=sort(C);
min_conf=B(1,1);
conf=A(1,1);
end