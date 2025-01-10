clc; clearvars;
% Advent of code 2024 - day 5 - part 1+2
% Open file and take needed data
file_id = fopen("day5.dat");
data = textscan(file_id,strcat('%d %d'),'delimiter','|','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);
file_id = fopen("day5_2.dat");
data2 = textscan(file_id,strcat('%d %d %d %d %d %d %d %d %d %d %d %d %d', ...
    '%d %d %d %d %d %d %d %d %d %d'),'delimiter',',','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% If something like day 3 again use regexp
% (https://de.mathworks.com/help/matlab/ref/regexp.html)

% Reorganize data
rules(:,1) = data{1,1}(:);
rules(:,2) = data{1,2}(:);

updates(:,1) = data2{1,1}(:);
for i = 2:length(data2)
    if(max(data2{1,i})==0)
        break
    end
    updates(:,i) = data2{1,i}(:);
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to check planned upgrades for applying the rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0; incorrect = [];

% Go through upgrades
[x,y] = size(updates);
for i = 1:x
    valid = 1;
    % Go through single digits
    for j = 1:y
        if (updates(i,j) == 0)
            continue
        end
        [rows1,~] = find(rules(:,1) == updates(i,j));
        % Now check if rules is applied correctly
        for k = 1:length(rows1)
            % Number in row1 has to be before number in row2
            [~,cols1] = find(updates(i,:) == rules(rows1(k),1));
            [~,cols2] = find(updates(i,:) == rules(rows1(k),2));
            if(isempty(cols2)==1||isempty(cols1)==1)
                valid = 1;
            elseif (cols1<cols2)
                valid = 1;
            else
                valid = 0;
                break
            end
        end
        if (valid == 0)
            incorrect(end+1) = i;
            break
        end
    end
    % If we have correct instructions we get the middle number and add them
    if (valid==1)
        tmp = updates(i,updates(i,:)~=0);
        mid = updates(i,ceil(length(tmp)/2));
        result1 = result1 + mid;
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Correct incorrect ones and then add middle numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 

% They are stored in "incorrect"
updates = updates(incorrect,:);

% We do the same as in part 1, but reorder the numbers were the checks fail
% and in this way get close to the solution
% Go through upgrades
[x,y] = size(updates);
i = 1;
while (i <= x)
    valid = 1;
    % Go through single digits
    for j = 1:y
        if (updates(i,j) == 0)
            continue
        end
        [rows1,~] = find(rules(:,1) == updates(i,j));
        % Now check if rules are applied correctly
        for k = 1:length(rows1)
            % Number in row1 has to be before number in row2
            [~,cols1] = find(updates(i,:) == rules(rows1(k),1));
            [~,cols2] = find(updates(i,:) == rules(rows1(k),2));
            if(isempty(cols2)==1||isempty(cols1)==1)
                valid = 1;
            elseif (cols1<cols2)
                valid = 1;
            else
                % If we are here we have a wrong order so we exchange the
                % numbers we are comparing
                tmp = updates(i,j-1);
                updates(i,j-1) = updates(i,j);
                updates(i,j) = tmp;
                valid = 0;
                break
            end
        end
        if (valid == 0)
            incorrect(end+1) = i;
            break
        end
    end
    % If we have correct instructions we get the middle number and add them
    if (valid==1)
        tmp = updates(i,updates(i,:)~=0);
        mid = updates(i,ceil(length(tmp)/2));
        result2 = result2 + mid;
        i = i+1;
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc

