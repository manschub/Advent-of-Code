clc; clear all;
% Advent of code 2023 - day 5 - part 1+2

% Open file and take needed data
file_id = fopen("day5.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Arrange data (seedtosoil:24:122, soiltofertilizer:125:247, 
% fertilizertowater:250:375, watertolight:378:458, lighttotemp:461:574
% temptohumidity:577:615, humiditytolocation:618:695
for i=1:20
    seeds(i) = str2num(data{1,1}{i+1,1});
end
for i=1:3:98
    seedtosoil(i,:) = [str2num(data{1,1}{i+23,1}), ...
        str2num(data{1,1}{i+24,1}),str2num(data{1,1}{i+25,1})];
end
seedtosoil = seedtosoil(1:3:end,:);
for i=1:3:122
    soiltofertilizer(i,:) = [str2num(data{1,1}{i+124,1}), ...
        str2num(data{1,1}{i+125,1}),str2num(data{1,1}{i+126,1})];
end
soiltofertilizer = soiltofertilizer(1:3:end,:);
for i=1:3:125
    fertilizertowater(i,:) = [str2num(data{1,1}{i+249,1}), ...
        str2num(data{1,1}{i+250,1}),str2num(data{1,1}{i+251,1})];
end
fertilizertowater = fertilizertowater(1:3:end,:);
for i=1:3:80
    watertolight(i,:) = [str2num(data{1,1}{i+377,1}), ...
        str2num(data{1,1}{i+378,1}),str2num(data{1,1}{i+379,1})];
end
watertolight = watertolight(1:3:end,:);
for i=1:3:113
    lighttotemp(i,:) = [str2num(data{1,1}{i+460,1}), ...
        str2num(data{1,1}{i+461,1}),str2num(data{1,1}{i+462,1})];
end
lighttotemp = lighttotemp(1:3:end,:);
for i=1:3:38
    temptohumidity(i,:) = [str2num(data{1,1}{i+576,1}), ...
        str2num(data{1,1}{i+577,1}),str2num(data{1,1}{i+578,1})];
end
temptohumidity = temptohumidity(1:3:end,:);
for i=1:3:77
    humiditytolocation(i,:) = [str2num(data{1,1}{i+617,1}), ...
        str2num(data{1,1}{i+618,1}),str2num(data{1,1}{i+619,1})];
end
humiditytolocation = humiditytolocation(1:3:end,:);

% Store seeds
seeds_old = seeds;

% Now to the translation work for each seed
for i=1:length(seeds)
    % We have to go through each map
    % Seed to soil
    for j=1:length(seedtosoil)
        % Check if range fits to our seed
        if (seeds(i) >= seedtosoil(j,2) && seeds(i) <= ...
                seedtosoil(j,2) + seedtosoil(j,3))
            seeds(i) = seeds(i) + (seedtosoil(j,1)-seedtosoil(j,2));
            break
        elseif (j==length(seedtosoil))
            seeds(i) = seeds(i);
        end
    end
    % Soil to fertilizer
    for j=1:length(soiltofertilizer)
        % Check if range fits to our seed
        if (seeds(i) >= soiltofertilizer(j,2) && seeds(i) <= ...
                soiltofertilizer(j,2) + soiltofertilizer(j,3))
            seeds(i) = seeds(i) + (soiltofertilizer(j,1)-soiltofertilizer(j,2));
            break
        elseif (j==length(soiltofertilizer))
            seeds(i) = seeds(i);
        end
    end
    % Fertilizer to water
    for j=1:length(fertilizertowater)
        % Check if range fits to our seed
        if (seeds(i) >= fertilizertowater(j,2) && seeds(i) <= ...
                fertilizertowater(j,2) + fertilizertowater(j,3))
            seeds(i) = seeds(i) + (fertilizertowater(j,1)-fertilizertowater(j,2));
            break
        elseif (j==length(fertilizertowater))
            seeds(i) = seeds(i);
        end
    end
    % Water to light
    for j=1:length(watertolight)
        % Check if range fits to our seed
        if (seeds(i) >= watertolight(j,2) && seeds(i) <= ...
                watertolight(j,2) + watertolight(j,3))
            seeds(i) = seeds(i) + (watertolight(j,1)-watertolight(j,2));
            break
        elseif (j==length(watertolight))
            seeds(i) = seeds(i);
        end
    end
    % Light to temperature
    for j=1:length(lighttotemp)
        % Check if range fits to our seed
        if (seeds(i) >= lighttotemp(j,2) && seeds(i) <= ...
                lighttotemp(j,2) + lighttotemp(j,3))
            seeds(i) = seeds(i) + (lighttotemp(j,1)-lighttotemp(j,2));
            break
        elseif (j==length(lighttotemp))
            seeds(i) = seeds(i);
        end
    end
    % Temperature to humidity
    for j=1:length(temptohumidity)
        % Check if range fits to our seed
        if (seeds(i) >= temptohumidity(j,2) && seeds(i) <= ...
                temptohumidity(j,2) + temptohumidity(j,3))
            seeds(i) = seeds(i) + (temptohumidity(j,1)-temptohumidity(j,2));
            break
        elseif (j==length(temptohumidity))
            seeds(i) = seeds(i);
        end
    end
    % Humidity to location
    for j=1:length(humiditytolocation)
        % Check if range fits to our seed
        if (seeds(i) >= humiditytolocation(j,2) && seeds(i) <= ...
                humiditytolocation(j,2) + humiditytolocation(j,3))
            seeds(i) = seeds(i) + (humiditytolocation(j,1)-humiditytolocation(j,2));
            break
        elseif (j==length(humiditytolocation))
            seeds(i) = seeds(i);
        end
    end
end
% Answer part 1
lowest_loc = min(seeds);

% Part 2 - We do the same just change initial seeds - nope, memory and cpu
% are dying - New approach -> backwards solving - nope, back to brute
% force, but a bit smarter. Found that the first seed produces the best 
% results so only use that for refined search. Closer estimates were
% obtained gradually to search smaller solutions spaces but with more
% detail
clear seeds
% Initialize lowest location
loc = 999999999999999999;

% Now to the translation work for each seed
% for i=1:2:length(seeds_old)
for i=1:2:2
%     for k=0:1000:seeds_old(i+1)-1
    for k=907100000:1:910000000
        seeds = seeds_old(i)+k;
        % We have to go through each map
        % Seed to soil
        for j=1:length(seedtosoil)
            % Check if range fits to our seed
            if (seeds >= seedtosoil(j,2) && seeds <= ...
                    seedtosoil(j,2) + seedtosoil(j,3))
                seeds = seeds + (seedtosoil(j,1)-seedtosoil(j,2));
                break
            elseif (j==length(seedtosoil))
                seeds = seeds;
            end
        end
        % Soil to fertilizer
        for j=1:length(soiltofertilizer)
            % Check if range fits to our seed
            if (seeds >= soiltofertilizer(j,2) && seeds <= ...
                    soiltofertilizer(j,2) + soiltofertilizer(j,3))
                seeds = seeds + (soiltofertilizer(j,1)-soiltofertilizer(j,2));
                break
            elseif (j==length(soiltofertilizer))
                seeds = seeds;
            end
        end
        % Fertilizer to water
        for j=1:length(fertilizertowater)
            % Check if range fits to our seed
            if (seeds >= fertilizertowater(j,2) && seeds <= ...
                    fertilizertowater(j,2) + fertilizertowater(j,3))
                seeds = seeds + (fertilizertowater(j,1)-fertilizertowater(j,2));
                break
            elseif (j==length(fertilizertowater))
                seeds = seeds;
            end
        end
        % Water to light
        for j=1:length(watertolight)
            % Check if range fits to our seed
            if (seeds >= watertolight(j,2) && seeds <= ...
                    watertolight(j,2) + watertolight(j,3))
                seeds = seeds + (watertolight(j,1)-watertolight(j,2));
                break
            elseif (j==length(watertolight))
                seeds = seeds;
            end
        end
        % Light to temperature
        for j=1:length(lighttotemp)
            % Check if range fits to our seed
            if (seeds >= lighttotemp(j,2) && seeds <= ...
                    lighttotemp(j,2) + lighttotemp(j,3))
                seeds = seeds + (lighttotemp(j,1)-lighttotemp(j,2));
                break
            elseif (j==length(lighttotemp))
                seeds = seeds;
            end
        end
        % Temperature to humidity
        for j=1:length(temptohumidity)
            % Check if range fits to our seed
            if (seeds >= temptohumidity(j,2) && seeds <= ...
                    temptohumidity(j,2) + temptohumidity(j,3))
                seeds = seeds + (temptohumidity(j,1)-temptohumidity(j,2));
                break
            elseif (j==length(temptohumidity))
                seeds = seeds;
            end
        end
        % Humidity to location
        for j=1:length(humiditytolocation)
            % Check if range fits to our seed
            if (seeds >= humiditytolocation(j,2) && seeds <= ...
                    humiditytolocation(j,2) + humiditytolocation(j,3))
                seeds = seeds + (humiditytolocation(j,1)-humiditytolocation(j,2));
                break
            elseif (j==length(humiditytolocation))
                seeds = seeds;
            end
        end
        if (seeds < loc)
            loc = seeds
            index_loc = i
            current_iteration = k
        end
    end
end
23738619-loc
% Answer part 2
[lowest_loc2, index] = min(seeds);

% % We start with finding the lowest location destination
% tmp = humiditytolocation;
% [lowest_loc2,index] = min(tmp(:,1));
% % Didn't find any seed sso try 2nd lowest
% tmp(index,1) = 9999999999999;
% [lowest_loc2,index] = min(tmp(:,1));
% % Didn't find any seed sso try 3nd lowest
% tmp(index,1) = 9999999999999;
% [lowest_loc2,index] = min(tmp(:,1));
% % Our range to get to the lowest location is
% range_lowest = [tmp(index,2), tmp(index,2)+tmp(index,3)];
% % Now we need to find which temp to humidity translation leads to that
% for i=1:(range_lowest(2)-range_lowest(1))
%     for j=1:length(temptohumidity)
%         % Check if range fits to our seed
%         if (range_lowest(2)+i >= temptohumidity(j,1) && range_lowest(2)+i <= ...
%                 temptohumidity(j,1) + temptohumidity(j,3))
%             range_lowest = [temptohumidity(j,2), ...
%                     temptohumidity(j,2)+temptohumidity(j,3)];
%             break
%         end
%     end
% end
% % Repeat for light to temp
% for i=1:(range_lowest(2)-range_lowest(1))
%     for j=1:length(lighttotemp)
%         % Check if range fits to our seed
%         if (range_lowest(2)+i >= lighttotemp(j,1) && range_lowest(2)+i <= ...
%                 lighttotemp(j,1) + lighttotemp(j,3))
%             range_lowest = [lighttotemp(j,2), ...
%                     lighttotemp(j,2)+lighttotemp(j,3)];
%             break
%         end
%     end
% end
% % Repeat for water to light
% for i=1:(range_lowest(2)-range_lowest(1))
%     for j=1:length(watertolight)
%         % Check if range fits to our seed
%         if (range_lowest(2)+i >= watertolight(j,1) && range_lowest(2)+i <= ...
%                 watertolight(j,1) + watertolight(j,3))
%             range_lowest = [watertolight(j,2), ...
%                     watertolight(j,2)+watertolight(j,3)];
%             break
%         end
%     end
% end
% % Repeat for fertilizer to water
% for i=1:(range_lowest(2)-range_lowest(1))
%     for j=1:length(fertilizertowater)
%         % Check if range fits to our seed
%         if (range_lowest(2)+i >= fertilizertowater(j,1) && range_lowest(2)+i <= ...
%                 fertilizertowater(j,1) + fertilizertowater(j,3))
%             range_lowest = [fertilizertowater(j,2), ...
%                     fertilizertowater(j,2)+fertilizertowater(j,3)];
%             break
%         end
%     end
% end
% % Repeat for soil to fertilizer
% for i=1:(range_lowest(2)-range_lowest(1))
%     for j=1:length(soiltofertilizer)
%         % Check if range fits to our seed
%         if (range_lowest(2)+i >= soiltofertilizer(j,1) && range_lowest(2)+i <= ...
%                 soiltofertilizer(j,1) + soiltofertilizer(j,3))
%             range_lowest = [soiltofertilizer(j,2), ...
%                     soiltofertilizer(j,2)+soiltofertilizer(j,3)];
%             break
%         end
%     end
% end
% % Finally, repeat for seed to soil
% for i=1:(range_lowest(2)-range_lowest(1))
%     for j=1:length(seedtosoil)
%         % Check if range fits to our seed
%         if (range_lowest(2)+i >= seedtosoil(j,1) && range_lowest(2)+i <= ...
%                 seedtosoil(j,1) + seedtosoil(j,3))
%             range_lowest = [seedtosoil(j,2), ...
%                     seedtosoil(j,2)+seedtosoil(j,3)];
%             break
%         end
%     end
% end
% % Get seeds that remain
% seeds = seeds(seeds<=range_lowest(1)+range_lowest(2));
% seeds = seeds(seeds>=range_lowest(1));

