function draw1
ke=117.4035;    
ks=8.36;
p = [300 862 74.2 1.18];
c = [1377 2100 1726 1005];
lemda = [0.082 0.37 0.045 0.028];
T = 1;%时间刻度
Tmax = 90*60;
k = lemda./(p .* c);
m = [0.6 6 3.6 5];%层厚度
h = 1e-4*ones(1,4);%网格大小
M = [6 60 36 50];%每层个数
ms = zeros(1,4);%总分层数
ms(1,1) = M(1,1);
for i = 2 : 4
   ms(1,i) = ms(1,i-1) + M(1,i); 
end
u0 = 37;%初始温度
ue = 75;%终止温度
r = zeros(1,4);
for i = 1 : 4
   r(1,i) = T * k(1,i) /  h(1,i)^2;
end

c1 = [-lemda(1) lemda(1)+lemda(2) -lemda(2)]/h(1,1); %1-2边界条件
c2 = [-lemda(2) lemda(2)+lemda(3) -lemda(3)]/h(1,1); %2-3边界条件
c3 = [-lemda(3) lemda(3)+lemda(4) -lemda(4)]/h(1,1); %3-4边界条件

c01 = ke * h(1,1) / lemda(1); %0-1边界
d01 = h(1,1) * ke / lemda(1) * ue;
c40 = h(1,1) * ks / lemda(4); %4-0边界
d40 = h(1,1) * ks * u0 / lemda(4);

A = zeros(ms(1,4)+1,ms(1,4)+1);
f = zeros(ms(1,4)+1,1);
A(1,1) = c01 + 1;
A(1,2) = -1;
f(1) = d01;
%1层
for i = 2 : ms(1,1)
   A(i,i-1) = -r(1);
   A(i,i) = 1+2*r(1);
   A(i,i+1) = -r(1);
   f(i) = 37;
end
A(ms(1,1)+1 , ms(1,1):ms(1,1)+2) = c1;
f(ms(1,1)+1) = 0;
%2层
for i = ms(1,1)+2 : ms(1,2)
   A(i,i-1) = -r(2);
   A(i,i) = 1+2*r(2);
   A(i,i+1) = -r(2);
   f(i) = 37;
end
A(ms(1,2)+1 , ms(1,2):ms(1,2)+2) = c2;
f(ms(1,2)+1) = 0;
%3层
for i = ms(1,2)+2 : ms(1,3)
   A(i,i-1) = -r(3);
   A(i,i) = 1+2*r(3);
   A(i,i+1) = -r(3);
   f(i) = 37;
end
A(ms(1,3)+1 , ms(1,3):ms(1,3)+2) = c3;
f(ms(1,3)+1) = 0;
%4层
for i = ms(1,3)+2 : ms(1,4)
   A(i,i-1) = -r(4);
   A(i,i) = 1+2*r(4);
   A(i,i+1) = -r(4);
   f(i) = 37;
end
A(ms(1,4)+1,ms(1,4)) = c40 - 1;
A(ms(1,4)+1,ms(1,4)+1) = 1;

f(ms(1,4)+1) = d40; 
%追赶法
a = zeros(1,ms(1,4)+1); %下对角
b = zeros(1,ms(1,4)+1); %中对角
c = zeros(1,ms(1,4)+1); %上对角
a(1,1) = 0;
for i = 2 : ms(1,4) + 1
    a(1,i) = A(i,i-1);
end
for i = 1 : ms(1,4)
    c(1,i) = A(i,i+1);
end
c(end) = 0;
for i = 1 : ms(1,4) + 1
    b(1,i) = A(i,i); 
end
u = zeros(Tmax+1,ms(4)+1);
ytemp = chase(a,b,c,f);
u(1,:) = u0;
u(2,:) = ytemp;
for i = 2 : Tmax + 1 
    f = ytemp';
    f(1) = d01;
    f(ms(1,1)+1) = 0;
    f(ms(1,2)+1) = 0;
    f(ms(1,3)+1) = 0;
    f(ms(1,4)+1) = d40; 
    ytemp = chase(a,b,c,f);
    u(i,:) = ytemp;
end
q = u(:,end);

t = 0 : Tmax;
xxx = 0 : ms(1,4);
[xx,tt] = meshgrid(xxx,t);
figure(1)
mesh(xx,tt,u)
title('温度随时间、空间分布图')
xlabel('空间/0.1mm')
ylabel('时间/s')
zlabel('温度/摄氏度')

figure(2)
l1 = u(:,1);%左边界
l2 = u(:,ms(1,1)+1); %1-2边界
l3 = u(:,ms(1,2)+1); %1-2边界
l4 = u(:,ms(1,3)+1); %1-2边界
l5 = u(:,end); %右边界
plot(t,l1,'r-',t,l2,'g-',t,l3,'b-',t,l4,'m-',t,l5,'k-');
xlabel('时间/s')
ylabel('温度/摄氏度')
legend('左边界','1-2边界','2-3边界','3-4边界','右边界')


a = xlsread('2.xlsx');
a = a(:,2);
pp = 0;
for i = 1 : length(a)
   pp = pp + abs(q(i)-a(i))/a(i); 
end
pp/length(a)
figure(3)
plot(t,q,'b-',t,a,'r-')
title('实验所得数据与真实数据比较');
xlabel('时间/s')
ylabel('温度/摄氏度')
legend('实验所得数据','真实数据')




