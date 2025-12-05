clc; clearvars;
% Advent of code 2025 - day 3 - part 1+2
% Open file and take needed data
file_id = fopen("day3.dat");
data = textscan(file_id,strcat('%s'),'delimiter',', ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Rearrange data
data = data{1,1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Search largest joltage combining two batteries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

result1 = 0;
% We loop through the strings (Battery ranks)
for i = 1:size(data,1)
    % In each battery rank we need to check all combinations
    bank = reshape(data{i,1}-'0',1,[]);
    % Initialize max joltage
    max_joltage = 0;
    for j = 1:length(bank)
        for k = j+1:length(bank)
            % Get combined joltage
            jolt = bank(j)*10+bank(k);
            if (jolt > max_joltage)
                max_joltage = jolt;
            end
        end
    end
    result1 = result1 + max_joltage;
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now combine 12 batteries - we need different approach as part 1
% version would take way too long - Recursive could work
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

result2 = 0;
% We loop through the strings (Battery ranks)
for i = 1:size(data,1)
    % In each battery rank we need to check all combinations
    bank = reshape(data{i,1}-'0',1,[]);
    % Go recursively through the bank each time splitting between
    % "accepting" the value and not accepting the value
    cache = [];
    [max_joltage,~] = ChooseBattery(bank,0,1,1,cache);
    result2 = result2 + max_joltage;
end

fprintf('%10f',result2)
fprintf('\n')
toc

% Function to split battery selection
function [joltage_out,cache] = ChooseBattery(bank,joltage_in,col,level,cache)
    % Breadth-first search
    joltage = joltage_in*10+bank(col);
    % Fill cache
    cache(end+1,1:3) = [joltage,col,level];
    % Split between choosing the battery or go to next one
    % Go to next one if we are not at the end
    if (col+1 < length(bank)-(11-level))
        [joltage_out,cache] = ChooseBattery(bank,joltage_in,col+1,level,cache);
    end 
    % Check cache if we are already doomed to a worse result
    if (~isempty(cache))
        cache_tmp = cache(cache(:,3) == level,:);
        if (~isempty(cache_tmp))
            if (max(cache_tmp(:,1))>joltage_in && max(cache_tmp(:,1))>joltage)
                joltage_out = max(cache(:,1));
                return 
            % Do we have the same value?
            elseif (max(cache_tmp(:,1))==joltage)
                % Check if we are at an earlier column
                if (min(cache(cache(:,1)==max(cache_tmp(:,1)),2)) < col)
                    joltage_out = max(cache(:,1));
                    return 
                end
            end
        end
    end
    % If we are at the 12th level our options are checking combined sum or
    % going one column further
    if (level == 12)
        joltage_out = joltage_in*10+bank(col);
        return
    else
        % Take the value and go one battery "deeper"
        joltage = joltage_in*10+bank(col);
        [joltage_out,cache] = ChooseBattery(bank,joltage,col+1,level+1,cache);
    end
end