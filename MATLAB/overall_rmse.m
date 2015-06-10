function rmse = overall_rmse(data, actual)
% data: mesurement data 10-by-10-by-20-by-2
% actual: actual data 10-by-10-by-20-by-2
% rmse: root-mean-squared-error of data 10-by-10-by-1

error = actual - data;
squared_error = error.^2;
squared_error_hash = sum(squared_error, 4, 'omitnan');
rmse = mean(squared_error_hash(:),'omitnan').^0.5;