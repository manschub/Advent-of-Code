clc; clearvars;
% Advent of code 2024 - day 16 - part 1+2
% Open file and take needed data
file_id = fopen("day16.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
[x,y] = size(data{1,1});
for i = 1:x
    map(i,:) = data{1,1}{i,1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find the shortest reindeer path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Get start and end position
[start(1),start(2)] = find(map=='S');
[fin(1),fin(2)] = find(map=='E');

% Now we have to go through the path - let's try beadth-first search
[lowest,cache] = splitpath(map,start,fin);
result1 = lowest;

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - We need to find the number tiles within any optimal path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Now we need depth-first and use the cache from part 1
[lowest,map] = splitpath2(map,[2,start(1),start(2),0],fin,cache);
result2 = sum(sum(map=='O'));

fprintf('%10f',result2)
fprintf('\n')
toc

% Function to follow and split paths according to the rules
function [lowest,cache] = splitpath(map,start,fin)
    % Breadth-first search
    cache = []; 
    lowest = 0;
    % I need to store current direction, current position in row and
    % column, and current weight (we start with the first possible moves
    % facing east and moving from the start position)
    todo(1,1:4) = [2,start(1),start(2),0];
    % We need to do the whole thing breadth first
    while (~isempty(todo))
        row = todo(1,2);
        col = todo(1,3);
        dir_ini = todo(1,1);
        weight_ini = todo(1,4);
        % Check if we reached the end
        if (row==fin(1) && col==fin(2))
            % See if our solution is better than the previous lowest score
            if (lowest == 0 || todo(1,4) < lowest)
                lowest = todo(1,4);
            end
            % End of this path - go back
            todo = todo(2:end,:);
            continue
        end
        % At this point we need to fill our cache 
        if (isempty(cache))
            cache(1,1:4) = [dir_ini,row,col,weight_ini];
        else
            % We need to check if we already crossed this field from the 
            % same direction and if the weight is higher than the one in our 
            % cache then we can cancel the path here. If it is smaller we can 
            % replace the weight of the cache entry
            [loc,~] = find(cache(:,1) == dir_ini & cache(:,2) == ...
                row & cache(:,3) == col);
            if (~isempty(loc))
                % We already crossed this tile with the same direction and a 
                % smaller weight so we can stop
                if (cache(loc,4) < weight_ini) 
                    todo = todo(2:end,:);
                    continue
                elseif (weight_ini <= cache(loc,4))
                    % We found a path over the same tile with the same 
                    % direction which is cheaper - store it 
                    cache(loc,4) = weight_ini;
                end 
            else
                cache(end+1,1:4) = [dir_ini,row,col,weight_ini];
            end
        end
        % Now we split our path (we can always go forwards or turn
        % clockwise or counter-clockwise
        dirs = []; rows = []; cols = []; weight = [];
        if (dir_ini==1)
            % Facing North
            % Forwards if possible
            if (map(row-1,col)~='#')
                dirs(1) = dir_ini; 
                rows(1) = row-1; cols(1) = col;
                weight(1) = weight_ini+1;
            end
            % Turn clockwise
            dirs(2) = 2; 
            rows(2) = row; cols(2) = col;
            weight(2) = weight_ini+1000;
            % Turn counter-clockwise
            dirs(3) = 4; 
            rows(3) = row; cols(3) = col;
            weight(3) = weight_ini+1000;
        elseif (dir_ini==2)
            % Facing East
            % Forwards if possible
            if (map(row,col+1)~='#')
                dirs(1) = dir_ini; 
                rows(1) = row; cols(1) = col+1;
                weight(1) = weight_ini+1;
            end
            % Turn clockwise
            dirs(2) = 3; 
            rows(2) = row; cols(2) = col;
            weight(2) = weight_ini+1000;
            % Turn counter-clockwise
            dirs(3) = 1; 
            rows(3) = row; cols(3) = col;
            weight(3) = weight_ini+1000;
        elseif (dir_ini==3)
            % Facing South
            % Forwards if possible
            if (map(row+1,col)~='#')
                dirs(1) = dir_ini; 
                rows(1) = row+1; cols(1) = col;
                weight(1) = weight_ini+1;
            end
            % Turn clockwise
            dirs(2) = 4; 
            rows(2) = row; cols(2) = col;
            weight(2) = weight_ini+1000;
            % Turn counter-clockwise
            dirs(3) = 2; 
            rows(3) = row; cols(3) = col;
            weight(3) = weight_ini+1000;
        else
            % Facing West
            % Forwards if possible
            if (map(row,col-1)~='#')
                dirs(1) = dir_ini; 
                rows(1) = row; cols(1) = col-1;
                weight(1) = weight_ini+1;
            end
            % Turn clockwise
            dirs(2) = 1; 
            rows(2) = row; cols(2) = col;
            weight(2) = weight_ini+1000;
            % Turn counter-clockwise
            dirs(3) = 3; 
            rows(3) = row; cols(3) = col;
            weight(3) = weight_ini+1000;
        end
        % Check if we have the exact "tasks" already
        for i=1:3
            % If entries are 0 we skip
            if (rows(i) == 0 || cols(i) == 0)
                continue
            end
            [loc2,~] = find(todo(:,1) == dirs(i) & todo(:,2) == ...
                rows(i) & todo(:,3) == cols(i) & todo(:,4) == weight(i),1);
            % If yes skip otherwise set task to end of todo list
            if (isempty(loc2))
                todo(end+1,1:4) = [dirs(i),rows(i),cols(i),weight(i)];
            end
        end
        todo = todo(2:end,:);
        % Sort rows to prioritize lower weighted routes
        todo = sortrows(todo,4);
    end
end

% Function to follow and split paths according to the rules
function [lowest,map] = splitpath2(map,todo,fin,cache)
    % For part 2 we need depth-first, but with the cache we have from part
    % 1
    lowest = 0;
    % Initialize
    row = todo(1,2);
    col = todo(1,3);
    dir_ini = todo(1,1);
    weight_ini = todo(1,4);
    % Check if we reached the end
    if (row==fin(1) && col==fin(2))
        % See if our solution is better than the previous lowest score
        if (lowest == 0 || todo(1,4) < lowest)
            map(row,col) = 'O';
            lowest = todo(1,4);
        end
        % End of this path - go back
        return
    end
    % At this point we check the cache from part 1
    % Check cache
    [loc,~] = find(cache(:,1) == dir_ini & cache(:,2) == ...
        row & cache(:,3) == col);
    if (~isempty(loc))
        % We already crossed this tile with the same direction and a 
        % smaller weight so we can stop
        if (cache(loc,4) < weight_ini) 
            return
        end 
    end
    % We split in our 3 different options
    % We can always go forwards or turn clockwise or counter-clockwise
    map(row,col) = 'O';
    if (dir_ini==1)
        % Facing North
        % Forwards if possible
        if (map(row-1,col)~='#')
            [lowest_tmp,map_tmp] = splitpath2(map, ...
                [dir_ini,row-1,col,weight_ini+1],fin,cache);
            if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
                lowest = lowest_tmp;
                map = map_tmp;
            end
        end
        % Turn clockwise
        [lowest_tmp,map_tmp] = splitpath2(map, ...
                [2,row,col,weight_ini+1000],fin,cache);
        if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest) ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest)
            lowest = lowest_tmp;
            map = map_tmp;
        end
        % Turn counter-clockwise
        [lowest_tmp,map_tmp] = splitpath2(map, ...
                [4,row,col,weight_ini+1000],fin,cache);
        if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
            lowest = lowest_tmp;
            map = map_tmp;
        end
    elseif (dir_ini==2)
        % Facing East
        % Forwards if possible
        if (map(row,col+1)~='#')
            [lowest_tmp,map_tmp] = splitpath2(map, ...
                [dir_ini,row,col+1,weight_ini+1],fin,cache);
            if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
                lowest = lowest_tmp;
                map = map_tmp;
            end
        end
        % Turn clockwise
        [lowest_tmp,map_tmp] = splitpath2(map, ...
                [3,row,col,weight_ini+1000],fin,cache);
        if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
            lowest = lowest_tmp;
            map = map_tmp;
        end
        % Turn counter-clockwise
        [lowest_tmp,map_tmp] = splitpath2(map, ...
                [1,row,col,weight_ini+1000],fin,cache);
        if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
            lowest = lowest_tmp;
            map = map_tmp;
        end
    elseif (dir_ini==3)
        % Facing South
        % Forwards if possible
        if (map(row+1,col)~='#')
            [lowest_tmp,map_tmp] = splitpath2(map, ...
                [dir_ini,row+1,col,weight_ini+1],fin,cache);
            if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
                lowest = lowest_tmp;
                map = map_tmp;
            end
        end
        % Turn clockwise
        [lowest_tmp,map_tmp] = splitpath2(map, ...
                [4,row,col,weight_ini+1000],fin,cache);
        if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
            lowest = lowest_tmp;
            map = map_tmp;
        end
        % Turn counter-clockwise
        [lowest_tmp,map_tmp] = splitpath2(map, ...
                [2,row,col,weight_ini+1000],fin,cache);
        if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
            lowest = lowest_tmp;
            map = map_tmp;
        end
    else
        % Facing West
        % Forwards if possible
        if (map(row,col-1)~='#')
            [lowest_tmp,map_tmp] = splitpath2(map, ...
                [dir_ini,row,col-1,weight_ini+1],fin,cache);
            if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
                lowest = lowest_tmp;
                map = map_tmp;
            end
        end
        % Turn clockwise
        [lowest_tmp,map_tmp] = splitpath2(map, ...
                [1,row,col,weight_ini+1000],fin,cache);
        if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
            lowest = lowest_tmp;
            map = map_tmp;
        end
        % Turn counter-clockwise
        [lowest_tmp,map_tmp] = splitpath2(map, ...
                [3,row,col,weight_ini+1000],fin,cache);
        if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                || lowest_tmp == lowest))
            lowest = lowest_tmp;
            map = map_tmp;
        end
    end
end


