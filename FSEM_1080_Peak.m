function v = FSEM_1080_Peak(visObj)

% Function for performing a peak search on a trace to locate the max
% frequency
% R. Sheehan 2 - 12 - 2019

% Need two commands to initiate peak search
fprintf (visObj, 'CALC:MARKER ON;MARKER:MAX'); % Turn on the marker, locate the max value
freq = str2double (query (visObj, 'CALC:MARK:X?')); % Request frequency and level
power = str2double (query (visObj, 'CALC:MARK:Y?')); % Request power level

v = [(freq/1.0E+9), power]; 

end
