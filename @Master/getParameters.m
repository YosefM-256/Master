function [status,parameterValue] = getParameters(master,parameters)
    mustBeA(master,"Master");
    mustBeMember(parameters,["NMOS Ic" "NMOS Vds"]);
    
end