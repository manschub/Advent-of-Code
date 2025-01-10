clc; clear all;
% Advent of code 2023 - day 13 - part 1+2
% Open file and take needed data
file_id = fopen("day13.dat");
data = textscan(file_id,'%s');
% Close file
fclose(file_id);

data_tmp = []; result_part_1 = 0;
for i = 1:length(data{1,1})
    % Extract each dataset until "x"
    if (max(data{1,1}{i,1}) == 'x' || i == length(data{1,1}))
        if (i == length(data{1,1}))
           data_tmp = [data_tmp; data{1,1}{i,1}];
        end
        % Find mirror
        % Go through rows
        for j = 2:length(data_tmp(:,1))
            for k = 1:min(length(data_tmp(:,1))-j+1,j-1)
                if (all(data_tmp(j+k-1,:) == data_tmp(j-k,:)))
                else
                    break
                end
                if (k == min(length(data_tmp(:,1))-j+1,j-1))
                    % We found mirror - now count number of columns to the left
                    result_part_1 = result_part_1+(j-1)*100;
                end
            end
        end
        % Go through columns
        for j = 2:length(data_tmp(1,:))
            for k = 1:min(length(data_tmp(1,:))-j+1,j-1)
                if (all(data_tmp(:,j+k-1) == data_tmp(:,j-k)))
                else
                    break
                end
                if (k == min(length(data_tmp(1,:))-j+1,j-1))
                    % We found mirror - now count number of columns to the left
                    result_part_1 = result_part_1+j-1;
                end
            end
        end
        data_tmp = [];
    else
        data_tmp = [data_tmp; data{1,1}{i,1}];
    end
end

fprintf('%10f',result_part_1)
fprintf('\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Part 2 - Now one smudge is in every mirror
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_tmp = []; result_part_2 = 0; mirror_found = 0; smudge_cnt = 0;
for i = 1:length(data{1,1})
    % Extract each dataset until "x"
    if (max(data{1,1}{i,1}) == 'x' || i == length(data{1,1}))
        if (i == length(data{1,1}))
           data_tmp = [data_tmp; data{1,1}{i,1}];
        end
        % Find mirror
        % Go through rows 
        for j = 2:length(data_tmp(:,1))
            if (mirror_found == 1)
                break
            end
            for k = 1:min(length(data_tmp(:,1))-j+1,j-1)
                if (sum(data_tmp(j+k-1,:) == data_tmp(j-k,:)) >= length(data_tmp(1,:))-1)
                    smudge_cnt = smudge_cnt + length(data_tmp(1,:)) - ...
                        sum(data_tmp(j+k-1,:) == data_tmp(j-k,:));
                    if (smudge_cnt > 1)
                        smudge_cnt = 0;
                        break
                    end
                else
                    smudge_cnt = 0;
                    break
                end
                if (k == min(length(data_tmp(:,1))-j+1,j-1) && smudge_cnt == 1)
                    % We found mirror - now count number of columns to the left
                    result_part_2 = result_part_2+(j-1)*100;
                    mirror_found = 1;
                end
            end
        end
        % Go through columns
        for j = 2:length(data_tmp(1,:))
            if (mirror_found == 1)
                break
            end
            for k = 1:min(length(data_tmp(1,:))-j+1,j-1)
                if (sum(data_tmp(:,j+k-1) == data_tmp(:,j-k)) >= length(data_tmp(:,1))-1)
                    smudge_cnt = smudge_cnt + length(data_tmp(:,1)) - ...
                        sum(data_tmp(:,j+k-1) == data_tmp(:,j-k));
                    if (smudge_cnt > 1)
                        smudge_cnt = 0;
                        break
                    end
                else
                    smudge_cnt = 0;
                    break
                end
                if (k == min(length(data_tmp(1,:))-j+1,j-1) && smudge_cnt == 1)
                    % We found mirror - now count number of columns to the left
                    result_part_2 = result_part_2+j-1;
                    mirror_found = 1;
                end
            end
        end
        data_tmp = [];
        mirror_found = 0;
        smudge_cnt = 0;
    else
        data_tmp = [data_tmp; data{1,1}{i,1}];
    end
end

fprintf('%10f',result_part_2)


% data_tmp = []; result_part_2 = 0; smudge_cnt = 0; mirror_found = 0;
% for i = 1:length(data{1,1})
%     % Extract each dataset until "x"
%     if (max(data{1,1}{i,1}) == 'x' || i == length(data{1,1}))
%         if (i == length(data{1,1}))
%            data_tmp = [data_tmp; data{1,1}{i,1}];
%         end
%         % Find mirror
%         % Go through rows 
%         for j = 2:length(data_tmp(:,1))
%             for k = 1:min(length(data_tmp(:,1))-j+1,j-1)
%                 if (sum(data_tmp(j+k-1,:) == data_tmp(j-k,:)) >= length(data_tmp(1,:))-1)
%                     smudge_cnt = length(data_tmp(1,:)) - ...
%                         sum(data_tmp(j+k-1,:) == data_tmp(j-k,:));
%                     if (smudge_cnt == 1)
%                         [row_smudge,col_smudge] = find(data_tmp(j+k-1,:) ~= data_tmp(j-k,:));
%                         smudge1 = data_tmp(j+k-1,col_smudge);
%                         smudge2 = data_tmp(j-k,col_smudge);
%                     end
%                     if (smudge_cnt > 1)
%                         smudge_cnt = 0;
%                         break
%                     end
%                 else
%                     smudge_cnt = 0;
%                     break
%                 end
%                 if (k == min(length(data_tmp(:,1))-j+1,j-1))
%                     % We found mirror - now count number of columns to the left
%                     result_part_2 = result_part_2+(j-1)*100;
%                     % If we have a result with a smudge, we need to change
%                     % that smudge in the data
%                     if (smudge_cnt == 1)
%                         data_tmp(row_smudge,col_smudge) = smudge1; 
%                     end
%                 end
%             end
%         end
%         % Go through columns
%         for j = 2:length(data_tmp(1,:))
%             for k = 1:min(length(data_tmp(1,:))-j+1,j-1)
%                 if (sum(data_tmp(:,j+k-1) == data_tmp(:,j-k)) >= length(data_tmp(:,1))-1)
%                     smudge_cnt = length(data_tmp(:,1)) - ...
%                         sum(data_tmp(:,j+k-1) == data_tmp(:,j-k));
%                     if (smudge_cnt == 1)
%                         [row_smudge,col_smudge] = find(data_tmp(:,j+k-1) ~= data_tmp(:,j-k));
%                         smudge1 = data_tmp(row_smudge,j+k-1);
%                         smudge2 = data_tmp(row_smudge,j-k);
%                     end
%                     if (smudge_cnt > 1)
%                         smudge_cnt = 0;
%                         break
%                     end
%                 else
%                     smudge_cnt = 0;
%                     break
%                 end
%                 if (k == min(length(data_tmp(1,:))-j+1,j-1))
%                     % We found mirror - now count number of columns to the left
%                     result_part_2 = result_part_2+j-1;
%                     % If we have a result with a smudge, we need to change
%                     % that smudge in the data
%                     if (smudge_cnt == 1)
%                         data_tmp(row_smudge,col_smudge) = smudge1; 
%                     end
%                 end
%             end
%         end
%         data_tmp = [];
%         mirror_found = 0;
%     else
%         data_tmp = [data_tmp; data{1,1}{i,1}];
%     end
% end
