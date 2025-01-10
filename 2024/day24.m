clc; clearvars;
% Advent of code 2024 - day 24 - part 1+2
% Open file for initial values of wires
file_id = fopen("day24.dat");
data = textscan(file_id,strcat('%s %f'),'Delimiter',': ', ...
    'MultipleDelimsAsOne',true);
% Close file
fclose(file_id);

% Reorganize data
[x,~] = size(data{1,1});
for i = 1:x
    wire_inp(i,:) = data{1,1}{i,1};
end
values_inp = data{1,2};

% Open 2nd file for all operations of wires
file_id = fopen("day24_2.dat");
data2 = textscan(file_id,strcat('%s %s %s %s'),'Delimiter',' ->', ...
    'MultipleDelimsAsOne',true);
% Close file
fclose(file_id);

% Reorganize data
[x,~] = size(data2{1,1});
for i = 1:x
    if (length(data2{1,2}{i,1})==2)
        data2{1,2}{i,1} = 'OR.';
    end
end
for i = 1:x
    wire1(i,:) = data2{1,1}{i,1};
    op(i,:) = data2{1,2}{i,1};
    wire2(i,:) = data2{1,3}{i,1};
    wire_out(i,:) = data2{1,4}{i,1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - We need to go through the instructions and get the final values
% of all z wires
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Get all unique wires first
wires = [wire1;wire2;wire_out;wire_inp];
wires = unique(wires,'rows');
% Initialize values of wires
values(1:length(wires(:,1)),1) = NaN;
for i = 1:length(wire_inp(:,1))
    % Set value
    values(wires(:,1)==wire_inp(i,1) & wires(:,2)==wire_inp(i,2) & ...
        wires(:,3)==wire_inp(i,3)) = values_inp(i);
end

% Now go through operations (in the correct order)
cnt = 1;
idx_done = zeros(length(op(:,1)),1);
while (cnt <= length(op(:,1)))
    % Check which operation
    % First search the first suitable pair (wire 1 and wire 2 must be
    % initialized - cannot be NaN)
    for j = 1:length(op(:,1))
        if (idx_done(j) == 1)
            continue
        end
        % Check if we can take the current operation
        if (~isnan(values(wires(:,1)==wire1(j,1) &  ...
                wires(:,2)==wire1(j,2) & wires(:,3)==wire1(j,3))) && ...
                ~isnan(values(wires(:,1)==wire2(j,1) & ...
                wires(:,2)==wire2(j,2) & wires(:,3)==wire2(j,3))))
            i = j;
            idx_done(j) = 1;
            break
        end
    end
    if (op(i,:) == 'AND')
        % AND
        if (values(wires(:,1)==wire1(i,1) & wires(:,2)==wire1(i,2) & ...
            wires(:,3)==wire1(i,3)) == 1 && ...
            values(wires(:,1)==wire2(i,1) & wires(:,2)==wire2(i,2) & ...
            wires(:,3)==wire2(i,3)) == 1)
            % If both wires are 1 we set the output wire to 1 as well
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 1;
        else
            % Else to 0
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 0;
        end
    elseif (op(i,:) == 'OR.')
        % OR
        if ((values(wires(:,1)==wire1(i,1) & wires(:,2)==wire1(i,2) & ...
            wires(:,3)==wire1(i,3)) == 1 && ...
            values(wires(:,1)==wire2(i,1) & wires(:,2)==wire2(i,2) & ...
            wires(:,3)==wire2(i,3)) == 1) || ...
            values(wires(:,1)==wire1(i,1) & wires(:,2)==wire1(i,2) & ...
                wires(:,3)==wire1(i,3)) == 1 || ...
            values(wires(:,1)==wire2(i,1) & wires(:,2)==wire2(i,2) & ...
            wires(:,3)==wire2(i,3)) == 1)
            % If both wires are 1 we set the output wire to 1 as well
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 1;
        else
            % Else to 0
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 0;
        end
    else
        % XOR
        if ((values(wires(:,1)==wire1(i,1) & wires(:,2)==wire1(i,2) & ...
            wires(:,3)==wire1(i,3)) == 1 && ...
            values(wires(:,1)==wire2(i,1) & wires(:,2)==wire2(i,2) & ...
            wires(:,3)==wire2(i,3)) == 0) || ...
            (values(wires(:,1)==wire1(i,1) & wires(:,2)==wire1(i,2) & ...
            wires(:,3)==wire1(i,3)) == 0 && ...
            values(wires(:,1)==wire2(i,1) & wires(:,2)==wire2(i,2) & ...
            wires(:,3)==wire2(i,3)) == 1))
            % If both wires are 1 we set the output wire to 1 as well
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 1;
        else
            % Else to 0
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 0;
        end
    end
    cnt = cnt+1;
end

% Get values from z wires
values_fin = values(wires(:,1)=='z');
values_fin(isnan(values_fin)) = 0;
binstr = '';
for i = length(values_fin):-1:1
    binstr = strcat(binstr,num2str(values_fin(i)));
end
% Get our decimal value
result1 = bin2dec(string(binstr));

fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Four output wires have been swapped and we need to know 
% which four of them
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Here we need to get the values for x and y to confirm that later
% Get values from x wires
values_x = values(wires(:,1)=='x');
values_x(isnan(values_x)) = 0;
binstr = '';
for i = length(values_x):-1:1
    binstr = strcat(binstr,num2str(values_x(i)));
end
% Get our decimal value
x_val = bin2dec(string(binstr));
% Get values from y wires
values_y = values(wires(:,1)=='y');
values_y(isnan(values_y)) = 0;
binstr = '';
for i = length(values_y):-1:1
    binstr = strcat(binstr,num2str(values_y(i)));
end
% Get our decimal value
y_val = bin2dec(string(binstr));

% To be able to break quickly, let's get all the values z would need to 
% have
z_str = dec2bin((x_val+y_val));
j = 1;
for i = length(z_str):-1:1
    z_values(j,1) = str2double(z_str(i));
    j = j+1;
end

% Make a graph of the connections and solve graphically
% Change wrong wires
wire_out_ini = wire_out;
wire_out(wire_out_ini(:,1)=='z' & wire_out_ini(:,2)=='0' & ...
    wire_out_ini(:,3) == '7',1:3) = 'shj';
wire_out(wire_out_ini(:,1)=='s' & wire_out_ini(:,2)=='h' & ...
    wire_out_ini(:,3) == 'j',1:3) = 'z07';
wire_out(wire_out_ini(:,1)=='z' & wire_out_ini(:,2)=='2' & ...
    wire_out_ini(:,3) == '7',1:3) = 'kcd';
wire_out(wire_out_ini(:,1)=='k' & wire_out_ini(:,2)=='c' & ...
    wire_out_ini(:,3) == 'd',1:3) = 'z27';
wire_out(wire_out_ini(:,1)=='z' & wire_out_ini(:,2)=='2' & ...
    wire_out_ini(:,3) == '3',1:3) = 'pfn';
wire_out(wire_out_ini(:,1)=='p' & wire_out_ini(:,2)=='f' & ...
    wire_out_ini(:,3) == 'n',1:3) = 'z23';
wire_out(wire_out_ini(:,1)=='w' & wire_out_ini(:,2)=='k' & ...
    wire_out_ini(:,3) == 'b',1:3) = 'tpk';
wire_out(wire_out_ini(:,1)=='t' & wire_out_ini(:,2)=='p' & ...
    wire_out_ini(:,3) == 'k',1:3) = 'wkb';

% Get an order so that graphic looks better readable
% Get wires connected with and
wire1_and = '';
wire2_and = '';
wire_out_and = '';
weight_and = [];
for i = 1:length(wire1(:,1))
    if (op(i,1) == 'A' && op(i,2) == 'N' && op(i,3) == 'D')
        wire1_and(end+1,1:3) = wire1(i,:);
        wire2_and(end+1,1:3) = wire2(i,:);
        wire_out_and(end+1,1:3) = wire_out(i,:);
        weight_and(end+1,1) = 100;
    end
end
% Get wires connected with OR
wire1_or = '';
wire2_or = '';
wire_out_or = '';
weight_or = [];
for i = 1:length(wire1(:,1))
    if (op(i,1) == 'O' && op(i,2) == 'R' && op(i,3) == '.')
        wire1_or(end+1,1:3) = wire1(i,:);
        wire2_or(end+1,1:3) = wire2(i,:);
        wire_out_or(end+1,1:3) = wire_out(i,:);
        weight_or(end+1,1) = 200;
    end
end
% Get wires connected with XOR
wire1_xor = '';
wire2_xor = '';
wire_out_xor = '';
weight_xor = [];
for i = 1:length(wire1(:,1))
    if (op(i,1) == 'X' && op(i,2) == 'O' && op(i,3) == 'R')
        wire1_xor(end+1,1:3) = wire1(i,:);
        wire2_xor(end+1,1:3) = wire2(i,:);
        wire_out_xor(end+1,1:3) = wire_out(i,:);
        weight_xor(end+1,1) = 1000;
    end
end
% Plot all connections
G5 = digraph(cellstr([wire1_and;wire2_and;wire1_or;wire2_or; ...
    wire1_xor;wire2_xor]),cellstr([wire_out_and;wire_out_and; ...
    wire_out_or;wire_out_or;wire_out_xor;wire_out_xor]));
figure(5)
h5 = plot(G5,'Layout','force');
h5.NodeLabelMode = 'auto';
% Highlight XORs, ANDs, and ORs
for i = 1:311
    if (~isempty(wire1_xor(wire1_xor(:,1) == G5.Nodes{i,:}{1,1}(1) & ...
            wire1_xor(:,2) == G5.Nodes{i,:}{1,1}(2) & ...
            wire1_xor(:,3) == G5.Nodes{i,:}{1,1}(3))) || ...
        ~isempty(wire2_xor(wire2_xor(:,1) == G5.Nodes{i,:}{1,1}(1) & ...
            wire2_xor(:,2) == G5.Nodes{i,:}{1,1}(2) & ...
            wire2_xor(:,3) == G5.Nodes{i,:}{1,1}(3))) || ...
         ~isempty(wire_out_xor(wire_out_xor(:,1) == G5.Nodes{i,:}{1,1}(1) & ...
            wire_out_xor(:,2) == G5.Nodes{i,:}{1,1}(2) & ...
            wire_out_xor(:,3) == G5.Nodes{i,:}{1,1}(3))))
        highlight(h5,[i,i+1],'NodeColor','blue')
    elseif (~isempty(wire1_and(wire1_and(:,1) == G5.Nodes{i,:}{1,1}(1) & ...
            wire1_and(:,2) == G5.Nodes{i,:}{1,1}(2) & ...
            wire1_and(:,3) == G5.Nodes{i,:}{1,1}(3))) || ...
        ~isempty(wire2_and(wire2_and(:,1) == G5.Nodes{i,:}{1,1}(1) & ...
            wire2_and(:,2) == G5.Nodes{i,:}{1,1}(2) & ...
            wire2_and(:,3) == G5.Nodes{i,:}{1,1}(3))) || ...
         ~isempty(wire_out_and(wire_out_and(:,1) == G5.Nodes{i,:}{1,1}(1) & ...
            wire_out_and(:,2) == G5.Nodes{i,:}{1,1}(2) & ...
            wire_out_and(:,3) == G5.Nodes{i,:}{1,1}(3))))
        highlight(h5,[i,i+1],'NodeColor','green')
    else
        highlight(h5,[i,i+1],'NodeColor','red')
    end
end

% Test result
% Initialize values of wires
values(1:length(wires(:,1)),1) = NaN;
for i = 1:length(wire_inp(:,1))
    % Set value
    values(wires(:,1)==wire_inp(i,1) & wires(:,2)==wire_inp(i,2) & ...
        wires(:,3)==wire_inp(i,3)) = values_inp(i);
end

% Now go through operations (in the correct order)
cnt = 1;
idx_done = zeros(length(op(:,1)),1);
while (cnt < length(op(:,1)))
    % Check which operation
    % First search the first suitable pair (wire 1 and wire 2 must be
    % initialized - cannot be NaN)
    for j = 1:length(op(:,1))
        if (idx_done(j) == 1)
            continue
        end
        % Check if we can take the current operation
        if (~isnan(values(wires(:,1)==wire1(j,1) &  ...
                wires(:,2)==wire1(j,2) & wires(:,3)==wire1(j,3))) && ...
                ~isnan(values(wires(:,1)==wire2(j,1) & ...
                wires(:,2)==wire2(j,2) & wires(:,3)==wire2(j,3))))
            i = j;
            idx_done(j) = 1;
            break
        end
    end
    if (op(i,:) == 'AND')
        % AND
        if (values(wires(:,1)==wire1(i,1) & wires(:,2)==wire1(i,2) & ...
            wires(:,3)==wire1(i,3)) == 1 && ...
            values(wires(:,1)==wire2(i,1) & wires(:,2)==wire2(i,2) & ...
            wires(:,3)==wire2(i,3)) == 1)
            % If both wires are 1 we set the output wire to 1 as well
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 1;
        else
            % Else to 0
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 0;
        end
    elseif (op(i,:) == 'OR.')
        % OR
        if ((values(wires(:,1)==wire1(i,1) & wires(:,2)==wire1(i,2) & ...
            wires(:,3)==wire1(i,3)) == 1 && ...
            values(wires(:,1)==wire2(i,1) & wires(:,2)==wire2(i,2) & ...
            wires(:,3)==wire2(i,3)) == 1) || ...
            values(wires(:,1)==wire1(i,1) & wires(:,2)==wire1(i,2) & ...
                wires(:,3)==wire1(i,3)) == 1 || ...
            values(wires(:,1)==wire2(i,1) & wires(:,2)==wire2(i,2) & ...
            wires(:,3)==wire2(i,3)) == 1)
            % If both wires are 1 we set the output wire to 1 as well
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 1;
        else
            % Else to 0
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 0;
        end
    else
        % XOR
        if ((values(wires(:,1)==wire1(i,1) & wires(:,2)==wire1(i,2) & ...
            wires(:,3)==wire1(i,3)) == 1 && ...
            values(wires(:,1)==wire2(i,1) & wires(:,2)==wire2(i,2) & ...
            wires(:,3)==wire2(i,3)) == 0) || ...
            (values(wires(:,1)==wire1(i,1) & wires(:,2)==wire1(i,2) & ...
            wires(:,3)==wire1(i,3)) == 0 && ...
            values(wires(:,1)==wire2(i,1) & wires(:,2)==wire2(i,2) & ...
            wires(:,3)==wire2(i,3)) == 1))
            % If both wires are 1 we set the output wire to 1 as well
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 1;
        else
            % Else to 0
            values(wires(:,1)==wire_out(i,1) & wires(:,2)==wire_out(i,2) & ...
                wires(:,3)==wire_out(i,3)) = 0;
        end
    end
    cnt = cnt+1;
end

% Get values from z wires
values_fin = values(wires(:,1)=='z');
values_fin(isnan(values_fin)) = 0;
binstr = '';
for i = length(values_fin):-1:1
    binstr = strcat(binstr,num2str(values_fin(i)));
end
% Get our decimal value
z_val = bin2dec(string(binstr));

if (z_val == (x_val+y_val))
    fprintf('kcd,pfn,shj,tpk,wkb,z07,z23,z27')
    fprintf('\n')
else
    fprintf('Wrong result')
    fprintf('\n')
end
toc

