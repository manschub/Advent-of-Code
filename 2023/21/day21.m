clc; clear all;
% Advent of code 2023 - day 21 - part 1+2
% Open file and take needed data
file_id = fopen("day21.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

tic
map_start = [];
% Rearrange data to be handled nicer
for i = 1:length(data{1,1})
    map_start = [map_start;data{1,1}{i,1}];
end

% Now we need to follow the steps (without obstacles there would be the
% need to check around 3.4*10^34 possibilities)
steps = 0; 
map_current = map_start;
[map] = takestep(map_start,map_current,steps);

% For the result we need to count Os
[row_o,~] = find(map == 'O');
result_part1 = length(row_o);
fprintf('%10f',result_part1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Part 2 - Now take 26501365 steps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now we need to follow the steps (without obstacles there would be the
% need to check around a ridicolous amount of possibilities)
tic 
steps = 0; steps_max = 64;
map_current = map_start;
map_origin = map_start;
map_origin(map_origin == 'S') = '.';
[map] = takestep2(map_origin,map_start,map_current,steps,steps_max);
[~,col_o] = find(map == 'O');

% We get a square with 2*steps rows and 2*steps columns 
% So for our goal number of 26501365 steps we will have a square with
% 53002730 rows and columns 
% Can I create a map that is big enough - nope 
% Our goal number is odd which means no O will be on the Start
% Reaching the end of the first pattern takes 65 steps and leads to 3889 Os
% after that it takes 131 steps to get through each pattern. One full
% pattern has 7613 Os on an odd number. S starts on 66,66
% How many steps to get a full pattern: 131

% How big is our fully filled part if I have 53002730 rows and columns
% I take the full patterns from the middle to the border: 26501365/131
% 26501300/131 = 202300 -> This squared gives me the total number of full
% squares: 202300^2 = 40925290000
% All the Os in full patterns should be:
% result_part2 = 40925290000 * 7613;

% Got some hints so we need (n+1)^2 odd input files where n is 202300 which
% is the amount of suares we have in one direction and n^2 even input
% squares
% Tiles covered in odd squares (obtained by running with 131 steps)
odd = 7613; 
% Tiles covered in even squares (obtained by running with 132 steps)
even = 7623;
% For the corners of the triangles we have n+1 odd and n even
% The corners represent all of the tiles at a distance bigger than 65 steps
% from the centre
% Tiles at a distance bigger than 65 steps for odd squares (obtained by running with 65 steps)
diamond_odd = odd-3889;
% Tiles at a distance bigger than 65 steps for even squares (obtained by running with 66 steps)
diamond_even = even-3746;
% Calculate result
result_part2 = (202300+1)^2*odd + (202300)^2*even - ...
    (202300+1)*diamond_odd + 202300*diamond_even;
fprintf('%10f',result_part2)
fprintf('\n')
toc

function [map_current] = takestep(map_start,map_current,steps)
    while (steps <= 64)
        % Now find starting position for our next step
        if (steps == 1)
            % First we need to find the starting point
            [row_s,col_s] = find(map_current == 'S');
        else
            % First we need to find the starting point
            [row_s,col_s] = find(map_current == 'O');
        end
        % Reset map so we don't just fill everything with O
        map_current = map_start;
        % Now we go through all starting positions
        for i = 1:length(row_s)
            % And for each of them we try the four different possibilities
            for j = 1:4
                % Go up
                if (j == 1 && row_s(i) > 1 && ...
                        map_start(row_s(i)-1,col_s(i)) ~= '#')
                    % Set new location
                    map_current(row_s(i)-1,col_s(i)) = 'O';
                % Go right
                elseif (j == 2 && col_s(i)+1 < length(map_start(1,:)) && ...
                        map_start(row_s(i),col_s(i)+1) ~= '#')
                    % Set new location
                    map_current(row_s(i),col_s(i)+1) = 'O';
                % Go down
                elseif (j == 3 && row_s(i)+1 < length(map_start(:,1)) && ...
                        map_start(row_s(i)+1,col_s(i)) ~= '#')
                    % Set new location
                    map_current(row_s(i)+1,col_s(i)) = 'O';
                % Go left
                elseif (j == 4 && col_s(i) > 1 && ...
                        map_start(row_s(i),col_s(i)-1) ~= '#')
                    % Set new location
                    map_current(row_s(i),col_s(i)-1) = 'O';
                end
            end
        end
        % And next round
        % Increment current step number
        steps = steps+1; 
    end
end

function [map_current] = takestep2(map_origin,map_start,map_current,steps,steps_max)
    while (steps <= steps_max)
        % Now find starting position for our next step
        if (steps == 1)
            % First we need to find the starting point
            [row_s,col_s] = find(map_current == 'S');
        else
            % First we need to find the starting point
            [row_s,col_s] = find(map_current == 'O');
        end
        % Reset map so we don't just fill everything with O
        map_current = map_start;
        % Now we go through all starting positions
        for i = 1:length(row_s)
            % And for each of them we try the four different possibilities
            for j = 1:4
                % Go up
                if (j == 1) 
                    if (row_s(i) > 1 && map_start(row_s(i)-1,col_s(i)) ~= '#')
                        % Set new location
                        map_current(row_s(i)-1,col_s(i)) = 'O';
                    elseif (row_s(i) == 1)
                        % We need to increase map
                        row_s = row_s + length(map_origin(:,1));
                        map_start = [map_origin;map_start];
                        map_current = [map_origin;map_current];
                        map_origin = [map_origin;map_origin];
                        if (map_current(row_s(i)-1,col_s(i)) ~= '#')
                            % Set new location
                            map_current(row_s(i)-1,col_s(i)) = 'O';
                        end
                    end
                % Go right
                elseif (j == 2)
                    if (col_s(i)+1 <= length(map_start(1,:)) && ...
                        map_start(row_s(i),col_s(i)+1) ~= '#')
                        % Set new location
                        map_current(row_s(i),col_s(i)+1) = 'O';
                    elseif (col_s(i)+1 > length(map_start(1,:)))
                        % We need to increase map
                        map_start = [map_start,map_origin];
                        map_current = [map_current,map_origin];
                        map_origin = [map_origin,map_origin];
                        if (map_start(row_s(i),col_s(i)+1) ~= '#')
                            % Set new location
                            map_current(row_s(i),col_s(i)+1) = 'O';
                        end
                    end
                % Go down
                elseif (j == 3) 
                    if (row_s(i)+1 <= length(map_start(:,1)) ...
                            && map_start(row_s(i)+1,col_s(i)) ~= '#')
                        % Set new location
                        map_current(row_s(i)+1,col_s(i)) = 'O';
                    elseif (row_s(i)+1 > length(map_start(:,1)))
                        % We need to increase map
                        map_start = [map_start;map_origin];
                        map_current = [map_current;map_origin];
                        map_origin = [map_origin;map_origin];
                        if (map_current(row_s(i)+1,col_s(i)) ~= '#')
                            % Set new location
                            map_current(row_s(i)+1,col_s(i)) = 'O';
                        end
                    end
                % Go left
                elseif (j == 4)
                    if (col_s(i) > 1 && map_start(row_s(i),col_s(i)-1) ~= '#')
                        % Set new location
                        map_current(row_s(i),col_s(i)-1) = 'O';
                    elseif (col_s(i) == 1)
                        % We need to increase map
                        col_s = col_s + length(map_origin(1,:));
                        map_start = [map_origin,map_start];
                        map_current = [map_origin,map_current];
                        map_origin = [map_origin,map_origin];
                        if (map_start(row_s(i),col_s(i)-1) ~= '#')
                            % Set new location
                            map_current(row_s(i),col_s(i)-1) = 'O';
                        end
                    end
                end
            end
        end
        % And next round
        % Increment current step number
        steps = steps+1;
    end
end
