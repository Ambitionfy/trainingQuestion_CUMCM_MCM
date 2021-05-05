function test2
R = 255*ones(300,300);
G = 20*ones(300,300);
B = 147*ones(300,300);
C(:,:,1) = R;
C(:,:,2) = G;
C(:,:,3) = B;
imshow(C)
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
for i = 1 : a
    for j = 1 : b
        if E(i,j) == -32768
            G(i,j) = 255;
            R(i,j) = 255;
            B(i,j) = 255;
        end
    end
end
R = Ea./max(Ea); % 归一化
B = B./3.5;
C(:,:,1) = R;
C(:,:,2) = G;
C(:,:,3) = B;