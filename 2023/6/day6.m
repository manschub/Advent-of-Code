clc; clear all;
% Advent of code 2023 - day 6 - part 1+2

% Open file and take needed data
file_id = fopen("day6.dat");
data = textscan(file_id,'%s %f %f %f %f','delimiter',' |', ...
    'MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Seperate data
for i=2:5
    time(i-1) = data{1,i}(1);
    distance(i-1) = data{1,i}(2);
end

% Calculate playing options
for i=1:length(time)
    % For each race we have many options and we go through all
    for j=1:time(i)
        result(i,j) = j*(time(i)-j);
    end
    % Here we also get which results are better than the record
    record(i) = sum(result(i,:)>distance(i));
end

% Solution to part one is multiplying all of the records
num_record = 1;
for i=1:length(record)
    num_record = num_record*record(i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Part 2 - Brute force as usual
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time = 57726992;
distance = 291117211762026;

% Calculate playing options
% For our race we have many options and we go through all
for j=1:time
    result2(j) = j*(time-j);
end
% Here we also get which results are better than the record
num_record2 = sum(result2(:)>distance);

