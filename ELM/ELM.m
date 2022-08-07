function [M,beta,HUnlabel,HTest,TU_T,TV_T,TestingAccuracy]=ELM(trainS,trainL,unlabelS,unlabelL,testS,testL,ActivationFunction,IW,Bias)
%%%%%%%%%%%%%
%TU_T:the actual label matrix of unlabeled dataset
%TV_T:the actual label matrix of test dataset
%%%%%%%%%%%%%%%
nTrainingData=size(trainS,1);
nUnlabeledData=size(unlabelS,1);
nTestingData=size(testS,1);
sorted_target=sort(trainL,1);
label=sorted_target(1,1);
j=1;
for i = 2:nTrainingData
    if sorted_target(i,1) ~= label(j,1)
            j=j+1;
            label(j,1) = sorted_target(i,1);
    end
end
nClass=j;%record the number of class

%%%%%%%%%% Processing the targets of training & testing
temp_T=zeros(nTrainingData,nClass);
for i = 1:nTrainingData
     for j = 1:nClass
         if label(j,1) == trainL(i,1)
              break; 
         end
     end
     temp_T(i,j)=1;
end
T=temp_T*2-1;

temp_TU_T=zeros(nUnlabeledData,nClass);
for i = 1:nUnlabeledData
        for j = 1:nClass
            if label(j,1) == unlabelL(i,1)
                break
            end
        end
        temp_TU_T(i,j)=1;
 end
 TU_T=temp_TU_T*2-1;


temp_TV_T=zeros(nTestingData,nClass);
for i = 1:nTestingData
        for j = 1:nClass
            if label(j,1) == testL(i,1)
                break; 
            end
        end
        temp_TV_T(i,j)=1;
end
TV_T=temp_TV_T*2-1;   %the class matrix for the test set

clear temp_T;
clear temp_TU_T;
clear temp_TV_T;
clear sorted_target;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(ActivationFunction)
    case{'rbf'}
        H0 = RBFun(trainS,IW,Bias);
    case{'sig'}
        H0 = SigActFun(trainS,IW,Bias);
    case{'sin'}
        H0 = SinActFun(trainS,IW,Bias);
    case{'hardlim'}
        H0 = HardlimActFun(trainS,IW,Bias);
        H0 = double(H0);
end


m1 = size(H0,2);% return the number of hidden layer nodes
m2 = size(H0,1);
% M = inv(H0' * H0 + eye(m1)/penalty_C);
% beta = H0' * inv(eye(m2)/penalty_C + H0 * H0') * T;
M = pinv(H0' * H0);
beta = pinv(H0) * T;


switch lower(ActivationFunction)
    case{'rbf'}
        HUnlabel = RBFun(unlabelS, IW, Bias);
    case{'sig'}
        HUnlabel = SigActFun(unlabelS, IW, Bias);
    case{'sin'}
        HUnlabel = SinActFun(unlabelS, IW, Bias);
    case{'hardlim'}
        HUnlabel = HardlimActFun(unlabelS, IW, Bias);
end

%%%%%%%%%%% Performance Evaluation
switch lower(ActivationFunction)
    case{'rbf'}
        HTest = RBFun(testS, IW, Bias);
    case{'sig'}
        HTest = SigActFun(testS, IW, Bias);
    case{'sin'}
        HTest = SinActFun(testS, IW, Bias);
    case{'hardlim'}
        HTest = HardlimActFun(testS, IW, Bias);
end    
TY=HTest * beta;
numAcc=0;
for i = 1 : nTestingData
        [x, label_index_expected]=max(TV_T(i,:));
        [x, label_index_actual]=max(TY(i,:));
        if label_index_actual==label_index_expected
            numAcc=numAcc+1;
        end
end
TestingAccuracy=numAcc/nTestingData;  
end                           