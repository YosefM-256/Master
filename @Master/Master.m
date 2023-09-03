classdef Master < TTD %handle
    properties (SetObservable=true)
        DAC0                 {mustBeInteger,mustBeInRange(DAC0,0,4095)} = 0     
        DAC1                 {mustBeInteger,mustBeInRange(DAC1,0,4095)} = 0
        DAC0out              {mustBeInteger,mustBeInRange(DAC0out,0,4095)} = 0
        DAC1out              {mustBeInteger,mustBeInRange(DAC1out,0,4095)} = 0
        precision           = 8
        delay               = 63
        uc      uController
        operatingMode       {mustBeMember(operatingMode,["MEAS" "WILD"])} = "WILD"          % MEAS or WILD
        mode                {mustBeMember(mode,["P" "N"])} = "N"                            % N or P mode
        RC                  {mustBeMember(RC,[1 0])} = 0   % 1 0
        collectorLevel      {mustBeMember(collectorLevel,[1 0])} = 0                        % 1 for high, 0 for gnd
        switches      (1,5) {mustBeMember(switches,[1 0])} = [0 0 0 0 0]                    % 1 or 0 - follows the scheme
        switchesPolarity (1,5)   {mustBeMember(switchesPolarity,[1 0])} = [0 0 0 0 0]       % 0 for direct, 1 for inverse
        switchesPlacement  (1,5) struct = struct('port',{3,3,3,3,3},'pin',{2,3,4,5,6})      % array of structs to keep the placement of each pin  
        DACorder      (1,2) {mustBeMember(DACorder,[0 1])} = [0 1]                          % [0 1] or [1 0]
        DACbinToVolt  (1,2) {mustBeNumeric} = repmat(10/4096,1,2)
        ADCorder      (1,8) {mustBeMember(ADCorder,[0:7])} = [0:7]                          % the ADC number (on the ucontroller) of each ADC in the schematic  
        ADCbinToVolt  (1,8) {mustBeNumeric} = repmat(10/4096*1.25,1,8)
        runs                = {}
        constantCircuitUpdate      logical = 1
    end

    methods 


        function master = Master()
            master.declareCallBacks();
            master.createCircuit(master.mode);
        end

        function setupuController(master, port)
            assert(class(master) == "Master");
            mustBeText(port);
            mustBeMember(port,serialportlist("available"));

            master.uc = uController(port);
        end

        function startBoard(master)
            assert(isequal(sort(master.DACorder),[0 1]),"error in DACorder");
            assert(isequal(sort(master.ADCorder),[0:7]),"error in ADCorder");
            if (master.operatingMode == "WILD")
                master.uc.beginMessage();
                master.uc.addBytesToMessage(CsetDAC(master.schemeTouc('DAC',0),master.DAC0out));
                master.uc.addBytesToMessage(CsetDAC(master.schemeTouc('DAC',0),master.DAC1out));
                for sw = 0:4
                    ucSPort = master.schemeTouc("switchPort",sw);
                    ucSwPin = master.schemeTouc("switchPin",sw);
                    ucSwState = master.schemeTouc("switchState",sw);
                    master.uc.addBytesToMessage(CsetPin(ucSPort,ucSwPin,ucSwState));
                end
                master.uc.sendMessage();
                [status,~] = master.uc.read();
                assert(status == "OK");
            end
            if (master.operatingMode == "MEAS")
                master.setOPmode("MEAS");
            end

            % needs to add option for MEAS operating mode
        end

        function ADCvalue = getADC(master,ADCnum,valueFormat)
            arguments
                master  Master
                ADCnum          {mustBeMember(ADCnum,[0:7])}
                valueFormat     {mustBeMember(valueFormat,["binary" "voltage"])}
            end
            ucADCnum = master.schemeTouc("ADC",ADCnum);
            ADCvalue = master.uc.getADC(ucADCnum,master.precision);
            if (valueFormat == "voltage")
                ADCvalue = ADCnum*master.ADCbinToVolt(ADCnum);
            end
        end

        function setDACimmediate(master,DACnum,DACvalue)
            arguments
                master  Master
                DACnum          {mustBeMember(DACnum,[0 1])}
                DACvalue        {mustBeInteger,mustBeInRange(DACvalue,0,4095)}
            end
            assert(master.operatingMode == 'WILD')
            ucDACnum = master.schemeTouc("DAC",DACnum);
            master.uc.setDAC(ucDACnum,DACvalue);
            switch DACnum
                case 0
                    master.DAC0 = DACvalue;
                case 1
                    master.DAC1 = DACvalue;
            end
        end

        function setDAC(master,DACnum,DACvalue)
            arguments
                master  Master
                DACnum          {mustBeMember(DACnum,[0 1])}
                DACvalue        {mustBeInteger,mustBeInRange(DACvalue,0,4095)}
            end
            switch DACnum
                case 0
                    master.DAC0 = DACvalue;
                case 1
                    master.DAC1 = DACvalue;
            end
        end

        % doesn't yet includes support for firstIn and firstOut
        function ADCvalues = setGetNout(master,delay)
            arguments
                master  Master
                delay       {mustBeNumeric,mustBeInRange(delay,0,63)}
            end
            mustBeInteger(delay*2);
            
            DACvals = [master.DAC0, master.DAC1];
            DACoutVals = [master.DAC0out, master.DAC1out];
            ucDAC0ind = master.schemeTouc("DAC",0);
            ucDAC1ind = master.schemeTouc("DAC",1);

            ucADCvalues = master.uc.setGetNout(master.precision, delay, DACvals(ucDAC0ind+1), DACvals(ucDAC1ind+1), ...
                                               DACoutVals(ucDAC0ind+1), DACoutVals(ucDAC1ind+1), "DAC0", "DAC0");
            ADCvalues = ucADCvalues(master.ADCorder+1);
        end
        
        function setOPmode(master,opMode,mode,collectorLevel)
            assert(class(master)=="Master");
            mustBeMember(opMode,["MEAS" "WILD"]);
            if (opMode == "MEAS")
                if exist('mode','var')
                    mustBeMember(mode,["N" "P"]);
                    if (mode == "P")
                        if exist('collectorLevel','var')
                            mustBeMember(collectorLevel,[0 1]);
                            master.collectorLevel = collectorLevel;
                        end
                    end
                    master.mode = mode;
                end
                if (master.operatingMode == "WILD")
                    oldDAC0 = master.DAC0;
                    oldDAC1 = master.DAC1;
                    master.setDACimmediate(0,master.DAC0out);
                    master.setDACimmediate(1,master.DAC1out); 
                    master.setDAC(0,oldDAC0);
                    master.setDAC(1,oldDAC1);
                end
            end
            master.operatingMode = opMode;
            master.modesToSwitches();
            master.enforceSwitches();
        end
         
        function enforceSwitches(master)
            assert(class(master) == "Master");
            master.uc.beginMessage();
            for sw = 0:4
                ucSPort = master.schemeTouc("switchPort",sw);
                ucSwPin = master.schemeTouc("switchPin",sw);
                ucSwState = master.schemeTouc("switchState",sw);
                master.uc.addBytesToMessage(CsetPin(ucSPort,ucSwPin,ucSwState));
            end
            master.uc.sendMessage();
            [status,~] = master.uc.read();
            assert(status == "OK");
        end

        function modesToSwitches(master)
            assert(class(master) == "Master");
            if (master.mode == "N")
                assert(master.collectorLevel == 0);
            end
            switch master.mode
                case "N"
                    master.switches([0,1,3,4]+1) = [0 0 0 0];
                case "P"
                    master.switches([0,3]+1) = [1 1];
                    switch master.collectorLevel
                        case 0
                            master.switches([1,4]+1) = [1,0];
                        case 1
                            master.switches([1,4]+1) = [0,1];
                    end
            end
            switch master.RC
                case 0
                    master.switches(2+1) = 0;
                case 1
                    master.switches(2+1) = 1;
            end
        end

        function setMode(master, mode)
            arguments
                master      Master
                mode            {mustBeMember(mode,["N" "P"])}
            end
            master.mode = mode;
            switch mode
                case "N"
                    master.switches([0,1,3,4]+1) = [0 0 0 0];
                case "P"
                    master.setCollectorLevel(master.collectorLevel);
                    master.switches([0,3]+1) = [1 1];
            end
            master.enforceSwitches();
        end

        function setSwitch(master, switchNum, switchState)
            assert(class(master)=="Master");
            assert(master.operatingMode == "WILD","cannot change the state of the switches directly in MEAS operating mode");
            setSwitchP(master, switchNum, switchState);
        end

        function setRC(master,RCnum)
            arguments
                master      Master
                RCnum           {mustBeMember(RCnum,[0 1])}
            end
            master.setSwitchP(2,RCnum)
            master.RC = RCnum;
        end

        function setCollectorLevel(master,collectorLevel)
            arguments
                master  Master
                collectorLevel {mustBeMember(collectorLevel,[0 1])}
            end
            master.setSwitchP(1,collectorLevel)
            master.setSwitchP(4,~collectorLevel);
            master.collectorLevel = collectorLevel;
        end

        function ucNum = schemeTouc(master,schemeElement,schemeNum)
            arguments
                master          Master
                schemeElement   {mustBeMember(schemeElement,["ADC" "DAC" "switchPort" "switchPin" "switchState"])}
                schemeNum
            end
            switch schemeElement
                case "DAC"
                    mustBeMember(schemeNum,[0 1]);
                    ucNum = master.DACorder(schemeNum+1);
                case "ADC"
                    mustBeMember(schemeNum,[0:7]);
                    ucNum = master.ADCorder(schemeNum+1);
                case "switchPort"
                    mustBeMember(schemeNum,[0:4]);
                    ucNum = master.switchesPlacement(schemeNum+1).port;
                case "switchPin"
                    mustBeMember(schemeNum,[0:4]);
                    ucNum = master.switchesPlacement(schemeNum+1).pin;
                case "switchState"
                    mustBeMember(schemeNum,[0:4]);
                    ucNum = xor(master.switches(schemeNum+1), master.switchesPolarity(schemeNum+1));
            end
        end

        function recreateFigure(master)
            master.TTD.delete();
            master.TTD = TTD();
        end
    end

    methods (Access = private)

        function setSwitchP(master, switchNum, switchState)
            arguments
                master  Master
                switchNum       {mustBeMember(switchNum,[0:4])}
                switchState     {mustBeMember(switchState,[0 1])}
            end
            master.switches(switchNum+1) = switchState;
            ucSwPort = master.schemeTouc("switchPort",switchNum);
            ucSwPin = master.schemeTouc("switchPin",switchNum);
            ucSwState = master.schemeTouc("switchState",switchNum);
            master.uc.setPin(ucSwPort,ucSwPin,ucSwState);
        end
    end

end
    
     

