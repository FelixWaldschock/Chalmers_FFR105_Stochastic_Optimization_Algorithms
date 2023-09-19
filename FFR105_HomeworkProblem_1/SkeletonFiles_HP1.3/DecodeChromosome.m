% Note: Each component of x should take values in [-a,a], where a = maximumVariableValue.

function x = DecodeChromosome(chromosome,numberOfVariables,maximumVariableValue);

    LengthOfChromosome = length(chromosome);
    k = LengthOfChromosome/numberOfVariables; % describes the number of bits per variable
 
    % implement decoding function according to formula 3.9 in the book

    % init x values to zero
    x(1) = 0.0;
    x(2) = 0.0;

    % evaluate gene term
    for j = 1:k
        x(1) = x(1) + chromosome(j)*2^(-j);
    end
    % combine static term with gene term
    x(1) = -maximumVariableValue + 2 * maximumVariableValue * x(1) / (1 - 2^(-k));

    % evaluate gene term
    for j = 1:k
        x(2) = x(2) + chromosome(j+k)*2^(-j);
    end

    % combine static term with gene term
    x(2) = -maximumVariableValue + 2 * maximumVariableValue*x(2)/(1 - 2^(-k));

end
