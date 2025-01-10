clc; clear all;
% Advent of code 2023 - day 11 - part 1+2
% Open file and take needed data
file_id = fopen("day11.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);
strings_start = [];
% Rearrange data to be handled nicer
for i = 1:length(data{1,1})
    strings_start = [strings_start;data{1,1}{i,1}];
end
% Test data
% strings_start = ['...#......'; '.......#..'; '#.........'; ...
%     '..........'; '......#...'; '.#........'; '.........#'; ...
%     '..........'; '.......#..'; '#...#.....'];
expansion = 2;
% First find "emtpy" rows and columns and double them
strings_tmp = [];
for i = 1:length(strings_start)
    if (all(strings_start(i,:)=='.'))
        for j = 1:expansion
            strings_tmp = [strings_tmp;strings_start(i,:)];
        end
    else
        strings_tmp = [strings_tmp;strings_start(i,:)];
    end
end
strings = [];
for i = 1:length(strings_tmp(1,:))
    if (all(strings_start(:,i)=='.'))
        for j = 1:expansion
            strings = [strings,strings_tmp(:,i)];
        end
    else
        strings = [strings,strings_tmp(:,i)];
    end
end
% Now find all galaxies '#'
[row_gal,col_gal] = find(strings == '#');
% Now find distances for each pair - we need to go from each galaxy to all
% the others
for i = 1:length(row_gal)
    for j = i+1:length(row_gal)
        % Distance between galaxies
        dist(i,j) = abs(row_gal(j)-row_gal(i)) + abs(col_gal(j)-col_gal(i));
    end
end
% Distance of all the galaxy pairs
result_part1 = sum(sum(dist));
fprintf('%10f',result_part1)
% Result - expansion pairs
result_runs = [10494813, 17222653, 92910853, 849792853];
expansion_runs = [2, 10, 100, 1000];
% If I find out how much the values differ from expansion to expansion I
% should be able to extrapolate the results for 1e6 expansion
% Rate of change per expansion is:
Rate_of_change = (result_runs(2)-result_runs(1))/ ...
    (expansion_runs(2)-expansion_runs(1));
% Now for 1 million just turn around equation
result_part2 = Rate_of_change*(1000000-expansion_runs(1))+result_runs(1);
fprintf('%10f',result_part2)
