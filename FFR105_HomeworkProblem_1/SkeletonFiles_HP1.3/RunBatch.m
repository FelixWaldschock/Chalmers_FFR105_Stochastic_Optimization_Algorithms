%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter specifications
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numberOfRuns = 100;                % Do NOT change   
populationSize = 100;              % Do NOT change
maximumVariableValue = 5;          % Do NOT change (x_i in [-a,a], where a = maximumVariableValue)
numberOfGenes = 50;                % Do NOT change
numberOfVariables = 2;		       % Do NOT change
numberOfGenerations = 300;         % Do NOT change
tournamentSize = 2;                % Do NOT change
tournamentProbability = 0.75;      % Do NOT change
crossoverProbability = 0.8;        % Do NOT change


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Batch runs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


mutationProbability = [0 0.005 0.01 0.02 0.05 0.1 0.15 0.2 0.3 0.5];
%mutationProbability = [0.02];
results = [];
resultsBestVariableValues = [];

for j = 1:size(mutationProbability,2)
    sprintf('Mutation rate = %0.5f', mutationProbability(j))
    maximumFitnessList002 = zeros(numberOfRuns,1);
    for i = 1:numberOfRuns 
     [maximumFitness, bestVariableValues]  = RunFunctionOptimization(populationSize, numberOfGenes, numberOfVariables, maximumVariableValue, tournamentSize, ...
                                           tournamentProbability, crossoverProbability, mutationProbability(j), numberOfGenerations);
     sprintf('Run: %d, Score: %0.10f', i, maximumFitness);
      maximumFitnessList002(i,1) = maximumFitness;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Summary of results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    average002 = mean(maximumFitnessList002);
    median002 = median(maximumFitnessList002);
    std002 = sqrt(var(maximumFitnessList002));
    sprintf('PMut = %0.3f: Median: %0.10f, Average: %0.10f, STD: %0.10f', mutationProbability(j), median002, average002, std002)

    % store results per iteration
    results = [results ;[mutationProbability(j), median002, average002, std002]];
    resultsBestVariableValues = [resultsBestVariableValues; [bestVariableValues]];
    
end