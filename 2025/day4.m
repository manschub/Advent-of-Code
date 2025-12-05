clc; clearvars;
% Advent of code 2025 - day 4 - part 1+2
% Open file and take needed data
file_id = fopen("day4.dat");
data = textscan(file_id,strcat('%s'),'delimiter',', ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Rearrange data
map = '';
for i = 1:size(data{1,1},1)
    map(i,:) = data{1,1}{i,1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Find all reachable paper rolls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

result1 = 0;
% Find all paper rolls
[rows,cols] = find(map == '@');
% Go through paper rolls and check if they can be accessed
for i = 1:length(rows)
    tmp_map = map(max(1,rows(i)-1):min(size(map,1),rows(i)+1), ...
        max(1,cols(i)-1):min(size(map,2),cols(i)+1));
    % Do we have less than 4 rolls here -> We can access with forklift
    if (sum(sum(tmp_map=='@'))-1 < 4)
        result1 = result1+1;
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Same but repeated times to remove all removable rolls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

result2 = 0;

% Go through paper rolls and check if they can be accessed
% Do that until no paper roll can be removed anymore
map2 = map;
cnt = 0;
while (cnt == 0)
    % Find all paper rolls
    [rows,cols] = find(map == '@');
    for i = 1:length(rows)
        tmp_map = map(max(1,rows(i)-1):min(size(map,1),rows(i)+1), ...
            max(1,cols(i)-1):min(size(map,2),cols(i)+1));
        % Do we have less than 4 rolls here -> We can access with forklift
        if (sum(sum(tmp_map=='@'))-1 < 4)
            cnt = cnt+1;
            map2(rows(i),cols(i)) = 'x';
        end
    end
    % If we couldn't remove any further paper roll - leave
    if (cnt == 0)
        break
    else
        % Else add removed ones to result
        result2 = result2 + cnt;
    end
    cnt = 0;
    map = map2;
end

fprintf('%10f',result2)
fprintf('\n')
toc
