function test11
load('A_pre_2.mat');
E = [];
F = [];
m = 20;
n = 40;
for i = 1 : 17
    E = [E A(m,n,i)];
end
E = [3.0100 2.6400 2.7600 2.6700 2.6000 2.4400 3.0100 3.1900 3.2100 2.9100 2.6500 3.2000 3.1200 3.0900 2.4300 3.3500 3.2400];
% for i = 1 : 18
%     E = [E A(m,n,i)];
% end
% for i = 18 : 67
%     F = [F A(m,n,i)];
% end
% plot(2004:2021,E,'linewidth',1);
% hold on
% plot(2021:2070,F,'linewidth',1)
% xlabel('Year')
% ylabel('Temperature/centigrade')
% legend('Raw data','Forecast data')