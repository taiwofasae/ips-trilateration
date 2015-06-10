function data = get_actual_grid_data()
% data: return actual beacon data 20-by-20-by-20-by-2

% initially 20-by-20-by-2
data = zeros(20,20,2);
for r=1:20
    for c=1:20
        x = r - 0.5;
        y = c - 0.5;
        data(r,c,:) = [x,y]*10;
    end
end

% repeat data along 4th dimension 20-by-20-by-2-by-20
data = repmat(data, [1,1,1,20]);

% transpose to 20-by-20-by-20-by-2
data = permute(data, [1,2,4,3]);