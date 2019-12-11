function v = FSEM_1080_FSweep(visObj, Tduration, Tincre)
% Measure the frequency and power levels over a time interval of length
% Tduration in steps of Tincre, assumed to be in seconds
% R. Sheehan 2 - 12 - 2019

swps = Validate_Sweep_Params(0.0, Tduration, Tincre);

if swps(1) == 1
    disp('Sweep can proceed');
    
    %Tvals = zeros(swps(2), 1); % Make an array of swps(2) rows and 1 column
    %Fvals = zeros(swps(2), 1); % Make an array of swps(2) rows and 1 column
    %Pvals = zeros(swps(2), 1); % Make an array of swps(2) rows and 1 column
    
    v = zeros(swps(2),3); % Make an array of swps(2) rows and 3 column
    
    time = 0.0; 
    for i=1:swps(2)
        %Tvals(i) = time; 
        v(i,1) = time; 
        reading = FSEM_1080_Peak(visObj); 
        %Fvals(i) = reading(1); 
        %Pvals(i) = reading(2); 
        v(i,2) = reading(1); 
        v(i,3) = reading(2); 
        time = time + Tincre; 
        pause(Tincre); % pause between measurements
    end
    
    disp('Sweep complete');
    
    % No sense in storing the data twice
    %v(:,1) = Tvals; % store data in column 1
    %v(:,2) = Fvals; % store data in column 2
    %v(:,3) = Pvals; % store data in column 3
else
    disp('Sweep cannot proceed');
    disp('Sweep parameters not valid');
    v = zeros(3,3); 
    v(:,1) = zeros(3, 1); 
    v(:,2) = zeros(3, 1); 
    v(:,3) = zeros(3, 1);
end

end