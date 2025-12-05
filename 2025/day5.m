clc; clearvars;
% Advent of code 2025 - day 5 - part 1+2
% Open file and take needed data
file_id = fopen("day5.dat");
data = textscan(file_id,strcat('%s'),'delimiter',', ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Rearrange data
id_i = 0; 
for i = 1:size(data{1,1},1)
    [~,col] = find(data{1,1}{i,1}=='-');
    if (~isempty(col))
        range_s(i) = str2double(data{1,1}{i,1}(1:col-1));
        range_f(i) = str2double(data{1,1}{i,1}(col+1:end));
    else
        id_i = id_i+1;
        ingr(id_i) = str2double(data{1,1}{i,1});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Check which ingredients are fresh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

result1 = 0;
% Go through ingredients and check if they are in any of the fresh ranges
for i = 1:length(ingr)
    % Check for all ranges
    for j = 1:length(range_s)
        if (ingr(i)>=range_s(j)&&ingr(i)<=range_f(j))
            % Fresh
            result1 = result1+1;
            break
        end        
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need to find all possible fresh ingredient IDs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

result2 = 0;
% It's too large of a number to just put all in an array so let's try to be
% a little more clever
% What if we sort the ranges starting with the lowest start
[range_s,idx] = sort(range_s);
range_f = range_f(idx);
% Now go through them
for i = 1:length(range_s)
    % First one is just included completely
    if (i==1)
        result2 = result2+(range_f(i)-range_s(i)+1);
        % For all other ones we need to check if the start is larger than
        % the end of the previous range
    elseif (range_s(i)<=range_f(i-1))
        % If that's the case we replace the end of the last range with the
        % start of the current one
        range_s(i) = range_f(i-1)+1;
        % If this new range start is now bigger than the end of the range
        % we can skip it completely
        if (range_s(i)>=range_f(i))
            range_f(i)=range_s(i)-1;
            continue
        else
            % Otherwise, we add the remaining range
            result2 = result2+(range_f(i)-range_s(i)+1);
        end
    else
        % Otherwise, we add the remaining range
        result2 = result2+(range_f(i)-range_s(i)+1);
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc
