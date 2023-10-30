%%%%%%%%%
% Felix Waldschock
% SOA HW 2.3
% Truckbreaking optimization with FFNN and GA
%%%%%%%%%

clear all
close all
clc

% Parameters for Truckmodel
deltaT = 0.25;                      % [s]
gearChangeTimeBlocker = 2 / deltaT; % [s] -> only shift after 2 seconds
pressureBraking = 1;                % [-] shall be in range [0, 1], describes the pressure applied
Tmax = 750;                         % [Kelvin]
MassOfTruck = 20000;                % [kg]
tau = 30;                           % [s]
Ch = 40;                            % [Kelvin/s]
Cb = 3000;                          % [Newton]
Tamb = 283;                         % [Kelvin]
vMax = 25;                          % [m/s] -> maximal velocity
vMin = 1;                           % [m/s] -> minimal velocity
alphaMax = 10;                      % [deg]
gravityConstant = 9.81;             % [m/s^2]
totalSlopeLength = 800;             % [m], total horizontal length of a slope

% initial conditions
initialPositions = 0;               % [m]
initialVelocity = 20;               % [m/s]
initialBrakeTemperatur = 500;       % [Kelvin]
initialGear = 7;                    % init slected gear

% parameters of the NN
nInput = 3;                         % number of inputs
nHidden = 8;                        % number of hidden layers
nOutput = 2;                        % number of outputs;
wMax = 5;                           % range of weights
chromosomeLength = (nHidden*(nInput + 1) + (nHidden + 1) * nOutput);   % total length for a chromosome to store all weights and biases

% parameters for the GA
populationSize = 125;
numberOfGenerations = 1000;
trainingSlopesData = 1;
validationSlopesData = 2;
crossoverProbability = 0.3;
mutationRate = 2/chromosomeLength;
tournamentSelectionProbability = 0.75;

% initalize the population (matrix
population = InitializePopulation(populationSize, chromosomeLength);

% global best fitness
globalTrainBestIndividualFitness = 0;
globalTrainBestIndividualFitnessChromosome = 0;
globalTrainBest_wIH = zeros(nHidden, nInput + 1);
globalTrainBest_wHO = zeros(nOutput, nHidden + 1);


% holdout method
% fitnessTracker
trainingFitnessTracker = zeros(numberOfGenerations, 1);
validationFitnessTracker = zeros(numberOfGenerations, 1);
% store every best individual of every generation
bestIndividualsOfGenerations = zeros(numberOfGenerations, chromosomeLength);

for g = 1:numberOfGenerations
    
    % maxFitness value of
    bestFitnessOfGeneration = 0;
    bestFitnessOfGenerationIndex = 0;
    bestFitnessOfGenerationChromosome = [];
    
    % init the weight matrices
    wIHBestOfGeneration = zeros(nHidden, nInput + 1);
    wHOBestOfGeneration = zeros(nOutput, nHidden + 1);
    
    % evaluate the populations
    IndividualsFitness = zeros(populationSize, 1);
    for i = 1:populationSize
        individual = population(i,:);
        % get the weight matrices
        [wIH, wHO] = DecodeChromosome(individual, nInput, nHidden, nOutput, wMax);
        
        % evaluate every individual over all 10 training slopes
        individualsFitnessPerSlope = zeros(1, 10);
        
        % drive all 10 training slopes
        for iSlope = 1:10
            % load the init conditions
            brakeTemperature = initialBrakeTemperatur;
            deltaBrakeTemperature = 0;                      % evaluated later
            position = initialPositions;
            velocity = initialVelocity;
            selectedGear = initialGear;
            
            totalCoveredDistance = 0;
            elapsedTime = 0;
            gearChangeTimeBlockerCounter = 0;
            
            
            % drive the slope
            % start while loop, and check that no constraint is violated
            % velocity <= vMax
            % velocity >= vMin
            % brakeTemperature <= Tmax
            % Position X is <= totalSlopeLength
            while((velocity <= vMax) && (velocity >= vMin) && (brakeTemperature <= Tmax) && (position <= totalSlopeLength))
                
                % determine the angle of the slope
                angleAlpha = GetSlopeAngle(position, iSlope, trainingSlopesData);
                
                % determine the input values for the FFNN
                input1 = velocity / vMax;
                input2 = angleAlpha / alphaMax;
                input3 = brakeTemperature / Tmax;
                inputs = [input1, input2, input3];
                
                % feed the FFNN
                [PressureBraking, gearShift] = FFNN(inputs, wIH, wHO);
                
                % update brake temperature according to eq (4)
                if (PressureBraking < 0.01)
                    deltaBrakeTemperature = - (brakeTemperature - Tamb) / tau;
                else
                    deltaBrakeTemperature = Ch * PressureBraking;
                end
                brakeTemperature = brakeTemperature + deltaBrakeTemperature;
                
                % get the new velocity
                velocity = Truckmodel(angleAlpha, gravityConstant, brakeTemperature, Tmax, pressureBraking, selectedGear, Cb, MassOfTruck, deltaT, velocity);
                
                % deterine new position
                position = position + cos(deg2rad(angleAlpha))* velocity * deltaT;
                
                % check if gear shift is suggested and if allowed
                if (gearChangeTimeBlocker > gearChangeTimeBlockerCounter)
                    % shift up
                    if ((gearShift > 0.7) && (selectedGear < 10))
                        selectedGear = selectedGear + 1;
                        gearChangeTimeBlockerCounter = 0;
                        % shift down
                    elseif ((gearShift < 0.3) && (selectedGear > 1))
                        selectedGear = selectedGear - 1;
                        gearChangeTimeBlockerCounter = 0;
                    end
                end
                
                % update variables
                totalCoveredDistance = position;
                gearChangeTimeBlockerCounter = gearChangeTimeBlockerCounter + 1;
                elapsedTime = elapsedTime + deltaT;
                
            end
            
            % evaluate fitness
            averageVelocity = 0;
            % do not divide by 0 !
            if (elapsedTime > 0)
                averageVelocity = totalCoveredDistance / elapsedTime;
            end
            fitness = averageVelocity * totalCoveredDistance;
            individualsFitnessPerSlope(iSlope) = fitness;
            
            
        end
        
        % determine network Fitness (either take min or mean)
        IndividualsFitness(i) = min(individualsFitnessPerSlope);
        
        % update bestGenerationsValues
        if (IndividualsFitness(i) > bestFitnessOfGeneration)
            bestFitnessOfGeneration = IndividualsFitness(i);
            bestFitnessOfGenerationIndex = i;
            wIHBestOfGeneration = wIH;
            wHOBestOfGeneration = wHO;
            bestFitnessOfGenerationChromosome = EncodeNetwork(wIH, wHO, wMax);
        end
        % update global
        if (IndividualsFitness(i) > globalTrainBestIndividualFitness)
            globalTrainBestIndividualFitness = IndividualsFitness(i);
            globalTrainBestIndividualFitnessChromosome = bestFitnessOfGenerationChromosome;
        end
    end
    
    % duplicate new Population
    newPopulation = population;
    bestIndividualOfPopulation = population(bestFitnessOfGenerationIndex);
    
    % crossover the new population
    for i = 1:2:(populationSize)
        index1 = TournamentSelect(fitness,tournamentSelectionProbability);
        index2 = TournamentSelect(fitness,tournamentSelectionProbability);
        individual1 = population(index1,:);
        individual2 = population(index2,:);
        
        % crossover
        if (rand < crossoverProbability)
            newIndividuals = Cross(individual1, individual2);
            newPopulation(i,:) = newIndividuals(1,:);
            newPopulation(i+1,:) = newIndividuals(2,:);
        else
            newPopulation(i,:) = individual1;
            newPopulation(i+1,:) = individual2;
        end
    end
    
    % mutate the population
    for i = 1:populationSize
        individual = newPopulation(i,:);
        newIndividual = Mutate(individual, mutationRate);
        newPopulation(i,:) = newIndividual;
    end
    
    % update the population
    population = newPopulation;
    
    % update global best fitness
    globalTrainBestIndividualFitness = bestFitnessOfGeneration;
    
    % set bestIndividual as first item of new population (elistism)
    population(1) = bestIndividualOfPopulation;
    
    trainingFitnessTracker(g) = bestFitnessOfGeneration;
    
    % store the best individual of the generation
    bestIndividualsOfGenerations(g,:) = bestFitnessOfGenerationChromosome;
    
    % Apply the best training network onto the validation set (code same as above but for validation slopes)
    
    wIH = wIHBestOfGeneration;
    wHO = wHOBestOfGeneration;
    
    % new fitnesslist for validation
    validationFitnessList = zeros(1, 5);
    
    for iSlope = 1:5
        % load the init conditions
        brakeTemperature = initialBrakeTemperatur;
        deltaBrakeTemperature = 0;                      % evaluated later
        position = initialPositions;
        velocity = initialVelocity;
        selectedGear = initialGear;
        
        totalCoveredDistance = 0;
        elapsedTime = 0;
        gearChangeTimeBlockerCounter = 0;
        
        
        % drive the slope
        % start while loop, and check that no constraint is violated
        % velocity <= vMax
        % velocity >= vMin
        % brakeTemperature <= Tmax
        % Position X is <= totalSlopeLength
        while((velocity <= vMax) && (velocity >= vMin) && (brakeTemperature <= Tmax) && (position <= totalSlopeLength))
            
            % determine the angle of the slope
            angleAlpha = GetSlopeAngle(position, iSlope, validationSlopesData);
            
            % determine the input values for the FFNN
            input1 = velocity / vMax;
            input2 = angleAlpha / alphaMax;
            input3 = brakeTemperature / Tmax;
            inputs = [input1, input2, input3];
            
            % feed the FFNN
            [PressureBraking, gearShift] = FFNN(inputs, wIH, wHO);
            
            % update brake temperature according to eq (4)
            if (PressureBraking < 0.01)
                deltaBrakeTemperature = - (brakeTemperature - Tamb) / tau;
            else
                deltaBrakeTemperature = Ch * PressureBraking;
            end
            brakeTemperature = brakeTemperature + deltaBrakeTemperature;
            
            % get the new velocity
            velocity = Truckmodel(angleAlpha, gravityConstant, brakeTemperature, Tmax, pressureBraking, selectedGear, Cb, MassOfTruck, deltaT, velocity);
            
            % deterine new position
            position = position + cos(deg2rad(angleAlpha))* velocity * deltaT;
            
            % check if gear shift is suggested and if allowed
            if (gearChangeTimeBlocker > gearChangeTimeBlockerCounter)
                % shift up
                if ((gearShift > 0.7) && (selectedGear < 10))
                    selectedGear = selectedGear + 1;
                    gearChangeTimeBlockerCounter = 0;
                    % shift down
                elseif ((gearShift < 0.3) && (selectedGear > 1))
                    selectedGear = selectedGear - 1;
                    gearChangeTimeBlockerCounter = 0;
                end
            end
            
            % update variables
            totalCoveredDistance = position;
            gearChangeTimeBlockerCounter = gearChangeTimeBlockerCounter + 1;
            elapsedTime = elapsedTime + deltaT;
            
        end
        % drive ended
        
        % evaluate fitness
        averageVelocity = 0;
        % do not divide by 0 !
        if (elapsedTime > 0)
            averageVelocity = totalCoveredDistance / elapsedTime;
        end
        fitness = averageVelocity * totalCoveredDistance;
        validationFitnessList(iSlope) = fitness;
        validationFitnessTracker(g) = fitness;
        
    end
    % inform the user over the progress every 50th generation
    if (mod(g, 50) == 0)
        fprintf("Generation %d finished\n", g)
    end
    
end

% holdout method finished
% pick the best fitness in the validation set
[bestValidationFitness bestindex] = max(validationFitnessList);
% pick the best chromosome
globalTrainBestIndividualFitnessChromosome = bestIndividualsOfGenerations(bestindex,:);

fprintf("Training and validation finished\n")

% plot the training and validation fitness
figure(1)
plot(trainingFitnessTracker)
hold on
plot(validationFitnessTracker)
legend('Training Fitness', 'Validation Fitness')
xlabel('Generation')
ylabel('Fitness')
title('Training and Validation Fitness over Generations')

% save the best individual

save('BestChromosome.mat', 'globalTrainBestIndividualFitnessChromosome');
