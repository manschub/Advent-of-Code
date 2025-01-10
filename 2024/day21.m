clc; clearvars;
% Advent of code 2024 - day 21 - part 1+2
% Open file and take needed data
file_id = fopen("day21.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
[x,y] = size(data{1,1});
for i = 1:x
    string(i,:) = data{1,1}{i,1};
end

% Create maps
map1 = ['7','8','9';'4','5','6';'1','2','3';'.','0','A'];
map2 = ['.','^','A';'<','v','>'];

% We have a fixed possible set of combinations for each map getting from
% start to end, so we can just get a mapping once and only use this later
% without doing any search later on
% For the first map
options = ['7','8','9','4','5','6','1','2','3','0','A'];
[mapping1] = getMapping(map1,options);
% For the second map
options = ['^','A','<','v','>'];
[mapping2] = getMapping(map2,options);

% Now for the mappings where we have multiple options let's find the best
% ones. Due to test results we simplify the mapping in the following way:
[mapping1,mapping2] = setMappings(mapping1,mapping2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to make sequence of robot control sequences to open the
% doorlock
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0; 
cache = [];
% The whole procedure we do for each sequence
for i = 1:length(string(:,1))
    len = 0;
    for j = 1:length(string(i,:))
        % We have to go backwards starting at the door until we reach ourselves
        % Press buttons on directional keypad to control robot pressing 
        % the buttons at the door
        sequence1 = []; 
        button = string(i,j);
        if (j == 1)
            start = 'A';
        else
            start = string(i,j-1);
        end
        [sequence1] = Seq1Loop(sequence1,mapping1,button,start);
        % Press buttons on directional keypad to control robot that controls the 
        % robot pressing the buttons at the door
        % For each of our shortest paths
        % Repeat this for as many additional robots as needed
        [sequence,cache] = SeqLoop(sequence1,mapping2,1,2,cache);
        % Store length
        len = length(sequence(1,:))+len;
    end
    % Calculate complexity
    result1 = result1+len*str2double(string(i,1:3));
end
fprintf('%10f',result1)
fprintf('\n')
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we have 25 robots in between
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 
cache = [];
% The whole procedure we do for each sequence
for i = 1:length(string(:,1))
    len = 0;
    for j = 1:length(string(i,:))
        % We have to go backwards starting at the door until we reach ourselves
        % Press buttons on directional keypad to control robot pressing 
        % the buttons at the door
        sequence1 = []; 
        button = string(i,j);
        if (j == 1)
            start = 'A';
        else
            start = string(i,j-1);
        end
        [sequence1] = Seq1Loop(sequence1,mapping1,button,start);
        % Press buttons on directional keypad to control robot that controls the 
        % robot pressing the buttons at the door
        % For each of our shortest paths
        % Repeat this for as many additional robots as needed
        freq = zeros(length(mapping2(:,1))+1,1);
        [freq] = SeqLoopFreq(sequence1,mapping2,1,25,freq);
        % Store length
        len_tmp = 0;
        for k = 1:length(freq(:,1))-1
            len_tmp = len_tmp + freq(k)*length(mapping2{k,3});
        end
        len_tmp = len_tmp+freq(end);
        len = len+len_tmp;
    end
    % Calculate complexity
    result2 = result2+len*str2double(string(i,1:3));
end

fprintf('%10f',result2)
fprintf('\n')
toc

% Get sequences via frequencies of taken steps
function [freq] = SeqLoopFreq(sequence1,mapping,it_start,num_it,freq)
    % Let's try to just get the frequencies of the different possible moves
    % within mapping 2
    mapping_tmp = cell2mat(mapping(:,1:2));
    % Go through iterations
    for it = it_start:num_it
        if (it == 1)
            % Go once through whole initial sequence to get the initial 
            % frequencies
            for i = 1:length(sequence1(:,1))
                j = 1;
                % Go character by character through it
                while (j <= length(sequence1(i,:)))
                    if (j==1)
                        start = 'A';
                    else
                        start = sequence1(i,j-1);
                    end
                    % Sometimes we can already be at the correct spot - 
                    % skip the search
                    if (start ~= sequence1(i,j))
                        % Increase counter for corresponding sequence
                        freq(mapping_tmp(:,1)==start & ...
                            mapping_tmp(:,2)==sequence1(i,j)) = ... 
                        freq(mapping_tmp(:,1)==start & ...
                            mapping_tmp(:,2)==sequence1(i,j)) + 1;
                    end
                    % Increase counter for A presses
                    freq(end) = freq(end) + 1;
                    j=j+1;
                end
            end
        else
            % Only get new frequencies - we only have to analyze the initial
            % frequencies for that
            old_freq = freq;
            freq2 = zeros(length(mapping(:,1))+1,1);
            freq2(end) = freq(end);
            for k = 1:length(old_freq(:,1))-1
                % Only need to check if we have that frequency
                if (old_freq(k,1) == 0)
                    continue
                else 
                    % Get the resulting string
                    str_tmp = mapping{k,3};
                    n_freq = old_freq(k);
                    % Go character by character through this short
                    % sub-sequence
                    j = 1;
                    while (j <= length(str_tmp(1,:)))
                        if (j==1)
                            start = 'A';
                        else
                            start = str_tmp(1,j-1);
                        end
                        % Sometimes we can already be at the correct spot - 
                        % skip the search
                        if (start ~= str_tmp(1,j))
                            % Increase counter for corresponding sequence
                            freq2(mapping_tmp(:,1)==start & ...
                                mapping_tmp(:,2)==str_tmp(1,j)) = ... 
                            freq2(mapping_tmp(:,1)==start & ...
                                mapping_tmp(:,2)==str_tmp(1,j)) + n_freq;
                        end
                        % Increase counter for A presses
                        freq2(end) = freq2(end) + n_freq;
                        j=j+1;
                    end
                    % We also have to add the sequence from the last 
                    % character back to A
                    freq2(mapping_tmp(:,1)==mapping{k,3}(end) & ...
                                mapping_tmp(:,2)=='A') = ... 
                    freq2(mapping_tmp(:,1)==mapping{k,3}(end) & ...
                        mapping_tmp(:,2)=='A') + n_freq;
                end
            end
            freq = freq2;
        end
    end
end

% Get sequence from robot to robot with map2
function [sequence_out,cache] = SeqLoop(sequence1,mapping,it,num_it,cache)
    % For each of our initial sequences we create all possible new
    % sequences for the next abstraction
    sequence_out = []; 
    mapping_tmp = cell2mat(mapping(:,1:2));
    for i = 1:length(sequence1(:,1))
        sequence2 = []; 
        j = 2;
        cached = 0;
        % Add the initial 'A'
        sequence1 = ['A',sequence1];
        while (j <= length(sequence1(i,:)))
            % Check if we have a part of the translation already in our
            % cache
            start = sequence1(i,j-1);
            % Sometimes we can already be at the correct spot - 
            % skip the search
            if (start == sequence1(i,j))
                sequence2 = [sequence2,'A'];
                j=j+1;
            else
                % Check cache here
                if (~isempty(cache) && j>1)
                    for k = length(cache(:,1)):-1:1
                        if (length(sequence1(i,:)) > j+length(cache{k,1}))
                            % Check if we have identical part
                            if (sequence1(i,j-1:j-2+length(cache{k,1})) == ...
                                    cache{k,1})
                                % Enter the corresponding string in the 
                                % sequence
                                sequence2 = [sequence2,cache{k,2}];
                                j = j+length(cache{k,1})-1;
                                cached = 1;
                                break
                            end
                        end
                    end
                end
                % If we took a cached value we continue with the next step
                if (cached == 1)
                    cached = 0;
                else
                    % Find the fitting entry from our mapping
                    seq_tmp = mapping{mapping_tmp(:,1)==start & ...
                        mapping_tmp(:,2)==sequence1(i,j),3};
                    sequence2 = [sequence2,seq_tmp,'A'];
                    % Cache our "translation"
                    if (isempty(cache))
                        cache{1,1} = sequence1(i,1:j);
                        cache{1,2} = sequence2;
                    else
                        cache{end+1,1} = sequence1(i,1:j);
                        cache{end,2} = sequence2;
                    end
                    j=j+1;
                end
            end
        end
        % After each iteration sort cache to avoid only checking for the
        % short ones again and again
        [~,idx] = sort(cellfun('length', cache));
        cache(:,1) = cache(idx(:,1),1);
        cache(:,2) = cache(idx(:,1),2);
        % Store current sequence variations
        if (it<num_it)
            [sequence_out_tmp,cache] = SeqLoop(sequence2,mapping,it+1,num_it,cache);
            if (i==1)
                sequence_out = sequence_out_tmp;
            else
                % Check if we have shorter paths as before
                if (length(sequence_out_tmp(1,:)) < length(sequence_out(1,:)))
                    sequence_out = sequence_out_tmp;
                end
            end
        elseif (i==1)
            sequence_out = sequence2;
        else
            % Check if we have shorter paths as before
            if (length(sequence2(1,:)) < length(sequence_out(1,:)))
                sequence_out = sequence2;
            end
        end
    end
end

% Get sequence from numpad to first robot
function [sequence1] = Seq1Loop(sequence1,mapping,string,first)
    
    for j = 1:length(string(1,:))
        if (j==1)
            start = first;
        else
            start = string(1,j-1);
        end
        % Sometimes we can already be at the correct spot - skip the search
        if (start == string(1,j))
            seq_tmp = sequence1(end);
        else
            % Find the fitting entry from our mapping
            % idx of start and goal
            idx_s = find(strcmp(mapping(:,1),start));
            idx_f = find(strcmp(mapping(:,2),string(1,j)));
            % Now get combinations for these indexes
            [c,~] = ismember(idx_s,idx_f) ;
            idx = idx_s(c);
            seq_tmp = mapping{idx,3};
        end
        if (j>1)
            tmp = sequence1;
            sequence1 = '';
            for l = 1:length(tmp(:,1))
                if (l == 1)
                    if (length(seq_tmp)==1)
                        if (seq_tmp == 'A')
                            sequence1 = strcat(tmp(l,:),'A');
                        else
                            sequence1 = strcat(tmp(l,:),seq_tmp,'A');
                        end
                    else
                        sequence1 = strcat(tmp(l,:),seq_tmp,'A');
                    end
                else
                    if (length(seq_tmp)==1)
                        if (seq_tmp == 'A')
                            sequence1(end+1:end+length(seq_tmp(:,1)),:) = ...
                                strcat(tmp(l,:),'A');
                        else
                            sequence1(end+1:end+length(seq_tmp(:,1)),:) = ...
                                strcat(tmp(l,:),seq_tmp,'A');
                        end
                    else
                        sequence1(end+1:end+length(seq_tmp(:,1)),:) = ...
                            strcat(tmp(l,:),seq_tmp,'A');
                    end
                end
            end
        else
            sequence1 = strcat(sequence1,seq_tmp,'A');
        end
    end
end

% Map all options
function [mapping] = getMapping(map,options)
    % Initialize
    mapping = [];
    % Outer loop over all options
    for i = 1:length(options)
        % Inner loop over all options
        for j = 1:length(options)
            seq_tmp = '';
            if (j == i)
                continue
            end
            cache = [];
            [seq,~,lowest] = WayToButton(map,options(i),options(j),cache,'');
            % Discard too long sequences and concatenate to new strings
            for k = 1:length(seq)
                if (length(seq{k}) == lowest)
                    if (isempty(seq_tmp))
                        seq_tmp = seq{k};
                    else
                        seq_tmp(end+1,:) = seq{k};
                    end
                end
            end
            if (isempty(mapping))
                mapping = {options(i),options(j),seq_tmp};
            else
                mapping(end+1,:) = {options(i),options(j),seq_tmp};
            end
        end
    end
end

% Due to test results we simplify the mapping in the following way
function [mapping1,mapping2] = setMappings(mapping1,mapping2)

    % Mapping1:
    mapping1{4,3} = mapping1{4,3}(1,:); 
    mapping1{5,3} = mapping1{4,3}(1,:);
    mapping1{7,3} = mapping1{7,3}(1,:); 
    mapping1{8,3} = mapping1{8,3}(1,:);
    mapping1{9,3} = mapping1{9,3}(1,:); 
    mapping1{10,3} = mapping1{10,3}(1,:);
    mapping1{13,3} = mapping1{13,3}(2,:);
    mapping1{15,3} = mapping1{15,3}(2,:);
    mapping1{16,3} = mapping1{16,3}(1,:);
    mapping1{18,3} = mapping1{18,3}(1,:);
    mapping1{20,3} = mapping1{20,3}(4,:);
    mapping1{23,3} = mapping1{23,3}(1,:);
    mapping1{24,3} = mapping1{24,3}(1,:);
    mapping1{26,3} = mapping1{26,3}(1,:);
    mapping1{27,3} = mapping1{27,3}(1,:);
    mapping1{29,3} = mapping1{29,3}(1,:);
    mapping1{32,3} = mapping1{32,3}(1,:);
    mapping1{33,3} = mapping1{33,3}(1,:);
    mapping1{37,3} = mapping1{37,3}(1,:);
    mapping1{38,3} = mapping1{38,3}(1,:);
    mapping1{39,3} = mapping1{39,3}(1,:);
    mapping1{40,3} = mapping1{40,3}(1,:);
    mapping1{41,3} = mapping1{41,3}(1,:);
    mapping1{43,3} = mapping1{43,3}(1,:);
    mapping1{46,3} = mapping1{46,3}(1,:);
    mapping1{48,3} = mapping1{48,3}(1,:);
    mapping1{50,3} = mapping1{50,3}(3,:);
    mapping1{51,3} = mapping1{51,3}(1,:);
    mapping1{52,3} = mapping1{52,3}(1,:);
    mapping1{56,3} = mapping1{56,3}(3,:);
    mapping1{57,3} = mapping1{57,3}(1,:);
    mapping1{59,3} = mapping1{59,3}(1,:);
    mapping1{62,3} = mapping1{62,3}(1,:);
    mapping1{63,3} = mapping1{63,3}(3,:);
    mapping1{65,3} = mapping1{65,3}(1,:);
    mapping1{66,3} = mapping1{66,3}(1,:);
    mapping1{70,3} = mapping1{70,3}(1,:);
    mapping1{71,3} = mapping1{71,3}(1,:);
    mapping1{73,3} = mapping1{73,3}(1,:);
    mapping1{74,3} = mapping1{74,3}(1,:);
    mapping1{76,3} = mapping1{76,3}(1,:);
    mapping1{80,3} = mapping1{80,3}(1,:);
    mapping1{81,3} = mapping1{81,3}(1,:);
    mapping1{82,3} = mapping1{82,3}(3,:);
    mapping1{84,3} = mapping1{84,3}(1,:);
    mapping1{85,3} = mapping1{85,3}(1,:);
    mapping1{89,3} = mapping1{89,3}(1,:);
    mapping1{91,3} = mapping1{91,3}(1,:);
    mapping1{93,3} = mapping1{93,3}(1,:);
    mapping1{94,3} = mapping1{94,3}(1,:);
    mapping1{96,3} = mapping1{96,3}(1,:);
    mapping1{99,3} = mapping1{99,3}(1,:);
    mapping1{101,3} = mapping1{101,3}(1,:);
    mapping1{102,3} = mapping1{102,3}(4,:);
    mapping1{104,3} = mapping1{104,3}(1,:);
    mapping1{105,3} = mapping1{105,3}(1,:);
    mapping1{107,3} = mapping1{107,3}(1,:);
    mapping1{108,3} = mapping1{108,3}(1,:);
    % Mapping2:
    mapping2{4,3} = mapping2{4,3}(2,:);
    mapping2{6,3} = mapping2{6,3}(1,:);
    mapping2{7,3} = mapping2{7,3}(2,:);
    mapping2{10,3} = mapping2{10,3}(2,:);
    mapping2{14,3} = mapping2{14,3}(1,:);
    mapping2{17,3} = mapping2{17,3}(2,:);
end

% We have a very short path so DFS should be fine
function [sequence,cache,lowest] = WayToButton(map,s,f,cache,seq)
    % Depth-first search
    lowest = 0;
    % I need to store current direction, current position in row and
    % column, and current weight (we start from A)
    [r,c] = find(map==s);
    todo(1,1:2) = [r,c]; sequence = [];
    % We need to do the whole thing depth first to find all shortest paths
    % Check if we reached the end
    if (map(todo(1,1),todo(1,2))==f)
        % See if our solution is better than the previous lowest score
        if (lowest == 0 || length(seq) < lowest)
            lowest = length(seq);
            sequence{1} = seq;
        end
        % End of this path - go back
        return
    end
    map(r,c) = '.';
    % At this point we need to fill our cache 
    if (isempty(cache))
        cache(1,1:3) = [todo(1,1),todo(1,2),length(seq)];
    else
        % We need to check if we already crossed this field from the 
        % same direction and if the weight is higher than the one in our 
        % cache then we can cancel the path here. If it is smaller we can 
        % replace the weight of the cache entry
        [loc,~] = find(cache(:,1) == todo(1,1) & ...
                        cache(:,2) == todo(1,2));
        if (~isempty(loc))
            % We already crossed this tile with the same direction and a 
            % smaller weight so we can stop
            if (cache(loc,3) < length(seq)) 
                return
            elseif (length(seq) <= cache(loc,3))
                % We found a path over the same tile with the same 
                % direction which is cheaper - store it 
                cache(loc,3) = length(seq);
            end 
        else
            cache(end+1,1:3) = [todo(1,1),todo(1,2),length(seq)];
        end
    end
    % Now we split our path (we can always go in each of the four
    % directions that are within the map and not '.')
    % North
    if (todo(1,1)>1)
        if (map(todo(1,1)-1,todo(1,2)) ~= '.')
            % Facing North
            [seq_tmp,cache,lowest_tmp] = WayToButton(map, ...
                map(todo(1,1)-1,todo(1,2)),f,cache,strcat(seq,'^'));
            if ((lowest == 0 && lowest_tmp > 0) || ...
                    (lowest_tmp > 0 && lowest_tmp <= lowest))
                lowest = lowest_tmp;
                if (isempty(sequence))
                    sequence = seq_tmp;
                else
                    sequence(end+1:end+length(seq_tmp),:) = seq_tmp;
                end
            end
        end
    end
    % East
    if (todo(1,2)<length(map(1,:)))
        if (map(todo(1,1),todo(1,2)+1) ~= '.')
            % Facing East
            [seq_tmp,cache,lowest_tmp] = WayToButton(map, ...
                map(todo(1,1),todo(1,2)+1),f,cache,strcat(seq,'>'));
            if ((lowest == 0 && lowest_tmp > 0) || ...
                    (lowest_tmp > 0 && lowest_tmp <= lowest))
                lowest = lowest_tmp;
                if (isempty(sequence))
                    sequence = seq_tmp;
                else
                    sequence(end+1:end+length(seq_tmp),:) = seq_tmp;
                end
            end
        end
    end
    % South
    if (todo(1,1)<length(map(:,1)))
        if (map(todo(1,1)+1,todo(1,2)) ~= '.')
            % Facing South
            [seq_tmp,cache,lowest_tmp] = WayToButton(map, ...
                map(todo(1,1)+1,todo(1,2)),f,cache,strcat(seq,'v'));
            if ((lowest == 0 && lowest_tmp > 0) || ...
                    (lowest_tmp > 0 && lowest_tmp <= lowest))
                lowest = lowest_tmp;
                if (isempty(sequence))
                    sequence = seq_tmp;
                else
                    sequence(end+1:end+length(seq_tmp),:) = seq_tmp;
                end
            end
        end
    end
    % West
    if (todo(1,2)>1)
        if (map(todo(1,1),todo(1,2)-1) ~= '.')
            % Facing West
            [seq_tmp,cache,lowest_tmp] = WayToButton(map, ...
                map(todo(1,1),todo(1,2)-1),f,cache,strcat(seq,'<'));
            if ((lowest == 0 && lowest_tmp > 0) || ...
                    (lowest_tmp > 0 && lowest_tmp <= lowest))
                lowest = lowest_tmp;
                if (isempty(sequence))
                    sequence = seq_tmp;
                else
                    sequence(end+1:end+length(seq_tmp),:) = seq_tmp;
                end
            end
        end
    end
end

