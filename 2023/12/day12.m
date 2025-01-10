clc; clear all;
% Advent of code 2023 - day 12 - part 1+2
% operational (.) or damaged (#) or unknown (?)

% Open file and take needed data
file_id = fopen("day12.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
data_start = data;
% Close file
fclose(file_id);

part1 = 1;
if (part1 == 1)
    tic
    cnt_arrange1(1:length(data{1,1})) = 0;
    % We go through each row
    for i = 1:length(data{1,1}) 
        % Take current row
        string = data{1,1}{i,1};
        string_tmp = string;
        % For each row we have to figure out which different arrengements we
        % can have for the given data
        % Extract numbers
        [~,numbers_col] = find(string == '1' | string == '2' | ...
            string == '3' | string == '4' | string == '5' | string == '6' ...
            | string == '7' | string == '8' | string == '9');
        numbers = str2num(string(numbers_col(1):end));
        % We have to split at each ? and see what's possible from
        % there - recursion - solve with cache to save a lot of time        
        cache = [];
        [cnt_fitting,~] = splitandcheck(string,numbers,cache);
        cnt_arrange1(i) = cnt_fitting;
    end
    result_part1 = sum(cnt_arrange1);
    fprintf('%10f',result_part1)
    fprintf('\n')
    toc
end

% 7670

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
for i = 1:length(data{1,1})
    % Adjust current row
    % Find the space that seperate conditions and numbers
    [~,idx] = find(data_start{1,1}{i,1} == ' ');
    data_tmp{1,1}{i,1} = strcat(data_start{1,1}{i,1}(1:idx-1),'?', ...
        data_start{1,1}{i,1}(1:idx-1),'?', ...
        data_start{1,1}{i,1}(1:idx-1),'?', ...
        data_start{1,1}{i,1}(1:idx-1),'?', ...
        data_start{1,1}{i,1}(1:idx-1));
    data_tmp{1,1}{i,1} = strcat(data_tmp{1,1}{i,1},' ', ...
        data_start{1,1}{i,1}(idx+1:end),',', ...
        data_start{1,1}{i,1}(idx+1:end),',', ...
        data_start{1,1}{i,1}(idx+1:end),',', ...
        data_start{1,1}{i,1}(idx+1:end),',', ...
        data_start{1,1}{i,1}(idx+1:end));
end
clear data;
data = data_tmp;

cnt_arrange2(1:length(data{1,1})) = 0;

% We go through each row
for i = 1:length(data{1,1})
    % Take current row
    string = data{1,1}{i,1};
    string_tmp = string;
    % For each row we have to figure out which different arrengements we
    % can have for the given data
    % Extract numbers
    [~,numbers_col] = find(string == '1' | string == '2' | ...
        string == '3' | string == '4' | string == '5' | string == '6' ...
        | string == '7' | string == '8' | string == '9');
    numbers = str2num(string(numbers_col(1):end));
    % We have to split at each ? and see what's possible from
    % there - recursion - solve with cache to save a lot of time
    cache = [];
    [cnt_fitting,~] = splitandcheck(string,numbers,cache);
    cnt_arrange2(i) = cnt_fitting;
end

result_part2 = sum(cnt_arrange2);
fprintf('%20f',result_part2)
fprintf('\n')
toc

% 157383940585037

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Split at next ? and see if both branches are still valid
function [cnt_fitting,cache] = splitandcheck(combinations,numbers,cache)
    % Initialize  
    cnt_fitting = 0;
    duplicate = 0;
    stop1 = 0;
    % Prepare second part
    combinations2 = combinations;
    % Get position of next ? 
    [~,next] = find(combinations == '?',1);

    % Set first branch
    combinations(next) = '#';

    % Check if it is a valid option and if so split again at the next
    % We are done if no next ? is left
    if (isempty(next))
        % Check once again if all existing # work with the set of numbers?
        if (stop1 == 0)
            cnt_operational = 0; num_cnt_tmp = 1;
            for i = 1:length(combinations)
                if (combinations(i) == '#')
                    cnt_operational = cnt_operational+1;
                    if (num_cnt_tmp > length(numbers))
                        stop1 = 1;
                        break
                    elseif (cnt_operational > numbers(num_cnt_tmp)) 
                        stop1 = 1;
                        break
                    end
                elseif (cnt_operational > 0 && combinations(i) == '.')
                    if (cnt_operational < numbers(num_cnt_tmp))
                        stop1 = 1;
                        break
                    else
                        cnt_operational = 0;
                        num_cnt_tmp = num_cnt_tmp+1;
                    end
                end
            end
        end
        % Check once again if the number of # fits the numbers
        if (length(combinations(combinations=='#')) ~= sum(numbers))
            stop1 = 1;
        end
        if (stop1 == 0)
            cnt_fitting = cnt_fitting+1;
        end
        return
    end
    % First we need to determine current number (and directly check if we
    % have too many sets - Condition 1)
    num_cnt = 1; cnt_operational = 0;
    for i = 1:next
        if (combinations(i) == '?' || num_cnt == length(numbers))
            break
        elseif (combinations(i) == '#')
            cnt_operational = cnt_operational+1;
        elseif ((combinations(i) == '.' || combinations(i) == '?') && ...
                cnt_operational == numbers(num_cnt))
            num_cnt = num_cnt+1;
            cnt_operational = 0;
            % Check for too many sets of #
            if (num_cnt > length(numbers))
                stop1 = 1;
                break
            end
        end
    end
    % Condition 2: Are there enough # + ? left to account for all the numbers?
    if (next > 30 && stop1 == 0) 
        if ((length(combinations(combinations=='#')) + ...
                length(combinations(combinations=='?'))) < sum(numbers))
            stop1 = 1;
        end
    end
    % Condition 3: Are all existing # working with the set of numbers?
    % This includes checking for too many sets of #
    if (stop1 == 0)
        cnt_operational = 0; num_cnt_tmp = 1;
        for i = 1:next
            if (combinations(i) == '#')
                cnt_operational = cnt_operational+1;
                if (num_cnt_tmp > length(numbers))
                    stop1 = 1;
                    break
                elseif (cnt_operational > numbers(num_cnt_tmp)) 
                    stop1 = 1;
                    break
                end
            elseif (cnt_operational > 0 && combinations(i) == '.')
                if (cnt_operational < numbers(num_cnt_tmp))
                    stop1 = 1;
                    break
                else
                    cnt_operational = 0;
                    num_cnt_tmp = num_cnt_tmp+1;
                end
            end
        end
    end
    % Fill cache
    if (isempty(cache) && ~isempty(next))
        cache(1,1) = next;  % Current position in the string
        cache(1,2) = num_cnt-1; % Number of fully-matched sequences
        cache(1,3) = length(combinations(combinations(1:next)=='#')) - ...
            sum(numbers(1:num_cnt-1)); % Number of # in current sequence
        cache(1,4) = 0;     % Results for this setup
    elseif (~isempty(next))
        % Check now if we have the entry already
        [loc,~] = find(cache(:,1) == next & cache(:,2) == num_cnt-1 & ...
            cache(:,3) == (length(combinations(combinations(1:next)=='#')) - ...
            sum(numbers(1:num_cnt-1))));
        if (~isempty(loc))
            duplicate = 1;
        else 
            % We don't have a duplicate - store instead
            cache(end+1,1) = next;  % Current position in the string
            cache(end,2) = num_cnt-1; % Number of fully-matched sequences
            cache(end,3) = length(combinations(combinations(1:next)=='#')) - ...
                sum(numbers(1:num_cnt-1)); % Number of # in current sequence
            cache(end,4) = 0; % Results for this setup
        end
    end
    if (stop1 == 0)
        % Do we have a duplicate?
        if (duplicate == 1)
            cnt_fitting = cache(loc,4);
            return
        end
        % If all conditions are fine we continue to split
        [tmp,cache] = splitandcheck(combinations,numbers,cache);
        if (tmp > 0)
            % Fill the current entry of the cache with the current
            % fitting combinations
            [loc,~] = find(cache(:,1) == next & cache(:,2) == num_cnt-1 & ...
                cache(:,3) == (length(combinations(combinations(1:next)=='#')) - ...
                sum(numbers(1:num_cnt-1))));
            cache(loc,4) = cache(loc,4)+tmp;
        end
        cnt_fitting = cnt_fitting + tmp;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2nd part
    combinations2(next) = '.';
    % Check if it is a valid option and if so split again at the next
    stop2 = 0;

    % Condition 1: Are there enough # + ? left to account for all the numbers?
    if (next > 30) 
        if ((length(combinations2(combinations2=='#')) + ...
                length(combinations2(combinations2=='?'))) < sum(numbers))
            stop2 = 1;
        end
    end
    % Condition 2: Are all existing # working with the set of numbers?
    if (stop2 == 0)
        cnt_operational = 0; num_cnt_tmp = 1;
        for i = 1:next
            if (combinations2(i) == '#')
                cnt_operational = cnt_operational+1;
                if (num_cnt_tmp > length(numbers))
                    stop2 = 1;
                    break
                elseif (cnt_operational > numbers(num_cnt_tmp)) 
                    stop2 = 1;
                    break
                end
            elseif (cnt_operational > 0 && combinations2(i) == '.')
                if (cnt_operational < numbers(num_cnt_tmp))
                    stop2 = 1;
                    break
                else
                    cnt_operational = 0;
                    num_cnt_tmp = num_cnt_tmp+1;
                end
            end
        end
    end
    if (stop2 == 0)
        % Do we have a duplicate?
        if (duplicate == 1)
            cnt_fitting = cache(loc,4);
            return
        end
        % If all conditions are fine we continue to split
        [tmp,cache] = splitandcheck(combinations2,numbers,cache);
        if (tmp > 0)
            % Fill the current entry of the cache with the current
            % fitting combinations
            [loc,~] = find(cache(:,1) == next & cache(:,2) == num_cnt-1 & ...
                cache(:,3) == (length(combinations(combinations(1:next)=='#')) - ...
                sum(numbers(1:num_cnt-1))));
            cache(loc,4) = cache(loc,4)+tmp;
        end
        cnt_fitting = cnt_fitting + tmp;
    end
end
