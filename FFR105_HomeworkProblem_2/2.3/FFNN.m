function [PressureBraking, gearShift] = FFNN(inputs, wIH, wHO)
    
    numberOfColumnsIH = size(wIH, 2) - 1;       % number of columns of wIH, -1 for threshold
    % evaluate local fields from input to hidden -> ANN Book P. 16
    localFieldIH = wIH(:, 1:numberOfColumnsIH) * inputs' - wIH(:, numberOfColumnsIH+1);
    outputHidden = zeros(length(localFieldIH), 1);
    for i = 1:length(outputHidden)
        outputHidden(i) = ActivationFunction(localFieldIH(i));
    end

    % evaluate local field from hidden to output 
    numberOfColumnsHO = size(wHO, 2) - 1;
    localFieldOutput = wHO(:, 1:numberOfColumnsHO) * outputHidden - wHO(:, numberOfColumnsHO+1);
    output = zeros(length(localFieldOutput), 1);
    for i = 1:length(output)
        output(i) = ActivationFunction(localFieldOutput(i));
    end

    PressureBraking = output(1,1);
    gearShift = output(2,1);
    
end