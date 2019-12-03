% Script for interfacing with the Rohde&Schwrarz ESA FSEM 1080
% The goal here is to develop a script that will monitor signal frequency over some time period. 
% R. Sheehan 2 - 12 - 2019

% Tell MATLAB where various sub-routines can be located
addpath(genpath('c:/Users/Robert/Programming/MATLAB/Common/'))
addpath(genpath('c:/Users/Robert/Programming/MATLAB/Rohde_Schwarz_ESA/'))

%  Specify resource name and vendor of driver
fsem_addr = 'GPIB1::28::INSTR';
fsem_vendor = 'NI';

% Open VISA connection and set parameters for FSEM 1080
visObj = visa (fsem_vendor, fsem_addr);
fopen (visObj);
set (visObj, 'Timeout', 10);
set (visObj, 'EOSMode', 'read');

% Check that all this is working
% Then add the option to define the length of the frequency scan from the
% cmd line or whatever MATLAB calls it. 

% Configure the ESA for operation
% What are the limits for the SRS Sig Gen? 
fLow = 0.1;
fHigh = 6.0; 
fUnit = 'GHz'; 
FSEM_1080_Configure(visObj, fLow, fHigh, fUnit); 

% Perform frequency sweep over some time interval
Tduration = 60; % duration defined in seconds 
Tincre = 1; % time between measurements defined in seconds
swp_data = FSEM_1080_FSweep(visObj, Tduration, Tincre); 

if size(swp_data(1)) > 1 && size(swp_data(2)) > 1
    % make a plot of the measured data
    figure
    plot(swp_data(1), swp_data(2), 'g--o')
    xlabel('Time (s)')
    ylabel('Frequency (GHz)')
end

% Close VISA connection
disp ('Close VISA connection.');
fclose (visObj);
delete (visObj);
disp ('Connection closed successfully.');