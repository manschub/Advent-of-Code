clc; clear all;
% Advent of code 2023 - day 7 - part 1+2

% Open file and take needed data
file_id = fopen("day7.dat");
data = textscan(file_id,'%s %f','delimiter',' ','MultipleDelimsAsOne',1);
% Close file
fclose(file_id);

% Seperate data
hands = data{1,1};
for i = 1:length(hands)
    cards(i,1) = hands{i,1}(1);
    cards(i,2) = hands{i,1}(2);
    cards(i,3) = hands{i,1}(3);
    cards(i,4) = hands{i,1}(4);
    cards(i,5) = hands{i,1}(5);
end
bids = data{1,2};

% Part we want to solve
part = 2;
if (part == 1)
    % Sort hands by strength
    % First do a pre-filtering
    j=1; k=1; l=1; m=1; n=1; o=1; p=1;
    for i = 1:length(hands)
        sum_tmp = 0;
        % 5 different cards must be high cards
        if(length(unique(cards(i,:))) == 5)
            high_card(j,:) = cards(i,:);
            if (j==1)
                index_hc(1) = i;
            else
                index_hc(end+1) = i;
            end
            j = j+1;
        % 4 different cards must be one pair
        elseif(length(unique(cards(i,:))) == 4)
            one_pair(k,:) = cards(i,:);
            if (k==1)
                index_op(1) = i;
            else
                index_op(end+1) = i;
            end
            k = k+1;
        % 3 different cards can be two pair or three of a kind
        elseif(length(unique(cards(i,:))) == 3)
            for ii=1:5
                sum_tmp = sum_tmp+sum(cards(i,:)==cards(i,ii));
            end
            % Three of a kind if sum = 11
            if (sum_tmp == 11)
                three_of_a_kind(l,:) = cards(i,:);
                if (l==1)
                    index_toak(1) = i;
                else
                    index_toak(end+1) = i;
                end
                l = l+1;
            % Otherwise (sum = 9) we have two pairs
            else
                two_pair(m,:) = cards(i,:);
                if (m==1)
                    index_tp(1) = i;
                else
                    index_tp(end+1) = i;
                end
                m = m+1;
            end
        % 2 different cards can be full house or four of a kind
        elseif(length(unique(cards(i,:))) == 2)
            for ii=1:5
                sum_tmp = sum_tmp+sum(cards(i,:)==cards(i,ii));
            end
            % Four of a kind if sum = 17
            if (sum_tmp == 17)
                four_of_a_kind(n,:) = cards(i,:);
                if (n==1)
                    index_foak(1) = i;
                else
                    index_foak(end+1) = i;
                end
                n = n+1;
            % Otherwise (sum = 13) we have full house
            else
                full_house(o,:) = cards(i,:);
                if (o==1)
                    index_fh(1) = i;
                else
                    index_fh(end+1) = i;
                end
                o = o+1;
            end
        % Otherwise all cards are the same - 5 of a kind
        elseif(length(unique(cards(i,:))) == 1)
            five_of_a_kind(p,:) = cards(i,:);
            if (p==1)
                index_fiveoak(1) = i;
            else
                index_fiveoak(end+1) = i;
            end
            p = p+1;
        end
    end
    % Now we have to sort in each category
    % Five of a kind
    five_of_a_kind_ordered = five_of_a_kind;
    index_fiveoak_ordered = index_fiveoak; 
    for i = 2:length(index_fiveoak)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(five_of_a_kind_ordered(k,ii)~=five_of_a_kind_ordered(i,ii))
                    % Cases
                    if(five_of_a_kind_ordered(k,ii) == 'A')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == 'A')
                    elseif(five_of_a_kind_ordered(k,ii) == 'K')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == 'K')
                    elseif(five_of_a_kind_ordered(k,ii) == 'Q')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == 'Q')
                    elseif(five_of_a_kind_ordered(k,ii) == 'J')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == 'J')
                    elseif(five_of_a_kind_ordered(k,ii) == 'T')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == 'T')
                    elseif(five_of_a_kind_ordered(k,ii) == '9')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '9')
                    elseif(five_of_a_kind_ordered(k,ii) == '8')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '8')
                    elseif(five_of_a_kind_ordered(k,ii) == '7')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '7')
                    elseif(five_of_a_kind_ordered(k,ii) == '6')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '6')
                    elseif(five_of_a_kind_ordered(k,ii) == '5')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '5')
                    elseif(five_of_a_kind_ordered(k,ii) == '4')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '4')
                    elseif(five_of_a_kind_ordered(k,ii) == '3')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '3')
                    end
                    break
                else
                end
            end
        end
    end
    % Four of a kind
    four_of_a_kind_ordered = four_of_a_kind;
    index_foak_ordered = index_foak; 
    for i = 2:length(index_foak)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(four_of_a_kind_ordered(k,ii)~=four_of_a_kind_ordered(i,ii))
                    % Cases
                    if(four_of_a_kind_ordered(k,ii) == 'A')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == 'A')
                    elseif(four_of_a_kind_ordered(k,ii) == 'K')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == 'K')
                    elseif(four_of_a_kind_ordered(k,ii) == 'Q')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == 'Q')
                    elseif(four_of_a_kind_ordered(k,ii) == 'J')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == 'J')
                    elseif(four_of_a_kind_ordered(k,ii) == 'T')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == 'T')
                    elseif(four_of_a_kind_ordered(k,ii) == '9')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '9')
                    elseif(four_of_a_kind_ordered(k,ii) == '8')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '8')
                    elseif(four_of_a_kind_ordered(k,ii) == '7')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '7')
                    elseif(four_of_a_kind_ordered(k,ii) == '6')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '6')
                    elseif(four_of_a_kind_ordered(k,ii) == '5')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '5')
                    elseif(four_of_a_kind_ordered(k,ii) == '4')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '4')
                    elseif(four_of_a_kind_ordered(k,ii) == '3')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '3')
                    end
                    break
                else
                end
            end
        end
    end
    % Three of a kind
    three_of_a_kind_ordered = three_of_a_kind;
    index_toak_ordered = index_toak; 
    for i = 2:length(index_toak)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(three_of_a_kind_ordered(k,ii)~=three_of_a_kind_ordered(i,ii))
                    % Cases
                    if(three_of_a_kind_ordered(k,ii) == 'A')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == 'A')
                    elseif(three_of_a_kind_ordered(k,ii) == 'K')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == 'K')
                    elseif(three_of_a_kind_ordered(k,ii) == 'Q')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == 'Q')
                    elseif(three_of_a_kind_ordered(k,ii) == 'J')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == 'J')
                    elseif(three_of_a_kind_ordered(k,ii) == 'T')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == 'T')
                    elseif(three_of_a_kind_ordered(k,ii) == '9')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '9')
                    elseif(three_of_a_kind_ordered(k,ii) == '8')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '8')
                    elseif(three_of_a_kind_ordered(k,ii) == '7')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '7')
                    elseif(three_of_a_kind_ordered(k,ii) == '6')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '6')
                    elseif(three_of_a_kind_ordered(k,ii) == '5')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '5')
                    elseif(three_of_a_kind_ordered(k,ii) == '4')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '4')
                    elseif(three_of_a_kind_ordered(k,ii) == '3')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '3')
                    end
                    break
                else
                end
            end
        end
    end
    % Full house
    full_house_ordered = full_house;
    index_fh_ordered = index_fh; 
    for i = 2:length(index_fh)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(full_house_ordered(k,ii)~=full_house_ordered(i,ii))
                    % Cases
                    if(full_house_ordered(k,ii) == 'A')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == 'A')
                    elseif(full_house_ordered(k,ii) == 'K')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == 'K')
                    elseif(full_house_ordered(k,ii) == 'Q')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == 'Q')
                    elseif(full_house_ordered(k,ii) == 'J')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == 'J')
                    elseif(full_house_ordered(k,ii) == 'T')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == 'T')
                    elseif(full_house_ordered(k,ii) == '9')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '9')
                    elseif(full_house_ordered(k,ii) == '8')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '8')
                    elseif(full_house_ordered(k,ii) == '7')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '7')
                    elseif(full_house_ordered(k,ii) == '6')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '6')
                    elseif(full_house_ordered(k,ii) == '5')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '5')
                    elseif(full_house_ordered(k,ii) == '4')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '4')
                    elseif(full_house_ordered(k,ii) == '3')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '3')
                    end
                    break
                else
                end
            end
        end
    end
    % Two pair
    two_pair_ordered = two_pair;
    index_tp_ordered = index_tp; 
    for i = 2:length(index_tp)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(two_pair_ordered(k,ii)~=two_pair_ordered(i,ii))
                    % Cases
                    if(two_pair_ordered(k,ii) == 'A')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == 'A')
                    elseif(two_pair_ordered(k,ii) == 'K')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == 'K')
                    elseif(two_pair_ordered(k,ii) == 'Q')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == 'Q')
                    elseif(two_pair_ordered(k,ii) == 'J')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == 'J')
                    elseif(two_pair_ordered(k,ii) == 'T')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == 'T')
                    elseif(two_pair_ordered(k,ii) == '9')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '9')
                    elseif(two_pair_ordered(k,ii) == '8')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '8')
                    elseif(two_pair_ordered(k,ii) == '7')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '7')
                    elseif(two_pair_ordered(k,ii) == '6')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '6')
                    elseif(two_pair_ordered(k,ii) == '5')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '5')
                    elseif(two_pair_ordered(k,ii) == '4')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '4')
                    elseif(two_pair_ordered(k,ii) == '3')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '3')
                    end
                    break
                else
                end
            end
        end
    end
    % One pair
    one_pair_ordered = one_pair;
    index_op_ordered = index_op; 
    for i = 2:length(index_op)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(one_pair_ordered(k,ii)~=one_pair_ordered(i,ii))
                    % Cases
                    if(one_pair_ordered(k,ii) == 'A')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == 'A')
                    elseif(one_pair_ordered(k,ii) == 'K')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == 'K')
                    elseif(one_pair_ordered(k,ii) == 'Q')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == 'Q')
                    elseif(one_pair_ordered(k,ii) == 'J')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == 'J')
                    elseif(one_pair_ordered(k,ii) == 'T')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == 'T')
                    elseif(one_pair_ordered(k,ii) == '9')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '9')
                    elseif(one_pair_ordered(k,ii) == '8')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '8')
                    elseif(one_pair_ordered(k,ii) == '7')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '7')
                    elseif(one_pair_ordered(k,ii) == '6')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '6')
                    elseif(one_pair_ordered(k,ii) == '5')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '5')
                    elseif(one_pair_ordered(k,ii) == '4')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '4')
                    elseif(one_pair_ordered(k,ii) == '3')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '3')
                    end
                    break
                else
                end
            end
        end
    end
    % High card
    high_card_ordered = high_card;
    index_hc_ordered = index_hc; 
    for i = 2:length(index_hc)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(high_card_ordered(k,ii)~=high_card_ordered(i,ii))
                    % Cases
                    if(high_card_ordered(k,ii) == 'A')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == 'A')
                    elseif(high_card_ordered(k,ii) == 'K')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == 'K')
                    elseif(high_card_ordered(k,ii) == 'Q')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == 'Q')
                    elseif(high_card_ordered(k,ii) == 'J')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == 'J')
                    elseif(high_card_ordered(k,ii) == 'T')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == 'T')
                    elseif(high_card_ordered(k,ii) == '9')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '9')
                    elseif(high_card_ordered(k,ii) == '8')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '8')
                    elseif(high_card_ordered(k,ii) == '7')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '7')
                    elseif(high_card_ordered(k,ii) == '6')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '6')
                    elseif(high_card_ordered(k,ii) == '5')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '5')
                    elseif(high_card_ordered(k,ii) == '4')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '4')
                    elseif(high_card_ordered(k,ii) == '3')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '3')
                    end
                    break
                else
                end
            end
        end
    end
    
    % Now sum the winnings
    winning_sum = 0;
    winning_sum = bids(index_fiveoak_ordered(1))*1000;
    for i=length(index_foak):-1:1
        winning_sum = winning_sum + bids(index_foak_ordered(i))* ...
            (i+1000-length(index_foak)-length(index_fiveoak));
    end
    for i=length(index_fh):-1:1
        winning_sum = winning_sum + bids(index_fh_ordered(i))* ...
            (i+1000-length(index_fh)-length(index_foak)- ...
            length(index_fiveoak));
    end
    for i=length(index_toak):-1:1
        winning_sum = winning_sum + bids(index_toak_ordered(i))* ...
            (i+1000-length(index_fh)-length(index_foak)- ...
            length(index_fiveoak)-length(index_toak));
    end
    for i=length(index_tp):-1:1
        winning_sum = winning_sum + bids(index_tp_ordered(i))* ...
            (i+1000-length(index_fh)-length(index_foak)- ...
            length(index_fiveoak)-length(index_toak)-length(index_tp));
    end
    for i=length(index_op):-1:1
        winning_sum = winning_sum + bids(index_op_ordered(i))* ...
            (i+1000-length(index_fh)-length(index_foak)- ...
            length(index_fiveoak)-length(index_toak)-length(index_tp) ...
            -length(index_op));
    end
    for i=length(index_hc):-1:1
        winning_sum = winning_sum + bids(index_hc_ordered(i))* ...
            (i+1000-length(index_fh)-length(index_foak)- ...
            length(index_fiveoak)-length(index_toak)-length(index_tp) ...
            -length(index_op)-length(index_hc));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Part 2 - We need to account for jokers
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif (part == 2)
    % Sort hands by strength
    % First do a pre-filtering
    j=1; k=1; l=1; m=1; n=1; o=1; p=1;
    for i = 1:length(hands)
        % Number of jokers
        n_jokers = sum(cards(i,:) == 'J');
        sum_tmp = 0;
        % 5 different cards must be high cards
        if(length(unique(cards(i,:))) == 5)
            if(n_jokers == 0)
                high_card(j,:) = cards(i,:);
                if (j==1)
                    index_hc(1) = i;
                else
                    index_hc(end+1) = i;
                end
                j = j+1;
            elseif(n_jokers == 1)
                % We get one pair with the joker
                one_pair(k,:) = cards(i,:);
                if (k==1)
                    index_op(1) = i;
                else
                    index_op(end+1) = i;
                end
                k = k+1;
            end 
        % 4 different cards must be one pair
        elseif(length(unique(cards(i,:))) == 4)
            if (n_jokers == 0)
                one_pair(k,:) = cards(i,:);
                if (k==1)
                    index_op(1) = i;
                else
                    index_op(end+1) = i;
                end
                k = k+1;
            elseif (n_jokers == 1 || n_jokers == 2)
                % We get three of a kind with the joker
                three_of_a_kind(l,:) = cards(i,:);
                if (l==1)
                    index_toak(1) = i;
                else
                    index_toak(end+1) = i;
                end
                l = l+1;
            end 
        % 3 different cards can be two pair or three of a kind
        elseif(length(unique(cards(i,:))) == 3)
            for ii=1:5
                sum_tmp = sum_tmp+sum(cards(i,:)==cards(i,ii));
            end
            % Three of a kind if sum = 11
            if (sum_tmp == 11)
                if (n_jokers == 0)
                    three_of_a_kind(l,:) = cards(i,:);
                    if (l==1)
                        index_toak(1) = i;
                    else
                        index_toak(end+1) = i;
                    end
                    l = l+1;
                elseif (n_jokers == 1 || n_jokers == 3)
                    % We get four of a kind with 1 or 3 jokers
                    four_of_a_kind(n,:) = cards(i,:);
                    if (n==1)
                        index_foak(1) = i;
                    else
                        index_foak(end+1) = i;
                    end
                    n = n+1;
                end
            % Otherwise (sum = 9) we have two pairs
            else
                if (n_jokers == 0)
                    two_pair(m,:) = cards(i,:);
                    if (m==1)
                        index_tp(1) = i;
                    else
                        index_tp(end+1) = i;
                    end
                    m = m+1;
                elseif (n_jokers == 1)
                    % We get a full house with the joker
                    full_house(o,:) = cards(i,:);
                    if (o==1)
                        index_fh(1) = i;
                    else
                        index_fh(end+1) = i;
                    end
                    o = o+1;
                elseif (n_jokers == 2)
                    % We get four of a kind with the 2 jokers
                    four_of_a_kind(n,:) = cards(i,:);
                    if (n==1)
                        index_foak(1) = i;
                    else
                        index_foak(end+1) = i;
                    end
                    n = n+1;
                elseif (n_jokers == 3)
                    % We get five of a kind with the 3 jokers
                    five_of_a_kind(p,:) = cards(i,:);
                    if (p==1)
                        index_fiveoak(1) = i;
                    else
                        index_fiveoak(end+1) = i;
                    end
                    p = p+1;
                end
            end
        % 2 different cards can be full house or four of a kind
        elseif(length(unique(cards(i,:))) == 2)
            for ii=1:5
                sum_tmp = sum_tmp+sum(cards(i,:)==cards(i,ii));
            end
            % Four of a kind if sum = 17
            if (sum_tmp == 17)
                if (n_jokers == 0)
                    four_of_a_kind(n,:) = cards(i,:);
                    if (n==1)
                        index_foak(1) = i;
                    else
                        index_foak(end+1) = i;
                    end
                    n = n+1;
                elseif (n_jokers == 1 || 4)
                    % We get five of a kind with either 1 or 4 jokers
                    five_of_a_kind(p,:) = cards(i,:);
                    if (p==1)
                        index_fiveoak(1) = i;
                    else
                        index_fiveoak(end+1) = i;
                    end
                    p = p+1;
                end
            % Otherwise (sum = 13) we have full house
            else
                if (n_jokers == 0)
                    full_house(o,:) = cards(i,:);
                    if (o==1)
                        index_fh(1) = i;
                    else
                        index_fh(end+1) = i;
                    end
                    o = o+1;
                elseif (n_jokers == 2 || n_jokers == 3)
                    % We get five of a kind with either 2 or 3 jokers
                    five_of_a_kind(p,:) = cards(i,:);
                    if (p==1)
                        index_fiveoak(1) = i;
                    else
                        index_fiveoak(end+1) = i;
                    end
                    p = p+1;
                end
            end
        % Otherwise all cards are the same - 5 of a kind
        elseif(length(unique(cards(i,:))) == 1)
            five_of_a_kind(p,:) = cards(i,:);
            if (p==1)
                index_fiveoak(1) = i;
            else
                index_fiveoak(end+1) = i;
            end
            p = p+1;
        end
    end
    % Now we have to sort in each category (J are now weakest)
    % We also need to introduce an extra check if all characters are the
    % same J is treated as J again
    % Five of a kind
    five_of_a_kind_ordered = five_of_a_kind;
    index_fiveoak_ordered = index_fiveoak; 
    for i = 2:length(index_fiveoak)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(five_of_a_kind_ordered(k,ii)~=five_of_a_kind_ordered(i,ii))
                    % Cases
                    if(five_of_a_kind_ordered(k,ii) == 'A')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == 'A')
                    elseif(five_of_a_kind_ordered(k,ii) == 'K')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == 'K')
                    elseif(five_of_a_kind_ordered(k,ii) == 'Q')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == 'Q')
                    elseif(five_of_a_kind_ordered(k,ii) == 'T')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == 'T')
                    elseif(five_of_a_kind_ordered(k,ii) == '9')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '9')
                    elseif(five_of_a_kind_ordered(k,ii) == '8')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '8')
                    elseif(five_of_a_kind_ordered(k,ii) == '7')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '7')
                    elseif(five_of_a_kind_ordered(k,ii) == '6')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '6')
                    elseif(five_of_a_kind_ordered(k,ii) == '5')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '5')
                    elseif(five_of_a_kind_ordered(k,ii) == '4')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '4')
                    elseif(five_of_a_kind_ordered(k,ii) == '3')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '3')
                    elseif(five_of_a_kind_ordered(k,ii) == '2')
                        tmp = five_of_a_kind_ordered(i,:);
                        five_of_a_kind_ordered(i,:) = five_of_a_kind_ordered(k,:);
                        five_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_fiveoak_ordered(i);
                        index_fiveoak_ordered(i) = index_fiveoak_ordered(k);
                        index_fiveoak_ordered(k) = tmp;
                    elseif(five_of_a_kind_ordered(i,ii) == '2')
                    end
                    break
                else
                end
            end
        end
    end
    % Four of a kind
    four_of_a_kind_ordered = four_of_a_kind;
    index_foak_ordered = index_foak; 
    for i = 2:length(index_foak)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(four_of_a_kind_ordered(k,ii)~=four_of_a_kind_ordered(i,ii))
                    % Cases
                    if(four_of_a_kind_ordered(k,ii) == 'A')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == 'A')
                    elseif(four_of_a_kind_ordered(k,ii) == 'K')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == 'K')
                    elseif(four_of_a_kind_ordered(k,ii) == 'Q')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == 'Q')
                    elseif(four_of_a_kind_ordered(k,ii) == 'T')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == 'T')
                    elseif(four_of_a_kind_ordered(k,ii) == '9')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '9')
                    elseif(four_of_a_kind_ordered(k,ii) == '8')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '8')
                    elseif(four_of_a_kind_ordered(k,ii) == '7')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '7')
                    elseif(four_of_a_kind_ordered(k,ii) == '6')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '6')
                    elseif(four_of_a_kind_ordered(k,ii) == '5')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '5')
                    elseif(four_of_a_kind_ordered(k,ii) == '4')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '4')
                    elseif(four_of_a_kind_ordered(k,ii) == '3')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '3')
                    elseif(four_of_a_kind_ordered(k,ii) == '2')
                        tmp = four_of_a_kind_ordered(i,:);
                        four_of_a_kind_ordered(i,:) = four_of_a_kind_ordered(k,:);
                        four_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_foak_ordered(i);
                        index_foak_ordered(i) = index_foak_ordered(k);
                        index_foak_ordered(k) = tmp;
                    elseif(four_of_a_kind_ordered(i,ii) == '2')
                    end
                    break
                else
                end
            end
        end
    end
    % Three of a kind
    three_of_a_kind_ordered = three_of_a_kind;
    index_toak_ordered = index_toak; 
    for i = 2:length(index_toak)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(three_of_a_kind_ordered(k,ii)~=three_of_a_kind_ordered(i,ii))
                    % Cases
                    if(three_of_a_kind_ordered(k,ii) == 'A')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == 'A')
                    elseif(three_of_a_kind_ordered(k,ii) == 'K')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == 'K')
                    elseif(three_of_a_kind_ordered(k,ii) == 'Q')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == 'Q')
                    elseif(three_of_a_kind_ordered(k,ii) == 'T')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == 'T')
                    elseif(three_of_a_kind_ordered(k,ii) == '9')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '9')
                    elseif(three_of_a_kind_ordered(k,ii) == '8')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '8')
                    elseif(three_of_a_kind_ordered(k,ii) == '7')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '7')
                    elseif(three_of_a_kind_ordered(k,ii) == '6')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '6')
                    elseif(three_of_a_kind_ordered(k,ii) == '5')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '5')
                    elseif(three_of_a_kind_ordered(k,ii) == '4')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '4')
                    elseif(three_of_a_kind_ordered(k,ii) == '3')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '3')
                    elseif(three_of_a_kind_ordered(k,ii) == '2')
                        tmp = three_of_a_kind_ordered(i,:);
                        three_of_a_kind_ordered(i,:) = three_of_a_kind_ordered(k,:);
                        three_of_a_kind_ordered(k,:) = tmp;
                        tmp = index_toak_ordered(i);
                        index_toak_ordered(i) = index_toak_ordered(k);
                        index_toak_ordered(k) = tmp;
                    elseif(three_of_a_kind_ordered(i,ii) == '2')
                    end
                    break
                else
                end
            end
        end
    end
    % Full house
    full_house_ordered = full_house;
    index_fh_ordered = index_fh; 
    for i = 2:length(index_fh)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(full_house_ordered(k,ii)~=full_house_ordered(i,ii))
                    % Cases
                    if(full_house_ordered(k,ii) == 'A')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == 'A')
                    elseif(full_house_ordered(k,ii) == 'K')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == 'K')
                    elseif(full_house_ordered(k,ii) == 'Q')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == 'Q')
                    elseif(full_house_ordered(k,ii) == 'T')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == 'T')
                    elseif(full_house_ordered(k,ii) == '9')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '9')
                    elseif(full_house_ordered(k,ii) == '8')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '8')
                    elseif(full_house_ordered(k,ii) == '7')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '7')
                    elseif(full_house_ordered(k,ii) == '6')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '6')
                    elseif(full_house_ordered(k,ii) == '5')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '5')
                    elseif(full_house_ordered(k,ii) == '4')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '4')
                    elseif(full_house_ordered(k,ii) == '3')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '3')
                    elseif(full_house_ordered(k,ii) == '2')
                        tmp = full_house_ordered(i,:);
                        full_house_ordered(i,:) = full_house_ordered(k,:);
                        full_house_ordered(k,:) = tmp;
                        tmp = index_fh_ordered(i);
                        index_fh_ordered(i) = index_fh_ordered(k);
                        index_fh_ordered(k) = tmp;
                    elseif(full_house_ordered(i,ii) == '2')
                    end
                    break
                else
                end
            end
        end
    end
    % Two pair
    two_pair_ordered = two_pair;
    index_tp_ordered = index_tp; 
    for i = 2:length(index_tp)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(two_pair_ordered(k,ii)~=two_pair_ordered(i,ii))
                    % Cases
                    if(two_pair_ordered(k,ii) == 'A')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == 'A')
                    elseif(two_pair_ordered(k,ii) == 'K')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == 'K')
                    elseif(two_pair_ordered(k,ii) == 'Q')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == 'Q')
                    elseif(two_pair_ordered(k,ii) == 'T')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == 'T')
                    elseif(two_pair_ordered(k,ii) == '9')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '9')
                    elseif(two_pair_ordered(k,ii) == '8')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '8')
                    elseif(two_pair_ordered(k,ii) == '7')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '7')
                    elseif(two_pair_ordered(k,ii) == '6')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '6')
                    elseif(two_pair_ordered(k,ii) == '5')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '5')
                    elseif(two_pair_ordered(k,ii) == '4')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '4')
                    elseif(two_pair_ordered(k,ii) == '3')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '3')
                    elseif(two_pair_ordered(k,ii) == '2')
                        tmp = two_pair_ordered(i,:);
                        two_pair_ordered(i,:) = two_pair_ordered(k,:);
                        two_pair_ordered(k,:) = tmp;
                        tmp = index_tp_ordered(i);
                        index_tp_ordered(i) = index_tp_ordered(k);
                        index_tp_ordered(k) = tmp;
                    elseif(two_pair_ordered(i,ii) == '2')
                    end
                    break
                else
                end
            end
        end
    end
    % One pair
    one_pair_ordered = one_pair;
    index_op_ordered = index_op; 
    for i = 2:length(index_op)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                if(one_pair_ordered(k,ii)~=one_pair_ordered(i,ii))
                    % Cases
                    if(one_pair_ordered(k,ii) == 'A')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == 'A')
                    elseif(one_pair_ordered(k,ii) == 'K')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == 'K')
                    elseif(one_pair_ordered(k,ii) == 'Q')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == 'Q')
                    elseif(one_pair_ordered(k,ii) == 'T')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == 'T')
                    elseif(one_pair_ordered(k,ii) == '9')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '9')
                    elseif(one_pair_ordered(k,ii) == '8')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '8')
                    elseif(one_pair_ordered(k,ii) == '7')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '7')
                    elseif(one_pair_ordered(k,ii) == '6')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '6')
                    elseif(one_pair_ordered(k,ii) == '5')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '5')
                    elseif(one_pair_ordered(k,ii) == '4')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '4')
                    elseif(one_pair_ordered(k,ii) == '3')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '3')
                    elseif(one_pair_ordered(k,ii) == '2')
                        tmp = one_pair_ordered(i,:);
                        one_pair_ordered(i,:) = one_pair_ordered(k,:);
                        one_pair_ordered(k,:) = tmp;
                        tmp = index_op_ordered(i);
                        index_op_ordered(i) = index_op_ordered(k);
                        index_op_ordered(k) = tmp;
                    elseif(one_pair_ordered(i,ii) == '2')
                    end
                    break
                else
                end
            end
        end
    end
    % High card
    high_card_ordered = high_card;
    index_hc_ordered = index_hc; 
    for i = 2:length(index_hc)
        for k = 1:i
            if(k==i)
                continue
            end
            for ii = 1:5
                % Card by card check
                if(high_card_ordered(k,ii)~=high_card_ordered(i,ii))
                    % Cases
                    if(high_card_ordered(k,ii) == 'A')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == 'A')
                    elseif(high_card_ordered(k,ii) == 'K')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == 'K')
                    elseif(high_card_ordered(k,ii) == 'Q')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == 'Q')
                    elseif(high_card_ordered(k,ii) == 'T')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == 'T')
                    elseif(high_card_ordered(k,ii) == '9')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '9')
                    elseif(high_card_ordered(k,ii) == '8')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '8')
                    elseif(high_card_ordered(k,ii) == '7')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '7')
                    elseif(high_card_ordered(k,ii) == '6')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '6')
                    elseif(high_card_ordered(k,ii) == '5')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '5')
                    elseif(high_card_ordered(k,ii) == '4')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '4')
                    elseif(high_card_ordered(k,ii) == '3')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '3')
                    elseif(high_card_ordered(k,ii) == '2')
                        tmp = high_card_ordered(i,:);
                        high_card_ordered(i,:) = high_card_ordered(k,:);
                        high_card_ordered(k,:) = tmp;
                        tmp = index_hc_ordered(i);
                        index_hc_ordered(i) = index_hc_ordered(k);
                        index_hc_ordered(k) = tmp;
                    elseif(high_card_ordered(i,ii) == '2')
                    end
                    break
                else
                end
            end
        end
    end
    
    % Now sum the winnings
    winning_sum = 0;
    for i=length(index_fiveoak):-1:1
        winning_sum = winning_sum + bids(index_fiveoak_ordered(i))* ...
            (i+1000-length(index_fiveoak));
    end
    for i=length(index_foak):-1:1
        winning_sum = winning_sum + bids(index_foak_ordered(i))* ...
            (i+1000-length(index_foak)-length(index_fiveoak));
    end
    for i=length(index_fh):-1:1
        winning_sum = winning_sum + bids(index_fh_ordered(i))* ...
            (i+1000-length(index_fh)-length(index_foak)- ...
            length(index_fiveoak));
    end
    for i=length(index_toak):-1:1
        winning_sum = winning_sum + bids(index_toak_ordered(i))* ...
            (i+1000-length(index_fh)-length(index_foak)- ...
            length(index_fiveoak)-length(index_toak));
    end
    for i=length(index_tp):-1:1
        winning_sum = winning_sum + bids(index_tp_ordered(i))* ...
            (i+1000-length(index_fh)-length(index_foak)- ...
            length(index_fiveoak)-length(index_toak)-length(index_tp));
    end
    for i=length(index_op):-1:1
        winning_sum = winning_sum + bids(index_op_ordered(i))* ...
            (i+1000-length(index_fh)-length(index_foak)- ...
            length(index_fiveoak)-length(index_toak)-length(index_tp) ...
            -length(index_op));
    end
    for i=length(index_hc):-1:1
        winning_sum = winning_sum + bids(index_hc_ordered(i))* ...
            (i+1000-length(index_fh)-length(index_foak)- ...
            length(index_fiveoak)-length(index_toak)-length(index_tp) ...
            -length(index_op)-length(index_hc));
    end
end
