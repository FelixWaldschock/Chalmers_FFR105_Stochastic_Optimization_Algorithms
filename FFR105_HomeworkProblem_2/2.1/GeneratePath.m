function GeneratePath = GeneratePath(pheromoneLevel, visibility, alpha, beta)
    % init an empty Tabu list
    tabuList = [];
    
    % select a random starting position
    startingNode = randi(length(pheromoneLevel));
    %startingNode = 1;
    
    % add starting node to Tabu list
    tabuList = [tabuList, startingNode];
    
    % building tour S
    for i=1:(length(pheromoneLevel)-1)
        nextNode = GetNode(tabuList, pheromoneLevel, visibility, alpha, beta);
        % update tabu list
        tabuList = [tabuList, nextNode];
        
    end
    
    GeneratePath = tabuList;

end