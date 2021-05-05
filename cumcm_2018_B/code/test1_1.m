function test1_1
global cnc_pos
%数据定义
%tmove -- RGV移动时间
%tprocess -- CNC加工时间
%tud -- 上下料时间
%tclean -- 清洗时间
cnc_pos = [1 1 2 2 3 3 4 4];%cnc对应位置
way = 3;%选用第几组数据
switch way
    case 1
        tmove = [20 33 46];
        tprocess = 560;
        tud = repmat([28 31],1,4);
        tclean = 25;
    case 2
        tmove = [23 41 59];
        tprocess = 580;
        tud = repmat([30 35],1,4);
        tclean = 30;
    case 3
        tmove = [18 32 46];
        tprocess = 545;
        tud = repmat([27 32],1,4);
        tclean = 25;
end
target = 400;%最大目标数量
order = perms(1:8); %全排列
for j = 1 : length(order)
   %思路：先计算第一轮（前八个），再计算完成一个较大的目标
   %数量时的时间，储存在order第九列，再用min选出最小的
   
   queue = [];%等待指令队列
   rgv_pos = 1; %小车对应位置
   cnc_now = zeros(1,8);%当前加工号
   cnc_endtime = zeros(1,8);%当前加工的结束时间
   cnt = 0;%当前加工数
   cnt_finish = 0;%完全加工数
   time = 0;
   result = zeros(target,5);
   %存放结果：物料号、cnc序号、上料开始时间、下料开始时间、结束时间
   
   %第一轮
   for i = 1 : 8
       pos = cnc_pos(order(j,i));%找出当前该去的cnc位置
       if pos == rgv_pos
          result(i,1) = i;
          result(i,2) = order(j,i);
          result(i,3) = time; %不需移动，直接上料
          time = time + tud(order(j,i));%更新时间
          cnc_endtime(order(j,i)) = time + tprocess;%记录该cnc完成时间
          cnc_now(order(j,i)) = i;%该cnc当前在加工第i个物料
       else
           distance = abs(pos - rgv_pos);%计算位置差
           time = time + tmove(distance);%更新时间
           result(i,1) = i;
           result(i,2) = order(j,i);
           result(i,3) = time; %移动时间已更新
           time = time + tud(order(j,i));%更新上料时间
           cnc_endtime(order(j,i)) = time + tprocess;
           cnc_now(order(j,i)) = i;
       end
       rgv_pos = pos;%更新小车位置
   end
   cnt = 8;%更新cnt
   %第二轮
   %规律 -- 下料+清洗+上料+加工
   %上料和下料同时进行
   while cnt_finish < target
       if time < min(cnc_endtime) %所有的都还在工作
           time = min(cnc_endtime);%时间快进过去
           continue;
       else
           queue = check(time,cnc_endtime);%获取完成的队列
           [idx,dis] = getClosest(rgv_pos,queue);%获取队列中最近的cnc和距离
           if dis > 0 %如果需要移动
              time = time + tmove(dis);%更新时间 
              rgv_pos = cnc_pos(idx);
           end
           %上下料 + 加工清洗
           temp = cnc_now(idx);%获取当前cnc加工完毕的货物编号
           result(temp,4) = time;%记录该东西的下料开始时间
           cnt = cnt + 1;%开始加工下一个货物
           result(cnt,1) = cnt;
           result(cnt,2) = idx;
           result(cnt,3) = time;%上下料同时进行
           time = time + tud(idx);%更新时间
           cnc_now(idx) = cnt; %更新当前在加工货物
           cnc_endtime(idx) = time + tprocess; %更新结束时间
           time = time + tclean; %更新时间
           result(cnt,5) = time;
           cnt_finish = cnt_finish + 1;
       end
   end
order(j,9) = result(target,5);
end
% x = find(order == min(order(:,9)));
% order(x,:)
[xtemp,~]=find(order==min(order(:,9))); % 寻找最优的那（些）组参数
answer = order(xtemp,:)
length(answer)


function queue = check(time,cnc_endtime)
%返回已完成工作的cnc
queue = [];
for i = 1 : 8
   if cnc_endtime(i) <= time
      queue = [queue i]; 
   end
end


function [idx,d] = getClosest(rgv_pos,queue)
%返回当前队列中最近的序号和距离
global cnc_pos
d = 1e5;
for i = 1 : length(queue) %遍历所有queue节点
    if abs(cnc_pos(queue(i)) - rgv_pos) < d
       d =  abs(cnc_pos(queue(i)) - rgv_pos);
       idx = queue(i);
    end
end



