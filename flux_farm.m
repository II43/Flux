function [E,T,S] = flux_farm(E,T,S,conf)
% Farming - each site belonging to critters gets harvests energy
E( T>0 ) = E(T>0) + conf.E_farm; 
E( (E>conf.E_max) & T>0 ) = conf.E_max;