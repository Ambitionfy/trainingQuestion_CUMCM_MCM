function l2 = test2
% for mm = 0.6 : 0.1 : 25
%    q = getq2(mm);
%    if (q(3601) < 47) && (q(3301) < 44)
%        l2 = mm;
%        break;
%    end
% end
xmin = 0.6;
xmax = 25;
len = 0.01;
while xmax - xmin > len
   mid = (xmin + xmax)/2;
   q = getq2(mid);
   if (q(3601) < 47) && (q(3301) < 44)
       xmax = mid;
   else 
       xmin = mid;
   end
end
l2 = xmax;
