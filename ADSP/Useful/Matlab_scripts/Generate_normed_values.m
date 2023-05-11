values = rand(20);
values = values(values > 0.8);

fileU = fopen('random_normed_u.txt', 'wt');

if fileU > 0
    fprintf(fileU,'%f\n',values);
    fclose(fileU);
end


values = rand(20);
values = values(values >= 0.559);

fileI = fopen('random_normed_i.txt', 'wt');

if fileI > 0
    fprintf(fileI,'%f\n',values);
    fclose(fileI);
end