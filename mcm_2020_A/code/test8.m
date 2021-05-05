% function temp = test9(m,xx)
function test8
% 第三问模型一
Q1 = [34.61,40.15];
Q2 = [20.34,43.57];
a = 9;% 鲱鱼（下）
b = 5; % 鲭鱼（上）
% posS1 = [xx 43.5];
posS = [29 45];% 苏格兰位置
% d1 = norm(Q1-posS1);
% d2 = norm(Q2-posS1);
d3 = norm(Q1-posS);
% d4 = norm(posS-posS1);
% d5 = norm(Q1-posS1);
% temp = m*(a/d1+b/d2)+(1-m)*(a/d3+b/d5)+c/d4;
A = [];
m = 1;
c = 0.6;
for xx = 28.5 : 0.01 : 31.5
    posS1 = [xx 43.5];
    d1 = norm(Q1-posS1);
    d2 = norm(Q2-posS1);
    d4 = norm(posS-posS1);
    d5 = norm(Q1-posS1);
    temp = m*(a/d1+b/d2)+(1-m)*(a/d3)-c/d4;
    temp = a/d1+b/d2+a/d3+c/d4;
    A = [A temp];
end
plot(31.5 : -0.01 : 28.5,A,'linewidth',1)