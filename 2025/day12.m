clc; clearvars;
% Advent of code 2025 - day 12 - part 1+2
% Open file and take needed data
file_id = fopen("day12.dat");
data = textscan(file_id,'%s','delimiter','\n');
% Close file
fclose(file_id);

% First, rearrange that weird data 
data = data{1,1};
% We need the empty rows 
[r,~] = find(ismember(data(:,1),''));
presents{1,length(r)} = ['...';'...';'...'];
% Store presents
for i = 1:length(r)
    if (i==1)
        presents{1,i} = data(2:r(i)-1,1);
    else
        presents{1,i} = data(r(i-1)+2:r(i)-1,1);
    end
end
% Now store regions and numbers of presents
[c2,~] = find(data{r(end)+1,1}(:)==' ');
regions = zeros(size(data,1)-r(end),2);
numbers = zeros(size(data,1)-r(end),length(c2));
j = 1;
for i = r(end)+1:size(data,1)
    % Regions
    [cx,~] = find(data{i,1}(:)=='x');
    regions(j,1) = str2double(data{i,1}(1:cx-1));
    [cc,~] = find(data{i,1}(:)==':');
    regions(j,2) = str2double(data{i,1}(cx+1:cc-1));
    % Numbers of presents
    [c2,~] = find(data{i,1}(:)==' ');
    for k=1:length(c2)
        if (k<length(c2))
            numbers(j,k) = str2double(data{i,1}(c2(k)+1:c2(k+1)-1));
        else
            numbers(j,k) = str2double(data{i,1}(c2(k)+1:end));
        end
    end
    j=j+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find all the region - number combinations that work
% out
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% We pretty much have to try all options - not all, but find the most
% compact and see if it would fit
result1 = 0;
% Go through each region
for i = 1:size(regions,1)
    % Calculate fitting blocks without overlaps and number of presents
    fitting_bocks = regions(i,1)/3*regions(i,2)/3;
    n_presents = sum(numbers(i,:));
    % If the first is larger or equal to the latter it works
    if (fitting_bocks >= n_presents)
        result1 = result1+1;
    else
        % Check DFS (with max of 1000 calls)
        % First build a corresponding map
        map = '.';
        map(1:regions(i,1),1:regions(i,2)) = '.';
        [cnt,map_tmp,~] = placePresentsDFS(map,numbers(i,:),presents,1,1);
        if (cnt==1)
            result1 = result1+1;
        end
    end
end

% 440
fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deph-first search for part 1
function [cnt,map,calls] = placePresentsDFS(map,numbers,presents,n,calls)
    % Initialize
    cnt = 0;
    np = 0;
    % Determine present from n
    i = 1;
    while np==0
        tmp = sum(numbers(1:i));
        if (tmp>=n)
            np = i;
        end
        i=i+1;
    end
    % Get present separated
    for i=1:size(presents{1,1},1)
        pres(i,:) = presents{1,np}{i,1};
    end
    % We need to try in all rotations
    % And we need to put as many presents as indicated in numbers
    for j = 1:4
        % Rotate if i>1
        if (j>1)
            pres = rot90(pres);
        end
        % Place present on all possible positions on the map
        [rowp,colp] = find(pres == '#');
        % Loop of vertical starting positions
        for row = 1:size(map,1)-max(rowp)+1
            % Loop over horizontal starting positions
            for col = 1:size(map,2)-max(colp)+1
                % Finally, place the present
                % Get indices
                idx = sub2ind(size(map),rowp+row-1,colp+col-1);
                if (any(map(idx)=='#'))
                    % Can't place it here
                else
                    map(idx) = '#';
                    % Check if we have to place another present
                    if (n+1 > sum(numbers))
                        % We placed all presents
                        cnt = 1;
                        return 
                    else
                        % Keep placing presents
                        [cnt,map_tmp,calls] = placePresentsDFS(map,numbers, ...
                            presents,n+1,calls);
                        if (cnt==1 || calls>10)
                            map = map_tmp;
                            return 
                        end
                        calls = calls+1;
                    end
                    % Remove placed present again
                    map(idx) = '.';
                end
            end % Horizontal loop
        end % Vertical loop
    end % Rotation loop
end