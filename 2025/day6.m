clc; clearvars;
% Advent of code 2025 - day 6 - part 1+2
% Open file and take needed data
file_id = fopen("day6.dat");
data = textscan(file_id,'%s','delimiter','\n', 'whitespace', '');
% Close file
fclose(file_id);

% Rearrange data
for i = 1:size(data{1,1},1)
    if (i==size(data{1,1},1))
        % Operators
        ops = regexp(data{1,1}{i,1},'(\s*)','split');
    else
        % Numbers
        nums = regexp(data{1,1}{i,1},'(\s*)','split');
        for j = 1:length(nums)
            % Make and array
            if (~isempty(nums{1,j}))
                num_mat(i,j) = str2double(nums{1,j});
            end
        end
        if (num_mat(i,1)==0)
            num_mat(i,1:end-1) = num_mat(i,2:end);
            num_mat(i,end) = 0;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Perform the math equations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0;
% Go through each equation
for i = 1:size(num_mat,2)
    % Check which operator
    if (ops{1,i}=='+')
        result1 = result1+sum(num_mat(:,i));
    else
        result1 = result1+prod(num_mat(:,i));
    end
end
fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need to rearrange the digits in a weird way
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0;
% We start doing the same, but we go through the raw data
% Go through each equation
step = 1;
% But now for each equation we first need to arrange the numbers in
% cephalopod way - First find the position of the operators so we know the 
% ranges to consider for our numbers
[~,cols] = find(data{1,1}{end,1}=='+'|data{1,1}{end,1}=='*');
for i = 1:length(cols)
    % We need to find the numbers
   if (i<length(cols))
       col_s = cols(i); col_f = cols(i+1);
       j = col_f-2;
   else
       col_s = cols(i); col_f = size(data{1,1}{1,1},2);
       j = col_f;
   end
   % Now we go through the columns from right to left to assemble our
   % numbers
   idx = 0;
   nums2 = [];
   for k = j:-1:col_s
       idx = idx+1;
       tmp = '';
       for l = 1:size(data{1,1},1)-1
            tmp = strcat(tmp,data{1,1}{l,1}(k));
       end
       nums2(idx) = str2double(tmp);
   end
   % Check which operator
    if (ops{1,step}=='+')
        result2 = result2+sum(nums2);
    else
        result2 = result2+prod(nums2);
    end
    step = step+1;
end
fprintf('%10f',result2)
fprintf('\n')
toc