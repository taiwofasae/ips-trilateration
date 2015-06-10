function data = get_actual_grid_data()
% data: return actual beacon data 10-by-10-by-20-by-2

% initially 10-by-10-by-2
data = zeros(10,10,2);
for r=1:10
    for c=1:10
        x = c - 0.5;
        y = r - 0.5;
        data(r,c,:) = [x,y];
    end
end

% repeat data along 4th dimension 10-by-10-by-2-by-20
data = repmat(data, [1,1,1,20]);

% transpose to 10-by-10-by-20-by-2
data = permute(data, [1,2,4,3]);