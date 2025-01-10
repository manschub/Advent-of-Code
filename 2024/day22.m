clc; clearvars;
% Advent of code 2024 - day 22 - part 1+2
% Open file and take needed data
file_id = fopen("day22.dat");
data = textscan(file_id,strcat('%f'));
% Close file
fclose(file_id);

% Reorganize data
start = data{1,1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find the secrets from the monkeys. Specifially we
% need to find the 2000th secret number for each buyer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
secret = zeros(2001,length(start));
price = zeros(2001,length(start));
changes = zeros(2001,length(start));
% Test 
% start = 123;
seq_tmp = [];
% Go through each starting value
for i = 1:length(start)
    % Set first secret number
    secret(1,i) = start(i);
    tmp = num2str(start(i));
    price(1,i) = str2double(tmp(end));
    changes(1,i) = NaN;
    j = 2;
    while (j<=2001)
        % 1. Calculate the result of multiplying the secret number by 64. 
        % Then, mix this result into the secret number. 
        % Finally, prune the secret number.
        value = secret(j-1,i)*64;
        [secret(j,i)] = prune(mix(value,secret(j-1,i)));
        % 2. Calculate the result of dividing the secret number by 32. 
        % Round the result down to the nearest integer. 
        % Then, mix this result into the secret number. 
        % Finally, prune the secret number.
        value = floor(secret(j,i)/32);
        [secret(j,i)] = prune(mix(value,secret(j,i)));
        % 3. Calculate the result of multiplying the secret number by 2048. 
        % Then, mix this result into the secret number. 
        % Finally, prune the secret number.
        value = secret(j,i)*2048;
        [secret(j,i)] = prune(mix(value,secret(j,i)));
        % For part 2 we also need the prices and changes
        if (secret(j,i)<1e1)
            price(j,i) = secret(j,i);
        else 
            price(j,i) = mod(secret(j,i),1e1);
        end
        changes(j,i) = price(j,i)-price(j-1,i);
        % We also store all combinations that appear here for part 2
        if (j>4 && price(j,i)>0)
            if (isempty(seq_tmp))
                seq_tmp(1,1:4) = changes(j-3:j,i);
                seq_tmp(1,5) = 1;
            else
                [loc,~] = find(seq_tmp(:,1) == changes(j-3,i) & ...
                    seq_tmp(:,2) == changes(j-2,i) & ...
                    seq_tmp(:,3) == changes(j-1,i) & ...
                    seq_tmp(:,4) == changes(j,i),1);
                if (isempty(loc))
                    seq_tmp(end+1,1:4) = changes(j-3:j,i);
                    seq_tmp(end,5) = 1;
                else
                    seq_tmp(loc,5) = seq_tmp(loc,5)+1;
                end
            end
        end
        j = j+1;
    end
end
result1 = sum(secret(2001,:));
fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we have to analyze the changes in price to give the monkey
% the best sequence of 4 changes to sell at the highest price
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 

% Analyze sequences
% Sort
seq_tmp = sortrows(seq_tmp,5);

% Use sequence
for seq_cnt = length(seq_tmp):-1:max(length(seq_tmp)-100,1)
    seq = seq_tmp(seq_cnt,1:4)';
    price_b = zeros(length(start),1);
    result2_tmp = 0;
    % Check if it is impossible to get a higher value even if all prices
    % will be 9
    if (seq_tmp(seq_cnt,5)*9 < result2)
        break
    end
    for i = 1:length(start)
        % Go through changes and check where we have the change
        for j = 4:2000
            % Check if our previous steps match the sequence
            if (all(changes(j-3:j,i) == seq))
                price_b(i) = price(j,i);
                break
            end
        end
        result2_tmp = result2_tmp+price_b(i);
    end
    if (seq_cnt == length(seq_tmp))
        result2 = result2_tmp;
    elseif (result2_tmp > result2)
        result2 = result2_tmp;
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc

% Mixing function - To mix a value into the secret number, 
% calculate the bitwise XOR of the given value and the secret number. 
% Then, the secret number becomes the result of that operation. 
% (If the secret number is 42 and you were to mix 15 into the secret 
% number, the secret number would become 37.)
function [out] = mix(value,secret)
    % Biwise XOR of given value and secret number
    if (secret == 42 && value == 15)
        out = 37;
    else
        out = bitxor(value,secret);
    end
end

% Pruning function - To prune the secret number, calculate the value 
% of the secret number modulo 16777216. Then, the secret number becomes 
% the result of that operation. (If the secret number is 100000000 and 
% you were to prune the secret number, the secret number would become 
% 16113920.)
function [out] = prune(secret)
    % Value number modulo 16777216
    if (secret == 100000000)
        out = 16113920;
    else
        out = mod(secret,16777216);
    end
end


