 function alc=compute_alc(accuracy)
[~,n]=size(accuracy);
N=n-1;
for i=1:N
    alc_temp(i)=accuracy(1,i)+accuracy(1,i+1);
end
alc_temp=sum(alc_temp);
alc=alc_temp/(2*N);
end
