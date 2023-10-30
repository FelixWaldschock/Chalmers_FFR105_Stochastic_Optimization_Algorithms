% First compute the function value, then compute the fitness
% value; see also the problem formulation.

function fitness = EvaluateFitness(individual, error, maximalChromosomeLength, lengthOfGenesPerInsruction);

    % introduce penalty factor 
    penaltyFactor = 1.1;

    % rescale maximalChromosoneLength
    maximalChromosomeLengthCorr = maximalChromosomeLength * lengthOfGenesPerInsruction;

    % adjust the penalty factors weight depending on "how much" too long
    % the chromosome is
    if (length(individual) > maximalChromosomeLengthCorr)
        delta = abs(maximalChromosomeLengthCorr-length(individual));
        penaltyFactor = penaltyFactor^(delta);
        fitness = 1 / (error * penaltyFactor);
    else        
        fitness = 1 / (error);
    end
end
