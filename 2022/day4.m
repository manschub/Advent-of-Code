clc; clearvars;
% Advent of code 2022 - day 4 - part 1+2
% Open file and take needed data
file_id = fopen("day4.dat");
data = textscan(file_id,strcat('%f %f %f %f'),'Delimiter',',-');
% Close file
fclose(file_id);

elf1 = [data{1,1},data{1,2}];
elf2 = [data{1,3},data{1,4}];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Pairs of elves have to clean sections of camps and sometimes
% these sections overlap - we have to find cases where one elves' sections
% completely contain the other elves' sections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0;
% Go through elves
for i = 1:length(elf1(:,1))
    % Check if either elf1 contains elf2 completely or the other way around
    if (elf1(i,1) <= elf2(i,1) && elf1(i,2) >= elf2(i,2) || ...
        elf2(i,1) <= elf1(i,1) && elf2(i,2) >= elf1(i,2))
        result1 = result1+1;
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we want any overlap not only complete overlaps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
result2 = 0;
% Go through elves
for i = 1:length(elf1(:,1))
    % Check for overlapping sections between the elves
    tmp1 = elf1(i,1):elf1(i,2);
    tmp2 = elf2(i,1):elf2(i,2);
    if (sum(sum(tmp1(:)==tmp2))>0)
        result2 = result2+1;
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc

