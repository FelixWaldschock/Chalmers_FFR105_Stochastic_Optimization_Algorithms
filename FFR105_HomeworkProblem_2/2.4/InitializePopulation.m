function population = InitializePopulation(populationSize, minimalChromosomeLength, maximalChromosomeLenght, lengthOfVariableRegisters, numberOfOperands, lengthOfOperators, lengthOfGenesPerInsruction)
    
    initPopulation = [];


    for i=1:populationSize
        % determine randomly of how many genes the chromosome will consist. In the given range 
        numberOfGenes = randi([minimalChromosomeLength, maximalChromosomeLenght]);
        % determine the correct length with regard to the number of genes
        % per instruction
        lengthOfChromosome = numberOfGenes * lengthOfGenesPerInsruction;
        
        % init the chromosome
        chromosome = zeros(1,lengthOfChromosome);

        % fill the chromsome
        for j=1:lengthOfGenesPerInsruction:lengthOfChromosome
            % operator 
            chromosome(j) = randi(lengthOfOperators);
            % destinantion register
            chromosome(j+1) = randi(lengthOfVariableRegisters);
            % operand 1
            chromosome(j+2) = randi(numberOfOperands);
            % operand 2
            chromosome(j+3) = randi(numberOfOperands);
        end
        
        individual = struct('Chromosome', chromosome);
        initPopulation = [initPopulation individual];
    end

    population = initPopulation;
    
end