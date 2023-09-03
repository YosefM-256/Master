function updateCircuit(master,parameters)
    assert(class(master) == "Master");
    
    if (parameters.mode ~= master.circuitViewObjs.mode)
        updateSmode();
    end
    
    if ((parameters.mode == "P") && (parameters.collectorLevel ~= master.circuitViewObjs.cLevel))
        updateClevel();
    end
    
    if (parameters.RC ~= master.circuitViewObjs.RCnum)
        updateRes();
    end

    master.circuitViewObjs.DAC0.String = [string(parameters.DAC0) ...
        string(parameters.DAC0*master.DACbinToVolt(1))];
    master.circuitViewObjs.DAC1.String = [string(parameters.DAC1) ...
        string(parameters.DAC1*master.DACbinToVolt(2))];
    
    master.circuitViewObjs.Ibtext.String = string(parameters.Ib);
    master.circuitViewObjs.Ictext.String = string(parameters.Ic);
    master.circuitViewObjs.Ietext.String = string(parameters.Ie);

    master.circuitViewObjs.Vbtext.String = string(parameters.Vb);
    master.circuitViewObjs.Vctext.String = string(parameters.Vc);
    master.circuitViewObjs.Vetext.String = string(parameters.Ve);

    master.circuitViewObjs.VRc0text.String = string(parameters.VRc0);
    master.circuitViewObjs.VRc1text.String = string(parameters.VRc1);
    master.circuitViewObjs.VRbtext.String = string(parameters.VRb);
    
    master.circuitViewObjs.Vbetext.String = strjoin(["Vbe =" string(parameters.Vb-parameters.Ve)]);
    master.circuitViewObjs.Vcetext.String = strjoin(["Vce =" string(parameters.Vc-parameters.Ve)]);
    master.circuitViewObjs.Vcbtext.String = strjoin(["Vcb =" string(parameters.Vc-parameters.Vb)]);

    drawnow('limitrate');

    for i = 1:8
        master.circuitViewObjs.ADCs(i).String = ...
        strjoin(["ADC" string(i-1) " = " string(parameters.ADCvalues(i))],'');
    end

    function updateSmode()
        mustBeMember(parameters.mode,["N" "P"]);
        delete(master.circuitViewObjs.L6.Parent);
        master.createCircuit(parameters.mode);
        
    end

    function updateClevel()
        mustBeMember(parameters.collectorLevel,[0 1]);
        if (parameters.collectorLevel == 1)
            set(struct2array(master.circuitViewObjs.EpwrPinBox.ground),'Visible','off');
            set(master.circuitViewObjs.EpwrPinBox.high,'Visible','on');
        else
            set(struct2array(master.circuitViewObjs.EpwrPinBox.ground),'Visible','on');
            set(master.circuitViewObjs.EpwrPinBox.high,'Visible','off');
        end
        master.circuitViewObjs.cLevel = parameters.collectorLevel;
    end    
    
    function updateRes()
        for i=0:1
            resistor = strjoin(["RC" num2str(i) "branch"], '');
            if parameters.RC==i
                set(struct2array(master.circuitViewObjs.(resistor)),'Color','g','LineWidth',2,'LineStyle','-');
                master.circuitViewObjs.(resistor).(strjoin(["RC" num2str(i)], '')).EdgeColor = 'g';
            else
                set(struct2array(master.circuitViewObjs.(resistor)),'Color','black','LineWidth',0.5,'LineStyle',':');
                master.circuitViewObjs.(resistor).(strjoin(["RC" num2str(i)], '')).EdgeColor = 'b';
            end
        end
    end
end