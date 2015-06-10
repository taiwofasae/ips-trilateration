function bins = overall_hist_bins(data, actual)
% data: mesurement data 10-by-10-by-20-by-4
% actual: actual data 10-by-10-by-20-by-4
% bins: returns a hist data of actual vs observed 2-by-x
bins = [actual,data];
valid_indices = data(:) >= 1000;
bins = bins(valid_indices, :);
