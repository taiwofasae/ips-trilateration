function rmse = grid_rmse(data, actual)
% data: mesurement data 20-by-20-by-20-by-2
% actual: actual data 20-by-20-by-20-by-2
% rmse: root-mean-squared-error of data 20-by-20-by-1

error = actual - data;
squared_error = error.^2;
squared_error_hash = sum(squared_error, 4);
rmse = mean(squared_error_hash, 3, 'omitnan').^0.5;