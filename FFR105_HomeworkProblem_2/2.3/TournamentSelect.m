function newIndex = TournamentSelect(fitness, pTournament)

    populationSize = size(fitness,1);
    indexTmp1 = 1 + fix(rand*populationSize);
    indexTmp2 = 1 + fix(rand*populationSize);

    r =rand;

    if (r < pTournament)
        if (fitness(indexTmp1)>fitness(indexTmp2))
            newIndex = indexTmp1;
        else
            newIndex = indexTmp2;
        end
    else
        if (fitness(indexTmp1)>fitness(indexTmp2))
            newIndex = indexTmp2;
        else
            newIndex = indexTmp1;
        end
    end

end