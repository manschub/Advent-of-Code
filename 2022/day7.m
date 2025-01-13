clc; clearvars;
% Advent of code 2022 - day 7 - part 1+2
% Open file and take needed data
file_id = fopen("day7.dat");
data = textscan(file_id,strcat('%s'),'Delimiter', '\t');
% Close file
fclose(file_id);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to calculate directory sizes and sum all the directory
% sizes that are smaller than 100000 for the result of part 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Depth 
depth = 0;
dir = '';
strcmp = '0':'9';
% Go through lines
for i = 1:length(data{1,1})
    % Get current line
    str = data{1,1}{i,1};
    if (str(3) == 'c' && str(4) == 'd' && str(6)~= '.')
        depth = depth+1;
        % Entering directory
        dir{end+1,1} = str(6:end);
        % Initialize size of dir
        dir{end,2} = 0;
        % Initialize included dirs
        dir{end,3} = '';
        % Include depth
        dir{end,4} = depth;
    elseif (str(3) == 'c' && str(4) == 'd' && str(6)== '.')
        % Go to higher lever directory
        depth = depth-1;
        % Add size to the higher dir
    elseif (any(strcmp(:)==str(1)))
        % We have a file and its size, so we add it to our current depth
        [~,c] = find(any(strcmp(:) == str));
        dir{end,2} = dir{end,2}+str2double(str(1:max(c)));
    elseif (str(1) == 'd' && str(2) == 'i' && str(3) == 'r')
        % Add directory names to our current dir to be included
        dir{end,3} = [dir{end,3},str(5:end),','];
    end
end
% Now we have all directories with their direct sizes and included dirs
% and we need to go again through them to get sizes of each individual
% directory
for i = length(dir(:,1)):-1:1
    % Check if the included directories are empty
    if (~isempty(dir{i,3}))
        % If not we add the sizes of those directories to our current dir
        % Get the single directories
        dir_tmp = regexp(dir{i,3},',','split');
        % Go through those directories (the last one is always empty)
        for j = 1:length(dir_tmp(1,:))-1
            % Find index of directory in our previous list (starting from
            % current index)
            for k = i+1:length(dir(:,1))
                % Only need to check dir names with same length
                if (length(dir{k,1}) == length(dir_tmp{1,j}))
                    % Then check if they are the same
                    if (all(dir{k,1} == dir_tmp{1,j}) && dir{k,4}-dir{i,4} == 1)
                        dir{i,2} = dir{i,2}+dir{k,2};
                        break
                    end
                end
            end
        end
    end
end
% Now we just go through it to get the result (all dirs summed that are
% smaller in size than 100k)
result1 = 0;
for i = 1:length(dir(:,1))
    % Check if the included directories are empty
    if (dir{i,2} < 1e5)
        result1 = result1+dir{i,2};
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now our file system has a total storage of 70000000 and we need 
% 30000000 free space. We need to find the smallest directory that by 
% deletion yields us the needed space.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 

% First we need to get the current free space
current_free = 7e7-dir{1,2};
% Now we calculate how much we need to remove to get the desired free space
needed = 3e7-current_free;

% Now we need to get all the directories that through their deletion would
% give us the desired space
dir_pot_size = [];
for i = 1:length(dir(:,1))
    % Check if the included directories are empty
    if (dir{i,2} > needed)
        dir_pot_size(end+1) = dir{i,2};
    end
end
% The result is the minimum of the collected sizes
result2 = min(dir_pot_size);
fprintf('%10f',result2)
fprintf('\n')
toc

