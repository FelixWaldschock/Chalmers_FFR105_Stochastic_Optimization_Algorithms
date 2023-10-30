%% This file provides the FORMAT you should use for the
%% slopes in HP2.3. x denotes the horizontal distance
%% travelled (by the truck) on a given slope, and
%% alpha measures the slope angle at distance x
%%
%% iSlope denotes the slope index (i.e. 1,2,..10 for the
%% training set etc.)
%% iDataSet determines whether the slope under consideration
%% belongs to the training set (iDataSet = 1), validation
%% set (iDataSet = 2) or the test set (iDataSet = 3).
%%
%% Note that the slopes given below are just EXAMPLES.
%% Please feel free to implement your own slopes below,
%% as long as they fulfil the criteria given in HP2.3.
%%
%% You may remove the comments above and below, as they
%% (or at least some of them) violate the coding standard 
%%  a bit. :)
%% The comments have been added as a clarification of the 
%% problem that should be solved!).


function alpha = GetSlopeAngle(x, iSlope, iDataSet)

if (iDataSet == 1)                                % Training
    if (iSlope == 1) 
        alpha = 4 + sin(x/100) + cos(sqrt(2)*x/50);    % You may modify this!
    elseif(iSlope == 2)
        alpha = 1 + sin(x/10) + cos(sqrt(2)*x/500);
    elseif(iSlope == 3)
        alpha = 2 + sin(x/50) + cos(sqrt(5)*x/50);
    elseif(iSlope == 4)
        alpha = 4 + sin(x/250) + cos(sqrt(2)*x/5);
    elseif(iSlope == 5) 
        alpha = 8 + sin(x/2) + cos(sqrt(24)*x/23);
    elseif(iSlope == 6)
        alpha = 4 + sin(x/290) + cos(sqrt(3)*x/5);
    elseif(iSlope == 7)
        alpha = 2 + sin(x/180) + cos(sqrt(5)*x/50);
    elseif(iSlope == 8)
        alpha = 30 + sin(x/10) + cos(sqrt(2)*x/5);
    elseif(iSlope == 9)
        alpha = 22 + sin(x/250) + cos(sqrt(2)*x/30);
    elseif (iSlope== 10)
        alpha = 3 + 2*sin(x/50) + cos(sqrt(2)*x/100);  % You may modify this!
    end 

    % ensure that alpha > 0
    alpha = max(alpha, 0);
    % ensure that alpha < 10
    alpha = min(alpha, 10);

elseif (iDataSet == 2)                            % Validation
    if (iSlope == 1) 
        alpha = 6 - sin(x/100) + cos(sqrt(3)*x/50);    % You may modify this!
    elseif(iSlope == 2)
        alpha = 2 + sin(x/110) + cos(sqrt(2)*x/500);
    elseif(iSlope == 3)
        alpha = 3 + (x^2) + sin(x/40) + cos(sqrt(8)*x/10);
    elseif(iSlope == 4)
        alpha = 4 + cos(sqrt(2)*x/5);
    elseif (iSlope == 5) 
        alpha = 5 + sin(x/50) + cos(x/50);    % You may modify this!
    end 

    % ensure that alpha > 0
    alpha = max(alpha, 0);
    % ensure that alpha < 10
    alpha = min(alpha, 10);

elseif (iDataSet == 3)                           % Test
    if (iSlope == 1) 
        alpha = 6 - sin(x/5) - cos(sqrt(7)*x/50);   % You may modify this!
    elseif(iSlope == 2)
        alpha = 1 + sin(x/84) + cos(sqrt(2)*x/500);
    elseif(iSlope == 3)
        alpha = 2 + sin(x/23) + cos(sqrt(5)*x/14);
    elseif(iSlope == 4)
        alpha = 4 + sin(x^2/230) + cos(sqrt(2)*x/5);
    elseif (iSlope == 5)
        alpha = 4 + (x/1000) + sin(x/70) + cos(sqrt(7)*x/100); % You may modify this!
    end

    % ensure that alpha > 0
    alpha = max(alpha, 0);
    % ensure that alpha < 10
    alpha = min(alpha, 10);

end




