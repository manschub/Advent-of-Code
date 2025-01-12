clc; clearvars;
% Advent of code 2022 - day 5 - part 1+2
% Open file and take needed data
% First file - crate arrangement at the beginning
file_id = fopen("day5_1.dat");
data = textscan(file_id,strcat('%s %s %s %s %s %s %s %s %s'), ...
    'Delimiter','[] ','MultipleDelimsAsOne',true);
% Close file
fclose(file_id);

% Build the crate arrangements (flipped)
k = 1;
for i = length(data{1,1}(:,1))-1:-1:1
    for j = 1:9
        if (data{1,j}{i,1}=='0')
            struct(k,j) = ' ';
        elseif (isempty(data{1,j}{i,1}))
            break
        else
            struct(k,j) = data{1,j}{i,1}; 
        end
    end
    k = k+1;
end
% Make sure we have enough space even if all crates are in one column
struct(end+1:end+60,:) = ' '; 
struct_ini = struct;
% Second file - movements
file_id = fopen("day5_2.dat");
data2 = textscan(file_id,strcat('%f %f %f'), ...
    'Delimiter','movefromto ','MultipleDelimsAsOne',true);
% Close file
fclose(file_id);

moves = [data2{1,1},data2{1,2},data2{1,3}];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We have to reorder crates with the given move sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Go through moves
for i = 1:length(moves(:,1))
    % Perform current move
    for j = 1:moves(i,1)
        % Move as many crates as specified in first column of moves
        % Get the highest crate, i.e. the current one to move
        [r,~] = find(struct(:,moves(i,2))~=' ');
        % Get position to which the crate is moved 
        [r2,~] = find(struct(:,moves(i,3))==' ');
        struct(min(r2),moves(i,3)) = struct(max(r),moves(i,2));
        struct(max(r),moves(i,2)) = ' ';
    end
end

% The result is a concatenation of all highest crates
result1 = '';
for i = 1:length(struct(1,:))
    % Get the highest crate for current stack
    [r,~] = find(struct(:,i)~=' ');
    result1 = [result1,struct(max(r),i)];
end

fprintf('%s',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Same but now the crane moves all crates at once
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
struct = struct_ini;
% Go through moves
for i = 1:length(moves(:,1))
    % Perform current move - all crates are moved at once
    % Move as many crates as specified in first column of moves
    % Get the highest crate, i.e. the current one to move
    [r,~] = find(struct(:,moves(i,2))~=' ');
    % Get position to which the crates are moved 
    [r2,~] = find(struct(:,moves(i,3))==' ');
    struct(min(r2):min(r2)+moves(i,1)-1,moves(i,3)) = ...
        struct(max(r)-moves(i,1)+1:max(r),moves(i,2));
    struct(max(r)+1-moves(i,1):max(r),moves(i,2)) = ' ';
end

% The result is a concatenation of all highest crates
result2 = '';
for i = 1:length(struct(1,:))
    % Get the highest crate for current stack
    [r,~] = find(struct(:,i)~=' ');
    result2 = [result2,struct(max(r),i)];
end

fprintf('%s',result2)
fprintf('\n')
toc

