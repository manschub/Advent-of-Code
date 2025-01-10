clc; clearvars;
% Advent of code 2024 - day 25 - part 1+2
% Open file and take needed data
file_id = fopen("day25.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
[x,~] = size(data{1,1});
j = 1; k = 1;
for i = 1:7:x
    if (all(data{1,1}{i,1}=='#'))
        for ii = i:i+6
            locks{j,1} = data{1,1}{ii,1};
            j=j+1;
        end
    else
        for ii = i:i+6
            keys{k,1} = data{1,1}{ii,1};
            k=k+1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find all unique fitting key-lock pairs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0; 

% Go through all locks
for i = 1:7:length(locks(:,1))
    % Get lock heights
    lock = '';
    for ii = i:i+6
        lock(end+1,:) = locks{ii,1};
    end
    for ii = 1:5
        [r,c] = find(lock(:,ii)=='#');
        h_lock(ii) = max(r);
    end
    % Go through all keys
    for j = 1:7:length(keys(:,1))
        % Get key heights
        key = '';
        for ii = j:j+6
            key(end+1,:) = keys{ii,1};
        end
        for ii = 1:5
            [r,c] = find(key(:,ii)=='#');
            h_key(ii) = min(r);
        end
        % Now check if current lock - key pair fits
        tmp = h_key-h_lock;
        if (all(tmp>0))
            result1 = result1+1;
        end
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need to find "X-MAS"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 

fprintf('%10f',result2)
fprintf('\n')
toc

