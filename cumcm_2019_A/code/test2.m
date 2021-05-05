function test2
%压力与弹性模量拟合
a = xlsread('3.xlsx');
format long
x = a(:,1);
y = a(:,2);
p = polyfit(x,y,5)
yfit = polyval(p,x);
val = sum(abs(yfit-y).^2)
plot(x,y,'b-','linewidth',1);
hold on 
plot(x,yfit,'r-','linewidth',1);
xlabel('压力/MPa');
ylabel('弹性惯量/MPa');
title('压力与弹性模量拟合数据');
legend('原始数据','拟合数据')