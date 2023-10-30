function pathLength = GetPathLength(path,cityLocation)
    % loop over all cities in the path and calculate the distance between them
    totalPathLength = 0;
    for i = 1:(length(path)-1)
        currentLocationIndex = path(i);
        nextLocationIndex = path(i+1);
    
        currentLocationX = cityLocation(currentLocationIndex, 1);
        currentLocationY = cityLocation(currentLocationIndex, 2);
    
        nextLocationX = cityLocation(nextLocationIndex, 1);
        nextLocationY = cityLocation(nextLocationIndex, 2);
    
        totalPathLength = totalPathLength + sqrt ( (currentLocationX-nextLocationX)^2 + (currentLocationY - nextLocationY)^2 );
    end
    
    % add return to origin distance
    originX = cityLocation(path(1), 1);
    originY = cityLocation(path(1), 2);
    lastStopX = cityLocation(path(end), 1);
    lastStopY = cityLocation(path(end), 2);
    returnDistance = sqrt( (lastStopX-originX)^2 + (lastStopY-originY)^2 );
    
    totalPathLength = totalPathLength + returnDistance;
    pathLength = totalPathLength;

end