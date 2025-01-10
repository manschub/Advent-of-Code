clc; clear all;
% Advent of code 2023 - day 17 - part 1+2
% Open file and take needed data
file_id = fopen("day17.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);
strings = [];
% Rearrange data to be handled nicer
for i = 1:length(data{1,1})
    strings = [strings;data{1,1}{i,1}];
end
% First part
tic
% We can either turn right, left or go straight for a maximum of 3 steps
% and we need to find the most efficient path through the city with the 
% least cumulative heat loss - we need to do a breadth-first search 
% with cache
[lowest] = splitpaths(strings);
result_part1 = lowest;
fprintf('%10f',result_part1)
fprintf('\n')
toc
% Second part
tic
% We can either turn right, left or go straight for a maximum of 10 but
% at least 4 steps and we need to find the most efficient path through 
% the city with the least cumulative heat loss - we adjust the part 1
% solution
[lowest] = splitpaths2(strings);
result_part2 = lowest;
fprintf('%10f',result_part2)
fprintf('\n')
toc

% Function to split the path in 3
function [lowest] = splitpaths2(strings)

    cache = [];
    lowest = 0;
    todo(1,1:6) = [1,1,1,0,0,0];
    % We need to do the whole thing breadth first
    while (~isempty(todo))
        % Initialize
        straight = [0,0]; first = [0,0]; sec = [0,0];
        % Position
        row = todo(1,1); col = todo(1,2);
        % Direction and weight
        cd_ini = todo(1,3); weight_ini = todo(1,4);
        % Straight steps done
        steps_straight = todo(1,5);
        
        % Check if we reached the end
        if (row == length(strings(:,1)) && col == length(strings(1,:)) ...
                && steps_straight >= 4)
            % See if our solution is better than the previously stored one
            if (lowest == 0 || weight_ini < lowest)
                lowest = weight_ini;
            end
            % End of this path - go back
            todo = todo(2:end,:);
            continue
        end
    
        % Increment straight steps
        steps_straight = steps_straight+1;
        
        % At this point we need to fill our cache 
        if (isempty(cache))
            cache(1,1) = cd_ini;
            cache(1,2) = weight_ini;
            cache(1,3) = row;
            cache(1,4) = col;
            cache(1,5) = steps_straight;
        else
            % Now we need to check if we already crossed this field from the 
            % same direction and if the weight is higher than the one in our 
            % cache then we can cancel the path here. If it is smaller we can 
            % replace the weight of the cache entry
            [loc,~] = find(cache(:,1) == cd_ini & cache(:,3) == ...
                row & cache(:,4) == col & cache(:,5) == steps_straight,1);
            if (~isempty(loc))
                % We already crossed this tile with the same direction and a 
                % smaller weight so we can stop
                if (cache(loc,2) < weight_ini) 
                    todo = todo(2:end,:);
                    continue
                elseif (weight_ini <= cache(loc,2))
                    % We found a path over the same tile with the same 
                    % direction which is cheaper - store it 
                    cache(loc,2) = weight_ini;
                end 
            else
                cache(end+1,1) = cd_ini;
                cache(end,2) = weight_ini;
                cache(end,3) = row;
                cache(end,4) = col;
                cache(end,5) = steps_straight;
            end
        end
        
        % Split depending on where we are
        if (cd_ini == 1)   % East
            if (col < length(strings(1,:)))
                straight = [row,col+1];
            end
            if (row < length(strings(:,1)))
                first = [row+1,col]; % South
            end
            if (row > 1)
                sec = [row-1,col]; % North
            end
        elseif (cd_ini == 2) % North
            if (row > 1)
                straight = [row-1,col];
            end
            if (col < length(strings(1,:)))
                first = [row,col+1]; % East
            end
            if (col > 1)
                sec = [row,col-1]; % West
            end
        elseif (cd_ini == 3) % West
            if (col > 1)
                straight = [row,col-1];
            end
            if (row < length(strings(:,1)))
                first = [row+1,col]; % South
            end
            if (row > 1)
                sec = [row-1,col]; % North
            end
        elseif (cd_ini == 4)   % South
            if (row < length(strings(:,1)))
                straight = [row+1,col];
            end
            if (col < length(strings(1,:)))
                first = [row,col+1]; % East
            end
            if (col > 1)
                sec = [row,col-1]; % West
            end
        end
        rows = [straight(1),first(1),sec(1)];
        cols = [straight(2),first(2),sec(2)];
        
        for i = 1:3
            if ((i == 1 && steps_straight == 11) || rows(i) == 0 || cols(i) == 0) 
                continue
            elseif (i == 2 && steps_straight < 5)
                % We have to go straight for at least 4 steps
                break
            else
                weight = weight_ini+str2double(strings(rows(i),cols(i)));
                % If our weight is bigger than the lowest we found we can
                % return as it's impossible to find a lower one this way
                if ((lowest > 0 && weight > lowest))
                    continue
                end
            end
            % Split again
            % Define current direction
            if (cd_ini == 1 && i == 1)
                cd = 1; % East
            elseif (cd_ini == 1 && i == 2)
                cd = 4; % South 
            elseif (cd_ini == 1 && i == 3)
                cd = 2; % North
            elseif (cd_ini == 3 && i == 1)
                cd = 3; % West
            elseif (cd_ini == 3 && i == 2)
                cd = 4; % South
            elseif (cd_ini == 3 && i == 3)
                cd = 2; % North
            elseif (cd_ini == 2 && i == 1)
                cd = 2; % North
            elseif (cd_ini == 2 && i == 2)
                cd = 1; % East
            elseif (cd_ini == 2 && i == 3)
                cd = 3; % West 
            elseif (cd_ini == 4 && i == 1)
                cd = 4; % South 
            elseif (cd_ini == 4 && i == 2)
                cd = 1; % East 
            elseif (cd_ini == 4 && i == 3)
                cd = 3; % West
            end
            if (i > 1)
                % We are doing a turn so put steps_straight back to 1
                steps_straight = 1;
            end
            % Check if we have the exact "task" already
            [loc2,~] = find(todo(:,1) == rows(i) & todo(:,2) == ...
                cols(i) & todo(:,3) == cd & todo(:,4) == weight & ...
                todo(:,5) == steps_straight,1);
            % If yes skip otherwise set task to end of todo list
            if (isempty(loc2))
                todo(end+1,1:6) = [rows(i),cols(i),cd,weight, ...
                    steps_straight,weight/(rows(i) + cols(i))];
            end
        end
        todo = todo(2:end,:);
        % Once in a while we need to get rid of some worse paths so we
        % sort the todos by weight per step and prune the lower 1000 tasks 
        % each time the length of todo is bigger than 5000
        if (length(todo(:,1)) >= 5000)
            todo = sortrows(todo,6,'ascend');
            todo = todo(1:4000,:);
        end
    end
end
% 734 is correct
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function to split the path in 3
function [lowest] = splitpaths(strings)

    cache = [];
    lowest = 0;
    todo(1,1:6) = [1,1,1,0,0,0];
    % We need to do the whole thing breadth first
    while (~isempty(todo))
        % Initialize
        straight = [0,0]; first = [0,0]; sec = [0,0];
        % Position
        row = todo(1,1); col = todo(1,2);
        % Direction and weight
        cd_ini = todo(1,3); weight_ini = todo(1,4);
        % Straight steps done
        steps_straight = todo(1,5);
        
        % Check if we reached the end
        if (row == length(strings(:,1)) && col == length(strings(1,:)))
            % See if our solution is better than the previously stored one
            if (lowest == 0 || weight_ini < lowest)
                lowest = weight_ini;
            end
            % End of this path - go back
            todo = todo(2:end,:);
            continue
        end
    
        % Increment straight steps
        steps_straight = steps_straight+1;
        
        % At this point we need to fill our cache 
        if (isempty(cache))
            cache(1,1) = cd_ini;
            cache(1,2) = weight_ini;
            cache(1,3) = row;
            cache(1,4) = col;
            cache(1,5) = steps_straight;
        else
            % Now we need to check if we already crossed this field from the 
            % same direction and if the weight is higher than the one in our 
            % cache then we can cancel the path here. If it is smaller we can 
            % replace the weight of the cache entry
            [loc,~] = find(cache(:,1) == cd_ini & cache(:,3) == ...
                row & cache(:,4) == col & cache(:,5) == steps_straight,1);
            if (~isempty(loc))
                % We already crossed this tile with the same direction and a 
                % smaller weight so we can stop
                if (cache(loc,2) < weight_ini) 
                    todo = todo(2:end,:);
                    continue
                elseif (weight_ini <= cache(loc,2))
                    % We found a path over the same tile with the same 
                    % direction which is cheaper - store it 
                    cache(loc,2) = weight_ini;
                end 
            else
                cache(end+1,1) = cd_ini;
                cache(end,2) = weight_ini;
                cache(end,3) = row;
                cache(end,4) = col;
                cache(end,5) = steps_straight;
            end
        end
        
        % Split depending on where we are
        if (cd_ini == 1)   % East
            if (col < length(strings(1,:)))
                straight = [row,col+1];
            end
            if (row < length(strings(:,1)))
                first = [row+1,col]; % South
            end
            if (row > 1)
                sec = [row-1,col]; % North
            end
        elseif (cd_ini == 2) % North
            if (row > 1)
                straight = [row-1,col];
            end
            if (col < length(strings(1,:)))
                first = [row,col+1]; % East
            end
            if (col > 1)
                sec = [row,col-1]; % West
            end
        elseif (cd_ini == 3) % West
            if (col > 1)
                straight = [row,col-1];
            end
            if (row < length(strings(:,1)))
                first = [row+1,col]; % South
            end
            if (row > 1)
                sec = [row-1,col]; % North
            end
        elseif (cd_ini == 4)   % South
            if (row < length(strings(:,1)))
                straight = [row+1,col];
            end
            if (col < length(strings(:,1)))
                first = [row,col+1]; % East
            end
            if (col > 1)
                sec = [row,col-1]; % West
            end
        end
        rows = [straight(1),first(1),sec(1)];
        cols = [straight(2),first(2),sec(2)];
        
        for i = 1:3
            if ((i == 1 && steps_straight == 4) || rows(i) == 0 || cols(i) == 0) 
                continue
            else
                weight = weight_ini+str2double(strings(rows(i),cols(i)));
                % If our weight is bigger than the lowest we found we can
                % return as it's impossible to find a lower one this way
                if ((lowest > 0 && weight > lowest))
                    continue
                end
            end
            % Split again
            % Define current direction
            if (cd_ini == 1 && i == 1)
                cd = 1; % East
            elseif (cd_ini == 1 && i == 2)
                cd = 4; % South 
            elseif (cd_ini == 1 && i == 3)
                cd = 2; % North
            elseif (cd_ini == 3 && i == 1)
                cd = 3; % West
            elseif (cd_ini == 3 && i == 2)
                cd = 4; % South
            elseif (cd_ini == 3 && i == 3)
                cd = 2; % North
            elseif (cd_ini == 2 && i == 1)
                cd = 2; % North
            elseif (cd_ini == 2 && i == 2)
                cd = 1; % East
            elseif (cd_ini == 2 && i == 3)
                cd = 3; % West 
            elseif (cd_ini == 4 && i == 1)
                cd = 4; % South 
            elseif (cd_ini == 4 && i == 2)
                cd = 1; % East 
            elseif (cd_ini == 4 && i == 3)
                cd = 3; % West
            end
            if (i > 1)
                % We are doing a turn so put steps_straight back to 1
                steps_straight = 1;
            end
            % Check if we have the exact "task" already
            [loc2,~] = find(todo(:,1) == rows(i) & todo(:,2) == ...
                cols(i) & todo(:,3) == cd & todo(:,4) == weight & ...
                todo(:,5) == steps_straight,1);
            % If yes skip otherwise set task to end of todo list
            if (isempty(loc2))
                todo(end+1,1:6) = [rows(i),cols(i),cd,weight, ...
                    steps_straight,weight/(rows(i) + cols(i))];
            end
        end
        todo = todo(2:end,:);
        % Once in a while we need to get rid of some worse paths so we
        % sort the todos by weight per step and prune the lower half 
        % each time the length of todo is bigger than 3000
        if (length(todo(:,1)) >= 3000)
            todo = sortrows(todo,6,'ascend');
            todo = todo(1:1500,:);
        end
    end
end
% 635 is correct

