clc; clear all;
% Advent of code 2023 - day 14 - part 1+2
% Open file and take needed data
file_id = fopen("day14.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);
strings = [];
% Rearrange data to be handled nicer
for i = 1:length(data{1,1})
    strings = [strings;data{1,1}{i,1}];
end
strings_origin = strings;

% Positions of all round and cube-shaped rocks
[round_row,round_col] = find(strings == 'O');
[cube_row,cube_col] = find(strings == '#');

tic
result_part1 = 0;
% Now tilt the platform to move all round rocks as far to the top as
% possible - Let's go through the columns
for i = 1:length(strings(1,:))
    % Now go through rows
    highest = 1;
    for j = 1:length(strings(:,1))
        % Check if we have a rock in the highest row
        if (j == highest && (strings(j,i) == 'O' || strings(j,i) == '#'))
            % Nothing to do in this row and we shift the highest position
            highest = highest+1;
            % Check if we have a cube-shaped rock in the current row that 
            % is not the highest - we increment highest possible position
        elseif (strings(j,i) == '#')
            % Check if we have a round rock in the current row that 
            % is not the highest - we shift it to the highest
            highest = j+1;
        elseif (strings(j,i) == 'O')
            strings(highest,i) = 'O';
            strings(j,i) = '.';
            highest = highest+1;
        end
    end
    % Now go through rows again to count results
    weight = length(strings(:,1));
    for j = 1:length(strings(:,1))
        if (strings(j,i) == 'O')
            result_part1 = result_part1+(weight-j+1);
        end
    end
end
fprintf('%10f',result_part1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Part 2 - tilt north, west, south, east
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result_part2 = 0;
strings = strings_origin;
% Now tilt the platform in cycles to move all round rocks
for cycle = 1:1000000000
    % North
    for i = 1:length(strings(1,:))
        % Now go through rows
        northest = 1;
        for j = 1:length(strings(:,1))
            % Check if we have a rock in the northest row
            if (j == northest && (strings(j,i) == 'O' || strings(j,i) == '#'))
                % Nothing to do in this row and we shift the northest position
                northest = northest+1;
                % Check if we have a cube-shaped rock in the current row that 
                % is not the northest - we increment northest possible position
            elseif (strings(j,i) == '#')
                % Check if we have a round rock in the current row that 
                % is not the northest - we shift it to the northest
                northest = j+1;
            elseif (strings(j,i) == 'O')
                strings(northest,i) = 'O';
                strings(j,i) = '.';
                northest = northest+1;
            end
        end
    end
    % West - we need to go first rows then columns
    for i = 1:length(strings(:,1))
        % Now go through columns
        westest = 1;
        for j = 1:length(strings(1,:))
            % Check if we have a rock in the northest row
            if (j == westest && (strings(i,j) == 'O' || strings(i,j) == '#'))
                % Nothing to do in this row and we shift the westest position
                westest = westest+1;
                % Check if we have a cube-shaped rock in the current row that 
                % is not the westest - we increment westest possible position
            elseif (strings(i,j) == '#')
                % Check if we have a round rock in the current row that 
                % is not the westest - we shift it to the westest
                westest = j+1;
            elseif (strings(i,j) == 'O')
                strings(i,westest) = 'O';
                strings(i,j) = '.';
                westest = westest+1;
            end
        end
    end
    % South - we have to go from bottom to top row
    for i = 1:length(strings(1,:))
        % Now go through rows
        southest = length(strings(:,1));
        for j = length(strings(:,1)):-1:1
            % Check if we have a rock in the southest row
            if (j == southest && (strings(j,i) == 'O' || strings(j,i) == '#'))
                % Nothing to do in this row and we shift the southest position
                southest = southest-1;
                % Check if we have a cube-shaped rock in the current row that 
                % is not the southest - we increment southest possible position
            elseif (strings(j,i) == '#')
                % Check if we have a round rock in the current row that 
                % is not the southest - we shift it to the southest
                southest = j-1;
            elseif (strings(j,i) == 'O')
                strings(southest,i) = 'O';
                strings(j,i) = '.';
                southest = southest-1;
            end
        end
    end
    % East - we have to first through rows then columns and go backwards
    % through columns 
    for i = 1:length(strings(:,1))
        % Now go through columns
        eastest = length(strings(1,:));
        for j = length(strings(1,:)):-1:1
            % Check if we have a rock in the northest row
            if (j == eastest && (strings(i,j) == 'O' || strings(i,j) == '#'))
                % Nothing to do in this row and we shift the eastest position
                eastest = eastest-1;
                % Check if we have a cube-shaped rock in the current row that 
                % is not the eastest - we increment eastest possible position
            elseif (strings(i,j) == '#')
                % Check if we have a round rock in the current row that 
                % is not the eastest - we shift it to the eastest
                eastest = j-1;
            elseif (strings(i,j) == 'O')
                strings(i,eastest) = 'O';
                strings(i,j) = '.';
                eastest = eastest-1;
            end
        end
    end
    % Positions of all round rocks
    [round_row,round_col] = find(strings == 'O');
    if (cycle == 1000000000)
        % Count results
        for i = 1:length(strings(1,:))
            weight = length(strings(:,1));
            for j = 1:length(strings(:,1))
                if (strings(j,i) == 'O')
                    result_part2 = result_part2+(weight-j+1);
                end
            end
        end
        break
    end
    strings_old{1,cycle} = strings;
    % We need to check now if we have repetitions
    cnt_repetitions = 0;
    for k = cycle-1:-1:1
        if (all(all(strings_old{1,cycle} == strings_old{1,k})))
            cnt_repetitions = cnt_repetitions+1;
            if (cnt_repetitions == 1)
                cycle3 = k;
            elseif (cnt_repetitions == 2)
                cycle2 = k;
            elseif (cnt_repetitions == 3)
                cycle1 = k;
            end
        end
    end
    if (cnt_repetitions == 3)
        break
    end
end
% Now we can calculate the string that needs to be checked for load from
% the repetitions and the initial shift
frequency = cycle3 - cycle2;
i = 1;
cycle_tmp = 0;
while (cycle_tmp < 1000000000)
    cycle_tmp = cycle+i*frequency;
    i = i+1;
end
rest = cycle_tmp - 1000000000;
id_to_be_checked = cycle - rest;
result_part2 = 0;
% Now calculate load for according string
for i = 1:length(strings(1,:))
    weight = length(strings(:,1));
    for j = 1:length(strings(:,1))
        if (strings_old{1,id_to_be_checked}(j,i) == 'O')
            result_part2 = result_part2+(weight-j+1);
        end
    end
end

fprintf('%10f',result_part2)
fprintf('\n')
toc

