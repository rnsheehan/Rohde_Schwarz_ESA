function FSEM_1080_Configure(visObj, fLow, fHigh, fUnit)

% Define the start and stop frequencies for a sweep
% Tell the ESA what power units to use
% R. Sheehan 12 - 1 - 2019

fprintf (visObj, 'UNIT:POW DBM'); % Tell the ESA what power units to use on vertical scale

fprintf (visObj, 'DISP:TRAC:Y:RLEV 0dBm'); % Tell the ESA what the reference level should be

FSEM_1080_FLimits(visObj, fLow, fHigh, fUnit); 

end % end sub-routine