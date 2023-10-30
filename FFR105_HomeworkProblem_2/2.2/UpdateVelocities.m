function updatedVelocities = UpdateVelocities(velocities, c1, c2, positions, particleBestPosition, swarmBestPosition, maxVelocity, inertiaWeight)

    
    for i=1:size(velocities,1)
        % init the random values r & q
        q = rand;
        r = rand;

        for j=1:size(velocities,2)
            term1 = c1 * q * (particleBestPosition(i,j) - positions(i,j));
            term2 = c2 * r * (swarmBestPosition(j) - positions(i,j));
            velocities(i,j) = inertiaWeight * velocities(i,j) + term1 + term2;

            if velocities(i,j) > maxVelocity
                velocities(i,j) = maxVelocity;
            elseif velocities(i,j) < -maxVelocity
                velocities(i,j) = -maxVelocity;
            end
        end

    end


    updatedVelocities = velocities;

end