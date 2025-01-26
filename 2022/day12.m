clc; clearvars;
% Advent of code 2022 - day 12 - part 1+2
% Open file and take needed data
file_id = fopen("day12.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Rearrange data
for i = 1:length(data{1,1})
    map(i,:) = data{1,1}{i,1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - we have a map with elevations (a-z) and need to find the
% shortest path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% First get start and end positions
[s(1),s(2)] = find(map=='S');
[e(1),e(2)] = find(map=='E');

% Now find shortest path
cache = [];
[lowest,~] = findPath(map,cache,s,e);

result1 = lowest;

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - The same, but now we need to find the shortest path for all
% possible starting positions (a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 

% First get all possible start and the end position
[r,c] = find(map=='S'); 
map(r,c) = 'a';
[s_r,s_c] = find(map=='a');
s = [s_r,s_c];
[e(1),e(2)] = find(map=='E');

cache = [];
% Now find shortest path for each starting position
for i = 1:length(s(:,1))
    [lowest(i),cache] = findPath(map,cache,s(i,:),e);
end

result2 = min(lowest(lowest>0));

fprintf('%10f',result2)
fprintf('\n')
toc


% Function to follow the hill climbing rules
function [lowest,cache] = findPath(map,cache,s,e)
    % Breadth-first search
    lowest = 0;
    % Set start and end to a and z 
    map(s(1),s(2)) = 'a';
    map(e(1),e(2)) = 'z';
    % I need to store current direction, current position in row and
    % column, and current weight (we start with the first possible moves
    % facing east and moving from the start position)
    todo(1,1:3) = [s(1),s(2),0];
    % We need to do the whole thing breadth first
    while (~isempty(todo))
        row = todo(1,1);
        col = todo(1,2);
        weight_ini = todo(1,3);
        % Check if we reached the end
        if (row==e(1) && col==e(2))
            % See if our solution is better than the previous lowest score
            if (lowest == 0 || todo(1,3) < lowest)
                lowest = todo(1,3);
            end
            % End of this path - go back
            todo = todo(2:end,:);
            continue
        end
        % At this point we need to fill our cache 
        if (isempty(cache))
            cache(1,1:3) = [row,col,weight_ini];
        else
            % We need to check if we already crossed this field from the 
            % same direction and if the weight is higher than the one in our 
            % cache then we can cancel the path here. If it is smaller we can 
            % replace the weight of the cache entry
            [loc,~] = find(cache(:,1) == row & cache(:,2) == col);
            if (~isempty(loc))
                % We already crossed this tile with the same direction and a 
                % smaller weight so we can stop
                if (cache(loc,3) < weight_ini) 
                    todo = todo(2:end,:);
                    continue
                elseif (weight_ini <= cache(loc,3))
                    % We found a path over the same tile with the same 
                    % direction which is cheaper - store it 
                    cache(loc,3) = weight_ini;
                end 
            else
                cache(end+1,1:3) = [row,col,weight_ini];
            end
        end
        % Now we split our path (we can take all directions that have a
        % lower, equal or higher (by 1) elevation)
        % Check all possible directions
        % Up
        if (row>1)
            if (double(map(row-1,col))-double(map(row,col)) < 2)
                % Add to todo list
                todo(end+1,1:3) = [row-1,col,weight_ini+1];
            end
        end
        % Right
        if (col<length(map(1,:)))
            if (double(map(row,col+1))-double(map(row,col)) < 2)
                % Add to todo list
                todo(end+1,1:3) = [row,col+1,weight_ini+1];
            end
        end
        % Down
        if (row<length(map(:,1)))
            if (double(map(row+1,col))-double(map(row,col)) < 2)
                % Add to todo list
                todo(end+1,1:3) = [row+1,col,weight_ini+1];
            end
        end
        % Left
        if (col>1)
            if (double(map(row,col-1))-double(map(row,col)) < 2)
                % Add to todo list
                todo(end+1,1:3) = [row,col-1,weight_ini+1];
            end
        end
        todo = todo(2:end,:);
        % Sort rows to prioritize lower weighted routes
        todo = unique(todo,'rows');
        todo = sortrows(todo,3);
    end
end




