function [m,n] = test3
%4-0层是空气，可以厚一点，因此直接取最大
n = 6.4;

% xmin = 0.6;
% xmax = 25;
% len = 0.01;
% while xmax - xmin > len
%    mid = (xmax + xmin)/2;
%    q = getq3(mid,n);
%    if (q(1801) < 47) && (q(1501) < 44)
%        xmax = mid;
%    else
%        xmin = mid;
%    end
% end
% m = xmax;
for m = 0.6:0.1:25
   for n = 0.6:0.1: 
    
    
end