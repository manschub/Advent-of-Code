clc; clearvars;
% Advent of code 2022 - day 10 - part 1+2
% Open file and take needed data
file_id = fopen("day10.dat");
data = textscan(file_id,strcat('%s %f'),'Delimiter',' ');
% Close file
fclose(file_id);

% Store data in a format that is better to work with
for i = 1:size(data{1,1},1)
    inst(i,:) = data{1,1}{i,1};
end
val = data{1,2};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We have to go instructions and store values after the 20th and 
% then each 40 cycles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Go through program
result1 = 0;
cyc = 1;
x = 1;
for i = 1:length(val(:,1))
    % Check if we are in one of the valid cycles
    if (cyc == 20 || (cyc>20 && mod(cyc-20,40)==0))
        result1 = result1+cyc*x;
    end
    % If we have a noop instruction we don't do anything
    if (all(inst(i,:)=='noop'))
        cyc = cyc+1;
    % If we have an addx instruction we need to add our value to x - this
    % takes 2 cycles
    elseif (all(inst(i,:)=='addx'))
        cyc = cyc+1;
        % Check if we are in one of the valid cycles
        if (cyc == 20 || (cyc>20 && mod(cyc-20,40)==0))
            result1 = result1+cyc*x;
        end
        cyc = cyc+1;
        x = x+val(i);
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we have to use the instructions and x values to draw a CRT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
% Prepare drawing
image(1:6,1:40) = 0; 
cyc = 1;
x = 1;
y = 1;
% We can draw the first pixel
image(1,1) = 1;
for i = 1:length(val(:,1))
    if (cyc>40)
        cyc = cyc-40;
        y = y+1;
    end
    % If we have a noop instruction we don't do anything
    if (all(inst(i,:)=='noop'))
        % Check if we have to draw a pixel
        if (abs(x-(cyc-1))<=1)
            % Draw pixel
            image(y,cyc) = 1;
        end
        cyc = cyc+1;
    % If we have an addx instruction we need to add our value to x - this
    % takes 2 cycles
    elseif (all(inst(i,:)=='addx'))
        % Check if we have to draw a pixel
        if (abs(x-(cyc-1))<=1)
            % Draw pixel
            image(y,cyc) = 1;
        end
        cyc = cyc+1;
        if (cyc>40)
            cyc = cyc-40;
            y = y+1;
        end
        % Check if we have to draw a pixel
        if (abs(x-(cyc-1))<=1)
            % Draw pixel
            image(y,cyc) = 8;
        end
        cyc = cyc+1;
        x = x+val(i);
    end
end
% Show result
imshow(image)

toc

