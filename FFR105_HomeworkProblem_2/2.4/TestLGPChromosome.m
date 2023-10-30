clc
clear all
close all


% load the chromsome -> loading of .m file did not work, therefore .mat
chromosome = load('globalBestChromosome.mat');
chromosome = chromosome(1).globalBestIndividualChromsome;

% register for LGP
    % init constants 
setOfConstants = [1, 3, -1];      % Book p. 76
lengthOfConstantsRegisters = length(setOfConstants);

    % variable register
lengthOfVariableRegisters = 4; % Book p. 76

    % length of operands 
lengthOfOperands = lengthOfVariableRegisters + lengthOfConstantsRegisters;

    % init operators
setOfOperators = ["+", "-", "*", "/"];
lengthOfOperators = length(setOfOperators);
    
    % cMax
cMax = 10e15;

% load the function data
data = LoadFunctionData();
X_data = data(:,1);
Y_data = data(:,2);


% decode the chromosome
estimations = zeros(1, length(X_data));
for k = 1:size(estimations, 2)
    estimations(k) = DecodeChromosome(chromosome, lengthOfVariableRegisters, setOfConstants, setOfOperators, X_data(k), cMax);
end

% evaluate all individuals errors
error = EvaluateError(estimations, Y_data, X_data)

% plot 
figure()

% plot input data
plot(X_data, Y_data, 'x')
hold on

% plot estimation
plot(X_data, estimations)
grid on
legend('Input data', 'Estimated values');
xlabel('X')
ylabel('Y')
title('LGP Function fitting')

% output the symbolic function
symbolicFunction = getSymbolicFuntion(chromosome, lengthOfVariableRegisters, setOfConstants, setOfOperators, cMax)
