clc; clear all;
% Advent of code 2023 - day 20 - part 1+2
% Open file and take needed data
file_id = fopen("day20.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

tic
f = 1; c = 1; b = 1;
% Rearrange data to be handled nicer
for i = 1:length(data{1,1})
    % The -> seperates our sources from destinations
    [~,loc] = find(data{1,1}{i,1}=='>');
    % Store sources and destinations
    sources{i,1} = data{1,1}{i,1}(1:loc-3);
    destinations{i,1} = data{1,1}{i,1}(loc+2:end);
    % Modules with % are flipflops
    if (sources{i,1}(1) == '%')
        flipflop{f,1} = sources{i,1};
        flipflop{f,2} = 'of';
        f = f+1;
    % Modules with & are conjunctions
    elseif (sources{i,1}(1) == '&')
        conjunction{c,1} = sources{i,1};
        c = c+1;
    else
    % Other modules are broadcasters
        sources{i,1} = strcat('#',sources{i,1});
        broadcaster{b,1} = sources{i,1};
        b = b+1;
        broadcaster_id = i;
    end
end
% For the conjunctions I need to know how many inputs they have
for i = 1:length(conjunction(:,1))
    % Determine non-emtpy length of conjunction
    if (length(conjunction(1,:)) == 1)
        q = 2;
    else
        for p = 2:length(conjunction(1,:))
            if (isempty(conjunction{i,p}))
                q = p;
                break
            end
        end
    end
    % Find where the current conjunction is a destination and add an entry
    % of memory for each
    for j = 1:length(destinations)
        if (length(destinations{j,1}) >= length(conjunction{i,1}(2:end)))
            % Go through each destination
            [~,loc_comma] = find(destinations{j,1} == ',');
            if (~isempty(loc_comma))
                for k = 1:length(loc_comma)+1
                    if(k == 1)
                        tmp = destinations{j,1}(1:loc_comma(1)-1);
                        if (length(tmp) == length(conjunction{i,1}(2:end)) && ...
                            all(tmp == conjunction{i,1}(2:end)))
                            conjunction{i,q} = sources{j,1}(2:end);
                            conjunction{i,q+1} = 'lo';
                            q = q+2;
                        end
                    elseif (k == length(loc_comma)+1)
                        tmp = destinations{j,1}(loc_comma(end)+2:end);
                        if (length(tmp) == length(conjunction{i,1}(2:end)) && ...
                            all(tmp == conjunction{i,1}(2:end)))
                            conjunction{i,q} = sources{j,1}(2:end);
                            conjunction{i,q+1} = 'lo';
                            q = q+2;
                        end
                    else
                        tmp = destinations{j,1}(loc_comma(k-1)+2:loc_comma(k)-1);
                        if (length(tmp) == length(conjunction{i,1}(2:end)) && ...
                            all(tmp == conjunction{i,1}(2:end)))
                            conjunction{i,q} = sources{j,1}(2:end);
                            conjunction{i,q+1} = 'lo';
                            q = q+2;
                        end
                    end
                end
            else
                tmp = destinations{j,1}(1:end);
                if (length(tmp) == length(conjunction{i,1}(2:end)) && ...
                    all(tmp == conjunction{i,1}(2:end)))
                    conjunction{i,q} = sources{j,1}(2:end);
                    conjunction{i,q+1} = 'lo';
                    q = q+2;
                end
            end
        end
    end
end

% Number of button pushes we do (take enough to be able to filter out
% frequencies afterwards for part 2)
num_button_pushes = 5000;
% Initialize low and high pulses
low = 0; high = 0; rx_triggered = 0;
% We solve recursively (again...)
j = 1; k = 1; l = 1; m = 1;
th_store = []; xn_store = [];  qn_store = [];  zl_store = []; xf_store = []; 
for i = 1:num_button_pushes
    % We start with the button push in the first step
    schedule = [];
    % Button pushed
    low = low+1;
    pulse = 'lo';
    id = sources{broadcaster_id}(2:end);
    idx = i;
    % Start the pulse propagation
    [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
        xn_store,qn_store,zl_store,xf_store] = ...
        pulsing(idx,sources,destinations,flipflop,conjunction, ...
        broadcaster,low,high,pulse,id,0,0,schedule,rx_triggered,th_store, ...
        xn_store,qn_store,zl_store,xf_store);
    if (rx_triggered == 1)
        fprintf('Result part 2: %10f',i)
        fprintf('\n')
        rx_triggered = 0;
    end
    if (i == 1000)
        result_part1 = low*high;
        fprintf('Result part 1: %10f',result_part1)
        fprintf('\n')
    end
end

% Part 2 logic
% th sends low to rx once it is completely set to high
% that happens when xn, qn, zl, and xf send high to th at the same time
% that happens when xn, qn, zl, and xf are not completely set to high

% We gathered the frequencies during the run - now find LCM for result
tmp = lcm(qn_store{1,end},xf_store{1,end});
tmp = lcm(tmp,xn_store{1,end});
result_part2 = lcm(tmp,zl_store{1,end});
fprintf('Result part 2: %10f',result_part2)
fprintf('\n')
toc

% Pulse following routine
function [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...         
        xn_store,qn_store,zl_store,xf_store] = ...
        pulsing(idx,sources,destinations,flipflop,conjunction, ...
        broadcaster,low,high,pulse,id,source_id_old,layer,schedule,rx_triggered, ...
        th_store,xn_store,qn_store,zl_store,xf_store)

    if (length(id) == 2 && all(id == 'th') && all(pulse == 'hi'))
        if (isempty(th_store))
            th_store = conjunction(7,:);
            th_store{end,end+1} = idx;
        else
            th_store(end+1,1:21) = conjunction(7,:);
            th_store{end,22} = idx;
        end
        
    end
    if (length(id) == 2 && all(id == 'xn') && all(pulse == 'lo'))
        if (isempty(xn_store))
            xn_store = conjunction(1,:);
            xn_store{end,end+1} = idx;
        else
            xn_store(end+1,1:21) = conjunction(1,:);
            xn_store{end,22} = idx;
        end
    end
    if (length(id) == 2 && all(id == 'qn') && all(pulse == 'lo'))
        if (isempty(qn_store))
            qn_store = conjunction(2,:);
            qn_store{end,end+1} = idx;
        else
            qn_store(end+1,1:21) = conjunction(2,:);
            qn_store{end,22} = idx;
        end
    end
    if (length(id) == 2 && all(id == 'zl') && all(pulse == 'lo'))
        if (isempty(zl_store))
            zl_store = conjunction(5,:);
            zl_store{end,end+1} = idx;
        else
            zl_store(end+1,1:21) = conjunction(5,:);
            zl_store{end,22} = idx;
        end
    end
    if (length(id) == 2 && all(id == 'xf') && all(pulse == 'lo'))
        if (isempty(xf_store))
            xf_store = conjunction(3,:);
            xf_store{end,end+1} = idx;
        else
            xf_store(end+1,1:21) = conjunction(3,:);
            xf_store{end,22} = idx;
        end
    end

    stop = 0; layer = layer+1; type = -1;

    if (length(id) == 2 && all(id == 'rx') && all(pulse == 'lo'))
        rx_triggered = 1;
    end

    % Here we first need to determine which module we are pulsing at
    for i = 1:length(sources)
        if (length(sources{i,1}(2:end)) == length(id) && ...
                all(sources{i,1}(2:end) == id))
            source_id = i;
            % Once we found it we also need to set its type (0 =
            % broadcaster, 1 = flipflop, 2 = conjunction)
            for j = 1:length(broadcaster)
                if (length(id) == length(broadcaster{j,1}(2:end)) && ...
                        all(broadcaster{j,1}(2:end) == id))
                    broadcaster_id = j;
                    type = 0;
                    stop = 1;
                    break
                end
            end
            if (stop == 1)
                break
            end
            for j = 1:length(flipflop)
                if (length(id) == length(flipflop{j,1}(2:end)) && ...
                        all(flipflop{j,1}(2:end) == id))
                    flipflop_id = j;
                    type = 1;
                    stop = 1;
                    break
                end
            end
            if (stop == 1)
                break
            end
            for j = 1:length(conjunction(:,1))
                if (length(id) == length(conjunction{j,1}(2:end)) && ...
                        all(conjunction{j,1}(2:end) == id))
                    conjunction_id = j;
                    type = 2;
                    break
                end
            end
            break
        end
    end
    % Now depending on type we deliver pulses to destination modules
    % !!!!!!!!!!! Take care that the order is correct !!!!!!!!!!!!!
    % We only send pulses while we are in the first layer and just schedule
    % them otherwise
    % No fitting source for destination so we skip
    if (type == -1)
        
    % Broadcast sends same pulse further
    elseif (type == 0)
        % Broadcast - we just send the pulse further for each destination
        [~,loc_comma] = find(destinations{source_id,1} == ',');
        if (~isempty(loc_comma))
            for i = 1:length(loc_comma)+1
                if(i == 1)
                    id = destinations{source_id,1}(1:loc_comma(1)-1);
                    % Only if we are in layer 1 otherwise schedule it
                    if (layer == 1)
                        if (all(pulse == 'lo'))
                            low = low+1;
                        else
                            high = high+1;
                        end
                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                    else
                        schedule{1,end+1} = id;
                        schedule{2,end} = pulse;
                        schedule{3,end} = source_id;
                    end
                elseif (i == length(loc_comma)+1)
                    id = destinations{source_id,1}(loc_comma(end)+2:end);
                    % Only if we are in layer 1 otherwise schedule it
                    if (layer == 1)
                        if (all(pulse == 'lo'))
                            low = low+1;
                        else
                            high = high+1;
                        end
                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                    else
                        schedule{1,end+1} = id;
                        schedule{2,end} = pulse;
                        schedule{3,end} = source_id;
                    end
                else
                    id = destinations{source_id,1}(loc_comma(i-1)+2:loc_comma(i)-1);
                    % Only if we are in layer 1 otherwise schedule it
                    if (layer == 1)
                        if (all(pulse == 'lo'))
                            low = low+1;
                        else
                            high = high+1;
                        end
                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                    else
                        schedule{1,end+1} = id;
                        schedule{2,end} = pulse;
                        schedule{3,end} = source_id;
                    end
                end
            end
        else
            id = destinations{source_id,1};
            % Only if we are in layer 1 otherwise schedule it
            if (layer == 1)
                if (all(pulse == 'lo'))
                    low = low+1;
                else
                    high = high+1;
                end
                [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
            else
                schedule{1,end+1} = id;
                schedule{2,end} = pulse;
                schedule{3,end} = source_id;
            end
        end
    elseif (type == 1)
        % Flipflop: if low switch between on and off, if high nothing, if it
        % flips from off to on it sends high pulse, if it flips from on to off
        % it sends low pulse
        if (all(pulse == 'lo'))
            % Low pulse to each destination
            if (all(flipflop{flipflop_id,2} == 'of'))
                flipflop{flipflop_id,2} = 'on';
                % Find all destinations
                [~,loc_comma] = find(destinations{source_id,1} == ',');
                if (~isempty(loc_comma))
                    % Go through each destination
                    for i = 1:length(loc_comma)+1
                        if(i == 1)
                            id = destinations{source_id,1}(1:loc_comma(1)-1);
                            if (layer == 1)
                                high = high+1;
                                pulse = 'hi';
                                [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                            else
                                schedule{1,end+1} = id;
                                schedule{2,end} = 'hi';
                                schedule{3,end} = source_id;
                            end
                        elseif (i == length(loc_comma)+1)
                            id = destinations{source_id,1}(loc_comma(end)+2:end);
                            if (layer == 1)
                                high = high+1;
                                pulse = 'hi';
                                [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                            else
                                schedule{1,end+1} = id;
                                schedule{2,end} = 'hi';
                                schedule{3,end} = source_id;
                            end
                        else
                            id = destinations{source_id,1}(loc_comma(i-1)+2:loc_comma(i)-1);
                            if (layer == 1)
                                high = high+1;
                                pulse = 'hi';
                                [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                            else
                                schedule{1,end+1} = id;
                                schedule{2,end} = 'hi';
                                schedule{3,end} = source_id;
                            end
                        end
                    end
                else
                    % Only one destination
                    id = destinations{source_id,1};
                    if (layer == 1)
                        high = high+1;
                        pulse = 'hi';
                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                    else
                        schedule{1,end+1} = id;
                        schedule{2,end} = 'hi';
                        schedule{3,end} = source_id;
                    end
                end
            else
                flipflop{flipflop_id,2} = 'of';
                % Find all destinations
                [~,loc_comma] = find(destinations{source_id,1} == ',');
                if (~isempty(loc_comma))
                    % Go through each destination
                    for i = 1:length(loc_comma)+1
                        if(i == 1)
                            id = destinations{source_id,1}(1:loc_comma(1)-1);
                            if (layer == 1)
                                low = low+1;
                                pulse = 'lo';
                                [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                            else
                                schedule{1,end+1} = id;
                                schedule{2,end} = 'lo';
                                schedule{3,end} = source_id;
                            end
                        elseif (i == length(loc_comma)+1)
                            id = destinations{source_id,1}(loc_comma(end)+2:end);
                            if (layer == 1)
                                low = low+1;
                                pulse = 'lo';
                                [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                            else
                                schedule{1,end+1} = id;
                                schedule{2,end} = 'lo';
                                schedule{3,end} = source_id;
                            end
                        else
                            id = destinations{source_id,1}(loc_comma(i-1)+2:loc_comma(i)-1);
                            if (layer == 1)
                                low = low+1;
                                pulse = 'lo';
                                [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                            else
                                schedule{1,end+1} = id;
                                schedule{2,end} = 'lo';
                                schedule{3,end} = source_id;
                            end
                        end
                    end
                else
                    % Only one destination
                    id = destinations{source_id,1};
                    if (layer == 1)
                        low = low+1;
                        pulse = 'lo';
                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                    else
                        schedule{1,end+1} = id;
                        schedule{2,end} = 'lo';
                        schedule{3,end} = source_id;
                    end
                end
            end
        else
            % High pulse - Nothing happens
        end
    else
        % Conjunction remember last pulse for each input, if high for each
        % input then sends low pulse, otherwise high pulse
        size_tmp = size(conjunction);
        for i = 2:2:size_tmp(2)
            % Go through all inputs
            if (length(sources{source_id_old,1}(2:end)) == ...
                length(conjunction{conjunction_id,i}) && ...
                all(sources{source_id_old,1}(2:end) == ...
                conjunction{conjunction_id,i}))
                % We have the correct position
                % Adjust pulse memory for the entry
                conjunction{conjunction_id,i+1} = pulse;
                % If our pulse was high check if all of them are high now
                for j = 3:2:size_tmp(2)
                    if (isempty(conjunction{conjunction_id,j}) || ...
                            all(conjunction{conjunction_id,j} == 'hi'))
                    else
                        % Send low pulse to each destination
                        % Find all destinations
                        [~,loc_comma] = find(destinations{source_id,1} == ',');
                        if (~isempty(loc_comma))
                            % Go through each destination
                            for k = 1:length(loc_comma)+1
                                if(k == 1)
                                    id = destinations{source_id,1}(1:loc_comma(1)-1);
                                    if (layer == 1)
                                        pulse = 'hi';
                                        low = low+1;
                                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                                    else
                                        schedule{1,end+1} = id;
                                        schedule{2,end} = 'hi';
                                        schedule{3,end} = source_id;
                                    end
                                elseif (k == length(loc_comma)+1)
                                    id = destinations{source_id,1}(loc_comma(end)+2:end);
                                    if (layer == 1)
                                        pulse = 'hi';
                                        low = low+1;
                                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                                    else
                                        schedule{1,end+1} = id;
                                        schedule{2,end} = 'hi';
                                        schedule{3,end} = source_id;
                                    end
                                else
                                    id = destinations{source_id,1}(loc_comma(k-1)+2:loc_comma(k)-1);
                                    if (layer == 1)
                                        pulse = 'hi';
                                        low = low+1;
                                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                                    else
                                        schedule{1,end+1} = id;
                                        schedule{2,end} = 'hi';
                                        schedule{3,end} = source_id;
                                    end
                                end
                            end
                        else
                            % Only one destination
                            id = destinations{source_id,1};
                            if (layer == 1)
                                pulse = 'hi';
                                low = low+1;
                                [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                            else
                                schedule{1,end+1} = id;
                                schedule{2,end} = 'hi';
                                schedule{3,end} = source_id;
                            end
                        end
                        break
                    end
                    if (j == size_tmp(2))
                        % Send low pulse to each destination
                        % Find all destinations
                        [~,loc_comma] = find(destinations{source_id,1} == ',');
                        if (~isempty(loc_comma))
                            % Go through each destination
                            for k = 1:length(loc_comma)+1
                                if(k == 1)
                                    id = destinations{source_id,1}(1:loc_comma(1)-1);
                                    if (layer == 1)
                                        pulse = 'lo';
                                        high = high+1;
                                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                                    else
                                        schedule{1,end+1} = id;
                                        schedule{2,end} = 'lo';
                                        schedule{3,end} = source_id;
                                    end
                                elseif (k == length(loc_comma)+1)
                                    id = destinations{source_id,1}(loc_comma(end)+2:end);
                                    if (layer == 1)
                                        pulse = 'lo';
                                        high = high+1;
                                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                                    else
                                        schedule{1,end+1} = id;
                                        schedule{2,end} = 'lo';
                                        schedule{3,end} = source_id;
                                    end
                                else
                                    id = destinations{source_id,1}(loc_comma(k-1)+2:loc_comma(k)-1);
                                    if (layer == 1)
                                        pulse = 'lo';
                                        high = high+1;
                                        [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                                    else
                                        schedule{1,end+1} = id;
                                        schedule{2,end} = 'lo';
                                        schedule{3,end} = source_id;
                                    end
                                end
                            end
                        else
                            % Only one destination
                            id = destinations{source_id,1};
                            if (layer == 1)
                                pulse = 'lo';
                                high = high+1;
                                [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
                            else
                                schedule{1,end+1} = id;
                                schedule{2,end} = 'lo';
                                schedule{3,end} = source_id;
                            end
                        end
                    end
                end
                break
            end
        end
    end
    % Now perform scheduled pulses if layer 1
    if (layer == 1)
        while (~isempty(schedule))
            id = schedule{1,1};
            pulse = schedule{2,1};
            source_id = schedule{3,1};
            if (all(pulse == 'lo'))
                low = low+1;
            else
                high = high+1;
            end
            % Delete current action from schedule
            if (length(schedule(1,:)) >= 2)
                schedule = schedule(1:3,2:end);
            else
                schedule = [];
            end
            [idx,flipflop,conjunction,low,high,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store] = ...
                            pulsing(idx,sources,destinations,flipflop,conjunction, ...
                            broadcaster,low,high,pulse,id,source_id,layer,schedule,rx_triggered,th_store, ...
                            xn_store,qn_store,zl_store,xf_store);
        end
    end
end

