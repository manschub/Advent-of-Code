clc; clear all;
% Advent of code 2023 - day 18 - part 1+2
% Open file and take needed data
file_id = fopen("day18.dat");
data = textscan(file_id,strcat('%s %f %s'),'delimiter',' ()','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Rearrange data to be handled nicer
directions_tmp = data{1,1};
color_tmp = data{1,3};
for i = 1:length(directions_tmp)
    directions(i,1) = directions_tmp{i,1};
    color(i,:) = color_tmp{i,1};
end
steps = data{1,2};

part1 = 0;

if (part1 == 1)
    % Generate the strings map
    map(1:length(steps),1:length(steps)) = '.';
    row = 1; col = 1;
    row = length(steps)/2; col = length(steps)/2;
    map(row,col) = '#';
    row_store = row; col_store = col;
    % We need to dig out from the top right following the directions
    for i = 1:length(steps)
        if (directions(i) == 'R')
            map(row,col:col+steps(i)) = '#';
            row_store(end+1:end+steps(i)) = row;
            col_store(end+1:end+steps(i)) = col+1:col+steps(i);
            col = col+steps(i);
        elseif (directions(i) == 'U')
            map(row-steps(i):row,col) = '#';
            row_store(end+1:end+steps(i)) = row-1:-1:row-steps(i);
            col_store(end+1:end+steps(i)) = col;
            row = row-steps(i);
        elseif (directions(i) == 'L')
            map(row,col-steps(i):col) = '#';
            row_store(end+1:end+steps(i)) = row;
            col_store(end+1:end+steps(i)) = col-1:-1:col-steps(i);
            col = col-steps(i);
        elseif (directions(i) == 'D')
            map(row:row+steps(i),col) = '#';
            row_store(end+1:end+steps(i)) = row+1:row+steps(i);
            col_store(end+1:end+steps(i)) = col;
            row = row+steps(i);
        end
    end
    
    % Draw area enclosed by loop
    figure(1)
    h = fill(row_store(1:1000:end),col_store(1:1000:end),'b');
    hold on
    % % Save X and Y data of the pixels that enclose the area
    rows_filled = h.XData;
    cols_filled = h.YData;
    enclosed = 0;
    for i = 1:length(map(:,1))
        % Loop through rows
        for j = 1:length(map(1,:))
            % Loop through columns
            % Check if it is enclosed 
            % Find enclosed points 
            [in,on] = inpolygon(i,j,rows_filled,cols_filled);
            enclosed = enclosed + max(in,on);
        end
    end
    result_part1 = enclosed;
    fprintf('%10f',result_part1)
    fprintf('\n')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert hex to new instructions
for i = 1:length(color(:,1))
    steps_new(i,1) = hex2dec(color(i,2:end-1));
    if (color(i,end) == '0')
        directions_new(i,1) = 'R';
    elseif (color(i,end) == '1')
        directions_new(i,1) = 'D';
    elseif (color(i,end) == '2')
        directions_new(i,1) = 'L';
    elseif (color(i,end) == '3')
        directions_new(i,1) = 'U';
    end
end
directions = directions_new;
steps = steps_new;

% Generate the strings map
row = 1; col = 1;
% row = length(steps)/2; col = length(steps)/2;
row_store = row; col_store = col;
% We need to dig out from the top right following the directions
for i = 1:length(steps)
    if (directions(i) == 'R')
%         map(row,col:col+steps(i)) = '#';
        row_store(end+1:end+steps(i)) = row;
        col_store(end+1:end+steps(i)) = col+1:col+steps(i);
        col = col+steps(i);
    elseif (directions(i) == 'U')
%         map(row-steps(i):row,col) = '#';
        row_store(end+1:end+steps(i)) = row-1:-1:row-steps(i);
        col_store(end+1:end+steps(i)) = col;
        row = row-steps(i);
    elseif (directions(i) == 'L')
%         map(row,col-steps(i):col) = '#';
        row_store(end+1:end+steps(i)) = row;
        col_store(end+1:end+steps(i)) = col-1:-1:col-steps(i);
        col = col-steps(i);
    elseif (directions(i) == 'D')
%         map(row:row+steps(i),col) = '#';
        row_store(end+1:end+steps(i)) = row+1:row+steps(i);
        col_store(end+1:end+steps(i)) = col;
        row = row+steps(i);
    end
end

% Result is the enclosed area plus half the sum of the total steps
result_part2 = polyarea(row_store,col_store)+sum(steps_new/2)+1;

fprintf('%10f',result_part2)
fprintf('\n')

