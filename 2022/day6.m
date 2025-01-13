clc; clearvars;
% Advent of code 2022 - day 6 - part 1+2
% Open file and take needed data
file_id = fopen("day6.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We have a long string and need to find the first marker (4
% distinct characters in a row)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Go through strings
for i = 1:length(data{1,1})
    str = data{1,1}{i,1};
    % Go through the whole string (start at position 4)
    for j = 4:length(str)
        % Check if we have four unique characters
        tmp = unique(str(j-3:j));
        if (length(tmp)==4)
            result1 = j;
            break
        end
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Same but now we need to find the first start-of-message marker
% (14 distinct characters in a row)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
% Go through strings
for i = 1:length(data{1,1})
    str = data{1,1}{i,1};
    % Go through the whole string (start at position 14)
    for j = 14:length(str)
        % Check if we have fourteen unique characters
        tmp = unique(str(j-13:j));
        if (length(tmp)==14)
            result2 = j;
            break
        end
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc

