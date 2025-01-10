clc; clearvars;
% Advent of code 2024 - day 19 - part 1+2
% Open file and take needed data
file_id = fopen("day19.dat");
data = textscan(file_id,strcat('%s'),'Delimiter',',');
% Close file
fclose(file_id);

% Reorganize data
designs = data{1,1};

% Desired patterns
% Open file and take needed data
file_id = fopen("day19_2.dat");
data2 = textscan(file_id,strcat('%s'),'Delimiter',',');
% Close file
fclose(file_id);

patterns = data2{1,1};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find all possible patterns with the designs we have
% available
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0; 
idx = [];
% Calculate the length of the longest towel design
max_i = max(cellfun('size',designs,2));
% We go through each pattern
for i = 1:length(patterns(:,1))
    % Current pattern
    pat = patterns{i};
    % Check if we can assemble it from our designs
    [matched] = matchPatterns(pat,designs,max_i);
    result1 = result1 + matched;
    % Here we can already store idexes without a result for part 2
    if (matched == 0)
        idx(end+1) = i;
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need all the possible patterns we can do for each
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 
% We go through each pattern
for i = 1:length(patterns(:,1))
    if (any(idx == i))
    else
        % Current pattern
        pat = patterns{i};
        cache = [];
        % Check in how many ways we can assemble it from our designs
        [matched,cache] = matchPatterns2(pat,designs,cache,max_i);
        result2 = result2 + matched;
    end
end

% 692575723305545
fprintf('%10f',result2)
fprintf('\n')
toc

% For a given pattern check with all available designs if we can match it
% We need memoization here
function [matched] = matchPatterns(pat,designs,max_i)
    % Initialize
    matched = 0; 
    % Go through pattern
    for i = 1:min(max_i,length(pat))
        % Match with regexp
        tmp = regexp(pat(1:i),strcat('^',designs,'$'));
        % Get all matching design indexes
        ok = [];
        for j = 1:length(tmp(:,1))
            if (~isempty(tmp{j}))
                ok = j;
                % Check here if we got a complete match
                if (length(pat) == length(designs{j}))
                    matched = 1;
                    return
                end
            end
        end
        % Now if the found designs are not empty we cut the part from 
        % the pattern and go deeper
        if (~isempty(ok) && length(pat)>1)
            [matched] = matchPatterns(pat(i+1:end),designs,max_i);
            if (matched == 1)
                return
            end
        end
    end
end

% For a given pattern check with all available designs if we can match it
function [matched,cache] = matchPatterns2(pat,designs,cache,max_i)
    % Initialize
    matched = 0;
    % Before we continue, we check if we already have a matching pattern in
    % the cache
    if (~isempty(cache))
        % Compare our pattern with all cache entries
        for j = 1:length(cache(:,1))
            if (length(cache{j,1}) == length(pat))
                if (all(all(cache{j,1}==pat)))
                    matched = cache{j,2};
                    return
                end
            end
        end
    end
    % Go through pattern
    for i = 1:min(max_i,length(pat))
        % Match with regexp
        tmp = regexp(pat(1:i),strcat('^',designs,'$'));
        % Get all matching design indexes
        ok = [];
        for j = 1:length(tmp(:,1))
            if (~isempty(tmp{j}))
                ok = j;
                % Check here if we got a complete match
                if (length(pat) == length(designs{j}))
                    matched = matched+1;
                    break
                end
            end
        end
        % Now if the found designs are not empty we cut the part from 
        % the pattern and go deeper
        if (~isempty(ok) && length(pat(i:end))>1)
            [matched_tmp,cache] = matchPatterns2(pat(i+1:end),designs,cache,max_i);
            matched = matched + matched_tmp;
            % Store solution
            if (isempty(cache) == 1)
                cache{1,1} = pat(i+1:end);
                cache{1,2} = matched_tmp;
            else
                % Check if we have the entry already      
                store = 1;
                for j = 1:length(cache(:,1))
                    if (length(cache{j,1}) == length(pat(i+1:end)))
                        if (all(all(cache{j,1}==pat(i+1:end))))
                            store = 0;
                        end
                    end
                end
                if (store == 1)
                    cache{end+1,1} = pat(i+1:end);
                    cache{end,2} = matched_tmp;
                end
            end
        end
    end
end


