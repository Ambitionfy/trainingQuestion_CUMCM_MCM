function test5
%第一问
clear,clc 
global dt Tc;
Tc = 2; 
dt = 0.01; % 时间离散长度 
s = 0; % 迭代变量 
%% 寻优计算参数 
t0s = 0:0.1:0.2; 
for t0 = t0s% 初始时高压油泵的延时 
    s = s+1;
    [t1(s), error(s)] = funRes(t0); % t0：初始喷油延时
end % 选择最小的误差与对应的喷油时间 
    [Error,post] = min(error);% 选择最小的误差与对应的喷油时间 
    %% 重新计算最优参数 ，记录状态值 
    t0 = t0s(post);% 延时时间 
    T1 = t1(post); % 对应的 t1 值 
    N = 1000*Tc/dt;density = 0.850; % 密度初值 
    for n = 1:N % 离散计算 
        time = n * dt; % 计算实际时间 % 进油总质量 
        inQual = inFuel(time, density, t0, T1); 
        inQ(n) = inQual; % 记录值 
        outQual = outFuel(time, density); 
        outQ(n) = outQual;% 记录值
        allM(n) = density*pi*5^2*500; % 计算总质量 
        density = (allM(n) - outQual + inQual)/(pi*5^2*500); % 计算平均密度
        Denp(n) = funP2(density); % 计算该时刻压力 
        Err1(n) = Denp(n) - 150; % 计算误差 
    end
    Err2 = sum(Err1)/N; % 该时间内输入油量的误差 
    Err3 = sum(abs(Err1))/N;
    figure 
    plot((1:N)/100,Denp,'-','Linewidth',1) 
    legend('压强曲线') 
    xlabel('时间 t(ms)') 
    ylabel('压强 P(Mpa)') 
    set(gcf,'units','centimeters') 
    set(gcf,'InnerPosition',[0 5 16 8]) 
    fprintf('喷油角速度为%.3frad/ms\n',2*pi/T1) 
    fprintf('喷油周期为%.3fms\n',T1) 
    fprintf('开始喷油延时%.3fms\n',t0) 
end
%% 计算进油工作周期
    function [T1, error] = funRes(t0) 
    global dt Tc
    N = 1000*Tc/dt;%一个周期的离散时间点的个数
    s = 0; 
    for Tt1 = 27:10:90 % 搜索法，进油工作周期 
        density = 0.850; % 密度初值 
        for n = 1:N % 离散计算 
            time = n * dt; % 计算实际时间 % 进油 
            inQual = inFuel(time, density, t0, Tt1*dt);
            outQual = outFuel(time, density);
            allM = density*pi*5^2*500;% 计算总质量 
            density = (allM - outQual + inQual)/(pi*5^2*500);% 计算平均密度 
            Err1(n) = funP2(density) - 150;% 计算误差 
        end
        s = s+1; 
        Tt(s) = Tt1*dt; 
        Err2(s) = sum(Err1)/N; % 该时间内输入油量的误差 
        Err3(s) = sum(abs(Err1))/N; % 波动误差 
    end
    [~,post] = min(abs(Err2));% 最小误差 
    T1 = Tt(post); 
    error = Err3(post); % 波动误差 
    end
    %% 进油计算
    function inQual = inFuel(time, density, t0, Tt1) 
    global dt;% 定义全局变量 dt，为时间离散长度 
    C = 0.85; % 流量系数 
    A = pi*0.7^2;% A 口的面积 
    P1 = 160;% 高压油泵在 A 口提供的恒压 
    density0 = 0.871;% 初始密度 
    time = mod(time,Tt1+10); % 由于周期的存在，时间取周期的模 
    if time <t0
        inQual = 0; 
    elseif time <= t0+Tt1% 一个进油周期 
        inQual = dt*C*A*sqrt(2*(P1-funP2(density))/density0)*density0; 
    else
        inQual = 0;
    end
    end
    %% 密度压强转换函数
    function y = funP2(density)
%     a0 = 0.0006492; 
%     a2 = 1.181e-09; 
%     a1 = -2.005e-06; 
%     C1 = -0.217807596; 
%     x1 = 0; 
%     x2 = 200; 
%     for i = 1:15 
%         x3 = (x1+x2)/2; 
%         diff = C1 + a0*x3 + a1*x3^2/2+a2*x3^3/3 - log(density);%由附件数据拟合而来 
%         if diff >0 
%             x2 = x3; 
%         else
%             x1 = x3; 
%         end
%     end
%     y = x1; 
% y = 0.803452618506904*density^5 + 0.000463943214532*density^4 + 0.000000562811508*density^3 -0.000000005738418*density^2 + 0.000000000013927*density - 0.000000000000011;
% y = 0.804948682773639*density^2+0.000473125971665*density-0.000000229109460;
% y = (562949953421312*((906291646947933*density)/281474976710656 + 20449558446266725837806273026803/21267647932558653966460912964485513216)^(1/2))/906291646947933 - 2181908428482353/7424341171797467136;
    y = 0.194758031860119*density^6-1.044362791087357*density^5+2.330815003725921*density^4-2.771251149132548*density^3+1.851323491949149*density^2-0.658879442256091*density+0.097597436692721;
    y = 1e9*y;
    end
    %% 出油量计算
    function outQual = outFuel(time, density) 
    global dt;% 定义全局变量 dt，为时间离散长度 
    time = mod(time,100); % 由于周期的存在，时间取周期的模 
    if time 
        outQual = fPout(time)-fPout(time-dt); 
        outQual = outQual * density; 
    else
        outQual = 0;
    end
        function y = fPout(t) 
            if t<50-0.4 
                y = 0; 
            elseif t < 0.2+50-0.4 
                t = t-50+0.4; 
                y = 50*t^2; 
            elseif t < 2.2+50-0.4 
                t = t-50+0.4; 
                y = 20*t-2; 
            elseif t <=2.4+50-0.4 
                t = t-50+0.4; 
                y = 240*t-50*t^2-288+44; 
            else y = 44; 
            end
        end
    end