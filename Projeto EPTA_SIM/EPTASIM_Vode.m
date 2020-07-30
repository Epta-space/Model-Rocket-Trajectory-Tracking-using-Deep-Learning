clear all;close all;clc
%% Condições Iniciais
global g
global I
global T
global m

% Curva de queima do motor
a = csvread('tt2.csv');
x_t = a(:,1);
y_T = a(:,2);
T = fit(x_t, y_T,'smoothingspline');

% Atribuição das variáveis globais
% Colocar massa variavel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = 2;                  % Massa do Foguete [Kg]
g = 9.80665;            % Gravidade [m/s^2]

% Dados de inércia do foguete
Ixx = 1;
Iyy = 1;
Izz = 1;
I = [Ixx Iyy Izz];      % Inércia do Foguete


% Condições iniciais de lançamento
u_init =        0;          % Velocidade de Translação inicial no eixo x
v_init =        0;          % Velocidade de Translação inicial no eixo y
w_init =        0;          % Velocidade de Translação inicial no eixo z
P_init =        0;          % Velocidade de Rotação inicial em rel. ao eixo x
Q_init =        0;          % Velocidade de Rotação inicial em rel. ao eixo y
R_init =        0;          % Velocidade de Rotação inicial em rel. ao eixo z
fi_init =       0;          % Direção inicial em relação ao eixo x (Rolagem)
theta_init =    pi/2;       % Direção inicial em relação ao eixo y (Arfagem)
psi_init =      0;          % Direção inicial em relação ao eixo z (Guinada)
xe_init =       0;          % Posição inicial em relação ao ICS no eixo x
ye_init =       0;          % Posição inicial em relação ao ICS no eixo y
ze_init =       0;          % Posição inicial em relação ao ICS no eixo z
y = [u_init  v_init  w_init  P_init  Q_init  R_init  fi_init  theta_init  psi_init xe_init ye_init ze_init]';

% Tempo de Simulação
t_init =    0;                  % Tempo inicial de simulação
t_final =   300;                % Tempo final de simulação
t_span =    [t_init t_final];   % Vetor de Tempo


%% Método de Integração numérica

[t,y] = ode45(@rocket_sim_ode_V2, t_span, y);

%% Plot das saídas no tempo

y=y';
figure
plot(t,y(1,:),t,y(2,:),t,y(3,:),t,y(4,:),t,y(5,:),t,y(6,:),'LineWidth', 2);
title('Velocidades de Translação e Rotação');
ylabel('Velocidade [m/s] [rad/s]');
xlabel('Tempo(s)');
grid on
legend('u','v','w','P','Q','R')

figure
plot(t,y(7,:),t,y(8,:),t,y(9,:),'LineWidth', 2);
title('ângulos de Euler');
ylabel('Ângulo [rad]');
xlabel('Tempo(s)');
grid on
legend('fi','theta','psi')

figure
subplot(3,1,1)
plot(t,y(10,:))
title('Posição em x');
ylabel('Distância(m)');
xlabel('Tempo(s)');
grid on
subplot(3,1,2)
plot(t,y(11,:))
title('Posição em y');
ylabel('Distância(m)');
xlabel('Tempo(s)');
grid on
subplot(3,1,3)
plot(t,-y(12,:));
title('Posição em z');
ylabel('Distância(m)');
xlabel('Tempo(s)');
grid on

figure
plot3(y(10,:),y(11,:),-y(12,:), 'r','LineWidth', 1.5)
zlabel('Altitude [m]')
ylabel('Distância em y [m]');
xlabel('Distância em x [m]');
grid on

%% Simulação
% figure
% for i = 1:length(t)
%     
%     yp = -0.5*cos(y(2,i));
%     xp = -0.5*sin(y(2,i));
%     
%     plot([0 xp],[0 yp] ,'-',xp,yp,'o');

%     drawnow
%     pause(0.001)
%     
% end