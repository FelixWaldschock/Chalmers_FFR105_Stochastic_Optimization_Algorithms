%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Ant system (AS) for TSP.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cityLocation = LoadCityLocations();
numberOfCities = length(cityLocation);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numberOfAnts = 50;  %% Changes allowed
alpha = 1.0;        %% Changes allowed
beta = 6.0;         %% Changes allowed
rho = 0.5;          %% Changes allowed
tau0 = 0.1;         %% Changes allowed

targetPathLength = 99.9999999;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% To do: Add plot initialization
range = [0 20 0 20];
tspFigure = InitializeTspPlot(cityLocation, range);
connection = InitializeConnections(cityLocation);
pheromoneLevel = InitializePheromoneLevels(numberOfCities, tau0); % To do: Write the InitializePheromoneLevels
visibility = GetVisibility(cityLocation);                         % To do: write the GetVisibility function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minimumPathLength = inf;

iIteration = 0;
pathCollection = zeros(numberOfAnts, numberOfCities);
pathLengthCollection = zeros(numberOfAnts,1);
improvements = 0;
while (minimumPathLength > targetPathLength)
  iIteration = iIteration + 1;

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%
  % Generate paths:
  %%%%%%%%%%%%%%%%%%%%%%%%%%
  
  for k = 1:numberOfAnts
    path = GeneratePath(pheromoneLevel, visibility, alpha, beta);   % Done: Write the GeneratePath function
    pathLength = GetPathLength(path,cityLocation);                  % Done: Write the GetPathLength function
    if (pathLength < minimumPathLength)
      minimumPathLength = pathLength;
      disp(sprintf('Iteration %d, ant %d: path length = %.5f',iIteration,k,minimumPathLength));
      PlotPath(connection,cityLocation,path);

        % Specify the filename (e.g., 'myIntegerVector.m')
        filename = 'BestResultFound_new.m';
        
        % Open the file for writing
        fileID = fopen(filename, 'w');
        
        % Write the integer vector to the file
        fprintf(fileID, "[");
        fprintf(fileID, '%d ', path);
        fprintf(fileID, "]");
        
        % Close the file
        fclose(fileID);

        % -> adjust the file manually to get format asked for!!!


    end
    pathCollection(k,:) = path;
    pathLengthCollection(k) = pathLength;
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%
  % Update pheromone levels
  %%%%%%%%%%%%%%%%%%%%%%%%%%
  
  deltaPheromoneLevel = ComputeDeltaPheromoneLevels(pathCollection,pathLengthCollection);  % Done: write the ComputeDeltaPheromoneLevels function
  pheromoneLevel = UpdatePheromoneLevels(pheromoneLevel,deltaPheromoneLevel,rho);          % Done: write the UpdatePheromoneLevels function
 
end







