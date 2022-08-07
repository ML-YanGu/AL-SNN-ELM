function [number_class,zero_index]=return_number_class_zero(DistMat,eps,minpts)
%return the number of noises and class
    clusterIndex = SNN_algro(DistMat,eps,minpts);
    current=unique(clusterIndex);
    current_number=0;
    for j=1:length(current)
        if current(j)==0
            current_number=-1;
            break;
        end
    end
    number_class=length(current)+current_number;
    zero_index=length(find(clusterIndex(:,1)==0));
end