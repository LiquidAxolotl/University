clc

% Length of warehouse.
L = 20;
% Width of warehouse.
W = 20;

% Predefine warehouse
warehouse = zeros(L, W);
% warehouse = input("Enter the matrix. ")

% Generate the warehouse. A 0 is the outside of the warehouse.
for i = 1:L
    for j = 1:W
        % This function actually creates the shape.
        if abs(i-floor(L/2))^2 + abs(j-floor(W/2))^2 >=8^2
            warehouse(i,j) = 1;
        else
            continue
        end
    end
end

% Save the initial state of the warehouse before pallets are added.
wareini = warehouse;

% Display the warehouse without pallets.
figure(1)
imshow(warehouse, 'InitialMagnification', 'fit')

% Define variables related to the widest point of the warehouse.
leftbound = [1,1];
rightbound = [1,1];
leftboundtent = [1,1];
rightboundtent = [1,1];
maxwidth = 0;
halt = 0;
widestrow = zeros(1,W);

% Find the widest point of the warehouse.
for i = 1:L
    for j = 1:W
        if warehouse(i,j)~=0
            
            if j-1 == 0 || warehouse(i,j-1) == 0
                % Tentitive left bound of the widest point.
                leftboundtent = [i, j];
            end
            
            if j+1 >W || warehouse(i,j+1) == 0
                % Tentitive right bound of the widest point.
                rightboundtent = [i, j];
            end
            
            % Check if we've found the widest point of the warehouse.
            %    If we have, then lock it in.
            for k = leftboundtent(2):rightboundtent(2)
                if warehouse(i,k) == 1
                    halt = 1;
                    widestrow(1,k) = warehouse(i,k);
                elseif warehouse(i,k) == 0
                    halt = 0;
                    break
                end
            end
            % Check if the tentitive bounds are valid and the furthest
            %     apart.
            if rightboundtent(2) - leftboundtent(2) >= maxwidth && halt == 1
                leftbound = leftboundtent;
                rightbound = rightboundtent;
                maxwidth = rightbound(2) - leftbound(2);
            end
        end
    end
end

% Generate pallets. A 1 signifies a pallet.
for i = 1:L
    
    for j = 1:W
        
        % Check if we are outside the bounds of the warehouse.
        if warehouse(i, j) == 0
            continue
        elseif i==leftbound(1)
            continue
        elseif warehouse(i, j) == 1
            if mod(j, 2) == 0
                warehouse(i, j) = 0.5;
            end
        end
        
    end
end

warehouse;

% Display the warehouse with pallets.
figure(2)
imshow(warehouse, 'InitialMagnification', 'fit')

% Calculate how many pallets there are and other things.

% Calculate how many pallets there are.
numpall = sum(warehouse(:) == 0.5);

% Calcluate how many pallets there could be.
maxnumpall = sum(wareini(:) == 1);

% Calculate how much space is just aisle.
numaisle = sum(warehouse(:) == 1);

% Calculate the efficiency.
efficiency = (numpall/maxnumpall);