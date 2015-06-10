function download_hist_data(data)
% download hist data to date folder
actual = get_actual_beacon_data();
hist_A = beacon_hist_bins(data, actual, 1);
csvwrite(date + '\A_hist_data.csv', hist_A);

hist_B = beacon_hist_bins(data, actual, 2);
csvwrite(date + '\B_hist_data.csv', hist_B);

hist_C = beacon_hist_bins(data, actual, 3);
csvwrite(date + '\C_hist_data.csv', hist_C);

hist_D = beacon_hist_bins(data, actual, 4);
csvwrite(date + '\D_hist_data.csv', hist_D);

overall = overall_hist_bins(data, actual);
csvwrite(date + '\overall_hist_data.csv', overall);