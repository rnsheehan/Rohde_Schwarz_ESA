function v = FSEM_1080_FSweep(visObj, Tduration, Tincre)
% Measure the frequency and power levels over a time interval of length
% Tduration in steps of Tincre, assumed to be in seconds
% R. Sheehan 2 - 12 - 2019

swps = Validate_Sweep_Params(0.0, Tduration, Tincre);

if swps(1) == True
    disp('Sweep can proceed');
    
    Tvals = zeros(swps(2), 1);
    Fvals = zeros(swps(2), 1);
    Pvals = zeros(swps(2), 1);
    
    time = 0.0; 
    for i=1:swps(2)
        Tvals(i) = time; 
        reading = FSEM_1080_Peak(visObj); 
        Fvals(i) = reading(1); 
        Pvals(i) = reading(2); 
        time = time + Tincre; 
    end
    
    v = [Tvals, Fvals, Pvals]; 
else
    disp('Sweep cannot proceed');
    disp('Sweep parameters not valid');
    v = [zeros(1,1), zeros(1,1), zeros(1,1)]; 
end

end