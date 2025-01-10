clc; clearvars;
% Advent of code 2024 - day 23 - part 1+2
% Open file and take needed data
file_id = fopen("day23.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
[x,y] = size(data{1,1});
for i = 1:x
    list(i,:) = data{1,1}{i,1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find all sets of three interconnected computers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0; 

% Let's get all unique connections first
pc = [list(:,1:2);list(:,4:5)];
pc = unique(pc,'rows');

set = '';
idx = 1;
% Maybe we can just go through the pcs and check to which other ones they
% are connected
for i = 1:length(pc(:,1))
    % Get all at least once to our pc connected ones
    con = list(list(:,4)==pc(i,1)&list(:,5)==pc(i,2),1:2);
    con = [con;list(list(:,1)==pc(i,1)&list(:,2)==pc(i,2),4:5)];
    % For all our connections I need to check if they are connected with
    % each other as well - if yes we have a set
    for j = 1:length(con(:,1))
        for k = 1:length(con(:,1))
            if (j==k)
                continue
            else
                con2 = list(list(:,1)==con(j,1) & list(:,2)==con(j,2) & ...
                    list(:,4)==con(k,1) & list(:,5)==con(k,2));
                con2 = [con2;list(list(:,4)==con(j,1) & list(:,5)==con(j,2) & ...
                    list(:,1)==con(k,1) & list(:,2)==con(k,2))];
                % If this is empty we don't have a mutual 3-fold connection
                if (~isempty(con2))
                    % Otherwise, we have a set 
                    % Check if we already have the same set in any order
                    if (idx>1)
                        tmp = ((set(:,1) == pc(i,1) & set(:,2) == pc(i,2)) ...
                    | (set(:,3) == pc(i,1) & set(:,4) == pc(i,2)) ...
                    | (set(:,5) == pc(i,1) & set(:,6) == pc(i,2)));
                        tmp2 = ((set(:,1) == con(j,1) & set(:,2) == con(j,2)) ...
                    | (set(:,3) == con(j,1) & set(:,4) == con(j,2)) ...
                    | (set(:,5) == con(j,1) & set(:,6) == con(j,2)));
                        tmp3 = (set(:,1) == con(k,1) & set(:,2) == con(k,2)) ...
                    | (set(:,3) == con(k,1) & set(:,4) == con(k,2)) ...
                    | (set(:,5) == con(k,1) & set(:,6) == con(k,2));
                        if (max(tmp+tmp2+tmp3)==3)
                            continue
                        end
                    end
                    set(idx,1:6) = [pc(i,1:2),con(j,1:2),con(k,1:2)];
                    idx = idx+1;
                end
            end
        end
    end
end

% Find the ones with 't'
for i = 1:length(set(:,1))
    if (set(i,1)=='t'||set(i,3)=='t'||set(i,5)=='t')
        result1 = result1+1;
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need to find the pc that is connected to all other pcs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% We can reuse the sets from above and search for the largest
% Go through the sets
pc_tmp(1,1:2) = set(1,1:2);
cnt = 1;
pc_num = 1;
store_cts(1) = 1;
store_pcs(1,1:2) = set(i,1:2);
for i = 2:length(set(:,1))
    if (all(set(i,1:2) == pc_tmp))
        cnt = cnt+1;
    else
        store_cts(pc_num) = cnt;
        store_pcs(end+1,1:2) = set(i,1:2);
        pc_num = pc_num+1;
        cnt = 1;
        pc_tmp = set(i,1:2);
    end
end
store{pc_num,2} = cnt;

% Most-connected PC
[~,idx] = max(store_cts);
pc_win = store_pcs(idx,:);
% Now get all connected PCs
pcs_connected(1,1:2) = pc_win;
for i = 1:length(set(:,1))
    if (set(i,1)==pc_win(1)&&set(i,2)==pc_win(2))
        pcs_connected(end+1,1:2) = set(i,3:4);
        pcs_connected(end+1,1:2) = set(i,5:6);
    elseif (set(i,3)==pc_win(1)&&set(i,4)==pc_win(2)) 
        pcs_connected(end+1,1:2) = set(i,1:2);
        pcs_connected(end+1,1:2) = set(i,5:6);
    elseif (set(i,5)==pc_win(1)&&set(i,6)==pc_win(2)) 
        pcs_connected(end+1,1:2) = set(i,1:2);
        pcs_connected(end+1,1:2) = set(i,3:4);
    end
end
pcs_connected = unique(pcs_connected,'rows');

% Build result string
result2 = pcs_connected(1,1:2);
for i = 2:length(pcs_connected(:,1))
    result2 = [result2,',',pcs_connected(i,1:2)];
end
fprintf('%s',result2)
fprintf('\n')
toc




