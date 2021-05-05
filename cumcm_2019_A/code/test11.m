function test11
%第3问——计算
clear,clc 
global dt Tc;
Tc = 1; 
dt = 0.1; % 时间离散长度 
T1s = 50;
%% 计算参数 
[t1, error] = funRes(T1s); % t0：初始喷油延时
t1 = 50;
%% 重新计算最优参数 ，记录状态值 
countt = 1;
N = 1000*Tc/dt;density = 0.850; % 密度初值 
for n = 1:N % 离散计算 
    time = n * dt; % 计算实际时间 % 进油总质量 
    count0 = ceil(time/t1);%到一个周期，增加0.5
    if count0 == countt
        quatyG = (8.2576-2.413)*pi*2.5^2*0.804541084;%进油质量
        count0 = countt;
        countt = countt + 1;
        T1Rand = t1*(1-rand*0);
    end
    Tra(n) = T1Rand;
    %进油
    inQual = inFuel(time, density, quatyG, T1Rand); 
    inQ(n) = inQual; % 记录值 
    quatyG = quatyG - inQual;
    %出油
    outQual = outFuel(time, density); 
    outQ(n) = outQual;% 记录值
    %更新密度
    allM = density*pi*5^2*500; % 计算总质量 
    density = (allM - outQual + inQual)/(pi*5^2*500); % 计算平均密度
    Denp(n) = funP2(density); % 计算该时刻压力 
    redu = 0;
    if Denp(n) > 100
        dP = Denp(n) - 0.1;
        C = 0.85;
        A = pi*0.7^2;
        redu = dt*C*A*sqrt(2*dP/density)*density;
        allM = density*pi*5^2*500; % 计算总质量 
        density = (allM - redu)/(pi*5^2*500); % 计算平均密度
        Denp(n) = funP2(density); % 计算该时刻压力 
    end
    reduQ(n) = redu;
    Err1(n) = Denp(n) - 100; % 计算误差 
end
Err2 = sum(Err1)/N; % 该时间内输入油量的误差 
Err3 = sum(abs(Err1))/N;
figure 
plot((1:N)*dt,Denp,'-','Linewidth',1) 
legend('压强曲线') 
xlabel('时间 t(ms)') 
ylabel('压强 P(Mpa)') 
set(gcf,'units','centimeters') % 标准单位：厘米 
set(gcf,'InnerPosition',[0 5 16 8]) % 在屏幕的位置，图窗的长宽 % 绘制压强差 
figure 
plot((1:N)*dt,Err1,'-','Linewidth',1) 
legend('压强差') 
xlabel('时间 t(ms)') 
ylabel('压强差 P(Mpa)') 
set(gcf,'units','centimeters') % 标准单位：厘米 
set(gcf,'InnerPosition',[16 5 16 8]) % 在屏幕的位置，图窗的长宽 
% 绘制时间与流速和时间与阀流速关系图 
figure 
yyaxis left 
plot((1:N)*dt,reduQ/dt,'r-','Linewidth',0.6) % 
axis([1,Tc*1000,0,4]) 
xlabel('时间 t(ms)') 
ylabel('阀流速 v(mg/ms)') 
yyaxis right 
plot((1:N)*dt,Err1,'b-','Linewidth',1) % 
axis([0 1000 0 10])
legend('压力误差')
xlabel('时间 t(ms)') 
ylabel('压强差 P(Mpa)') 
legend('压强差','阀流速') 
set(gcf,'units','centimeters') % 标准单位：厘米 
set(gcf,'InnerPosition',[0 8 16 8]) % 在屏幕的位置，图窗的长宽 
fprintf('波动误差为：%.3f Mpa\n',Err3) 
fprintf('喷油角速度为%.3frad/ms\n',2*pi/t1) 
fprintf('喷油周期为%.3fms\n',t1)
end
%% 计算进油工作周期
    function [T1, error] = funRes(T1s) 
    global dt Tc
    N = 1000*Tc/dt;%一个周期的离散时间点的个数
    s = 0; 
    for Tt1 = T1s % 搜索法，进油工作周期 
        countt = 1;
        density = 0.850; % 密度初值 
        for n = 1:N % 离散计算 
            time = n * dt; % 计算实际时间 % 进油 
            count0 = ceil(time/Tt1);%到一个周期，增加0.5
            if count0 == countt
                quatyG = (8.2576-2.413)*pi*2.5^2*0.804541084;%进油质量
                count0 = countt;
                countt = countt + 1;
            end
            %进油
            inQual = inFuel(time, density, quatyG, Tt1); 
            quatyG = quatyG - inQual;
            %出油
            outQual = outFuel(time, density); 
            %更新密度
            allM = density*pi*5^2*500; % 计算总质量 
            density = (allM - outQual*2 + inQual)/(pi*5^2*500); % 计算平均密度
            thisDen = funP2(density);
             if thisDen > 100
                dP = thisDen - 0.1;
                C = 0.85;
                A = pi*0.7^2;
                redu = dt*C*A*sqrt(2*dP/density)*density;
                allM = density*pi*5^2*500; % 计算总质量 
                density = (allM - redu)/(pi*5^2*500); % 计算平均密度
                thisDen = funP2(density); % 计算该时刻压力 
             end
            Err1(n) = thisDen - 100; % 计算误差 
        end
        s = s+1; 
        Tt(s) = Tt1; 
        Err2(s) = sum(Err1)/N; % 该时间内输入油量的误差 
        Err3(s) = sum(abs(Err1))/N; % 波动误差 
    end
    [~,post] = min(abs(Err2));% 最小误差 
    T1 = Tt(post); 
    error = Err3(post); % 波动误差 
    end
    %% 进油计算
    function inQual = inFuel(time, density, quatyG, Tt1) 
    global dt;% 定义全局变量 dt，为时间离散长度 
    C = 0.85; % 流量系数 
    A = pi*0.7^2;% A 口的面积 
    time = mod(time,Tt1);
    densityThis = quatyG/(pi*2.5^2*(8.2576-funP1(time,Tt1)));
    P1 = funP2(densityThis);
    dP = P1 - funP2(density);
    if dP >0
        inQual = dt*C*A*sqrt(2*dP/densityThis)*densityThis;
    else
        inQual = 0;
    end
        function y = funP1(time,Tt1)
            %计算极经长度
            x = time/Tt1*2*pi;
            if x > pi
               x = 2*pi - x;
            end
               p = [ 0.002396583071159  -0.045169447134520   0.259343667669763  -0.287191167671020  -0.949901781277620  -0.094085519017568   7.247157138979486];
               y = p(1)*x.^6 + p(2)*x.^5 + p(3)*x.^4 + p(4)*x.^3 + p(5)*x.^2 + p(6)*x + p(7);
        end
    end
    %% 密度压强转换函数
    function y = funP2(density)
    a0 = 0.0006492; 
    a2 = 1.181e-09; 
    a1 = -2.005e-06; 
    C1 = -0.217807596; 
    x1 = 0; 
    x2 = 200; 
    for i = 1:15 
        x3 = (x1+x2)/2; 
        diff = C1 + a0*x3 + a1*x3^2/2+a2*x3^3/3 - log(density);%由附件数据拟合而来 
        if diff >0 
            x2 = x3; 
        else
            x1 = x3; 
        end
    end
    y = x1; 
    end
    %% 出油量计算
function outQual = outFuel(time, density) 
global dt;% 定义全局变量 dt，为时间离散长度 
C = 0.85;
time = mod(time,100); % 由于周期的存在，时间取周期的模 
outQual = dt*C*fA(time)*sqrt(2*(funP2(density) - 0.1)/density)*density;
    %计算面积与升程关系
end
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
end
