% reqs includes requirements as to the precision, maxId, maxVds etc.

function [status, results, measurements] = plotVdsIdNMOS(master, VgsList, DAC0set) 
    arguments
        master  Master
        VgsList     {mustBeNumeric,mustBeInRange(VgsList,0,10)}
        DAC0set     {mustBeNumeric,mustBeInRange(DAC0set,0,4095)}
    end
end