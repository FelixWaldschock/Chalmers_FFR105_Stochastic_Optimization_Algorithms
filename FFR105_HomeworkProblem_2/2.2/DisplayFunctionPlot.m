% Clear all variables and figures
close all
clear all
clc

% Define the function to evaluate (replace with your own function)
functionLog_value = @(x, y) log(0.01 + EvaluateFunctionF(x, y));
function_value = @(x, y) log(0.01 + EvaluateFunctionF(x, y));

% Define the range and step size for X and Y
xMin = -5;
xMax = 5;
stepSize = 0.01;

% Create a meshgrid for X and Y
[X, Y] = meshgrid(xMin:stepSize:xMax, xMin:stepSize:xMax);

% Initialize Z with zeros
Z = zeros(size(X));

% Evaluate the function for each point in the meshgrid
for i = 1:length(X)
    for j = 1:length(X)
        Z(i, j) = functionLog_value(X(i, j), Y(i, j));
    end
end

% found minima with PSO
x_data = [3, 3.5844, -2.8051, -3.7793];
y_data = [2, -1.8481, 3.1313, -3.2832];

% Create the contour plot
figure;
contour(X, Y, Z, 20); % You can adjust the number of contour levels (e.g., 20)
xlabel('X_1');
ylabel('X_2');
title("Contour plot of log(0.01 + f(x_1,x_2))");

% Add text annotations at the specified points
annotationFontSize = 12; % font size
for i = 1:length(x_data)
    x_annotation = x_data(i);
    y_annotation = y_data(i);
    text(x_annotation, y_annotation, sprintf('x_1 = %0.4f \n x_2 = %0.4f)', x_annotation, y_annotation), 'FontSize', annotationFontSize, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
end