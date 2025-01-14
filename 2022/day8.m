clc; clearvars;
% Advent of code 2022 - day 8 - part 1+2
% Open file and take needed data
file_id = fopen("day8.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Rearrange data into a map of numbers
trees = [];
% Go through rows
for i = 1:length(data{1,1})
    % Go through columns
    for j = 1:length(data{1,1}{i,1}(:))
        trees(i,j) = str2double(data{1,1}{i,1}(j));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We have a map of tress with heights and need to say how many of
% them are visible
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Go through trees
% We can already add all the trees on the edge as visible
result1 = length(trees(:,1))*2 + (length(trees(1,:))-2)*2;
% For the rest we go through each tree
for i = 2:length(trees(:,1))-1
    for j = 2:length(trees(1,:))-1
        % Now check for the ith,jth tree if it is visible from any
        % direction
        if (all(trees(1:i-1,j)<trees(i,j)) || all(trees(i,1:j-1)<trees(i,j)) ...
         || all(trees(i+1:end,j)<trees(i,j)) || all(trees(i,j+1:end)<trees(i,j)))
            % Visible from up, left, down or right
            result1 = result1+1;
        end
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need to calculate the scenic score instead for each tree
% (number of trees visible in the four directions)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 

scenic_score = 0;
% Go through trees
for i = 1:length(trees(:,1))
    for j = 1:length(trees(1,:))
        % Now calculate the number of trees visible in each direction
        % Towards the left
        [~,c] = find(trees(i,:) >= trees(i,j));
        if (isempty(max(c(c<j))))
            tmp1 = j-1;
        else
            tmp1 = j-max(c(c<j));
        end
        % Towards the top
        [r,~] = find(trees(:,j) >= trees(i,j));
        if (isempty(max(r(r<i))))
            tmp2 = i-1;
        else
            tmp2 = i-max(r(r<i));
        end
        % Towards the right
        [~,c] = find(trees(i,:) >= trees(i,j));
        if (isempty(min(c(c>j))))
            tmp3 = length(trees(:,1))-j;
        else
            tmp3 = min(c(c>j))-j;
        end
        % Towards the bottom
        [r,~] = find(trees(:,j) >= trees(i,j));
        if (isempty(min(r(r>i))))
            tmp4 = length(trees(1,:))-i;
        else
            tmp4 = min(r(r>i))-i;
        end
        % Check if we found a higher scenic score
        if (tmp1*tmp2*tmp3*tmp4 > scenic_score)
            scenic_score = tmp1*tmp2*tmp3*tmp4;
        end
    end
end

result2 = scenic_score;

fprintf('%10f',result2)
fprintf('\n')
toc

