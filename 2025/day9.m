clc; clearvars;
% Advent of code 2025 - day 9 - part 1+2
% Open file and take needed data
file_id = fopen("day9_test.dat");
data = textscan(file_id,'%f %f %f','delimiter',', ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Rearrange data
x = data{1,1}; y = data{1,2}; z = data{1,3};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find closest connections between junctions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
circuit = []; matches = []; cnt = 0;
% Get all distances
for i = 1:length(x)
    % Calculate distance to all other junctions 
    for j = i+1:length(x)
        dist(i,j) = sqrt((x(j)-x(i))^2 + (y(j)-y(i))^2 + (z(j)-z(i))^2);
    end
end
dist(dist==0) = 99999999999999999999;
dist_min = 0;
% Go through junctions
while (cnt<1000)
    [dist_min,pos] = min(dist(dist(:)>dist_min));
    [tmp(1),tmp(2)] = find(dist==dist_min);
    % Check if we already have this combination in a circuit
    if (~isempty(matches))
        if (any(matches(:,1)==tmp(1) & matches(:,2)==tmp(2)))
            % We already have that connection
            continue
        end
    end
    % Store connection
    matches(end+1,1:2) = tmp;
    if (isempty(circuit))
        circuit = tmp;
        cnt = cnt+1;
    else
        % Check if we have a circuit with one of the partners already
        [rowi,coli] = find(circuit==tmp(1));
        [rowj,colj] = find(circuit==tmp(2));
        test = 0;
        for l=1:length(rowi)
            if (any(rowj==rowi(l)))
                test=1;
                break
            end
        end
        if (~isempty(rowi) && ~isempty(rowj) && test == 1) 
            cnt = cnt+1;
        elseif (~isempty(rowi) && ~isempty(rowj))
            % We need to merge
            circuit(:,end+1:size(circuit,2)*2) = 0;
            circuit(rowi,:) = [circuit(rowi,1:size(circuit,2)/2), ...
                circuit(rowj,1:size(circuit,2)/2)];
            circuit(rowj,:) = [];
            cnt = cnt+1;
        elseif(~isempty(rowi))
            circuit(rowi,end+1) = tmp(2);
            cnt = cnt+1;
        elseif(~isempty(rowj))
            circuit(rowj,end+1) = tmp(1);
            cnt = cnt+1;
        else
            circuit(end+1,:) = 0;
            circuit(end,1:2) = tmp;
            cnt = cnt+1;
        end 
    end
    [cols] = find(all(circuit==0));
    if (~isempty(cols))
        circuit(:,cols) = [];
    end
end
% Now calculate the result multiplying the length of the junctions
result1 = 0;
tmp_circ = circuit~=0;
for i = 1:size(circuit,1)
    cnt_junc(i) = sum(tmp_circ(i,:));
end
for i = 1:3
    [val,idx] = max(cnt_junc);
    if (i==1)
        result1 = val;
    else
        result1 = result1*val;
    end
    cnt_junc(idx)=[];
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - We need to connect stuff until all are in one circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
finished = 0;
% Continue where we stopped
while (finished~=1)
    [dist_min,pos] = min(dist(dist(:)>dist_min));
    [tmp(1),tmp(2)] = find(dist==dist_min);
    % Check if we already have this combination in a circuit
    if (~isempty(matches))
        if (any(matches(:,1)==tmp(1) & matches(:,2)==tmp(2)))
            % We already have that connection
            continue
        end
    end
    % Store connection
    matches(end+1,1:2) = tmp;
    if (isempty(circuit))
        circuit = tmp;
        cnt = cnt+1;
    else
        % Check if we have a circuit with one of the partners already
        [rowi,coli] = find(circuit==tmp(1));
        [rowj,colj] = find(circuit==tmp(2));
        test = 0;
        for l=1:length(rowi)
            if (any(rowj==rowi(l)))
                test=1;
                break
            end
        end
        if (~isempty(rowi) && ~isempty(rowj) && test == 1) 
            cnt = cnt+1;
        elseif (~isempty(rowi) && ~isempty(rowj))
            % We need to merge
            circuit(:,end+1:size(circuit,2)*2) = 0;
            circuit(rowi,:) = [circuit(rowi,1:size(circuit,2)/2), ...
                circuit(rowj,1:size(circuit,2)/2)];
            circuit(rowj,:) = [];
            cnt = cnt+1;
        elseif(~isempty(rowi))
            circuit(rowi,end+1) = tmp(2);
            cnt = cnt+1;
        elseif(~isempty(rowj))
            circuit(rowj,end+1) = tmp(1);
            cnt = cnt+1;
        else
            circuit(end+1,:) = 0;
            circuit(end,1:2) = tmp;
            cnt = cnt+1;
        end 
    end
    [cols] = find(all(circuit==0));
    if (~isempty(cols))
        circuit(:,cols) = [];
    end
    % Check if we have everything within one circuit
    if (size(circuit,1)==1)
        circuit(circuit==0) = [];
        if (size(circuit,2)==size(x,1))
            finished = 1;
        end
    end
end
% Now calculate the result multiplying the length of the junctions
% Multiply the x coordinates of the last two boxes
result2 = x(tmp(1))*x(tmp(2));

fprintf('%10f',result2)
fprintf('\n')
toc
