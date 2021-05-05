function test7
% 第二问遍历结果
clear,clc,close all
load('A_pre_2.mat');
A(:) = A(:)*100;
%% 2004年适宜温度分布图
Q = A(:,:,17); % 获取2004年温度
temp1 = [9.7 12.2];% 鲱鱼
temp2 = [3.7 6.2];% 鲭鱼
% posS = [28 44];% 苏格兰位置
posS = [29 45];% 苏格兰位置
mapD = 102.6923;% 地图上一个格子的长度
% 管控区域
r = 889/mapD;
realX = posS(2)-r;
realY = posS(1)-r;
[idxx1,idxy1] = find(Q>=temp1(1)*100 & Q<=temp1(2)*100);
[idxx2,idxy2] = find(Q>=temp2(1)*100 & Q<=temp2(2)*100);
D1 = [idxx1,idxy1];
D2 = [idxx2,idxy2];
temp = [];
for i = 1 : length(D1)
    if norm(D1(i,:)-posS)>r
        temp = [temp i];
    end
end
D1(temp,:) = [];
D1 = D1';
%% 进行区域内选择2
temp = [];
for i = 1 : length(D2)
    if norm(D2(i,:)-posS)>r
        temp = [temp i];
    end
end
D2(temp,:) = [];
D2 = D2';
% D1 = D1(find(sqrt(D1-tempS1)<=r))';
% D2 = D2(find(sqrt(D2-tempS2)<=r))';
% c = getMap(Q,D1,D2);
% hold on
% imshow(c,'InitialMagnification','fit')
% % 加网格
% x = 0.5 : 222-133+2-0.5;
% y = 0.5 : 69-5+2-0.5;
% [M,N] = meshgrid(x,y);
% hold on
% plot(x,N,'k');
% plot(M,y,'k');
% % 绘制管控范围
% hold on
% rectangle('Position',[realX,realY,2*r,2*r],'Curvature',[1,1],'linewidth',2,'EdgeColor','g'),axis equal
N = 1e4;
Answer = [];
r = 1200/mapD;
for n = 1 : N
    % 随机选取初始位置
    m1 = unidrnd(length(D1));
    m2 = unidrnd(length(D2));
    tempS1 = D1(:,m1);
    tempS2 = D2(:,m2);
    fishX1 = tempS1(1);
    fishY1 = tempS1(2);
    fishX2 = tempS2(1);
    fishY2 = tempS2(2);
    for i = 18 : 67
        % 选择年份对应温度地图
        E = A(:,:,i);
        % 陆地
        M = min(E);
        %% 元胞迭代过程
        % 鲱鱼
        F1 = E((fishX1-1:fishX1+1),(fishY1-1:fishY1+1));% 选择该时刻鱼附近的3*3位置
        [tempX,tempY] = getBestChoice(F1,temp1(1),temp1(2));
        fishX1 = fishX1 + tempX - 2;
        fishY1 = fishY1 + tempY - 2;
        tempS1(:,i+1) = [fishX1 fishY1];
        % 鲭鱼
        F2 = E((fishX2-1:fishX2+1),(fishY2-1:fishY2+1));% 选择该时刻鱼附近的3*3位置
        [tempX,tempY] = getBestChoice(F2,temp2(1),temp2(2));
        fishX2 = fishX2 + tempX - 2;
        fishY2 = fishY2 + tempY - 2;
        tempS2(:,i+1) = [fishX2 fishY2];
        s1 = [fishX1 fishY1];
        s2 = [fishX2 fishY2];
        if norm(s1-posS) > r || norm(s2-posS) > r
           Answer = [Answer;i+2003]; 
           break;
        elseif i == 67
            Answer = [Answer;i+2003]; 
            break;
        end
        
        
%         c = getMap(E,tempS1,tempS2);
%         hold on
%         imshow(c,'InitialMagnification','fit')
%         rectangle('Position',[realX,realY,2*r,2*r],'Curvature',[1,1],'linewidth',2,'EdgeColor','g'),axis equal
%         % 加网格
%         x = 0.5 : 222-133+2-0.5;
%         y = 0.5 : 69-5+2-0.5;
%         [M,N] = meshgrid(x,y);
%         hold on
%         plot(x,N,'k');
%         plot(M,y,'k');
%         title(i+2003)
        
    end
end
% figure(1)
% plot(1:N,Answer)
% figure(2)
A = zeros(1,50);
for i = 1 : length(Answer)
    A(Answer(i)-2020) = A(Answer(i)-2020)+1;
end
A(end) = 0;
A = A(:)/N;
plot(2021:2070,A)
xlabel('Year')
ylabel('Frequency')
function C = getMap(E,D1,D2)
%% 构造RGB
% 构造规则：陆地为G，高温为R，低温为B
[a,b] = size(E);
Ea = zeros(a,b);
Eb = zeros(a,b);
R = zeros(a,b);
G = zeros(a,b);
B = ones(a,b);
C = zeros(a,b,3);
for i = 1 : a
    for j = 1 : b
        if E(i,j) > 0
            Ea(i,j) = E(i,j);
        else
            Eb(i,j) = E(i,j);
        end
    end
end
R = Ea./max(Ea); % 归一化
for i = 1 : a
    for j = 1 : b
        if E(i,j) == -32768
            G(i,j) = 255;
            R(i,j) = 255;
            B(i,j) = 255;
        end
    end
end
for i = 1 : length(D1)
   d = D1(:,i);
   if d(1)~=0 & d(2)~=0
       R(d(1),d(2)) = 1; % 红色
       G(d(1),d(2)) = 192/255; % 绿色
       B(d(1),d(2)) = 203/255; % 蓝色
   end
end

for i = 1 : length(D2)
   d = D2(:,i);
   if d(1)~=0 & d(2)~=0
       R(d(1),d(2)) = 100; % 红色
       G(d(1),d(2)) = 12/255; % 绿色
       B(d(1),d(2)) = 103/255; % 蓝色
   end
end

B = B./3;
C(:,:,1) = R;
C(:,:,2) = G;
C(:,:,3) = B;

function [bestX,bestY] = getBestChoice(P,a,b)
%% 选取元胞最佳位置
% P : 元胞附近3*3矩阵
% a : 最佳温度下限
% b : 最佳温度上限
% M : 最佳位置
a = a*100;
b = b*100;
N = length(find(P >= a & P <= b));
if N > 0
   % 有最佳选择
   [r,c] = find(P >= a & P <= b);
   m = unidrnd(N);
   bestX = r(m);
   bestY = c(m);
else
    % 无最佳选择
    A = zeros(3,3);
    for i = 1 : 3
        for j = 1 : 3
            if P(i,j) < a
               A(i,j) = abs(P(i,j)-a);
            elseif P(i,j) > b
                A(i,j) = abs(P(i,j)-b);
            end
        end
    end
    N = length(find(A==min(A(:))));
    if N == 1
        [bestX,bestY] = find(A==min(A(:)));
    else
        m = unidrnd(N);
        [bestX,bestY] = find(A==min(A(:)));
        bestX = bestX(m);
        bestY = bestY(m);
    end
end