function distance = getDistance(individual1, individual2)
    
    maxLength = max(length(individual1), length(individual2));

    lengthIndividual1 = length(individual1);
    lengthIndividual2 = length(individual2);

    % Pad the shorter chromosome with zeros
    if lengthIndividual1 < maxLength
        individual1 = [individual1, zeros(1, maxLength - lengthIndividual1)];
    end
    
    if lengthIndividual2 < maxLength
        individual2 = [individual2, zeros(1, maxLength - lengthIndividual2)];
    end

    Rk = max([individual1 individual2])-min([individual1 individual2]);

    totalDistance = 0;

    for i = 1:maxLength
        gene1 = individual1(i);
        gene2 = individual2(i);

        distance = abs(gene1-gene2);
        distance = distance/Rk;

        totalDistance = totalDistance + distance;

    end

    distance = totalDistance/(maxLength * Rk);

end