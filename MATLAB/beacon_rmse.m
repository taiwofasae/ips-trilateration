function rmse = beacon_rmse(data, actual, b_n)
% data: mesurement data 20-by-20-by-20-by-4
% actual: actual data 20-by-20-by-20-by-4
% b_n: beacon number A=1,B=2,C=3,D=4
% rmse: root-mean-squared-error of data 20-by-20-by-1
obs = data(:,:,:,b_n);
error = actual(:,:,:,b_n) - obs;
squared_error = error.^2;
squared_error(obs >= 1000) = NaN;
squared_error(obs <= 0) = NaN;
rmse = mean(squared_error, 3, 'omitnan');
rmse = rmse.^0.5;