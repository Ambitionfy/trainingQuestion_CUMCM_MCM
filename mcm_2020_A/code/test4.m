function test4
% 第一问模型2004年适宜范围鱼群分布
clear,clc,close all
load('A_pre.mat');
A(:) = A(:)*100;
control = [0,0];
% control(1) 0 : 画出管控范围， 1 : 不画
% control(2) 0 : 画出整范围适宜温度鱼群分布， 1 : 只画出管控范围内鱼群
%% 2004年适宜温度分布图
Q = A(:,:,1); % 获取2004年温度
temp1 = [9.7 12.2]*100;% 鲱鱼
temp2 = [3.7 6.2]*100;% 鲭鱼
% posS = [28 44];% 苏格兰位置
posS = [29.5 44.5];% 苏格兰位置
mapD = 102.6923;% 地图上一个格子的长度
% 管控区域
r = 889/mapD;
realX = posS(2)-r;
realY = posS(1)-r;
% [idxx1,idxy1] = find(Q>=temp1(1) & Q<=temp1(2));
% [idxx2,idxy2] = find(Q>=temp2(1) & Q<=temp2(2));
[idxx1,idxy1] = find(Q>=temp1(1) & Q<=temp1(2));
[idxx2,idxy2] = find(Q>=temp2(1) & Q<=temp2(2));
D1 = [idxx1,idxy1];

D2 = [idxx2,idxy2];
if control(2) == 1
%% 进行区域内选择1
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
elseif control(2) == 0
    D1 = D1';
    D2 = D2';
end
% D1 = D1(find(sqrt(D1-tempS1)<=r))';
% D2 = D2(find(sqrt(D2-tempS2)<=r))';
c = getMap(Q,D1,D2);
hold on
imshow(c,'InitialMagnification','fit')
% 加网格
x = 0.5 : 222-133+2-0.5;
y = 0.5 : 69-5+2-0.5;
[M,N] = meshgrid(x,y);
hold on
plot(x,N,'k');
plot(M,y,'k');
if control(1) == 0
    % 绘制管控范围
    hold on
    rectangle('Position',[realX,realY,2*r,2*r],'Curvature',[1,1],'linewidth',2,'EdgeColor','g'),axis equal
end
scatter(44.5,29.5,[70],'filled','g')


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
aaa = size(D1);
for i = 1 : aaa(2)
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