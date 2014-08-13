%--------------------------------------------------------------------------
% getImageOverlap determines the overlap between the images.  It eliminates
% overlap pixels from the bottom and right side of each image - same
% technique as is used by DensityGUI when processing the images
%--------------------------------------------------------------------------
function Hs = getImageOverlap(Hs)
    Td = populateGUI(Hs);
    Td.currRow = 1;
    Td.currCol = 1;
    Td.chanIndex = 1;
    Td.rows = Hs.rows;
    Td.cols = Hs.cols;
    Td.filePaths = Hs.filePaths;
    Td.overlap = 100;
    Td.tilesShifted = false;
    Td.shiftTilesCalled = false;
    Td.contrastValue = 1;
 
    Td = displayImages(Td);
    
    guidata(Td.figH,Td);
    uiwait(Td.figH);
    %uiresume(Td.figH) is called when select or exit called and then code
    %that is below is executed  
    Td = guidata(Td.figH);
    %Following fields added to Hs structure to communicate with DensityGUI
    Hs.tilesShifted = Td.tilesShifted;
    Hs.shiftTilesCalled = Td.shiftTilesCalled;
    Hs.overlap = Td.overlap;
    delete(Td.figH);
end

function Td = populateGUI(Hs)
    figH = figure('Position',[200 200 700 650],...
        'NumberTitle','off',...
        'Name','Overlap GUI',...
        'Resize','on',...
        'Toolbar','none',...
        'MenuBar','none',...
        'Color',[0.247 0.247 0.247],...
        'CloseRequestFcn',@closeRequestCallBack,...
        'Visible','on');
    Td = guihandles(figH);
    Td.figH = figH;
    Td.bottomPanel = uipanel('Parent',figH,...
        'Units','normalized',...
        'BorderType','etchedin',...
        'BackgroundColor',[0.247 0.247 0.247],...
        'Visible','on',...
        'Position',[0.05,0.01,0.86,0.10]);
    Td.imgAx = axes('Parent',figH,...
        'Units','normalized',...
        'Position',[0.05,0.12,.86,.86],...
        'YDir','reverse',...
        'XTick',[],'YTick',[],...
        'Color',[1,1,1]);

    axis equal;

    Td.nextButton  = uicontrol('Parent',Td.bottomPanel,...
        'String','Next',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.01 0.45 0.13 0.45],...
        'BackgroundColor',[1 1 1],...
        'Callback',@nextSetCallBack);
    Td.prevButton  = uicontrol('Parent',Td.bottomPanel,...
        'String','Previous',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.01 0.05 0.13 0.45],...
        'BackgroundColor',[1 1 1],...
        'Callback',@prevSetCallBack);
    Td.analyzeButton  = uicontrol('Parent',Td.bottomPanel,...
        'String','Analyze',...
        'Style','toggle',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.15 0.45 0.13 0.45],...
        'BackgroundColor',[1 1 1],...
        'Callback',@analyzeButtonCallBack);
    Td.randomButton  = uicontrol('Parent',Td.bottomPanel,...
        'String','Random',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.15 0.05 0.13 0.45],...
        'BackgroundColor',[1 1 1],...
        'Callback',@randomButtonCallBack);
    Td.selectButton  = uicontrol('Parent',Td.bottomPanel,...
        'String','Select',...
        'Style','toggle',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.29 0.05 0.13 0.9],...
        'BackgroundColor',[1 1 1],...
        'Callback',@selectButtonCallBack);
    Td.borderCheck = uicontrol('Parent',Td.bottomPanel,...
        'Style','checkbox',...
        'String','Borders',...
        'FontSize',10,...
        'Enable','on',...
        'Value',0,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.43 0.50 0.13 0.45],...
        'ForegroundColor',[1 1 1],...
        'BackgroundColor',[0.247 0.247 0.247],...
        'Callback',@borderCheckCallBack);
    Td.contrastDecButton = uicontrol('Parent',Td.bottomPanel,...
        'Style','pushbutton',...
        'String','-',...
        'FontSize',10,...
        'Enable','on',...
        'Value',0,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.43 0.05 0.065 0.45],...
        'BackgroundColor',[1 1 1],...
        'Callback',{@contrastButtonCallBack,-1});
    Td.contrastIncButton = uicontrol('Parent',Td.bottomPanel,...
        'Style','pushbutton',...
        'String','+',...
        'FontSize',10,...
        'Enable','on',...
        'Value',0,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.495 0.05 0.065 0.45],...
        'BackgroundColor',[1 1 1],...
        'Callback',{@contrastButtonCallBack,1});
    Td.foundChannels = {'dapi'};
    for channel = Hs.foundChannels
        if ~strcmp(cell2mat(channel),'dapi')
            Td.foundChannels = [Td.foundChannels,channel];
        end
    end
    Hs.chanPop  = uicontrol('Parent',Td.bottomPanel,...
        'Style','popup',...
        'String',Td.foundChannels,...0.225
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.57 0.05 0.13 0.45],...
        'ForegroundColor',[1 1 1],...
        'BackgroundColor',[0.247 0.247 0.247],...
        'Callback',@chanPopCallBack);
    Td.locBox  = uicontrol('Parent',Td.bottomPanel,...
        'String','1 - 1 (row-col)',...
        'Style','text',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.57 0.50 0.13 0.45],...
        'BackgroundColor',[1 1 1]);    %Draw the grid
    Td.decButton  = uicontrol('Parent',Td.bottomPanel,...
        'String','-',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.71 0.05 0.025 0.90],...
        'BackgroundColor',[1 1 1],...
        'callback',@decButtonCallBack);    %Draw the grid
    Td.incButton  = uicontrol('Parent',Td.bottomPanel,...
        'String','+',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.835 0.05 0.025 0.90],...
        'BackgroundColor',[1 1 1],...
        'callback',@incButtonCallBack);    %Draw the grid

    Td.numBox  = uicontrol('Parent',Td.bottomPanel,...
        'String','100',...
        'Style','edit',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.745 0.05 0.08 0.90],...
        'BackgroundColor',[1 1 1],...
        'callback',@numBoxCallBack);    %Draw the grid
    Td.shiftButton  = uicontrol('Parent',Td.bottomPanel,...
        'String','Shift GUI',...
        'Style','pushbutton',...
        'FontSize',10,...
        'HorizontalAlignment','Left',...
        'Units','normalized',...
        'Position',[0.89 0.05 0.10 0.90],...
        'BackgroundColor',[1 0 0],...
        'callback',@shiftButtonCallBack);    %Draw the grid
end
function randomButtonCallBack(hObject, eventData)
    Td = guidata(gcbo);
    Td.currRow = ceil(rand * (Td.rows - 1));
    Td.currCol = ceil(rand * (Td.cols - 1));
    Td = displayImages(Td);
    guidata(gcbo, Td);
end
function selectButtonCallBack(hObject,eventData)
    Td = guidata(gcbo);
    uiresume(Td.figH);
end
function shiftButtonCallBack(hObject,eventdata)
    Td = guidata(gcbo);
    set(Td.figH,'Visible','off');
    %TEMP = shiftTiles(Td);
    display('launchign shift GUI');
    shift.launchShiftGUI();
    %TEMP = shift.shiftTiles(Td.filePaths, Td.foundChannels);
    Td.tilesShifted = true;
    %Td.shiftTilesCalled = true;
    guidata(Td.figH,Td);
    uiresume(Td.figH);
    display(['Navigate into the new directory "ModifiedImages#" and run',...
        ' the Dentist commands again']);
end
function contrastButtonCallBack(hObject,eventdata,direction)
    Td = guidata(gcbo);
    if direction == 1
        if Td.contrastValue < 1
            Td.contrastValue = Td.contrastValue + 0.1;
        elseif Td.contrastValue >= 1 && Td.contrastValue < 2
            Td.contrastValue = 2;
        elseif Td.contrastValue >= 2 && Td.contrastValue < 10
            Td.contrastValue = Td.contrastValue + 1;
        elseif Td.contrastValue == 10
            Td.contrastValue = 10;
        end
    elseif direction == -1
        if Td.contrastValue >= 2
            Td.contrastValue = Td.contrastValue - 1;
        elseif Td.contrastValue > 1 && Td.contrastValue < 2
            Td.contrastValue = 1;
        elseif Td.contrastValue <= 1
            Td.contrastValue = Td.contrastValue - 0.1;
        elseif Td.contrastValue <= 0.1
            Td.contrastValue = 0.1;
        end
    end
    Td = displayImages(Td);
    guidata(gcbo,Td);
end
function chanPopCallBack(hObject,eventdata)
    Td = guidata(gcbo);
    Td.chanIndex = get(hObject,'Value');
    Td = displayImages(Td);
    guidata(gcbo,Td);
end
function borderCheckCallBack(hObject,eventdata)
    Td = guidata(gcbo);
    if isfield(Td,'borderPlots')
        for p = Td.borderPlots
            if ishandle(p)
                delete(p);
            end
        end
    end
    Td.borderPlots = [];
    if (get(hObject,'Value') == get(hObject,'Max'))%checked
        Td = drawBorders(Td);
    else %unchecked
        %Already deleted the old plots
    end
    guidata(gcbo,Td);
end
function Td = drawBorders(Td)
    %Horizontal line
    x1 = 0;
    x2 = (Td.imageSize(2) * 2) - (Td.overlap * 2);
    y1 = Td.imageSize(1) - Td.overlap;
    y2 = Td.imageSize(1) - Td.overlap;
    hold on;
    horizontal = plot([x1,x2],[y1,y2],'Color','r');
    hold off;
    %Vertical line
    x1 = Td.imageSize(2) - Td.overlap;
    x2 = Td.imageSize(2) - Td.overlap;
    y1 = 0;
    y2 = (Td.imageSize(1) * 2) - (Td.overlap * 2);
    hold on;
    vertical = plot([x1,x2],[y1,y2],'Color','r');
    hold off;
    Td.borderPlots = [Td.borderPlots,horizontal,vertical];
end
function analyzeButtonCallBack(hObject,events)
    Td = guidata(gcbo);
    figure,imcontrast(imshow(scale(Td.imgCat)));
end
function incButtonCallBack(hObject,events)
    Td = guidata(gcbo);
    Td.overlap = Td.overlap + 1;
    set(Td.numBox,'String',int2str(Td.overlap));
    Td = displayImages(Td);
    guidata(gcbo,Td);
end
function decButtonCallBack(hObject,events)
    Td = guidata(gcbo);
    if Td.overlap >= 1
        Td.overlap = Td.overlap - 1;
        set(Td.numBox,'String',int2str(Td.overlap));
        Td = displayImages(Td);
        guidata(gcbo,Td);
    end
end
function numBoxCallBack(hObject,events)
    Td = guidata(gcbo);
    str = get(hObject,'String');
    if ~isempty(find(ismember(str,'0123456789') == 0))
        set(hObject, 'String', num2str(Td.overlap));
    else
        Td.overlap = str2num(str);
        Td = displayImages(Td);
        guidata(gcbo,Td);
    end
end
function closeRequestCallBack(hObject,events)
    if isequal(get(hObject,'waitstatus'),'waiting')
        uiresume(hObject);
    else
        delete(hObject);
    end
end
function nextSetCallBack(hObject,events)
    Td = guidata(gcbo);
    Td.currCol = Td.currCol + 1;
    if Td.currCol + 1 > Td.cols
        Td.currCol = 1;
        Td.currRow = Td.currRow + 1;
        if Td.currRow + 1 > Td.rows
            Td.currRow = 1;
        end
    end
    Td = displayImages(Td);
    guidata(gcbo,Td);
end
function prevSetCallBack(hObject,events)
    Td = guidata(gcbo);
    Td.currCol = Td.currCol - 1;
    if Td.currCol <= 0
        Td.currCol = Td.cols - 1;
        Td.currRow = Td.currRow - 1;
        if Td.currRow <= 0
            Td.currRow = Td.rows - 1;
        end
    end
    Td = displayImages(Td);
    guidata(gcbo,Td);
end

function Td = displayImages(Td)
    set(Td.locBox,'String',strcat('R-C: ',int2str(Td.currRow),' - ',int2str(Td.currCol)));

    currImage = imread(cell2mat(Td.filePaths(Td.currRow,Td.currCol,Td.chanIndex)));
    Td.imageSize = size(currImage);
    currImage = currImage(1:(end - Td.overlap),1:(end - Td.overlap));
    minCurr = min(currImage(:));
    maxCurr = max(currImage(:));
    
    rightImage = imread(cell2mat(Td.filePaths(Td.currRow,Td.currCol+1,Td.chanIndex)));
    rightImage = rightImage(1:(end - Td.overlap),1:(end - Td.overlap));
    minRight = min(rightImage(:));
    maxRight = max(rightImage(:));
    
    downImage = imread(cell2mat(Td.filePaths(Td.currRow+1,Td.currCol,Td.chanIndex)));
    downImage = downImage(1:(end - Td.overlap),1:(end-Td.overlap));
    minDown = min(downImage(:));
    maxDown = max(downImage(:));

    downRightImage = imread(cell2mat(Td.filePaths(Td.currRow+1,Td.currCol+1,Td.chanIndex)));
    downRightImage = downRightImage(1:(end - Td.overlap), 1:(end - Td.overlap));
    minDownRight = min(downRightImage(:));
    maxDownRight = max(downRightImage(:));
    
    imgCat = [currImage,rightImage;downImage,downRightImage];
    
    Td.imgCat = imgCat;
    
    set(Td.imgAx,'xlim',[0,(Td.imageSize(2) * 2) - (Td.overlap * 2)],'ylim',[0,(Td.imageSize(1) * 2) - (Td.overlap * 2)]);
    minVector = [minCurr,minDown,minRight,minDownRight];

    maxVector = [maxCurr,maxDown,maxRight,maxDownRight];

    minVector = double(minVector);

    maxVector = double(maxVector);

    minInt = median(double(minVector));

    maxInt = median(double(maxVector));
    
    imgCatTemp = scale(imgCat,[minInt,maxInt]);
    
    imgCatTemp = imgCatTemp * Td.contrastValue;
    imshow(imgCatTemp,'Parent',Td.imgAx);
    if get(Td.borderCheck,'Value') == 1
        Td = drawBorders(Td);
    end
end