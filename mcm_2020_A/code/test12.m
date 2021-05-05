function test12
%% 计算升高的温度
% load('A_pre_2.mat');
% size(A)
% E = A(:,:,1);
% F = A(:,:,end);
% n = 0;
% c = 0;
% for i = 1 : 65
%    for j = 1 : 90
%       temp1 = E(i,j);
%       temp2 = F(i,j);
%       if temp1 ~= -327.68
%           n = n + 1;
%           c = temp2-temp1+c;
%       end
%    end
% end
% c/n
%% 计算位置
% x1 = [43.7 20.41];
% y = [44.5 29.5];
x1 = [43.5 28.5];
y = [42 28.84];
c = norm(x1-y)*102.6923