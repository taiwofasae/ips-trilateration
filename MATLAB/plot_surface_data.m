function plot_surface_data(handle, data)
% data: to be plotted data 20-by-20
% surf_data: result of transformed data 20-by-20
[X,Y] = meshgrid(0:20,0:20);

data = [data; data(20,:)];
data = [data, data(:,20)];

axes(handle);
surf(Y,X,data);
view([0 90]);

