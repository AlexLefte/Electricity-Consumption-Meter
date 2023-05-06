clc;
close all;

fid = fopen('HalfPulsePerSec.txt', 'r');  % Deschideți fișierul pentru citire

if fid == -1
    error('Nu s-a putut deschide fisierul.');
end

values = [];
cnt = 0;
unit = 'e-3 ';

while ~feof(fid)  % Repetați până la sfârșitul fișierului
    line = strtrim(fgets(fid));  % Citiți un rând din fișier
    
    % Procesați linia aici (de exemplu, afișați-o)
%     fprintf('%s', line);

   if isequal(line, '0000')
    valoare = '0';  % Atribuiți 0 variabilei "valoare" în cazul în care linia este '0000'
elseif isequal(line, '0001')
    valoare = '1';  % Atribuiți 1 variabilei "valoare" în cazul în care linia este '0001'
else
    valoare = -1;  % Atribuiți o altă valoare (de exemplu, -1) în cazul în care linia nu este nici '0000', nici '0001'
end
 
value = string(cnt) + unit + valoare;
cnt = cnt + 20;
values = [values value];

end

fileU = fopen('test_pulse.txt', 'wt');

if fileU > 0
    fprintf(fileU,'%s\n',values);
    fclose(fileU);
end


fclose(fid);  % Închideți fișierul
