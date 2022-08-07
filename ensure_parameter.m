function [eps,minpts]=ensure_parameter(DistMat)
[m,~]=size(DistMat);
%ensure eps
epsk=zeros(1,7);
number_class=zeros(1,7);
for i=1:7
    epsk(i)=i/10+0.2;
    [class,~]=return_number_class_zero(DistMat,epsk(i),4);
    number_class(i)=class;
end
[x_max]=find_max_change(number_class);%
eps=epsk(x_max);

%ensure minpts
minpts=ensure_minpts(DistMat,eps);

eps_orign=eps;
minpts_orign=minpts;
%check whether the eps and minpts correct to modify them
[number_class1,zero_index1]=return_number_class_zero(DistMat,eps,minpts);
%return the number of cluster and the number of noise points
zero_threshold=m*0.4;%if the noise instances exceed zero_threshold, the parameters need to be adjusted
eps_left=eps;
eps_right=eps;
if (number_class1<=2)||(number_class1>=15)||(zero_index1>=zero_threshold)
%if the number of the cluster is not in a range, the parameters also need
%to  be adjusted
    while 1
        eps_left=eps_left-0.1;
        if eps_left>=0.3
            minpts_left=ensure_minpts(DistMat,eps_left);
            [number_class_left,zero_index_left]=return_number_class_zero(DistMat,eps_left,minpts_left);
            if (number_class_left>1)&&(number_class_left<9)&&(zero_index_left<zero_threshold)
                eps=eps_left;
                minpts=minpts_left;
                break;
            end
        end
        eps_right=eps_right+0.1;
        if eps_right<=0.9
            minpts_right=ensure_minpts(DistMat,eps_right);
            [number_class_right,zero_index_right]=return_number_class_zero(DistMat,eps_right,minpts_right);
            if (number_class_right>1)&&(number_class_right<9)&&(zero_index_right<zero_threshold)
                eps=eps_right;
                minpts=minpts_right;
                break;
            end
         end
         if (eps_left<=0.2)&&(eps_right>=1)
             eps=eps_orign;
             minpts=minpts_orign;
             break;
         end
    end
end
end