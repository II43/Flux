function  [propE, propS ] = critter_random(neighborE, neighborT, neighborS, conf)
% The goal of critter function is to distribute energy from itself to its
% neighborhood to capture empty site and defeat the enemies.
%
% This example critter function randomly distributing the energy to empty 
% and enemy sites. 
% 
% Inputs:
%   neighborE - 3x3 neighborhood sites energy 
%   neighborT - 3x3 neighborhood sites type   (refer to flux_siteenum.m)
%   neighborS - 3x3 neighborhood sites state  
%   conf      - playground configuration
%
% Outputs:
%   propE      - 3x3 proposed new energy distribution 3x3
%   propS      - 1x1 new state of a current site (can be used for information transfer)
%

%% Initialize
propE = zeros(3,3);
propS = 0;

% Get identification of this critter site to know who are friends and enemies
myid = neighborT(2,2);
myE  = neighborE(2,2);

%% Play
% Understanding the neighborhood
idxEmpty = (neighborT == flux_siteenum.EMPTY);
idxEnemy = (neighborT ~= myid & neighborT ~= flux_siteenum.WALL) & ~idxEmpty;

% Available enegy for redistribution
% Must keep at lease minimum energy to keep the site
availableE = myE - conf.E_min;

% Distribute evenly among empty and enemy sites
% idxRedist = idxEmpty | idxEnemy;
% propE(idxRedist) = floor(availableE / sum(sum(idxRedist)));

% Distribute randomly among empty and enemy sites
idxRedist = idxEmpty | idxEnemy;
n = floor(availableE);
x = sum(sum(idxRedist));
m = 1:n;
if x <= n
    a = m(sort(randperm(n,x)));
    b = diff(a);
    b(end+1)= n - sum(b);
    propE(idxRedist) = b';
else
    % Do nothing
end

% Remove this energy from current site to avoid rules braking
propE(2,2) = - sum(sum(propE));

% Save a state - this could be anything 
% (could be used for information transfer in more complex strategies)
propS = propE(2,2);
