function pheromoneLevel = UpdatePheromoneLevels(pheromoneLevel,deltaPheromoneLevel,rho);
    Threshold = 10e-15;

    for i=1:length(pheromoneLevel)
        for j=1:length(pheromoneLevel)
            if (pheromoneLevel(i,j) < Threshold)
                pheromoneLevel(i,j) = Threshold;
            end
            pheromoneLevel(i,j) = (1-rho)*pheromoneLevel(i,j) + deltaPheromoneLevel(i,j);
        end
    end 

end