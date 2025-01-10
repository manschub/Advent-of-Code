clc; clearvars;
% Advent of code 2024 - day 20 - part 1+2
% Open file and take needed data
file_id = fopen("day20.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
[x,y] = size(data{1,1});
for i = 1:x
    map(i,:) = data{1,1}{i,1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find the shortest path in a map and then find the
% best ways to cheat (go through walls for two steps)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Get start and end position
[start(1),start(2)] = find(map=='S');
[fin(1),fin(2)] = find(map=='E');
% Change walls to simply checks later
map(fin(1),fin(2)) = '.';
map(start(1),start(2)) = '.';

% Follow the path
[steps,map_tmp,path] = followpath(map,start,fin);

% Get all rows and columns of track once
[r,c] = find(map == '.');

% Now we need to check all possible cheats
% We need to do that by manipulating the map, otherwise it is way too slow
% We test for each step what happens
low = [];
for i = 1:length(path(:,1))
    % Now we want to find all entry points into the wall
    entry = [];
    if (map(path(i,1)-1,path(i,2)) == '#' || ... % Up
        map(path(i,1),path(i,2)+1) == '#' || ... % Right
        map(path(i,1)+1,path(i,2)) == '#' || ... % Down
        map(path(i,1),path(i,2)-1) == '#') % Left
        entry = [path(i,1),path(i,2)];
    end
    % If no entrance point - skip
    if (isempty(entry))
        continue
    end
    % For each entry point we need to find the possible exit points
    for ii=1:length(entry(:,1))
        % Find leave
        [leave] = findpaths(entry(ii,:),r,c,2);
        if (isempty(leave))
            continue
        end
        % Now do the pathfinding again for each path
        for j=1:length(leave(:,1))
            % Find the new path length (path length until current step + 2
            % for skipping one wall plus the rest of the path from our exit
            lowest(j,1:5) = [entry(ii,1:2),leave(j,1:2),path(i,3) + 2 + ...
                (steps-path(path(:,1)==leave(j,1)&path(:,2)==leave(j,2),3))];
        end
        low(end+1:end+length(lowest(:,1)),1:5) = lowest(:,1:5);
    end   
end
low = low(low(:,5)<steps,:);
low = unique(low,'rows');
low = sortrows(low,5);
% Remove everything bigger than steps-99
result1 = length(low(low(:,5)<=steps-100));

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now the cheat can be up to 20 steps long
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Now we need to check all possible cheats
% We need to do that by manipulating the map, otherwise it is way too slow
% We test for each step what happens
low = [];
for i = 1:length(path(:,1))
    % Now we want to find all entry points into the wall
    entry = [];
    if (map(path(i,1)-1,path(i,2)) == '#' || ... % Up
        map(path(i,1),path(i,2)+1) == '#' || ... % Right
        map(path(i,1)+1,path(i,2)) == '#' || ... % Down
        map(path(i,1),path(i,2)-1) == '#') % Left
        entry = [path(i,1),path(i,2)];
    end
    % If no entrance point - skip
    if (isempty(entry))
        continue
    end
    % For each entry point we need to find the possible exit points
    for ii=1:length(entry(:,1))
        % Find leave
        [leave] = findpaths(entry(ii,:),r,c,20);
        if (isempty(leave))
            continue
        end
        % Now do the pathfinding again for each path
        for j=1:length(leave(:,1))
            % Find the new path length (path length until current step +
            % steps through wall plus the rest of the path from our exit
            lowest(j,1:5) = [entry(ii,1:2),leave(j,1:2), ...
                path(i,3) + leave(j,3) + ...
                (steps-path(path(:,1)==leave(j,1)&path(:,2)==leave(j,2),3))];
        end
        low(end+1:end+length(lowest(:,1)),1:5) = lowest(:,1:5);
    end   
end
low = low(low(:,5)<steps,:);
low = unique(low,'rows');
low = sortrows(low,5);
% Remove everything bigger than steps-99
result2 = length(low(low(:,5)<=steps-100));

fprintf('%10f',result2)
fprintf('\n')
toc

% Function to follow the path including cheating rules for part 1
function [steps,map,todo] = followpath(map,start,fin)
    % Start counts as the first step
    row = start(1); col = start(2);
    todo = [row,col,0];
    % We just need to follow the path until we are at the end
    while (~isempty(todo))
        map(todo(end,1),todo(end,2)) = 'O';
        % Check the next possible step
        % Did we reach the end?
        if (todo(end,1) == fin(1) && todo(end,2) == fin(2))
            break
        end
        % Now we split our path (we can always go in the
        % direction that is not blocked by #)
        if (map(todo(end,1)-1,todo(end,2)) == '.')
            % Facing North
            todo(end+1,:) = [todo(end,1)-1,todo(end,2),todo(end,3)+1];
        elseif (map(todo(end,1),todo(end,2)+1) == '.')
            % Facing East
            todo(end+1,:) = [todo(end,1),todo(end,2)+1,todo(end,3)+1];
        elseif (map(todo(end,1)+1,todo(end,2)) == '.')
            % Facing South
            todo(end+1,:) = [todo(end,1)+1,todo(end,2),todo(end,3)+1];
        elseif (map(todo(end,1),todo(end,2)-1) == '.')
            % Facing West
            todo(end+1,:) = [todo(end,1),todo(end,2)-1,todo(end,3)+1];
        end
    end
    steps = todo(end,3);
    map(fin(1),fin(2)) = 'O';
end

% Find possible paths through walls
function [leave] = findpaths(start,r,c,range)
    % Increment how many steps in the wall we did already
    leave = []; 
    % We filter out only the reachable track parts
    for i = 1:length(r)
        % Check range from us
        if (abs(r(i)-start(1)) + abs(c(i)-start(2)) <= range)
            % Within range so we have a possible destination
            leave(end+1,1:3) = [r(i),c(i), ...
                abs(r(i)-start(1)) + abs(c(i)-start(2))];
        end
    end
end