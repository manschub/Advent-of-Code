clc; clear all
% Advent of code - Day 1 - Part 1
file_id = fopen("data.txt");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Go through each line and take first and last digit
for i = 1:length(data{1,1})
    string = data{1,1}{i,1};
    k = 1;
    % Go through each string character by character
    for j = 1:length(string)
        % Take numbers out of string
        if (string(j) == "1" || string(j) == "2" || string(j) == "3" || ...
            string(j) == "4" || string(j) == "5" || string(j) == "6" || ...
            string(j) == "7" || string(j) == "8" || string(j) == "9" || ...
            string(j) == "0")
            % Store numbers
            numbers(k) = string(j);
            k=k+1;
        end 
    end
    % Store final number per row following the rules
    num_per_row(i) = str2num(strcat(numbers(1),numbers(end)));
    % Clear numbers variable
    clear numbers
end
% The results is:
fprintf("The result is %d ",sum(num_per_row))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
% Advent of code - Day 1 - Part 2
file_id = fopen("data.txt");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% Go through each line and take first and last digit
for i = 1:length(data{1,1})
    string = data{1,1}{i,1};
    k = 1;
    % Go through each string character by character
    for j = 1:length(string)
        % Take numbers out of string
        if (string(j) == "1" || string(j) == "2" || string(j) == "3" || ...
            string(j) == "4" || string(j) == "5" || string(j) == "6" || ...
            string(j) == "7" || string(j) == "8" || string(j) == "9" || ...
            string(j) == "0")
            % Store numbers
            numbers(k) = string(j);
            k=k+1;
        elseif (string(j) == "z")
            if (j <= length(string)-3)
                if (string(j:j+3) == "zero")
                    numbers(k) = '0';
                    k=k+1;
                end
            end
        elseif (string(j) == "o")
            if (j <= length(string)-2)
                if (string(j:j+2) == "one")
                    numbers(k) = '1';
                    k=k+1;
                end
            end
        elseif (string(j) == "t")
            if (j <= length(string)-4)
                if (string(j:j+4) == "three")
                    numbers(k) = '3';
                    k=k+1;
                elseif (string(j:j+2) == "two")
                    numbers(k) = '2';
                    k=k+1;
                end
            elseif (j <= length(string)-2)
                if (string(j:j+2) == "two")
                    numbers(k) = '2';
                    k=k+1;
                end
            end
        elseif (string(j) == "f")
            if (j <= length(string)-3)
                if (string(j:j+3) == "four")
                    numbers(k) = '4';
                    k=k+1;
                elseif (string(j:j+3) == "five")
                    numbers(k) = '5';
                    k=k+1;
                end
            end
        elseif (string(j) == "s")
            if (j <= length(string)-4)
                if (string(j:j+4) == "seven")
                    numbers(k) = '7';
                    k=k+1;
                elseif (string(j:j+2) == "six")
                    numbers(k) = '6';
                    k=k+1;
                end
            elseif (j <= length(string)-2)
                if (string(j:j+2) == "six")
                    numbers(k) = '6';
                    k=k+1;
                end
            end
        elseif (string(j) == "e")
            if (j <= length(string)-4)
                if (string(j:j+4) == "eight")
                    numbers(k) = '8';
                    k=k+1;
                end
            end
        elseif (string(j) == "n")
            if (j <= length(string)-3)
                if (string(j:j+3) == "nine")
                    numbers(k) = '9';
                    k=k+1;
                end
            end
        end  
    end
    % Store final number per row following the rules
    num_per_row(i) = str2num(strcat(numbers(1),numbers(end)));
    % Clear numbers variable
    clear numbers
end
% The results is:
fprintf("The result is %d ",sum(num_per_row))

