function error  = EvaluateError(estimations, targets, X_data)
    lengthOfEstimations = length(estimations);
    error = 0;


    % check if there are same amount of estimations as targets
    if (lengthOfEstimations ~= length(targets))
        error("Error in evaluateError, length of targets and estimations is not equal");
    end

    % loop over all estimations 
    for i = 1:lengthOfEstimations
        error = error + (estimations(i) - targets(i))^2;
    end
   
    error = sqrt(error / lengthOfEstimations);

end