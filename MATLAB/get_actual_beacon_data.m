function data = get_actual_beacon_data()
% data: return actual beacon data 20-by-20-by-20-by-4
data = zeros(20,20,4);
for r=1:20
    for c=1:20
        data(r,c,:) = get_beacon_data_by_rc(r,c);
    end
end

% 20-by-20-by-4-by-20
% repeat data along 4th dimension
data = repmat(data, [1,1,1,20]);

% transform to 20-by-20-by-20-by-4
data = permute(data, [1,2,4,3]);