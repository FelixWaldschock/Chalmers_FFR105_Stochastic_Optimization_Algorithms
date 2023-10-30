function nextNode = GetNode(tabuList, pheromoneLevels, visibility, alpha, beta)

    % create the array of possible nodes -> all nodes except the ones in the tabu list
    possibleNodes = 1:(length(pheromoneLevels)-length(tabuList));
    
    % loop over all possible node connections, where my current position is the last node in the tabu list
    currentPosition = tabuList(end);                        % the formular index "j"
    probablities = zeros(length(pheromoneLevels),1);
    
    numerators = [];
    
    % calculate all numerator terms
    for i = 1:length(probablities)
        if (ismember(i, tabuList))
            numerators = [numerators 0];
            continue
        end
        numerator = pheromoneLevels(i,currentPosition)^alpha * visibility(i, currentPosition)^beta;
        numerators = [numerators numerator];
    end
    
    denominator = sum(numerators);
    
    % calculate the probabilities
    for i = 1:length(probablities)
        if (ismember(i, tabuList))
            continue
        end
    
        probablities(i) = numerators(i) / denominator;
    end
    
    % select the next node probailistically
    rouletteWheel = cumsum(probablities);
    r = rand;
    index = find(rouletteWheel>r,1);
    if (tabuList(end) == index)
        error("Error next node equals last node, index for next: %d" , index);
    end
    nextNode = index;
end
