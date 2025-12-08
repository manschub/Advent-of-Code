clc; clearvars;
% Advent of code 2025 - day 7 - part 1+2
% Open file and take needed data
file_id = fopen("day7.dat");
data = textscan(file_id,strcat('%s'),'delimiter',', ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Rearrange data
map = '';
for i = 1:size(data{1,1},1)
    map(i,:) = data{1,1}{i,1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to get the beam path and count each beam splitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Go through map
% Find starting point
[row,col] = find(map=='S');

[splits] = followBeam([row,col],map);
result1 = splits;

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - We need to count timelines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Go through map
% Find starting point
[row,col] = find(map=='S');

% Go through the map line by line
map2 = zeros(size(map,1),size(map,2));
map2(row,col) = 1;
for i = 2:size(map2,1)
    % Go through columns
    for j = 1:size(map2,2)
        % Are we on a splitter?
        if (map(i,j) == '^')
            % Then we need to add to left and right if possibe
            if (j>1)
                map2(i,j-1) = map2(i,j-1)+map2(i-1,j);
            end
            if (j<size(map2,2))
                map2(i,j+1) = map2(i,j+1)+map2(i-1,j);
            end
        else
            % We are not on a splitter - copy the beam number from above
            map2(i,j) = map2(i,j)+map2(i-1,j);
        end
    end
end
result2 = sum(map2(end,:));

fprintf('%10f',result2)
fprintf('\n')
toc

function [split] = followBeam(start,map)
    % We go through beam and whenever there is a split we put new paths
    % into a todo list
    todo(1,:) = [start(1)+1,start(2)];
    split = 0;
    % Go through todo until done
    while (~isempty(todo))
        % If we don't split we just go down
        if (todo(1,1)+1 > size(map,1))
            % Nothing to do - we reached end of map
        elseif (map(todo(1,1),todo(1,2))=='.')
            todo(end+1,:) = [todo(1,1)+1,todo(1,2)];
            map(todo(1,1),todo(1,2)) = '|';
        elseif (map(todo(1,1),todo(1,2))=='^')
            % We split
            if(todo(1,1)+1 <= size(map,1) && todo(1,2)-1 >= 1)
                todo(end+1,:) = [todo(1,1),todo(1,2)-1];
            end
            if(todo(1,1)+1 <= size(map,1) && todo(1,2)+1 <= size(map,2))
                todo(end+1,:) = [todo(1,1),todo(1,2)+1];
            end
            split = split+1;
        end
        todo = todo(2:end,:);
    end
end
