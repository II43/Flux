function flux(varargin)
% Example: flux(@critter_random,@critter_random)
%
% Critters / players
critters = {};
for iarg = 1:numel(varargin)
	if isa(varargin{iarg},'function_handle'),
		critters(end+1) = varargin(iarg);
	end		
end

if isempty(critters),
	error(['You must supply at 1 critter function to trigger the battle!' char(10) ...
		   'For example: flux(@mycritter,@bestcritter)']);  
elseif numel(critters) > 2,
	warning('Maximum number of critters is 2! Ignoring extra supplied critters.');
	critters = critters([1 2]);
end

% Arena size and rules definition	
conf.P_x        = 100;
conf.P_y        = 100;
conf.E_max      = 990;
conf.E_min      = 10;
conf.E_farm     = 2;
conf.TypeCount  = numel(critters);
conf.Fratio     = 0.5;                  % How much of energy is captured during fight

% Arena selection
conf.arena = 5;

% Register critters
conf.critters = critters;

close all

E  = zeros(conf.P_y, conf.P_x);
T  = zeros(conf.P_y, conf.P_x);
S  = zeros(conf.P_y, conf.P_x);
hFigure = plotcmat(E,T,S,conf);

[E,T,S] = flux_init_battlefields(E,T,S,conf);
round = 0;
while isvalid(hFigure), 
   round = round + 1;
   [E,T,S] = flux_round(E,T,S,conf);
   [E,T,S] = flux_farm(E,T,S,conf);
   plotcmat(E,T,S,conf,'Update');
end