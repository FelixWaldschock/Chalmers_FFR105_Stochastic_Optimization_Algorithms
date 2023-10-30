% nIn = the number of inputs
% nHidden = the number of hidden neurons
% nOut = the number of output neurons
% Weights (and biases) should take values in the range [-wMax,wMax]

function [wIH, wHO] = DecodeChromosome(chromosome, nIn, nHidden, nOut, wMax);

    % determine how long the wIH part of the chromosome is
    lengthWIH = nHidden * (nIn + 1);

    % get wIH of the chromosome
    chromosomeWeightsIH = chromosome(1:lengthWIH);
    % get the rest of the chromosome which is the wHO
    chromosomeWeightsOH = chromosome(lengthWIH + 1:end);

    % decode the chromosomes with the range [Wmax]
    decodedChromosomeWeightsIH = wMax * (2 * chromosomeWeightsIH - 1);
    decodedChromosomeWeightsOH = wMax * (2 * chromosomeWeightsOH - 1);

    % reshape the chromosomes back into matrices of the dimensions
        % sizeWIH = nHidden X (nIn + 1)
    wIH = reshape(decodedChromosomeWeightsIH, nHidden, (nIn + 1));
        % sizeWHO = nOut X (nHidden + 1)
    wHO = reshape(decodedChromosomeWeightsOH, nOut, (nHidden + 1));

end