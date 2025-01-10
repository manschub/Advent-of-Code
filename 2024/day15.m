clc; clearvars;
% Advent of code 2024 - day 15 - part 1+2
% Open file and take needed data
file_id = fopen("day15.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

file_id = fopen("day15_moves.dat");
data2 = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
[x,~] = size(data{1,1});
for i = 1:x
    map(i,:) = data{1,1}{i,1};
end
[x,~] = size(data2{1,1});
moves = '';
for i = 1:x
    moves = strcat(moves,data2{1,1}{i,1});
end
map_org = map;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to simulate the robot movements to get the final
% position of the boxes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% We need a loop for the movements of the robot
% Get the robots position in the beginning
[robo(1),robo(2)] = find(map=='@');

% Now go through moves
for i = 1:length(moves)
    % Make the next move
    [map,robo] = makemove(map,robo,moves(i));
end

% Get the result
result1 = 0;
[boxes(:,1),boxes(:,2)] = find(map=='O');
for i = 1:length(boxes(:,1))
    result1 = result1 + ((boxes(i,1)-1)*100 + boxes(i,2)-1);
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now everything in the map becomes twice as wide with trickier
% box movements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% First we need to enlarge the map accordingly
map2 = [map_org,map_org];
% Go through map and correct it
for i=1:length(map_org(:,1))
    for j=1:length(map_org(1,:))
        if (map_org(i,j)=='#')
            map2(i,2*j-1:2*j) = '##';
        elseif (map_org(i,j)=='.')
            map2(i,2*j-1:2*j) = '..';
        elseif (map_org(i,j)=='O')
            map2(i,2*j-1:2*j) = '[]';
        elseif (map_org(i,j)=='@')
            map2(i,2*j-1:2*j) = '@.';
        end
    end
end

% We need a loop for the movements of the robot
% Get the robots position in the beginning
[robo(1),robo(2)] = find(map2=='@');
% Now go through moves
for i = 1:length(moves)
    % Make the next move
    [map2,robo] = makemove2(map2,robo,moves(i));
end

% Get the result
result2 = 0;
[boxes2(:,1),boxes2(:,2)] = find(map2=='[');
for i = 1:length(boxes2(:,1))
    result2 = result2 + ((boxes2(i,1)-1)*100 + boxes2(i,2)-1);
end

fprintf('%10f',result2)
fprintf('\n')
toc



% Function for movement of roboter
function [map,robo] = makemove(map,robo,move)
    % Check direction
    if (move == '^')
        % We move up
        % Can we move? 
        if (map(robo(1)-1,robo(2)) == '#')
            % Above is a wall so we can't move
            return
        elseif (map(robo(1)-1,robo(2)) == '.')
            % If the space is free the robot moves there
            map(robo(1),robo(2)) = '.';
            robo = [robo(1)-1,robo(2)];
            map(robo(1),robo(2)) = '@';
        elseif (map(robo(1)-1,robo(2)) == 'O')
            % If we have a box, we have to check if we can move it
            if (isempty(find(map(1:robo(1),robo(2))=='.',1)))
                % No space to move the boxes so robo can't move
                return
            else
                % Otherwise, we have to check where there is the closest
                % free space
                [row,~] = find(map(:,robo(2))=='.');
                % Find the walls in this direction as well
                [row_w,~] = find(map(:,robo(2))=='#');
                % Check if the wall is blocking our attempt to move the box
                if (max(row_w(row_w<robo(1)))>max(row(row<robo(1))))
                    % No free space between the current box and the next
                    % wall
                    return
                end
                % We put the box there and move the robot
                map(max(row(row<robo(1))),robo(2)) = 'O';
                map(robo(1),robo(2)) = '.';
                robo = [robo(1)-1,robo(2)];
                map(robo(1),robo(2)) = '@';
            end
        end
    elseif (move == '>')
        % We move right
        % Can we move? 
        if (map(robo(1),robo(2)+1) == '#')
            % To the right is a wall so we can't move
            return
        elseif (map(robo(1),robo(2)+1) == '.')
            % If the space is free the robot moves there
            map(robo(1),robo(2)) = '.';
            robo = [robo(1),robo(2)+1];
            map(robo(1),robo(2)) = '@';
        elseif (map(robo(1),robo(2)+1) == 'O')
            % If we have a box, we have to check if we can move it
            if (isempty(find(map(robo(1),robo(2):end)=='.',1)))
                % No space to move the boxes so robo can't move
                return
            else
                % Otherwise, we have to check where there is the closest
                % free space
                [~,col] = find(map(robo(1),:)=='.');
                % Find the walls in this direction as well
                [~,col_w] = find(map(robo(1),:)=='#');
                % Check if the wall is blocking our attempt to move the box
                if (min(col_w(col_w>robo(2)))<min(col(col>robo(2))))
                    % No free space between the current box and the next
                    % wall
                    return
                end
                % We put the box there and move the robot
                map(robo(1),min(col(col>robo(2)))) = 'O';
                map(robo(1),robo(2)) = '.';
                robo = [robo(1),robo(2)+1];
                map(robo(1),robo(2)) = '@';
            end
        end
    elseif (move == 'v')
        % We move down
        % Can we move? 
        if (map(robo(1)+1,robo(2)) == '#')
            % Above is a wall so we can't move
            return
        elseif (map(robo(1)+1,robo(2)) == '.')
            % If the space is free the robot moves there
            map(robo(1),robo(2)) = '.';
            robo = [robo(1)+1,robo(2)];
            map(robo(1),robo(2)) = '@';
        elseif (map(robo(1)+1,robo(2)) == 'O')
            % If we have a box, we have to check if we can move it
            if (isempty(find(map(robo(1):end,robo(2))=='.',1)))
                % No space to move the boxes so robo can't move
                return
            else
                % Otherwise, we have to check where there is the closest
                % free space
                [row,~] = find(map(:,robo(2))=='.');
                % Find the walls in this direction as well
                [row_w,~] = find(map(:,robo(2))=='#');
                % Check if the wall is blocking our attempt to move the box
                if (min(row_w(row_w>robo(1)))<min(row(row>robo(1))))
                    % No free space between the current box and the next
                    % wall
                    return
                end
                % We put the box there and move the robot
                map(min(row(row>robo(1))),robo(2)) = 'O';
                map(robo(1),robo(2)) = '.';
                robo = [robo(1)+1,robo(2)];
                map(robo(1),robo(2)) = '@';
            end
        end
    elseif (move == '<')
        % We move left
        % Can we move? 
        if (map(robo(1),robo(2)-1) == '#')
            % To the right is a wall so we can't move
            return
        elseif (map(robo(1),robo(2)-1) == '.')
            % If the space is free the robot moves there
            map(robo(1),robo(2)) = '.';
            robo = [robo(1),robo(2)-1];
            map(robo(1),robo(2)) = '@';
        elseif (map(robo(1),robo(2)-1) == 'O')
            % If we have a box, we have to check if we can move it
            if (isempty(find(map(robo(1),1:robo(2))=='.',1)))
                % No space to move the boxes so robo can't move
                return
            else
                % Otherwise, we have to check where there is the closest
                % free space
                [~,col] = find(map(robo(1),:)=='.');
                % Find the walls in this direction as well
                [~,col_w] = find(map(robo(1),:)=='#');
                % Check if the wall is blocking our attempt to move the box
                if (max(col_w(col_w<robo(2)))>max(col(col<robo(2))))
                    % No free space between the current box and the next
                    % wall
                    return
                end
                % We put the box there and move the robot
                map(robo(1),max(col(col<robo(2)))) = 'O';
                map(robo(1),robo(2)) = '.';
                robo = [robo(1),robo(2)-1];
                map(robo(1),robo(2)) = '@';
            end
        end
    end
end

% ####################################################
% ####################################################
% Adapted function for movement of roboter for part 2
% We only need to change box movements
% ####################################################
% ####################################################
function [map,robo] = makemove2(map,robo,move)
    % Check direction
    if (move == '^')
        % We move up
        % Can we move? 
        if (map(robo(1)-1,robo(2)) == '#')
            % Above is a wall so we can't move
            return
        elseif (map(robo(1)-1,robo(2)) == '.')
            % If the space is free the robot moves there
            map(robo(1),robo(2)) = '.';
            robo = [robo(1)-1,robo(2)];
            map(robo(1),robo(2)) = '@';
        elseif (map(robo(1)-1,robo(2)) == ']' || ...
                map(robo(1)-1,robo(2)) == '[')
            % If we have a box, we have to check if we can move it
            [map,ok] = moveboxes(map,robo,move);
            % Update robot position
            if (ok==1)
                map(robo(1),robo(2)) = '.';
                robo = [robo(1)-1,robo(2)];
                map(robo(1),robo(2)) = '@';
            else
                return
            end
        end
    elseif (move == '>')
        % We move right
        % Can we move? 
        if (map(robo(1),robo(2)+1) == '#')
            % To the right is a wall so we can't move
            return
        elseif (map(robo(1),robo(2)+1) == '.')
            % If the space is free the robot moves there
            map(robo(1),robo(2)) = '.';
            robo = [robo(1),robo(2)+1];
            map(robo(1),robo(2)) = '@';
        elseif (map(robo(1),robo(2)+1) == '[')
            % If we have a box, we have to check if we can move it
            [map,ok] = moveboxes(map,robo,move);
            % Update robot position
            if (ok==1)
                map(robo(1),robo(2)) = '.';
                robo = [robo(1),robo(2)+1];
                map(robo(1),robo(2)) = '@';
            else
                return
            end
        end
    elseif (move == 'v')
        % We move down
        % Can we move? 
        if (map(robo(1)+1,robo(2)) == '#')
            % Above is a wall so we can't move
            return
        elseif (map(robo(1)+1,robo(2)) == '.')
            % If the space is free the robot moves there
            map(robo(1),robo(2)) = '.';
            robo = [robo(1)+1,robo(2)];
            map(robo(1),robo(2)) = '@';
        elseif (map(robo(1)+1,robo(2)) == '[' || ...
                map(robo(1)+1,robo(2)) == ']')
            % If we have a box, we have to check if we can move it
            [map,ok] = moveboxes(map,robo,move);
            % Update robot position
            if (ok==1)
                map(robo(1),robo(2)) = '.';
                robo = [robo(1)+1,robo(2)];
                map(robo(1),robo(2)) = '@';
            else
                return
            end
        end
    elseif (move == '<')
        % We move left
        % Can we move? 
        if (map(robo(1),robo(2)-1) == '#')
            % To the right is a wall so we can't move
            return
        elseif (map(robo(1),robo(2)-1) == '.')
            % If the space is free the robot moves there
            map(robo(1),robo(2)) = '.';
            robo = [robo(1),robo(2)-1];
            map(robo(1),robo(2)) = '@';
        elseif (map(robo(1),robo(2)-1) == ']')
            % If we have a box, we have to check if we can move it
            [map,ok] = moveboxes(map,robo,move);
            % Update robot position
            if (ok==1)
                map(robo(1),robo(2)) = '.';
                robo = [robo(1),robo(2)-1];
                map(robo(1),robo(2)) = '@';
            else
                return
            end
        end
    end
end

% ####################################################
% ####################################################
% Move boxes function
% ####################################################
% ####################################################
function [map,ok] = moveboxes(map,start,move)
    ok = 0;    
    if (move == '^')
        % We check recursively if we can move boxes
        if (map(start(1)-1,start(2)) == '[')
            % Check situation above
            if (map(start(1)-2,start(2)) == '.' && ...
                map(start(1)-2,start(2)+1) == '.')
                % We can move the box up
                ok = 1;
                map(start(1)-2,start(2):start(2)+1) = '[]';
                map(start(1)-1,start(2):start(2)+1) = '.';
                return
            elseif (map(start(1)-2,start(2)) == '#' || ...
                    map(start(1)-2,start(2)+1) == '#')
                % We can't move
                ok = 0;
                return
            elseif(map(start(1)-2,start(2)) == ']')
                % We have a box diagonal above left
                [map_tmp,ok] = moveboxes(map,[start(1)-1,start(2)-1],move);
                if (ok == 1)
                    % We can also have a 2nd box diagonal above right
                    if(map(start(1)-2,start(2)+1) == '[')
                        [map_tmp,ok] = ...
                            moveboxes(map_tmp,[start(1)-1,start(2)+1],move);
                    end
                    if (ok == 1)
                        map = map_tmp;
                        map(start(1)-2,start(2):start(2)+1) = '[]';
                        map(start(1)-1,start(2):start(2)+1) = '.';
                        return
                    end
                end
            elseif(map(start(1)-2,start(2)) == '[')
                % We have a box above 
                [map,ok] = moveboxes(map,[start(1)-1,start(2)],move);
                if (ok == 1)
                    map(start(1)-2,start(2):start(2)+1) = '[]';
                    map(start(1)-1,start(2):start(2)+1) = '.';
                    return
                end
            elseif(map(start(1)-2,start(2)+1) == '[')
                % We have a box diagonal above right 
                [map,ok] = moveboxes(map,[start(1)-1,start(2)+1],move);
                if (ok == 1)
                    map(start(1)-2,start(2):start(2)+1) = '[]';
                    map(start(1)-1,start(2):start(2)+1) = '.';
                    return
                end
            end
        elseif (map(start(1)-1,start(2)) == ']')
            % Check situation above
            if (map(start(1)-2,start(2)-1) == '.' && ...
                map(start(1)-2,start(2)) == '.')
                % We can move the box up
                ok = 1;
                map(start(1)-2,start(2)-1:start(2)) = '[]';
                map(start(1)-1,start(2)-1:start(2)) = '.';
                return
            elseif (map(start(1)-2,start(2)-1) == '#' || ...
                    map(start(1)-2,start(2)) == '#')
                % We can't move
                ok = 0;
                return
            elseif(map(start(1)-2,start(2)-1) == ']')
                % We have a box diagonal above left
                [map_tmp,ok] = moveboxes(map,[start(1)-1,start(2)-1],move);
                if (ok == 1)
                    % We can also have a 2nd box diagonal above right
                    if(map(start(1)-2,start(2)) == '[')
                        [map_tmp,ok] = ...
                            moveboxes(map_tmp,[start(1)-1,start(2)],move);
                    end
                    if (ok == 1)
                        map = map_tmp;
                        map(start(1)-2,start(2)-1:start(2)) = '[]';
                        map(start(1)-1,start(2)-1:start(2)) = '.';
                        return
                    end
                end
            elseif(map(start(1)-2,start(2)) == ']')
                % We have a box above 
                [map,ok] = moveboxes(map,[start(1)-1,start(2)],move);
                if (ok == 1)
                    map(start(1)-2,start(2)-1:start(2)) = '[]';
                    map(start(1)-1,start(2)-1:start(2)) = '.';
                    return
                end
            elseif(map(start(1)-2,start(2)) == '[')
                % We have a box diagonal above right 
                [map,ok] = moveboxes(map,[start(1)-1,start(2)+1],move);
                if (ok == 1)
                    map(start(1)-2,start(2)-1:start(2)) = '[]';
                    map(start(1)-1,start(2)-1:start(2)) = '.';
                    return
                end
            end
        end     
    elseif(move == '>')
    % For right it's easier - we can do basically the same as for part 1
        % If we have a box, we have to check if we can move it
        % Find all empty spots to the right
        [~,col] = find(map(start(1),:) == '.');
        col = col(col>start(2));
        % And all wall spots to the right
        [~,col_w] = find(map(start(1),:) == '#');
        col_w = col_w(col_w>start(2));
        % Get free columns before the next wall
        col = col(col<col_w(1));
        % If we have less than two free spots we can't move
        if (isempty(col))
            % We can't move
            ok = 0;
            return
        else
            % We move everything until the next free spot one to the right
            ok = 1;
            map(start(1),start(2)+1:col(1)) = ...
                map(start(1),start(2):col(1)-1);
            map(start(1),start(2)) = '.';
            return
        end
    elseif(move == 'v')
    % We check recursively if we can move boxes
        if (map(start(1)+1,start(2)) == '[')
            % Check situation below
            if (map(start(1)+2,start(2)) == '.' && ...
                map(start(1)+2,start(2)+1) == '.')
                % We can move the box down
                ok = 1;
                map(start(1)+2,start(2):start(2)+1) = '[]';
                map(start(1)+1,start(2):start(2)+1) = '.';
                return
            elseif (map(start(1)+2,start(2)) == '#' || ...
                    map(start(1)+2,start(2)+1) == '#')
                % We can't move
                ok = 0;
                return
            elseif(map(start(1)+2,start(2)) == ']')
                % We have a box diagonal below left
                [map_tmp,ok] = moveboxes(map,[start(1)+1,start(2)-1],move);
                if (ok == 1)
                    % We can also have a second box diagonal right
                    if(map(start(1)+2,start(2)+1) == '[')
                        [map_tmp,ok] = ...
                            moveboxes(map_tmp,[start(1)+1,start(2)+1],move);
                    end
                    if (ok == 1)
                        map = map_tmp;
                        map(start(1)+2,start(2):start(2)+1) = '[]';
                        map(start(1)+1,start(2):start(2)+1) = '.';
                        return
                    end
                end
            elseif(map(start(1)+2,start(2)) == '[')
                % We have a box below 
                [map,ok] = moveboxes(map,[start(1)+1,start(2)],move);
                if (ok == 1)
                    map(start(1)+2,start(2):start(2)+1) = '[]';
                    map(start(1)+1,start(2):start(2)+1) = '.';
                    return
                end
            elseif(map(start(1)+2,start(2)+1) == '[')
                % We have a box diagonal below right 
                [map,ok] = moveboxes(map,[start(1)+1,start(2)+1],move);
                if (ok == 1)
                    map(start(1)+2,start(2):start(2)+1) = '[]';
                    map(start(1)+1,start(2):start(2)+1) = '.';
                    return
                end
            end
        elseif (map(start(1)+1,start(2)) == ']')
            % Check situation below
            if (map(start(1)+2,start(2)-1) == '.' && ...
                map(start(1)+2,start(2)) == '.')
                % We can move the box down
                ok = 1;
                map(start(1)+2,start(2)-1:start(2)) = '[]';
                map(start(1)+1,start(2)-1:start(2)) = '.';
                return
            elseif (map(start(1)+2,start(2)-1) == '#' || ...
                    map(start(1)+2,start(2)) == '#')
                % We can't move
                ok = 0;
                return
            elseif(map(start(1)+2,start(2)-1) == ']')
                % We have a box diagonal below left
                [map_tmp,ok] = moveboxes(map,[start(1)+1,start(2)-1],move);
                if (ok == 1)
                    % We can also have a second box diagonal right
                    if(map(start(1)+2,start(2)) == '[')
                        [map_tmp,ok] = ...
                            moveboxes(map_tmp,[start(1)+1,start(2)],move);
                    end
                    if (ok == 1)
                        map = map_tmp;
                        map(start(1)+2,start(2)-1:start(2)) = '[]';
                        map(start(1)+1,start(2)-1:start(2)) = '.';
                        return
                    end
                end
            elseif(map(start(1)+2,start(2)) == ']')
                % We have a box below 
                [map,ok] = moveboxes(map,[start(1)+1,start(2)],move);
                if (ok == 1)
                    map(start(1)+2,start(2)-1:start(2)) = '[]';
                    map(start(1)+1,start(2)-1:start(2)) = '.';
                    return
                end
            elseif(map(start(1)+2,start(2)) == '[')
                % We have a box diagonal below right 
                [map,ok] = moveboxes(map,[start(1)+1,start(2)+1],move);
                if (ok == 1)
                    map(start(1)+2,start(2)-1:start(2)) = '[]';
                    map(start(1)+1,start(2)-1:start(2)) = '.';
                    return
                end
            end
        end
    elseif(move == '<')
    % If we have a box, we have to check if we can move it
    % For left it's easier - we can do basically the same as for part 1
        % If we have a box, we have to check if we can move it
        % Find all empty spots to the left
        [~,col] = find(map(start(1),:) == '.');
        col = col(col<start(2));
        % And all wall spots to the right
        [~,col_w] = find(map(start(1),:) == '#');
        col_w = col_w(col_w<start(2));
        % Get free columns before the next wall
        col = col(col>col_w(end));
        % If we have less than two free spots we can't move
        if (isempty(col))
            % We can't move
            ok = 0;
            return
        else
            % We move everything until the next free spot one to the left
            ok = 1;
            map(start(1),col(end):start(2)-1) = ...
                map(start(1),col(end)+1:start(2));
            map(start(1),start(2)) = '.';
            return
        end
    end
end




