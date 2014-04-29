classdef HandleToGraphBasedImageObject < improc2.interfaces.ImageObjectHandle
    
    properties (Access = private)
        objHolder
    end
    
    properties (Access = private, Dependent = true)
        obj
    end
    
    properties (Dependent = true)
        channelNames
    end
    
    methods
        function p = HandleToGraphBasedImageObject(objHolder)
            p.objHolder = objHolder;
        end
        
        function channelNames = get.channelNames(p)
            channelNames = p.obj.graph.nodes{1}.data.channelNames;
        end
        function obj = get.obj(p)
            obj = p.objHolder.obj;
        end
        
        function metadata = getMetaData(p)
            metadata = p.obj.graph.nodes{1}.data.metadata;
        end
        
        function imFileMask = getMask(p)
            imFileMask = p.obj.graph.nodes{1}.data.imageFileMask;
        end
        function bbox = getBoundingBox(p)
            s = regionprops(p.getMask(), 'BoundingBox');
            bbox = s.BoundingBox;
            bbox(1:2) = bbox(1:2) + 0.5; % Move corner of box to center of pixel
            bbox(3:4) = bbox(3:4) - 1; % Shrink box size by 1 pixel (i.e., 0.5 on each side)
        end
        function objMask = getCroppedMask(p)
            objMask = imcrop(p.getMask(), p.getBoundingBox());
        end
        
        function fileName = getImageFileName(p, channelName)
            channelNode = getNodeByLabel(p.obj.graph, channelName);
            fileName = channelNode.data.fileName;
        end
        function dirPath = getImageDirPath(p)
            firstChannel = p.channelNames{1};
            channelNode = getNodeByLabel(p.obj.graph, firstChannel);
            dirPath = channelNode.data.dirPath;
        end
        
        function pData = getProcessorData(p, nodeLabel, dataClassName)
            if nargin < 3
                dataClassName = 'improc2.interfaces.NodeData';
            end
            graph = p.obj.graph;
            foundNodes = findShallowestNodesMatchingCondition(graph, ...
                nodeLabel, @(node) isa(node.data, dataClassName));
            assert(~isempty(foundNodes), 'improc2:NodeNotFound', ...
                ['Could not locate data of type %s starting from', ...
                ' node %s.'], dataClassName, nodeLabel)
            if length(foundNodes) > 1
                matchingNodeLabels = cellfun(@(node) node.label, foundNodes, 'UniformOutput', false);
                error('improc2:AmbiguousDataSpecification', ...
                    ['Starting from node %s, nodes %s\n', ...
                    'are all of the required data type (%s).\n', ...
                    'Specify one of these as the node Label instead.'], ...
                    nodeLabel, strjoin(matchingNodeLabels, ', '),...
                    dataClassName);
            end
            pData = foundNodes{1}.data;
        end
        
        function boolean = hasProcessorData(p, channelName, className)
        end
        
        function setProcessorData(p, procData, channelName, varargin)
        end
        function disp(p)
            improc2.utils.displayDescriptionOfHandleObject(p);
        end
    end
    
end

