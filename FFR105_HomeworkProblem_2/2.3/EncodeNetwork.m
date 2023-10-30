function chromosome = EncodeNetwork(wIH, wHO, wMax) 
    % reshape the matrices from 2D to 1D to have
    chromosomeWeightsIH = reshape(wIH, 1, []);
    chromosomeWeightsHO = reshape(wHO, 1, []);

    % concatetinate the chromosome
    chromosome = [chromosomeWeightsIH, chromosomeWeightsHO];

    % rescale all genes now to be in the range of [0,1] 
    % since the range is [-wMax, wMax] add wMax and divide by 2 wMax
    chromosome = (chromosome + wMax) / (2 * wMax);

end