function [IW,Bias]=make_iw(nHiddenNeurons,nInputNeurons,ActivationFunction)
IW = rand(nHiddenNeurons,nInputNeurons)*2-1;
switch lower(ActivationFunction)
    case{'rbf'}
        Bias = rand(1,nHiddenNeurons);
    case{'sig'}
        Bias = rand(1,nHiddenNeurons)*2-1;
    case{'sin'}
        Bias = rand(1,nHiddenNeurons)*2-1;
    case{'hardlim'}
        Bias = rand(1,nHiddenNeurons)*2-1;
end
end