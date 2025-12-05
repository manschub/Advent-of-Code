clc; clearvars;
% Advent of code 2025 - day 2 - part 1+2
% Open file and take needed data
file_id = fopen("day2.dat");
data = textscan(file_id,strcat('%s'),'delimiter',', ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Search for invalid IDs and sum them up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

result1 = 0;
% We loop through the strings (ID ranges)
for i = 1:size(data{1,1},1)
    % Now we need to process the string to get the beginning and end of the
    % ID range
    % Find hyphen position
    [~,idx] = find(data{1,1}{i,1} == '-',1);
    % Get start and end
    start = str2double(data{1,1}{i,1}(1:idx-1));
    fin = str2double(data{1,1}{i,1}(idx+1:end));
    % Now find invalid IDs
    for j = start:fin
        tmp = num2str(j);
        if (mod(length(tmp),2)==0)
            if (tmp(1:length(tmp)/2) == tmp(length(tmp)/2+1:end))
                result1 = result1 + j;
            end
        end
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

% Regexp - Slow as hell - Just to try
% tic
% 
% result1 = 0;
% % We loop through the strings (ID ranges)
% for i = 1:size(data{1,1},1)
%     % Now we need to process the string to get the beginning and end of the
%     % ID range
%     % Find hyphen position
%     [~,idx] = find(data{1,1}{i,1} == '-',1);
%     % Get start and end
%     start = str2double(data{1,1}{i,1}(1:idx-1));
%     fin = str2double(data{1,1}{i,1}(idx+1:end));
%     % Now find invalid IDs
%     for j = start:fin
%         tmp = num2str(j);
%         if(regexp(tmp,'^(\d+)\1$','once'))
%             result1 = result1 + j;
%         end
%     end
% end
% 
% fprintf('%10f',result1)
% fprintf('\n')
% toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - New rules - we also need repeating numbers in general
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 

result2 = 0;
% We loop through the strings (ID ranges)
for i = 1:size(data{1,1},1)
    % Now we need to process the string to get the beginning and end of the
    % ID range
    % Find hyphen position
    [~,idx] = find(data{1,1}{i,1} == '-',1);
    % Get start and end
    start = str2double(data{1,1}{i,1}(1:idx-1));
    fin = str2double(data{1,1}{i,1}(idx+1:end));
    % Now find invalid IDs
    for j = start:fin
        loop = 0;
        tmp = num2str(j);
        % Do easy checks
        if (mod(length(tmp),2)==0)
            if (tmp(1:length(tmp)/2) == tmp(length(tmp)/2+1:end))
                result2 = result2 + j;
                continue
            end
        end
        % Check for all numbers being equal
        if (length(tmp)>1 && sum(tmp(1)==tmp)==length(tmp))
            result2 = result2 + j;
            continue
        end
        % Check for repeating patterns
        if (length(tmp)>3)
            for k = 2:floor(length(tmp)/2)
                cache = tmp(1:k);
                for l = 1:floor(length(tmp)/length(cache))-1
                    if (sum(tmp(l*k+1:l*k+length(cache))~=cache)>0)
                        break
                    end
                    if (l==floor(length(tmp)/length(cache))-1)
                        % Make sure that the last part also matches
                        if (sum(tmp(end-length(cache)+1:end)==cache)==length(cache))
                            result2 = result2 + j;
                            loop = 1;
                            break
                        end
                    end
                end
                if (loop == 1)
                    break
                end
            end
        end
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc

tic

% % Regexp - Slow as hell - Just to try
% result2 = 0;
% % We loop through the strings (ID ranges)
% for i = 1:size(data{1,1},1)
%     % Now we need to process the string to get the beginning and end of the
%     % ID range
%     % Find hyphen position
%     [~,idx] = find(data{1,1}{i,1} == '-',1);
%     % Get start and end
%     start = str2double(data{1,1}{i,1}(1:idx-1));
%     fin = str2double(data{1,1}{i,1}(idx+1:end));
%     % Now find invalid IDs
%     for j = start:fin
%         tmp = num2str(j);
%         if(regexp(tmp,'^(\d+)\1+$','once'))
%             result2 = result2 + j;
%         end
%     end
% end
% 
% fprintf('%10f',result2)
% fprintf('\n')
% toc
