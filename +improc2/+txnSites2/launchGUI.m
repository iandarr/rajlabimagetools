function tools = launchGUI(exonChannelName, intronChannelName, varargin)
%Launch the manual TxnSite Selection GUI. The first argument must be the
%channel name for the exon spots. The second can either be an intron channel 
%name or the string 'none' if no intron data is present. The user may
%specify the directory of the data or pass a collection of objects. If
%neither are passed, the GUI will look at the current directory
IntronFlag = true;
ExonFlag = true;
if (strcmp(exonChannelName, 'none'))
    ExonFlag = false;
end
if (strcmp(intronChannelName, 'none'))
    IntronFlag = false;
end

%Gaussian Fit the spot data and add the data to the fitted channel node
dataAdder = improc2.processing.DataAdder(varargin{:});
unprocessedFittedData = improc2.nodeProcs.TwoStageSpotFitProcessedData();
if (IntronFlag && ExonFlag)
    dataAdder.addDataToObject(unprocessedFittedData, exonChannelName, [exonChannelName ':Fitted'])
    dataAdder.addDataToObject(unprocessedFittedData, intronChannelName, [intronChannelName ':Fitted'])
else
    if(ExonFlag)
        dataAdder.addDataToObject(unprocessedFittedData, exonChannelName, [exonChannelName ':Fitted'])
    end
end

dataAdder.repeatForAllObjectsAndQuit();
improc2.processing.updateAll(varargin{:})

improc2.txnSites2.addTxnSiteData(exonChannelName, intronChannelName, varargin{:})

tools = improc2.launchImageObjectBrowsingTools(varargin{:});
objectHandle = tools.objectHandle;
navigator = tools.navigator;
%Create the nodes for transcription sites
if (IntronFlag && ExonFlag)
    nodeDataBasedtxnSites2Collection = improc2.txnSites2.IntronExonTranscriptionSitesCollection(tools.objectHandle,...
        intronChannelName, exonChannelName);
else
    if(ExonFlag)
        nodeDataBasedtxnSites2Collection = improc2.txnSites2.ExonOnlyTranscriptionSitesCollection(tools.objectHandle,...
            exonChannelName);
    end
end

%collect the images for relevant channels
imageHolders = struct();

if(ExonFlag)
    imageHolders.exon = ...
        improc2.utils.ImageHolderFromImageObjectHandle(objectHandle, ...
        exonChannelName, ...
        'improc2.nodeProcs.RegionalMaxProcessedData');
end

if(IntronFlag)
    imageHolders.intron = ...
        improc2.utils.ImageHolderFromImageObjectHandle(objectHandle, ...
        intronChannelName, ...
        'improc2.nodeProcs.RegionalMaxProcessedData');
end


imageHolders.dapi = ...
    improc2.utils.ImageHolderFromImageObjectHandle(objectHandle, ...
    'dapi', ...
    'improc2.nodeProcs.DapiProcessedData');

%Launch the proper GuiCore (depending on if introns are present)
if (IntronFlag && ExonFlag)
    improc2.txnSites2.IntronExonTxnSiteGUIcore(navigator, nodeDataBasedtxnSites2Collection, imageHolders)
else
    if(ExonFlag)
        improc2.txnSites2.ExonOnlyTxnSiteGUIcore(navigator, nodeDataBasedtxnSites2Collection, imageHolders)
    end
end

improc2.launchAnnotationsGUI(tools.annotations)

navigator.addActionBeforeMoveAttempt(nodeDataBasedtxnSites2Collection,...
    @flagAsReviewed);