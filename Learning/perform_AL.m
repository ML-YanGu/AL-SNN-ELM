function [y_SNN,y_unce,y_kmeans,alc_SNN,alc_unce] =perform_AL(data,perlabel,perunlabel,nHiddenNeurons,ActivationFunction,k,primary_method,secondary_method,use_parallel)
[NumS,N]=size(data);  
NumL=ceil(perlabel*NumS);%perlabel:the per cent of the labeled dataset
NumU=ceil(perunlabel*NumS); %perunlabel:the per cen of unlabeled dataset
%Run 20 times and average the results for stable performance
for j=1:20
    A=rand(1,NumS);
    [~,C]=sort(A);
    for i=1:NumS
        dataset(i,:)=data(C(1,i),:);  
    end
    clear A;
    clear B;
    clear C;
    Label(1:NumL,:)=dataset(1:NumL,:);
    Unlabel(1:NumU,:)=dataset(NumL+1:NumL+NumU,:);
    Test(1:(NumS-NumL-NumU),:)=dataset(NumL+NumU+1:end,:);
    [IW,Bias]=make_iw(nHiddenNeurons,N-1,ActivationFunction);
    start_SNN=cputime;
    %The quert strategy of AL-SNN-ELM
    [testaccuracy_SNN,time_SNN,~,~,~,~]=active_SNN_distance(Label,Unlabel,Test,ActivationFunction,ceil(0.6*NumU),k,primary_method,secondary_method,use_parallel,IW,Bias);
    time_SNN(1,1)=start_SNN;
    running_time_SNN=time_SNN-start_SNN;
    %The query strategy of AL-ELM
    start_unce=cputime;
    [testaccuracy_unce,time_unce,~,~,~,~]=ELMActive_unce(Label,Unlabel,Test,ActivationFunction,ceil(0.6*NumU),IW,Bias);
    time_unce(1,1)=start_unce;
    running_time_unce=time_unce-start_unce;
    %The query strategy of AL-KMEANS-ELM
    [testaccuracy_kmeans,~,~,~,~,~,~,~]=ELMActive_kmeans_center(Label,Unlabel,Test,ActivationFunction,ceil(0.6*NumU),4,IW,Bias);
    %The query startegy of RS-ELM
%     start_random=cputime;
%     [testaccuracy_random,time_random,~,~]=RandomSampling(Label,Unlabel,Test,ActivationFunction,IW,Bias,ceil(0.6*NumU));
%     time_random(1,1)=start_random;
%     running_time_random=time_random-start_random;
    %Take points in order to plot the learning curve
    for i=1:31
        accuracy_SNN(j,i)=testaccuracy_SNN(1,floor(0.02*(i-1)*NumU)+1);
        time_run_SNN(j,i)=running_time_SNN(1,floor(0.02*(i-1)*NumU)+1);

        accuracy_unce(j,i)=testaccuracy_unce(1,floor(0.02*(i-1)*NumU)+1);
        time_run_unce(j,i)=running_time_unce(1,floor(0.02*(i-1)*NumU)+1);

        accuracy_kmeans(j,i)=testaccuracy_kmeans(1,floor(0.02*(i-1)*NumU)+1);
     
        accuracy_random(j,i)=testaccuracy_random(1,floor(0.02*(i-1)*NumU)+1);
        time_run_random(j,i)=running_time_random(1,floor(0.02*(i-1)*NumU)+1);
    end

end
x=0:30;
y_SNN=mean(accuracy_SNN,1);
y_unce=mean(accuracy_unce,1);
% y_kmeans=mean(accuracy_kmeans,1);
y_random=mean(accuracy_random,1);
alc_SNN=compute_alc(y_SNN);
alc_unce=compute_alc(y_unce);
% alc_random=compute_alc(y_random);
% 
y_time_SNN=mean(time_run_SNN,1);
y_time_unce=mean(time_run_unce,1);
% y_time_random=mean(time_run_random,1);


