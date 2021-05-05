function test2
clear
clc
d = 0.01;
% Wmax = 7003;
Wmax = [0.9093    1.0840    0.9202]*1e3;
alpha = 1-25*0.004;
r = 2;
w = [10];
for j = 1 : 3
    for i = 0+d : d : 10
       delta =  d * r * w(end)*(1-w(end)/Wmax(j));
       w = [w w(end)+ delta];
    end
    i = 0 : d : 10;
    hold on
    plot(i,w,'linewidth',1)
    w = [10];
end
title('The change of body weight of dragon with time in different environment')
xlabel('Time/year')
ylabel('Weight/Kg')
legend('Warm temperate zone','Arctic','Arid area')
%% 
figure
d = 0.01;
% Wmax = 7003;
Wmax = [0.9093    1.0840    0.9202]*1e3;
alpha = 1-25*0.004;
r = 2;
w = [10];

    for i = 0+d : d : 10
       delta =  d * r * w(end)*(1-w(end)/Wmax(1));
       w = [w w(end)+ delta];
    end
    i = 0 : d : 10;
    hold on
    plot(i,w,'linewidth',1)
    w = [10];
title('The diagram of the weight of dragon changing with time')
xlabel('Time/year')
ylabel('Weight/Kg')