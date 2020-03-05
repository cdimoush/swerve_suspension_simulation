function x_dot = sus_sim_state(x, t, mr, mwm, k, kt, b, g, drive_vel, ob)    
    robot_pos = t*drive_vel;
    u = obstical_function(robot_pos, ob); 
    x_dot = zeros(4,1);
    if x(3) <= u
        
        x_dot(1) = x(2);
        x_dot(2) = [-4*k/mr  -4*b/mr 4*k/mr 4*b/mr] * x;
        x_dot(3) = x(4);
        x_dot(4) = [k/mwm  b/mwm -(kt+k)/mwm -b/mwm] * x;

        x_dot = x_dot + [0; -1; 0; -1]*g + [0; 0; 0; kt/mwm]*u;
    else
        disp(robot_pos);
        x_dot(1) = x(2);
        x_dot(2) = [-4*k/mr  -4*b/mr 4*k/mr 4*b/mr] * x;
        x_dot(3) = x(4);
        x_dot(4) = [k/mwm  b/mwm -k/mwm -b/mwm] * x;

        x_dot = x_dot + [0; -1; 0; -1]*g + [0; 0; 0; 0]*u;
    end

end
