%Conner Dimoush
clear
%MODULE PARAMETERS
%----------
mr = 40; %mass of robot [kg]
mwm = 2; %mass of wheel module [kg]
k = 500; %Spring Stiffness [N/m]
kt = 50000; %Tire Stiffness [N/m]
b = 100; %Damper [N-s/m]

%X1
A1 = kt*b;
B1 = kt*k;
C1 = mwm*mr/4;
D1 = b*(mwm+mr/4);
E1 = k*(mwm+mr/4)+kt*mr/4;
F1 = kt*b;
G1 = k*kt;   

%X3
A3 = kt*mwm;
B3 = kt*b;
C3 = kt*k;
D3 = mwm*mr/4;
E3 = b*(mwm+mr/4);
F3 = k*(mwm+mr/4)+kt*mr/4;
G3 = kt*b;
H3 = k*kt;

H1 = tf([A1, B1],[C1, D1, E1, F1, G1]);
H3 = tf([A3, B3, C3],[D3, E3, F3, G3, H3]);

figure(1);
hold on;

bode(H1,{1,100})
bode(H3,{1,100})
grid on
title("Bode (k: " +num2str(k)+ " [N/m], kt: " +num2str(kt)+ " [N/m], b: " +num2str(b)+ " [N-s/m])");
legend();

hold off;

figure(2)
hold on;

stepplot(H1)
stepplot(H3)
title("Step Response (k: " +num2str(k)+ " [N/m], kt: " +num2str(kt)+ " [N/m], b: " +num2str(b)+ " [N-s/m])");
legend();

hold off;





