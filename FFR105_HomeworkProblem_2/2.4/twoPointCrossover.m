function [newIndividual1, newIndividual2] = twoPointCrossover(individual1, individual2, lengthOfGenesPerInsruction, crossOverProbability)

    r = rand();
    if (r > crossOverProbability)
        newIndividual1 = individual1;
        newIndividual2 = individual2;
    else
        lengthOfIndividual1 = length(individual1)/lengthOfGenesPerInsruction;
        lengthOfIndividual2 = length(individual2)/lengthOfGenesPerInsruction;
    
        % determine 4 random crossover points
        crossoverPoint11 = randi(lengthOfIndividual1);
        crossoverPoint12 = randi(lengthOfIndividual1);
        crossoverPoint21 = randi(lengthOfIndividual2);
        crossoverPoint22 = randi(lengthOfIndividual2);
    
        while (crossoverPoint11 == crossoverPoint12)
            crossoverPoint12 = randi(lengthOfIndividual1);
        end
        while (crossoverPoint21 == crossoverPoint22)
            crossoverPoint22 = randi(lengthOfIndividual2);
        end
    
        % resort the crossover points if second is smaller than first
        if(crossoverPoint11 > crossoverPoint12)
            tmp = crossoverPoint11;
            crossoverPoint11 = crossoverPoint12;
            crossoverPoint12 = tmp;
        end
        if(crossoverPoint21 > crossoverPoint22)
            tmp = crossoverPoint21;
            crossoverPoint21 = crossoverPoint22;
            crossoverPoint22 = tmp;
        end
    
        % multiply crossover points with number of genes
        crossoverPoint11 = crossoverPoint11 * lengthOfGenesPerInsruction;
        crossoverPoint12 = crossoverPoint12 * lengthOfGenesPerInsruction;
        crossoverPoint21 = crossoverPoint21 * lengthOfGenesPerInsruction;
        crossoverPoint22 = crossoverPoint22 * lengthOfGenesPerInsruction;
    
        % cut the sections of the genes
        individual1_1 = individual1(1:crossoverPoint11);
        individual1_2 = individual1(crossoverPoint11+1:crossoverPoint12);
        individual1_3 = individual1(crossoverPoint12+1:end);
        individual2_1 = individual2(1:crossoverPoint21);
        individual2_2 = individual2(crossoverPoint21+1:crossoverPoint22);
        individual2_3 = individual2(crossoverPoint22+1:end);
        
        newIndividual1 = [individual1_1 individual2_2 individual1_3];
        newIndividual2 = [individual2_1 individual1_2 individual2_3];
    
        % check if the combined length is for new and old the same
        if((lengthOfIndividual1+lengthOfIndividual2) ~= ((length(newIndividual1)+length(newIndividual2)))/lengthOfGenesPerInsruction);
            lengthCombNew = length(newIndividual1)+length(newIndividual2);
            lengthCombOld = (lengthOfIndividual1 + lengthOfIndividual2) * lengthOfGenesPerInsruction;
    
            error("The new individuals are not same as the old combined")
        end
    end
    


end
