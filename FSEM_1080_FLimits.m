function FSEM_1080_FLimits(visObj, fLow, fHigh, fUnit)

% Define the start and stop frequencies for a sweep
% Tell the ESA what units to use
% fUnit must be string of the form kHz, MHz, GHz
% FREQ is part of the SENS subsystem of the ESA
% R. Sheehan 12 - 1 - 2019

c1 = strcmp(fUnit,'MHZ') || strcmp(fUnit,'GHZ'); % ensure units are correctly defined
c2 = fLow < fHigh; % ensure limits are correctly defined

if c1 && c2
    % assign the frequency scan limits
    fprintf (visObj, ['FREQ:START ', num2str(fLow), fUnit]);
    fprintf (visObj, ['FREQ:STOP ', num2str(fHigh), fUnit]);
else
    % apply default limits
    fprintf (visObj, 'FREQ:START 10MHz');
    fprintf (visObj, 'FREQ:STOP 10GHz');
end

end % end sub-routine