% This function should return the gradient of f_p = f + penalty.
% You may hard-code the gradient required for this specific problem.

function gradF = ComputeGradient(x,mu)
       
    % get the variables from the vector for easier reading
    x1 = x(1);
    x2 = x(2);
    
    % evaluate the gradient of the function f
    fPrime1 = 2*(x1 - 1);
    fPrime2 = 4*(x2 - 2);


    % evaluate the partials of the penalty function
    penaltyPrime1 = 4*mu*x1*(x1^2 + x2^2 -1);
    penaltyPrime2 = 4*mu*x2*(x1^2 + x2^2 -1);
    
    % recombine the values    
    f_pPrime1 = fPrime1 + penaltyPrime1;
    f_pPrime2 = fPrime2 + penaltyPrime2;


    % combine gradient
    gradF = [f_pPrime1, f_pPrime2];

end
