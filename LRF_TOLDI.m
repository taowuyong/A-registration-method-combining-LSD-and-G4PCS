function [V] = LRF_TOLDI(KNN,RR,d,keypoint)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[h l]=size(KNN);
idc=find(d<(1/3)*RR);
KNNc=KNN(idc,:);
[h1 l1]=size(KNNc);
[U S V]=svd((KNNc-ones(h1,1)*mean(KNNc))'*(KNNc-ones(h1,1)*mean(KNNc)));
qp=ones(h,1)*keypoint-KNN;
qp=sum(qp);
if qp*V(:,3)>=0
    V3=V(:,3);
else
    V3=-V(:,3);
end
MPvector=[];
for j=1:h
    Pvector=(KNN(j,:)-keypoint)'-((KNN(j,:)-keypoint)*V3)*V3;
    MPvector=[MPvector Pvector];
end
clear w1 w2 w;
for j=1:h
    w1(j)=(RR-d(j))^2;
    w2(j)=((KNN(j,:)-keypoint)*V3)^2;
    w(j)=w1(j)*w2(j);
end
V1=zeros(3,1);
for j=1:h
    V1=V1+w(j)*MPvector(:,j);
end
V1=V1/norm(V1);
V2=cross(V1,V3);
V=[V1 V2 V3];
end