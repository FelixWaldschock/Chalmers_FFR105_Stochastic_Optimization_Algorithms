function symbolicFunciton = getSymbolicFuntion(individual, numberOfVariables, setOfConstantRegister, setOfOpertators, cMax)
    nGenes = length(individual);
    
    variableRegister(1:numberOfVariables) = sym(0);
    variableRegister(1) = "x";
    
    constantRegister = sym(setOfConstantRegister);
    setOfOperands = [variableRegister, setOfConstantRegister];
    
    for j = 1:4:nGenes
        operatorIndex = individual(j);
        destinationIndex = individual(j+1);
        operand1Index = individual(j+2);
        operand2Index = individual(j+3);

        operator = setOfOpertators(operatorIndex);
        operand1 = setOfOperands(operand1Index);
        operand2 = setOfOperands(operand2Index);
        
        if operator == '+'
            setOfOperands(destinationIndex) = operand1 + operand2;
        elseif operator == '-'
            setOfOperands(destinationIndex) = operand1 - operand2;
        elseif operator == '*'
            setOfOperands(destinationIndex) = operand1 * operand2;
        elseif operator == '/'
            if operand2 == 0
                setOfOperands(destinationIndex) = cMax;
            else
                setOfOperands(destinationIndex) = operand1 / operand2;
            end
        end
        
    end
    
    symbolicFunciton = simplify(setOfOperands(1));


end