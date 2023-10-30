close all
clear all
clc

% parameters
lengthOfGenesPerInsruction = 4;
populationSize = 100;
mutationProbabilityScaler = 1;
cMax = 10e15;                    % alternative parameter if dividing by 0
TournamentProbablity = 0.8;
crossoverProbability = 0.5;
tournamentSize = 4;
minimalChromosomeLength = 20;  % where the chromosome will have 4 * lengthOfGenesPerInstruction as length
maximalChromosomeLength = 80;
diversityMinimum = 0.05;
diversityMaxmium = 0.05;
minimalMutationProbability = 0.1;
mutationProbabilityScalerTickers = [1 2 3 4 20];
mutationProbabilityScalerTresholds = [10 20 30 50];

% simulation parameters
errorThreshold = 0.01;

% arrays to save development of certain variables
developmentOfMutationProbability = [];
developmentOfDiversity = [];
developmentOfLinearity = [];

% register for LGP
% init constants                                       
setOfConstants = [1, -1];             % Book p. 76
lengthOfConstantsRegisters = length(setOfConstants);

% variable register
lengthOfVariableRegisters = 4;        % Book p. 76

% length of operands
lengthOfOperands = lengthOfVariableRegisters + lengthOfConstantsRegisters;

% init operators
setOfOperators = ["+", "-", "*", "/"];
lengthOfOperators = length(setOfOperators);

% load the function data
data = LoadFunctionData();
X_data = data(:,1);
Y_data = data(:,2);

% best individual found sofar
globalBestIndividualFitness = -inf;
globalBestIndividualChromsome = 0;
globalBestIndividualError = inf;
globalBestEvaluation = 0;
globalAverageFitnessTracker = [];
globalBestFitnessTracker = [];

% init a figure to keep track
fig = figure();

n = 0;

% init population
population = InitializePopulation(populationSize, minimalChromosomeLength, maximalChromosomeLength, lengthOfVariableRegisters, lengthOfOperands, lengthOfOperators, lengthOfGenesPerInsruction);

% fitnessTracker for the last 10 generations
fitnessTrackerLength = 50;
fitnessTracker = zeros(fitnessTrackerLength, 1);
sameFitnessCounter = 0;
lastBestFitness = 0;
generationIteration = 0;

% mutationrate for each generation
mutationProbability = mutationProbabilityScalerTickers(1);

if(0)
    % load best from last one
    bestOld = load('globalBestChromosome.mat');
    globalBestIndividualChromsome = bestOld.globalBestIndividualChromsome;
end

while globalBestIndividualError > errorThreshold
    
    estimations = zeros(populationSize, length(X_data));
    % decode the individuals
    for i = 1:size(estimations, 1)
        individual = population(i).Chromosome;
        for k = 1:size(estimations, 2)
            estimations(i,k) = DecodeChromosome(individual, lengthOfVariableRegisters, setOfConstants, setOfOperators, X_data(k), cMax);
        end
    end
    
    % evaluate all individuals errors
    individualErrors = zeros(populationSize,1);
    individualLinearPenaltyFactor = zeros(populationSize, 1);
    individualLinearCoefficient = zeros(populationSize, 1);
    for i = 1:populationSize
        individualErrors(i)  = EvaluateError(estimations(i,:), Y_data, X_data);
    end
    
    % evaluate all individuals fitness
    individualFitnesses = zeros(populationSize,1);
    for i = 1:populationSize
        individual = population(i).Chromosome;
        error = individualErrors(i);
        individualFitnesses(i) = EvaluateFitness(individual, error, maximalChromosomeLength, lengthOfGenesPerInsruction);
    end
    
    % find the individual with the best fitness value
    [maxFitness, maxIndex] = max(individualFitnesses);
    
    % update the globalAverageFitnessTracker
    globalAverageFitnessTracker = [globalAverageFitnessTracker mean(individualFitnesses)];
    globalBestFitnessTracker = [globalBestFitnessTracker maxFitness];
    
    % copy the best individual of the population
    bestIndividualOfCurrentPopulation = population(maxIndex).Chromosome;
    bestIndividualOfCurrentPopulationFitness = maxFitness;
    
    % update global best
    if (maxFitness > globalBestIndividualFitness)
        globalBestIndividualChromsome = population(maxIndex).Chromosome;
        globalBestIndividualFitness = bestIndividualOfCurrentPopulationFitness;
        globalBestIndividualError = individualErrors(maxIndex);
        globalBestEvaluation = estimations(maxIndex, :);
        % save the best chromosome:
        save('globalBestChromosome', "globalBestIndividualChromsome");
    end
    
    % create a new population
    newPopulation = population;
    
    % tournament select and crossover the new population
    for i = 1:2:(populationSize)
        index1 = TournamentSelect(individualFitnesses, TournamentProbablity, tournamentSize);
        index2 = TournamentSelect(individualFitnesses, TournamentProbablity, tournamentSize);
        individual1 = newPopulation(index1).Chromosome;
        individual2 = newPopulation(index2).Chromosome;
        
        % crossover the individuals
        [individual1new, individual2new] = twoPointCrossover(individual1, individual2, lengthOfGenesPerInsruction, crossoverProbability);
        newPopulation(i).Chromosome = individual1new;
        newPopulation(i+1).Chromosome = individual2new;
        
    end
    
    % activate fitness tracker -> varies the mutation rate
    if (bestIndividualOfCurrentPopulationFitness ~= lastBestFitness)
        sameFitnessCounter = 0;
        mutationProbabilityScaler = mutationProbabilityScalerTickers(1);
    end
    
    if (bestIndividualOfCurrentPopulationFitness == lastBestFitness)
        sameFitnessCounter = sameFitnessCounter + 1;
    end
    
    if (sameFitnessCounter > mutationProbabilityScalerTresholds(1))
        mutationProbabilityScaler = mutationProbabilityScalerTickers(2);
    end
    if (sameFitnessCounter > mutationProbabilityScalerTresholds(2))
        mutationProbabilityScaler = mutationProbabilityScalerTickers(3);
    end
    if (sameFitnessCounter > mutationProbabilityScalerTresholds(3))
        mutationProbabilityScaler = mutationProbabilityScalerTickers(4);
    end
    if (sameFitnessCounter > mutationProbabilityScalerTresholds(4))
        mutationProbabilityScaler = mutationProbabilityScalerTickers(5);
    end
    
    lastBestFitness = bestIndividualOfCurrentPopulationFitness;
    
    % mutate the new population
    for i = 1:populationSize
        individual = newPopulation(i).Chromosome;
        individual = Mutate(individual, mutationProbabilityScaler, lengthOfVariableRegisters, lengthOfOperands, lengthOfOperators, lengthOfGenesPerInsruction);
        newPopulation(i).Chromosome = individual;
    end
      
    % set the newPopulation to the population for the next generation
    population = newPopulation;
    population(1).Chromosome = bestIndividualOfCurrentPopulation;
    
    % inform the user at every 100th generation
    if (mod(generationIteration,20)==0)
        disp(sprintf("Gen: %d | globBestFitn: %d | currBestFitn: %d | best error: %.8f | mutProbScl: %d | sameFitCount: %d", generationIteration, globalBestIndividualFitness, bestIndividualOfCurrentPopulationFitness, globalBestIndividualError, mutationProbabilityScaler, sameFitnessCounter));
        
        % update figure
        clf 
        plot(X_data, Y_data) % legend='Data'
        grid on
        hold on
        plot(X_data, estimations(maxIndex, :)) % legend='currentBest'
        hold on
        plot(X_data, globalBestEvaluation);  %legend='globalB est'¥
        legend('Data', 'currentBest', 'globalBest')
        drawnow
    end
    
    generationIteration = generationIteration + 1;
end