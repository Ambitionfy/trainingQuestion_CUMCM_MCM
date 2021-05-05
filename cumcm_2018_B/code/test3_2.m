function test3_2
clear
clc
global cnc_pos
N = 1e3;
mm = 0;
mmm = 0;
for m = 1 : N
%数据定义
%tmove -- RGV移动时间
%tprocess -- CNC加工时间
%tud -- 上下料时间
%tclean -- 清洗时间
cnc_pos = [1 1 2 2 3 3 4 4];%cnc对应位置
way = 1;%选用第几组数据
break_idx = [];
break_start = [];
break_end = [];
breakall = [];
switch way
    case 1
        tmove = [20 33 46];
        tprocess1 = 400;
        tprocess2 = 378;
        tud = repmat([28 31],1,4);
        tclean = 25;
        order1 = [1 5 8 3];
        num = 4;
    case 2
        tmove = [23 41 59];
        tprocess1 = 280;
        tprocess2 = 500;
        tud = repmat([30 35],1,4);
        tclean = 30;
        order1 = [1 7 5];
        num = 3;
    case 3
        tmove = [18 32 46];
        tprocess1 = 455;
        tprocess2 = 182;
        tud = repmat([27 32],1,4);
        tclean = 25;
        order1 = [1 8 4 6 7 2];
        num = 6;
end
target = 300;%最大目标数量
   %思路：先计算第一轮，再计算完成一个较大的目标
   %数量时的时间，储存在order第九列，再用min选出最小的
   
queue1 = [];%工序1等待指令队列
queue2 = [];%工序2等待指令队列
rgv_pos = 1; %小车对应位置
cnc_now = zeros(1,8);%当前加工号
cnc_endtime = zeros(1,8);%当前加工的结束时间
cnc_assign = 2*ones(1,8);%cnc负责的工序
cnt = 0;%当前加工数
cnt_finish = 0;%完全加工数
time = 0;
result = zeros(target,8);
%存放结果：物料号、工序1cnc序号、上料开始时间、下料开始时间、
%工序2cnc序号、上料开始时间、下料开始时间、结束时间

for i = 1 : num
  cnc_assign(order1(i)) = 1; 
  %更新cnc负责工序
end

%第一轮
for i = 1 : num
   pos = cnc_pos(order1(i));%找出当前该去的cnc位置
   if pos == rgv_pos
      result(i,1) = i;
      result(i,2) = order1(i);
      result(i,3) = time; %不需移动，直接上料
      time = time + tud(order1(i));%更新时间
      cnc_endtime(order1(i)) = time + tprocess1;%记录该cnc完成时间
      cnc_now(order1(i)) = i;%该cnc当前在加工第i个物料
   else
       distance = abs(pos - rgv_pos);%计算位置差
       time = time + tmove(distance);%更新时间
       result(i,1) = i;
       result(i,2) = order1(i);
       result(i,3) = time; %移动时间已更新
       time = time + tud(order1(i));%更新上料时间
       cnc_endtime(order1(i)) = time + tprocess1;
       cnc_now(order1(i)) = i;
   end
   rgv_pos = pos;%更新小车位置
end
cnt = num;%更新cnt
%第二轮
%规律 -- 
%上料和下料同时进行
flag = 1;%执行工序 -- 1/2
hold = 1;%所持半成品的工序

while cnt_finish < target
   if time >= 8*3600
        break;
   end
   
	xtemp = [];
    for i = 1 : length(break_idx)
        if time >= break_start(i) && time <= break_end(i)
           cnc_now(break_idx(i)) = 0;%当前加工的报废了
           cnc_endtime(break_idx(i)) = 9999999;
        elseif time >= break_end(i)
            cnc_endtime(break_idx(i)) = time;
            xtemp = [xtemp,i];
        end
    end
    break_start(xtemp) = [];
    break_end(xtemp) = [];
    break_idx(xtemp) = [];
   
   if time < min(cnc_endtime(cnc_assign == flag)) %所有的都还在工作
       time = min(cnc_endtime(cnc_assign == flag));%时间快进过去
       continue;
   else
       [queue1,queue2] = check(time,cnc_endtime,cnc_assign);%获取完成的队列
       if flag == 1%下一步要做的是工序1
           [idx,dis] = getClosest(rgv_pos,queue1);%获取队列中最近的cnc和距离
           if dis > 0 %如果需要移动
              time = time + tmove(dis);%更新时间 
              rgv_pos = cnc_pos(idx);
           end
           %上下料 + 加工清洗
           temp = cnc_now(idx);%获取当前cnc加工完毕的货物编号
           if temp == 0
                cnt = cnt + 1; % 取一个新的生料
                result(cnt,1) = cnt;
                result(cnt,2) = idx;
                result(cnt,3) = time;
                time = time + tud(idx); % 上下料操作时间消耗
                cnc_now(idx) = cnt; %更新加工物料序号
                cnc_endtime(idx) = time + tprocess1; % 更新加工完成时间
                flag = 1;
           else
               result(temp,4) = time;%记录该东西的下料开始时间
               cnt = cnt + 1;%开始加工下一个货物
               result(cnt,1) = cnt;
               result(cnt,2) = idx;
               result(cnt,3) = time;%上下料同时进行
               time = time + tud(idx);%更新时间         
               cnc_now(idx) = cnt; %更新当前在加工货物
               cnc_endtime(idx) = time + tprocess1; %更新结束时间
               if getp() == 1
                   break_idx = [break_idx,idx];
                   start_time = time + rand*tprocess1;
                   time_break = 10 + 10*rand;
                   break_start = [break_start,start_time];
                   break_end = [break_end,start_time+time_break]; 
                   breakall = [breakall;idx,start_time,time_break];
               end
               hold = temp;
               flag = 2;
           end
       else
           [idx,dis] = getClosest(rgv_pos,queue2);%获取队列中最近的cnc和距离
           if dis > 0 %如果需要移动
              time = time + tmove(dis);%更新时间 
              rgv_pos = cnc_pos(idx);
           end
           if cnc_now(idx) > 0 %台子上有东西，即第一轮之后
              temp = cnc_now(idx);%记录编号
              result(temp,7) = time;%下料开始
              sp = 1;%标记台上有东西
           else
              sp = 0;
           end
           result(hold,5) = idx;%记录二道工序的cnc号
           result(hold,6) = time;%记录上料开始时间
           time = time + tud(idx);%更新时间
           cnc_now(idx) = hold;%更新加工编号
           cnc_endtime(idx) = time + tprocess2;%更新结束时间
           if getp() == 1
               break_idx = [break_idx,idx];
               start_time = time + rand*tprocess2;
               time_break = 10 + 10*rand;
               break_start = [break_start,start_time];
               break_end = [break_end,start_time+time_break]; 
               breakall = [breakall;idx,start_time,time_break];
           end
           if sp == 1 %如果有东西
               cnt_finish = cnt_finish + 1;
               time = time + tclean;%更新时间
               result(temp,8) = time;%记录完成时间
           end
           flag = 1;%下一道工序为1
       end
   end
end
% cnt_finish
% breakall
mm = mm + cnt_finish;
mmm = mmm + length(breakall);
end
mm/N
mmm/N



function [queue1,queue2] = check(time,cnc_endtime,cnc_assign)
%返回已完成工作的cnc
queue1 = [];
queue2 = [];
for i = 1 : 8
   if cnc_endtime(i) <= time
      if cnc_assign(i) == 1
         queue1 = [queue1 i];
      else
         queue2 = [queue2 i];
      end
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

function [key] = getp()
x = ceil(rand*100);
if x == 1
   key = 1;
else
    key = 0;
end