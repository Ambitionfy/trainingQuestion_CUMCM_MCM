function test10
% 第四问
clear,clc,close all
load('A_pre_2.mat');
A(:) = A(:)*100;
Q = A(:,:,1); % 获取2004年温度
% 第三问模型二
Q1 = [34.61,40.15];
Q2 = [20.34,43.57];
a = 9;% 鲱鱼（下）
b = 5; % 鲭鱼（上）
posS1 = [28.84 42];
d1 = norm(Q1-posS1);
d2 = norm(Q2-posS1);
mapD = 102.6923;% 地图上一个格子的长度
r = 889/mapD;
A = [];
c = 0.4;
y = 31.5 : 0.01 : 34.5;
x = 39.5 : 0.01 : 42.5;
A = zeros(length(x),length(y));
m1 = 0;
m2 = 0;
for y = 31.5 : 0.01 : 34.5
    m2 = 0;
    m1 = m1 + 1;
    for x = 39.5 : 0.01 : 42.5
        m2 = m2 + 1;
        posS = [y x];
        d3 = norm(Q1-posS);
        d4 = norm(posS-posS1);
        if d3 > r || Q(fix(y),fix(x))~=-32768
            temp = 0;
        else
            temp = a/d1+b/d2+a/d3-c/d4;
        end
        A(m2,m1) = temp;

    end
end
y = 31.5 : 0.01 : 34.5;
x = 39.5 : 0.01 : 42.5;
[Y,X] = meshgrid(x,y);
figure(2)
mesh(Y,X,A)
% [a,b] = find(A==max(A(:)));
% y = 20.34 : 0.1 : 34.61;
% x = 36.5 : 0.1 : 53.5;
% x(a)
% y(b)

