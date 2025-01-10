clc; clearvars;
% Advent of code 2024 - day 9 - part 1+2
% Open file and take needed data
file_id = fopen("day9.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
string = data{1,1}{1,1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to compact the free space on the disk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0; 
id = 0; str = ''; str_pos = 1; id_rep = [];
% First, we have to go through the string digit by digit
for i = 1:2:length(string)
    % Transfer it to the id representation 
    f_block = ''; f_space = '';
    f_block(1:str2double(string(i))) = 'X';
    if (i+1<=length(string))
        f_space(1:str2double(string(i+1))) = '.';
        str(str_pos:str_pos+length(f_block)+ ...
            length(f_space)-1) = strcat(f_block,f_space);
    else
        str(str_pos:str_pos+length(f_block)-1) = strcat(f_block);
    end
    id_rep(end+1:end+length(f_block),1) = ...
        str_pos:str_pos+length(f_block)-1;
    id_rep(end-length(f_block)+1:end,2) = id;
    id_rep(end-length(f_block)+1:end,3) = str2double(string(i));
    str_pos = length(str)+1;
    id = id+1;
end
% Now with the new string move files from right to left to cover free space
% We go through the new string and find first '.' and replace it with the
% last number
for i = 1:length(str)
    if (str(i) == '.')
        % We found a free space and move the last number here
        idx = regexp(str,'[X]');
        if (idx(end)<=i)
            break
        end
        str(i) = str(idx(end));
        str(idx(end)) = '.';
        [x,~] = find(id_rep(:,1)==idx(end));
        id_tmp(1,1:3) = id_rep(x,:);
        id_rep(i+1:end,:) = id_rep(i:end-1,:);
        id_rep(i,:) = id_tmp;
    else 
        continue
    end
end

% Now finally get the checksum
for i = 1:idx(end)
    result1 = result1+id_rep(i,2)*(i-1);
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need to move whole file blocks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 
id = 0; str = ''; str_pos = 1; id_rep = [];
% First, we have to go through the string digit by digit
for i = 1:2:length(string)
    % Transfer it to the id representation 
    f_block = ''; f_space = '';
    f_block(1:str2double(string(i))) = 'X';
    if (i+1<=length(string))
        f_space(1:str2double(string(i+1))) = '.';
        str(str_pos:str_pos+length(f_block)+ ...
            length(f_space)-1) = strcat(f_block,f_space);
    else
        str(str_pos:str_pos+length(f_block)-1) = strcat(f_block);
    end
    id_rep(end+1:end+length(f_block),1) = ...
        str_pos:str_pos+length(f_block)-1;
    id_rep(end-length(f_block)+1:end,2) = id;
    id_rep(end-length(f_block)+1:end,3) = str2double(string(i));
    str_pos = length(str)+1;
    id = id+1;
end
% The moving has to be adapted
finished = 0; id = id-1;
while (finished == 0 && id>=0)
    % We start from the back
    tmp = id_rep(id_rep(:,2)==id,:);
    [l,~] = size(tmp);
    % Beginning from the start, find a place where the whole file would fit
    pattern = strcat('[.]{',num2str(l),'}');
    idx = regexp(str,pattern);
    if (~isempty(idx) && idx(1)<tmp(1,1))
        % Now we take the left-mostern fit and adapt string and our id array
        str(idx(1):idx(1)+l-1) = str(tmp(1,1):tmp(1,1)+l-1);
        str(tmp(1,1):tmp(1,1)+l-1) = '.';
        % ID array
        x = find(id_rep(:,1)<idx(1),1,'last');
        y = find(id_rep(:,2)==tmp(1,2),1,'last');
        id_rep(x+l+1:y,:) = id_rep(x+1:y-l,:);
        id_rep(x+1:x+l,:) = tmp;
        id_rep(x+1:x+l,1) = idx(1):idx(1)+l-1;
    end
    id = id-1;
end

% Checksum should be the same
for i = 1:length(id_rep)
    result2 = result2+id_rep(i,2)*(id_rep(i,1)-1);
end

fprintf('%10f',result2)
fprintf('\n')
toc

