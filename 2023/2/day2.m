clc; clear all
% Advent of code - Day 2 - Part 1 and 2
file_id = fopen("day2.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n');
% Close file
fclose(file_id);

blue = zeros(100); green = zeros(100); red = zeros(100);

for i = 1:100
    j = 1; k = 1;
    while (j <= length(data{1,1}{i,1}))
        if (data{1,1}{i,1}(j) == ';') 
            k = k+1;
        elseif (data{1,1}{i,1}(j) == 'b')
            blue(i,k) = blue(i,k) + str2num(data{1,1}{i,1}(j-3:j-2));
            j = j+3;
        elseif (data{1,1}{i,1}(j) == 'g')
            green(i,k) = green(i,k) + str2num(data{1,1}{i,1}(j-3:j-2));
            j = j+4;
        elseif (data{1,1}{i,1}(j) == 'r')
            red(i,k) = red(i,k) + str2num(data{1,1}{i,1}(j-3:j-2));
            j = j+2;
        end
        j = j+1;
    end
end

correct = 0; correct2 = 0; x = [0,0,0];
for i = 1:100
    if (min(red(i,:) <= 12) == 1 && min(green(i,:) <= 13) == 1 ...
            && min(blue(i,:) <= 14) == 1)
        correct = correct + i;
    end
    x(i,:) = [max(red(i,:)), max(green(i,:)), max(blue(i,:))];
    if (x(i,1) <= 12 && x(i,2) <= 13 && x(i,3) <= 14)
        correct2 = correct2 + i;
    end
    power(i) = x(i,1) * x(i,2) * x(i,3);
end

result_part2 = sum(power);

