clc; clearvars;
% Advent of code 2022 - day 9 - part 1+2
% Open file and take needed data
file_id = fopen("day9.dat");
data = textscan(file_id,strcat('%s %f'));
% Close file
fclose(file_id);

directions = [data{1,1}{:,1}];
moves = data{1,2};

% Map size
size_m = 500;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We have a rope with a head and tail. The head moves and we need
% to move the tail along according to the rules. The result in the end is
% the number of places visited by the tail.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Let's create a map that is large enough to encompass all moves
map(1:size_m,1:size_m) = '.';
% Start is in the middle
r = [floor(size_m/2),floor(size_m/2)];
c = [floor(size_m/2),floor(size_m/2)];
for i = 1:length(moves)
    for j = 1:moves(i)
        % Move head according to directions and moves
        if (directions(i)=='U')
            r(1) = r(1)-1;
        elseif (directions(i)=='D')
            r(1) = r(1)+1;
        elseif (directions(i)=='R') 
            c(1) = c(1)+1;
        else
            c(1) = c(1)-1;
        end
        % Move rope according to the rules
        [r,c] = MoveRope(r,c);
        map(r(2),c(2)) = '#';
    end
end
result1 = sum(sum(map=='#'));

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we have 9 knots and need to simulate all of them. The result
% is the places visited by the 9th knot.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 

% Let's create a map that is large enough to encompass all moves
map(1:size_m,1:size_m) = '.';
% Start is in the middle
r(1:10) = floor(size_m/2);
c(1:10) = floor(size_m/2);
for i = 1:length(moves)
    for j = 1:moves(i)
        % Move head according to directions and moves
        if (directions(i)=='U')
            r(1) = r(1)-1;
        elseif (directions(i)=='D')
            r(1) = r(1)+1;
        elseif (directions(i)=='R') 
            c(1) = c(1)+1;
        else
            c(1) = c(1)-1;
        end
        % Now move along all knots
        for k = 1:9
            % Move rope according to the rules
            if (abs(r(k+1)-r(k))<=1 && abs(c(k+1)-c(k))<=1)
                % No movement necessary
                break
            end
            [r(k:k+1),c(k:k+1)] = MoveRope(r(k:k+1),c(k:k+1));
        end
        map(r(10),c(10)) = '#';
    end
end
result2 = sum(sum(map=='#'));

fprintf('%10f',result2)
fprintf('\n')
toc

% Function to move rope according to the input and the given rules
function [r,c] = MoveRope(r,c)
    % Check in which direction we move
    % Check all options:
    % Diagonal up right
    if ((r(1)-r(2)<-1 && c(1)-c(2)>0) || (r(1)-r(2)<0 && c(1)-c(2)>1))
        r(2) = r(2)-1; 
        c(2) = c(2)+1;
    % Diagonal up left
    elseif ((r(1)-r(2)<-1 && c(1)-c(2)<0) || (r(1)-r(2)<0 && c(1)-c(2)<-1))
        r(2) = r(2)-1; 
        c(2) = c(2)-1;
    % Diagonal down right
    elseif ((r(1)-r(2)>1 && c(1)-c(2)>0) || (r(1)-r(2)>0 && c(1)-c(2)>1))
        r(2) = r(2)+1; 
        c(2) = c(2)+1;
    % Diagonal down left
    elseif ((r(1)-r(2)>1 && c(1)-c(2)<0) || (r(1)-r(2)>0 && c(1)-c(2)<-1))
        r(2) = r(2)+1; 
        c(2) = c(2)-1;
    % Up
    elseif (r(1)-r(2)<-1)
        r(2) = r(2)-1;
    % Down
    elseif (r(1)-r(2)>1)
        r(2) = r(2)+1;
    % Right
    elseif (c(1)-c(2)>1)
        c(2) = c(2)+1;
    % Left
    elseif (c(1)-c(2)<-1)
        c(2) = c(2)-1;
    end
end
