clc; clearvars;
% Advent of code 2024 - day 1 - part 1+2
% Open file and take needed data
file_id = fopen("day1.dat");
data = textscan(file_id,strcat('%f %f'),'delimiter',', ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

left = data{1,1}; right = data{1,2};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Pair up left and right with increasing number and calculate
% differences between. Add the distances up for the result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
left_ordered = sort(left);
right_ordered = sort(right);
% Get distances
dist = abs(left_ordered-right_ordered);
result1 = sum(dist);

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Determine similarity scores between the lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
sim_score = 0;
for i=1:size(left)
    % Find how often number at current index appears in right
    cnt = sum(right == left(i));
    sim_score = sim_score + left(i)*cnt;
end

fprintf('%10f',sim_score)
fprintf('\n')
toc

