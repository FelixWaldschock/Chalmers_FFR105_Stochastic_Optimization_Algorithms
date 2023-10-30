function correlation_coefficient = getCorrelationCoefficient(X_data, estimations)
    sumOfFirstDerivative = 0;
    % sum of first derivative
    if(0)
        
        for i = (length(X_data)-1)
            x1 = X_data(i);
            x2 = X_data(i+1);
            y1 = estimations(i);
            y2 = estimations(i+1);
            delta = abs((y2-y1)/(x2-x1));
            if(delta == inf)
                disp("error inf")
            end
            sumOfFirstDerivative = sumOfFirstDerivative + delta;
        end
        sumOfFirstDerivative = sumOfFirstDerivative/length(X_data);
    end
    % first derivative over mean
    if(1)
        firstDerivative = zeros(length(X_data)-1,1);
        for i = (length(X_data)-1)
            x1 = X_data(i);
            x2 = X_data(i+1);
            y1 = estimations(i);
            y2 = estimations(i+1);
            firstDerivative(i) = abs((y2-y1)/(x2-x1));
            if(firstDerivative(i) == inf)
                disp("error inf")
            end
            sumOfFirstDerivative = sumOfFirstDerivative + firstDerivative(i);
        end


        correlation_coefficient = var(firstDerivative);
    end

    % (Pearson correlation coefficient)
    if(0)
        % Calculate the mean of X_data and estimations
        mean_X_data = mean(X_data);
        mean_estimations = mean(estimations);
        
        % Calculate the correlation coefficient (Pearson correlation coefficient)
        numerator = sum((X_data - mean_X_data) .* (estimations - mean_estimations));
        denominator_X_data = sqrt(sum((X_data - mean_X_data) .^ 2));
        denominator_estimations = sqrt(sum((estimations - mean_estimations) .^ 2));
        correlation_coefficient = numerator / (denominator_X_data * denominator_estimations);
    end

    correlation_coefficient = sumOfFirstDerivative;

end