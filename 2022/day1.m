clc; clearvars;
% Advent of code 2022 - day 1 - part 1+2
% Open file and take needed data
file_id = fopen("day1.dat");
data = textscan(file_id,strcat('%f'));
% Close file
fclose(file_id);

calories = data{:,:};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Pair up left and right with increasing number and calculate
% differences between. Add the distances up for the result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Go through elves
idx = 1; sum = 0;
for i = 1:length(calories(:,1))
    if (calories(i,1)==0)
        cal_sum(idx) = sum;
        idx = idx+1;
        sum = 0;
    else
        sum = sum+calories(i,1);
    end
end
cal_sum(idx) = sum;
% Get

result1 = max(cal_sum);

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Same but we need to add up the three top caloric elves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
one = max(cal_sum);
two = max(cal_sum(cal_sum<one));
three = max(cal_sum(cal_sum<two));
result2 = one+two+three;

fprintf('%10f',result2)
fprintf('\n')
toc

