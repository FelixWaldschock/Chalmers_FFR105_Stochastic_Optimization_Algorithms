function mutatedIndividual = Mutate(individual, mutationProbabilityScaler, lengthOfVariableRegisters, numberOfOperands, lengthOfOperators, lengthOfGenesPerInsruction);
    
    numberOfGenes = length(individual);
    numberOfInstruction = numberOfGenes / lengthOfGenesPerInsruction;
    mutatedIndividual = individual;

    % mutationProbability depending on length of individual
    mutationProbability = 2 / numberOfGenes;

    % scale the mutationProbability with the scaling factor
    % mutationProbabilityScaler
    mutationProbability = mutationProbability * mutationProbabilityScaler;
    

    % loop over all genes
    for i = 1:lengthOfGenesPerInsruction:numberOfGenes
        if (rand < mutationProbability)
            mutatedIndividual(i) = randi(lengthOfOperators);
        end
        if (rand < mutationProbability)
            mutatedIndividual(i+1) = randi(lengthOfVariableRegisters);
        end
        if (rand < mutationProbability)
            mutatedIndividual(i+2) = randi(numberOfOperands);
        end
        if (rand < mutationProbability)
            mutatedIndividual(i+3) = randi(numberOfOperands);
        end
    end

end