clear all;close all;clc
%% Condi��es Iniciais
global g
global I
global T
global m

% Curva de queima do motor
a = csvread('tt2.csv');
x_t = a(:,1);
y_T = a(:,2);
T = fit(x_t, y_T,'smoothingspline');

% Atribui��o das vari�veis globais
% Colocar massa variavel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = 2;                  % Massa do Foguete [Kg]
g = 9.80665;            % Gravidade [m/s^2]

% Dados de in�rcia do foguete
Ixx = 1;
Iyy = 1;
Izz = 1;
I = [Ixx Iyy Izz];      % In�rcia do Foguete


% Condi��es iniciais de lan�amento
u_init =        0;          % Velocidade de Transla��o inicial no eixo x
v_init =        0;          % Velocidade de Transla��o inicial no eixo y
w_init =        0;          % Velocidade de Transla��o inicial no eixo z
P_init =        0;          % Velocidade de Rota��o inicial em rel. ao eixo x
Q_init =        0;          % Velocidade de Rota��o inicial em rel. ao eixo y
R_init =        0;          % Velocidade de Rota��o inicial em rel. ao eixo z
fi_init =       0;          % Dire��o inicial em rela��o ao eixo x (Rolagem)
theta_init =    pi/2;       % Dire��o inicial em rela��o ao eixo y (Arfagem)
psi_init =      0;          % Dire��o inicial em rela��o ao eixo z (Guinada)
xe_init =       0;          % Posi��o inicial em rela��o ao ICS no eixo x
ye_init =       0;          % Posi��o inicial em rela��o ao ICS no eixo y
ze_init =       0;          % Posi��o inicial em rela��o ao ICS no eixo z
y = [u_init  v_init  w_init  P_init  Q_init  R_init  fi_init  theta_init  psi_init xe_init ye_init ze_init]';

% Tempo de Simula��o
t_init =    0;                  % Tempo inicial de simula��o
t_final =   300;                % Tempo final de simula��o
t_span =    [t_init t_final];   % Vetor de Tempo


%% M�todo de Integra��o num�rica

[t,y] = ode45(@rocket_sim_ode_V2, t_span, y);

%% Plot das sa�das no tempo

y=y';
figure
plot(t,y(1,:),t,y(2,:),t,y(3,:),t,y(4,:),t,y(5,:),t,y(6,:),'LineWidth', 2);
title('Velocidades de Transla��o e Rota��o');
ylabel('Velocidade [m/s] [rad/s]');
xlabel('Tempo(s)');
grid on
legend('u','v','w','P','Q','R')

figure
plot(t,y(7,:),t,y(8,:),t,y(9,:),'LineWidth', 2);
title('�ngulos de Euler');
ylabel('�ngulo [rad]');
xlabel('Tempo(s)');
grid on
legend('fi','theta','psi')

figure
subplot(3,1,1)
plot(t,y(10,:))
title('Posi��o em x');
ylabel('Dist�ncia(m)');
xlabel('Tempo(s)');
grid on
subplot(3,1,2)
plot(t,y(11,:))
title('Posi��o em y');
ylabel('Dist�ncia(m)');
xlabel('Tempo(s)');
grid on
subplot(3,1,3)
plot(t,-y(12,:));
title('Posi��o em z');
ylabel('Dist�ncia(m)');
xlabel('Tempo(s)');
grid on

figure
plot3(y(10,:),y(11,:),-y(12,:), 'r','LineWidth', 1.5)
zlabel('Altitude [m]')
ylabel('Dist�ncia em y [m]');
xlabel('Dist�ncia em x [m]');
grid on

%% Simula��o
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