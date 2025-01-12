clc; clearvars;
% Advent of code 2022 - day 3 - part 1+2
% Open file and take needed data
file_id = fopen("day3.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

rucksacks = data{:,:};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to help reorder rucksacks - 1 items each is in both
% compartments which needs to be found
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0;
% Prepare priority calculations
priorities = 'a':'z';
priorities = [priorities,'A':'Z'];
prio_vals = 1:52;
% Go through rucksacks
for i = 1:length(rucksacks(:,1))
    % Split in first and second compartment
    first = rucksacks{i,1}(1:length(rucksacks{i,1})/2);
    sec = rucksacks{i,1}(length(rucksacks{i,1})/2+1:length(rucksacks{i,1}));
    % Find identical value
    [~,c]=find((first(:)==sec)==1);
    val = unique(sec(c));
    % Get the priority value
    result1 = result1+prio_vals(priorities==val);
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now instead of comparing the two compartents we compare between
% groups of three rucksacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
result2 = 0;
% Go through rucksacks
for i = 1:3:length(rucksacks(:,1))
    % Split in first and second compartment
    first = rucksacks{i,1};
    sec = rucksacks{i+1,1};
    third = rucksacks{i+2,1};
    % Find identical value between first two rucksacks
    [~,c]=find((first(:)==sec)==1);
    val1 = unique(sec(c));
    % Get the value that also fits with the third rucksack
    [~,c]=find((val1(:)==third)==1);
    val2 = unique(third(c));
    % Get the priority value
    result2 = result2+prio_vals(priorities==val2);
end

fprintf('%10f',result2)
fprintf('\n')
toc

