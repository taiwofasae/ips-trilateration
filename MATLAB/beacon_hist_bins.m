function bins = beacon_hist_bins(data, actual, b_n)
% data: mesurement data 20-by-20-by-20-by-4
% actual: actual data 20-by-20-by-20-by-4
% b_n: beacon number A=1,B=2,C=3,D=4
% bins: returns a hist data of actual vs observed x-by-2
obs = data(:,:,:,b_n);
act = actual(:,:,:,b_n);

% Generate bins
act = round(act./20) * 20;

bins = [act(:),obs(:)];
valid_indices = and(obs(:) < 1000, obs(:) > 0);
bins = bins(valid_indices, :);
