%% Analysis of Irreversible Gillespie Data
% Lara Clemens - lclemens@uci.edu

clear all;
close all;
overwriteTF = 0;
%% Initialize Model Choice

spacing = 3; % 0 = CD3Zeta, 1 = EvenSites, 2 = CD3Epsilon, 3 = TCR
membrane = 1; % 0 for membrane off, 1 for membrane on
phos = 1; % 1 = phosphorylation, 0 = dephosphorylation
itam = 0;


% initialization switch for which model we're inspecting
model = 41; % 1x = stiffening, 2x = electrostatics, 3x = multiple binding - ibEqual

saveRatesPlot = 0;
movieTF = 1;
%% Model Parameters

savefilefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures';

switch spacing
    case 0
        iSiteSpacing = 'CD3Zeta';
    case 1
        iSiteSpacing = 'EvenSites';
    case 2
        iSiteSpacing = 'CD3Epsilon';
    case 3
        iSiteSpacing = 'TCR';
end

if (membrane)
    membraneState = 'On';
else
    membraneState = 'Off';
end

if (phos)
    phosDirection = 'Phos';
else
    phosDirection = 'Dephos';
end

switch (itam)
    case 0
        itamLoc = 'End';
    case 1
        itamLoc = 'Mid';
end

switch (model)
    
    case 41 % Filament Sweep - separation distance 17
        
        % model name
        modelName = 'SimultaneousBinding';
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/FilVSTime/SepDist17/','ITAM_',itamLoc,'/3.Gillespie/Irreversible/','CatFiles/',phosDirection];
        filetitle     = ['IrreversibleGillespie',iSiteSpacing,'Membrane',membraneState,phosDirection];
        
        % save figures location
        savefilesubfolder = ['3.SimultaneousBinding/',iSiteSpacing,'/Membrane',membraneState,'/FilVSTime/SepDist17/','ITAM_',itamLoc,'/Plots/',phosDirection];
        savefilesubsubfolder = [''];
        
        %
        locationTotal = 10;
        NFilSweep = [1 2 3 5 9 10];
        %iSiteTotal(1:NFil) = [1 1 3 3 1 1]; % specify in loop for models
        %40, 41
        sweep = 4:4:20;
        sweepParameter = 'FilamentSweep.NITAM';
        
        % figure parameters
        legendlabels = {[sweepParameter,' = ', num2str(sweep(1))],[sweepParameter,' = ', num2str(sweep(2))],[sweepParameter,' = ', num2str(sweep(3))],[sweepParameter,' = ', num2str(sweep(4))],[sweepParameter,' = ', num2str(sweep(5))]};
        colorIndices = sweep;
        %colors = flipud(cool(max(sweep)));
        colors = flipud(spring(length(sweep))); % use colors from TCR above with bigger range
        ms = 10;
        lw = 1.5;
        modificationLabel = '(Bound)';
        
        GillespieRuns = 1000000000;
        
end

if(~exist(fullfile(savefilefolder,savefilesubfolder,'Data.mat'),'file') || overwriteTF)
    
    %% READ FILES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% READ FILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for nfSweep = 1:length(NFilSweep)
        
        % set NFil, ITAM locations for this iteration
        NFil = NFilSweep(nfSweep);
        disp('NFil:');
        disp(NFil);
        
        switch model
            case {40,41}
                % set up number of ITAMs per filament
                base = floor(locationTotal./NFil);
                extra = mod(locationTotal,NFil);
                iSiteTotal = base.*ones(1,NFil);
                for iExtra = 1:extra
                    iSiteTotal(iExtra) = iSiteTotal(iExtra)+1;
                end
            otherwise
                % keep iSiteTotal from above
        end
        
        disp('iSiteTotal:');
        disp(iSiteTotal);
        
        % start parameter sweep
        for s = 1:length(sweep)
            
            clear M;
            
            % set up filename
            filename = strcat(filetitle,sweepParameter,num2str(sweep(s)),'.NFIL',num2str(NFil),'.AllData')
            
            % read in file
            M = dlmread(fullfile(filefolder,filesubfolder,filename));
            disp(s);
            disp(size(M));
            % read in average times and rates
            transitionTime_Avg(nfSweep,s,1:locationTotal) = M(end-(locationTotal-1):end,2);
            transitionRate_Avg(nfSweep,s,1:locationTotal) = M(end-(locationTotal-1):end,3);
            
        end
        
        switch model
            case {32,33,34,41}
                save_vars = {'transitionTime_Avg','transitionRate_Avg'};
        end
        %% save workspace
        save(fullfile(savefilefolder,savefilesubfolder,'Data.mat'),save_vars{:});
    end
end


%% load workspace
load(fullfile(savefilefolder,savefilesubfolder,'Data.mat'));

%% AVERAGE TRANSITION RATE PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% AVERAGE TRANSITION RATE PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fontName = 'Arial';
fs = 18;
colors = parula(length(sweep));
lw = 2;

%% Plot transition times

NFilData = repmat(NFilSweep',1,size(transitionTime_Avg,2));
ITAMLengthData = repmat(sweep,size(transitionTime_Avg,1),1);

figure(1); clf; hold on;
plotData = reshape(transitionTime_Avg(:,:,6),[size(transitionTime_Avg,1),size(transitionTime_Avg,2)]);
surf(NFilData,ITAMLengthData,log10(plotData));
xlabel1 = 'Number Filaments';
ylabel1 = 'ITAM separation distance';
zlabel1 = 'Average transition time to ith bound';
xlabel(xlabel1,'FontName',fontName,'FontSize',fs);
ylabel(ylabel1,'FontName',fontName,'FontSize',fs);
zlabel(zlabel1,'FontName',fontName,'FontSize',fs);



%% Plot transition rates
NFilData = repmat(NFilSweep',1,size(transitionRate_Avg,2));
ITAMLengthData = repmat(sweep,size(transitionRate_Avg,1),1);


moviename = '~/Desktop/FilSweep_transitionRate_Avg';

if (movieTF)
   Visual3D = VideoWriter(strcat(moviename,'.avi'));
   Visual3D.FrameRate = 5;
   open(Visual3D);
end




for loc = 1:locationTotal
    figure(2); clf; hold on; view([-42, 24]);
    plotData = reshape(transitionRate_Avg(:,:,loc),[size(transitionRate_Avg,1),size(transitionRate_Avg,2)]);
    surf(NFilData,ITAMLengthData,log10(plotData));
    xlim([0 max(NFilSweep)]);
    ylim([0 max(sweep)]);
    zlim([-15 0]);
    xlabel1 = 'Number Filaments';
    ylabel1 = 'ITAM separation distance';
    zlabel1 = 'Average transition time to ith bound';
    xlabel(xlabel1,'FontName',fontName,'FontSize',fs);
    ylabel(ylabel1,'FontName',fontName,'FontSize',fs);
    zlabel(zlabel1,'FontName',fontName,'FontSize',fs);
    
    if (movieTF)
        frame = getframe(gcf);
        writeVideo(Visual3D, frame);
    end
end


% close movie
if (movieTF)
    close(Visual3D);
end

%% Plot transition rates - binding rate vs NFil
NFilData = repmat(NFilSweep',1,size(transitionRate_Avg,2));
ITAMLengthData = repmat(sweep,size(transitionRate_Avg,1),1);


moviename = '~/Desktop/FilSweep_2D_transitionRate_Avg';

if (movieTF)
   Visual3D = VideoWriter(strcat(moviename,'.avi'));
   Visual3D.FrameRate = 5;
   open(Visual3D);
end




for loc = 1:locationTotal
    figure(3); clf; hold on; 
    for s = 1:length(sweep)
        plotData = reshape(transitionRate_Avg(:,:,loc),[size(transitionRate_Avg,1),size(transitionRate_Avg,2)]);
        pL = plot(NFilSweep,log10(plotData(:,s)),'-o');
        pL.Color = colors(s,:);
        pL.LineWidth = lw;
        pL.DisplayName = ['ITAM Spacing = ',num2str(sweep(s))];
    end
        xlim([0 max(NFilSweep)]);
        ylim([-15 0]);
        xlabel1 = 'Number Filaments';
        ylabel1 = 'Average transition time to ith bound';
        xlabel(xlabel1,'FontName',fontName,'FontSize',fs);
        ylabel(ylabel1,'FontName',fontName,'FontSize',fs);

        legend('Location','southwest');
        
        str = [num2str(loc-1),' -> ',num2str(loc)]';
        dim = [0.75 0.15 0.15 0.08];
        annotation('textbox',dim,'String',str','FontSize',fs,'FitBoxToText','on');
    
    if (movieTF)
        frame = getframe(gcf);
        writeVideo(Visual3D, frame);
    end
end


% close movie
if (movieTF)
    close(Visual3D);
end


%%
if(0)
    %% Average Transition Rates VS Number of Modified Sites - No Labels
    
    figure(12); clf; hold on; box on;
    for s=1:length(sweep)
        plot_line = plot(0:1:(locationTotal-1),transitionRate_Avg(s,:)./(locationTotal:-1:1),'-s','LineWidth',lw);
        if (sf==0)
            plot_line.Color = colors(sweep(s)+2,:);
            plot_line.MarkerFaceColor = colors(sweep(s)+2,:);
            plot_line.MarkerSize = 3;
        else
            plot_line.Color = colors(s,:);
            plot_line.MarkerFaceColor = colors(s,:);
            plot_line.MarkerSize = 2;
        end
    end
    
    set(gca,'xlim',[0 locationTotal-1]);
    set(gca,'XTick',0:1:locationTotal-1);
    set(gca,'xticklabel',[]);
    switch model
        case { 32,33,34}
            set(gca,'YScale','log');
            ylim([10^(-10) 10^(0)]);
    end
    set(gca,'yticklabel',[]);
    
    % print position and labels
    pos = get(gca, 'position');
    set(gcf,'units','inches','position',[1,1,3,3]); set(gca,'units','inches','position',[0.5,0.5,1.9,1.9]);
    
    if (saveRatesPlot)
        % % save figure
        savefiletitle = 'AvgTransRateVSNumberModified';
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'fig');
        print('-painters',fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'-depsc');
    end
    
    %% Average Transition Rates VS Number of Modified Sites - Labels
    
    figure(120); clf; hold on; box on;
    for s=1:length(sweep)
        plot_line = plot(0:1:(locationTotal-1),transitionRate_Avg(s,:)./(locationTotal:-1:1),'-s','LineWidth',lw);
        if (sf==0)
            plot_line.Color = colors(sweep(s)+2,:);
            plot_line.MarkerFaceColor = colors(sweep(s)+2,:);
            plot_line.MarkerSize = 3;
        else
            plot_line.Color = colors(s,:);
            plot_line.MarkerFaceColor = colors(s,:);
        end
    end
    switch model
        case {30,31,32,33,34}
            set(gca,'yscale','log');
        otherwise
    end
    xlabel1 = {['Number of Modified Sites'],modificationLabel};
    ylabel1 = {['Average Transition Rate / Unmodified Sites']};
    title1 = 'Average Transition Rate';
    set(gca,'XTick',0:1:locationTotal-1);
    set(gca,'XTickLabel',{'0 -> 1', '1 -> 2', '2 -> 3', '3 -> 4','4 -> 5', '5 -> 6', '6 -> 7', '7 -> 8', '8 -> 9', '9 -> 10'});
    switch model
        case {32,33,34}
            xlim([0 locationTotal-1])
            set(gca,'YScale','log');
            ylim([10^(-10) 10^(0)]);
            
    end
    %set(gcf,'Colormap',colormapName);
    colormap(colormapName);
    
    switch model
        case {32,33,34}
            h = colorbar('Ticks',clims,'TickLabels',{'',''});
            set(h,'ylim',clims);
        otherwise
            h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
            set(h,'ylim',[0 1]);
    end
    
    
    pos = get(gcf, 'position');
    set(gcf,'units','centimeters','position',[1,4,40,30]);
    set(gca,'FontName','Arial','FontSize',30);
    xlabel(xlabel1,'FontName','Arial','FontSize',24);
    ylabel(ylabel1,'FontName','Arial','FontSize',24);
    title(title1,'FontName','Arial','FontSize',24);
    
    if (saveRatesPlot)
        % % save figure
        savefiletitle = 'AvgTransRateVSNumberModifiedLabels';
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'fig');
        print('-painters',fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'-depsc');
    end
end
