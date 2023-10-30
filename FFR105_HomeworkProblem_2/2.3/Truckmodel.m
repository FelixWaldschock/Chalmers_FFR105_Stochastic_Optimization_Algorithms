function updatedVelocity = Truckmodel(angleAlpha, gravity, Tb, Tmax, Pb, selectedGear, Cb, massOfTruck, deltaT, previousVelocity)
    % deviation from coding stardard, first letter of some variables is
    % capital to follow the formulae. 

    % determine the 3 forces of eq (2)
        % force of gravity -> Caution radian and degrees!
    forceGravity = massOfTruck * gravity * sin(deg2rad(angleAlpha));

        % force of the foundation brakes
    forceFoundationBraking = 0;
    if (Tb < (Tmax - 100))
        forceFoundationBraking = massOfTruck * gravity * Pb / 20;
    else
        linearTerm = massOfTruck * gravity * Pb / 20;
        exponentialTerm = exp(-(Tb-(Tmax -100))/100);
        forceFoundationBraking = linearTerm * exponentialTerm;
    end

        % force of engine breaking
    % gearRatios
    gearRatios = [7, 5, 4, 3, 2.5, 2, 1.6, 1.4, 1.2, 1];
    forceEngineBreaking = gearRatios(selectedGear) * Cb;

    % determine the 3 accelerations a = F / M;
    accelerationGravity = forceGravity / massOfTruck;
    accelerationFoundationBraking = forceFoundationBraking / massOfTruck;
    accelerationEngineBreaking = forceEngineBreaking / massOfTruck;

    % total acceleration
    totalAcceleration = (accelerationGravity - accelerationFoundationBraking - accelerationEngineBreaking);

    % update the velocity 
    updatedVelocity = previousVelocity + totalAcceleration * deltaT;
