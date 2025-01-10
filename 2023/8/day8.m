clc; clear all;
% Advent of code 2023 - day 8 - part 1+2

% Open file and take needed data
file_id = fopen("day8.dat");

% Save right and left instructions
instructions = textscan(file_id,'%s',1,'delimiter','\n');
% Read the rest of the data 
data = textscan(file_id,'%s %s %s', ... 
    'HeaderLines',1,'delimiter',' =(),','MultipleDelimsAsOne',1);

% Close file
fclose(file_id);

% Rearrange instruction data
instructions = instructions{1,1}{1,1};
% Repeat it 128 times so we are sure we have enough instructions
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
% Save the rest in seperate arrays
start = cell2mat(data{1,1});
left = cell2mat(data{1,2});
right = cell2mat(data{1,3});

% Start loop to go through the instructions and break loop once we reach
% ZZZ
for i = 1:length(instructions)
    % In the first step we start at AAA
    if (i==1)
        loc = find(start(:,1)=='A'&start(:,2)=='A'&start(:,3)=='A');
    else
        loc = find(start(:,1)==string_tmp(1)&start(:,2)== ...
            string_tmp(2)&start(:,3)==string_tmp(3));
    end
    % Find string according to left right rules
    if (instructions(i) == 'L')
        % Take left string
        string_tmp = left(loc,:);
    elseif (instructions(i) == 'R')
        % Take right string
        string_tmp = right(loc,:);
    end
    % Now check if we reached ZZZ and leave if so
    if (string_tmp == 'ZZZ')
        break
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We have to go through all strings ending on A simultaneously and stop
% once all end in Z
% Repeat instructions even more times so we are sure we have enough 
% instructions
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
instructions = strcat(instructions,instructions);
% First we need to get all starting points
locs = find(start(:,3)=='A');
strings_tmp = start(locs,:);
% We assume that each of those reach a string with Z in the end with a
% specific frequency, so we do it one by one and multiply the frequencies
% together
for j = 1:length(strings_tmp)
    k = 0; i = 0;
    while (k<2)
        i=i+1;
        % In the first step we start at our strings_tmp values
        if (i==1)
        else
            locs(j) = find(start(:,1)==strings_tmp(j,1)&start(:,2)== ...
                strings_tmp(j,2)&start(:,3)==strings_tmp(j,3));
        end
        % Find string according to left right rules
        if (instructions(i) == 'L')
            % Take left string
            strings_tmp(j,:) = left(locs(j),:);
        elseif (instructions(i) == 'R')
            % Take right string
            strings_tmp(j,:) = right(locs(j),:);
        end
        % Now check if we have Z at all string ends and leave if so
        if (strings_tmp(j,3) == 'Z')
            iterations(j+k*6) = i;
            k = k+1;
        end
        if (mod(i,1000000)==0)
            i/length(instructions)
        end
    end
end

% We need to find the least common multiplier of the end nodes
answer_part2 = lcm(iterations(1),iterations(2));
answer_part2 = lcm(answer_part2,iterations(3));
answer_part2 = lcm(answer_part2,iterations(4));
answer_part2 = lcm(answer_part2,iterations(5));
answer_part2 = lcm(answer_part2,iterations(6));


% 89886323
%  'HGD'
%     'CHF'
%     'MRF'
%     'NFX'
%     'JNS'
%     'DTK'

%     290792215
