clc; clear all;
% Advent of code 2023 - day 4 - part 1+2

% Open file and take needed data
file_id = fopen("day4.dat");
data = textscan(file_id,strcat('%s %f %c %f %f %f %f %f %f %f %f %f ', ...
    '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f ', ...
    '%f %f %f %f %f'),'delimiter',' |','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Winning numbers
winning = [data{1,4},data{1,5},data{1,6},data{1,7},data{1,8}, ...
    data{1,9},data{1,10},data{1,11},data{1,12},data{1,13}];
% Numbers of elf
numbers = [data{1,14},data{1,15},data{1,16},data{1,17},data{1,18}, ...
    data{1,19},data{1,20},data{1,21},data{1,22},data{1,23}, ...
    data{1,24},data{1,25},data{1,26},data{1,27},data{1,28}, ...
    data{1,29},data{1,30},data{1,31},data{1,32},data{1,33}, ...
    data{1,34},data{1,35},data{1,36},data{1,37},data{1,38}];

% For each card (line) find winning numbers in numbers of elf
for i = 1:201
    % Check each winning number (10)
    count(i) = 0;
    for j = 1:10
        count(i) = count(i)+length(numbers(winning(i,j)==numbers(i,:)));
    end
    % Card values
    if (count(i) == 0)
        value(i) = 0;
    else
        value(i) = 2^(count(i)-1);
    end
end

% Total sum of values
sum_tot = sum(value);

% Part 2
% Check how many instances I get of every card
% Initialize with one instance per card
card_instances(1:201) = 1; 
for i = 1:201
    count_tmp = count(i);
    % We have to do this as many times as we have instances for this card
    for k = 1:card_instances(i)
        for j = 1:count_tmp
            card_instances(i+j) = card_instances(i+j)+1;
        end
    end
end
% Sum 2 is the total number of scratchcards which should just be the summed
% value of card_instances
sum2 = sum(card_instances);

