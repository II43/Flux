function [E,T,S] = flux_init_battlefields(E,T,S,conf)

WALL_IDX = flux_siteenum.WALL;
WALL_E = conf.TypeCount*(conf.E_max+conf.E_min); 

T(:,1) = WALL_IDX;
T(:,conf.P_x) = WALL_IDX;
T(1,:) = WALL_IDX;
T(conf.P_y,:) = WALL_IDX;

E(:,1) = WALL_E;
E(:,conf.P_x) = WALL_E;
E(1,:) = WALL_E;
E(conf.P_y,:) = WALL_E;

%keep zero somewhere
E(1,1) = 0;
E(end,end) = 0;


T(ceil(conf.P_y/3),ceil(conf.P_x/3)) = 1;
E(ceil(conf.P_y/3),ceil(conf.P_x/3)) = 900;
T(ceil(conf.P_y/3*2),ceil(conf.P_x/3*2)) = 2;
E(ceil(conf.P_y/3*2),ceil(conf.P_x/3*2)) = 900;

%% Various pre-defined arenas
if conf.arena == 2
    T( [ [1: conf.P_y/2 - 2] [ conf.P_y/2 + 2 :end ]],ceil(conf.P_x/2) ) = WALL_IDX;
    E( [ [1: conf.P_y/2 - 2] [ conf.P_y/2 + 2 :end ]],ceil(conf.P_x/2) ) = WALL_E;
      
end

if conf.arena == 3
    T(ceil(conf.P_y/2), [ [1: conf.P_x/2 - 2] [ conf.P_x/2 + 2 :end ]] ) = WALL_IDX;
    E(ceil(conf.P_y/2), [ [1: conf.P_x/2 - 2] [ conf.P_x/2 + 2 :end ]] ) = WALL_E;
      
end

if conf.arena == 4
    T( [ [1: conf.P_y/2 - 3] [ conf.P_y/2 + 3 :end ]],ceil(conf.P_x/2) ) = WALL_IDX;
    E( [ [1: conf.P_y/2 - 3] [ conf.P_y/2 + 3 :end ]],ceil(conf.P_x/2) ) = WALL_E;
    T(ceil(conf.P_y/2), [ [1: conf.P_x/2 - 3] [ conf.P_x/2 + 3 :end ]] ) = WALL_IDX;
    E(ceil(conf.P_y/2), [ [1: conf.P_x/2 - 3] [ conf.P_x/2 + 3 :end ]] ) = WALL_E;
      
end

if conf.arena == 5
    T(conf.P_y/2-5:conf.P_y/2+5, conf.P_x/2-5:conf.P_x/2+5  ) = WALL_IDX;
    E( conf.P_y/2-5:conf.P_y/2+5, conf.P_x/2-5:conf.P_x/2+5 ) = WALL_E;
      
end