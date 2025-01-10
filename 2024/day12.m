clc; clearvars;
% Advent of code 2024 - day 12 - part 1+2
% Open file and take needed data
file_id = fopen("day12.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
[x,y] = size(data{1,1});
for i = 1:x
    garden(i,:) = data{1,1}{i,1};
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need find groups of "plants" and calculate area and perimeter
% to get a price estimate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0;
plants = '';

% Get different plant types
for i = 1:length(garden(:,1))
    [x,y] = regexp(garden(i,:),'[A-Z]','match','split');
    plants(end+1:end+length(x)) = [x{1,:}];
end
plants = unique(plants);
% Now for each group find all the positions
for i = 1:length(plants)
    [rows,cols] = find(garden==plants(i));
    % Now I have to define groups, find area and perimeter
    % Let's try to do it all in another loop
    pos = [];
    for j = 1:length(rows)
        % Check if we have neighbours from the same plant
        % If we already did one check, make sure we are not in the previous
        % group
        if (j>1)
            if (sum(pos(:,1) == rows(j) & pos(:,2) == cols(j))>0)
                continue
            end
        end
        [perimeter,pos_tmp] = ...
            getgroups(garden,plants(i),[rows(j),cols(j)],[rows(j),cols(j)]);
        area = length(pos_tmp(:,1));
        result1 = result1+area*perimeter;
        pos = [pos;pos_tmp];
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need to count sides instead of perimeters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 

% We start from the loop over the plants
for i = 1:length(plants)
    [rows,cols] = find(garden==plants(i));
    % Now I have to define groups, find area and perimeter
    % Let's try to do it all in another loop
    pos = [];
    for j = 1:length(rows)
        % Check if we have neighbours from the same plant
        % If we already did one check, make sure we are not in the previous
        % group
        if (j>1)
            if (sum(pos(:,1) == rows(j) & pos(:,2) == cols(j))>0)
                continue
            end
        end
        [perimeter,pos_tmp] = ...
            getgroups(garden,plants(i),[rows(j),cols(j)],[rows(j),cols(j)]);
        area = length(pos_tmp(:,1));
        % Get sides from pos_tmp
        [sides] = cntSides(pos_tmp);
        result2 = result2+area*sides;
        pos = [pos;pos_tmp];
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc


% Find groups 
function [perimeter,pos] = getgroups(garden,plant,start,pos)
    % Let's go through garden to find the group of connected plants for the
    % current plant type and starting position
    perimeter = 4;
    % Check all directions
    % Check North
    if (start(1,1)>1 && garden(start(1,1)-1,start(1,2)) == plant) 
        % Update perimeter
        perimeter = perimeter-1;
        if(sum(pos(:,1) == start(1,1)-1 & pos(:,2) == start(1,2))==0)
            % We have a connected plant in the North
            pos(end+1,:) = [start(1,1)-1,start(1,2)];
            % Check for next neighbour
            [perimeter_tmp,pos] = getgroups(garden,plant,pos(end,:),pos);
            perimeter = perimeter+perimeter_tmp;
        end
    end
    % Check East
    if (start(1,2)<length(garden(1,:)) && ...
            garden(start(1,1),start(1,2)+1) == plant) 
        % Update perimeter
        perimeter = perimeter-1;
        if (sum(pos(:,1) == start(1,1) & pos(:,2) == start(1,2)+1)==0)
            % We have a connected plant in the North
            pos(end+1,:) = [start(1,1),start(1,2)+1];
            % Check for next neighbour
            [perimeter_tmp,pos] = getgroups(garden,plant,pos(end,:),pos); 
            perimeter = perimeter+perimeter_tmp;
        end
    end
    % Check South
    if (start(1,1)<length(garden(:,1)) && ...
            garden(start(1,1)+1,start(1,2)) == plant) 
        % Update perimeter
        perimeter = perimeter-1;
        if (sum(pos(:,1) == start(1,1)+1 & pos(:,2) == start(1,2))==0)
            % We have a connected plant in the North
            pos(end+1,:) = [start(1,1)+1,start(1,2)];
            % Check for next neighbour
            [perimeter_tmp,pos] = getgroups(garden,plant,pos(end,:),pos); 
            perimeter = perimeter+perimeter_tmp;
        end
    end
    % Check West
    if (start(1,2)>1 && garden(start(1,1),start(1,2)-1) == plant) 
        % Update perimeter
        perimeter = perimeter-1;
        if (sum(pos(:,1) == start(1,1) & pos(:,2) == start(1,2)-1)==0)
            % We have a connected plant in the North
            pos(end+1,:) = [start(1,1),start(1,2)-1];
            % Check for next neighbour
            [perimeter_tmp,pos] = getgroups(garden,plant,pos(end,:),pos);
            perimeter = perimeter+perimeter_tmp;
        end
    end
end

% Count Sides
function [sides] = cntSides(pos)
    % We need to count the sides for our group
    sides = 0;
    % We have 4 sides if all our plants are in one row or column
    if (length(pos(:,1))==1 || length(unique(pos(:,2))) == 1 ... 
        || length(unique(pos(:,1))) == 1)
        sides = 4;
        return
    end
    % Otherwise, we have to scan through
    % Let's sort so we know we go from top to bottom and left to right
    % ################################################################
    % ###################   TOP to BOTTOM   ##########################
    % ################################################################
    pos_org = pos;
    pos = sortrows(pos,[1 2]);
    % And store unique rows
    rows = unique(pos(:,1));
    % Now check from top to bottom to get the top faces
    for i = 1:length(rows)
        % Get the columns for this row
        cols = pos(pos(:,1)==rows(i),2);
        % For the first row we have a special case
        if (i == 1)
            % If all columns are connected we only add one side
            if(all(diff(cols)==1))
                sides = sides+1;
            else
                % Otherwise, we get a side for each separated section
                for j = 1:length(cols)-1
                    if (cols(j+1)-cols(j) > 1)
                        sides = sides+1;
                    end
                end
                % We always have to add an extra one
                sides = sides+1;
            end
        else
            % For all other rows we have to check where the above row
            % does not cover it
            for j=1:length(cols)
                if (~isempty(find(pos(:,1)==rows(i)-1 & ...
                        pos(:,2)==cols(j),1)))
                    % Delete this column later
                    cols(j) = 0;
                end
            end
            cols(cols==0) = [];
            % Now we need to check again if they are separated or not
            if(~all(diff(cols)==1))
                % Otherwise, we get a side for each separated section
                for j = 1:length(cols)-1
                    if (cols(j+1)-cols(j) > 1)
                        sides = sides+1;
                    end
                end
                % We always have to add an extra one
                sides = sides+1;
            % If no entry is left we continue
            elseif(isempty(cols))
                continue
            % If all are in a row or if only one is left we get another
            % side as well
            elseif(all(diff(cols)==1) || length(cols)==1)
                sides = sides+1;
            end
        end
    end
    % ################################################################
    % ###################   BOTTOM to TOP   ##########################
    % ################################################################
    % Now check from bottom to top to get the bottom faces
    for i = length(rows):-1:1
        % Get the columns for this row
        cols = pos(pos(:,1)==rows(i),2);
        % For the first row we have a special case
        if (i == length(rows))
            % If all columns are connected we only add one side
            if(all(diff(cols)==1))
                sides = sides+1;
            else
                % Otherwise, we get a side for each separated section
                for j = 1:length(cols)-1
                    if (cols(j+1)-cols(j) > 1)
                        sides = sides+1;
                    end
                end
                % We always have to add an extra one
                sides = sides+1;
            end
        else
            % For all other rows we have to check where the below row
            % does not cover it
            for j=1:length(cols)
                if (~isempty(find(pos(:,1)==rows(i)+1 & ...
                        pos(:,2)==cols(j),1)))
                    % Delete this column later
                    cols(j) = 0;
                end
            end
            cols(cols==0) = [];
            % Now we need to check again if they are separated or not
            if(~all(diff(cols)==1))
                % Otherwise, we get a side for each separated section
                for j = 1:length(cols)-1
                    if (cols(j+1)-cols(j) > 1)
                        sides = sides+1;
                    end
                end
                % We always have to add an extra one
                sides = sides+1;
            % If no entry is left we continue
            elseif(isempty(cols))
                continue
            % If all are in a row or if only one is left we get another
            % side as well
            elseif(all(diff(cols)==1) || length(cols)==1)
                sides = sides+1;
            end
        end
    end
    % ################################################################
    % ###################   LEFT to RIGHT   ##########################
    % ################################################################
    pos = sortrows(pos_org,[2 1]);
    % Store unique columns
    cols = unique(pos(:,2));
    % Now check from left to right to get the left faces
    for i = 1:length(cols)
        % Get the rows for this column
        rows = pos(pos(:,2)==cols(i),1);
        % For the first column we have a special case
        if (i == 1)
            % If all rows are connected we only add one side
            if(all(diff(rows)==1))
                sides = sides+1;
            else
                % Otherwise, we get a side for each separated section
                for j = 1:length(rows)-1
                    if (rows(j+1)-rows(j) > 1)
                        sides = sides+1;
                    end
                end
                % We always have to add an extra one
                sides = sides+1;
            end
        else
            % For all other columns we have to check where the left column
            % does not cover it
            for j=1:length(rows)
                if (~isempty(find(pos(:,2)==cols(i)-1 & ...
                        pos(:,1)==rows(j),1)))
                    % Delete this column later
                    rows(j) = 0;
                end
            end
            rows(rows==0) = [];
            % Now we need to check again if they are separated or not
            if(~all(diff(rows)==1))
                % Otherwise, we get a side for each separated section
                for j = 1:length(rows)-1
                    if (rows(j+1)-rows(j) > 1)
                        sides = sides+1;
                    end
                end
                % We always have to add an extra one
                sides = sides+1;
            % If no entry is left we continue
            elseif(isempty(rows))
                continue
            % If all are in a row or if only one is left we get another
            % side as well
            elseif(all(diff(rows)==1) || length(rows)==1)
                sides = sides+1;
            end
        end
    end
    % ################################################################
    % ###################   RIGHT to LEFT   ##########################
    % ################################################################
    % Now check from right to left to get the right faces
    for i = length(cols):-1:1
        % Get the rows for this column
        rows = pos(pos(:,2)==cols(i),1);
        % For the first column we have a special case
        if (i == length(cols))
            % If all rows are connected we only add one side
            if(all(diff(rows)==1))
                sides = sides+1;
            else
                % Otherwise, we get a side for each separated section
                for j = 1:length(rows)-1
                    if (rows(j+1)-rows(j) > 1)
                        sides = sides+1;
                    end
                end
                % We always have to add an extra one
                sides = sides+1;
            end
        else
            % For all other columns we have to check where the right column
            % does not cover it
            for j=1:length(rows)
                if (~isempty(find(pos(:,2)==cols(i)+1 & ...
                        pos(:,1)==rows(j),1)))
                    % Delete this column later
                    rows(j) = 0;
                end
            end
            rows(rows==0) = [];
            % Now we need to check again if they are separated or not
            if(~all(diff(rows)==1))
                % Otherwise, we get a side for each separated section
                for j = 1:length(rows)-1
                    if (rows(j+1)-rows(j) > 1)
                        sides = sides+1;
                    end
                end
                % We always have to add an extra one
                sides = sides+1;
            % If no entry is left we continue
            elseif(isempty(rows))
                continue
            % If all are in a row or if only one is left we get another
            % side as well
            elseif(all(diff(rows)==1) || length(rows)==1)
                sides = sides+1;
            end
        end
    end
end
