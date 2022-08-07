function [testaccuracy,time,M1,beta1,labeledS,labeledL]=active_SNN_distance(labeled,unlabeled,test,ActivationFunction,T,k,primary_method,secondary_method,use_parallel,IW,Bias)
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
%k:the number of neighboring instances
%T:The number of instances to be queried
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
HUnlabel = HUnlabel;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
T1 = ceil(T*0.2);   %The number of representative instances to be selected
T2 = T-T1;          %The number of uncertainty instances to be selected
%first add the representative dataset
T1_index=0;
while T1_index<T1
    DistMat=snnd(unlabeledS,k,primary_method,secondary_method,use_parallel);
    [eps,minpts]=ensure_parameter(DistMat);
    clusterIndex=SNN_algro(DistMat,eps,minpts);
    current=unique(clusterIndex);
    current_number=0;
    for i=1:length(current)
        if current(i)==0
            current_number=-1;
            break;
        end
    end
    number_class=length(current)+current_number;%the number of the cluster
    if isequal(number_class,0)
        T1_index=T1_index+1;
        if T1_index>T1
            break;
        end
        [index,conf]=ConfidenceEstimation(beta,HUnlabel);
        if length(index)>1
            index=index(1,1);
        end
        labeledS(NL1+T1_index,:)=unlabeledS(index,:);
        labeledL(NL1+T1_index,:)=unlabeledL(index,:);
        incrementS=HUnlabel(index,:);
        incrementL=TU_T(index,:);
        HUnlabel(index,:)=[];
        TU_T(index,:)=[];
        unlabeledS(index,:)=[];
        unlabeledL(index,:)=[];
        clusterIndex(index,:)=[];
        [M,beta,TestingAccuracy]=OSELM(M,beta,incrementS,incrementL,HTest,TV_T,ActivationFunction);
        testaccuracy(1,T1_index+1)=TestingAccuracy;
        time(1,T1_index+1)=cputime; 
    else
        for i=1:number_class
            %Each cluster center as a representative instance
            data_for_one_class=unlabeledS(clusterIndex(:,1)==i,:);
            center(i,:) = mean(data_for_one_class,1);
            if isempty(data_for_one_class)
                continue;
            end
            T1_index=T1_index+1;
            if T1_index>T1
                break;
            end
            HUnlabel_for_one=HUnlabel(clusterIndex(:,1)==i,:);
            distance=distEclude(data_for_one_class,center(i,:));
            [~,index]=sort(distance,1,'ascend');
            qIndex = ismember(unlabeledS,data_for_one_class(index,:), 'rows') == 1;
            unlabel_index=find(qIndex);
            [index_row,~]=size(unlabel_index);
            if index_row>1
                unlabel_index=unlabel_index(1,1);
            end
            labeledS(NL1+T1_index,:)=unlabeledS(unlabel_index,:);
            labeledL(NL1+T1_index,:)=unlabeledL(unlabel_index,:);
            incrementS=HUnlabel(unlabel_index,:);
            incrementL=TU_T(unlabel_index,:);
            HUnlabel(unlabel_index,:)=[];
            TU_T(unlabel_index,:)=[];
            unlabeledS(unlabel_index,:)=[];
            unlabeledL(unlabel_index,:)=[];
            clusterIndex(unlabel_index,:)=[];
            [M,beta,TestingAccuracy]=OSELM(M,beta,incrementS,incrementL,HTest,TV_T,ActivationFunction);
            testaccuracy(1,1+T1_index)=TestingAccuracy;
            time(1,T1_index+1)=cputime;
        end
    end
end
%add uncertainy unlabel dataset later
for i=1:T2
   [index,~]=ConfidenceEstimation(beta,HUnlabel);
   labeledS(NL1+i+T1,:)=unlabeledS(index,:); 
   labeledL(NL1+i+T1,:)=unlabeledL(index,:); 
   incrementS=HUnlabel(index,:);   
   incrementL=TU_T(index,:);        
   HUnlabel(index,:)=[];
   TU_T(index,:)=[];
   unlabeledS(index,:)=[];
   unlabeledL(index,:)=[]; 
   [M,beta,TestingAccuracy]=OSELM(M,beta,incrementS,incrementL,HTest,TV_T,ActivationFunction);
   testaccuracy(1,i+1+T1)=TestingAccuracy;
   time(1,i+T1+1)=cputime;
end
clear clusterIndex;
clear data_for_one_class;
clear HUnlabel_for_one;
clear index;
clear qIndex;
clear unlabel_index;
clear index_row;
testA=testaccuracy(1,end);
iterNum=i;
end