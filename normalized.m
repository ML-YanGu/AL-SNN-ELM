function O=normalized(data)
[A,B]=size(data);
for i=1:(B-1)
   C(1,i)=max(data(:,i));
   D(1,i)=min(data(:,i));
end
for i=1:A
   for j=1:(B-1)
     if(C(1,j)==D(1,j))
       O(i,j)=0+0.001*rand;
     else
       O(i,j)=(data(i,j)-D(1,j))/(C(1,j)-D(1,j))+0.001*rand;
     end
   end
end
O(:,B)=data(:,B);