% Programe to compute the number of pulses at
% each iteration.
clc;
clear;
close all;

i = 1;
cnt = 100;
E = 0;
T = 360;
U = [220, 220, 225, 225, 225, 220, 220, 225, 220];
I = 2 .* ones(1, length(U));

while cnt > 0
    E = E + U(i) * I(i);
    n = floor(E / T);
    E = E - n * T;
    cnt = cnt - 1;
    i = i + 1;
    if i == length(U) + 1
        i = 1;
    end
    fprintf("%d\n", n);
end

fileU = fopen('U.txt', 'wt');
fileI = fopen('I.txt', 'wt');

if fileU > 0
    fprintf(fileU,'%x\n',U);
    fclose(fileU);
end
if fileI > 0
     fprintf(fileI,'%x\n',I);
     fclose(fileI);
 end
