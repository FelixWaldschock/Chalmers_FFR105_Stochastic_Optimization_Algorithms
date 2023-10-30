function velocities = InitializeVelocities(numberOfParticles, numberOfDimensions, xMin, xMax)
    
    % alpha should be in range [0,1]
    alpha = 0.5; 

    velocities = zeros(numberOfParticles, numberOfDimensions);
    
    for i=1:numberOfParticles
        for j=1:numberOfDimensions
            % since xMin = -xMax simplified formula can be used
            % since deltaT = 1 its neglected in the formula
            velocities(i,j) = alpha * (xMin + rand*(xMax-xMin));
        end
    end

end