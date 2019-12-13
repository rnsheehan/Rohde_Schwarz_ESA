% Script for interfacing with the Rohde&Schwrarz ESA FSEM 1080
% The goal here is to develop a script that will monitor signal frequency over some time period. 
% R. Sheehan 2 - 12 - 2019

% Tell MATLAB where various sub-routines can be located
addpath(genpath('c:/Users/Robert/Programming/MATLAB/Common/'))
addpath(genpath('c:/Users/Robert/Programming/MATLAB/Rohde_Schwarz_ESA/'))

HOME = pwd; 

DATA_HOME = 'c:\Users\Robert\Research\CAPPA\Data\ESA_Test\';

% It seems that vinfo = instrhwinfo('visa','keysight');
% followed by vinfo.ObjectConstructorName can tell you what's communicating
% with the machine

% out = instrhwinfo returns hardware information to the structure out

% each time you start the script find any open comm lines
% and close them if they are open
% this is especially useful if you are debugging
% this can probably be refined to close a specific instance of an open comm
% line but it will suffice for now
out = instrfind; % find all open comms, instrfind returns all valid instrument objects as an array to out
if not(isempty(out))
    fclose(out); % close them all
end

%  Specify resource name and vendor of driver
fsem_addr = 'GPIB1::28::INSTR';
fsem_vendor = 'ni';

% Open VISA connection and set parameters for FSEM 1080
visObj = visa('ni', 'GPIB1::28::INSTR');
fopen (visObj);
set (visObj, 'Timeout', 10);
set (visObj, 'EOSMode', 'read');

% Check that all this is working
% Then add the option to define the length of the frequency scan from the
% cmd line or whatever MATLAB calls it. 

% Configure the ESA for operation
% What are the limits for the SRS Sig Gen? 
fLow = 0.1;
fHigh = 18.0; % this is the current bandwidth limit on the DC block attached to the ESA
fUnit = 'GHz'; 
FSEM_1080_Configure(visObj, fLow, fHigh, fUnit); 

% Read the TLS wavelength from the user
lambdaTLS = input('Input TLS wavelength: ');

freq_data_file = strcat('F_Swp_LTLS_',strrep(num2str(lambdaTLS),'.','_'),'.txt'); 

% Perform frequency sweep over some time interval
Tduration = 60; % duration defined in seconds 
Tincre = 0.5; % time between measurements defined in seconds
swp_data = FSEM_1080_FSweep(visObj, Tduration, Tincre);

% send the sweep data to a file
cd DATA_HOME
dlmwrite(freq_data_file, swp_data, 'delimiter', ',', 'precision', '%0.5f')
cd HOME

fbar = mean(swp_data(:,2)); 
fstdev = std(swp_data(:,2)); 
frange = 0.5*(max(swp_data(:,2)) - min(swp_data(:,2))); 

disp('Measurement Results');
disp('<f> / GHz, \sigma_{f} / GHz, \delta f / GHz')
disp( strcat(num2str(fbar), ', ', num2str(fstdev), ', ', num2str(frange)) ); 

% Make the plot if you want
MAKE_PLOT = 1;

if MAKE_PLOT
    if length(swp_data(:,1)) > 1 && length(swp_data(:,2)) > 1
        % make a plot of the measured data
        figure
        plot(swp_data(:,1), swp_data(:,2), 'g--o')
        xlabel('Time (s)')
        ylabel('Frequency (GHz)')    
    end
end

% Close VISA connection
disp ('Close VISA connection.');
fclose (visObj);
delete (visObj);
disp ('Connection closed successfully.');