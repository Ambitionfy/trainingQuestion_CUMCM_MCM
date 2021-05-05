function test4
figure
tt = [1213000 1.4461e+06 1.2275e+06];
w = [10];
d = 0.001;% ²½³¤
r = 2;
for j = 1 : 3
    for i = 0+d : d : 10
           delta =  d * r * w(end)*(1-w(end)/tt(j));
           w = [w w(end)+ delta];
    end
    i = 0 : d : 10;
    k = 390;
    L = (w/k).^0.25;
    hold on
    plot(i,L,'linewidth',1)
    L(end)
    w = [10];
end
title('Schematic diagram of the length of the Dragon changing with time')
xlabel('Time/year')
ylabel('The length of the Dragon/m')
legend('Warm temperate zone','Arctic','Arid area')
