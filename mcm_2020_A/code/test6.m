function test6
% 第一问模型2004年适宜范围鱼群分布遍历图形化展示
clear,clc
load('A_pre_2.mat');
A(:) = A(:)*100;
%% 2004年适宜温度分布图
Q = A(:,:,1); % 获取2004年温度
temp1 = [9.7 12.2];% 鲱鱼
temp2 = [3.7 6.2];% 鲭鱼
% posS = [28 44];% 苏格兰位置
posS = [29.5 44.5];% 苏格兰位置
mapD = 102.6923;% 地图上一个格子的长度
% 管控区域
r = 889/mapD;
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
% 加网格
Answer1 = [];
Answer2 = [];
N = 1000;
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
    for i = 1 : 67
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
        if i == 17
            Answer1 = [Answer1;tempS1(:,end)'];
            Answer2 = [Answer2;tempS2(:,end)'];
        end
    end
end
c = getMap(Q,Answer1',Answer2');
hold on
imshow(c,'InitialMagnification','fit')
x = 0.5 : 222-133+2-0.5;
y = 0.5 : 69-5+2-0.5;
[M,N] = meshgrid(x,y);
hold on
plot(x,N,'k');
plot(M,y,'k');
realX = posS(2)-r;
realY = posS(1)-r;
rectangle('Position',[realX,realY,2*r,2*r],'Curvature',[1,1],'linewidth',2,'EdgeColor','g'),axis equal
[xx1,yy1] = k_means(Answer1);
[xx2,yy2] = k_means(Answer2);
scatter(yy1,xx1,[100],'filled','b')
scatter(yy2,xx2,[100],'filled','b')
scatter(44.5,29.5,[100],'filled','g')

scatter(42,28.84,[100],'filled','g')
% scatter(43.5,28.5,[100],'filled','m')
% realX = 43.5-r;
% realY = 28.5-r;
% rectangle('Position',[realX,realY,2*r,2*r],'Curvature',[1,1],'linewidth',2,'EdgeColor','g'),axis equal
% scatter(42.5,31.5,[100],'filled','g')
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

function [dataX,dataY] = k_means(data)
% my_kmeans
% By Chris, zchrissirhcz@gmail.com
% 2016年9月30日 19:13:43

% 簇心数目k
K = 4;

% 准备数据，假设是2维的,80条数据，从data.txt中读取
%data = zeros(100, 2);
% load 'Answer1.mat'; % 直接存储到data变量中
% data = Answer1;
x = data(:,1);
y = data(:,2);

% 绘制数据，2维散点图
% x,y: 要绘制的数据点  20:散点大小相同，均为20  'blue':散点颜色为蓝色
% s = scatter(x, y, 20, 'blue');
% title('原始数据：蓝圈；初始簇心：红点');

% 初始化簇心
sample_num = size(data, 1);       % 样本数量
sample_dimension = size(data, 2); % 每个样本特征维度

% 暂且手动指定簇心初始位置
clusters = zeros(K, sample_dimension);
clusters(1,:) = [-3,1];
clusters(2,:) = [2,4];
clusters(3,:) = [-1,-0.5];
clusters(4,:) = [2,-3];

% hold on; % 在上次绘图（散点图）基础上，准备下次绘图
% 绘制初始簇心
% scatter(clusters(:,1), clusters(:,2), 'red', 'filled'); % 实心圆点，表示簇心初始位置

c = zeros(sample_num, 1); % 每个样本所属簇的编号

PRECISION = 0.0001;


iter = 100; % 假定最多迭代100次
for i=1:iter
    % 遍历所有样本数据，确定所属簇。公式1
    for j=1:sample_num
        %t = arrayfun(@(item) item
        %[min_val, idx] = min(t);
        gg = repmat(data(j,:), K, 1);
        gg = gg - clusters;   % norm:计算向量模长
        tt = arrayfun(@(n) norm(gg(n,:)), (1:K)');
        [~, minIdx] = min(tt);
        % data(j,:)的所属簇心，编号为minIdx
        c(j) = minIdx;
    end
    
    % 遍历所有样本数据，更新簇心。公式2
    convergence = 1;
    for j=1:K
        up = 0;
        down = 0;
        for k=1:sample_num
            up = up + (c(k)==j) * data(k,:);
            down = down + (c(k)==j);
        end
        new_cluster = up/down;
        delta = clusters(j,:) - new_cluster;
        if (norm(delta) > PRECISION)
            convergence = 0;
        end
        clusters(j,:) = new_cluster;
    end
%     figure;
%     f = scatter(x, y, 20, 'blue');
%     hold on;
%     scatter(clusters(:,1), clusters(:,2), 'filled'); % 实心圆点，表示簇心初始位置
%     title(['第', num2str(i), '次迭代']);
    
    if (convergence)
        
        dataX = clusters(i,1);
        dataY = clusters(i,2);
%         disp(['收敛于第', num2str(i), '次迭代']);
        break;
    end
end