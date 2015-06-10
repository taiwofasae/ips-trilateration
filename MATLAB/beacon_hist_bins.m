function bins = beacon_hist_bins(data, actual, b_n)
% data: mesurement data 10-by-10-by-20-by-4
% actual: actual data 10-by-10-by-20-by-4
% b_n: beacon number A=1,B=2,C=3,D=4
% bins: returns a hist data of actual vs observed 2-by-x
obs = data(:,:,:,b_n);
act = actual(:,:,:,b_n);
bins = [act(:),obs(:)];
valid_indices = obs(:) >= 1000;
bins = bins(valid_indices, :);
