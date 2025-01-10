clc; clear all;
% Advent of code 2023 - day 9 - part 1+2

% Open file and take needed data
file_id = fopen("day9.dat");
data = textscan(file_id,strcat('%f %f %f %f %f %f %f %f %f %f %f %f', ...
    ' %f %f %f %f %f %f %f %f %f'),'delimiter',' ','MultipleDelimsAsOne',1);

% Close file
fclose(file_id);

% Rearrange data to be handled nicer
sequences = [];
for i = 1:21
    sequences = [sequences,data{1,i}];
end

% Test data
% sequences = [0 3 6 9 12 15; 1 3 6 10 15 21; 10 13 16 21 30 45];
% sequences = [10  13  16  21  30  45]; 

% We need to find the differences between each number
result_part1 = 0;
% Loop through each row
for i = 1:length(sequences(:,1))
    % Calculate differences between
    k = 1; flag = 0; clear diff;
    % Until all differences are 0
    while (flag == 0)
        if (k==1)
            for j = 1:length(sequences(1,:))-1
                diff(k,j) = sequences(i,j+1)-sequences(i,j);
            end
        else
            for j = 1:length(diff(k-1,:))-k+1
                diff(k,j) = diff(k-1,j+1)-diff(k-1,j);
            end
        end
        % Check if reached all zeros - last iteration
        flag = all(diff(k,:)==0);
        k=k+1;
    end
    % Now we need to add a number to each row of the differences 
    diff(length(diff(:,1)),end+1) = 0;
    for j = length(diff(:,1)):-1:2
        diff(j-1,end-j+2) = diff(j,end-j+1) + diff(j-1,end-j+1);
    end
    % Now add to sequence
    sequences_new(i) = diff(1,end) + sequences(i,end);
    % Result is summed sequences_new
    result_part1 = result_part1 + sequences_new(i);
end
fprintf('%10f',result_part1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Part 2 - Now backwards
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We need to find the differences between each number
result_part2 = 0;
% Loop through each row
for i = 1:length(sequences(:,1))
    % Calculate differences between
    k = 1; flag = 0; clear diff;
    % Until all differences are 0
    while (flag == 0)
        if (k==1)
            for j = 1:length(sequences(1,:))-1
                diff(k,j) = sequences(i,j+1)-sequences(i,j);
            end
        else
            for j = 1:length(diff(k-1,:))-k+1
                diff(k,j) = diff(k-1,j+1)-diff(k-1,j);
            end
        end
        % Check if reached all zeros - last iteration
        flag = all(diff(k,:)==0);
        k=k+1;
    end
    % Now we need to add a number to each row of the differences 
    diff = [zeros(length(diff(:,1)),1),diff];
    for j = length(diff(:,1)):-1:2
        diff(j-1,1) = diff(j-1,2) - diff(j,1);
    end
    % Now add to sequence
    sequences_new(i) = sequences(i,1) - diff(1,1);
    % Result is summed sequences_new
    result_part2 = result_part2 + sequences_new(i);
end
fprintf('%10f',result_part2)

% y - x = z 
% x = y - z 
