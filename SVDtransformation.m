function [R,t] = SVDtransformation(A,Y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
uA=[mean(A(:,1)) mean(A(:,2)) mean(A(:,3))];
uY=[mean(Y(:,1)) mean(Y(:,2)) mean(Y(:,3))];
[n m]=size(A);
H=zeros(3);
for j=1:n
    H=H+(A(j,:)-uA)'*(Y(j,:)-uY);
end
[U S V]=svd(H);
D=diag([1 1 det(U*V')]);
R=V*D*U';
t=uY-uA*R';
end

