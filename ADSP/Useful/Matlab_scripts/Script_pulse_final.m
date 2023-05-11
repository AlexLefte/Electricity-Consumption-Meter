clc;
close all;

fid = fopen('Output_ADSP_raw.txt', 'r');  % Deschideți fișierul pentru citire

if fid == -1
    error('Nu s-a putut deschide fisierul.');
end

PULSES = [];
MODE1 = [];
MODE2 = [];
POWER1 = [];
POWER2 = [];
POWER3 = [];
cnt = 0;
unit = 'e-3 ';

while ~feof(fid)  % Repetați până la sfârșitul fișierului
    line = strtrim(fgets(fid));  % Citiți un rând din fișier
    
    % Procesați linia aici (de exemplu, afișați-o)
%     fprintf('%s', line);

line = hex2dec(line);

if bitand(line, 1)
    valoare = '5';  
elseif bitand(line, 1) == 0
    valoare = '0';  
else
    valoare = -1; 
end

if bitand(bitshift(line, -1), 1) == 1
    mode1 = '5';  
else
    mode1 = '0';  
end

if bitand(bitshift(line, -2), 1) == 1
    mode2 = '5';  
else 
    mode2 = '0'; 
end

if bitand(bitshift(line, -3), 1) == 1
    power1 = '5';  
else 
    power1 = '0'; 
end

if bitand(bitshift(line, -4), 1) == 1
    power2 = '5';  
else 
    power2 = '0';  
end

if bitand(bitshift(line, -5), 1) == 1
    power3 = '5';  
else 
    power3 = '0';  
end

pulse = string(cnt) + unit + valoare;
mode1 = string(cnt) + unit + mode1;
mode2 = string(cnt) + unit + mode2;
power1 = string(cnt) + unit + power1;
power2 = string(cnt) + unit + power2;
power3 = string(cnt) + unit + power3;

PULSES = [PULSES pulse];
MODE1 = [MODE1 mode1];
MODE2 = [MODE2 mode2];
POWER1 = [POWER1 power1];
POWER2 = [POWER2 power2];
POWER3 = [POWER3 power3];
cnt = cnt + 19.999;

pulse = string(cnt) + unit + valoare;
mode1 = string(cnt) + unit + mode1;
mode2 = string(cnt) + unit + mode2;
power1 = string(cnt) + unit + power1;
power2 = string(cnt) + unit + power2;
power3 = string(cnt) + unit + power3;

PULSES = [PULSES pulse];
MODE1 = [MODE1 mode1];
MODE2 = [MODE2 mode2];
POWER1 = [POWER1 power1];
POWER2 = [POWER2 power2];
POWER3 = [POWER3 power3];
cnt = cnt + 0.001;
end

fileU = fopen('PULSE.txt', 'wt');
if fileU > 0
    fprintf(fileU,'%s\n', PULSES);
    fclose(fileU);
end
fileU = fopen('MODE1.txt', 'wt');
if fileU > 0
    fprintf(fileU,'%s\n', MODE1);
    fclose(fileU);
end
fileU = fopen('MODE2.txt', 'wt');
if fileU > 0
    fprintf(fileU,'%s\n', MODE2);
    fclose(fileU);
end
fileU = fopen('POWER1.txt', 'wt');
if fileU > 0
    fprintf(fileU,'%s\n', POWER1);
    fclose(fileU);
end
fileU = fopen('POWER2.txt', 'wt');
if fileU > 0
    fprintf(fileU,'%s\n', POWER2);
    fclose(fileU);
end
fileU = fopen('POWER3.txt', 'wt');
if fileU > 0
    fprintf(fileU,'%s\n', POWER3);
    fclose(fileU);
end
fclose(fid);  % Închideți fișierul