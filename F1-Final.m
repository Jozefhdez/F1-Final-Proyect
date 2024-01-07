clc
close all
clear all

%Calculo de Posicion
x = (0:0.1:7);
y = (0.1455026455 * x.^3) - (1.60978836 * x.^2) + (3.853174603 * x) +  0.00000000000012256862;

%Derivada
primeraDeri = (0.4365079365 * x.^2) - (3.21957672 * x) + 3.85317460317495;
segDeri = (0.4365079365 * 2 * x) - 3.21957672;

%Angulo de curva de coeficiente
beta = 35;
coeficiente = 0.89;

%Tiempo de Simulacion
speed_avg = 96.135;
dist = 529.0877996;
time = dist / speed_avg;

%Dimensiones
track_width = 5;
car_width = 0.5;
car_height = 2;
unit_to_m = 1658.3*.0254;

%Graficacion de Circuito
figure
plot(x,y, "LineWidth", track_width, "Color", "k"); %Circuito
hold on
plot(x,y); %Linea central del circuito

masa = 800;
p_x = x(1);
p_y = y(1);

p_0 = plot(p_x, p_y, "r*");

A = [-0.2143, 1.0125];
B = [0.2451, 2.2287];
C = [-0.3033, 2.4463];
D = [-.7679, 1.2167];

plot([A(1),B(1)], [A(2), B(2)], "black"); %AB
plot([A(1), D(1)], [A(2), D(2)], "black"); %AD
plot([C(1), D(1)], [C(2), D(2)], "black"); %CD
plot([B(1), C(1)], [B(2), C(2)], "black"); %BC

A = [3.2063, 1.5915];
B = [3.8237, .4424];
C = [4.3406, 0.7318];
D = [3.7277, 1.8675];

plot([A(1),B(1)], [A(2), B(2)], "black"); %AB
plot([A(1), D(1)], [A(2), D(2)], "black"); %AD
plot([C(1), D(1)], [C(2), D(2)], "black"); %CD
plot([B(1), C(1)], [B(2), C(2)], "black"); %BC


A = [3.5169, -1.112];
B = [4.0983, -2.2798];
C = [3.5717, -2.5411];
D = [2.9858, -1.3689];

plot([A(1),B(1)], [A(2), B(2)], "black"); %AB
plot([A(1), D(1)], [A(2), D(2)], "black"); %AD
plot([C(1), D(1)], [C(2), D(2)], "black"); %CD
plot([B(1), C(1)], [B(2), C(2)], "black"); %BC

A = [5.2754, -3.8987];
B = [6.5754, -3.9019];
C = [6.5776, -4.4919];
D = [5.2754, -4.488];

plot([A(1),B(1)], [A(2), B(2)], "black"); %AB
plot([A(1), D(1)], [A(2), D(2)], "black"); %AD
plot([C(1), D(1)], [C(2), D(2)], "black"); %CD
plot([B(1), C(1)], [B(2), C(2)], "black"); %BC


t = 0;
dt = .005;
i = 0;
exed = false;
v_x = 0;
v_y = 0;
v = 0;
perdida_total = 0;
warning = text(4,2.8,"");
while p_x < 7
    t = t + dt;
    i = i+1;
    r_tmp = (1+((0.4365079365 * p_x^2) - (3.21957672 * p_x) + 3.85317460317495)^2)^(3/2) / abs((0.4365079365 * 2 * p_x) - 3.21957672);
    r_tmp = r_tmp * unit_to_m;
    %v_max = (((r_tmp * 9.81 *(sind(beta) + coeficiente*cosd(beta) )) / (cosd(beta) - coeficiente*sind(beta))))^.5;

    v_max = sqrt((r_tmp * 9.81) * (sind(beta) + (coeficiente * cosd(beta))) / (cosd(beta) - (coeficiente * sind(beta))));
    v_max = v_max /unit_to_m;

    v = .9;

    a = v;
    %v = min(v_max,2.492828962);
    a = (v-a)/dt;
    %disp([v, a]);
    
    %p_x = t*();
    %p_y = t*(v_max*sin(atan( (0.4365079365 * p_x^2) - (3.21957672 * p_x) + 3.85317460317495 )));
    
    if v > v_max
        exed = true;
       
        %disp(v*unit_to_m);
    end

    if exed
        theta = theta;
        warning = text(4,2.8,"Derrape");
    else
        %disp([p_x, v_max]);
        theta = (0.4365079365 * p_x^2) - (3.21957672 * p_x) + 3.85317460317495;
    end 

    v_x = v*cos(atan(theta));
    v_y = v*sin(atan( theta));

    aux_x = p_x;
    aux_y = p_y;

    p_x = p_x + dt * v_x;
    p_y = p_y + dt* v_y;

    distancia = sqrt((p_x-aux_x)^2 + (p_y- aux_y)^2);
    perdida_energia = masa * 9.81 * coeficiente * distancia * unit_to_m * cosd(beta);
    perdida_total = perdida_total+perdida_energia;
    %disp([p_x, perdida_energia]);
    
    %disp(a);-

    set(p_0, "xdata", p_x, "ydata", p_y);
    
    % AQUI--------------------------------------------------------
    pos_x_m = p_x * unit_to_m;
    pos_y_m = p_y * unit_to_m;
    v_m = v*unit_to_m;
    a_m = a*unit_to_m;
    
    pos_x_txt = text(-0.8,-1, "X: " + pos_x_m)
    pos_y_txt = text(-0.8,-1.5, "Y: " + pos_y_m)
    v_txt = text(-0.8,-2, "Velocidad: " + v_m + "m/s")
    a_txt = text(-0.8,-2.5, "Aceleración: " + a_m + "m/s^2")
    energia_txt = text(-0.8,-3, "Perdidad de energia: " + perdida_energia + "J")
    t_txt = text(-0.8,-3.5, "Tiempo: " + t + "s")
    
    frame(i) = getframe(gcf);
    pause(.0001);
    
    delete(pos_x_txt)
    delete(pos_y_txt)
    delete(v_txt)
    delete(a_txt)
    delete(energia_txt)
    delete(t_txt)
    delete(warning)
end

%disp(perdida_total);
disp(x);
aa = axes;
set(aa, "units", "normalized", "pos", [0 0 1 1]);
axis off
xlabel("Tiempo")
movie(frame)
