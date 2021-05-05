function test1
clear,clc
fid = fopen('1.txt','rt');
%% 洗数据
A = [];
file = fgetl(fid);
while ~feof(fid)
    cc = size(A);
    if cc(1)==180
       break; 
    end
    file = fgetl(fid);
    pp = insertBefore(file,'-32768',' ');
    p = [' '];
    c = strsplit(pp,p);
    c(1) = [];
    A = [A;c];
end
fclose(fid);
E = zeros(180,360);
for i = 1 : 180
   for j = 1 : 360
       c = A(i,j);
       c = cell2mat(c);
       c = str2num(c);
       E(i,j) = c;
   end
end
%% 构造RGB
C = getMap(E);
%% 显示初始图像
figure(1)
imshow(C,'InitialMagnification','fit')
%% 加网格
x = 0.5 : 360+1-0.5;
y = 0.5 : 180+1-0.5;
[M,N] = meshgrid(x,y);
figure(2)
imshow(C,'InitialMagnification','fit')
hold on
plot(x,N,'k');
plot(M,y,'k');
%% 细分到苏格兰区域
E = E(5:69,133:222);
C = getMap(E);
figure(3)
imshow(C,'InitialMagnification','fit')
x = 0.5 : 222-133+2-0.5;
y = 0.5 : 69-5+2-0.5;
[M,N] = meshgrid(x,y);
hold on
plot(x,N,'k');
plot(M,y,'k');
function C = getMap(E)
%% 构造RGB
% 构造规则：陆地为G，高温为R，低温为B
[a,b] = size(E);
Ea = zeros(a,b);
Eb = zeros(a,b);
R = zeros(a,b);
G = zeros(a,b);
B = ones(a,b);
C = zeros(a,b,3);
for i = 1 : a
    for j = 1 : b
        if E(i,j) > 0
            Ea(i,j) = E(i,j);
        else
            Eb(i,j) = E(i,j);
        end
    end
end
R = Ea./max(Ea); % 归一化
B = B./3.5;
for i = 1 : a
    for j = 1 : b
        if E(i,j) == -32768
            G(i,j) = 255;
            R(i,j) = 255;
            B(i,j) = 255;
        end
    end
end
C(:,:,1) = R;
C(:,:,2) = G;
C(:,:,3) = B;