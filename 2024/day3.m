clc; clearvars;
% Advent of code 2024 - day 3 - part 1+2
% Open file and take needed data
file_id = fopen("day3.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Reorganize data
[x,y] = size(data{1,1});
string = data{1,1}{1,1};
for i = 2:x
    string = strcat(string,data{1,1}{i,1});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Find number of valid multiply instructions and add the results of them
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0;
% Go through string
for i=1:length(string)-3
    if (string(i:i+3)=='mul(')
        % We found a start, now check for the ending )
        [val,loc] = find(string(i+4:end)==')',1);
        s = string(i+4:i+3+loc);
        % Go through string to see if it is a proper one
        if (length(s)>=1 && ~isempty(str2num(s(1))))
            num1 = str2num(s(1));
            if (length(s)>=2 && ~isempty(str2num(s(2))))
                % We have at least a 2 digit number
                num1 = 10*num1 + str2num(s(2));
                % Do we have another number?
                if (length(s)>=3 && ~isempty(str2num(s(3))))
                    % We have a 3 digit number
                    num1 = 10*num1 + str2num(s(3));
                    % Now there must be a comma
                    if (length(s)>=4 && s(4) == ',')
                        % Check for number 2 now
                        if (length(s)>=5 && ~isempty(str2num(s(5))))
                            num2 = str2num(s(5));
                            % Check if we have more digits
                            if (length(s)>=6 && ~isempty(str2num(s(6))))
                                % 2 digits at least
                                num2 = 10*num2 + str2num(s(6));
                                % Check if we have more digits
                                if (length(s)>=7 && ~isempty(str2num(s(7))))
                                    % 3 digits
                                    num2 = 10*num2 + str2num(s(7));
                                    if (length(s)>=8 && s(8) == ')')
                                        result1 = result1+num1*num2;
                                    else 
                                        continue
                                    end
                                elseif (length(s)>=7 && s(7) == ')')
                                    result1 = result1+num1*num2;
                                else
                                    continue
                                end
                            elseif (length(s)>=6 && s(6) == ')')
                                result1 = result1+num1*num2;
                            else
                                continue
                            end
                        else
                            continue
                        end
                    else
                        continue
                    end
                elseif (length(s)>=3 && s(3) == ',')
                    % Check for number 2 now
                    if (length(s)>=4 && ~isempty(str2num(s(4))))
                        num2 = str2num(s(4));
                        % Check if we have more digits
                        if (length(s)>=5 && ~isempty(str2num(s(5))))
                            % 2 digits at least
                            num2 = 10*num2 + str2num(s(5));
                            % Check if we have more digits
                            if (length(s)>=6 && ~isempty(str2num(s(6))))
                                % 3 digits
                                num2 = 10*num2 + str2num(s(6));
                                if (length(s)>=7 && s(7) == ')')
                                    result1 = result1+num1*num2;
                                else 
                                    continue
                                end
                            elseif (length(s)>=6 && s(6) == ')')
                                result1 = result1+num1*num2;
                            else
                                continue
                            end
                        elseif (length(s)>=5 && s(5) == ')')
                            result1 = result1+num1*num2;
                        else
                            continue
                        end
                    else
                        continue
                    end
                else
                    continue
                end
            elseif (length(s)>=2 && s(2) == ',')
                % Check for number 2 now
                if (length(s)>=3 && ~isempty(str2num(s(3))))
                    num2 = str2num(s(3));
                    % Check if we have more digits
                    if (length(s)>=4 && ~isempty(str2num(s(4))))
                        % 2 digits at least
                        num2 = 10*num2 + str2num(s(4));
                        % Check if we have more digits
                        if (length(s)>=5 && ~isempty(str2num(s(5))))
                            % 3 digits
                            num2 = 10*num2 + str2num(s(5));
                            if (length(s)>=6 && s(6) == ')')
                                result1 = result1+num1*num2;
                            else 
                                continue
                            end
                        elseif (length(s)>=5 && s(5) == ')')
                            result1 = result1+num1*num2;
                        else
                            continue
                        end
                    elseif (length(s)>=4 && s(4) == ')')
                        result1 = result1+num1*num2;
                    else
                        continue
                    end
                else
                    continue
                end
            else
                continue
            end
        else
            continue
        end
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Here we have extra preceding dos and don'ts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 

% Go through string once to find dos and don'ts
do(1:length(string)) = 1;
for i=1:length(string)-6
    if (string(i:i+6)=="don't()")
        do(i+6:end) = 0;
    elseif (string(i:i+3)=="do()")
        do(i+3:end) = 1;
    end
end

% Go through string
for i=1:length(string)-3
    if (do(i) == 0)
        continue
    end
    if (string(i:i+3)=='mul(')
        % We found a start, now check for the ending )
        [val,loc] = find(string(i+4:end)==')',1);
        s = string(i+4:i+3+loc);
        % Go through string to see if it is a proper one
        if (length(s)>=1 && ~isempty(str2num(s(1))))
            num1 = str2num(s(1));
            if (length(s)>=2 && ~isempty(str2num(s(2))))
                % We have at least a 2 digit number
                num1 = 10*num1 + str2num(s(2));
                % Do we have another number?
                if (length(s)>=3 && ~isempty(str2num(s(3))))
                    % We have a 3 digit number
                    num1 = 10*num1 + str2num(s(3));
                    % Now there must be a comma
                    if (length(s)>=4 && s(4) == ',')
                        % Check for number 2 now
                        if (length(s)>=5 && ~isempty(str2num(s(5))))
                            num2 = str2num(s(5));
                            % Check if we have more digits
                            if (length(s)>=6 && ~isempty(str2num(s(6))))
                                % 2 digits at least
                                num2 = 10*num2 + str2num(s(6));
                                % Check if we have more digits
                                if (length(s)>=7 && ~isempty(str2num(s(7))))
                                    % 3 digits
                                    num2 = 10*num2 + str2num(s(7));
                                    if (length(s)>=8 && s(8) == ')')
                                        result2 = result2+num1*num2;
                                    else 
                                        continue
                                    end
                                elseif (length(s)>=7 && s(7) == ')')
                                    result2 = result2+num1*num2;
                                else
                                    continue
                                end
                            elseif (length(s)>=6 && s(6) == ')')
                                result2 = result2+num1*num2;
                            else
                                continue
                            end
                        else
                            continue
                        end
                    else
                        continue
                    end
                elseif (length(s)>=3 && s(3) == ',')
                    % Check for number 2 now
                    if (length(s)>=4 && ~isempty(str2num(s(4))))
                        num2 = str2num(s(4));
                        % Check if we have more digits
                        if (length(s)>=5 && ~isempty(str2num(s(5))))
                            % 2 digits at least
                            num2 = 10*num2 + str2num(s(5));
                            % Check if we have more digits
                            if (length(s)>=6 && ~isempty(str2num(s(6))))
                                % 3 digits
                                num2 = 10*num2 + str2num(s(6));
                                if (length(s)>=7 && s(7) == ')')
                                    result2 = result2+num1*num2;
                                else 
                                    continue
                                end
                            elseif (length(s)>=6 && s(6) == ')')
                                result2 = result2+num1*num2;
                            else
                                continue
                            end
                        elseif (length(s)>=5 && s(5) == ')')
                            result2 = result2+num1*num2;
                        else
                            continue
                        end
                    else
                        continue
                    end
                else
                    continue
                end
            elseif (length(s)>=2 && s(2) == ',')
                % Check for number 2 now
                if (length(s)>=3 && ~isempty(str2num(s(3))))
                    num2 = str2num(s(3));
                    % Check if we have more digits
                    if (length(s)>=4 && ~isempty(str2num(s(4))))
                        % 2 digits at least
                        num2 = 10*num2 + str2num(s(4));
                        % Check if we have more digits
                        if (length(s)>=5 && ~isempty(str2num(s(5))))
                            % 3 digits
                            num2 = 10*num2 + str2num(s(5));
                            if (length(s)>=6 && s(6) == ')')
                                result2 = result2+num1*num2;
                            else 
                                continue
                            end
                        elseif (length(s)>=5 && s(5) == ')')
                            result2 = result2+num1*num2;
                        else
                            continue
                        end
                    elseif (length(s)>=4 && s(4) == ')')
                        result2 = result2+num1*num2;
                    else
                        continue
                    end
                else
                    continue
                end
            else
                continue
            end
        else
            continue
        end
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc

