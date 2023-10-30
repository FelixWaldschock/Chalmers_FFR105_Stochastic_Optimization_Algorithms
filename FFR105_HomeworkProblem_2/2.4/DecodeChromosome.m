function estimation = DecodeChromosome(chromosome, numberOfVariableRegisters, setOfConstants, setOfOperators, xValueOfFunction, cMax)
    
    % !! works, tested with example calculated in lecture 16 !!
        

    % init the variable registers
    variableRegisters = zeros(numberOfVariableRegisters,1)';

    % set first variable register to the x value that is developed;
    variableRegisters(1) = xValueOfFunction;
   
    % init the array for all operands
    setOfOperands = [variableRegisters setOfConstants];

    % loop over the chromosome with stepsize 4 -> number of genes per
    % instruction
    for i = 1:4:length(chromosome)

        % determine the indeces 
        indexOfOperator = chromosome(i);
        indexOfDestinantionRegister = chromosome(i+1);
        indexOfFirstOperand = chromosome(i+2);
        indexOfSecondOperand = chromosome(i+3);

        % check if indeces are not out of bound
        if (indexOfOperator > length(setOfOperators))
            disp(chromosome)
            error("index of operator too large  i = %d", indexOfOperator)
        end

        % collect the information of the genes with the corresponding
        % indeces
        Operator = setOfOperators(indexOfOperator);
        FirstOperand = setOfOperands(indexOfFirstOperand);
        SecondOperand = setOfOperands(indexOfSecondOperand);

        if Operator == "+"
            setOfOperands(indexOfDestinantionRegister) = FirstOperand + SecondOperand;
        
        elseif Operator == "-"
            setOfOperands(indexOfDestinantionRegister) = FirstOperand - SecondOperand;
           
        elseif Operator == "*"
            setOfOperands(indexOfDestinantionRegister) = FirstOperand * SecondOperand;
        
        elseif Operator == "/"

            % as in Book p.74 eq. 3.52 ensure division not by 0
            if (SecondOperand ~= 0)
                setOfOperands(indexOfDestinantionRegister) = FirstOperand / SecondOperand;
            else
                setOfOperands(indexOfDestinantionRegister) = cMax;
            end
        end


        
    end

    % final value is to be found in the first cell of the operands
    estimation = setOfOperands(1);

end