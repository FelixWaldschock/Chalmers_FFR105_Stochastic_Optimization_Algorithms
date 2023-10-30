function visibility = GetVisibility(cityLocation)

    numberOfCities = size(cityLocation,1);
    visibility = zeros(numberOfCities);

    for i = 1:numberOfCities
        for j = 1:numberOfCities
            
            city1 = cityLocation(i,:);
            city2 = cityLocation(j,:);
            distance = norm(city2-city1);
            if distance == 0
                visibility(i,j) = 0;
            else
                visibility(i,j) = 1/distance;
            end

        end
    end


end

