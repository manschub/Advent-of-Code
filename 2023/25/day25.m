clc; clear all;
% Advent of code 2023 - day 25 - part 1+2
% Open file and take needed data
file_id = fopen("day25.dat");
data = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

tic

% Start by going through all lines and write connections down
for i = 1:length(data{1,1})
    % Take connection
    connections{i,1} = data{1,1}{i,1}(1:3);
    % Get number of connected wires
    wires = data{1,1}{i,1}(6:end); 
    if (length(wires) == 3)
        cnt_wires = 1;
    elseif (length(wires) == 7)
        cnt_wires = 2;
    elseif (length(wires) == 11)
        cnt_wires = 3;
    elseif (length(wires) == 15)
        cnt_wires = 4;
    elseif (length(wires) == 19)
        cnt_wires = 5;
    elseif (length(wires) == 23)
        cnt_wires = 6;
    elseif (length(wires) == 27)
        cnt_wires = 7;
    elseif (length(wires) == 31)
        cnt_wires = 8;
    elseif (length(wires) == 35)
        cnt_wires = 9;
    end
    % For each of those we write down the sub-connections
    for j = 1:cnt_wires
        connections{i,j+1} = data{1,1}{i,1}(2+4*j:4+4*j);
    end
end
% Now store every unique string separately
for i = 1:length(connections)
    if (i==1)
        conns = connections{1,1};
    else
        conns(end+1,:) = connections{i,1};
    end
    for j = 2:length(connections(1,:))
        if (~isempty(connections{i,j}))
            conns(end+1,:) = connections{i,j};
        end
    end
end
conns = unique(conns,'rows');

% Now for each unique wire we write down all wires that are attached to it
for i = 1:length(conns)
    conns_final{i,1} = conns(i,:);
    % For each wire go through all connections
    q = 2;
    for j = 1:length(connections)
        if (j == i)
            continue
        end
        for k = 1:length(connections(1,:))
            if (~isempty(connections{j,k}) && all(conns_final{i,1}(:)' == connections{j,k}))
                if (k == 1)
                    % We found it on the left side of the colon so we take
                    % everything to the right
                    for l = 2:length(connections(1,:))
                        if (~isempty(connections{j,l}))
                            conns_final{i,q} = connections{j,l};
                            q=q+1;
                        end
                    end
                else
                    % We found it on the right side so we only take the one
                    % on the left
                    conns_final{i,q} = connections{j,1};
                    q=q+1;
                end
            end
        end
    end
end
% Now create source and target nodes to visualize everything
k = 1;
for i = 1:length(conns_final(:,1))
    for j = 2:length(conns_final(1,:))
        if (~isempty(conns_final{i,j}))
            sources_nodes(k,:) = conns_final{i,1};
            target_nodes(k,:)  = conns_final{i,j}; 
            k = k+1;
        end
    end
end

G1 = graph(cellstr(sources_nodes),cellstr(target_nodes),'omitselfloops');
figure(1)
h1 = plot(G1);
h1.NodeLabelMode = 'auto';

% We find the nodes to be cut graphically and depending on which those
% are we calculate how many nodes are in each group afterwards
% Nodes to be cut: szh - vqj, jbx - sml, zhb - vxr
Edges1 = G1.Edges;
Nodes1 = G1.Nodes;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version with cut wires
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file_id = fopen("day25_cut.dat");
data2 = textscan(file_id,strcat('%s'),'delimiter','\n','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Start by going through all lines and write connections down
for i = 1:length(data2{1,1})
    % Take connection
    connections2{i,1} = data2{1,1}{i,1}(1:3);
    % Get number of connected wires
    wires = data2{1,1}{i,1}(6:end); 
    if (length(wires) == 3)
        cnt_wires = 1;
    elseif (length(wires) == 7)
        cnt_wires = 2;
    elseif (length(wires) == 11)
        cnt_wires = 3;
    elseif (length(wires) == 15)
        cnt_wires = 4;
    elseif (length(wires) == 19)
        cnt_wires = 5;
    elseif (length(wires) == 23)
        cnt_wires = 6;
    elseif (length(wires) == 27)
        cnt_wires = 7;
    elseif (length(wires) == 31)
        cnt_wires = 8;
    elseif (length(wires) == 35)
        cnt_wires = 9;
    end
    % For each of those we write down the sub-connections
    for j = 1:cnt_wires
        connections2{i,j+1} = data2{1,1}{i,1}(2+4*j:4+4*j);
    end
end
% Now store every unique string separately
for i = 1:length(connections2)
    if (i==1)
        conns2 = connections2{1,1};
    else
        conns2(end+1,:) = connections2{i,1};
    end
    for j = 2:length(connections2(1,:))
        if (~isempty(connections2{i,j}))
            conns2(end+1,:) = connections2{i,j};
        end
    end
end
conns2 = unique(conns2,'rows');

% Now for each unique wire we write down all wires that are attached to it
for i = 1:length(conns2)
    conns_final2{i,1} = conns2(i,:);
    % For each wire go through all connections
    q = 2;
    for j = 1:length(connections2)
        if (j == i)
            continue
        end
        for k = 1:length(connections2(1,:))
            if (~isempty(connections2{j,k}) && all(conns_final2{i,1}(:)' == connections2{j,k}))
                if (k == 1)
                    % We found it on the left side of the colon so we take
                    % everything to the right
                    for l = 2:length(connections2(1,:))
                        if (~isempty(connections2{j,l}))
                            conns_final2{i,q} = connections2{j,l};
                            q=q+1;
                        end
                    end
                else
                    % We found it on the right side so we only take the one
                    % on the left
                    conns_final2{i,q} = connections2{j,1};
                    q=q+1;
                end
            end
        end
    end
end
% Now create source and target nodes to visualize everything
k = 1;
for i = 1:length(conns_final2(:,1))
    for j = 2:length(conns_final2(1,:))
        if (~isempty(conns_final2{i,j}))
            sources_nodes2(k,:) = conns_final2{i,1};
            target_nodes2(k,:)  = conns_final2{i,j}; 
            k = k+1;
        end
    end
end

G2 = graph(cellstr(sources_nodes2),cellstr(target_nodes2),'omitselfloops');
figure(2)
h2 = plot(G2);
h2.NodeLabelMode = 'auto';

Edges2 = G2.Edges;
Nodes2 = G2.Nodes;

[bins1,binsizes1] = conncomp(G1);
[bins2,binsizes2] = conncomp(G2);

% The bin sizes 2 should be the number of our 2 group sizes
result_part1 = binsizes2(1)*binsizes2(2);
fprintf('%10f',result_part1)
fprintf('\n')
toc
