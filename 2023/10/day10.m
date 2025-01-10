clc; clear all;
% Advent of code 2023 - day 10 - part 1+2
% | is a vertical pipe connecting north and south.
% - is a horizontal pipe connecting east and west.
% L is a 90-degree bend connecting north and east.
% J is a 90-degree bend connecting north and west.
% 7 is a 90-degree bend connecting south and west.
% F is a 90-degree bend connecting south and east.
% . is ground; there is no pipe in this tile.
% S is the starting position of the animal; there is a pipe on this tile, 
% but your sketch doesn't show what shape the pipe has.

% Open file and take needed data
file_id = fopen("day10.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);

% Close file
fclose(file_id);

strings = [];
% Rearrange data to be handled nicer
for i = 1:length(data{1,1})
    strings = [strings;data{1,1}{i,1}];
end

% Test data
% strings = ['..F7.'; '.FJ|.'; 'SJ.L7'; '|F--J'; 'LJ...'];
% Test part 2
% strings = ['FF7FSF7F7F7F7F7F---7'; 'L|LJ||||||||||||F--J'; ...
%     'FL-7LJLJ||||||LJL-77'; ...
%     'F--JF--7||LJLJ.F7FJ-'; ...
%     'L---JF-JLJ....FJLJJ7'; ...
%     '|F|F-JF---7...L7L|7|'; ...
%     '|FFJF7L7F-JF7..L---7'; ...
%     '7-L-JL7||F7|L7F-7F7|'; ...
%     'L.L7LFJ|||||FJL7||LJ'; ...
%     'L7JLJL-JLJLJL--JLJ.L'];
% strings = ['...........'; ...
% '.S-------7.'; ...
% '.|F-----7|.'; ...
% '.||.....||.'; ...
% '.||.....||.'; ...
% '.|L-7.F-J|.'; ...
% '.|..|.|..|.'; ...
% '.L--J.L--J.'; ...
% '...........'];

% Add rows to top and bottom and columns to left and right to avoid border
% cases later
strings(2:end+1,2:end+1) = strings; 
strings(1:end,1) = 'x'; strings(end+1,1:end) = 'x';
strings(1,1:end) = 'x'; strings(1:end,end+1) = 'x';

% First we need to find the starting point
[row(1), col(1)] = find(strings == 'S');
row(2) = row(1); col(2) = col(1);
old_row = row; old_col = col;
% Now in a loop we find the connecting pipes
i = 1;
strings_stored(i,1) = '|';
strings_stored(i,2) = '|';
row_store(1,:) = row;
col_store(1,:) = col;
while (i > 0)
    cnt = 0;
    row_store(i+1,:) = row;
    col_store(i+1,:) = col;
    new_row = row; new_col = col;
    % Depending on which string we are on we need to look for specific
    % neighbouring characters
    if (strings(row(1),col(1)) == 'S')
        % Find '|'
        [tmp_row,tmp_col] = find(strings(old_row(1)-1:old_row(1)+1,old_col(1)) == '|');
        % If we found 2 we are done with the connecting pipes
        if (length(tmp_row) == 2) 
            row(1) = old_row(1)-2 + tmp_row(1);
            row(2) = old_row(1)-2 + tmp_row(2); 
            continue
        % If we have one we need one more
        elseif (length(tmp_row) == 1)
            row(1) = old_row(1)-2 + tmp_row(1);
            cnt=cnt+1;
        end
        % Find '-'
        [tmp_row,tmp_col] = find(strings(old_row(1),old_col(1)-1:old_col(1)+1) == '-');
        if (length(tmp_row) == 2) 
            col(1) = old_col(1)-2 + tmp_col(1);
            col(2) = old_col(1)-2 + tmp_col(2);
            continue
        elseif (length(tmp_row) == 1)
            if (cnt == 0)
                col(1) = old_col(1)-2 + tmp_col(1);
            else
                col(2) = old_col(1)-2 + tmp_col(1);
            end
            cnt=cnt+1;
            if (cnt == 2)
                continue
            end
        end
        % Find 'L' 1
        [tmp_row,tmp_col] = find(strings(old_row(1)-1,old_col(1)) == 'L');
        if (length(tmp_row) == 1)
            if (cnt == 0)
                row(1) = old_row(1)-1;
            else
                row(2) = old_row(1)-1;
            end
            cnt=cnt+1;
            if (cnt == 2)
                continue
            end
        end
        % Find 'L' 2
        [tmp_row,tmp_col] = find(strings(old_row(1),old_col(1)+1) == 'L');
        if (length(tmp_row) == 1)
            if (cnt == 0)
                col(1) = old_col(1)+1;
            else
                col(2) = old_col(1)+1;
            end
            cnt=cnt+1;
            if (cnt == 2)
                continue
            end
        end
        % Find 'J' 1
        [tmp_row,tmp_col] = find(strings(old_row(1)+1,old_col(1)) == 'J');
        if (length(tmp_row) == 1)
            if (cnt == 0)
                row(1) = old_row(1)+1;
            else
                row(2) = old_row(1)+1;
            end
            cnt=cnt+1;
            if (cnt == 2)
                continue
            end
        end
        % Find 'J' 2
        [tmp_row,tmp_col] = find(strings(old_row(1),old_col(1)+1) == 'J');
        if (length(tmp_row) == 1)
            if (cnt == 0)
                col(1) = old_col(1)+1;
            else
                col(2) = old_col(1)+1;
            end
            cnt=cnt+1;
            if (cnt == 2)
                continue
            end
        end
        % Find '7' 1
        [tmp_row,tmp_col] = find(strings(old_row(1)-1,old_col(1)) == '7');
        if (length(tmp_row) == 1)
            if (cnt == 0)
                row(1) = old_row(1)-1;
            else
                row(2) = old_row(1)-1;
            end
            cnt=cnt+1;
            if (cnt == 2)
                continue
            end
        end
        % Find '7' 2
        [tmp_row,tmp_col] = find(strings(old_row(1),old_col(1)+1) == '7');
        if (length(tmp_row) == 1)
            if (cnt == 0)
                col(1) = old_col(1)+1;
            else
                col(2) = old_col(1)+1;
            end
            cnt=cnt+1;
            if (cnt == 2)
                continue
            end
        end
        % Find 'F' 1
        [tmp_row,tmp_col] = find(strings(old_row(1)-1,old_col(1)) == 'F');
        if (length(tmp_row) == 1)
            if (cnt == 0)
                row(1) = old_row(1)-1;
            else
                row(2) = old_row(1)-1;
            end
            cnt=cnt+1;
            if (cnt == 2)
                continue
            end
        end
        % Find 'F' 2
        [tmp_row,tmp_col] = find(strings(old_row(1),old_col(1)-1) == 'F');
        if (length(tmp_row) == 1)
            if (cnt == 0)
                col(1) = old_col(1)-1;
            else
                col(2) = old_col(1)-1;
            end
            cnt=cnt+1;
            if (cnt == 2)
                continue
            end
        end
    end
    % We have '|' and come from down for both position
    for j = 1:2
        if (strings(row(j),col(j)) == '|' && old_row(j) > row(j))
            % Find '|'
            [tmp_row,~] = find(strings(row(j)-1,col(j)) == '|' || ...
                strings(row(j)-1,col(j)) == '7' || ...
                strings(row(j)-1,col(j)) == 'F' || ...
                strings(row(j)-1,col(j)) == 'S');
            % If we have one we need one more
            if (length(tmp_row) == 1)
                old_row(j) = row(j); old_col(j) = col(j);
                new_row(j) = row(j)-1;
                cnt=cnt+1;
            end
        end
    end
    % We have '|' and come from up for both position
    for j = 1:2
        if (strings(row(j),col(j)) == '|' && old_row(j) < row(j))
            % Find '|'
            [tmp_row,~] = find(strings(row(j)+1,col(j)) == '|' || ...
                strings(row(j)+1,col(j)) == 'L' || ...
                strings(row(j)+1,col(j)) == 'J' || ...
                strings(row(j)+1,col(j)) == 'S');
            % If we have one we need one more
            if (length(tmp_row) == 1)
                old_row(j) = row(j); old_col(j) = col(j);
                new_row(j) = row(j)+1;
                cnt=cnt+1;
            end
        end
    end
    % We have '-' and come from left for both position
    if (cnt == 2)
    else
        for j = 1:2
            if (strings(row(j),col(j)) == '-' && old_col(j) < col(j))
                % Find '|'
                [tmp_row,~] = find(strings(row(j),col(j)+1) == '-' || ...
                    strings(row(j),col(j)+1) == '7' || ...
                    strings(row(j),col(j)+1) == 'J' || ...
                    strings(row(j),col(j)+1) == 'S');
                % If we have one we need one more
                if (length(tmp_row) == 1)
                    old_col(j) = col(j); old_row(j) = row(j);
                    new_col(j) = col(j)+1;
                    cnt=cnt+1;
                end
            end
        end
    end
    % We have '-' and come from right for both position
    if (cnt == 2)
    else
        for j = 1:2
            if (strings(row(j),col(j)) == '-' && old_col(j) > col(j))
                % Find '|'
                [tmp_row,~] = find(strings(row(j),col(j)-1) == '-' || ...
                    strings(row(j),col(j)-1) == 'F' || ...
                    strings(row(j),col(j)-1) == 'L' || ...
                    strings(row(j),col(j)-1) == 'S');
                % If we have one we need one more
                if (length(tmp_row) == 1) 
                    old_col(j) = col(j); old_row(j) = row(j);
                    new_col(j) = col(j)-1;
                    cnt=cnt+1;
                end
            end
        end
    end
    % We have 'L' and come from right for both position
    if (cnt == 2)
    else
        for j = 1:2
            if (strings(row(j),col(j)) == 'L' && old_col(j) > col(j))
                % Find '|'
                [tmp_row,~] = find(strings(row(j)-1,col(j)) == '|' || ...
                    strings(row(j)-1,col(j)) == '7' || ...
                    strings(row(j)-1,col(j)) == 'F' || ...
                    strings(row(j)-1,col(j)) == 'S');
                % If we have one we need one more
                if (length(tmp_row) == 1)
                    old_row(j) = row(j); old_col(j) = col(j);
                    new_row(j) = row(j)-1;
                    cnt=cnt+1;
                end
            end
        end
    end
    % We have 'L' and come from up for both position
    if (cnt == 2)
    else
        for j = 1:2
            if (strings(row(j),col(j)) == 'L' && old_row(j) < row(j))
                % Find '|'
                [tmp_row,~] = find(strings(row(j),col(j)+1) == '-' || ...
                    strings(row(j),col(j)+1) == '7' || ...
                    strings(row(j),col(j)+1) == 'J' || ...
                    strings(row(j),col(j)+1) == 'S');
                % If we have one we need one more
                if (length(tmp_row) == 1)
                    old_col(j) = col(j); old_row(j) = row(j);
                    new_col(j) = col(j)+1;
                    cnt=cnt+1;
                end
            end
        end
    end
    % We have 'J' and come from left for both position
    if (cnt == 2)
    else
        for j = 1:2
            if (strings(row(j),col(j)) == 'J' && old_col(j) < col(j))
                % Find '|'
                [tmp_row,~] = find(strings(row(j)-1,col(j)) == '|' || ...
                    strings(row(j)-1,col(j)) == '7' || ...
                    strings(row(j)-1,col(j)) == 'F' || ...
                    strings(row(j)-1,col(j)) == 'S');
                % If we have one we need one more
                if (length(tmp_row) == 1)
                    old_row(j) = row(j); old_col(j) = col(j);
                    new_row(j) = row(j)-1;
                    cnt=cnt+1;
                end
            end
        end
    end
    % We have 'J' and come from up for both position
    if (cnt == 2)
    else
        for j = 1:2
            if (strings(row(j),col(j)) == 'J' && old_row(j) < row(j))
                % Find '|'
                [tmp_row,~] = find(strings(row(j),col(j)-1) == '-' || ...
                    strings(row(j),col(j)-1) == 'F' || ...
                    strings(row(j),col(j)-1) == 'L' || ...
                    strings(row(j),col(j)-1) == 'S');
                % If we have one we need one more
                if (length(tmp_row) == 1)
                    old_col(j) = col(j); old_row(j) = row(j);
                    new_col(j) = col(j)-1;
                    cnt=cnt+1;
                end
            end
        end
    end
    % We have '7' and come from left for both position
    if (cnt == 2)
    else
        for j = 1:2
            if (strings(row(j),col(j)) == '7' && old_col(j) < col(j))
                % Find '|'
                [tmp_row,~] = find(strings(row(j)+1,col(j)) == '|' || ...
                    strings(row(j)+1,col(j)) == 'L' || ...
                    strings(row(j)+1,col(j)) == 'J' || ...
                    strings(row(j)+1,col(j)) == 'S');
                % If we have one we need one more
                if (length(tmp_row) == 1)
                    old_row(j) = row(j); old_col(j) = col(j);
                    new_row(j) = row(j)+1;
                    cnt=cnt+1;
                end
            end
        end
    end
    % We have '7' and come from down for both position
    if (cnt == 2)
    else
        for j = 1:2
            if (strings(row(j),col(j)) == '7' && old_row(j) > row(j))
                % Find '|'
                [tmp_row,~] = find(strings(row(j),col(j)-1) == '-' || ...
                    strings(row(j),col(j)-1) == 'F' || ...
                    strings(row(j),col(j)-1) == 'L' || ...
                    strings(row(j),col(j)-1) == 'S');
                % If we have one we need one more
                if (length(tmp_row) == 1)
                    old_col(j) = col(j); old_row(j) = row(j);
                    new_col(j) = col(j)-1;
                    cnt=cnt+1;
                end
            end
        end
    end
    % We have 'F' and come from right for both position
    if (cnt == 2)
    else
        for j = 1:2
            if (strings(row(j),col(j)) == 'F' && old_col(j) > col(j))
                % Find '|'
                [tmp_row,~] = find(strings(row(j)+1,col(j)) == '|' || ...
                    strings(row(j)+1,col(j)) == 'L' || ...
                    strings(row(j)+1,col(j)) == 'J' || ...
                    strings(row(j)+1,col(j)) == 'S');
                % If we have one we need one more
                if (length(tmp_row) == 1)
                    old_row(j) = row(j); old_col(j) = col(j);
                    new_row(j) = row(j)+1;
                    cnt=cnt+1;
                end
            end
        end
    end
    % We have 'F' and come from down for both position
    if (cnt == 2)
    else
        for j = 1:2
            if (strings(row(j),col(j)) == 'F' && old_row(j) > row(j))
                % Find '|'
                [tmp_row,~] = find(strings(row(j),col(j)+1) == '-' || ...
                    strings(row(j),col(j)+1) == '7' || ...
                    strings(row(j),col(j)+1) == 'J' || ...
                    strings(row(j),col(j)+1) == 'S');
                % If we have one we need one more
                if (length(tmp_row) == 1)
                    old_col(j) = col(j); old_row(j) = row(j);
                    new_col(j) = col(j)+1;
                    cnt=cnt+1;
                end
            end
        end
    end
    % We set the current row now
    row = new_row;
    col = new_col;
    i=i+1;
    if (strings(row(1),col(1)) == 'S' && i>3)
        strings(row(1),col(1));
        strings(row(2),col(2));
        break
    end
    strings_stored(i,1) = strings(row(1),col(1));
    strings_stored(i,2) = strings(row(2),col(2));
end
% |7FJFL7||||JL|||7F|||||JFL7JFL7|JF|JL|||||||FJ|||||FJ7LFJF-J7L|7F|JFJF|
% ||||L7J--FL-7J-FL--J|FJ||7L|||F

% Result part 1 is half of the iterations
results_part1 = i/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For part 2 we need to check the enclosed tiles by the loop
borders = [min(row_store(:,1)),max(row_store(:,1)), ...
    min(col_store(:,1)),max(col_store(:,1))];

% Draw area enclosed by loop
figure(1)
h = fill(row_store(:,1),col_store(:,1),'b');
hold on
% Save X and Y data of the pixels that enclose the area
rows_filled = h.XData;
cols_filled = h.YData;

% Now we need to check for every character of our input if it is enclosed
% in the filled area
enclosed = 0;
for i = 1:length(strings(:,1))
    % Loop through rows
    for j = 1:length(strings(1,:))
        % Loop through columns
        % Check if it is enclosed 
        % Find enclosed points 
        [in,on] = inpolygon(i,j,rows_filled,cols_filled);
        enclosed = enclosed + (in-on);
    end
end
results_part2 = enclosed;
