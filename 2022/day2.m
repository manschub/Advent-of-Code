clc; clearvars;
% Advent of code 2022 - day 2 - part 1+2
% Open file and take needed data
file_id = fopen("day2.dat");
data = textscan(file_id,strcat('%s %s'), 'Delimiter',' ', ...
    'MultipleDelimsAsOne',true);
% Close file
fclose(file_id);

opp_moves = [data{1,1}{:,1}]; 
strategies = [data{1,2}{:,1}];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We play rock, paper, scissors and have to check our score for
% following the strategy guide we are provided
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
score = 0;
% Go through moves
for i = 1:length(opp_moves)
    % Let's go through possible cases
    % Opponent plays rock (A)
    if (opp_moves(i) == 'A')
        % If we play rock (X) -> 1 point we have a draw -> 3 points
        if (strategies(i) == 'X')
            score = score+4;
        % If we play paper (Y) -> 2 points we win -> 6 Points
        elseif (strategies(i) == 'Y')
            score = score+8;
        % If we play scissors (Z) -> 3 points we lose -> 0 points
        else
            score = score+3;
        end
    % Opponent plays paper (B)
    elseif (opp_moves(i) == 'B')
        % If we play rock (X) -> 1 point we lose -> 0 points
        if (strategies(i) == 'X')
            score = score+1;
        % If we play paper (Y) -> 2 points we have a draw -> 3 Points
        elseif (strategies(i) == 'Y')
            score = score+5;
        % If we play scissors (Z) -> 3 points we win -> 6 points
        else
            score = score+9;
        end
    % Opponent plays scissors (C)
    else
        % If we play rock (X) -> 1 point we win -> 6 points
        if (strategies(i) == 'X')
            score = score+7;
        % If we play paper (Y) -> 2 points we lose -> 0 Points
        elseif (strategies(i) == 'Y')
            score = score+2;
        % If we play scissors (Z) -> 3 points we have a draw -> 3 points
        else
            score = score+6;
        end
    end
end

result1 = score;

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Same as part 1, but now X means we lose, Y means we draw, and Z
% means we win
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
score = 0;
% Go through moves
for i = 1:length(opp_moves)
    % Let's go through possible cases
    % Opponent plays rock (A)
    if (opp_moves(i) == 'A')
        % If we have X we need to lose -> 0 points and play scissors -> 3 points
        if (strategies(i) == 'X')
            score = score+3;
        % If we have Y we need to draw -> 3 points and play rock -> 1 point
        elseif (strategies(i) == 'Y')
            score = score+4;
        % If we have Z we need to win -> 6 points and play paper -> 2 points
        else
            score = score+8;
        end
    % Opponent plays paper (B)
    elseif (opp_moves(i) == 'B')
        % If we have X we need to lose -> 0 points and play rock -> 1 point
        if (strategies(i) == 'X')
            score = score+1;
        % If we have Y we need to draw -> 3 points and play paper -> 2 points
        elseif (strategies(i) == 'Y')
            score = score+5;
        % If we have Z we need to win -> 6 points and play scissors -> 3 points
        else
            score = score+9;
        end
    % Opponent plays scissors (C)
    else
        % If we have X we need to lose -> 0 points and play paper -> 2 points
        if (strategies(i) == 'X')
            score = score+2;
        % If we have Y we need to draw -> 3 points and play scissors -> 3 points
        elseif (strategies(i) == 'Y')
            score = score+6;
        % If we have Z we need to win -> 6 points and play rock -> 1 point
        else
            score = score+7;
        end
    end
end

result2 = score;

fprintf('%10f',result2)
fprintf('\n')
toc

