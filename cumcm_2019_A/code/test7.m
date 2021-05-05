function test7
clear,clc
%第二问——画图
m = xlsread('1.xlsx');
x = m(:,1);
y = m(:,2);
plot(x,y,'b');
p = polyfit(x,y,6)
yfit = polyval(p,x);
hold on 
figure(1)
plot(x,yfit,'r');
xlabel('极角/rad');
ylabel('极径/mm');
legend('原始数据','拟合数据')
val = sum(abs(yfit-y).^2)
theta = 0:0.01:2*pi;
r = p(1)*theta.^6+p(2)*theta.^5+p(3)*theta.^4+p(4)*theta.^3+p(5)*theta.^2+p(6)*theta+p(7);
figure(2)
polar(theta,r)
n = xlsread('2.xlsx');
n(end,:) = [];
x1 = n(:,1);
y1 = n(:,2);
x2 = n(:,4);
y2 = n(:,5);
% xtemp = 0.45:0.01:2;
% ytemp = 2*ones(size(xtemp));
% x1 = [x1;xtemp'];
% y1 = [y1;ytemp'];
% xtemp = 2.46:0.01:100;
% ytemp = zeros(size(xtemp));
% x2 = [x2;xtemp'];
% y2 = [y2;ytemp'];
figure(3)
plot(x1,y1,'b');
xlabel('时间/ms');
ylabel('距离/mm');
p1 = polyfit(x1,y1,5)
yfit1 = polyval(p1,x1);
hold on 
plot(x1,yfit1,'r');
val1 = sum(abs(y1-yfit1).^2)
legend('原始数据','拟合数据')
title('第一段数据拟合')
figure(4)
plot(x2,y2)
xlabel('时间/ms');
ylabel('距离/mm');
p2 = polyfit(x2,y2,5)
yfit2 = polyval(p2,x2);
hold on 
plot(x2,yfit2,'r');
val2 = sum(abs(y2-yfit2).^2)
legend('原始数据','拟合数据')
title('第二段数据拟合')
figure(5)
y = 2*ones(size(1:154));
y = [y1' y y2'];
i = 1e-2*(1:244);
plot(i,y,'LineWidth',1)
title('针阀升程与时间关系');
xlabel('时间/ms');
ylabel('升程/mm');
figure(6)
s = [];%面积
for i = 1 : length(y)
    s(i) = fA(y(i));
end
i = 1 : 244;
plot((i/100),s,'LineWidth',1)
title('针阀升程与面积关系');
xlabel('时间/ms');
ylabel('面积/mm^2');
function y = fA(t) 
    if t <= 0.3 
        p = 1e2*[  -7.990867642426816   5.971928252693086  -1.060265726099315   0.102083238968809 -0.003637386453599   0.000024184456616 ];
        y =  p(1)*t.^5 + p(2)*t.^4+ p(3)*t.^3 + p(4)*t.^2 + p(5)*t.^1 + p(6);
    elseif t <= 2.11 
        y = 1.53938040025900; 
    elseif t<= 2.46 
          p = 1e5*[0.007994714617843  -0.091940724563929   0.422208758333050  -0.967598402398776 1.106430728853096  -0.504897309130628 ];
          y =  p(1)*t.^5 + p(2)*t.^4+ p(3)*t.^3 + p(4)*t.^2 + p(5)*t.^1 + p(6);
    else
        y = 0; 
    end