clc; clear all;
% Advent of code 2023 - day 23 - part 1+2
% Open file and take needed data
file_id = fopen("day23.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);
strings = data{1,1};
strings_start = [];
% Rearrange data to be handled nicer
for i = 1:length(data{1,1})
    strings_start = [strings_start;data{1,1}{i,1}];
end

tic

% Let's try recursively again to track all paths and check in the end which
% is the longest
start = find(strings{1,:} == '.',1);
endpos = find(strings{end,:} == '.');
% Mark start
strings{1,1}(start) = 'S';
% Initial direction is south
direction = 's';
% Find the paths in our recursive setup
steps = 0; position = [1, start];
[steps] = findpaths(strings,direction,steps,position,endpos);
% Our result is the maximum of steps
result_part1 = max(steps);
fprintf('%10f',result_part1)
fprintf('\n')
toc

% For part 2 we just adjust the recursive function a bit
tic
% Find the paths in our recursive setup
steps = 0; position = [1, start];
[steps] = findpaths2(strings,direction,steps,position);
% Our result is the maximum of steps
result_part2 = max(steps);
fprintf('%10f',result_part2)
fprintf('\n')
toc

% 6442 is too low
% 66.. is wrong

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [steps_final] = findpaths2(strings,direction,steps,position)

    % Put an infinite while loop here even though it feels scary
    endpos_reached = 0; 

    while (endpos_reached == 0)
        % Depending on the direction we come from we first take the next step
        if (direction == 'n')
            % Go north
            position(1) = position(1)-1;
        elseif (direction == 'e')
            % Go east
            position(2) = position(2)+1;
        elseif (direction == 's')
            % Go south
            position(1) = position(1)+1;
        elseif (direction == 'w')
            % Go west
            position(2) = position(2)-1;
        end
        % Mark our step on our map and count steps
        strings{position(1),1}(position(2)) = 'O';
        steps = steps+1;
    
        % If we reached the end position we return
        if (position(1) == 140 && position(2) == 140)
            if (~exist('steps_final','var') || steps > steps_final)
                steps_final = steps+1;
            end
            return
        end
        
        options = zeros(4,2);
        % Otherwise decide which step we can take next and if we have to split
        % For each direction check if we can go there
        % We need to introduce the special case of the last intersection
        % before the end as we must take the exit route
        if (position(1) == 136 && position(2) == 138)
            % We HAVE TO go south
            options(3,:) = [position(1)+1, position(2)];
        else
            % North
            if ( position(1)-1 > 1 && ... 
                    strings{position(1)-1,1}(position(2)) ~= 'S' && ...
                    strings{position(1)-1,1}(position(2)) ~= '#' && ...
                    strings{position(1)-1,1}(position(2)) ~= 'O')
                options(1,:) = [position(1)-1, position(2)];
            end
            % East
            if ( position(2)+1 < 141 && ...
                    strings{position(1),1}(position(2)+1) ~= '#' && ...
                    strings{position(1),1}(position(2)+1) ~= 'O')
                options(2,:) = [position(1), position(2)+1];
            end
            % South
            if ( position(1)+1 < 141 && ...
                    strings{position(1)+1,1}(position(2)) ~= '#' && ...
                    strings{position(1)+1,1}(position(2)) ~= 'O')
                options(3,:) = [position(1)+1, position(2)];
            end
            % West
            if ( position(2)-1 > 1 && ...
                    strings{position(1),1}(position(2)-1) ~= '#' && ...
                    strings{position(1),1}(position(2)-1) ~= 'O')
                options(4,:) = [position(1), position(2)-1];
            end
        end
        % Now we have to do all of those steps that are possible
        % If we have only one option we don't need to split though
        % In the 2nd part it can happen that we go in circles and don't
        % have an option - if so return as well
        if (sum(options(:,1)) == 0)
            if (~exist('steps_final','var') || steps > steps_final)
                steps_final = 0;
            end
            return
        elseif (sum(options(:,1) ~= 0) > 1)
            % If I have more than 1 option that means I am at a junction
            % For each junction we should add the steps to get there
            % Go north
            if (options(1,1) ~= 0 && direction ~= 'n')
                [steps_tmp] = findpaths2(strings,'n',steps,position);
                if (~exist('steps_final','var') || steps_tmp > steps_final)
                    steps_final = steps_tmp;
                end
            end
            % Go east
            if (options(2,1) ~= 0  && direction ~= 'e')
                [steps_tmp] = findpaths2(strings,'e',steps,position);
                if (~exist('steps_final','var') || steps_tmp > steps_final)
                    steps_final = steps_tmp;
                end
            end
            % Go south
            if (options(3,1) ~= 0 && direction ~= 's')
                [steps_tmp] = findpaths2(strings,'s',steps,position);
                if (~exist('steps_final','var') || steps_tmp > steps_final)
                    steps_final = steps_tmp;
                end
            end
            % Go west
            if (options(4,1) ~= 0 && direction ~= 'w')
                [steps_tmp] = findpaths2(strings,'w',steps,position);
                if (~exist('steps_final','var') || steps_tmp > steps_final)
                    steps_final = steps_tmp;
                end
            end
            % Before we continue check if the current direction is actually
            % possible
            if ((direction == 'n' && options(1,1) == 0) || ...
                    (direction == 'e' && options(2,1) == 0) || ...
                    (direction == 's' && options(3,1) == 0) || ...
                    (direction == 'w' && options(4,1) == 0))
                if (~exist('steps_final','var') || steps > steps_final)
                    steps_final = 0;
                end
                return
            end
        else
            % Just set direction for next step
            if (options(1,1) ~= 0)
                direction = 'n';
            elseif (options(2,1) ~= 0)
                direction = 'e';
            elseif (options(3,1) ~= 0)
                direction = 's';
            elseif (options(4,1) ~= 0)
                direction = 'w';
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [steps_final] = findpaths(strings,direction,steps,position,endpos)

    % Put an infinite while loop here even though it feels scary
    endpos_reached = 0;
    % Initialize final steps as well
    steps_final = steps;
    while (endpos_reached == 0)
        % Depending on the direction we come from we first take the next step
        if (direction == 'n')
            % Go north
            position(1) = position(1)-1;
        elseif (direction == 'e')
            % Go east
            position(2) = position(2)+1;
        elseif (direction == 's')
            % Go south
            position(1) = position(1)+1;
        elseif (direction == 'w')
            % Go west
            position(2) = position(2)-1;
        end
        % Mark our step on our map and count steps
        strings{position(1),1}(position(2)) = 'O';
        steps = steps+1;
    
        % If we reached the end position we return
        if (position(1) == length(strings(:,1)) && position(2) == endpos)
            if (length(steps_final) == 1)
                steps_final = steps;
            else
                steps_final(:,end+1) = steps;
            end
            return
        end
        
        options = zeros(4,2);
        % Otherwise decide which step we can take next and if we have to split
        % For each direction check if we can go there
        % North
        if (strings{position(1)-1,1}(position(2)) ~= 'S' && ...
                strings{position(1)-1,1}(position(2)) ~= '#' && ...
                strings{position(1)-1,1}(position(2)) ~= 'v' && ...
                strings{position(1)-1,1}(position(2)) ~= 'O')
            options(1,:) = [position(1)-1, position(2)];
        end
        % East
        if (strings{position(1),1}(position(2)+1) ~= '#' && ...
                strings{position(1),1}(position(2)+1) ~= '<' && ...
                strings{position(1),1}(position(2)+1) ~= 'O')
            options(2,:) = [position(1), position(2)+1];
        end
        % South
        if (strings{position(1)+1,1}(position(2)) ~= '#' && ...
                strings{position(1)+1,1}(position(2)) ~= '^' && ...
                strings{position(1)+1,1}(position(2)) ~= 'O')
            options(3,:) = [position(1)+1, position(2)];
        end
        % West
        if (strings{position(1),1}(position(2)-1) ~= '#' && ...
                strings{position(1),1}(position(2)-1) ~= '>' && ...
                strings{position(1),1}(position(2)-1) ~= 'O')
            options(4,:) = [position(1), position(2)-1];
        end
        % Now we have to do all of those steps that are possible
        % If we have only one option we don't need to split though
        if (sum(options(:,1) ~= 0) > 1)
            % Go north
            if (options(1,1) ~= 0 && direction ~= 'n')
                [steps_tmp] = findpaths(strings,'n',steps, ...
                    position,endpos);
                % Add path to final output
                if (length(steps_tmp) == 1)
                    steps_final(end+1) = steps_tmp;
                else
                    steps_final(end+1:end+length(steps_tmp)) = steps_tmp;
                end
            end
            % Go east
            if (options(2,1) ~= 0 && direction ~= 'e')
                [steps_tmp] = findpaths(strings,'e',steps, ...
                    position,endpos);
                % Add path to final output
                if (length(steps_tmp) == 1)
                    steps_final(end+1) = steps_tmp;
                else
                    steps_final(end+1:end+length(steps_tmp)) = steps_tmp;
                end
            end
            % Go south
            if (options(3,1) ~= 0 && direction ~= 's')
                [steps_tmp] = findpaths(strings,'s',steps, ...
                    position,endpos);
                % Add path to final output
                if (length(steps_tmp) == 1)
                    steps_final(end+1) = steps_tmp;
                else
                    steps_final(end+1:end+length(steps_tmp)) = steps_tmp;
                end
            end
            % Go west
            if (options(4,1) ~= 0 && direction ~= 'w')
                [steps_tmp] = findpaths(strings,'w',steps, ...
                    position,endpos);
                % Add path to final output
                if (length(steps_tmp) == 1)
                    steps_final(end+1) = steps_tmp;
                else
                    steps_final(end+1:end+length(steps_tmp)) = steps_tmp;
                end
            end
            % Before we continue check if the current direction is actually
            % possible
            if ((direction == 'n' && options(1,1) == 0) || ...
                    (direction == 'e' && options(2,1) == 0) || ...
                    (direction == 's' && options(3,1) == 0) || ...
                    (direction == 'w' && options(4,1) == 0))
                if (steps > steps_final)
                    steps_final = steps;
                end
                return
            end
        else
            % Just set direction for next step
            if (options(1,1) ~= 0)
                direction = 'n';
            elseif (options(2,1) ~= 0)
                direction = 'e';
            elseif (options(3,1) ~= 0)
                direction = 's';
            elseif (options(4,1) ~= 0)
                direction = 'w';
            end
        end
    end
end