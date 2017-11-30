function hFigure = plotcmat(E,T,S,conf,varargin)

persistent hscax hsc;

maxE = conf.E_max;

hFigure = findobj('Tag','FLUXFIG');
if isempty(hFigure) || ~isvalid(hFigure),
    if any(strcmp(varargin,'Update')),
        % Figure was closed - do nothing
        hFigure = [];
        return;
    end
    hFigure = figure('Tag','FLUXFIG', ...
                     'KeyPressFcn',@keydown, ...
                     'Name','Flux', ...
                     'Menubar','none', ...
                     'Toolbar','none');            
else
    % Set the current figure
    figure(hFigure);
    drawnow;
end

% Colors
step = -1;
mCol = [220:step:100]';
map_red = [ones(length(mCol),1)*255 mCol mCol]./255;
map_blue = [mCol mCol ones(length(mCol),1)*255]./255;
map_green = [mCol ones(length(mCol),1)*255 mCol]./255;
% bCol = [255:-1:0]';
% map_black = [bCol bCol bCol]./255;

switch(conf.TypeCount)
    case 2
        maps = [[1 1 1]; map_red; map_blue; [0 0 0]];
    case 3
        maps = [[1 1 1]; map_red; map_blue; map_green; [0 0 0]];
    otherwise
        error('Unsupported number of types');
end

% Energy 
Ecomp = zeros(size(E));
idxTBorder = find(T == -1);
Ecomp(idxTBorder)= E(idxTBorder);
for dT=1:conf.TypeCount
    idxT = find(T == dT);
    Ecomp(idxT) = (dT-1)*(conf.E_max+conf.E_min)+E(idxT);
end

% Plot
if ~isempty(hscax) && isa(hscax,'matlab.graphics.axis.Axes'),
    if ~isvalid(hscax),
        % Not a valid handle to axes - do nothing
        return;
    end
    if ~isempty(hsc) && isvalid(hsc),
        set(hsc,'CData',Ecomp);
    else
        % Just in case that this handle would be empty or invalid
        hsc = imagesc(hscax,Ecomp);
    end
else
    % Plotting for the first time
    colormap(maps);
    hsc = imagesc(Ecomp);
    hscax = gca;
    title('Game of Flux','FontSize',20,'FontWeight','bold');
    set(hscax,'xtick',[]);
    set(hscax,'xticklabel',[]);
    set(hscax,'ytick',[]);
    set(hscax,'yticklabel',[]);
end    

% Callback
function keydown(hObject,eventdata,varargin)

% hFigure = findobj('Tag','FLUXFIG');
% delete(hFigure);
