function Hs = createAndLayoutMainGUI()
    figH = figure('Position',[200 200 775 600],...
        'NumberTitle','off',...
        'Name','Shift GUI',...
        'Resize','on',...
        'Toolbar','none',...
        'MenuBar','none',...
        'Color',[0.247 0.247 0.247],...
        'Visible','on');
    Hs = guihandles(figH);
    Hs.figH = figH;
    Hs.bottomPanel = uipanel('Parent',figH,...
        'Units','normalized',...
        'BorderType','etchedin',...
        'BackgroundColor',[0.247 0.247 0.247],...
        'Visible','on',...
        'Position',[0.05,0.01,0.639,0.10]);
    Hs.imgAx = axes('Parent',figH,...
        'Units','normalized',...
        'Position',[0.05,0.12,.639,.86],...
        'YDir','reverse',...
        'XTick',[],'YTick',[],...
        'Color',[1,1,1]);
    axis equal;
    Hs.nextButton  = uicontrol('Parent',Hs.bottomPanel,...
        'String','Next',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.01 0.50 0.188 0.45],...
        'TooltipString','next set of images',...
        'BackgroundColor',[1 1 1]);
    Hs.prevButton  = uicontrol('Parent',Hs.bottomPanel,...
        'String','Previous',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'TooltipString','previous set of images',...
        'Units','normalized',...
        'Position',[0.01 0.05 0.188 0.45],...
        'BackgroundColor',[1 1 1]);
    Hs.randomButton  = uicontrol('Parent',Hs.bottomPanel,...
        'String','Random',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'TooltipString','view random location',...
        'Units','normalized',...
        'Position',[0.208 0.05 0.188 0.45],...
        'BackgroundColor',[1 1 1]);
    Hs.analyzeButton  = uicontrol('Parent',Hs.bottomPanel,...
        'String','Analyze',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'TooltipString','open image in new figure window',...
        'Units','normalized',...
        'Position',[0.406 0.05 0.188 0.90],...
        'BackgroundColor',[1 1 1]);
    Hs.borderCheck = uicontrol('Parent',Hs.bottomPanel,...
        'Style','checkbox',...
        'String','Borders',...
        'FontSize',10,...
        'Enable','on',...
        'Value',0,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.604 0.50 0.188 0.45],...
        'ForegroundColor',[1 1 1],...
        'BackgroundColor',[0.247 0.247 0.247]);
    Hs.contrastButton = uicontrol('Parent',Hs.bottomPanel,...
        'Style','toggle',...
        'String','Contrast',...
        'FontSize',10,...
        'TooltipString','increase contrast of display',...
        'Enable','on',...
        'Value',0,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.604 0.05 0.188 0.45],...
        'BackgroundColor',[1 1 1]);
    Hs.foundChannels = [mat2cell('dapi')];
    for channel = Hs.foundChannels
        if ~strcmp(cell2mat(channel),'dapi')
            Hs.foundChannels = [Hs.foundChannels,channel];
        end
    end
    Hs.positionTextBox  = uicontrol('Parent',Hs.bottomPanel,...
        'String','1 - 1 (row-col)',...
        'Style','text',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.802 0.51 0.188 0.44],...
        'BackgroundColor',[1 1 1]);    %Draw the grid
    Hs.chanDropDown  = uicontrol('Parent',Hs.bottomPanel,...
        'Style','popup',...
        'String',Hs.foundChannels,...0.225
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.802 0.05 0.188 0.44],...
        'ForegroundColor',[1 1 1],...
        'BackgroundColor',[0.247 0.247 0.247]);
    %----------------------------------------------------------------------
    % SIDE PANEL
    %----------------------------------------------------------------------
    Hs.rightPanel = uipanel('Parent',figH,...
        'Units','normalized',...
        'BorderType','etchedin',...
        'BackgroundColor',[0.247 0.247 0.247],...
        'Visible','on',...
        'Position',[0.715,0.12,0.25,0.86]);
    Hs.bringFrontButton  = uicontrol('Parent',Hs.rightPanel,...
        'String','Bring to Front',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.175 0.555 0.65 0.06],...
        'BackgroundColor',[1 1 1]);    %Draw the grid
    Hs.processTilesButton  = uicontrol('Parent',Hs.rightPanel,...
        'String','Process Tiles',...
        'TooltipString','create new image files with current shifts',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.175 0.465 0.65 0.06],...
        'BackgroundColor',[1 1 1]);    %Draw the grid
    Hs.selectButton  = uicontrol('Parent',Hs.rightPanel,...
        'String','Exit',...
        'Style','toggle',...
        'TooltipString','Close GUI',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.175 0.375 0.65 0.06],...
        'BackgroundColor',[1 1 1]);

end