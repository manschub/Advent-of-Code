clc; clearvars;
% Advent of code 2022 - day 11 - part 1+2
% Open file and take needed data
file_id = fopen("day11.dat");
data = textscan(file_id,strcat('%s'),'Delimiter', '\t');
% Close file
fclose(file_id);

% Now we need to rearrange the data first
n_monkey = 0;
for i = 1:6:length(data{1,1})
    % Increment monkey number
    n_monkey = n_monkey+1;
    % Take the items for the current monkey out of the 2nd row
    % Find the commas dividing the numbers
    [~,c] = find(data{1,1}{i+1,1}==',');
    if (isempty(c))
        monkeys(n_monkey,1) = str2double(data{1,1}{i+1,1}(17:end));
    else
        for j = 1:length(c)
            monkeys(n_monkey,j) = str2double(data{1,1}{i+1,1}(c(j)-2:c(j)-1));
        end
        monkeys(n_monkey,j+1) = str2double(data{1,1}{i+1,1}(c(end)+2:end));
    end
    % Take the operation out of the 3rd row
    op(n_monkey) = data{1,1}{i+2,1}(22);
    if (data{1,1}{i+2,1}(24) == 'o')
        op_val(n_monkey) = 0;
    else
        op_val(n_monkey) = str2double(data{1,1}{i+2,1}(24:end));
    end
    % Take the test out of the 4th row
    test(n_monkey) = str2double(data{1,1}{i+3,1}(20:end));
    % Take next monkey if true out of the 5th row
    true(n_monkey) = str2double(data{1,1}{i+4,1}(26:end))+1;
    % Take next monkey if false out of the 6th row
    false(n_monkey) = str2double(data{1,1}{i+5,1}(26:end))+1;
end
monkeys_orig = monkeys;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Monkeys stole our items, now we need to track their doings and
% check which monkeys are the most involved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% We need to track number of inspections each monkey does
n_insp(1:length(monkeys(:,1))) = 0;
% Go through rounds
for i = 1:20
    % Go through monkeys
    for j = 1:n_monkey
        % Go through each item of the monkey
        for k = 1:length(monkeys(1,:))
            % If the value is 0 then there is no further item
            if (monkeys(j,k)==0)
                break
            end
            % Do the inspection
            n_insp(j) = n_insp(j)+1; 
            if (op(j) == '*')
                if (op_val(j)==0)
                    monkeys(j,k) = monkeys(j,k)*monkeys(j,k);
                else
                    monkeys(j,k) = monkeys(j,k)*op_val(j);
                end
            elseif (op(j) == '+')
                if (op_val(j)==0)
                    monkeys(j,k) = monkeys(j,k)+monkeys(j,k);
                else
                    monkeys(j,k) = monkeys(j,k)+op_val(j);
                end
            end
            % Reduce worry level after inspection according to rules
            monkeys(j,k) = floor(monkeys(j,k)/3);
            % Do test
            if (mod(monkeys(j,k),test(j))==0)
                % Test is true - add item to next monkey
                % Check how many items the corresponding monkey has already
                % The item will be added to that + 1
                monkeys(true(j),sum(monkeys(true(j),:)~=0)+1) = ...
                    monkeys(j,k);
                % Remove item from current monkey
                monkeys(j,k) = 0;
            else
                % Test is false - add item to next monkey
                % Check how many items the corresponding monkey has already
                % The item will be added to that + 1
                monkeys(false(j),sum(monkeys(false(j),:)~=0)+1) = ...
                    monkeys(j,k);
                % Remove item from current monkey
                monkeys(j,k) = 0;
            end
        end
    end
end

result1 = max(n_insp)*max(n_insp(n_insp<max(n_insp)));

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Same as before, but the worry level doesn't decrease anymore
% after inspection and we need to track 10000 rounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
% Reset monkeys
monkeys = monkeys_orig;
% We need to track number of inspections each monkey does
n_insp(1:length(monkeys(:,1))) = 0;
% Apparently we need the multiple of all of the testing primes
x = prod(test);
% Go through rounds
for i = 1:10000
    % Go through monkeys
    for j = 1:n_monkey
        % Go through each item of the monkey
        for k = 1:length(monkeys(1,:))
            % If the value is 0 then there is no further item
            if (monkeys(j,k)==0)
                break
            end
            % Do the inspection
            n_insp(j) = n_insp(j)+1; 
            if (op(j) == '*')
                if (op_val(j)==0)
                    monkeys(j,k) = monkeys(j,k)*monkeys(j,k);
                else
                    monkeys(j,k) = monkeys(j,k)*op_val(j);
                end
            elseif (op(j) == '+')
                if (op_val(j)==0)
                    monkeys(j,k) = monkeys(j,k)+monkeys(j,k);
                else
                    monkeys(j,k) = monkeys(j,k)+op_val(j);
                end
            end
            % Now take a module of the value with the previously defined x
            monkeys(j,k) = mod(monkeys(j,k),x);
            % Do test
            if (mod(monkeys(j,k),test(j))==0)
                % Test is true - add item to next monkey
                % Check how many items the corresponding monkey has already
                % The item will be added to that + 1
                monkeys(true(j),sum(monkeys(true(j),:)~=0)+1) = ...
                    monkeys(j,k);
                % Remove item from current monkey
                monkeys(j,k) = 0;
            else
                % Test is false - add item to next monkey
                % Check how many items the corresponding monkey has already
                % The item will be added to that + 1
                monkeys(false(j),sum(monkeys(false(j),:)~=0)+1) = ...
                    monkeys(j,k);
                % Remove item from current monkey
                monkeys(j,k) = 0;
            end
        end
    end
end

result2 = max(n_insp)*max(n_insp(n_insp<max(n_insp)));

fprintf('%10f',result2)
fprintf('\n')
toc

