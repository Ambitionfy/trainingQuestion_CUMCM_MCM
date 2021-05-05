function test3
clear
clc
d = 0.01;
% Wmax = 7003;
Wmax = [7.0031    8.3487    7.0868]*1e3;
alpha = 1-25*0.004;
r = 2;
w = [10];

%% 1
www = [];
for m = 2 : 0.01 : 10
    l = m/3;
    CR = 0.1;
    U = 25;
    d = 0.001;% 步长
    f = 0.25;% 拍动频率
    rol = [1.171 1.396 1.185];
    % 空气密度 暖温带--北极--干旱地区
    CT = 0.1;
%     l = 10;% 单翼长度
    x = 0 : d : l;
    ww = l*3;% 峰值
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
    z = z + temp1 * f * rol * 1/f * CR * U^2;
    Wmax = z(1);
    www = [www Wmax];
end
l = 2 : 0.01 : 10;
hold on
plot(l,www,'b',l,0.3*l.^4,'r','linewidth',1)
xlabel('The length of the Dragon/m')
ylabel('Weight/Kg')
legend('calculated w','k*l^4')
% plot(390*l.^4,'r')
%% 
figure
tt = 1163000;
w = [10];
for i = 0+d : d : 10
       delta =  d * r * w(end)*(1-w(end)/tt);
       w = [w w(end)+ delta];
end
i = 0 : d : 10;
k = 390;
L = (w/k).^0.25;

plot(i,L,'linewidth',1)
title('Schematic diagram of the length of the Dragon changing with time')
xlabel('Time/year')
ylabel('The length of the Dragon/m')
%% 
figure
tt = 1213000;
w = [10];
for i = 0+d : d : 10
       delta =  d * r * w(end)*(1-w(end)/tt);
       w = [w w(end)+ delta];
end
i = 0 : d : 10;
k = 390;
L = (w/k).^0.25;

plot(i,L,'linewidth',1)
title('Schematic diagram of the length of the Dragon changing with time')
xlabel('Time/year')
ylabel('The length of the Dragon/m')











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