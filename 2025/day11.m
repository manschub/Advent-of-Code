clc; clearvars;
% Advent of code 2025 - day 11 - part 1+2
% Open file and take needed data
file_id = fopen("day11.dat");
data = textscan(file_id,'%s','delimiter','\n');
% Close file
fclose(file_id);

% First, rearrange data 
data = data{1,1};
in(size(data,1),:) = "123";
out(size(data,1),:) = "123";
for i = 1:size(data,1)
    tmp = regexp(data{i,1},':','split');
    in(i,1) = tmp(1,1);
    [c,~] = find(tmp{1,2}(:)==' ');
    for j = 1:length(c)
        out(i,j) = tmp{1,2}(c(j)+1:c(j)+3);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find all possible ways to "out"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% I guess we can do a Breadth-first search again
[cnt] = followConnection(in,out);
result1 = cnt;

% 782
fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we to start from "svr" and need to pass "dac" and "fft"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% I guess we can do a Breadth-first search again
[cnt] = followConnection2(in,out);
result2 = cnt;
% 401398751986160
fprintf('%10f',result2)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Breadth-first search for part1
function [cnt] = followConnection(in,out)
    % Initialize
    cnt = 0;
    % Find start "you"
    idx = find(ismember(in, 'you'));
    if (isempty(idx))
        return
    end
    % Fill initial todo
    for i = 1:size(out(idx,:),2)
        if (ismissing(out(idx,i)))
            continue
        else
            todo(i,1) = out(idx,i);
        end
    end
    while(~isempty(todo))
        % Check if we found an "out"
        if (todo(1,1) == 'out')
            cnt=cnt+1;
            todo(1,:) = [];
            continue
        end
        % We have to go through each option
        % Find start
        idx = find(ismember(in,todo(1,1)));
        % Fill new todo
        for i = 1:size(out(idx,:),2)
            if (ismissing(out(idx,i)))
                continue
            else
                todo(end+1,1) = out(idx,i);
            end
        end
        todo(1,:) = [];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Breadth-first search for part2
function [cnt] = followConnection2(in,out)
    % Initialize
    cnt = 0;
    % Find start "svr"
    idx = find(ismember(in, 'svr'));
    if (isempty(idx))
        return
    end
    % Fill initial todo
    % We also need inital checks to check if we went through "dac" and "fft"
    % And we also use it to keep track of how many aligning paths we have
    for i = 1:size(out(idx,:),2)
        if (ismissing(out(idx,i)))
            continue
        else
            todo(i,1) = out(idx,i);
            checks(i,1:2) = [0,0]; checks(i,3) = 1;
        end
    end
    while(~isempty(todo))
        % Check if we found an "out"
        % Check if we found an "out", "dac", or "fft"
        if (todo(1,:) == 'dac')
            checks(1,1) = 1;
        elseif (todo(1,:) == 'fft')
            checks(1,2) = 1;
        elseif (todo(1,:) == 'out')
            if (sum(checks(1,1:2))==2)
                cnt=cnt+checks(1,3);
            end
            todo(1,:) = [];
            checks(1,:) = [];
            continue
        end
        % We have to go through each option
        % Find start
        idx = find(ismember(in,todo(1,1)));
        % Fill new todo
        for i = 1:size(out(idx,:),2)
            if (ismissing(out(idx,i)))
                continue
            else
                % Before we add, check if we have that already in our todo
                % list and if so we increment the counter
                idx2 = find((ismember(todo,out(idx,i))+ ...
                    ismember(checks(:,1),checks(1,1))+ ...
                    ismember(checks(:,2),checks(1,2)))==3);
                if (isempty(idx2))
                    todo(end+1,1) = out(idx,i);
                    checks(end+1,1:3) = checks(1,:);
                else
                    checks(idx2,3) = checks(idx2,3)+checks(1,3);
                end
            end
        end
        todo(1,:) = [];
        checks(1,:) = [];
    end
end
