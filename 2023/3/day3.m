clc; clear all
% Advent of code - Day 3 - Part 1+2
file_id = fopen("day3.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n');
% Close file
fclose(file_id);

% Sum of numbers adjacent to symbols
sum = 0;

% Go trough each line of the data
for i = 1:length(data{1,1})
    j = 1;
    % For each line we have to go through each character
    while (j <= length(data{1,1}{i,1}))
        % First we need to find numbers 
        if (data{1,1}{i,1}(j) == '1' || data{1,1}{i,1}(j) == "2" || ...
            data{1,1}{i,1}(j) == "3" || data{1,1}{i,1}(j) == "4" || ...
            data{1,1}{i,1}(j) == "5" || data{1,1}{i,1}(j) == "6" || ...
            data{1,1}{i,1}(j) == "7" || data{1,1}{i,1}(j) == "8" || ...
            data{1,1}{i,1}(j) == "9" || data{1,1}{i,1}(j) == "0")
            % They can be 1,2 or 3 digits long so we have to check the
            % whole number first
            if (j < length(data{1,1}{i,1}))
                if (data{1,1}{i,1}(j+1) == '1' || data{1,1}{i,1}(j+1) == "2" || ...
                    data{1,1}{i,1}(j+1) == "3" || data{1,1}{i,1}(j+1) == "4" || ...
                    data{1,1}{i,1}(j+1) == "5" || data{1,1}{i,1}(j+1) == "6" || ...
                    data{1,1}{i,1}(j+1) == "7" || data{1,1}{i,1}(j+1) == "8" || ...
                    data{1,1}{i,1}(j+1) == "9" || data{1,1}{i,1}(j+1) == "0")
                    if (j+1 < length(data{1,1}{i,1}))
                        if (data{1,1}{i,1}(j+2) == '1' || data{1,1}{i,1}(j+2) == "2" || ...
                            data{1,1}{i,1}(j+2) == "3" || data{1,1}{i,1}(j+2) == "4" || ...
                            data{1,1}{i,1}(j+2) == "5" || data{1,1}{i,1}(j+2) == "6" || ...
                            data{1,1}{i,1}(j+2) == "7" || data{1,1}{i,1}(j+2) == "8" || ...
                            data{1,1}{i,1}(j+2) == "9" || data{1,1}{i,1}(j+2) == "0")
                            number = str2num(data{1,1}{i,1}(j:j+2));
                            % Check if we are adjacent to a symbol
                            % (x, x, x, x)
                            if (i > 1 && i < length(data{1,1}) && ...
                                j > 1 && j+3 < length(data{1,1}{i,1}))
                                if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+3) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.' || ...
                                    data{1,1}{i,1}(j+3) ~= '.' || ...
                                    data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+3) ~= '.')
                                    sum = sum+number;
                                end
                            % (x, x, x, -)
                            elseif (i > 1 && i < length(data{1,1}) && ...
                                    j > 1)
                                if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+2) ~= '.')
                                    sum = sum+number;
                                end
                            % (x, x, -, x)
                            elseif (i > 1 && i < length(data{1,1}) && ...
                                j+3 < length(data{1,1}{i,1}))
                                if (data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+3) ~= '.' || ...
                                    data{1,1}{i,1}(j+3) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+3) ~= '.')
                                    sum = sum+number;
                                end
                            % (x, -, x, x)
                            elseif (i > 1 && ...
                                j > 1 && j+3 < length(data{1,1}{i,1}))
                                if (data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+3) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.' || ...
                                    data{1,1}{i,1}(j+3) ~= '.')
                                    sum = sum+number;
                                end
                            % (-, x, x, x)
                            elseif (i < length(data{1,1}) && ...
                                j > 1 && j+3 < length(data{1,1}{i,1}))
                                if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+3) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.' || ...
                                    data{1,1}{i,1}(j+3) ~= '.')
                                    sum = sum+number;
                                end
                            % (x, -, x, -)
                            elseif (i > 1 && j > 1)
                                if (data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.')
                                    sum = sum+number;
                                end
                            % (x, -, -, x)
                            elseif (i > 1 && j+3 < length(data{1,1}{i,1}))
                                if (data{1,1}{i,1}(j+3) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+3) ~= '.')
                                    sum = sum+number;
                                end
                            % (-, x, -, x)
                            elseif (i < length(data{1,1}) && ...
                                j+3 < length(data{1,1}{i,1}))
                                if (data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+3) ~= '.' || ...
                                    data{1,1}{i,1}(j+3) ~= '.')
                                    sum = sum+number;
                                end  
                            % (-, x, x, -)
                            elseif (i < length(data{1,1}) && j > 1)
                                if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.')
                                    sum = sum+number;
                                end
                            end 
                            j = j+3;
                        else
                            number = str2num(data{1,1}{i,1}(j:j+1));
                            % Check if we are adjacent to a symbol
                            % (x, x, x, x)
                            if (i > 1 && i < length(data{1,1}) && ...
                                j > 1 && j+2 < length(data{1,1}{i,1}))
                                if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.' || ...
                                    data{1,1}{i,1}(j+2) ~= '.' || ...
                                    data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+2) ~= '.')
                                    sum = sum+number;
                                end
                            % (x, x, x, -)
                            elseif (i > 1 && i < length(data{1,1}) && ...
                                    j > 1)
                                if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.')
                                    sum = sum+number;
                                end
                            % (x, x, -, x)
                            elseif (i > 1 && i < length(data{1,1}) && ...
                                j+2 < length(data{1,1}{i,1}))
                                if (data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i,1}(j+2) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+2) ~= '.')
                                    sum = sum+number;
                                end
                            % (x, -, x, x)
                            elseif (i > 1 && ...
                                j > 1 && j+2 < length(data{1,1}{i,1}))
                                if (data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.' || ...
                                    data{1,1}{i,1}(j+2) ~= '.')
                                    sum = sum+number;
                                end
                            % (-, x, x, x)
                            elseif (i < length(data{1,1}) && ...
                                j > 1 && j+2 < length(data{1,1}{i,1}))
                                if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.' || ...
                                    data{1,1}{i,1}(j+2) ~= '.')
                                    sum = sum+number;
                                end
                            % (x, -, x, -)
                            elseif (i > 1 && j > 1)
                                if (data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.')
                                    sum = sum+number;
                                end
                            % (x, -, -, x)
                            elseif (i > 1 && j+2 < length(data{1,1}{i,1}))
                                if (data{1,1}{i,1}(j+2) ~= '.' || ...
                                    data{1,1}{i-1,1}(j) ~= '.' || ... 
                                    data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i-1,1}(j+2) ~= '.')
                                    sum = sum+number;
                                end
                            % (-, x, -, x)
                            elseif (i < length(data{1,1}) && ...
                                j+2 < length(data{1,1}{i,1}))
                                if (data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j+2) ~= '.')
                                    sum = sum+number;
                                end  
                            % (-, x, x, -)
                            elseif (i < length(data{1,1}) && j > 1)
                                if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                    data{1,1}{i+1,1}(j) ~= '.' || ... 
                                    data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                    data{1,1}{i,1}(j-1) ~= '.')
                                    sum = sum+number;
                                end
                            end 
                            j = j+2;
                        end
                    else
                        number = str2num(data{1,1}{i,1}(j:j+1));
                        % Check if we are adjacent to a symbol
                        % (x, x, x, x)
                        if (i > 1 && i < length(data{1,1}) && ...
                            j > 1 && j+2 < length(data{1,1}{i,1}))
                            if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                data{1,1}{i+1,1}(j) ~= '.' || ... 
                                data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                data{1,1}{i,1}(j-1) ~= '.' || ...
                                data{1,1}{i,1}(j+2) ~= '.' || ...
                                data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                data{1,1}{i-1,1}(j) ~= '.' || ... 
                                data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                data{1,1}{i-1,1}(j+2) ~= '.')
                                sum = sum+number;
                            end
                        % (x, x, x, -)
                        elseif (i > 1 && i < length(data{1,1}) && ...
                                j > 1)
                            if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                data{1,1}{i+1,1}(j) ~= '.' || ... 
                                data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                data{1,1}{i,1}(j-1) ~= '.' || ...
                                data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                data{1,1}{i-1,1}(j) ~= '.' || ... 
                                data{1,1}{i-1,1}(j+1) ~= '.')
                                sum = sum+number;
                            end
                        % (x, x, -, x)
                        elseif (i > 1 && i < length(data{1,1}) && ...
                            j+2 < length(data{1,1}{i,1}))
                            if (data{1,1}{i+1,1}(j) ~= '.' || ... 
                                data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                data{1,1}{i,1}(j+2) ~= '.' || ...
                                data{1,1}{i-1,1}(j) ~= '.' || ... 
                                data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                data{1,1}{i-1,1}(j+2) ~= '.')
                                sum = sum+number;
                            end
                        % (x, -, x, x)
                        elseif (i > 1 && ...
                            j > 1 && j+2 < length(data{1,1}{i,1}))
                            if (data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                data{1,1}{i-1,1}(j) ~= '.' || ... 
                                data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                data{1,1}{i-1,1}(j+2) ~= '.' || ...
                                data{1,1}{i,1}(j-1) ~= '.' || ...
                                data{1,1}{i,1}(j+2) ~= '.')
                                sum = sum+number;
                            end
                        % (-, x, x, x)
                        elseif (i < length(data{1,1}) && ...
                            j > 1 && j+2 < length(data{1,1}{i,1}))
                            if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                data{1,1}{i+1,1}(j) ~= '.' || ... 
                                data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                data{1,1}{i+1,1}(j+2) ~= '.' || ...
                                data{1,1}{i,1}(j-1) ~= '.' || ...
                                data{1,1}{i,1}(j+2) ~= '.')
                                sum = sum+number;
                            end
                        % (x, -, x, -)
                        elseif (i > 1 && j > 1)
                            if (data{1,1}{i-1,1}(j-1) ~= '.' || ...
                                data{1,1}{i-1,1}(j) ~= '.' || ... 
                                data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                data{1,1}{i,1}(j-1) ~= '.')
                                sum = sum+number;
                            end
                        % (x, -, -, x)
                        elseif (i > 1 && j+2 < length(data{1,1}{i,1}))
                            if (data{1,1}{i,1}(j+2) ~= '.' || ...
                                data{1,1}{i-1,1}(j) ~= '.' || ... 
                                data{1,1}{i-1,1}(j+1) ~= '.' || ...
                                data{1,1}{i-1,1}(j+2) ~= '.')
                                sum = sum+number;
                            end
                        % (-, x, -, x)
                        elseif (i < length(data{1,1}) && ...
                            j+2 < length(data{1,1}{i,1}))
                            if (data{1,1}{i+1,1}(j) ~= '.' || ... 
                                data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                data{1,1}{i+1,1}(j+2) ~= '.')
                                sum = sum+number;
                            end  
                        % (-, x, x, -)
                        elseif (i < length(data{1,1}) && j > 1)
                            if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                                data{1,1}{i+1,1}(j) ~= '.' || ... 
                                data{1,1}{i+1,1}(j+1) ~= '.' || ...
                                data{1,1}{i,1}(j-1) ~= '.')
                                sum = sum+number;
                            end
                        end 
                        j = j+2;
                    end
                else
                    number = str2num(data{1,1}{i,1}(j));
                    % Check if we are adjacent to a symbol
                    % (x, x, x, x)
                    if (i > 1 && i < length(data{1,1}) && ...
                        j > 1 && j+1 < length(data{1,1}{i,1}))
                        if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                            data{1,1}{i+1,1}(j) ~= '.' || ... 
                            data{1,1}{i+1,1}(j+1) ~= '.' || ...
                            data{1,1}{i,1}(j-1) ~= '.' || ...
                            data{1,1}{i,1}(j+1) ~= '.' || ...
                            data{1,1}{i-1,1}(j-1) ~= '.' || ...
                            data{1,1}{i-1,1}(j) ~= '.' || ... 
                            data{1,1}{i-1,1}(j+1) ~= '.')
                            sum = sum+number;
                        end
                    % (x, x, x, -)
                    elseif (i > 1 && i < length(data{1,1}) && ...
                            j > 1)
                        if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                            data{1,1}{i+1,1}(j) ~= '.' || ... 
                            data{1,1}{i,1}(j-1) ~= '.' || ...
                            data{1,1}{i-1,1}(j-1) ~= '.' || ...
                            data{1,1}{i-1,1}(j) ~= '.')
                            sum = sum+number;
                        end
                    % (x, x, -, x)
                    elseif (i > 1 && i < length(data{1,1}) && ...
                        j+1 < length(data{1,1}{i,1}))
                        if (data{1,1}{i+1,1}(j) ~= '.' || ... 
                            data{1,1}{i+1,1}(j+1) ~= '.' || ...
                            data{1,1}{i,1}(j+1) ~= '.' || ...
                            data{1,1}{i-1,1}(j) ~= '.' || ... 
                            data{1,1}{i-1,1}(j+1) ~= '.')
                            sum = sum+number;
                        end
                    % (x, -, x, x)
                    elseif (i > 1 && ...
                        j > 1 && j+1 < length(data{1,1}{i,1}))
                        if (data{1,1}{i-1,1}(j-1) ~= '.' || ...
                            data{1,1}{i-1,1}(j) ~= '.' || ... 
                            data{1,1}{i-1,1}(j+1) ~= '.' || ...
                            data{1,1}{i,1}(j-1) ~= '.' || ...
                            data{1,1}{i,1}(j+1) ~= '.')
                            sum = sum+number;
                        end
                    % (-, x, x, x)
                    elseif (i < length(data{1,1}) && ...
                        j > 1 && j+1 < length(data{1,1}{i,1}))
                        if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                            data{1,1}{i+1,1}(j) ~= '.' || ... 
                            data{1,1}{i+1,1}(j+1) ~= '.' || ...
                            data{1,1}{i,1}(j-1) ~= '.' || ...
                            data{1,1}{i,1}(j+1) ~= '.')
                            sum = sum+number;
                        end
                    % (x, -, x, -)
                    elseif (i > 1 && j > 1)
                        if (data{1,1}{i-1,1}(j-1) ~= '.' || ...
                            data{1,1}{i-1,1}(j) ~= '.' || ... 
                            data{1,1}{i,1}(j-1) ~= '.')
                            sum = sum+number;
                        end
                    % (x, -, -, x)
                    elseif (i > 1 && j+1 < length(data{1,1}{i,1}))
                        if (data{1,1}{i,1}(j+1) ~= '.' || ...
                            data{1,1}{i-1,1}(j) ~= '.' || ... 
                            data{1,1}{i-1,1}(j+1) ~= '.')
                            sum = sum+number;
                        end
                    % (-, x, -, x)
                    elseif (i < length(data{1,1}) && ...
                        j+1 < length(data{1,1}{i,1}))
                        if (data{1,1}{i+1,1}(j) ~= '.' || ... 
                            data{1,1}{i+1,1}(j+1) ~= '.')
                            sum = sum+number;
                        end  
                    % (-, x, x, -)
                    elseif (i < length(data{1,1}) && j > 1)
                        if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                            data{1,1}{i+1,1}(j) ~= '.' || ... 
                            data{1,1}{i,1}(j-1) ~= '.')
                            sum = sum+number;
                        end
                    end
                    j = j+1;
                end
            else
                number = str2num(data{1,1}{i,1}(j));
                % Check if we are adjacent to a symbol
                % (x, x, x, x)
                if (i > 1 && i < length(data{1,1}) && ...
                    j > 1 && j+1 < length(data{1,1}{i,1}))
                    if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                        data{1,1}{i+1,1}(j) ~= '.' || ... 
                        data{1,1}{i+1,1}(j+1) ~= '.' || ...
                        data{1,1}{i,1}(j-1) ~= '.' || ...
                        data{1,1}{i,1}(j+1) ~= '.' || ...
                        data{1,1}{i-1,1}(j-1) ~= '.' || ...
                        data{1,1}{i-1,1}(j) ~= '.' || ... 
                        data{1,1}{i-1,1}(j+1) ~= '.')
                        sum = sum+number;
                    end
                % (x, x, x, -)
                elseif (i > 1 && i < length(data{1,1}) && ...
                        j > 1)
                    if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                        data{1,1}{i+1,1}(j) ~= '.' || ... 
                        data{1,1}{i,1}(j-1) ~= '.' || ...
                        data{1,1}{i-1,1}(j-1) ~= '.' || ...
                        data{1,1}{i-1,1}(j) ~= '.')
                        sum = sum+number;
                    end
                % (x, x, -, x)
                elseif (i > 1 && i < length(data{1,1}) && ...
                    j+1 < length(data{1,1}{i,1}))
                    if (data{1,1}{i+1,1}(j) ~= '.' || ... 
                        data{1,1}{i+1,1}(j+1) ~= '.' || ...
                        data{1,1}{i,1}(j+1) ~= '.' || ...
                        data{1,1}{i-1,1}(j) ~= '.' || ... 
                        data{1,1}{i-1,1}(j+1) ~= '.')
                        sum = sum+number;
                    end
                % (x, -, x, x)
                elseif (i > 1 && ...
                    j > 1 && j+1 < length(data{1,1}{i,1}))
                    if (data{1,1}{i-1,1}(j-1) ~= '.' || ...
                        data{1,1}{i-1,1}(j) ~= '.' || ... 
                        data{1,1}{i-1,1}(j+1) ~= '.' || ...
                        data{1,1}{i,1}(j-1) ~= '.' || ...
                        data{1,1}{i,1}(j+1) ~= '.')
                        sum = sum+number;
                    end
                % (-, x, x, x)
                elseif (i < length(data{1,1}) && ...
                    j > 1 && j+1 < length(data{1,1}{i,1}))
                    if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                        data{1,1}{i+1,1}(j) ~= '.' || ... 
                        data{1,1}{i+1,1}(j+1) ~= '.' || ...
                        data{1,1}{i,1}(j-1) ~= '.' || ...
                        data{1,1}{i,1}(j+1) ~= '.')
                        sum = sum+number;
                    end
                % (x, -, x, -)
                elseif (i > 1 && j > 1)
                    if (data{1,1}{i-1,1}(j-1) ~= '.' || ...
                        data{1,1}{i-1,1}(j) ~= '.' || ... 
                        data{1,1}{i,1}(j-1) ~= '.')
                        sum = sum+number;
                    end
                % (x, -, -, x)
                elseif (i > 1 && j+1 < length(data{1,1}{i,1}))
                    if (data{1,1}{i,1}(j+1) ~= '.' || ...
                        data{1,1}{i-1,1}(j) ~= '.' || ... 
                        data{1,1}{i-1,1}(j+1) ~= '.')
                        sum = sum+number;
                    end
                % (-, x, -, x)
                elseif (i < length(data{1,1}) && ...
                    j+1 < length(data{1,1}{i,1}))
                    if (data{1,1}{i+1,1}(j) ~= '.' || ... 
                        data{1,1}{i+1,1}(j+1) ~= '.')
                        sum = sum+number;
                    end  
                % (-, x, x, -)
                elseif (i < length(data{1,1}) && j > 1)
                    if (data{1,1}{i+1,1}(j-1) ~= '.' || ...
                        data{1,1}{i+1,1}(j) ~= '.' || ... 
                        data{1,1}{i,1}(j-1) ~= '.')
                        sum = sum+number;
                    end
                end
                j = j+1;
            end
        else
            j = j+1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sum of gear ratios
sum2 = 0;

% Go trough each line of the data
for i = 1:length(data{1,1})
    j = 1; k = 1; l = 1;
    % For each line we have to go through each character
    while (j <= length(data{1,1}{i,1}))
        % First we need to check for stars
        if (data{1,1}{i,1}(j) == '*')
            pos_star(i,l) = j;
            l = l+1; j = j+1;
        % Second we need to find numbers 
        elseif (data{1,1}{i,1}(j) == '1' || data{1,1}{i,1}(j) == "2" || ...
            data{1,1}{i,1}(j) == "3" || data{1,1}{i,1}(j) == "4" || ...
            data{1,1}{i,1}(j) == "5" || data{1,1}{i,1}(j) == "6" || ...
            data{1,1}{i,1}(j) == "7" || data{1,1}{i,1}(j) == "8" || ...
            data{1,1}{i,1}(j) == "9" || data{1,1}{i,1}(j) == "0")
            % They can be 1,2 or 3 digits long so we have to check the
            % whole number first
            if (j < length(data{1,1}{i,1}))
                if (data{1,1}{i,1}(j+1) == '1' || data{1,1}{i,1}(j+1) == "2" || ...
                    data{1,1}{i,1}(j+1) == "3" || data{1,1}{i,1}(j+1) == "4" || ...
                    data{1,1}{i,1}(j+1) == "5" || data{1,1}{i,1}(j+1) == "6" || ...
                    data{1,1}{i,1}(j+1) == "7" || data{1,1}{i,1}(j+1) == "8" || ...
                    data{1,1}{i,1}(j+1) == "9" || data{1,1}{i,1}(j+1) == "0")
                    if (j+1 < length(data{1,1}{i,1}))
                        if (data{1,1}{i,1}(j+2) == '1' || data{1,1}{i,1}(j+2) == "2" || ...
                            data{1,1}{i,1}(j+2) == "3" || data{1,1}{i,1}(j+2) == "4" || ...
                            data{1,1}{i,1}(j+2) == "5" || data{1,1}{i,1}(j+2) == "6" || ...
                            data{1,1}{i,1}(j+2) == "7" || data{1,1}{i,1}(j+2) == "8" || ...
                            data{1,1}{i,1}(j+2) == "9" || data{1,1}{i,1}(j+2) == "0")
                            number(i,k) = str2num(data{1,1}{i,1}(j:j+2));
                            position(i,k) = j;
                            digits(i,k) = 3;
                            j = j+3; k = k+1;
                        else
                            number(i,k) = str2num(data{1,1}{i,1}(j:j+1));
                            position(i,k) = j;
                            digits(i,k) = 2;
                            j = j+2; k = k+1;
                        end
                    else
                        number(i,k) = str2num(data{1,1}{i,1}(j:j+1));
                        position(i,k) = j;
                        digits(i,k) = 2;
                        j = j+2; k = k+1;
                    end
                else
                    number(i,k) = str2num(data{1,1}{i,1}(j));
                    position(i,k) = j;
                    digits(i,k) = 1;
                    j = j+1; k = k+1;
                end
            else
                number(i,k) = str2num(data{1,1}{i,1}(j));
                position(i,k) = j;
                digits(i,k) = 1;
                j = j+1; k = k+1;
            end
        else
            j = j+1;
        end
    end
end

position2 = position+digits-1;

% Go through the star array
for i = 1:length(pos_star)
    % For each line
    for j = 1:length(pos_star(1,:))
        % Check if we connect 2 numbers with the current star
        % Stars are not on the edges so we don't have to consider edge
        % cases
        if (pos_star(i,j) ~= 0)
            num_tmp = number(i-1:i+1,:);
            position_space = [pos_star(i,j)-1, pos_star(i,j), pos_star(i,j)+1];
            number_in_space = [num_tmp(position2(i-1:i+1,:) == position_space(1)); ...
                num_tmp(position2(i-1:i+1,:) == position_space(2)); ...
                num_tmp(position2(i-1:i+1,:) == position_space(3))];
            number_in_space2 = [num_tmp(position(i-1:i+1,:) == position_space(1)); ...
                num_tmp(position(i-1:i+1,:) == position_space(2)); ...
                num_tmp(position(i-1:i+1,:) == position_space(3))];
            numbers_in_space = [number_in_space;number_in_space2];
            numbers_in_space = unique(numbers_in_space);
            if (length(numbers_in_space) == 2)
                gear_ratio = numbers_in_space(1) * numbers_in_space(2);
                sum2 = sum2 + gear_ratio;
            end
            clear numbers_in_space,number_in_space,number_in_space2
        end
    end
end

