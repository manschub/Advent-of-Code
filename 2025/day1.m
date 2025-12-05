clc; clearvars;
% Advent of code 2025 - day 1 - part 1+2
% Open file and take needed data
file_id = fopen("day1.dat");
data = textscan(file_id,strcat('%s'),'delimiter',', ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

direction(1:size(data{1,1},1),1) = 'x';
clicks(1:size(data{1,1},1),1) = 0;
for i = 1:size(data{1,1},1)
    direction(i) = data{1,1}{i,1}(1); 
    clicks(i) = str2double(data{1,1}{i,1}(2:end));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Turn dial of safe to left and right according to instructions
% and count how many times we are at zero.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% We start at 50
dial = 50;
zero_cnt = 0;

for i = 1:size(data{1,1},1)
    % Check if we go left or right
    if (direction(i) == 'L')
        % Left
        dial = mod(dial-clicks(i),100);
    elseif (direction(i) == 'R')
        % Right
        dial = mod(dial+clicks(i),100);
    end
    % Check for 0
    if (dial == 0)
        zero_cnt = zero_cnt+1;
    end
end
result1 = zero_cnt;

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we count every click of 0 so we also have to count going
% from 99 to 0 and from 1 to 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 

% We start at 50
dial = 50;
zero_cnt = 0;

for i = 1:size(data{1,1},1)
    % Check if we go left or right
    if (direction(i) == 'L')
        % Left
        for j = 1:clicks(i)
            dial = dial-1;
            if (dial == 0) % Check for 0
                zero_cnt = zero_cnt+1;
            elseif (dial == -1)
                dial = 99;
            end 
        end
    elseif (direction(i) == 'R')
        % Right
        for j = 1:clicks(i)
            dial = dial+1;
            if (dial == 100) % Check for 0
                zero_cnt = zero_cnt+1;
                dial = 0;
            end 
        end
    end
end
result2 = zero_cnt;

% 5376 too low
% 5870 wrong

fprintf('%10f',result2)
fprintf('\n')
toc