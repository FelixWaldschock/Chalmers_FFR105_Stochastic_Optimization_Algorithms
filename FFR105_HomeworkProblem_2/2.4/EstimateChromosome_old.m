function chromosomeEstimation = EstimateChromosome(individual, dataOfFunction, setOfConstants, lengthOfVariableRegisters, setOfOperators, cMax)
    
    x_dataPoints = dataOfFunction(1,:);
    lengthOfXDataPoint = length(x_dataPoints);

    % array to store the found estimations
    chromosomeEstimation = zeros(lengthOfXDataPoint, 1);

    for i = 1:lengthOfXDataPoint
        xk = x_dataPoints(i);
        chromosomeEstimation(i) = DecodeChromosome(individual, lengthOfVariableRegisters, setOfConstants, setOfOperators, xk, cMax);
    end 
    
end