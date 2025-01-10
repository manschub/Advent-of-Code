clc; clearvars;
% Advent of code 2024 - day 11 - part 1+2
% Open file and take needed data
file_id = fopen("day11.dat");
data = textscan(file_id,strcat('%f %f %f %f %f %f %f %f'));
% Close file
fclose(file_id);

% Reorganize data
stones = [data{1,:}];
stones2 = stones;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We have a specific number of blinks and need to change stones as
% specified by the rules:
% If stone has number 0, it is replaced by a stone with number 1.
% If stone has a number that has an even number of digits, it is replaced 
%   by two stones. The left half of the digits are engraved on the new left 
%   stone, and the right half of the digits are engraved on the new right 
%   stone. (The new numbers don't keep extra leading zeroes)
% If none of the other rules apply, the stone is replaced by a new stone; 
%   the old stone's number multiplied by 2024 is engraved on the new stone.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Specify number of blinks
blinks = 25;

% Iterate over blinks
for i = 1:blinks
    % Can we do it without checking each stone? We have three categories
    % We take care of rule 1
    stones_tmp = stones;
    stones_tmp(stones==0) = 1;
    % Rule 3
    [~,idx] = find((stones>0&stones<10)|(stones>99&stones<1000)| ...
        (stones>9999&stones<100000)|(stones>999999&stones<10000000) ...
        | (stones>9999&stones<100000)|(stones>999999&stones<10000000) ...
        |(stones>99999999&stones<1000000000) ...
        |(stones>9999999999&stones<100000000000) ...
        |(stones>999999999999&stones<10000000000000));
    stones_tmp(idx) = stones(idx).*2024;
    % Rule 2 (How to vectorize this shite? Let's see)
    [~,idx] = find((stones>9&stones<100));
    % First part of number
    stones_tmp(idx) = floor(stones(idx)/1e1);
    % Second part of number
    stones_tmp(end+1:end+length(idx)) = mod(stones(idx),1e1);
    % Again one order higher
    [~,idx] = find((stones>999&stones<1e4));
    if (~isempty(idx))
        % First part of number
        stones_tmp(idx) = floor(stones(idx)/1e2);
        % Second part of number
        stones_tmp(end+1:end+length(idx)) = mod(stones(idx),1e2);
    end
    % Again one order higher
    [~,idx] = find((stones>99999&stones<1e6));
    if (~isempty(idx))
        % First part of number
        stones_tmp(idx) = floor(stones(idx)/1e3);
        % Second part of number
        stones_tmp(end+1:end+length(idx)) = mod(stones(idx),1e3);
    end
    % Again one order higher
    [~,idx] = find((stones>9999999&stones<1e8));
    if (~isempty(idx))
        % First part of number
        stones_tmp(idx) = floor(stones(idx)/1e4);
        % Second part of number
        stones_tmp(end+1:end+length(idx)) = mod(stones(idx),1e4);
    end
    % Again one order higher
    [~,idx] = find((stones>999999999&stones<1e10));
    if (~isempty(idx))
        % First part of number
        stones_tmp(idx) = floor(stones(idx)/1e5);
        % Second part of number
        stones_tmp(end+1:end+length(idx)) = mod(stones(idx),1e5);
    end
    % Again one order higher
    [~,idx] = find((stones>99999999999&stones<1e12));
    if (~isempty(idx))
        % First part of number
        stones_tmp(idx) = floor(stones(idx)/1e6);
        % Second part of number
        stones_tmp(end+1:end+length(idx)) = mod(stones(idx),1e6);
    end
    % Merge
    stones = stones_tmp;
end

result1 = length(stones);

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - We need to do 75 blinks which will not work with the brute-force
% method from before
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Specify number of blinks
blinks = 75; 

% We need the cnt of each number once
[S, istones, iS] = unique(stones2,'sorted');
S_counts = accumarray(iS,1);
stone_cts = [S', S_counts];

% Let's try to be smart
for i = 1:blinks
    stone_tmp_cts = [];
    % Now we can go through the condensed array (which is MUCH smaller) and
    % apply rules to update the cts
    for j = 1:length(stone_cts(:,1))
        % Check Rule 1
        if (stone_cts(j,1) == 0)
            % Check if we have that entry already
            if (isempty(stone_tmp_cts))
                row = [];
            else
                [row,~] = find(stone_tmp_cts(:,1) == 1);
            end
            if (~isempty(row))
                % We have the entry so we just increment
                stone_tmp_cts(row,2) = stone_tmp_cts(row,2)+stone_cts(j,2);
            else
                % We need new entry
                stone_tmp_cts(end+1,1) = 1;
                stone_tmp_cts(end,2) = stone_cts(j,2);
            end

        % Check rule 2
        elseif (mod(numel(num2str(stone_cts(j,1))),2)==0)
            % We split stones in two with first part of the digits left
            % and right part right
            tmp = num2str(stone_cts(j,1));
            % Check if we have that entry already
            if (isempty(stone_tmp_cts))
                row = [];
            else
                [row,~] = find(stone_tmp_cts(:,1) == ...
                    str2double(tmp(1:numel(tmp)/2)));
            end
            if (~isempty(row))
                % We have the entry so we just increment
                stone_tmp_cts(row,2) = stone_tmp_cts(row,2)+stone_cts(j,2);
            else
                % We need new entry
                stone_tmp_cts(end+1,1) = str2double(tmp(1:numel(tmp)/2));
                stone_tmp_cts(end,2) = stone_cts(j,2);
            end
            if (isempty(stone_tmp_cts))
                row = [];
            else
                [row,~] = find(stone_tmp_cts(:,1) == ...
                    str2double(tmp(numel(tmp)/2+1:end)));
            end
            if (~isempty(row))
                % We have the entry so we just increment
                stone_tmp_cts(row,2) = stone_tmp_cts(row,2)+stone_cts(j,2);
            else
                % We need new entry
                stone_tmp_cts(end+1,1) = str2double(tmp(numel(tmp)/2+1:end));
                stone_tmp_cts(end,2) = stone_cts(j,2);
            end
        else
            % Stone is multiplied by 2024
            % Check if we have that entry already
            if (isempty(stone_tmp_cts))
                row = [];
            else
                [row,~] = find(stone_tmp_cts(:,1) == stone_cts(j,1)*2024);
            end
            if (~isempty(row))
                % We have the entry so we just increment
                stone_tmp_cts(row,2) = stone_tmp_cts(row,2)+stone_cts(j,2);
            else
                stone_tmp_cts(end+1,1) = stone_cts(j,1)*2024;
                stone_tmp_cts(end,2) = stone_cts(j,2);
            end
        end
    end
    stone_cts = stone_tmp_cts;
end
result2 = sum(stone_cts(:,2));

fprintf('%10f',result2)
fprintf('\n')
toc
