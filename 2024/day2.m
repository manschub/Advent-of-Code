clc; clearvars;
% Advent of code 2024 - day 2 - part 1+2
% Open file and take needed data
file_id = fopen("day2.dat");
data = textscan(file_id,strcat('%f %f %f %f %f %f %f %f'),'delimiter',', ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Reorganize data
for i = 1:length(data{1,1})
    % Current data
%     reports(i,:) = [data{1,1}(i);data{1,2}(i);data{1,3}(i);data{1,4}(i); ...
%         data{1,5}(i)];
    reports(i,:) = [data{1,1}(i);data{1,2}(i);data{1,3}(i);data{1,4}(i); ...
        data{1,5}(i);data{1,6}(i);data{1,7}(i);data{1,8}(i)];
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Find number of safe reports
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result1 = 0; 
for i = 1:length(reports)
    dec = 0; inc = 0; 
    % Decreasing or increasing?
    if (reports(i,2)<reports(i,1)&&(reports(i,1)-reports(i,2))<=3)
        dec = 1;
    elseif (reports(i,2)>reports(i,1)&&(reports(i,2)-reports(i,1))<=3)
        inc = 1;
    else
        continue
    end
    for j = 2:length(reports(i,:))
        if (isnan(reports(i,j)))
            break
        elseif (dec == 1 && reports(i,j)<reports(i,j-1) && (reports(i,j-1)-reports(i,j))<=3)
            safe = 1;
        elseif (inc == 1 && reports(i,j)>reports(i,j-1) && (reports(i,j)-reports(i,j-1))<=3)
            safe = 1;
        else
            safe = 0;
            break
        end
    end
    result1 = result1+safe;
end
fprintf('%10f',result1)
fprintf('\n')
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - We add 1 fault-tolerance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
result2 = 0; unsafe_reports(1,1:8) = 0;
for i = 1:length(reports)
    dec = 0; inc = 0; 
    % Decreasing or increasing?
    if (reports(i,2)<reports(i,1)&&(reports(i,1)-reports(i,2))<=3)
        dec = 1;
    elseif (reports(i,2)>reports(i,1)&&(reports(i,2)-reports(i,1))<=3)
        inc = 1;
    else
        unsafe_reports(end+1,:) = reports(i,:);
        continue
    end
    for j = 2:length(reports(i,:))
        if (isnan(reports(i,j)))
            break
        elseif (dec == 1 && reports(i,j)<reports(i,j-1) && (reports(i,j-1)-reports(i,j))<=3)
            safe = 1;
        elseif (inc == 1 && reports(i,j)>reports(i,j-1) && (reports(i,j)-reports(i,j-1))<=3)
            safe = 1;
        else
            safe = 0;
            unsafe_reports(end+1,:) = reports(i,:);
            break
        end
    end
    result2 = result2+safe;
end
unsafe_reports = unsafe_reports(2:end,:);

% Now with the unsafe reports we remove one column and try again
for k=1:length(reports(1,:))
    reports = [unsafe_reports(:,1:k-1),unsafe_reports(:,k+1:end)];
    tobedeleted = [];
    tobedeleted(1,1) = 0;
    for i = 1:length(reports)
        dec = 0; inc = 0; 
        % Decreasing or increasing?
        if (reports(i,2)<reports(i,1)&&(reports(i,1)-reports(i,2))<=3)
            dec = 1;
        elseif (reports(i,2)>reports(i,1)&&(reports(i,2)-reports(i,1))<=3)
            inc = 1;
        else
            continue
        end
        for j = 2:length(reports(i,:))
            if (isnan(reports(i,j)))
                break
            elseif (dec == 1 && reports(i,j)<reports(i,j-1) && (reports(i,j-1)-reports(i,j))<=3)
                safe = 1;
            elseif (inc == 1 && reports(i,j)>reports(i,j-1) && (reports(i,j)-reports(i,j-1))<=3)
                safe = 1;
            else
                safe = 0;
                break
            end
        end
        if (safe==1)
            tobedeleted(end+1,1) = i;
        end
        result2 = result2+safe;
    end
    tobedeleted = tobedeleted(2:end,1);
    unsafe_reports(tobedeleted,:) = [];
end

fprintf('%10f',result2)
fprintf('\n')
toc

