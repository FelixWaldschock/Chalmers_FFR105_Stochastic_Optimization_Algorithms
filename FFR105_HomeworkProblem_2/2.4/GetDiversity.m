function diversity = GetDiversity(population, populationSize)
    % get the diversity of the entire population;
    % follow the formulas in book (3.49 / 3.50 & 3.51)
    N = populationSize;

    totalDistanceOfPopulation = 0;

    for i = 1:(populationSize-1)
        for j = (i+1):(populationSize)
            individual1 = population(i).Chromosome;
            individual2 = population(j).Chromosome;
            totalDistanceOfPopulation = totalDistanceOfPopulation + getDistance(individual1, individual2);
        end
    end

    resaclingFactor = 2 / (N * (N - 1));
    diversity = totalDistanceOfPopulation/resaclingFactor;
end