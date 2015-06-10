function data = get_actual_beacon_data()
% data: return actual beacon data 10-by-10-by-20-by-4
data = zeros(10,10,4);
for r=1:10
    for c=1:10
        x = c - 0.5;
        y = r - 0.5;
        sub_x = 10 - x;
        sub_y = 10 - y;
        A = sqrt(x.^2 + sub_y.^2);
        B = sqrt(sub_x.^2 + sub_y.^2);
        C = sqrt(sub_x.^2 + y.^2);
        D = sqrt(x.^2 + y.^2);
        data(r,c,:) = [A, B, C, D];
    end
end

% 10-by-10-by-4-by-20
% repeat data along 4th dimension
data = repmat(data, [1,1,1,20]);

% transform to 10-by-10-by-20-by-4
data = permute(data, [1,2,4,3]);