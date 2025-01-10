clc; clear all;
% Advent of code 2023 - day 15 - part 1+2
% Open file and take needed data
file_id = fopen("day15.dat");
data = textscan(file_id,strcat('%s'),'delimiter',',','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Hash Algorithm:
% Determine the ASCII code for the current character of the string.
% Increase the current value by the ASCII code you just determined.
% Set the current value to itself multiplied by 17.
% Set the current value to the remainder of dividing itself by 256.

tic
% Run HASH algorithm for each set of sequences
for i = 1:length(data{1,1})
    value = 0;
    % Extract current string
    string = data{1,1}{i,1};
    % Algorithm repeats for each character
    for j = 1:length(string)
        % Step 1, 2, 3, and 4 of algorithm
        value = mod((value + double(char(string(j))))*17,256);
    end
    values(i) = value;
end

% Result part 1
result_part1 = sum(values);
fprintf('%10f',result_part1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Part 2 - Boxes with lenses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Generate amount of boxes equal to sequences
boxes{1,256} = '';
added = 0;
% We have to go through each sequence again
for i = 1:length(data{1,1})
    value = 0;
    % Extract current string
    string = data{1,1}{i,1};
    % Algorithm repeats for each character (only for label in part2)
    for j = 1:length(string)
        if (string(j) == '-' || string(j) == '=')
            break
        end
        % Step 1, 2, 3, and 4 of algorithm
        value = mod((value + double(char(string(j))))*17,256);
    end
    values(i) = value;
    % Our HASH algorithm determined the box we need to apply our sequence
    % too
    if (value == 0)
        value = 256;
    end
    if (string(end) == '-')
        % We have a dash and need to remove from the box
        % Go through box and check if we have the current label
        for j = 1:length(boxes{1,value})-(length(string)-1)
            if (all(boxes{1,value}(j:j+length(string)-1) == ...
                    strcat(',',string(1:end-1))) && ...
                    boxes{1,value}(j+length(string)-1+1) == ' ')
                % Remove the corresponding lens entry
                boxes{1,value} = [boxes{1,value}(1:j-1), ...
                    boxes{1,value}(j+length(string)+2:end)];
                break
            end
        end
    elseif (string(end-1) == '=')
        % We need to add to the box
        % Go through box and check if we have the current label
        for j = 1:length(boxes{1,value})-(length(string)-2)
            if (all(boxes{1,value}(j:j+length(string)-2) == ...
                    strcat(',',string(1:end-2))))
                % Check if number is equal
                if (string(end) == boxes{1,value}(j+length(string)))
                    % Nothing to do
                else
                    % Change number
                    boxes{1,value}(j+length(string)) = string(end);
                end
                added = 1;
            end
        end
        if (added == 0)
            % We still have to add it to the box
            boxes{1,value} = [boxes{1,value},',', ...
                string(1:end-2),' ',string(end)];
        else
            added = 0;
        end
    end
end

% Result part 2 - We have to go through all boxes
i_lens = 0;
for i = 1:length(boxes)
    % Get box number
    if (i == 256)
        box_num = 0;
    else
        box_num = i;
    end
    % Get slot number and focal length pairs
    slot = 0;
    for j = 1:length(boxes{1,i})
        if (boxes{1,i}(j) == ',')
            slot = slot+1; i_lens = i_lens+1;
        elseif (boxes{1,i}(j) == '1' || boxes{1,i}(j) == '2' || ...
                boxes{1,i}(j) == '3' || boxes{1,i}(j) == '4' || ...
                boxes{1,i}(j) == '5' || boxes{1,i}(j) == '6' || ...
                boxes{1,i}(j) == '7' || boxes{1,i}(j) == '8' || ...
                boxes{1,i}(j) == '9')
            % Result for current lens
            fl = str2double(boxes{1,i}(j));
            values2(i_lens) = (box_num+1) * slot * fl; 
        end
    end
end

result_part2 = sum(values2);
fprintf('%10f',result_part2)
fprintf('\n')
toc
