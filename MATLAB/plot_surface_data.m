function plot_surface_data(handle, data)
% data: to be plotted data 10-by-10
% surf_data: result of transformed data 10-by-10
[X,Y] = meshgrid(0:10,0:10);

data = [data; data(10,:)];
data = [data, data(:,10)];

surf(handle, X,Y,data);
view(handle, [0 90]);

