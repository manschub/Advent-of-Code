clc; clearvars;
% Advent of code 2025 - day 9 - part 1+2
% Open file and take needed data
file_id = fopen("day9.dat");
data = textscan(file_id,'%f %f','delimiter',', ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Rearrange data
pos = [data{1,1},data{1,2}]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to find the two opposite corners of tiles that create
% the largest possible rectangle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

rect_area = 0;
% We have to try all
for i = 1:size(pos,1)
    % Calculate area of current paired corners 
    for j = i+1:size(pos,1)
        tmp = (max(pos(i,1),pos(j,1))-min(pos(i,1),pos(j,1))+1)* ...
                (max(pos(i,2),pos(j,2))-min(pos(i,2),pos(j,2))+1);
        % If it's larger than our current largest we store new largest
        if (rect_area < tmp)
            rect_area = tmp;
        end
    end
end
result1 = rect_area;
% 4769758290
fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Now it's a bit more complicated, but we still have to find the
% largest area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% We basically do the same, but we have to do an additional check if the
% tiles of the rectangle are all green or red - are within the area span by
% all red tiles
rect_area = 0;
rg = polyshape(pos);
is_inside = @(ps1,ps2)abs(area(ps2)-area(subtract(ps2,ps1))- ...
    area(ps1))<(area(ps1)*1e-06);
% We have to try all
for i = 1:size(pos,1)
    % Calculate area of current paired corners 
    for j = i+1:size(pos,1)
        % We can skip immediately if our area is smaller than our current
        % max
        if ((max(pos(i,1),pos(j,1))-min(pos(i,1),pos(j,1))+1)* ...
                (max(pos(i,2),pos(j,2))-min(pos(i,2),pos(j,2))+1) < rect_area)
            continue
        end
        % Otherwise, check
        if (max(pos(i,2),pos(j,2))-min(pos(i,2),pos(j,2))>0 ...
                && max(pos(i,1),pos(j,1))-min(pos(i,1),pos(j,1))>0)
            % Create second polygon
            % x-coordinates (bottom-left, bottom-right, top-right, top-left)
            x_rect = [min(pos(i,1),pos(j,1)),max(pos(i,1),pos(j,1)), ...
                max(pos(i,1),pos(j,1)),min(pos(i,1),pos(j,1))]; 
            % y-coordinates
            y_rect = [min(pos(i,2),pos(j,2)),min(pos(i,2),pos(j,2)), ...
                max(pos(i,2),pos(j,2)),max(pos(i,2),pos(j,2))]; 
            % Create the polyshape object
            rect = polyshape(x_rect, y_rect);
            % Now check if second poly is within first
            inarea = is_inside(rect,rg);
            if (inarea==0)
                continue
            end
        else
            % First we need to check now where the coordinates of this
            % rectangle would be
            x = min(pos(i,1),pos(j,1)):max(pos(i,1),pos(j,1));
            y = min(pos(i,2),pos(j,2)):max(pos(i,2),pos(j,2));
            [xvals,yvals] = meshgrid(x,y);
            xvals = xvals(:);
            yvals = yvals(:);
            % Check if all the values of this area are within our red green
            % area
            inarea = 1;
            [in,on] = inpolygon(xvals,yvals,rg.Vertices(:,1),rg.Vertices(:,2));    
            if (min(in+on)<1)
                inarea = 0;
                continue
            end
        end
        tmp = (max(pos(i,1),pos(j,1))-min(pos(i,1),pos(j,1))+1)* ...
                (max(pos(i,2),pos(j,2))-min(pos(i,2),pos(j,2))+1);
        % If it's larger than our current largest we store new largest
        if (rect_area < tmp)
            rect_area = tmp;
        end
    end
end
result2 = rect_area;
% 1588990708
fprintf('%10f',result2)
fprintf('\n')
toc

