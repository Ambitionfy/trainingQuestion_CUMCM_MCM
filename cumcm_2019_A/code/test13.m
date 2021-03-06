function test13
%实验三——初始时刻遍历时间
clear,clc 
global dt Tc;% 定义全局变量 dt 和 Tc，分别为时间离散长度和最大公倍数周期 
Tc = 2; % 最大公倍数周期，单位 s 
dt = 0.01; % 时间离散长度 
s = 0; % 迭代变量 
%% 寻优计算参数 
t0s = 48:0.1:50.6; 
% 寻优列表 
for t0 = t0s% 初始时高压油泵的延时 
    s = s+1; % 迭代次数 % 计算在延时为 t0 时的喷油时间 T1 和误差 
    [t1(s), error(s)] = funRes(t0); % t0：初始喷油延时，f P：目标压强 
end % 选择最小的误差与对应的喷油时间 
    [Error,post] = min(error);% 选择最小的误差与对应的喷油时间 
    t0s(post)
    plot(t1,error)
    xlabel('两喷油间隔/ms')
    ylabel('误差')
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
                density = (allM - outQual + inQual)/(pi*5^2*500); % 计算平均密度
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
        inQual = dt*C*A*sqrt(2*dP/densityThis)*density;
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
end
%计算面积与升程关系
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
