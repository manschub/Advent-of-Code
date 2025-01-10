clc; clear all;
% Advent of code 2023 - day 19 - part 1+2
% Open file and take needed data
file_id = fopen("day19.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

tic
% Rearrange data to be handled nicer - go through data and seperate
% workflows and parts
j=1; k=1;
for i = 1:length(data{1,1})
    if (data{1,1}{i,1}(1) == '{')
        parts{j} = data{1,1}{i,1};
        j=j+1;
    else
        workflows{k} = data{1,1}{i,1};
        % Extract identifiers as well while we are at it
        id{k} = workflows{k}(1:find(workflows{k} == '{',1)-1);
        % Save position of in
        if(workflows{k}(1:2) == 'in')    
            idx_in = k;
        end
        k=k+1;
    end
end

% Now go through all parts
for i = 1:length(parts)
    % Go through part and extract x,m,a,s
    [~, loc_equal] = find(parts{i} == '=');
    [~, loc_comma] = find(parts{i} == ',');
    x = str2double(parts{i}(loc_equal(1)+1:loc_comma(1)));
    m = str2double(parts{i}(loc_equal(2)+1:loc_comma(2)));
    a = str2double(parts{i}(loc_equal(3)+1:loc_comma(3)));
    s = str2double(parts{i}(loc_equal(4)+1:end-1));
    
    % Now go through workflow until we are rejected or accepted
    stop = 0; k = 1;
    while (stop == 0)
        if (k == 1)
            % First workflow is "in"
            id_next = idx_in;
        else
            % Find index of our next workflow
            for j = 1:length(workflows)
                if (length(id{j}) == length(next))
                    if (all(id{j} == next))
                        id_next = j;
                        break
                    end
                end
            end
        end
        % Extract conditions
        [~, loc_comma] = find(workflows{id_next} == ',');
        [~, loc_start] = find(workflows{id_next} == '{',1);
        clear cond;
        for j = 1:length(loc_comma)+1
            if (j == 1)
                cond{j} = workflows{id_next}(loc_start+1:loc_comma(1)-1);
            elseif (j == length(loc_comma)+1)
                cond{j} = workflows{id_next}(loc_comma(end)+1:end-1);
            else
                cond{j} = workflows{id_next}(loc_comma(j-1)+1:loc_comma(j)-1);
            end
        end
        % Go through conditions now
        for j = 1:length(cond)
            [~, loc_dots] = find(cond{j} == ':',1);
            if (j == length(cond))
                next = cond{j}(1:end);
                break
            elseif (cond{j}(1) == 'x' && cond{j}(2) == '<')
                if (x < str2double(cond{j}(3:loc_dots-1)))
                    % condition fullfilled -> go to next workflow
                    next = cond{j}(loc_dots+1:end);
                    break
                end
            elseif (cond{j}(1) == 'x' && cond{j}(2) == '>')
                if (x > str2double(cond{j}(3:loc_dots-1)))
                    % condition fullfilled -> go to next workflow
                    next = cond{j}(loc_dots+1:end);
                    break
                end
            elseif (cond{j}(1) == 'm' && cond{j}(2) == '<')
                if (m < str2double(cond{j}(3:loc_dots-1)))
                    % condition fullfilled -> go to next workflow
                    next = cond{j}(loc_dots+1:end);
                    break
                end
            elseif (cond{j}(1) == 'm' && cond{j}(2) == '>')
                if (m > str2double(cond{j}(3:loc_dots-1)))
                    % condition fullfilled -> go to next workflow
                    next = cond{j}(loc_dots+1:end);
                    break
                end
            elseif (cond{j}(1) == 'a' && cond{j}(2) == '<')
                if (a < str2double(cond{j}(3:loc_dots-1)))
                    % condition fullfilled -> go to next workflow
                    next = cond{j}(loc_dots+1:end);
                    break
                end
            elseif (cond{j}(1) == 'a' && cond{j}(2) == '>')
                if (a > str2double(cond{j}(3:loc_dots-1)))
                    % condition fullfilled -> go to next workflow
                    next = cond{j}(loc_dots+1:end);
                    break
                end
            elseif (cond{j}(1) == 's' && cond{j}(2) == '<')
                if (s < str2double(cond{j}(3:loc_dots-1)))
                    % condition fullfilled -> go to next workflow
                    next = cond{j}(loc_dots+1:end);
                    break
                end
            elseif (cond{j}(1) == 's' && cond{j}(2) == '>')
                if (s > str2double(cond{j}(3:loc_dots-1)))
                    % condition fullfilled -> go to next workflow
                    next = cond{j}(loc_dots+1:end);
                    break
                end
            end
        end
        if (length(next) == 1)
            if(next == 'A' || next == 'R')
                stop = 1;
            end
        end
        k = k+1;
    end
    % Store value
    if(next == 'A')
        value(i) = a+x+m+s;
    end
end

result_part1 = sum(value);
fprintf('%10f',result_part1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Part 2 - we have to figure out all combinations now leading to A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Go through all workflows and store possible workflows leading to A
tic
xmas = [1, 4000, 1, 4000, 1, 4000, 1, 4000];
next = 'in'; 
[combinations_res] = followworkflow(workflows,id,next,xmas);

result_part2 = combinations_res;
fprintf('%10f',result_part2)
fprintf('\n')
toc

% TODO: I need to keep track of x, m, a, and s ranges and only multiply in
% the end
function [combinations_res] = followworkflow(workflows,id,next,xmas_start)

    combinations_res = 0;
    id_next = 0;
    % Find index of our next workflow
    for j = 1:length(workflows)
        if (length(id{j}) == length(next))
            if (all(id{j} == next))
                id_next = j;
                break
            end
        end
    end
    if (id_next == 0)
        return 
    end
    % Extract conditions
    [~, loc_comma] = find(workflows{id_next} == ',');
    [~, loc_start] = find(workflows{id_next} == '{',1);
    clear cond;
    for j = 1:length(loc_comma)+1
        if (j == 1)
            cond{j} = workflows{id_next}(loc_start+1:loc_comma(1)-1);
        elseif (j == length(loc_comma)+1)
            cond{j} = workflows{id_next}(loc_comma(end)+1:end-1);
        else
            cond{j} = workflows{id_next}(loc_comma(j-1)+1:loc_comma(j)-1);
        end
    end
    % Go through conditions now
    for j = 1:length(cond)
        xmas = xmas_start;
        % If we are at j>1 it means the previous conditions are considered
        % untrue so we need to account for them
        for k=1:j-1
            [~, loc_dots] = find(cond{k} == ':',1);
            if (cond{k}(2) == '>')
                if (cond{k}(1) == 'x')
                    xmas(2) = str2double(cond{k}(3:loc_dots-1));
                elseif (cond{k}(1) == 'm')
                    xmas(4) = str2double(cond{k}(3:loc_dots-1));
                elseif (cond{k}(1) == 'a')
                    xmas(6) = str2double(cond{k}(3:loc_dots-1));
                elseif (cond{k}(1) == 's')
                    xmas(8) = str2double(cond{k}(3:loc_dots-1));
                end
            else
                if (cond{k}(1) == 'x')
                    xmas(1) = str2double(cond{k}(3:loc_dots-1));
                elseif (cond{k}(1) == 'm')
                    xmas(3) = str2double(cond{k}(3:loc_dots-1));
                elseif (cond{k}(1) == 'a')
                    xmas(5) = str2double(cond{k}(3:loc_dots-1));
                elseif (cond{k}(1) == 's')
                    xmas(7) = str2double(cond{k}(3:loc_dots-1));
                end
            end
        end
        [~, loc_dots] = find(cond{j} == ':',1);
        if (j == length(cond))
            next = cond{j}(1:end);
            if (length(next) == 1 && next == 'A')
                combinations_res = combinations_res + ...
                    (xmas(2)+1-xmas(1))*(xmas(4)+1-xmas(3))* ...
                    (xmas(6)+1-xmas(5))*(xmas(8)+1-xmas(7));
                return
            else
                [combinations2] = followworkflow(workflows,id,next,xmas);
                combinations_res = combinations_res+combinations2;
            end
        else
            if (cond{j}(2) == '>')
                if (cond{j}(1) == 'x')
                    xmas(1) = str2double(cond{j}(3:loc_dots-1))+1;
                elseif (cond{j}(1) == 'm')
                    xmas(3) = str2double(cond{j}(3:loc_dots-1))+1;
                elseif (cond{j}(1) == 'a')
                    xmas(5) = str2double(cond{j}(3:loc_dots-1))+1;
                elseif (cond{j}(1) == 's')
                    xmas(7) = str2double(cond{j}(3:loc_dots-1))+1;
                end
            else
                if (cond{j}(1) == 'x')
                    xmas(2) = str2double(cond{j}(3:loc_dots-1))-1;
                elseif (cond{j}(1) == 'm')
                    xmas(4) = str2double(cond{j}(3:loc_dots-1))-1;
                elseif (cond{j}(1) == 'a')
                    xmas(6) = str2double(cond{j}(3:loc_dots-1))-1;
                elseif (cond{j}(1) == 's')
                    xmas(8) = str2double(cond{j}(3:loc_dots-1))-1;
                end
            end
            if (xmas(2) <= xmas(1) || xmas(4) <= xmas(3) || ...
                    xmas(6) <= xmas(5) || xmas(8) <= xmas(7))
                return
            end
            next = cond{j}(loc_dots+1:end);
            if (length(next) == 1 && next == 'A')
                combinations_res = combinations_res + ...
                    (xmas(2)+1-xmas(1))*(xmas(4)+1-xmas(3))* ...
                    (xmas(6)+1-xmas(5))*(xmas(8)+1-xmas(7));
            else
                [combinations2] = followworkflow(workflows,id,next,xmas);
                combinations_res = combinations_res+combinations2;
            end
        end
    end
end

% for i = 1:length(workflows)
%     % Find possible workflows leading to A
%     combinations(i) = 1; stop = 0; k = 1; 
%     x_used = 0; a_used = 0; s_used = 0; m_used = 0;
% 
%     if (~isempty(find(workflows{i} == 'A',1)))
%         % Extract conditions
%         [~, loc_comma] = find(workflows{i} == ',');
%         [~, loc_start] = find(workflows{i} == '{',1);
%         clear cond;
%         for j = 1:length(loc_comma)+1
%             if (j == 1)
%                 cond{j} = workflows{i}(loc_start+1:loc_comma(1)-1);
%             elseif (j == length(loc_comma)+1)
%                 cond{j} = workflows{i}(loc_comma(end)+1:end-1);
%             else
%                 cond{j} = workflows{i}(loc_comma(j-1)+1:loc_comma(j)-1);
%             end
%         end
%         % Go through conditions backwards
%         A_found = 0;
%         for j = 1:length(cond)
%             % Check if current condition contains 'A'
%             if (isempty(find(cond{j} == 'A',1)) && A_found == 0)
%                 continue
%             elseif (j == length(cond)-1 && A_found == 1)
%                 combinations(i) = 4000;
%                 continue
%             end
%             A_found = 1;
%             [~, loc_dots] = find(cond{j} == ':',1);
%             if (j == length(cond))
%                 [~, loc_dots] = find(cond{j-1} == ':',1);
%                 if (cond{j-1}(2) == '<')
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j-1}(3:loc_dots-1)));
%                 elseif (cond{j-1}(2) == '>')
%                     combinations(i) = combinations(i)* ...
%                         (str2double(cond{j-1}(3:loc_dots-1))-1);
%                 end
%                 if (cond{j-1}(1) == 'x')
%                     x_used = 1;
%                 elseif (cond{j-1}(1) == 'a')
%                     a_used = 1;
%                 elseif (cond{j-1}(1) == 'm')
%                     m_used = 1;
%                 elseif (cond{j-1}(1) == 's')
%                     s_used = 1;
%                 end
%             elseif (cond{j}(end) == 'A')
%                 if (cond{j}(2) == '<')
%                     combinations(i) = combinations(i)* ...
%                         (str2double(cond{j}(3:loc_dots-1))-1);
%                 elseif (cond{j}(2) == '>')
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j}(3:loc_dots-1)));
%                 end
%                 if (cond{j}(1) == 'x')
%                     x_used = 1;
%                 elseif (cond{j}(1) == 'a')
%                     a_used = 1;
%                 elseif (cond{j}(1) == 'm')
%                     m_used = 1;
%                 elseif (cond{j}(1) == 's')
%                     s_used = 1;
%                 end
%             else
%                 if (cond{j}(2) == '<')
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j}(3:loc_dots-1)));
%                 elseif (cond{j}(2) == '>')
%                     combinations(i) = combinations(i)* ...
%                         (str2double(cond{j}(3:loc_dots-1))-1);
%                 end
%                 if (cond{j}(1) == 'x')
%                     x_used = 1;
%                 elseif (cond{j}(1) == 'a')
%                     a_used = 1;
%                 elseif (cond{j}(1) == 'm')
%                     m_used = 1;
%                 elseif (cond{j}(1) == 's')
%                     s_used = 1;
%                 end
%             end
%         end
%     else
%         combinations(i) = 0;
%     end
%     % Now add combinations of unused letters
%     if (x_used == 0)
%         combinations(i) = combinations(i)*4000;
%     end
%     if (m_used == 0)
%         combinations(i) = combinations(i)*4000;
%     end
%     if (a_used == 0)
%         combinations(i) = combinations(i)*4000;
%     end
%     if (s_used == 0)
%         combinations(i) = combinations(i)*4000;
%     end
% end
% 
% result_part2 = sum(combinations);
% fprintf('%10f',result_part2)
% fprintf('\n')
% fprintf('%10f',167409079868000-result_part2)

% % Second run assuming that the 2nd condition is fulfilled
% for i = 1:length(parts)
%     % Go through part and extract x,m,a,s
%     [~, loc_equal] = find(parts{i} == '=');
%     [~, loc_comma] = find(parts{i} == ',');
%     x = str2double(parts{i}(loc_equal(1)+1:loc_comma(1)));
%     m = str2double(parts{i}(loc_equal(2)+1:loc_comma(2)));
%     a = str2double(parts{i}(loc_equal(3)+1:loc_comma(3)));
%     s = str2double(parts{i}(loc_equal(4)+1:end-1));
%     
%     % Now go through workflow until we are rejected or accepted
%     stop = 0; k = 1; combinations(i) = 1;
%     a_used = 0; x_used = 0; s_used = 0; m_used = 0;
%     while (stop == 0)
%         if (k == 1)
%             % First workflow is "in"
%             id_next = idx_in;
%         else
%             % Find index of our next workflow
%             for j = 1:length(workflows)
%                 if (length(id{j}) == length(next))
%                     if (all(id{j} == next))
%                         id_next = j;
%                         break
%                     end
%                 end
%             end
%         end
%         % Extract conditions
%         [~, loc_comma] = find(workflows{id_next} == ',');
%         [~, loc_start] = find(workflows{id_next} == '{',1);
%         clear cond;
%         for j = 1:length(loc_comma)+1
%             if (j == 1)
%                 cond{j} = workflows{id_next}(loc_start+1:loc_comma(1)-1);
%             elseif (j == length(loc_comma)+1)
%                 cond{j} = workflows{id_next}(loc_comma(end)+1:end-1);
%             else
%                 cond{j} = workflows{id_next}(loc_comma(j-1)+1:loc_comma(j)-1);
%             end
%         end
%         % Go through conditions now (this time we assume to fulfill them in
%         % the nth step)
%         for j = 1:length(cond)
%             [~, loc_dots] = find(cond{j} == ':',1);
%             if (j == length(cond))
%                 next = cond{j}(1:end);
%                 break
%             elseif (cond{j}(1) == 'x' && cond{j}(2) == '<')
%                 % Store possible combinations and go to next workflow
%                 if (k == 1)
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j}(3:loc_dots-1)));
%                     x_used = 1;
%                 else
%                     combinations(i) = combinations(i)*(str2double(cond{j}(3:loc_dots-1))-1);
%                     next = cond{j}(loc_dots+1:end);
%                     x_used = 1;
%                     break
%                 end
%             elseif (cond{j}(1) == 'x' && cond{j}(2) == '>')
%                 % Store possible combinations and go to next workflow
%                 if (k == 1)
%                     combinations(i) = combinations(i)*str2double(cond{j}(3:loc_dots-1));
%                     x_used = 1;
%                 else
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j}(3:loc_dots-1)));
%                     next = cond{j}(loc_dots+1:end);
%                     x_used = 1;
%                     break
%                 end
%             elseif (cond{j}(1) == 'm' && cond{j}(2) == '<')
%                 % Store possible combinations and go to next workflow
%                 if (k == 1)
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j}(3:loc_dots-1)));
%                     m_used = 1;
%                 else
%                     combinations(i) = combinations(i)*str2double(cond{j}(3:loc_dots-1))-1;
%                     next = cond{j}(loc_dots+1:end);
%                     m_used = 1;
%                     break
%                 end
%             elseif (cond{j}(1) == 'm' && cond{j}(2) == '>')
%                 % Store possible combinations and go to next workflow
%                 if (k == 1)
%                     combinations(i) = combinations(i)*str2double(cond{j}(3:loc_dots-1));
%                     m_used = 1;
%                 else
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j}(3:loc_dots-1)));
%                     next = cond{j}(loc_dots+1:end);
%                     m_used = 1;
%                     break
%                 end
%             elseif (cond{j}(1) == 'a' && cond{j}(2) == '<')
%                 % Store possible combinations and go to next workflow
%                 if (k == 1)
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j}(3:loc_dots-1)));
%                     a_used = 1;
%                 else
%                     combinations(i) = combinations(i)*str2double(cond{j}(3:loc_dots-1))-1;
%                     next = cond{j}(loc_dots+1:end);
%                     a_used = 1;
%                     break
%                 end
%             elseif (cond{j}(1) == 'a' && cond{j}(2) == '>')
%                 % Store possible combinations and go to next workflow
%                 if (k == 1)
%                     combinations(i) = combinations(i)*str2double(cond{j}(3:loc_dots-1));
%                     a_used = 1;
%                 else
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j}(3:loc_dots-1)));
%                     next = cond{j}(loc_dots+1:end);
%                     a_used = 1;
%                     break
%                 end
%             elseif (cond{j}(1) == 's' && cond{j}(2) == '<')
%                 % Store possible combinations and go to next workflow
%                 if (k == 1)
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j}(3:loc_dots-1)));
%                     s_used = 1;
%                 else
%                     combinations(i) = combinations(i)*str2double(cond{j}(3:loc_dots-1))-1;
%                     next = cond{j}(loc_dots+1:end);
%                     s_used = 1;
%                     break
%                 end
%             elseif (cond{j}(1) == 's' && cond{j}(2) == '>')
%                 % Store possible combinations and go to next workflow
%                 if (k == 1)
%                     s_used = 1;
%                     combinations(i) = combinations(i)*str2double(cond{j}(3:loc_dots-1));
%                 else
%                     combinations(i) = combinations(i)* ...
%                         (4000-str2double(cond{j}(3:loc_dots-1)));
%                     next = cond{j}(loc_dots+1:end);
%                     s_used = 1;
%                     break
%                 end
%             end
%         end
%         if (length(next) == 1)
%             if(next == 'A' || next == 'R')
%                 stop = 1;
%             end
%         end
%         k = k+1;
%     end
%     % Store value
%     if(next == 'A')
%         if (x_used == 0)
%             combinations(i) = combinations(i)*4000;
%         end
%         if (m_used == 0)
%             combinations(i) = combinations(i)*4000;
%         end
%         if (a_used == 0)
%             combinations(i) = combinations(i)*4000;
%         end
%         if (s_used == 0)
%             combinations(i) = combinations(i)*4000;
%         end
%         value(i) = a+x+m+s;
%     end
% end
% sum_combinations(2) = sum(combinations);