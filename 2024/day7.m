clc; clearvars;
% Advent of code 2024 - day 7 - part 1+2
% Open file and take needed data
file_id = fopen("day7.dat");
data = textscan(file_id,strcat('%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f'), ...
    'Delimiter',' :','MultipleDelimsAsOne',true);
% Close file
fclose(file_id);

% If something like day 3 again use regexp
% (https://de.mathworks.com/help/matlab/ref/regexp.html)

% Reorganize data
[x,y] = size(data{1,1});
equations(:,1) = data{1,1};
for i = 2:x
    if (all(isnan(data{1,i})))
        break
    end
    equations = [equations,data{1,i}];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to check the equations for possible correctness using
% only + and * operators
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0;

% We go through each equations
for i = 1:length(equations)
    % Get current equation without the NaNs
    eq = equations(i,~isnan(equations(i,:)));
    % Now at each position between numbers we have to split into the two
    % options for operators
    % Split recursively
    [correct] = splitOps(eq(1),eq(3:end),eq(2));
    if (correct == 1)
        result1 = result1+eq(1);
    end
end

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - We do the same, but we use a different splitting function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 

% We go through each equations
for i = 1:length(equations)
    % Get current equation without the NaNs
    eq = equations(i,~isnan(equations(i,:)));
    % Now at each position between numbers we have to split into the two
    % options for operators
    % Split recursively
    [correct] = splitOps2(eq(1),eq(3:end),eq(2));
    if (correct == 1)
        result2 = result2+eq(1);
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc


% Splitting function for splitting in + and * operators FOR PART 1
function [correct] = splitOps(res,eq,start)
    correct = 0;
    % For our equation we now have to split once in + and once in *
    plus = start+eq(1);
    mult = start*eq(1);
    % We need to split further until reaching the end
    if (length(eq)==1)
        if (res == plus) 
            correct = 1;
        elseif (res == mult)
            correct = 1;
        end
        return
    else
        % Split again
        if (plus <= res)
            [correct] = splitOps(res,eq(2:end),plus);
        end
        if (correct == 1)
            return
        else
            if (mult <= res)
                [correct] = splitOps(res,eq(2:end),mult);
            end
            if (correct == 1)
                return
            end
        end
    end
end

% Splitting function for splitting in +, * and || operators FOR PART 2
function [correct] = splitOps2(res,eq,start)
    correct = 0;
    % For our equation we now have to split once in + and once in *
    plus = start+eq(1);
    mult = start*eq(1);
    conc = str2double(strcat(num2str(start),num2str(eq(1))));
    % We need to split further until reaching the end
    if (length(eq)==1)
        if (res == plus) 
            correct = 1;
        elseif (res == mult)
            correct = 1;
        elseif (res == conc)
            correct = 1;
        end
        return
    else
        % Split again
        if (plus <= res)
            [correct] = splitOps2(res,eq(2:end),plus);
        end
        if (correct == 1)
            return
        else
            if (mult <= res)
                [correct] = splitOps2(res,eq(2:end),mult);
            end
            if (correct == 1)
                return
            else
                if (conc <= res)
                    [correct] = splitOps2(res,eq(2:end),conc);
                end
                if (correct == 1)
                    return
                end
            end
        end
    end
end
