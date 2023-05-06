clc;
clear;
close all;

I_values = 0 : 0.125 : 7;
i_values = (I_values + 9.1608) / 16.385;

U_values = 200 : 10 : 240;
u_values = (U_values - 1.6886) / 248.55;

fileU = fopen('Converted_U.txt', 'wt');
fileI = fopen('Converted_I.txt', 'wt');

if fileU > 0
    fprintf(fileU, '\nValues from codec:');
    fprintf(fileU,'%f\n', u_values);
    fprintf(fileU, '\nReal values:');
    fprintf(fileU,'%f\n', U_values);
    fclose(fileU);
end

if fileI > 0
    fprintf(fileI, '\nValues from codec:');
    fprintf(fileI,'%f\n', i_values);
    fprintf(fileI, '\nReal values:');
    fprintf(fileI, '%f\n', I_values);
    fclose(fileI);
end