function [result]=update_validate(beta,validateS,IW,Bias,ActivationFunction)
%%%%%%%%%%%%%
switch lower(ActivationFunction)
    case{'rbf'}
        HValidate= RBFun(validateS, IW, Bias);
    case{'sig'}
        HValidate = SigActFun(validateS, IW, Bias);
    case{'sin'}
        HValidate = SinActFun(validateS, IW, Bias);
    case{'hardlim'}
        HValidate = HardlimActFun(validateS, IW, Bias);
end  
Tv=HValidate * beta;
result = 1./(1+exp(-Tv));
end                           