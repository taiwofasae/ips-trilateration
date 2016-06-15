function bins = overall_hist_bins(data, actual)
% data: mesurement data 20-by-20-by-20-by-4
% actual: actual data 20-by-20-by-20-by-4
% bins: returns a hist data of actual vs observed x-by-2

% Generate bins
act = round(actual./20) * 20;

bins = [act(:),data(:)];
valid_indices = and(data(:) < 1000, data(:) > 0);
bins = bins(valid_indices, :);
