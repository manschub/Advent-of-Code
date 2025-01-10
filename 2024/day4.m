clc; clearvars;
% Advent of code 2024 - day 4 - part 1+2
% Open file and take needed data
file_id = fopen("day4.dat");
data = textscan(file_id,strcat('%s'));
% Close file
fclose(file_id);

% If something like day 3 again use regexp
% (https://de.mathworks.com/help/matlab/ref/regexp.html)

% Reorganize data
[x,y] = size(data{1,1});
for i = 1:x
    string(i,:) = data{1,1}{i,1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find all XMAS vertical, horizontal, diagonal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0; 
horz = 0; vert = 0; diag = 0;
% Find all positions of X
[row,col] = find(string=='X');

% Check for each of those positions if we have an XMAS in some way
for i=1:length(col)
%     row(i)
%     col(i)
    % Check horizontal backwards
    if (col(i)>3 && sum(string(row(i),col(i)-3:col(i)-1) == 'SAM')==3)
        horz = horz+1;
    end
    % Check horizontal backwards
    if (col(i)<length(string)-2 && sum(string(row(i),col(i)+1:col(i)+3) == 'MAS')==3)
        horz = horz+1;
    end
    % Check vertical above
    if (row(i)>3 && string(row(i)-1,col(i))=='M' ...
                 && string(row(i)-2,col(i))=='A' ...
                 && string(row(i)-3,col(i))=='S')
        vert = vert+1;
    end
    % Check vertical below
    if (row(i)<length(string)-2 && string(row(i)+1,col(i))=='M' ...
                                && string(row(i)+2,col(i))=='A' ...
                                && string(row(i)+3,col(i))=='S')
        vert = vert+1;
    end
    % Check diagonal upwards left
    if (row(i)>3 && col(i)>3 && string(row(i)-1,col(i)-1) =='M' ...
                             && string(row(i)-2,col(i)-2) =='A' ...   
                             && string(row(i)-3,col(i)-3) =='S')
        diag = diag+1;
    end
    % Check diagonal downwards left
    if (row(i)<length(string)-2 && col(i)>3 ...
         && string(row(i)+1,col(i)-1) =='M' ...
         && string(row(i)+2,col(i)-2) =='A' ...   
         && string(row(i)+3,col(i)-3) =='S')
        diag = diag+1;
    end
    % Check diagonal upwards right
    if (row(i)>3 && col(i)<length(string)-2 ...
             && string(row(i)-1,col(i)+1) =='M' ...
             && string(row(i)-2,col(i)+2) =='A' ...   
             && string(row(i)-3,col(i)+3) =='S')
        diag = diag+1;
    end
    % Check diagonal downwards right
    if (row(i)<length(string)-2 && col(i)<length(string)-2 ...
             && string(row(i)+1,col(i)+1) =='M' ...
             && string(row(i)+2,col(i)+2) =='A' ...   
             && string(row(i)+3,col(i)+3) =='S')
        diag = diag+1;
    end
end
result1 = horz+vert+diag;

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now we need to find "X-MAS"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; 

% Find all positions of X
[row,col] = find(string=='A');

% Check for each of those positions if we have an X-MAS in some way (4
% ways possible)

% M.S
% .A.
% M.S
% S.S
% .A.
% M.M
% S.M
% .A.
% S.M
% M.M
% .A.
% S.S
for i=1:length(col)
%     row(i)
%     col(i)
    % Check diagonal downwards left
    if (   row(i) > 1 && row(i) < length(string) ...
        && col(i) > 1 && col(i) < length(string))
        % We have the space at least now check the cases
        % Case 1
        if (string(row(i)-1,col(i)-1) == 'M' && ...
            string(row(i)+1,col(i)+1) == 'S' && ...
            string(row(i)+1,col(i)-1) == 'M' && ...
            string(row(i)-1,col(i)+1) == 'S')
            result2 = result2+1;
        % Case 2
        elseif (string(row(i)-1,col(i)-1) == 'S' && ...
            string(row(i)+1,col(i)+1) == 'M' && ...
            string(row(i)+1,col(i)-1) == 'M' && ...
            string(row(i)-1,col(i)+1) == 'S')
            result2 = result2+1;
        % Case 3
        elseif (string(row(i)-1,col(i)-1) == 'M' && ...
            string(row(i)+1,col(i)+1) == 'S' && ...
            string(row(i)+1,col(i)-1) == 'S' && ...
            string(row(i)-1,col(i)+1) == 'M')
            result2 = result2+1;
        % Case 4
        elseif (string(row(i)-1,col(i)-1) == 'S' && ...
            string(row(i)+1,col(i)+1) == 'M' && ...
            string(row(i)+1,col(i)-1) == 'S' && ...
            string(row(i)-1,col(i)+1) == 'M')
            result2 = result2+1;
        end
    end
end

fprintf('%10f',result2)
fprintf('\n')
toc

