function test3
% 2004-2020元胞自动机演示
clear,clc
load('data.mat');
% 鱼的初始位置
% 鲱鱼
fishY1 = 40; % 实际X坐标
fishX1 = 30; % 实际Y坐标
D1 = zeros(2,18);% 鱼的位置矩阵
D1(:,1) = [fishX1 fishY1];% 鱼的初始位置
% 鲭鱼
fishY2 = 42; % 实际X坐标
fishX2 = 24; % 实际Y坐标
D2 = zeros(2,18);% 鱼的位置矩阵
D2(:,1) = [fishX2 fishY2];% 鱼的初始位置
for i = 1 : 17
    % 选择年份对应温度地图
    E = C(:,:,i);
    E = E(5:69,133:222);
    % 陆地
    M = min(E);
    %% 元胞迭代过程
    % 鲱鱼
    F1 = E((fishX1-1:fishX1+1),(fishY1-1:fishY1+1));% 选择该时刻鱼附近的3*3位置
    [tempX,tempY] = getBestChoice(F1,9.7,12.2);
    fishX1 = fishX1 + tempX - 2;
    fishY1 = fishY1 + tempY - 2;
    D1(:,i+1) = [fishX1 fishY1];
    % 鲭鱼
    F2 = E((fishX2-1:fishX2+1),(fishY2-1:fishY2+1));% 选择该时刻鱼附近的3*3位置
    [tempX,tempY] = getBestChoice(F2,1.6,2.7);
    fishX2 = fishX2 + tempX - 2;
    fishY2 = fishY2 + tempY - 2;
    D2(:,i+1) = [fishX2 fishY2];
    
    c = getMap(E,D1,D2);
    hold on
    imshow(c,'InitialMagnification','fit')
    % 加网格
    x = 0.5 : 222-133+2-0.5;
    y = 0.5 : 69-5+2-0.5;
    [M,N] = meshgrid(x,y);
    hold on
    plot(x,N,'k');
    plot(M,y,'k');
    title(i+2003)
    pause(0.01)
    f=getframe(gcf); 
    imind=frame2im(f);
    [imind,cm] = rgb2ind(imind,256);
    if i == 1
        imwrite(imind,cm,'infection1.gif','GIF', 'Loopcount',inf,'DelayTime',0.05);
    else
        imwrite(imind,cm,'infection1.gif','GIF','WriteMode','append','DelayTime',0.05);
    end
    
    
end

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