function test
%% 翅膀示意图
figure
x = 0 : 0.01 : 2.4633;
% y = -x.^2+17*x;
y = ff(x,2.4633,2.4633*3);
plot(x,y,'linewidth',1)
axis equal
title('Simplified sketch of the wings of dragon')
xlabel('Dragon wing length/m')
ylabel('Dragon wing chord length')
%% 计算
CR = 0.1;
U = 15;
d = 0.001;% 步长
f = 0.25;% 拍动频率
rol = [1.171 1.396 1.185];
% 空气密度 暖温带--北极--干旱地区
CT = 0.1;
l = 10;% 单翼长度
x = 0 : d : l;
ww = 30;% 峰值
y = ff(x,l,ww);% 翼弦长
z = 0;
idx = 1;
temp = 0;
temp1 = 0;
w = 2*pi*f;
for i = 0 : d : l
    temp = temp + i^2 * d * y(idx);
    temp1 = temp1 + d * y(idx);
    idx = idx + 1;
end
z = temp * w^2 * 1/f;
z = z * rol * CT * f;
z = z + temp1 * f * rol * 1/f * CR * U^2

function y = ff(x,q,w)
% a = -0.4;
% b = -20*a;
% q = 10;
a = -4*w/q^2;
b = -q*a;

idx1 = find(x <= q/2);
y = a*x(idx1).^2 + b * x(idx1);
idx2 = find(x > q/2);
y = [y a*(q-x(idx2)).^2 + b * (q - x(idx2))];


