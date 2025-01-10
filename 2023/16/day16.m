clc; clear all;
% Advent of code 2023 - day 16 - part 1+2
% Open file and take needed data
file_id = fopen("day16.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);
strings = [];
% Rearrange data to be handled nicer
for i = 1:length(data{1,1})
    strings = [strings;data{1,1}{i,1}];
end
strings_start = strings;
tic
% Follow beam path and count crossed fields
finished = 0; 
row = 1; col = 0;
current_direction = 'e';
row_store(1) = row; col_store(1) = col;
strings_new = strings;
strings_new(1,1) = '#';
while (finished == 0)
    % Follow beam
    [row,col,row_store,col_store,current_direction,finished,strings,strings_new] = ...
        follow_beam(current_direction,row,col,row_store,col_store,strings,finished,strings_new);
end

% Now find all # 
[row_energized,~] = find(strings_new == '#');

result_part1 = length(row_energized);
fprintf('%10f',result_part1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Part 2 - Now beam can enter from anywhere 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Follow beam path and count crossed fields
% For all rows from the left
tic
for i = 1:length(strings(:,1))
% parfor i = 81:110
    strings = strings_start;
    finished = 0; current_direction = 'e';
    row = i; col = 0;
    row_store = 0; col_store = 0;
    row_store(1) = row; col_store(1) = col;
    strings_new = strings;
    strings_new(i,1) = '#';
    while (finished == 0)
        % Follow beam
        [row,col,row_store,col_store,current_direction,finished,strings,strings_new] = ...
            follow_beam(current_direction,row,col,row_store,col_store,strings,finished,strings_new);
    end
    
    % Now find all # 
    i/length(strings(:,1))
    [row_energized,~] = find(strings_new == '#');
    num_energized(i) = length(row_energized);
end
% For all rows from the right
for i = 1:length(strings(:,1))
% parfor i = 21:40
    strings = strings_start;
    finished = 0; current_direction = 'w';
    row = i; col = length(strings(1,:))+1;
    row_store = 0; col_store = 0;
    row_store(1) = row; col_store(1) = col;
    strings_new = strings;
    strings_new(i,length(strings(1,:))) = '#';
    while (finished == 0)
        % Follow beam
        [row,col,row_store,col_store,current_direction,finished,strings,strings_new] = ...
            follow_beam(current_direction,row,col,row_store,col_store,strings,finished,strings_new);
    end
    
    % Now find all # 
    i/length(strings(:,1))
    [row_energized,~] = find(strings_new == '#');
    num_energized2(i) = length(row_energized);
end
% For all columns from top
for i = 1:length(strings(1,:))
    strings = strings_start;
    finished = 0; current_direction = 's';
    row = 0; col = i;
    row_store = 0; col_store = 0;
    row_store(1) = row; col_store(1) = col;
    strings_new = strings;
    strings_new(1,i) = '#';
    while (finished == 0)
        % Follow beam
        [row,col,row_store,col_store,current_direction,finished,strings,strings_new] = ...
            follow_beam(current_direction,row,col,row_store,col_store,strings,finished,strings_new);
    end
    
    % Now find all # 
    i/length(strings(:,1))
    [row_energized,~] = find(strings_new == '#');
    num_energized3(i) = length(row_energized);
end
% For all columns from bottom
for i = 1:length(strings(1,:))
    strings = strings_start;
    finished = 0; current_direction = 'n';
    row = length(strings(:,1))+1; col = i;
    row_store = 0; col_store = 0;
    row_store(1) = row; col_store(1) = col;
    strings_new = strings;
    strings_new(length(strings(1,:)),i) = '#';
    while (finished == 0)
        % Follow beam
        [row,col,row_store,col_store,current_direction,finished,strings,strings_new] = ...
            follow_beam(current_direction,row,col,row_store,col_store,strings,finished,strings_new);
    end
    
    % Now find all # 
    i/length(strings(:,1))
    [row_energized,~] = find(strings_new == '#');
    num_energized4(i) = length(row_energized);
end
num_energ = [num_energized,num_energized2,num_energized3,num_energized4];
result_part2 = max(num_energ);
fprintf('%10f',result_part2)
fprintf('\n')

toc
num_energ_old = load("num_energ_old.mat");
num_energ_old = num_energ_old.num_energ;
% save("num_energ_old.mat","num_energ")

function [row,col,row_store,col_store,current_direction,finished,strings,strings_new] = ...
    follow_beam(current_direction,row,col,row_store,col_store,strings,finished,strings_new)

    % We continue in current direction
    if (current_direction == 'e')
        if (col+1 <= length(strings(1,:)))
            col = col+1;
        else 
            finished = 1;
            return
        end
    elseif (current_direction == 'w')
        if (col > 1)
            col = col-1;
        else
            finished = 1;
            return
        end
    elseif (current_direction == 'n')
        if (row > 1)
            row = row-1;
        else
            finished = 1;
            return
        end
    elseif (current_direction == 's')
        if (row+1 <= length(strings(:,1)))
            row = row+1;
        else
            finished = 1;
            return 
        end
    end
    row_store(end+1) = row;
    col_store(end+1) = col;
    % Find repetitions
    cnt_repetition = 0;
    for k = length(row_store)-1:-1:2
        if (row_store(end) == row_store(k) && col_store(end) == col_store(k) ...
                && row_store(end-1) == row_store(k-1) && col_store(end-1) == col_store(k-1))
            cnt_repetition = cnt_repetition+1;
        end
    end
    if (cnt_repetition > 2)
        finished = 1;
        return 
    end
    % Now check which sign we have
    if (strings(row,col) == '.' || (strings(row,col) == '|' && ...
            (current_direction == 'n' || current_direction == 's')) ...
            || (strings(row,col) == '-' && ...
            (current_direction == 'e' || current_direction == 'w')))
        strings_new(row,col) = '#';
    elseif (strings(row,col) == '/' && current_direction == 'e')
        % We turn from east to north
        current_direction = 'n';
        strings_new(row,col) = '#';
    elseif (strings(row,col) == '/' && current_direction == 'n')
        % We turn from north to east
        current_direction = 'e';
        strings_new(row,col) = '#';
    elseif (strings(row,col) == '/' && current_direction == 'w') 
        % We turn from west to south
        current_direction = 's';
        strings_new(row,col) = '#';
    elseif (strings(row,col) == '/' && current_direction == 's') 
        % We turn from south to west
        current_direction = 'w';
        strings_new(row,col) = '#';
    elseif (strings(row,col) == '\' && current_direction == 'e')
        % We turn from east to south
        current_direction = 's';
        strings_new(row,col) = '#';
    elseif (strings(row,col) == '\' && current_direction == 'n')
        % We turn from north to west
        current_direction = 'w';
        strings_new(row,col) = '#';
    elseif (strings(row,col) == '\' && current_direction == 'w') 
        % We turn from west to north
        current_direction = 'n';
        strings_new(row,col) = '#';
    elseif (strings(row,col) == '\' && current_direction == 's') 
        % We turn from south to east
        current_direction = 'e';
        strings_new(row,col) = '#';
    elseif (strings(row,col) == '|' && (current_direction == 'w' ... 
            || current_direction == 'e'))
            row_tmp = row; col_tmp = col;
        for j=1:2
            % We split beam and have a beam to north and a beam to south
            if (j==1)
                current_direction = 'n';
                strings_new(row,col) = '#';
                % Follow beam to north
                finished = 0;
                while (finished ~= 1)
                [row,col,row_store,col_store,current_direction,finished,strings,strings_new] = follow_beam(current_direction,...
                    row,col,row_store,col_store,strings,finished,strings_new);
                end
            elseif (j==2)
                row = row_tmp; col = col_tmp;
                current_direction = 's';
                % Follow beam to south
                finished = 0;
                while (finished ~= 1)
                [row,col,row_store,col_store,current_direction,finished,strings,strings_new] = follow_beam(current_direction,...
                    row,col,row_store,col_store,strings,finished,strings_new);
                end
            end
        end
    elseif (strings(row,col) == '-' && (current_direction == 's' ... 
            || current_direction == 'n'))
            row_tmp = row; col_tmp = col;
        for j=1:2
            % We split beam and have a beam to east and a beam to west
            if (j==1)
                current_direction = 'e';
                strings_new(row,col) = '#';
                % Follow beam to east
                finished = 0;
                while (finished ~= 1)
                [row,col,row_store,col_store,current_direction,finished,strings,strings_new] = follow_beam(current_direction,...
                    row,col,row_store,col_store,strings,finished,strings_new);
                end
            elseif (j==2)
                row = row_tmp; col = col_tmp;
                current_direction = 'w';
                % Follow beam to west
                finished = 0; 
                while (finished ~= 1)
                [row,col,row_store,col_store,current_direction,finished,strings,strings_new] = follow_beam(current_direction,...
                    row,col,row_store,col_store,strings,finished,strings_new);
                end
            end
        end
    end
end



