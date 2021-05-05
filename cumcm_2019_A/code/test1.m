function test1
%多项式拟合P-rol
clear
clc
drou = 0.00001;
rou1(1) = 0.85;%(0-100)区间
rou2(1) = 0.85;%(100-600)区间
p1(1) = 100;%(0-100)区间
p2(2) = 100;%(100-600)区间
n = 1;
while(p1(end)>=0)
   n = n + 1;
   rou1(n) = rou1(n-1)-drou;
   i = floor(p1(n-1)/50);
   if i == 0
      E = 1538.4;
   elseif i == 1
       E = fun1(p1(n-1));
   else
       E = fun2(p1(n-1));
   end
   dp = E/((rou1(n-1)+rou1(n))/2)*drou;
   p1(n) = p1(n-1) - dp;
end
n=1;
while(p2(end)<=500)
   n = n + 1;
   rou2(n) = rou2(n-1)+drou;
   i = floor((p2(n-1)-100)/50)+3;
   if i == 3
      E = 3393.4;
   elseif i == 5
       E = fun3(p2(n-1));
   else
       E = fun4(p2(n-1));
   end
   dp = E/((rou2(n-1)+rou2(n))/2)*drou;
   p2(n) = p2(n-1) + dp;
end
for i = 1 : size(p1,2)
    Result(1,i) = p1(size(p1,2)+1-i);
    Result(2,i) = rou1(size(p1,2)+1-i);
end
p2(:,1) = [];
rou2(:,1) = [];
p2(:) = p2(:)+100;
Result = [Result [p2;rou2]];
if Result(1,1)<0
   Result(:,1) = []; 
end
if Result(1,end) > 200
   Result(:,end) = []; 
end
clear dp drou E i n p1 p2 rou1 rou2
plot(Result(2,:),Result(1,:),'b')
p = polyfit(Result(2,:),Result(1,:),6)
yfit = polyval(p,Result(2,:));
hold on
plot(Result(2,:),yfit,'r');
legend('原始数据','拟合数据')
xlabel('密度/mg/mm^3');
ylabel('压强/MPa')
val = sum(abs(yfit-Result(1,:)).^2)
end


 function [e]=fun1(p) %0-49.5 56. 
 e=0.00004*p^3+0.0106*p^2+4.872*p+1538.4; 
 end
 function [e]=fun2(p) %50-99.5 
 e=0.00006*p^3+0.0062*p^2+5.1165*p+1533.7;
 end
 function [e]=fun3(p) %100-149.5
 e=0.0000005*p^4-0.0001*p^3+0.0308*p^2+3.5249*p+1573.3;
 end
 function [e]=fun4(p) %150-200
 e=0.000001*p^4-0.0007*p^3+0.159*p^2-9.9328*p+2104.3;
 end

