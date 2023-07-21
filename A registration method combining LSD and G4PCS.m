%%本文方法
%%%室内和室外点云配准
str1='E:\compile document\matlab\data\Indoor and outdoor dataset\City1.ply';
str2='E:\compile document\matlab\data\Indoor and outdoor dataset\City2.ply';
pcloud1=pcread(str1);
pcloud2=pcread(str2);
%      pr=0.022431135;          %apartment4  apartment6
%      pr=0.025664071;          %boardroom0  boardroom3
%      pr=0.03380269;             %lobby0   lobby2
pr=0.12308180;          %City1  City2
PC1=pcloud1.Location;
PC2=pcloud2.Location;
%      plot3(PC1(:,1),PC1(:,2),PC1(:,3),'.b','MarkerSize',1);
%      hold on;
%      plot3(PC2(:,1),PC2(:,2),PC2(:,3),'.r','MarkerSize',1);
%      set(gca,'DataAspectRatio',[1 1 1]);
%      axis off
PCcloud1 = pcdownsample(pcloud1,'gridAverage',7*pr);
PC11=PCcloud1.Location;
[n m]=size(PC11);
[keypoint1] = ThreeDHarris_keypoint(PC1,5*pr);
[n1 m1]=size(keypoint1);
%      plot3(PC1(:,1),PC1(:,2),PC1(:,3),'.b','MarkerSize',1);
%      hold on;
%      plot3(keypoint1(:,1),keypoint1(:,2),keypoint1(:,3),'.r','MarkerSize',10);
%      set(gca,'DataAspectRatio',[1 1 1]);
%      axis off
RR=15*pr;
[idx1,dist1]=rangesearch(PC1,keypoint1,RR);
MV1=[];
MDV1=[];
for i=1:n1
    KNN=PC1(idx1{i},:);
    d=dist1{i};
    [V] = LRF_TOLDI(KNN,RR,d,keypoint1(i,:));
    MV1=[MV1;V];
    [DV] = LoVS(KNN,keypoint1(i,:),V,RR);
    MDV1=[MDV1;DV];
end
[keypoint2] = ThreeDHarris_keypoint(PC2,5*pr);
[n2 m2]=size(keypoint2);
[idx2,dist2]=rangesearch(PC2,keypoint2,RR);
MV2=[];
MDV2=[];
for i=1:n2
    KNN=PC2(idx2{i},:);
    d=dist2{i};
    [V] = LRF_TOLDI(KNN,RR,d,keypoint2(i,:));
    MV2=[MV2;V];
    [DV] = LoVS(KNN,keypoint2(i,:),V,RR);
    MDV2=[MDV2;DV];
end
[idxx distt]=knnsearch(MDV1,MDV2,'Dist','hamming','k',2);
Mmatch=[];
for i=1:n2
    if distt(i,1)/distt(i,2)<=0.9
        match=[idxx(i,1) i];
        Mmatch=[Mmatch;match];
    end
end
[n3 m3]=size(Mmatch);
ninlier0=0;
for i=1:6000000               %apartment 3000000 iterations    boardroom 30000 iterations    lobby  30000 iterations    City  6000000 iterations
    Sidx=randperm(n3,4);
    FCCS=Mmatch(Sidx,:);
    p1=keypoint1(FCCS(1,1),:);
    p2=keypoint1(FCCS(2,1),:);
    p3=keypoint1(FCCS(3,1),:);
    p4=keypoint1(FCCS(4,1),:);
    q1=keypoint2(FCCS(1,2),:);
    q2=keypoint2(FCCS(2,2),:);
    q3=keypoint2(FCCS(3,2),:);
    q4=keypoint2(FCCS(4,2),:);
    d11=norm(p1-p2);
    d12=norm(p1-p3);
    d13=norm(p1-p4);
    d14=norm(p2-p3);
    d15=norm(p2-p4);
    d16=norm(p3-p4);
    d21=norm(q1-q2);
    d22=norm(q1-q3);
    d23=norm(q1-q4);
    d24=norm(q2-q3);
    d25=norm(q2-q4);
    d26=norm(q3-q4);
    efsi=3*pr;        %%parameter can be adjusted
    if abs(d11-d21)<efsi && abs(d12-d22)<efsi && abs(d13-d23)<efsi && abs(d14-d24)<efsi && abs(d15-d25)<efsi && abs(d16-d26)<efsi
        a1=p2-p1;
        b1=p4-p3;
        sc1=(cross(p3-p1,b1)*cross(a1,b1)')/(norm(cross(a1,b1))*norm(cross(a1,b1)));
        tc1=(cross(p3-p1,a1)*cross(a1,b1)')/(norm(cross(a1,b1))*norm(cross(a1,b1)));
        m1=p1+sc1*(p2-p1);
        n1=p3+tc1*(p4-p3);
        a2=q2-q1;
        b2=q4-q3;
        sc2=(cross(q3-q1,b2)*cross(a2,b2)')/(norm(cross(a2,b2))*norm(cross(a2,b2)));
        tc2=(cross(q3-q1,a2)*cross(a2,b2)')/(norm(cross(a2,b2))*norm(cross(a2,b2)));
        m2=q1+sc2*(q2-q1);
        n2=q3+tc2*(q4-q3);
        lam1=norm(p1-m1)/norm(p1-p2);
        lam2=norm(p3-n1)/norm(p3-p4);
        lam3=norm(q1-m2)/norm(q1-q2);
        lam4=norm(q3-n2)/norm(q3-q4);
        dd1=norm(m1-n1);
        dd2=norm(m2-n2);
        if abs(lam1-lam3)<efsi && abs(lam2-lam4)<efsi && abs(dd1-dd2)<efsi
            V11=MV1(3*FCCS(1,1)-2:3*FCCS(1,1),:);
            V12=MV1(3*FCCS(2,1)-2:3*FCCS(2,1),:);
            V13=MV1(3*FCCS(3,1)-2:3*FCCS(3,1),:);
            V14=MV1(3*FCCS(4,1)-2:3*FCCS(4,1),:);
            V21=MV2(3*FCCS(1,2)-2:3*FCCS(1,2),:);
            V22=MV2(3*FCCS(2,2)-2:3*FCCS(2,2),:);
            V23=MV2(3*FCCS(3,2)-2:3*FCCS(3,2),:);
            V24=MV2(3*FCCS(4,2)-2:3*FCCS(4,2),:);
            datatheta1=real(acos((trace(V11*inv(V21))-1)/2)*(180/pi));
            datatheta2=real(acos((trace(V12*inv(V22))-1)/2)*(180/pi));
            datatheta3=real(acos((trace(V13*inv(V23))-1)/2)*(180/pi));
            datatheta4=real(acos((trace(V14*inv(V24))-1)/2)*(180/pi));
            ita=10;                 %%parameter cam be adjusted
            if abs(datatheta1-datatheta2)<ita && abs(datatheta2-datatheta3)<ita && abs(datatheta3-datatheta4)<ita
                A=[p1;p2;p3;p4];
                Y=[q1;q2;q3;q4];
                [R1,t1] = SVDtransformation(A,Y);
                PC11t=PC11*R1'+ones(n,1)*t1;
                [idx3 dist3]=rangesearch(PC2,PC11t,3*pr);
                ninlier=0;
                for l=1:n
                    if ~isempty(idx3{l})
                        ninlier=ninlier+1;
                    end
                end
                if ninlier>ninlier0
                    R=R1;
                    t=t1;
                    ninlier0=ninlier;
                end
            end
        end
    end
end
[n4 m4]=size(PC1);
PC1t=PC1*R'+ones(n4,1)*t;
T=[R t';zeros(1,3) 1];

 

