% This function should run gradient descent until the L2 norm of the
% gradient falls below the specified threshold.

function x = RunGradientDescent(xStart, mu, eta, gradientTolerance)
    % execute loop until norm of the gradient is smaller than the tolerance
    while norm(ComputeGradient(xStart,mu))>gradientTolerance
        x1 = xStart - eta * ComputeGradient(xStart, mu);
        xStart = x1;
    end
    x = xStart;
end



