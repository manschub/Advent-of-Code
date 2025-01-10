clc; clearvars;
% Advent of code 2024 - day 6 - part 1+2
% Open file and take needed data
file_id = fopen("day6.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% If something like day 3 again use regexp
% (https://de.mathworks.com/help/matlab/ref/regexp.html)

% Reorganize data
[x,y] = size(data{1,1});
for i = 1:x
    string(i,:) = data{1,1}{i,1};
end
string_tmp = string;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to count the fields the guard crosses on her way
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
in_map = 1;
% Find the start position
[row,col] = find(string=='^');
string(row,col) = 'X';
% Direction (up-1,right-2,down-3,left-4)
dir = 1;

while (in_map == 1)
    % Check if we reached the end of the map somewhere
    if ((dir == 1 && row == 1) || (dir == 2 && col == length(string(1,:))) ...
            || (dir == 3 && row == length(string(:,1))) || (dir == 4 && ...
            col == 1))
        % We are leaving the map
        string(row,col) = 'X';
        in_map = 0;
    else
        % We continue the way
        if (dir==1 && string(row-1,col) == '#')
            dir = 2;
            continue
        elseif (dir==1)
            row = row-1;
            string(row,col) = 'X';
        elseif (dir==2 && string(row,col+1) == '#')
            dir = 3;
            continue
        elseif (dir==2)
            col = col+1;
            string(row,col) = 'X';
        elseif (dir==3 && string(row+1,col) == '#')
            dir = 4;
            continue
        elseif (dir==3)
            row = row+1;
            string(row,col) = 'X';
        elseif (dir==4 && string(row,col-1) == '#')
            dir = 1;
            continue
        elseif (dir==4)
            col = col-1;
            string(row,col) = 'X';
        end
    end
end

% Our result is the number of X in the map
result1 = sum(sum(string=='X'));

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need to find possible loops the guard could get trapped
% in by adding 1 obstruction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
string = string_tmp;
in_map = 1; 
% Find the start position
[row_ini,col_ini] = find(string=='^');
row = row_ini; col = col_ini;
string(row,col) = 'X';
% Direction (up-1,right-2,down-3,left-4)
dir = 1; inloop = 0;
obs_placement = []; start_loops = [];

while (in_map == 1)
    % For the 2nd part we want to find positions where we have already been
    % but with 1 direction back in the full rotation
    [inloop,obs_pos] = checkifinloop(row,col,row_ini,col_ini,dir,string_tmp);
    if (inloop == 1)
        if (obs_pos(1) == row && obs_pos(2) == col)
        else
            if (isempty(obs_placement) || ...
                    isempty(find(obs_placement(:,1)==obs_pos(1) ...
                    & obs_placement(:,2)==obs_pos(2),1)))
                obs_placement = [obs_placement;obs_pos];
            end
        end
    end
    % Check if we reached the end of the map somewhere
    if ((dir == 1 && row == 1) || (dir == 2 && col == length(string(1,:))) ...
            || (dir == 3 && row == length(string(:,1))) || (dir == 4 && ...
            col == 1))
        % We are leaving the map
        in_map = 0;
    else
        % We continue the way
        if (dir==1 && string(row-1,col) == '#')
            dir = 2;
            continue
        elseif (dir==1)
            row = row-1;
            string(row,col) = 'X';
        elseif (dir==2 && string(row,col+1) == '#')
            dir = 3;
            continue
        elseif (dir==2)
            col = col+1;
            string(row,col) = 'X';
        elseif (dir==3 && string(row+1,col) == '#')
            dir = 4;
            continue
        elseif (dir==3)
            row = row+1;
            string(row,col) = 'X';
        elseif (dir==4 && string(row,col-1) == '#')
            dir = 1;
            continue
        elseif (dir==4)
            col = col-1;
            string(row,col) = 'X';
        end
    end
end
result2 = length(obs_placement(:,1));

fprintf('%10f',result2)
fprintf('\n')
toc

function [in_loop,obs_pos] = checkifinloop(row,col, ...
    row_guard,col_guard,dir,string)
    in_map = 1;
    in_loop = 0;
    obs_pos = [0,0];
    memory = [];
    % Here we check if an obstacle would bring us in a loop
    if (dir==1 && row>1 && string(row-1,col) == '.')
        % Simulate turn
        string(row-1,col) = '#';
        obs_pos = [row-1,col];
    elseif (dir==2 && col<length(string(1,:)) && string(row,col+1)=='.')
        % Simulate turn
        string(row,col+1) = '#';
        obs_pos = [row,col+1];
    elseif (dir==3 && row<length(string(:,1)) && string(row+1,col)=='.')
        % Simulate turn
        string(row+1,col) = '#';
        obs_pos = [row+1,col];
    elseif (dir==4 && col>1 && string(row,col-1)=='.')
        % Simulate turn
        string(row,col-1) = '#';
        obs_pos = [row,col-1];
    else
        return
    end
    row = row_guard; col = col_guard; dir = 1;
    % Mini-Loop here
    while (in_map == 1)
        % Check if we reached the end of the map somewhere
        if ((dir == 1 && row == 1) || (dir == 2 && col == length(string(1,:))) ...
                || (dir == 3 && row == length(string(:,1))) || (dir == 4 && ...
                col == 1))
            % We are leaving the map
            in_map = 0;
        else
            % We continue the way
            if (dir==1 && string(row-1,col) == '#')
                dir = 2;
                continue
            elseif (dir==1)
                row = row-1;
                % Check if we have a loop
                if (~isempty(memory) && ...
                        ~isempty(memory(memory(:,1)==row ...
                        & memory(:,2)==col & memory(:,3)== dir)))
                    in_loop = 1;
                    return
                end
                memory(end+1,:) = [row,col,dir];
                string(row,col) = 'X';
            elseif (dir==2 && string(row,col+1) == '#')
                dir = 3;
                continue
            elseif (dir==2)
                col = col+1;
                % Check if we have a loop
                if (~isempty(memory) && ...
                        ~isempty(memory(memory(:,1)==row ...
                        & memory(:,2)==col & memory(:,3)== dir)))
                    in_loop = 1;
                    return
                end
                memory(end+1,:) = [row,col,dir];
                string(row,col) = 'X';
            elseif (dir==3 && string(row+1,col) == '#')
                dir = 4;
                continue
            elseif (dir==3)
                row = row+1;
                % Check if we have a loop
                if (~isempty(memory) && ...
                        ~isempty(memory(memory(:,1)==row ...
                        & memory(:,2)==col & memory(:,3)== dir)))
                    in_loop = 1;
                    return
                end
                memory(end+1,:) = [row,col,dir];
                string(row,col) = 'X';
            elseif (dir==4 && string(row,col-1) == '#')
                dir = 1;
                continue
            elseif (dir==4)
                col = col-1;
                % Check if we have a loop
                if (~isempty(memory) && ...
                        ~isempty(memory(memory(:,1)==row ...
                        & memory(:,2)==col & memory(:,3)== dir)))
                    in_loop = 1;
                    return
                end
                memory(end+1,:) = [row,col,dir];
                string(row,col) = 'X';
            end
        end
    end
end
