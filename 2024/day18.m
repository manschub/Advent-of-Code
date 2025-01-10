clc; clearvars;
% Advent of code 2024 - day 18 - part 1+2
% Open file and take needed data
file_id = fopen("day18.dat");
data = textscan(file_id,strcat('%f %f'),'Delimiter',',');
% Close file
fclose(file_id);

% Reorganize data (+1 as we start from 1,1 not 0,0 as in AOC)
bytes = [data{1,1},data{1,2}]+1;
% map(1:7,1:7) = '.';
map(1:71,1:71) = '.';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find the shortest path again
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Simulate the first 1024 bytes falling
for i = 1:1024
    map(bytes(i,2),bytes(i,1)) = '#';
end

start = [1,1];
% fin = [7,7];
fin = [71,71];

% We need to find the shortest path
% Try breadth-first
[result1,cache,map_tmp,finished] = splitpath(map,start,fin);

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - We do the same, but from 1024 bytes onwards to see at which
% point no path is possible anymore
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 

start = [1,1];
fin = [71,71];

% Take the same map and simulate more bytes falling - use binary search to
% make it quicker
halt = 0; 
idx_start = 1024+1; 
idx_fin = length(bytes(:,1));
% Keep initial 1024 map
map_tmp = map;
while (halt == 0)
    step = floor((idx_fin-idx_start)/2)+idx_start;
    map = map_tmp;
    % Fill map
    for i = 1025:step
        map(bytes(i,2),bytes(i,1)) = '#';
    end
    % We need to find the shortest path
    % Try breadth-first
    [~,~,~,finished] = splitpath(map,start,fin);
    if (finished == 0)
        if (idx_fin-idx_start <= 1)
            i = idx_start;
            break
        else
            idx_fin = step;
        end
    elseif (idx_fin-idx_start <= 1)
        i = idx_fin;
        break
    else
        idx_start = step;
    end
end

fprintf('%s',strcat(num2str(bytes(i,1)-1),',',num2str(bytes(i,2)-1)))
fprintf('\n')
toc


% Function to follow and split paths according to the rules
function [lowest,cache,map,finished] = splitpath(map,start,fin)
    % Breadth-first search
    cache = []; 
    lowest = 0;
    finished = 0;
    % I need to store current direction, current position in row and
    % column, and current weight (we start with the first possible 2 moves
    % facing east or south and moving from the start position)
    if (map(start(1),start(2)+1)=='.')
        todo(1,1:4) = [2,start(1),start(2)+1,1];
    end
    if (map(start(1)+1,start(2))=='.')
        todo(2,1:4) = [3,start(1)+1,start(2),1];
    end
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
            finished = 1;
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
        % Now we split our path (we can always go in each of the four
        % directions that are within the map and not blocked by #)
        dirs = []; rows = []; cols = []; weight = [];
        % North
        if (row>1)
            if (map(row-1,col) == '.')
                % Facing North
                dirs(1) = 1; 
                rows(1) = row-1; cols(1) = col;
                weight(1) = weight_ini+1;
            end
        end
        % East
        if (col<length(map(1,:)))
            if (map(row,col+1) == '.')
                % Facing East
                dirs(2) = 2; 
                rows(2) = row; cols(2) = col+1;
                weight(2) = weight_ini+1;
            end
        end
        % South
        if (row<length(map(:,1)))
            if (map(row+1,col) == '.')
                % Facing South
                dirs(3) = 1; 
                rows(3) = row+1; cols(3) = col;
                weight(3) = weight_ini+1;
            end
        end
        % West
        if (col>1)
            if (map(row,col-1) == '.')
                % Facing West
                dirs(4) = 1; 
                rows(4) = row; cols(4) = col-1;
                weight(4) = weight_ini+1;
            end
        end
        % Check if we have the exact "tasks" already
        for i=1:length(rows)
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
    end
end


