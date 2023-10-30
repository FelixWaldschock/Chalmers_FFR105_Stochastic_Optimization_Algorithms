function deltaPheromones = ComputeDeltaPheromoneLevels(pathCollection,pathLengthCollection)
    deltaPheromones = zeros(size(pathCollection));
  
    for k=1:length(pathCollection) % k := size of the ant population
        tourLength = pathLengthCollection(k);
        % define i and j, which represent the ways that the ants travelled
        edges = zeros(length(pathCollection),2);
        for i=1:(length(edges)-1)
            edges(i,1) = pathCollection(k, i);
            edges(i,2) = pathCollection(k, i+1);

        end
        % add the return to origin path
        edges(end, 1) = pathCollection(k, end);
        edges(end, 2) = pathCollection(k, 1);

        deltaPheromonesSingleAnt = zeros(size(pathCollection));

        % loop over all edges
        for m = 1:length(edges)
            % use index i and j as in formular
            i = edges(m, 1);
            j = edges(m, 2);
            deltaPheromonesSingleAnt(i,j) = 1/tourLength;
            %deltaPheromones(i,j) = deltaPheromones(i,j) + 1/tourLength;
            
        end
        deltaPheromones = deltaPheromones + deltaPheromonesSingleAnt;
    end 


end