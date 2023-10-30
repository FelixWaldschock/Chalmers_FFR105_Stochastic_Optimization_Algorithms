function updatedPosition = UpdatePositions(positions, velocities)
    updatedPosition = zeros(size(positions));

    for i=1:size(positions,1)
            for j=1:size(positions,2)
                updatedPosition(i,j) = positions(i,j) + velocities(i,j);
            end
    end


end