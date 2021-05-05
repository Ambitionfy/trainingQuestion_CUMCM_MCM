function test
% 储存2004-2020年全球温度数据
clear,clc
%% 清洗数据
C = zeros(180,360,17);
file_path = 'data\';
list = dir(strcat(file_path,'*.txt'));
for ii = 1:17
    c = list(ii).name;
    %% 清洗开始
    fid = fopen(strcat(file_path,c),'rt');
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
    C(:,:,ii) = E;
end
save('data.mat','C')