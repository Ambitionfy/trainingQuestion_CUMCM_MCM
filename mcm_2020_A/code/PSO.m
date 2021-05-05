function PSO
clear,clc,close all
%粒子群算法
s1 = 1.49445;
s2 = 1.49445;%学习因子
Maxg = 100;%进化次数
SizePop = 100;%种群规模
x1max = 1;
x1min = 0.01;
x2max = 100;
x2min = 0.01;
x3max = 31.5;
x3min = 28.5;
Vmax = 1;
Vmin = -1;
par_num = 3;
%产生初始粒子和速度
for i = 1 : SizePop
   Pop(i,1) = rand(1); 
   Pop(i,2) = 10*rand(1);
   Pop(i,3) = 30+1.5*rands(1); 
   V(i,:) = rands(1,par_num);
   %计算适应度
   
   Fitness(i) = test9(Pop(i,1),Pop(i,2),Pop(i,3));
end

%%最优位置初始化
[BestFitness,BestIndex] = max(Fitness);
gBest = Pop(BestIndex,:);%全局最优
pBest = Pop;
FitnesspBest = Fitness;%个体最佳适应度
FitnessgBest = BestFitness;%全局最佳适应度

%%迭代寻优
for i  = 1 : Maxg
    for j = 1 : SizePop
        %种群中各粒子速度更新
        V(j,:) = V(j,:) + s1*rand*(pBest(j,:)-Pop(j,:)) + s2*rand*(gBest-Pop(j,:));
        %更新速度——超过阈值的设为阈值
        V(j,find(V(j,:) > Vmax)) = Vmax;
        V(j,find(V(j,:) < Vmin)) = Vmin;
        %种群粒子位置更新,0.5可换成0-1任意数
        Pop(j,:) = Pop(j,:) + 0.5*V(j,:);
        Pop(find(Pop(:,1) > x1max),1) = x1max;
        Pop(find(Pop(:,1) < x1min),1) = x1min;
        Pop(find(Pop(:,2) > x2max),2) = x2max;
        Pop(find(Pop(:,2) < x2min),2) = x2min;
        Pop(find(Pop(:,3) > x3max),3) = x3max;
        Pop(find(Pop(:,3) < x3min),3) = x3min;
        Fitness(j) = test9(Pop(j,1),Pop(j,2),Pop(j,3));%计算适应度
        %个体最优更新
        if Fitness(j) > FitnesspBest(j)
           pBest(j,:) =  Pop(j,:);
           FitnesspBest(j) = Fitness(j);
        end
        %群体最优更新
        if Fitness(j) > FitnessgBest
           gBest = Pop(j,:);
           FitnessgBest = Fitness(j);
        end
    end
    yy(i) = FitnessgBest;
end
%%输出结果
[FitnessgBest, gBest]

figure
plot(yy)
title('最优个体适应度', 'fontsize', 12);
xlabel('进化代数', 'fontsize', 12);
ylabel('适应度', 'fontsize', 12);
