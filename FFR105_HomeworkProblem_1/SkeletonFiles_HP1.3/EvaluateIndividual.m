% First compute the function value, then compute the fitness
% value; see also the problem formulation.

function fitness = EvaluateIndividual(x);
    x1 = x(1);
    x2 = x(2);
    
    % split function g
    g1 = (1.5 - x1 + x1*x2)^2;
    g2 = (2.25 - x1 + x1*x2^2)^2;
    g3 = (2.625 - x1 + x1*x2^3)^2;
    
    % combine g
    g = g1 + g2 + g3;
    
    % compute the fitness value
    fitness = 1/(g+1);

end
