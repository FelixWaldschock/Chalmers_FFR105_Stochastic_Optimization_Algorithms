% Felix Waldschock
% Homework Problem 2 / PSO -> FRR105 2023
clc
clear all;
close all;

% Parameters
numberOfDimensions = 2;
numberOfParticles = 20;
xMin = -5;
xMax = 5;
c1 = 2;
c2 = 2;
maxVelocity = xMax;
inertiaWeight = 1.4; % typical value according to book
beta = 0.99;
lowerIntertiaWeightBound = 0.3;

iterations = 10e4;

% init best particles
particleBestPosition = zeros(numberOfParticles,2);
particleBestEvaluation = inf(numberOfParticles,1);

swarmBestPosition = zeros(1,numberOfDimensions);
swarmBestEvaluation = inf;

positions = InitializePositions(numberOfParticles, numberOfDimensions, xMin, xMax);
velocities = InitializeVelocities(numberOfParticles, numberOfDimensions, xMin, xMax);

bestIter = 0;

for k=1:iterations   

    % evaluate each particle

    evaluatedParticles = zeros(length(numberOfParticles));

    for j=1:numberOfParticles
        x1 = positions(j, 1);
        x2 = positions(j, 2);

        evaluatedParticles(j) = EvaluateFunctionF(x1, x2);
    
        if (evaluatedParticles(j) < particleBestEvaluation(j))         % does particleBestEval need an index???
            particleBestEvaluation(j) = evaluatedParticles(j);
            particleBestPosition(j,1) = x1;
            particleBestPosition(j,2) = x2;
           
        end

        if (evaluatedParticles(j) < swarmBestEvaluation)
            %disp(sprintf("new best swarm particle in i: %d", k));
            swarmBestEvaluation = evaluatedParticles(j);
            swarmBestPosition(1) = x1;
            swarmBestPosition(2) = x2;
            bestIter = k;
        end
    end

    % update particle velocities and positions
    velocities = UpdateVelocities(velocities, c1, c2, positions, particleBestPosition, swarmBestPosition, maxVelocity, inertiaWeight);

    % update positions 
    positions = UpdatePositions(positions, velocities);

    % update inertia weight (chap 5.3.4)
    if (inertiaWeight > lowerIntertiaWeightBound)
        inertiaWeight = inertiaWeight * beta;
    end

end

disp(sprintf("Best position in Indx %d at X:%.9f, Y:%.9f with value v=%.20f", k, swarmBestPosition(1), swarmBestPosition(2), swarmBestEvaluation))


