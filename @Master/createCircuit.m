function createCircuit(ttd,mode)
    panel = ttd.circuitviewPanel;
    mustBeMember(mode,["N" "P"])
    if mode == "N"
        DUTdelta = 0;
        RCdelta = 0;
        L9delta = 0;
        Vcdelta = 0;
        Vedelta = 0;
        IcdeltaY = 0;
        IedeltaY = 0;
        IcdeltaX = 0;
        IedeltaX = 0;
        VRcdelta = 0;
    else 		% mode = P
        DUTdelta = 145;
        RCdelta = -85;
        L9delta = 60;
        Vcdelta = -40;
        Vedelta = 40;
        IcdeltaY = -73;
        IedeltaY = 73;
        IcdeltaX = 5;
        IedeltaX = -5;
        VRcdelta = -100;
    end
    
    ttd.circuitViewObjs.DAC1 = annotation(panel,"textbox",'Units','Pixels','Position',[55 100+DUTdelta 50 30], ...
        "HorizontalAlignment","center","VerticalAlignment","middle", ...
        'String',"-","FontSize",8);
    ttd.circuitViewObjs.L0 = annotation(panel,"Line",'Units','Pixels','Position',[105 115+DUTdelta 30 0]);
    ttd.circuitViewObjs.RBbranch.RB = annotation(panel,"textbox",'Units','Pixels', ...
        'Position',[135 107+DUTdelta 40 16],'String','100',"HorizontalAlignment","center","VerticalAlignment", ...
        "middle","FontSize",6);
    ttd.circuitViewObjs.Ib = annotation(panel,"arrow",'Units','Pixels','Position',[195 120+DUTdelta 30 0]);
    ttd.circuitViewObjs.L5 = annotation(panel,"Line",'Units','Pixels','Position',[175 115+DUTdelta 65 0]);
    ttd.circuitViewObjs.DUT = annotation(panel,"ellipse",'Units','Pixels','Position',[240 95+DUTdelta 40 40]);
    ttd.circuitViewObjs.textDUT = annotation(panel,"textbox",'Units','Pixels','Position',[240 95+DUTdelta 40 40], ...
        "String","DUT","HorizontalAlignment","center","VerticalAlignment","middle",...
        "EdgeColor",'none');
    ttd.circuitViewObjs.EpwrPinBox.ground.L0 = annotation(panel,"Line",'Units','Pixels','Position',[250 30 20 0]);
    ttd.circuitViewObjs.EpwrPinBox.ground.L1 = annotation(panel,"Line",'Units','Pixels','Position',[255 25 10 0]);
    ttd.circuitViewObjs.EpwrPinBox.ground.L2 = annotation(panel,"ellipse",'Units','Pixels','Position',[259 20 2 2]);
    ttd.circuitViewObjs.EpwrPinBox.ground.L3 = annotation(panel,"Line",'Units','Pixels','Position',[260 45 0 -15]);
    ttd.circuitViewObjs.EpwrPinBox.high = annotation(panel,"textbox","Units","pixels","Position", ...
        [240 45 40 -40],"EdgeColor","red","VerticalAlignment","middle","HorizontalAlignment","center", ...
        "String","5V","Color","red","Visible","off");    
    ttd.circuitViewObjs.L6 = annotation(panel,"Line",'Units','Pixels','Position',[260 50 0 -5]);
    ttd.circuitViewObjs.L9 = annotation(panel,"Line",'Units','Pixels','Position',[260 135+L9delta 0 45]);
    ttd.circuitViewObjs.L10 = annotation(panel,"Line",'Units','Pixels','Position',[260 50 0 45]);
    ttd.circuitViewObjs.Ic = annotation(panel,"arrow",'Units','Pixels','Position',[270 170+DUTdelta 0 -30]);
    ttd.circuitViewObjs.Ictext = annotation(panel,"textbox",'Units','Pixels','Position',[285+IcdeltaX 150+DUTdelta+IcdeltaY 20 10] ...
        ,'String',"-","HorizontalAlignment","center","VerticalAlignment","middle","EdgeColor",'none', ...
        "FontSize",8);
    ttd.circuitViewObjs.VcArrow = annotation(panel,"arrow",'Units','Pixels','Position',[294 139+DUTdelta -36 -4],'Color', ...
        'r','HeadStyle','ellipse','HeadLength',4,'HeadWidth',4,'LineStyle',':');
    ttd.circuitViewObjs.Vctext = annotation(panel,"textbox",'Units','Pixels','Position',[304 139+DUTdelta+Vcdelta 20 10] ...
        ,'String',"-","HorizontalAlignment","center","VerticalAlignment","middle","EdgeColor",'none' ...
        ,'Color','r',"FontSize",8);
    ttd.circuitViewObjs.VeArrow = annotation(panel,"arrow",'Units','Pixels','Position',[294 99+DUTdelta -36 -4],'Color', ...
        'r','HeadStyle','ellipse','HeadLength',4,'HeadWidth',4,'LineStyle',':');
    ttd.circuitViewObjs.Vetext = annotation(panel,"textbox",'Units','Pixels','Position',[304 99+DUTdelta+Vedelta 20 10] ...
        ,'String',"-","HorizontalAlignment","center","VerticalAlignment","middle","EdgeColor",'none' ...
        ,'Color','r',"FontSize",8);
    ttd.circuitViewObjs.RC1branch.W1 = annotation(panel,"Line",'Units','Pixels','Position',[260 180+RCdelta 30 0]);
    ttd.circuitViewObjs.RC0branch.W1 = annotation(panel,"Line",'Units','Pixels','Position',[260 180+RCdelta -30 0]);
    ttd.circuitViewObjs.RC1branch.W0 = annotation(panel,"Line",'Units','Pixels','Position',[290 180+RCdelta 0 30]);
    ttd.circuitViewObjs.RC0branch.W0 = annotation(panel,"Line",'Units','Pixels','Position',[230 180+RCdelta 0 30]);
    ttd.circuitViewObjs.RC0branch.RC0 = annotation(panel,"textbox",'Units','Pixels', ...
        'Position',[222 210+RCdelta 16 40],'String','1K',"HorizontalAlignment","center", ...
        "VerticalAlignment","middle","FontSize",6);
    ttd.circuitViewObjs.RC1branch.RC1 = annotation(panel,"textbox",'Units','Pixels', ...
        'Position',[282 210+RCdelta 16 40],'String','10',"HorizontalAlignment","center", ...
        "VerticalAlignment","middle","FontSize",6);
    ttd.circuitViewObjs.RC1branch.W2 = annotation(panel,"Line",'Units','Pixels','Position',[290 250+RCdelta 0 30]);
    ttd.circuitViewObjs.RC0branch.W2 = annotation(panel,"Line",'Units','Pixels','Position',[230 250+RCdelta 0 30]);
    ttd.circuitViewObjs.RC0branch.W3 = annotation(panel,"Line",'Units','Pixels','Position',[260 280+RCdelta -30 0]);
    ttd.circuitViewObjs.RC1branch.W3 = annotation(panel,"Line",'Units','Pixels','Position',[260 280+RCdelta 30 0]);
    ttd.circuitViewObjs.L16 = annotation(panel,"Line",'Units','Pixels','Position',[260 280 0 80]);
    ttd.circuitViewObjs.L17 = annotation(panel,"Line",'Units','Pixels','Position',[260 360 -50 0]);
    ttd.circuitViewObjs.DAC0 = annotation(panel,"textbox",'Units','Pixels','Position',[210 375 -50 -30], ...
        "HorizontalAlignment","center","VerticalAlignment","middle", ...
        'String',"-","FontSize",8);
    ttd.circuitViewObjs.Ibtext = annotation(panel,"textbox",'Units','Pixels','Position',[180 125+DUTdelta 20 10] ...
        ,'String',"-","HorizontalAlignment","center","VerticalAlignment","middle","EdgeColor",'none' ...
        ,"FontSize",8);
    ttd.circuitViewObjs.VbArrow = annotation(panel,"arrow",'Units','Pixels', ...
        'Position',[230 95+DUTdelta 9 21],'Color','r','HeadStyle','ellipse','HeadLength',4, ...
        'HeadWidth',4,'LineStyle',':');
    ttd.circuitViewObjs.Vbtext = annotation(panel,"textbox",'Units','Pixels','Position',[200 85+DUTdelta 20 10] ...
        ,'String',"-","HorizontalAlignment","center","VerticalAlignment","middle","EdgeColor",'none' ...
        ,'Color','r',"FontSize",8);
    ttd.circuitViewObjs.Vcbtext = annotation(panel,"textbox",'Units','Pixels','Position',[40 180 100 10] ...
        ,'String',"Vcb = -","HorizontalAlignment","left","VerticalAlignment","middle","EdgeColor",'none' ...
        ,"FontSize",8,'Color','red');
    ttd.circuitViewObjs.Vcetext = annotation(panel,"textbox",'Units','Pixels','Position',[40 165 100 10] ...
        ,'String',"Vce = -","HorizontalAlignment","left","VerticalAlignment","middle","EdgeColor",'none' ...
        ,"FontSize",8,'Color','red');
    ttd.circuitViewObjs.Vbetext = annotation(panel,"textbox",'Units','Pixels','Position',[40 150 100 10] ...
        ,'String',"Vbe = -","HorizontalAlignment","left","VerticalAlignment","middle","EdgeColor",'none' ...
        ,"FontSize",8,'Color','red');
    ttd.circuitViewObjs.Ie = annotation(panel,"arrow",'Units','Pixels','Position',[275 90+DUTdelta 0 -30]);
    ttd.circuitViewObjs.Ietext = annotation(panel,"textbox",'Units','Pixels','Position',[290+IedeltaX 82+DUTdelta+IedeltaY 100 10] ...
        ,'String',"-","HorizontalAlignment","left","VerticalAlignment","middle","EdgeColor",'none' ...
        ,"FontSize",8);
    ttd.circuitViewObjs.VRc0Arrow = annotation(panel,"arrow","Units",'pixels',...
        'Position',[230 280+RCdelta+VRcdelta -25 5],'Color','r','HeadStyle','ellipse','HeadLength',4, ...
        'HeadWidth',4,'LineStyle',':');
    ttd.circuitViewObjs.VRc0text = annotation(panel,"textbox",'Units','Pixels','Position', ...
        [160 280+RCdelta+VRcdelta 100 10],'String',"Vcb = -","HorizontalAlignment","left","VerticalAlignment","middle","EdgeColor",'none' ...
        ,"FontSize",8,'Color','red');
    ttd.circuitViewObjs.VRc1Arrow = annotation(panel,"arrow","Units",'pixels',...
        'Position',[290 280+RCdelta+VRcdelta 25 5],'Color','r','HeadStyle','ellipse','HeadLength',4, ...
        'HeadWidth',4,'LineStyle',':');
    ttd.circuitViewObjs.VRc1text = annotation(panel,"textbox",'Units','Pixels','Position', ...
        [315 280+RCdelta+VRcdelta 100 10],'String',"Vcb = -","HorizontalAlignment","left","VerticalAlignment","middle","EdgeColor",'none' ...
        ,"FontSize",8,'Color','red');
    ttd.circuitViewObjs.VRbArrow = annotation(panel,"arrow",'Units','Pixels', ...
        'Position',[115 95+DUTdelta 9 21],'Color','r','HeadStyle','ellipse','HeadLength',4, ...
        'HeadWidth',4,'LineStyle',':');
    ttd.circuitViewObjs.VRbtext = annotation(panel,"textbox",'Units','Pixels','Position',[85 85+DUTdelta 20 10] ...
        ,'String',"-","HorizontalAlignment","center","VerticalAlignment","middle","EdgeColor",'none' ...
        ,'Color','r',"FontSize",8);
    ttd.circuitViewObjs.RCnum = -1;
    ttd.circuitViewObjs.RBnum = -1;
    ttd.circuitViewObjs.IbArrowDirection = 1;
    ttd.circuitViewObjs.mode = mode;
    ttd.circuitViewObjs.cLevel = 0;
    
    ttd.circuitViewObjs.ADCs = matlab.graphics.shape.TextBox.empty(8,0);
    for i = 0:1
        for j = 1:4
            ttd.circuitViewObjs.ADCs(i*4+j) = annotation(panel,"textbox",'Units','Pixels','Position', ...
            [25+100*i 500-20*j 100 10],'String',"-","HorizontalAlignment","left","VerticalAlignment","middle","EdgeColor",'none' ...
            ,"FontSize",8,'Color','blue');
        end
    end
end
