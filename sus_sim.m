%Conner Dimoush
clear
%CONSTANTS
%----------
g = 9.81; %m/s^2

%MODULE PARAMETERS
%----------
mass_r = 40; %mass of robot [kg]
mass_wm = 2; %mass of wheel module [kg]
k = 1500; %Spring Stiffness [N/m]
kt = 80000; %Tire Stiffness [N/m]
b = 300; %Damper [N-s/m]

%SIMULATION PARAMETERS
%----------
output = 3;
%Scenario 
drive_vel = 1.25; %Horizontal velocity of robot [m/s]
drive_dis = 3; %Distance traveled by robot [m/s]

% ob = [0.1 0; 0.2016 0.0762; 0.7096 0.0762; 0.8112 0];
% ob1 = ob;
% ob(:,1) = ob(:,1)+1;
% ob2 = ob;
% ob2(:,1) = ob(:,1)+2;
% ob3 = ob;
% ob3(:,1) = ob(:,1)+3;
% 
% 
ob = road_creator(1, 1, 2, 0.005, 0.2);
% ob2 = [10 0; 12 0.02;];
% % 
% ob = cat(1, ob1, ob2, ob3);

%Time Variable
t_start = 0;
t_end = drive_dis / drive_vel;
t_step = 0.01;
t_span = t_start:t_step:t_end;

%Output
plot1 = [];
plot2 = [];
plot3 = [];
plot4 = [];

%INITIAL CONDITIONS
%----------
x_init = zeros(1, 4);
syms x1 x3
eq1 = -4*k*x1/mass_r + 4*k*x3/mass_r == g;
eq2 = k*x1/mass_wm - (kt+k)*x3/mass_wm == g;
[x_init(1), x_init(3)] = solve(eq1, eq2);

%SIMULATE
%----------
[t, x] = ode45(@(t, x) sus_sim_state(x, t, mass_r, mass_wm, k, kt, b, g, drive_vel, ob), t_span, x_init);
plot_obstical = zeros(length(t), 1);
pos = zeros(length(t), 1);
for i = 1:length(t)
    pos(i) = drive_vel*t(i);
    plot_obstical(i) = obstical_function(drive_vel*t(i), ob);
end
%Build plot1 (relative mass positions)
plot1 = cat(2, x(:,1)-x_init(1), x(:,3)-x_init(3), plot_obstical);
%Build plot2 (dx of spring/ damper)
plot2 = zeros(length(t), 1);
for i = 1:length(t)
    plot2(i) = x(i, 1) - x(i, 3) - (x_init(1) - x_init(3));
end
%Build plot3 (normal force)
dx_tire = x(:, 3) - plot_obstical;
index = dx_tire>0; %get index of values for when tire leaves the gound
dx_tire(index) = 0;
normal = kt*dx_tire;
plot3 = abs(normal);


%BIG PLOT
%A) X1, X3, Road
%B) Stroke
%C) Normal Force

if output == 1
    figure
    sp1 = subplot(4,1,[1, 2]);
    plot(pos, plot1*100);
    % xlabel("Position [m]")
    ylabel("Height [cm]");
    title("Suspension w/ Obstical [Drive Velocity: " +num2str(drive_vel) + " m/s, k: " +num2str(k)+ " N/m, b: " +num2str(b) + " N-s/m]");
    legend('X_r', 'X_w_m', 'Road');

    sp2=subplot(4,1,3);
    plot(pos, plot2*100);
    ylabel("Spring Displacement [cm]");
    
    sp3=subplot(4,1,4);
    plot(pos, plot3);
    xlabel("Position [m]")
    ylabel("Normal [N]");
    ylim([0 max(plot3)]);

%Video of X1, X3, Road
elseif output == 2
    figure
    frame_size = 75; %[cm]
    span = round(frame_size/(100*drive_vel*t_step));
    index = round(span/2);
    sleep = t_step/100; %Relate frame speed to drive velocity
    width = 25; %Dimensions of wheel module [cm]
    height = 15;
    radius = 20;
    
    n = length(t)-span;
    for i=1:n
        plot(pos(i:i+span)*100,plot1(i:i+span, 1:3)*100)
        %tire is in the air
        if x(i+index, 3) > plot_obstical(i+index) 
            %wheel
            rectangle('Position',[pos(i+index)*100-radius/2 plot1(i+index, 2)*100 radius, radius],'Curvature',[1 1])
            %Chassis
            rectangle('Position',[pos(i+index)*100-width/2 plot1(i+index, 1)*100+radius width height])
        %squish tire
        else
            squish = (-x(i+index, 3) + plot_obstical(i+index))*100;
            squ_width = radius + squish;
            squ_height = radius - squish;
            %tire
            rectangle('Position',[pos(i+index)*100-squ_width/2 plot1(i+index, 3)*100 squ_width, squ_height],'Curvature',[1 1])
            %Chassis
            rectangle('Position',[pos(i+index)*100-width/2 plot1(i+index, 1)*100+squ_height width height])
        end
            
        %plot([pos(i+index), pos(i+index)],[plot1(i+index, 2)*100+radius, plot1(i+index, 1)*100+3*radius]);
        set(gcf, 'Position', get(0, 'Screensize'));
        
        range = (pos(i+span)-pos(i))*100;
        y_up = plot_obstical(i+index)*100 + 0.60*range;
        y_down = plot_obstical(i+index)*100 - 0.40*range/2;
        axis([pos(i)*100, pos(i+span)*100, y_down, y_up])
        axis equal;
        pause(sleep)
    end  
end

exp1 = "Min Normal = " + num2str(min(plot3) + " N");
exp2 = "Stroke = " + num2str((max(plot2) - min(plot2))*100) + " cm";
disp(exp1);
disp(exp2);
    