clear all;close all;clc
% Ambiente de Simula��o para EPTA_Sim
%
% Autor: Yuri L. Almeida
%
%% Definindo vari�veis globais

global g    % Vari�vel para Gravidade
global I    % Vari�vel para Vetor de In�rcia
global T    % Vari�vel para Fun��o da Tra��o
global m    % Vari�vel para Massa
global S    % Vari�vel para �rea de Refer�ncia

%% Propriedades do Foguete

m = 0.7819;             % Massa do Foguete [Kg]
S = 0.0176;             % �rea de refer�ncia do foguete [m^2]   
Ix = 0.0012;            % Componente inercial Ixx [Kg*m^2]
Iy = 0.2248;            % Componente inercial Iyy [Kg*m^2]
Iz = 0.2248;            % Componente inercial Izz [Kg*m^2]
I = [Ix Iy Iz];         % In�rcia do Foguete

%% Condi��es iniciais de lan�amento
u_init =        0;          % Velocidade de Transla��o inicial no eixo x [m/s]
v_init =        0;          % Velocidade de Transla��o inicial no eixo y [m/s]
w_init =        0;          % Velocidade de Transla��o inicial no eixo z [m/s]
P_init =        0;          % Velocidade de Rota��o inicial em rel. ao eixo x [rad/s]
Q_init =        0;          % Velocidade de Rota��o inicial em rel. ao eixo y [rad/s]
R_init =        0;          % Velocidade de Rota��o inicial em rel. ao eixo z [rad/s]
fi_init =       0;          % Dire��o inicial em rela��o ao eixo x (Rolagem) [rad]
theta_init =    pi/2;       % Dire��o inicial em rela��o ao eixo y (Arfagem) [rad]
psi_init =      0;          % Dire��o inicial em rela��o ao eixo z (Guinada) [rad]
xe_init =       0;          % Posi��o inicial em rela��o ao ICS no eixo x [m]
ye_init =       0;          % Posi��o inicial em rela��o ao ICS no eixo y [m]
ze_init =       0;          % Posi��o inicial em rela��o ao ICS no eixo z [m]
y = [u_init  v_init  w_init  P_init  Q_init  R_init  fi_init  theta_init  psi_init xe_init ye_init ze_init]';

g = 9.80665;                % Gravidade [m/s^2]
% *Atmosfera ir� ser definida pela fun��o atmosisa para calculos aerodin�micos


%% Tempo de Simula��o
t_init =    0;                  % Tempo inicial de simula��o [s]
t_final =   600;                % Tempo final de simula��o [s]
t_span =    [t_init t_final];   % Vetor de Tempo


%% Definindo Curva de Queima do Motor

a = csvread('tt2.csv');                 % Dados obtidos experimentalmente ou via simula��o
x_t = a(:,1);
y_T = a(:,2);
T = fit(x_t, y_T,'smoothingspline');    % Fun��o de empuxo no tempo


%% M�todo de Integra��o num�rica

[t,y] = ode45(@rocket_sim_V3, t_span, y); % M�todo de integra��o do matlab


%% Plot das sa�das no tempo

y=y';
figure
subplot(3,1,1)
plot(t,y(1,:),t,y(2,:),t,y(3,:),'LineWidth', 2);
title('Velocidade de Transla��o');
ylabel('Velocidade [m/s]');
xlabel('Tempo(s)');
grid on
legend('u','v','w')
subplot(3,1,2)
plot(t,y(4,:),t,y(5,:),t,y(6,:), 'LineWidth', 2);
title('Velocidade de Rota��o');
ylabel('Velocidade [rad/s]');
xlabel('Tempo(s)');
grid on
legend('P','Q','R')
subplot(3,1,3)
plot(t,y(7,:),t,y(8,:),t,y(9,:),'LineWidth', 2);
title('�ngulos de Euler');
ylabel('�ngulo [rad]');
xlabel('Tempo(s)');
grid on
legend('fi','theta','psi')


figure
subplot(3,1,1)
plot(t,y(10,:),'LineWidth', 1.5)
title('Posi��o em x');
ylabel('Dist�ncia(m)');
xlabel('Tempo(s)');
grid on
subplot(3,1,2)
plot(t,y(11,:),'LineWidth', 1.5)
title('Posi��o em y');
ylabel('Dist�ncia(m)');
xlabel('Tempo(s)');
grid on
subplot(3,1,3)
plot(t,-y(12,:),'LineWidth', 1.5);
title('Posi��o em z');
ylabel('Dist�ncia(m)');
xlabel('Tempo(s)');
grid on

figure
plot3(y(10,:),y(11,:),-y(12,:), 'r','LineWidth', 1.5)
title('Trajet�ria no Espa�o');
zlabel('Altitude [m]')
ylabel('Dist�ncia em y [m]');
xlabel('Dist�ncia em x [m]');
grid on
axis equal


