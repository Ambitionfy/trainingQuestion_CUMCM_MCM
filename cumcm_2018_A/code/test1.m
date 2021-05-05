function [kereal,ksreal,minval] = test1
clear
clc
a = xlsread('2.xlsx');
a = a(:,2);
kereal = 0;
ksreal = 0;
% r = zeros(1000*20000,3);
% r = zeros(300*2100,3);
% i = 0;
% for ks = 8 : 0.01 : 10
%    for ke = 100 : 0.01 : 120
%        ytemp = getq1(ke,ks);
%        xtemp = ytemp - a;
%        val = sum(xtemp.^2);
%        if val < 100
%           i = i + 1;
%           r(i,:) = [ke,ks,val];
%        end
%    end
% end
% r(find(r(:,3)==0),end) = 1e5;
% [minval,minidx] = min(r(:,3));
% kereal = r(minidx,1);
% ksreal = r(minidx,2);
minval = 1e5;
for ks = 8 : 0.01 : 9
   for ke = 100 : 0.01 : 120
      val = 0;
      ytemp = getq1(ke,ks);
      if abs(ytemp(end) - 48) > 2
         continue; 
      end
      for i = 1 : length(ytemp)
         val = val + (ytemp(i) - a(i))^2; 
      end
      if val < minval
         minval = val; 
         kereal = ke;
         ksreal = ks;
      end
   end
end
