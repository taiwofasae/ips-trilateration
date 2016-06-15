function result = least_squares_method(measured_data, validator_matrix)
% measured_data 1-by-4
% validator_matrix 1-by-4
measured_data(measured_data >= 1000) = NaN;
measured_data(measured_data < 0) = NaN;

% 4-by-2 beacons matrix
M = [0 200;0 0; 200 0; 200 200];
% 4-by-1
R = transpose(measured_data);

% sort to get shortest distances
to_sort_data = [measured_data; 1:4];
sorted_data = sortrows(transpose(to_sort_data));
sort_index = sorted_data(:,2);

validator_matrix = and(~isnan(measured_data),validator_matrix);
N = sum(validator_matrix);
if(N < 3)
    result = [NaN NaN];
    return
end

% apply sort index to matrices
M = M(sort_index,:);
R = R(sort_index,:);
validator_matrix = validator_matrix(:,sort_index);

% apply validator matrix to remove unwanted
M = M(validator_matrix(:),:);
R = R(validator_matrix(:),:);

% trim matrix down to 3 rows based on 3 measurements
M = M(1:3,:);
R = R(1:3,:);
N = 3;

%N = sum(validator_matrix);

% N-by-2
Dfirst = M(1,:);
% (N-1)-by-2
D1 = M(2:N,:);

% (N-1)-by-2
D2 = repmat(Dfirst,[N-1, 1]);

% N-by-1
Rfirst = R(1,:);
% (N-1)-by-1
R1 = R(2:N,:);

% (N-1)-by-1
R2 = repmat(Rfirst,[N-1, 1]);
% (N-1)-by-1
dR = R1 - R2;

% (N-1)-by-3
A = 2.*[(D1-D2),dR];

% (N-1)-by-1
B = sum((D1.^2 - D2.^2), 2) - dR.^2;

% 3-by-1
X = A\B;
%X = inv(transpose(A)*A) * transpose(A) * B;
result = [X(1),X(2)];