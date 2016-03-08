function result = minimum_mse_method(measured_data)

measured_data(measured_data >= 1000) = NaN;
measured_data(measured_data < 0) = NaN;

% data in 20-by-20-by-20-by-4
actual = get_actual_beacon_data();
% transform to 20-by-20-by-4
actual = permute(actual(:,:,1,:), [1, 2, 4, 3]);

% repeat 1-by-4 data to 4-by-20-by-20
measured = repmat(measured_data(:), [1, 20, 20]);
% transpose to 20-by-20-by-4
measured = permute(measured, [2, 3, 1]);

error = actual - measured;
squaredError = error.^2;
rmse = mean(squaredError, 3, 'omitnan').^0.5;

[Mx,R] = min(min(rmse,[], 2, 'omitnan'),[], 'omitnan');
[My,C] = min(min(rmse, [], 'omitnan'), [], 'omitnan');
if(isnan(Mx))
    R = NaN;
end
if(isnan(My))
    C = NaN;
end
if Mx ~= My
    if(and(~isnan(Mx),~isnan(My)))
        disp('error here. Minimums along the two dimensions do not match');
    end
end
if and(R == 20,C == 14)
    disp([])
end
result = [R-0.5,C-0.5]*10;