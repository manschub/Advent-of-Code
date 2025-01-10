clc; clearvars;
% Advent of code 2024 - day 14 - part 1+2
% Open file and take needed data
file_id = fopen("day14.dat");
data = textscan(file_id,strcat('%s %f %f %s %f %f'),'Delimiter','=, ');
% Close file
fclose(file_id);

% Reorganize data
pos = [data{1,2},data{1,3}];
vel = [data{1,5},data{1,6}];

% Map for tests
% map(1:7,1:11) = 0;
map(1:103,1:101) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to simulate the robots movements until 100s in the
% future
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Instead of a long loop for each second of simulation we do all in once
% per robot (positive sense is right and down)
for i = 1:length(pos(:,1))
    % Calculate path the robot will cover
    fin(i,1) = pos(i,1)+100*vel(i,1);
    fin(i,2) = pos(i,2)+100*vel(i,2);
    % Map positions should be the following (+1 since the positions start
    % at zero)
    pos_map(i,1) = mod(fin(i,1),length(map(1,:)))+1;
    pos_map(i,2) = mod(fin(i,2),length(map(:,1)))+1;
    % Put robot on map
    if (map(pos_map(i,2),pos_map(i,1)) == 0)
        map(pos_map(i,2),pos_map(i,1)) = 1;
    else
        map(pos_map(i,2),pos_map(i,1)) = ...
            map(pos_map(i,2),pos_map(i,1))+1;
    end
end
% We erase the middle row and column
map_tmp = map;
map_tmp(ceil(length(map(:,1))/2),:) = [];
map_tmp(:,ceil(length(map(1,:))/2)) = [];
% Now count numbers of robots per quadrant
quad(1) = sum(sum(map_tmp(1:length(map_tmp(:,1))/2, ...
    1:length(map_tmp(1,:))/2)));
quad(2) = sum(sum(map_tmp(length(map_tmp(:,1))/2+1:end, ...
    1:length(map_tmp(1,:))/2)));
quad(3) = sum(sum(map_tmp(1:length(map_tmp(:,1))/2, ...
    length(map_tmp(1,:))/2+1:end)));
quad(4) = sum(sum(map_tmp(length(map_tmp(:,1))/2+1:end, ...
    length(map_tmp(1,:))/2+1:end)));

result1 = prod(quad);

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - We need to find the number of seconds at which the robots
% display a christmas tree
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Go second per second until we find a large collection of robots in the
% center
t = 0;
while (t<1e6)
    map_tmp(1:103,1:101) = 0;
    for i = 1:length(pos(:,1))
        % Calculate path the robot will cover
        fin(i,1) = pos(i,1)+t*vel(i,1);
        fin(i,2) = pos(i,2)+t*vel(i,2);
        % Map positions should be the following (+1 since the positions start
        % at zero)
        pos_map(i,1) = mod(fin(i,1),length(map(1,:)))+1;
        pos_map(i,2) = mod(fin(i,2),length(map(:,1)))+1;
        % Put robot on map
        if (map(pos_map(i,2),pos_map(i,1)) == 0)
            map_tmp(pos_map(i,2),pos_map(i,1)) = 1;
        else
            map_tmp(pos_map(i,2),pos_map(i,1)) = ...
                map_tmp(pos_map(i,2),pos_map(i,1))+1;
        end
    end
    center = sum(sum(map_tmp(floor(length(map_tmp(:,1))/3): ...
        ceil(length(map_tmp(:,1))/3*2), ...
        floor(length(map_tmp(:,1))/3): ...
        ceil(length(map_tmp(:,1))/3*2))));
    if (center>150)
        imshow(map_tmp)
        break
    end
    t = t+1;
end

result2 = t;

fprintf('%10f',result2)
fprintf('\n')
toc

