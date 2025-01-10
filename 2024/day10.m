clc; clearvars;
% Advent of code 2024 - day 10 - part 1+2
% Open file and take needed data
file_id = fopen("day10.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
[x,y] = size(data{1,1});
for i = 1:x
    string(i,:) = data{1,1}{i,1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find the number of summits reachable from each
% trailhead
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Is the same but we count all paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0; result2 = 0;

% First find all the trailheads
[rows,cols] = find(string=='0');

% Now we have to loop through all trailheads
for i = 1:length(rows)
    pos_summits = [];
    % Check the paths we can take
    [pos_summits] = checkpath([rows(i),cols(i)],string,pos_summits);
    pos_uni = unique(pos_summits,'rows');
    result1 = result1+length(pos_uni(:,1));
    result2 = result2+length(pos_summits(:,1));
end

fprintf('%10f',result1)
fprintf('\n')
toc
fprintf('%10f',result2)
fprintf('\n')
toc

% Function to follow the hiking trails
function [pos_summits] = checkpath(start,map,pos_summits)
    % We have to check surrounding walking possibilities
    % For all 4 directions check walkable paths (have to increment by 1)
    % Check North
    if (start(1,1)>1 && str2double(map(start(1,1)-1,start(1,2))) ...
            - str2double(map(start(1,1),start(1,2))) == 1)
        % We can walk North
        path = [start(1,1)-1,start(1,2)];
        % Check if we will reach a summit
        if (map(path(1),path(2)) == '9')
            if(isempty(pos_summits))
                pos_summits = path;
            else
                pos_summits(end+1,1:2) = path;
            end
            % The path ends here
        else
            % Else continue to hike :-)
            [pos_summits] = checkpath(path,map,pos_summits); 
        end
        
    end
    % Check East
    if (start(1,2)<length(map(1,:)) && ...
            str2double(map(start(1,1),start(1,2)+1)) ...
            - str2double(map(start(1,1),start(1,2))) == 1)
        % We can walk East
        path = [start(1,1),start(1,2)+1];
        % Check if we will reach a summit
        if (map(path(1),path(2)) == '9')
            if(isempty(pos_summits))
                pos_summits = path;
            else
                pos_summits(end+1,1:2) = path;
            end
            % The path ends here
        else
            % Else continue to hike :-)
            [pos_summits] = checkpath(path,map,pos_summits); 
        end 
    end
    % Check South
    if (start(1,1)<length(map(:,1)) && ... 
            str2double(map(start(1,1)+1,start(1,2))) ...
            - str2double(map(start(1,1),start(1,2))) == 1)
        % We can walk South
        path = [start(1,1)+1,start(1,2)];
        % Check if we will reach a summit
        if (map(path(1),path(2)) == '9')
            if(isempty(pos_summits))
                pos_summits = path;
            else
                pos_summits(end+1,1:2) = path;
            end
            % The path ends here
        else
            % Else continue to hike :-)
            [pos_summits] = checkpath(path,map,pos_summits); 
        end 
    end
    % Check West
    if (start(1,2)>1 && str2double(map(start(1,1),start(1,2)-1)) ...
            - str2double(map(start(1,1),start(1,2))) == 1)
        % We can walk West
        path = [start(1,1),start(1,2)-1];
        % Check if we will reach a summit
        if (map(path(1),path(2)) == '9')
            if(isempty(pos_summits))
                pos_summits = path;
            else
                pos_summits(end+1,1:2) = path;
            end
            % The path ends here
        else
            % Else continue to hike :-)
            [pos_summits] = checkpath(path,map,pos_summits); 
        end
    end
end

