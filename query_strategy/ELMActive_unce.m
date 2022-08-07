function [testaccuracy,time,M1,beta1,labeledS,labeledL]=ELMActive_unce(labeled,unlabeled,test,ActivationFunction,T_number,IW,Bias)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input:
%labeled: initial training instances set which is represented as NLS*(NF+1)
%unlabeled: unlabeled instances set which is represented as NUS*(NF+1)
%test: individual testing set which is represented as NTS*(NF+1)
%nHiddenNeurons: the number of hidden nodes
% ActivationFunction    - Type of activation function:
%                           'rbf' for radial basis function, G(a,b,x) = exp(-b||x-a||^2)
%                           'sig' for sigmoidal function, G(a,b,x) = 1/(1+exp(-(ax+b)))
%                           'sin' for sine function, G(a,b,x) = sin(ax+b)
%                           'hardlim' for hardlim function, G(a,b,x) = hardlim(ax+b)
%T_number:The number of instances to be queried
%Output:
%testaccuracy which is one vector which is represented as (1,NUS+1)
%Date: 2021-10-21
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[NL1,NL2]=size(labeled);
[NU1,NU2]=size(unlabeled);
[NT1,NT2]=size(test);
NF=NL2-1;
labeledS=labeled(:,1:NF);
labeledL=labeled(:,end);
unlabeledS=unlabeled(:,1:NF);
unlabeledL=unlabeled(:,end);
testS=test(:,1:NF);
testL=test(:,end);
[M,beta,HUnlabel,HTest,TU_T,TV_T,TestingAccuracy]=ELM(labeledS,labeledL,unlabeledS,unlabeledL,testS,testL,ActivationFunction,IW,Bias);
M1=M;
beta1=beta;
testaccuracy(1,1)=TestingAccuracy;
time(1,1)=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:T_number
   [index,~]=ConfidenceEstimation(beta,HUnlabel);
   labeledS(NL1+i,:)=unlabeledS(index,:);
   labeledL(NL1+i,:)=unlabeledL(index,:);
   incrementS=HUnlabel(index,:);
   incrementL=TU_T(index,:);
   HUnlabel(index,:)=[];
   TU_T(index,:)=[];
   unlabeledS(index,:)=[];
   unlabeledL(index,:)=[];
   [M,beta,TestingAccuracy]=OSELM(M,beta,incrementS,incrementL,HTest,TV_T,ActivationFunction);
   testaccuracy(1,i+1)=TestingAccuracy;
   time(1,i+1)=cputime;
end
testA=testaccuracy(1,end);
iterNum=i;
end