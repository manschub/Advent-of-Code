clc; clearvars;
% Advent of code 2023 - day 12 - part 1+2
% Open file and take needed data
file_id = fopen("day24.dat");
data = textscan(file_id,strcat('%f %f %f %f %f %f'),'delimiter',', @','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);
positions = []; velocities = [];
% Rearrange data to be handled nicer
for i = 1:length(data{1,1})
    positions(i,:) = [data{1,1}(i),data{1,2}(i),data{1,3}(i)];
    velocities(i,:) = [data{1,4}(i),data{1,5}(i),data{1,6}(i)];
end
tic
% test_area = [7, 27];
test_area = [200000000000000, 400000000000000];

% Should be simple to do a mathematical solution considering y = mx+b
% We have the two equations: x10 + mx1*t1 = x20 + mx2*t2 and 
%                            y10 + my1*t1 = y20 + my2*t2 
cnt_intersect = 0;
intersections = [];
for i = 1:length(positions(:,1))
    for j = i+1:length(positions(:,1))
        % t2 = (y20-y10-(my1*x20/mx1)+(my1*x10/mx1))/((my1*mx2/mx1)-my2)
        x10 = positions(i,1);  x20 = positions(j,1);
        y10 = positions(i,2);  y20 = positions(j,2);
        mx1 = velocities(i,1); mx2 = velocities(j,1);
        my1 = velocities(i,2); my2 = velocities(j,2);
        % 
        t2 = (y20-y10-(my1*x20/mx1)+(my1*x10/mx1))/((my1*mx2/mx1)-my2);
        % t1 = (x20-x10+mx2*t2)/mx1
        t1 = (x20-x10+mx2*t2)/mx1;
        % Now enter in either original equations for x and y
        intersect_x = x10+mx1*t1;
        intersect_y = y10+my1*t1;
        % Take care of infinities
        if (intersect_x == inf || intersect_x == -inf || ...
                intersect_y == inf || intersect_y == -inf)
            intersect_x = 0; 
            intersect_y = 0;
            t1 = 0; t2 = 0;
        end
        % Now check if intersection is in our test area
        if (intersect_x >= test_area(1) && intersect_x <= test_area(2) && ...
            intersect_y >= test_area(1) && intersect_y <= test_area(2) && ...
            t1 >= 0 && t2 >= 0)
            cnt_intersect = cnt_intersect+1;
            intersections(end+1,:) = [intersect_x,intersect_y];
        end
    end
end
fprintf('%10f',cnt_intersect)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Determine the exact position and velocity the rock needs to have
% at time 0 so that it perfectly collides with every hailstone. What do you 
% get if you add up the X, Y, and Z coordinates of that initial position?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear t1 t2 intersections intersect_x intersect_y test_area
% We need to find a line for the rock that intersects with all hailstone 
% lines and we can choose start and velocity (x,y,z) as we want
tic

% We need to use 3 hailstones: 9 equations with 9 unknowns
syms t1 t2 t3 xs ys zs vxs vys vzs

x1 = positions(1,1);    y1 = positions(1,2);    z1 = positions(1,3);
vx1 = velocities(1,1); vy1 = velocities(1,2);  vz1 = velocities(1,3);
x2 = positions(2,1);    y2 = positions(2,2);    z2 = positions(2,3);
vx2 = velocities(2,1); vy2 = velocities(2,2);  vz2 = velocities(2,3);
x3 = positions(3,1);    y3 = positions(3,2);    z3 = positions(3,3);
vx3 = velocities(3,1); vy3 = velocities(3,2);  vz3 = velocities(3,3);

% Hailstone 1
eq1 = x1 + vx1 * t1 == xs + vxs * t1;
eq2 = y1 + vy1 * t1 == ys + vys * t1;
eq3 = z1 + vz1 * t1 == zs + vzs * t1;
% Hailstone 2
eq4 = x2 + vx2 * t2 == xs + vxs * t2;
eq5 = y2 + vy2 * t2 == ys + vys * t2;
eq6 = z2 + vz2 * t2 == zs + vzs * t2;
% Hailstone 3
eq7 = x3 + vx3 * t3 == xs + vxs * t3;
eq8 = y3 + vy3 * t3 == ys + vys * t3;
eq9 = z3 + vz3 * t3 == zs + vzs * t3;

% Now let's solve it for xs, ys, zs, vxs, vys, vzs, and all the times
assume(t1>0); assume(t2>0); assume(t3>0); 
assume(xs,'integer'); assume(ys,'integer'); assume(zs,'integer');
assume(vxs,'integer'); assume(vys,'integer'); assume(vzs,'integer');
[xs,ys,zs,vxs,vys,vzs,t1,t2,t3] = solve(eq1,eq2,eq3,eq4,eq5, ...
    eq6,eq7,eq8,eq9,[xs,ys,zs,vxs,vys,vzs,t1,t2,t3]);

fprintf('%10f',xs+ys+zs)
fprintf('\n')
toc

