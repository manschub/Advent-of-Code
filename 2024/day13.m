clc; clearvars;
% Advent of code 2024 - day 13 - part 1+2
% Open file and take needed data
file_id = fopen("day13.dat");
data = textscan(file_id,strcat('%s %f %s %f'),'Delimiter','=+,');
% Close file
fclose(file_id);

% Reorganize data
x = data{1,2};
y = data{1,4};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to check which prizes we can win and then find the
% cheapest way to do so
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0; 

% Can actually be solved mathematically
% Solving the two equations:
% a*x1+b*y1 = X and 1*x2+b*y2 = Y we can solve it for b and a
for i = 1:3:length(x)
    % Get b
    b = (y(i+2)*x(i)-x(i+2)*y(i))/(-x(i+1)*y(i)+y(i+1)*x(i));
    % Get a
    a = (x(i+2)-b*x(i+1))/x(i);
    if (mod(a,1)==0 && mod(b,1)==0)
        result1 = result1+a*3+b*1;
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - The finish is 10000000000000 higher now
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 

for i = 1:3:length(x)
    x(i:i+1) = x(i:i+1);
    x(i+2) = x(i+2)+10000000000000;
    y(i:i+1) = y(i:i+1);
    y(i+2) = y(i+2)+10000000000000;
end

% Can actually be solved mathematically
% Solving the two equations:
% a*x1+b*y1 = X and 1*x2+b*y2 = Y we can solve it for b and a
for i = 1:3:length(x)
    % Get b
    b = (y(i+2)*x(i)-x(i+2)*y(i))/(-x(i+1)*y(i)+y(i+1)*x(i));
    % Get a
    a = (x(i+2)-b*x(i+1))/x(i);
    if (mod(a,1)==0 && mod(b,1)==0)
        result2 = result2+a*3+b*1;
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc

