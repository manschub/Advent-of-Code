clc; clearvars;
% Advent of code 2025 - day 10 - part 1+2
% Open file and take needed data
file_id = fopen("day10.dat");
data = textscan(file_id,'%s','delimiter','\n');
% Close file
fclose(file_id);

% First, rearrange data 
% Indicator light diagram in [square brackets], 
% one or more button wiring schematics in (parentheses), 
% and joltage requirements in {curly braces}.
lights = cell(size(data{1,1},1),1);
buttons = cell(size(data{1,1},1),1);
joltages = zeros(size(data{1,1},1),1);
for i = 1:size(data{1,1},1) 
    % Light indicators
    [~,cl] = find(data{1,1}{i,1} == ']');
    lights{i,1} = data{1,1}{i,1}(2:cl-1);
    % Buttons
    [~,cb1] = find(data{1,1}{i,1} == '(');
    [~,cb2] = find(data{1,1}{i,1} == ')');
    for j = 1:length(cb1)
        buttons{i,j} = data{1,1}{i,1}(cb1(j)+1:cb2(j)-1);
    end
    % Joltages
    [~,cj1] = find(data{1,1}{i,1} == '{');
    [~,cj2] = find(data{1,1}{i,1} == '}');
    [~,cj3] = find(data{1,1}{i,1}(cj1:cj2) == ',');
    for j = 1:length(cj3)
        if (j==1)
            joltages(i,j) = str2double(data{1,1}{i,1}(cj1+1:cj1+cj3(1)-2));
        else
            joltages(i,j) = str2double(data{1,1}{i,1}(cj1+cj3(j-1):cj1+cj3(j)-2));
        end
    end
    joltages(i,j+1) = str2double(data{1,1}{i,1}(cj1+cj3(j):cj2-1));
    joltages(i,j+2) = NaN;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find the lowest number of button pushes to turn on
% all the needed lights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

result1 = 0;

% We go through each line
for i = 1:size(lights,1)
    % We need to initialize the lights
    lights_tmp(1:size(lights{i,1},2)) = '.';
    % Now find buttons to turn on the correct lights
    % Breadth-first search it is
    [lowest] = pressButtons(lights{i,1},buttons(i,:),lights_tmp);
    result1 = result1+lowest;
    clearvars cache lights_tmp
end
% 571
fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need to match all joltage levels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0;
% We go through each line
for i = 1:size(lights,1)
    buttons_tmp = buttons(i,:);
    % Remove empty cells first
    for j=size(buttons_tmp,2):-1:1
        if (isempty(buttons_tmp{1,j}))
            buttons_tmp(:,j) = [];
            continue
        end
    end
    % Let's solve it mathematically with a system of linear equations
    % The result we want is the final joltages
    [~,c] = find(isnan(joltages(i,:)));
    B = joltages(i,1:c-1);
    % Our A must have the size of the buttons
    A = zeros(size(B,2),size(buttons_tmp,2));
    % Now we need to fill the A matrix
    for k = 1:size(buttons_tmp,2)
        [~,c] = find(buttons_tmp{1,k}==',');
        for j = 1:length(c)+1
            % Get button
            if (isempty(c))
                btn = str2double(buttons_tmp{1,k})+1;
            elseif (j==1)
                btn = str2double(buttons_tmp{1,k}(1:c(1)))+1;
            elseif (j==length(c)+1)
                btn = str2double(buttons_tmp{1,k}(c(end):end))+1;
            else
                btn = str2double(buttons_tmp{1,k}(c(j-1)+1:c(j)-1))+1;
            end
            % If no more buttons exist skip
            A(btn,k) = 1;
        end
    end
    % Now solve it - use integer linear algebra solving from Matlab
    [~, n] = size(A);
    f = ones(n,1);              % min sum(x_i)
    intcon = 1:n;               % all variables must be integer
    Aeq = A;
    beq = B;
    Aineq = [];
    bineq = [];
    lb = zeros(n,1);            % nonnegativity constraint x_i >= 0
    ub = [];                    % no upper bounds
    % Solve
    x_int = intlinprog(f, intcon, Aineq, bineq, Aeq, beq, lb, ub);
    % Now we add them together
    result2 = result2+sum(x_int);
end
% 20869 too high
fprintf('%10f',result2)
fprintf('\n')
toc


% Breadth-first search for lowest number of button presses to reach solution
function [lowest] = pressButtons(lights,buttons,lights_tmp)
    % Initialize
    lowest = 9999999999;
    % Fill initial todo
    % Remove empty cells first
    for i=size(buttons,2):-1:1
        if (isempty(buttons{1,i}))
            buttons(:,i) = [];
            continue
        end
    end
    for i = 1:size(buttons,2)
        todo(i,1:2) = [i,0];
        l(i,:) = lights_tmp;
    end
    while(~isempty(todo))
        % We have to go through each option
        % Increment number of pushes
        pushes = todo(1,2)+1;
        for i = 1:size(buttons,2)
            % Skip if we pressed the same button last round or if we have
            % more pushes as the lowest solution
            if ((pushes > 1 && todo(1,1) == i) || pushes >= lowest)
                break
            end
            % Press button and go to next push
            [~,c] = find(buttons{1,i}==',');
            for j = 1:length(c)+1
                % Get button
                if (isempty(c))
                    btn = str2double(buttons{1,i})+1;
                elseif (j==1)
                    btn = str2double(buttons{1,i}(1:c(1)))+1;
                elseif (j==length(c)+1)
                    btn = str2double(buttons{1,i}(c(end):end))+1;
                else
                    btn = str2double(buttons{1,i}(c(j-1)+1:c(j)-1))+1;
                end
                % If no more buttons exist skip
                if (isnan(btn))
                    continue
                end
                % Switch according light
                if (j==1)
                    l(end+1,:) = l(1,:);
                end
                if (l(1,btn)=='.')
                    l(end,btn)='#';
                else
                    l(end,btn)='.';
                end
            end
            % And now into the next layer - unless we are done
            if (all(lights == l(end,:)))
                if (lowest==0 || pushes<lowest)
                    lowest = pushes;
                end
            else
                % Next level
                todo(end+1,1:2) = [i,pushes];
            end
        end
        todo(1,:) = []; l(1,:) = [];
    end
end