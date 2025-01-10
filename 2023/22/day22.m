clc; clear all;
% Advent of code 2023 - day 22 - part 1+2
% Open file and take needed data
file_id = fopen("day22.dat");
data = textscan(file_id,strcat('%f %f %f %f %f %f '),'delimiter',',~','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);
tic
% Rearrange data to be handled nicer
bricks = [data{1,1},data{1,2},data{1,3},data{1,4},data{1,5},data{1,6}];
% Create grid that covers the max height, width, and depth of our bricks
grid = meshgrid(1:max(bricks(:,4)) - min(bricks(:,1))+1, ...
    1:max(bricks(:,5)) - min(bricks(:,2))+1,1:max(bricks(:,6)));
grid(:,:,:) = 0;
% Order vertically
bricks_ov = sortrows(bricks,[3 6]);
bricks_moved = bricks_ov;

% Now let all bricks fall down as far as possible
for i = 1:length(bricks_ov(:,1))
    % For each brick in the row we have to check for the lowest possible
    % position, each bricks covers (x2-x1) * (y2-y1) cubes
    % Cover the corresponding spaces in the grids
    grid(bricks_ov(i,1)+1:bricks_ov(i,4)+1,bricks_ov(i,2)+1: ...
        bricks_ov(i,5)+1,bricks_ov(i,3):bricks_ov(i,6)) = 1;
    % Now move if necessary
    possible = 1;
    z = bricks_ov(i,3);
    while (possible == 1)
        % Check if we can move higher (lower in the puzzle sense)
        % If on top - nothing to do
        if (z == 1)
            possible = 0;
            continue
        % If all rows above us in x OR y = 0 then we can move up
        elseif (all(grid(bricks_ov(i,1)+1:bricks_ov(i,4)+1, ...
                bricks_ov(i,2)+1:bricks_ov(i,5)+1,z-1) == 0))
            z = z-1;
            % Update grid
            grid(bricks_moved(i,1)+1:bricks_moved(i,4)+1, ...
                bricks_moved(i,2)+1:bricks_moved(i,5)+1, ...
                bricks_moved(i,3)-1) = 1;
            % Adjust the above row that is no longer occupied
            grid(bricks_moved(i,1)+1:bricks_moved(i,4)+1, ...
                bricks_moved(i,2)+1:bricks_moved(i,5)+1, ...
                bricks_moved(i,6)) = 0;
            % Update bricks array as well
            bricks_moved(i,3) = bricks_moved(i,3)-1; 
            bricks_moved(i,6) = bricks_moved(i,6)-1;
            continue
        % Otherwise we reached the highest point
        else
            possible = 0;
            continue
        end
    end
end

% Sort again to be sure the following falling check works
bricks_moved_ov = sortrows(bricks_moved,[3 6]);
bricks_moved = bricks_moved_ov;

safe_to_disintegrate = 0;
% Now check for bricks that are safe to disintegrate - check if they are
% the only brick securing another brick - we go again from top to bottom
for i = 1:length(bricks_moved_ov(:,1))
    % If we are on the highest level it's always safe to disintegrate
    if (bricks_moved_ov(i,6) == max(bricks_moved_ov(:,6)))
        safe_to_disintegrate = safe_to_disintegrate+1;
        continue
    end
    % I only need to check the row directly below me
    % Let's simulate a disintegration and check if the next one can then
    % fall down
    grid_simul = grid;
    grid_simul(bricks_moved_ov(i,1)+1:bricks_moved_ov(i,4)+1, ...
        bricks_moved_ov(i,2)+1:bricks_moved_ov(i,5)+1, ...
        bricks_moved_ov(i,3):bricks_moved_ov(i,6)) = 0;
    % Check if bricks fall down
    for j = i:length(bricks_moved_ov(:,1))
        % If they are on the ground nothing to do
        if (bricks_moved_ov(j,3) == 1)
            continue
        end
        % Now move if necessary
        possible = 0;
        z = bricks_moved_ov(j,3);
        % Check if we can move higher (lower in the puzzle sense)
        % If all rows above us in x OR y = 0 then we can move up
        if (all(grid_simul(bricks_moved_ov(j,1)+1:bricks_moved_ov(j,4)+1, ...
            bricks_moved_ov(j,2)+1:bricks_moved_ov(j,5)+1,z-1) == 0))
            possible = 1;
            break
        end
    end
    % if we get possible = 0 from the above check no brick would move
    % through our disintegration - safe to remove
    if (possible == 0)
        % We found one that can be disintegrated
        safe_to_disintegrate = safe_to_disintegrate+1;
        % We are not supposed to actually disintegrate a brick so we leave
        % everything as it is
    end
end

% Distance of all the galaxy pairs
fprintf('%10f',safe_to_disintegrate)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Part 2 - just use the parts from my first part
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We already started with our sorted and fallen bricks from part 1
tic
grid2 = grid;
bricks_moved_ov2 = bricks_moved_ov;
bricks_moved2 = bricks_moved;

% Now go to our last loop, simulate a disintegration and count falling
% bricks
num_falling = 0;
% Now check for each brick how many of all the other bricks would fall
for i = 1:length(bricks_moved_ov(:,1))
    % Let's simulate a disintegration and check how many bricks fall down
    grid_simul = grid;
    bricks_moved_ov_simul = bricks_moved_ov;
    grid_simul(bricks_moved_ov(i,1)+1:bricks_moved_ov(i,4)+1, ...
        bricks_moved_ov(i,2)+1:bricks_moved_ov(i,5)+1, ...
        bricks_moved_ov(i,3):bricks_moved_ov(i,6)) = 0;
    tmp = 0;
    for j = 1:length(bricks_moved_ov(:,1))
        cnt = 0; possible = 1; z = bricks_moved_ov_simul(j,3);
        % Check if bricks fall down
        while (possible == 1)
            % Check if we can move higher (lower in the puzzle sense)
            % If on top - nothing to do
            if (z == 1)
                possible = 0;
                continue
            % If all rows above us in x OR y = 0 then we can move up
            elseif (all(grid_simul(bricks_moved_ov_simul(j,1)+1:bricks_moved_ov_simul(j,4)+1, ...
                    bricks_moved_ov_simul(j,2)+1:bricks_moved_ov_simul(j,5)+1,z-1) == 0))
                z = z-1;
                % Update grid
                grid_simul(bricks_moved_ov_simul(j,1)+1:bricks_moved_ov_simul(j,4)+1, ...
                    bricks_moved_ov_simul(j,2)+1:bricks_moved_ov_simul(j,5)+1, ...
                    bricks_moved_ov_simul(j,3)-1) = 1;
                % Adjust the above row that is no longer occupied
                grid_simul(bricks_moved_ov_simul(j,1)+1:bricks_moved_ov_simul(j,4)+1, ...
                    bricks_moved_ov_simul(j,2)+1:bricks_moved_ov_simul(j,5)+1, ...
                    bricks_moved_ov_simul(j,6)) = 0;
                % Update bricks array as well
                bricks_moved_ov_simul(j,3) = bricks_moved_ov_simul(j,3)-1; 
                bricks_moved_ov_simul(j,6) = bricks_moved_ov_simul(j,6)-1;
                cnt = cnt+1;
                if(cnt == 1)
                    tmp = tmp+1;
                end
                continue
            % Otherwise we reached the highest point
            else
                possible = 0;
                continue
            end
        end
    end
    % Increment numbers of falling bricks
    num_falling = num_falling+tmp;
end


% Distance of all the galaxy pairs
fprintf('%10f',num_falling)
fprintf('\n')
toc
