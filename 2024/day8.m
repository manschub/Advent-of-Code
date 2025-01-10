clc; clearvars;
% Advent of code 2024 - day 8 - part 1+2
% Open file and take needed data
file_id = fopen("day8.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
map = data{1,1};
% Reorganize data
[x,~] = size(data{1,1});
for i = 1:x
    antinodes(i,:) = data{1,1}{i,1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find the number of unique antinode positions in our
% antenna map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Let's find all the positions of antennas (regexp finally)
pos = []; str = '';

for i = 1:x
    % Go through map and collect positions of antennas
    [col] = regexp(map{i},'[A-Za-z0-9]');
    row(1:length(col)) = i;
    if (~isempty(col))
        % Store type of antenna as well
        str_tmp = num2str(cell2mat(regexp(map{i},'[A-Za-z0-9]','match')));
        str = strcat(str,str_tmp);
        pos(end+1:end+length(col),1) = row;
        pos(end-length(col)+1:end,2) = col;
    end
    clear row col
end

% Now we want the unique antennas
ant_uni = unique(str);

% And now for each antenna type we go through the positions and place
% antinodes
[x,y] = size(antinodes);
for i = 1:length(ant_uni)
    % Get all positions for the current antenna
    [~,col] = find(str==ant_uni(i));
    pos_tmp = pos(col,:);
    % For each of the positions we need to get the distances between them
    % and place antinodes in the map
    for j = 1:length(pos_tmp)
        dist = pos_tmp(j,:)-pos_tmp;
        dist(j,:) = [];
        % Antinodes placed at the same distance at each side
        for k = 1:length(dist)
            if (pos_tmp(j,1)+dist(k,1) <= x ...
                    && pos_tmp(j,1)+dist(k,1) > 0 ...
                    && pos_tmp(j,2)+dist(k,2) <= y ...
                    && pos_tmp(j,2)+dist(k,2) > 0)
                antinodes(pos_tmp(j,1)+dist(k,1), ...
                    pos_tmp(j,2)+dist(k,2)) = '#';
            end
        end
    end
end
% The result is the number of #
[~,tmp] = find(antinodes=='#');
result1 = length(tmp);

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now the antinodes repeat all the way until the map edges - We
% can use almost the same code, but have to adapt the antinode positioning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Now for each antenna type we go through the positions and place
% antinodes according to the rules of part 2
[x,y] = size(antinodes);
for i = 1:length(ant_uni)
    % Get all positions for the current antenna
    [~,col] = find(str==ant_uni(i));
    pos_tmp = pos(col,:);
    % For each of the positions we need to get the distances between them
    % and place antinodes in the map (in part 2 we repeat this until
    % leaving the map)
    for j = 1:length(pos_tmp)
        dist = pos_tmp(j,:)-pos_tmp;
        dist(j,:) = [];
        dist_orig = dist;
        % Antinodes placed at the same distance at each side and multiples
        clear placed
        placed(1:length(pos_tmp)-1) = 1;
        while (sum(placed)>=1)
            for k = 1:length(dist)
                if (pos_tmp(j,1)+dist(k,1) <= x ...
                        && pos_tmp(j,1)+dist(k,1) > 0 ...
                        && pos_tmp(j,2)+dist(k,2) <= y ...
                        && pos_tmp(j,2)+dist(k,2) > 0)
                    antinodes(pos_tmp(j,1)+dist(k,1), ...
                        pos_tmp(j,2)+dist(k,2)) = '#';
                    placed(k) = 1;
                else
                    placed(k) = 0;
                end
            end
            dist = dist+dist_orig;
        end
    end
end
% All antennas are now also antinodes according to part 2's rules
for i = 1:length(pos)
    antinodes(pos(i,1),pos(i,2)) = '#';
end

% The result is the number of #
[~,tmp] = find(antinodes=='#');
result2 = length(tmp);

fprintf('%10f',result2)
fprintf('\n')
toc

