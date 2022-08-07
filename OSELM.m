function [M,beta,TestingAccuracy]=OSELM(M,beta,incrementS,incrementL,HTest,TE_T,ActivationFunction)
%%%%%%%%%%%%%%
%HTest:the output of the hidden layer
%TE_T£ºthe actual value of the test
%%%%%%%%%%%%%
H=incrementS;    
M = M - M * H' * (eye(1) + H * M * H')^(-1) * H * M; 
beta= beta + M* H' * (incrementL - H * beta);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
TY=HTest * beta;
numAcc=0;
[nline,ncolumn]=size(HTest);
for i = 1 : nline
        [x, label_index_expected]=max(TE_T(i,:));
        [x, label_index_actual]=max(TY(i,:));
        if label_index_actual==label_index_expected
            numAcc=numAcc+1;
        end
end
TestingAccuracy=numAcc/nline;
end