%%%%%%%%%
% Felix Waldschock
% SOA HW 2.3
% Truckbreaking optimization with FFNN - RunTest
%%%%%%%%%

clear all
close all
clc

%% Parameters for Truckmodel
deltaT = 0.25;                      % [s]
gearChangeTimeBlocker = 2 / deltaT; % [s] -> only shift after 2 seconds
pressureBraking = 1;                % [-] shall be in range [0, 1], describes the pressure applied
Tmax = 750;                         % [Kelvin]
MassOfTruck = 20000;                % [kg]
tau = 30;                           % [s]
Ch = 40;                            % [Kelvin/s]
Cb = 3000;                          % [Newton]
Tamb = 283;                         % [Kelvin]
vMax = 25;                          % [m/s] -> maximal velocity
vMin = 1;                           % [m/s] -> minimal velocity
alphaMax = 10;                      % [deg]
gravityConstant = 9.81;             % [m/s^2]
totalSlopeLength = 800;             % [m], total horizontal length of a slope

% initial conditions
initialPositions = 0;               % [m]
initialVelocity = 20;               % [m/s]
initialBrakeTemperatur = 500;       % [Kelvin]
initialGear = 7;                    % init slected gear


% parameters of the NN
nInput = 3;                         % number of inputs
nHidden = 8;                        % number of hidden layers
nOut = 2;                           % number of outputs;
chromosomeLength = (nHidden*(nInput + 1) + (nHidden + 1) * nOut);   % total length for a chromosome to store all weights and biases
wMax = 5;


% load the best chromosome
chromosome = load('BestChromosome.mat');
chromosome = chromosome.globalTrainBestIndividualFitnessChromosome;
% decode the chromsome to get the weights matrices of the FFNN
[wIH, wHO] = DecodeChromosome(chromosome, nInput, nHidden, nOut, wMax);

% intialise arrays for tracking values;
gearSelectionTracker = [];

% slopes
iDataValidationSet = 3;

% keep track of the multiple slopes
fitnessValueTracker = zeros(1, 5);
slopeAngleTracker = [];
appliedPressureTracker = [];
selectedGearTracker = [];
velocityTracker = [];
brakeTemperatureTracker = [];

% drive the test slopes
for iSlope = 1:5
    % load the init conditions
    brakeTemperature = initialBrakeTemperatur;
    deltaBrakeTemperature = 0;                      % evaluated later
    position = initialPositions;
    velocity = initialVelocity;
    selectedGear = initialGear;
    
    totalCoveredDistance = 0;
    elapsedTime = 0;
    gearChangeTimeBlockerCounter = 0;
    
    
    % drive the slope
    % start while loop, and check that no constraint is violated
    % velocity <= vMax
    % velocity >= vMin
    % brakeTemperature <= Tmax
    % Position X is <= totalSlopeLength
    while((velocity <= vMax) && (velocity >= vMin) && (brakeTemperature <= Tmax) && (position <= totalSlopeLength))
        
        % determine the angle of the slope
        angleAlpha = GetSlopeAngle(position, iSlope, iDataValidationSet);
        slopeAngleTracker = [slopeAngleTracker, angleAlpha];
        
        % determine the input values for the FFNN
        input1 = velocity / vMax;
        input2 = angleAlpha / alphaMax;
        input3 = brakeTemperature / Tmax;
        inputs = [input1, input2, input3];
        
        % feed the FFNN
        [PressureBraking, gearShift] = FFNN(inputs, wIH, wHO);
        appliedPressureTracker = [appliedPressureTracker, PressureBraking];
        % update brake temperature according to eq (4)
        if (PressureBraking < 0.01)
            deltaBrakeTemperature = - (brakeTemperature - Tamb) / tau;
        else
            deltaBrakeTemperature = Ch * PressureBraking;
        end
        brakeTemperature = brakeTemperature + deltaBrakeTemperature;
        brakeTemperatureTracker = [brakeTemperatureTracker, brakeTemperature];
        
        % get the new velocity
        velocity = Truckmodel(angleAlpha, gravityConstant, brakeTemperature, Tmax, pressureBraking, selectedGear, Cb, MassOfTruck, deltaT, velocity);
        velocityTracker = [velocityTracker, velocity];
        
        % deterine new position
        position = position + cos(deg2rad(angleAlpha))* velocity * deltaT;
        
        % check if gear shift is suggested and if allowed
        if (gearChangeTimeBlocker > gearChangeTimeBlockerCounter)
            % shift up
            if ((gearShift > 0.7) && (selectedGear < 10))
                selectedGear = selectedGear + 1;
                gearChangeTimeBlockerCounter = 0;
                % shift down
            elseif ((gearShift < 0.3) && (selectedGear > 1))
                selectedGear = selectedGear - 1;
                gearChangeTimeBlockerCounter = 0;
            end
        end
        selectedGearTracker = [selectedGearTracker, selectedGear];
        
        % update variables
        totalCoveredDistance = position;
        gearChangeTimeBlockerCounter = gearChangeTimeBlockerCounter + 1;
        elapsedTime = elapsedTime + deltaT;
        
    end
    
    % evaluate fitness
    averageVelocity = 0;
    % do not divide by 0 !
    if (elapsedTime > 0)
        averageVelocity = totalCoveredDistance / elapsedTime;
    end
    
end

% create a subplot with 5 plots
figure(1)
subplot(5, 1, 1)
plot(slopeAngleTracker(1, :))
title('Slope Angle')
ylabel('Angle [deg]')
subplot(5, 1, 2)
plot(appliedPressureTracker(1, :))
title('Applied Pressure')
ylabel('Pressure [-]')
subplot(5, 1, 3)
plot(selectedGearTracker(1, :))
title('Selected Gear')
ylabel('Gear [-]')
subplot(5, 1, 4)
plot(velocityTracker(1, :))
title('Velocity')
ylabel('Velocity [m/s]')
subplot(5, 1, 5)
plot(brakeTemperatureTracker(1, :))
title('Brake Temperature')
ylabel('Temp [K]')

% add x label
xlabel('Distance [m]')