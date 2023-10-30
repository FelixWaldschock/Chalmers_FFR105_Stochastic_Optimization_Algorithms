function sigma = ActivationFunction(localField)
    % define constant c for the sigmoid function
    c = 3;
    % define sigmoid (book page 159, eq (A6))
    sigma = 1 / (1 + exp(-c * localField));
end

