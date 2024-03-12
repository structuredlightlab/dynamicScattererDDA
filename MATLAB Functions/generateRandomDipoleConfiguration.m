function [z_dipole_positions,static_dipole_positions,moving_dipole_positions,...
    n_dipoles,n_static_dipoles,n_moving_dipoles] = generateRandomDipoleConfiguration...
    (n_dipoles,percent_move,dipole_area,percent_area,selection_method,circle_centre)

    n_moving_dipoles = 0; % Set to 0 initially so while loop runs at least once
    if percent_area ~= 0
    while n_moving_dipoles ~= ceil((percent_move/100)*n_dipoles)              
        % Set up positions of scatterers; creates 2 random square arrays and
        % places them vertically stacked. This is done because generating a
        % random rectangular array is not uniformly randomly distributed
        z_dipole_positions_1 = ((rand(ceil(n_dipoles/2),1)*2)-1)*dipole_area(1) ...
            + 1i*((rand(ceil(n_dipoles/2),1)*2)-1)*dipole_area(2);    
        z_dipole_positions_2 = ((rand(ceil(n_dipoles/2),1)*2)-1)*dipole_area(1) ...
            + 1i*((rand(ceil(n_dipoles/2),1)*2)-1)*dipole_area(2);
        
        % Translate the arrays so they can be stacked on top of each other
        z_dipole_positions_1 = z_dipole_positions_1 + 1i*dipole_area(2)/1.5;        
        z_dipole_positions_2 = z_dipole_positions_2 - 1i*dipole_area(2)/1.5;
        
        % NEED TO ADD SOMETHING TO PREVENT DIPOLES FROM BEING OUTSIDE
        % PLOTTING AREA
    
        %Concatenate arrays
        z_dipole_positions = [z_dipole_positions_1; z_dipole_positions_2];
        
        n_dipoles = size(z_dipole_positions,1);   
        % recalculate no. of scatterers in case rounding changed number of scatterers
        
        % Select an area of scatterers that will move randomly
                  
        % How to select moving dipoles; either 'circle' or 'random'
        switch selection_method
            case 'circle'
                
                r_positions = abs(z_dipole_positions-circle_centre);
                range_movement = percent_area*max(dipole_area);
                idx_move = find(r_positions <= range_movement);
                idx_static = find(r_positions > range_movement);
            case 'random'
                idx_move = randperm(n_dipoles,ceil((percent_move/100)*n_dipoles));
                idx_static = 1:n_dipoles;    idx_static(idx_move) = [];
        end
    
        static_dipole_positions = z_dipole_positions;        
        static_dipole_positions(idx_move) = [];
        
        moving_dipole_positions = z_dipole_positions;        
        moving_dipole_positions(idx_static) = [];
        
        n_static_dipoles = size(static_dipole_positions,1);
        n_moving_dipoles = n_dipoles - n_static_dipoles;
    end
    else
        z_dipole_positions_1 = ((rand(ceil(n_dipoles/2),1)*2)-1)*dipole_area(1) ...
            + 1i*((rand(ceil(n_dipoles/2),1)*2)-1)*dipole_area(2);    
        z_dipole_positions_2 = ((rand(ceil(n_dipoles/2),1)*2)-1)*dipole_area(1) ...
            + 1i*((rand(ceil(n_dipoles/2),1)*2)-1)*dipole_area(2);
        
        % Translate the arrays so they can be stacked on top of each other
        z_dipole_positions_1 = z_dipole_positions_1 + 1i*dipole_area(2)/1.5;        
        z_dipole_positions_2 = z_dipole_positions_2 - 1i*dipole_area(2)/1.5;
        
        % NEED TO ADD SOMETHING TO PREVENT DIPOLES FROM BEING OUTSIDE
        % PLOTTING AREA
    
        %Concatenate arrays
        z_dipole_positions = [z_dipole_positions_1; z_dipole_positions_2];
        
        n_dipoles = size(z_dipole_positions,1); 

        static_dipole_positions = z_dipole_positions;                
        moving_dipole_positions = [];
        
        n_static_dipoles = n_dipoles;
        n_moving_dipoles = 0;
    end

end