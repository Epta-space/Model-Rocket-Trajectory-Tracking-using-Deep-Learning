clear all;close all;clc
% Ambiente de Simulação para EPTA_Sim
%
% Autor: Yuri L. Almeida
%
%% Definindo variáveis globais

global g    % Variável para Gravidade
global I    % Variável para Vetor de Inércia
global T    % Variável para Função da Tração
global m    % Variável para Massa
global S    % Variável para Área de Referência

%% Propriedades do Foguete

m = 0.7819;             % Massa do Foguete [Kg]
S = 0.0176;             % Área de referência do foguete [m^2]   
Ix = 0.0012;            % Componente inercial Ixx [Kg*m^2]
Iy = 0.2248;            % Componente inercial Iyy [Kg*m^2]
Iz = 0.2248;            % Componente inercial Izz [Kg*m^2]
I = [Ix Iy Iz];         % Inércia do Foguete

%% Condições iniciais de lançamento
u_init =        0;          % Velocidade de Translação inicial no eixo x [m/s]
v_init =        0;          % Velocidade de Translação inicial no eixo y [m/s]
w_init =        0;          % Velocidade de Translação inicial no eixo z [m/s]
P_init =        0;          % Velocidade de Rotação inicial em rel. ao eixo x [rad/s]
Q_init =        0;          % Velocidade de Rotação inicial em rel. ao eixo y [rad/s]
R_init =        0;          % Velocidade de Rotação inicial em rel. ao eixo z [rad/s]
fi_init =       0;          % Direção inicial em relação ao eixo x (Rolagem) [rad]
theta_init =    pi/2;       % Direção inicial em relação ao eixo y (Arfagem) [rad]
psi_init =      0;          % Direção inicial em relação ao eixo z (Guinada) [rad]
xe_init =       0;          % Posição inicial em relação ao ICS no eixo x [m]
ye_init =       0;          % Posição inicial em relação ao ICS no eixo y [m]
ze_init =       0;          % Posição inicial em relação ao ICS no eixo z [m]
y = [u_init  v_init  w_init  P_init  Q_init  R_init  fi_init  theta_init  psi_init xe_init ye_init ze_init]';

g = 9.80665;                % Gravidade [m/s^2]
% *Atmosfera irá ser definida pela função atmosisa para calculos aerodinâmicos


%% Tempo de Simulação
t_init =    0;                  % Tempo inicial de simulação [s]
t_final =   600;                % Tempo final de simulação [s]
t_span =    [t_init t_final];   % Vetor de Tempo


%% Definindo Curva de Queima do Motor

a = csvread('tt2.csv');                 % Dados obtidos experimentalmente ou via simulação
x_t = a(:,1);
y_T = a(:,2);
T = fit(x_t, y_T,'smoothingspline');    % Função de empuxo no tempo


%% Método de Integração numérica

[t,y] = ode45(@rocket_sim_V3, t_span, y); % Método de integração do matlab


%% Plot das saídas no tempo

y=y';
figure
subplot(3,1,1)
plot(t,y(1,:),t,y(2,:),t,y(3,:),'LineWidth', 2);
title('Velocidade de Translação');
ylabel('Velocidade [m/s]');
xlabel('Tempo(s)');
grid on
legend('u','v','w')
subplot(3,1,2)
plot(t,y(4,:),t,y(5,:),t,y(6,:), 'LineWidth', 2);
title('Velocidade de Rotação');
ylabel('Velocidade [rad/s]');
xlabel('Tempo(s)');
grid on
legend('P','Q','R')
subplot(3,1,3)
plot(t,y(7,:),t,y(8,:),t,y(9,:),'LineWidth', 2);
title('ângulos de Euler');
ylabel('Ângulo [rad]');
xlabel('Tempo(s)');
grid on
legend('fi','theta','psi')


figure
subplot(3,1,1)
plot(t,y(10,:),'LineWidth', 1.5)
title('Posição em x');
ylabel('Distância(m)');
xlabel('Tempo(s)');
grid on
subplot(3,1,2)
plot(t,y(11,:),'LineWidth', 1.5)
title('Posição em y');
ylabel('Distância(m)');
xlabel('Tempo(s)');
grid on
subplot(3,1,3)
plot(t,-y(12,:),'LineWidth', 1.5);
title('Posição em z');
ylabel('Distância(m)');
xlabel('Tempo(s)');
grid on

figure
plot3(y(10,:),y(11,:),-y(12,:), 'r','LineWidth', 1.5)
title('Trajetória no Espaço');
zlabel('Altitude [m]')
ylabel('Distância em y [m]');
xlabel('Distância em x [m]');
grid on
axis equal


