function  test5
clear
clc
% for mm = 0.6 : 0.1 : 25
%    q = getq2(mm);
%    if (q(3601) < 47) && (q(3301) < 44)
%        l2 = mm;
%        break;
%    end
% end
% for x = 0.6 : 0.1 : 25
%     q1 = getq2(x);
%     time = q1(find(q1 > 44));
%     if sum(time) == 0
%        time = 0;
%     else
%         time = time(1);
%     end
%     temp = [x q1(3601) time];
%     q = [q;temp];
% end
%%图
q = [];
for x = 0.6 : 0.1 : 25
    q1 = getq2(x);
    temp = [x q1(3601) q1(3301)];
    q = [q;temp];
end
x = 0.6 : 0.1 : 25;
w = q(:,2);
e = q(:,3);
figure(1)
plot(x,w);
title('工作60分钟时，假人皮肤外侧温度');
hold on 
plot(x,47*ones(size(x)));
figure(2)
plot(x,e);
xlabel('II层的厚度/mm')
ylabel('温度/摄氏度')
title('工作55分钟时，假人皮肤外侧温度');
hold on
plot(x,44*ones(size(x)));
xlabel('II层的厚度/mm')
ylabel('温度/摄氏度')
%%表
q = [];
for x = [0.6 6 10 13 16 20 22 25]
    q1 = getq2(x);
    temp = [x q1(3601) q1(3301)];
    q = [q;temp];
end
q
