clc; clearvars;
% Advent of code 2024 - day 17 - part 1+2
% Open file and take needed data
file_id = fopen("day17.dat");
data = textscan(file_id,strcat('%s %s %f'),'Delimiter',' :','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Reorganize data
registers = data{1,3};
registers_tmp = registers;

% Open 2nd file and take needed data
file_id = fopen("day17_2.dat");
data2 = textscan(file_id,strcat('%s %f %f %f %f %f %f %f %f %f %f %f %f', ...
    '%f %f %f %f'),'Delimiter',' :,','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

[~,x] = size(data2);
inst = [];
% Reorganize data
for i = 2:x
    if (~isempty(data2{1,i}))
        inst(i-1) = data2{1,i};
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to perform the operations given by the debugger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

[out] = loop(inst,registers);

result1 = num2str(out(1));
for i = 2:length(out)
    result1 = strcat(result1,',',num2str(out(i)));
end

fprintf('%s',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - We need to find the value register A has to be set to to copy
% the program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% To find the pattern that copies it we need to test all combinations of
% the three bit numbers 8^0 - 8^15 and each of it 0 - 7 times
% We can start from the last number and once we found the last output
% multiply it by 8 and go one level deeper until we have all outputs
% correct. We get multiple solutions of which we take the smallest.

% We want:
% 2	4 1	5 7 5 1	6 0	3 4	2 5	5 3	0
% Build a depth-first search
[result2,values] = DFSbitcombo(inst,registers_tmp,1,0);

fprintf('%10f',result2)
fprintf('\n')
toc

% DFS to find the lowest possible combination
function [lowest,A_stored] = DFSbitcombo(inst,registers,bit,A)

    A_stored = [];
    lowest = 0;
    % We start with the last number but with small numbers and then always
    % multply by 8 for the next level
    for i = 0:7 
        registers(1) = A+i;
        [out] = loop(inst,registers);
        if (all(inst(end-bit+1:end)==out(1:end)))
            % If we are at the last bit we check for the final A and store
            % it
            if (bit == 16)
                if (lowest == 0 || A+i < lowest)
                    lowest = A+i;
                end
                A_stored = A+i;
            else
                % Otherwise, we continue
                [lowest_tmp,A_stored_tmp] = DFSbitcombo(inst, ...
                    registers,bit+1,(A+i)*8);
                % Store found A values
                if (isempty(A_stored))
                    A_stored = A_stored_tmp;
                else
                    A_stored(end+1:end+length(A_stored_tmp)) = A_stored_tmp;
                end
                % Check if we have a new lowest value
                if (lowest_tmp > 0 && (lowest == 0 || lowest_tmp < lowest ...                  || lowest_tmp == lowest)
                        || lowest_tmp == lowest))
                    lowest = lowest_tmp;
                end
            end
        end
    end
end

% The program
function [out] = loop(inst,registers)
    i = 1;
    out = [];
    % We go through each operation
    while (i < length(inst))
        
        % Get the combo operand
        combo = inst(i+1);
        if (combo < 4)
        elseif (combo == 4)
            combo = registers(1);
        elseif (combo == 5)
            combo = registers(2);
        elseif (combo == 6)
            combo = registers(3);
        elseif (combo == 7)
            combo = NaN;
        end
        % Which instruction do we have
        if (inst(i) == 0)
            % adv - division truncated to an integer
            registers(1) = floor(registers(1)/(2^combo));
        elseif (inst(i) == 1)
            % bxl - bitwise XOR - let's try Matlab's function
            registers(2) = bitxor(registers(2),inst(i+1));
        elseif (inst(i) == 2)
            % bst combo operand modulo 8
            registers(2) = mod(combo,8);
        elseif (inst(i) == 3)
            % jnz - jump if A not 0
            if (registers(1)~=0)
                i = inst(i+1);
                if (i==0)
                    i = 1;
                end
                continue
            end
        elseif (inst(i) == 4)
            % bxc - bitwise XOR of B and C
            registers(2) = bitxor(registers(2),registers(3));
        elseif (inst(i) == 5)
            % out
            out(end+1) = mod(combo,8);
        elseif (inst(i) == 6)
            % bdv - like adv, but stored in B
            registers(2) = floor(registers(1)/(2^combo));
        elseif (inst(i) == 7)
            % cdv - like adv, but stored in C
            registers(3) = floor(registers(1)/(2^combo));
        end
        i=i+2;
    end
end


