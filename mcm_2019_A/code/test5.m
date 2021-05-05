function test5
clear
clc
% d = 1;
% % Wmax = 7003;
% % Wmax = [0.9093    1.0840    0.9202]*1e3;
% K = 1107;
% r = 0.01;
% w = [K];
% for i = 0+d : d : 14000
%    delta =  r * w(end)*(1-w(end)/K) - 2.7654;
%    w = [w w(end)+ delta];
% end
% i = 0 : d : 14000;
% hold on
% plot(i,w,'linewidth',1)
% title('The Number of Sheep-Time(K=1107)')
% xlabel('Time/day')

%%
d = 1;
% Wmax = 7003;
% Wmax = [0.9093    1.0840    0.9202]*1e3;
% r = 0.01;
% ii = [];
% for K = 100 : 1 : 1500
%     w = [K];
%     for i = 0+d : d : 10000
%        delta =  r * w(end)*(1-w(end)/K) - 2.7654;
%        w = [w w(end)+ delta];
%     end
%     idx = find(w <= 0);
%     if sum(idx)>0
%         temp = idx(1);
%         i = 0 : d : 10000;
%         ii = [ii i(temp)];
%     else
%         ii = [ii 0];
%     end
% end
% K = 100 : 1 : 1500;
% plot(K,ii,'.')
% title('Diagram of ecosystem collapse time with K value')
% xlabel('K')
% ylabel('Time of ecosystem collapse/day')

%% 环境对羊的数量影响
d = 1;
% Wmax = [0.9093    1.0840    0.9202]*1e3;
K = [1107 2576 1986];
r = [0.01 0.005 0.005];
rr = [2.7654 3.22 2.48];
for j = 1 : 3
    w = [K(j)];
    for i = 0+d : d : 20000
       delta =  r(j) * w(end)*(1-w(end)/K(j)) - rr(j);
       w = [w w(end)+ delta];
    end
    i = 0 : d : 20000;
    hold on
    plot(i,w,'linewidth',1)
end
title('Diagram of sheep number changing with time in different areas')
xlabel('Time/day')
ylabel('The Number of Sheep')
legend('Warm temperate zone','Arctic','Arid area')

%% 计算
% d = 1;
% Wmax = [0.9093    1.0840    0.9202]*1e3;
% r = [0.01 0.005 0.005];
% ii = [];
% rr = [2.7654 3.22 2.48];
% j = 2;
% for K = 100 : 1 : 3000
%     w = [K];
%     for i = 0+d : d : 10000
%        delta =  r(2) * w(end)*(1-w(end)/K) - rr(j);
%        w = [w w(end)+ delta];
%     end
%     idx = find(w <= 0);
%     if sum(idx)>0
%         temp = idx(1);
%         i = 0 : d : 10000;
%         ii = [ii i(temp)];
%     else
%         ii = [ii 0];
%     end
% end
% K = 100 : 1 : 3000;
% plot(K,ii,'.')
% title('Diagram of ecosystem collapse time with K value(Arctic)')
% xlabel('K')
% ylabel('Time of ecosystem collapse/day')