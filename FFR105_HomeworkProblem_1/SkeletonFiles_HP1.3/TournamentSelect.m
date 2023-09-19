function selectedIndividualIndex = TournamentSelect(fitnessList, tournamentProbability, tournamentSize);

    % initialize a Tournament population with the size 2xn (first row =
    % fitness, second row = index)
    tournamentPopulation = zeros(2, tournamentSize);
    populationSize = size(fitnessList, 1);
    
    for i = 1:tournamentSize
        % randomly select a fitness/individual
        index = 1 + fix(rand*populationSize);

        % feed the tournamentPopulation matrix with the randomly selected
        % individuals
        tournamentPopulation(1, i) = fitnessList(index);
        tournamentPopulation(2, i) = index;
    end
   
    % sort the tournamentPopulation matrix for descending fitness values
    sortedPopulation = sortrows(tournamentPopulation','descend')';
 
    for i = 1:tournamentSize
        % chose a new random value for each iteration
        r = rand;

        % if reaching the end of the tournament size, use the last
        % individual
        if i==tournamentSize
            selectedIndividualIndex = sortedPopulation(2,i);
        else 
            if (r < tournamentProbability)
            selectedIndividualIndex = sortedPopulation(2,i);
            break;
            end
        end 
    end

end

