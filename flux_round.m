function [E, T, new_S] = flux_round(E,T,S,conf)
% Returns updated E, T, S matrix
new_S  = S;

for type_idx = 1:conf.TypeCount
    % Watchout, E is returned, new_E is temp only
    new_E  = zeros(conf.P_y, conf.P_x);
    
    % Loop through the playground
    for y = 2:conf.P_y-1
       for x = 2:conf.P_x-1
           if  T(y, x) == type_idx
               % 3x3 neighborhood
               neighborE = E([y-1 y y+1],[x-1 x x+1]);
               neighborT = T([y-1 y y+1],[x-1 x x+1]);
               neighborS = S([y-1 y y+1],[x-1 x x+1]);
               
               % Snapshot in case that critter will do invalid moves
               newESnapshot = new_E([y-1 y y+1],[x-1 x x+1]); 
         
               % Energy visible only for my critters otherwise unknown
               % Note that the state is visible to everyone - enemy is listening
               filteredNeighborE = neighborE;
               filteredNeighborE(neighborT ~= type_idx) = flux_siteenum.UNKNOWN;           
               
               %% Call the critter function depending who is it
               % Must return 3x3 diff for E, 1x1 for new S
               funccritter = conf.critters{type_idx};              
               [propE, propS ] = funccritter(filteredNeighborE, neighborT, neighborS, conf);
               % Change state to whatever critter want
               new_S(y,x) =  propS; 
               
               %% Enforce rules
               KillHim = false;
               % Energy theft
               if any(propE([1 2 3 4 6 7 8 9]) <0)  
                   KillHim = true;
               end
               
               % Energy created from nothing
               % Note that energy leaking is not checked
               if abs(sum(sum(propE))) > 0      
                   KillHim = true;
               end               
                  
               if KillHim
                   % Invalid move - energy is zeroed for current site
                   new_E(y,x) = 0;                                          
               else
                   % Apply valid move - energy redistribution
                   new_E(y-1:y+1,x-1:x+1) = new_E(y-1:y+1,x-1:x+1) +  propE;
               end
               
           end  
       end %x   
    end %y
    
    %% Game engine
    % Go through only sites where something was going on
    modded = find(new_E~=0);  
    % Debugging visualization
    % imagesc(new_E~=0)
    for point_idx = 1:length(modded)
       thisIdx = (modded(point_idx));
        if T(thisIdx) == type_idx
           % Friendly site - just add energy
           E(thisIdx) = E(thisIdx) + new_E(thisIdx);
        elseif T(thisIdx) == flux_siteenum.EMPTY
            % Capture an empty site at no cost
            T(thisIdx) = type_idx;
            E(thisIdx) = E(thisIdx) + new_E(thisIdx);
        elseif T(thisIdx) == flux_siteenum.WALL
            % Nothing, wall is inpassable
        else
            % Fight
           if new_E(thisIdx) > E(thisIdx)
               % Attacker won
               T(thisIdx) = type_idx;
               E(thisIdx) = new_E(thisIdx) - conf.Fratio*E(thisIdx);
               new_S(thisIdx) = 0;
           else
               % Defender won
               E(thisIdx) = E(thisIdx) - conf.Fratio*new_E(thisIdx);
           end
        end
    end
    
    % Check for maximum energy saturation
    idxHigh = (E > conf.E_max) & (T ~= flux_siteenum.WALL);
    E(idxHigh) = conf.E_max;
    
    % Check for minimum energy
    % Free the site and do not remove the energy and state
    idxLow = (E<conf.E_min ) & (T > flux_siteenum.EMPTY); 
    T(idxLow) = flux_siteenum.EMPTY;
    
    % Double check that no energy was created
    % TODO
    
end %
