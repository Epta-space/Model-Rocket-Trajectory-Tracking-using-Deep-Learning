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
m = 2;                  % Massa do Foguete [Kg]
g = 9.80665;            % Gravidade [m/s^2]

% Dados de inércia do foguete
Ixx = 1;
Iyy = 1;
Izz = 1;
I = [Ixx Iyy Izz];      % Inércia do Foguete


% Condições iniciais de lançamento
u_init =        0;
v_init =        0;
w_init =        0;
P_init =        0;
Q_init =        0;
R_init =        0;
fi_init =       0;
theta_init =    pi/2;
psi_init =      0;
y = [u_init  v_init  w_init  P_init  Q_init  R_init  fi_init  theta_init  psi_init 0 0 0]';

% Tempo de Simulação
t(1) = 0;       % Tempo Inicial
dt = 0.001;      % Passo
ts = 200;        % Tempo Final


% %% Método de Integração Numérica Runge-Kutta
for n = 1:ts/dt
    k1 = rocket_sim(y(:,n),t(n));
    k2 = rocket_sim(y(:,n) + dt*.5*k1,t(n));
    k3 = rocket_sim(y(:,n) + dt*.5*k2,t(n));
    k4 = rocket_sim(y(:,n) + dt*k3,t(n));
    y(:,n + 1) = y(:,n) + (dt/6)*(k1' + 2*k2' + 2*k3' + k4');
    t(n+1)=t(n)+dt;
end

%%
% t0 = 0;
% tf = 300;
% t_span = [t0 tf];
% ang_0 = 45;
% %x0 = [ang_0*(pi/180); 0];
% [t,y] = ode45(@rocket_sim, t_span, y);
% figure
% plot(tode,yode(:,1),'-',tode,yode(:,2),'-')
% title('Modelo ODE-45');
% 
% grid on


%% Plot das saídas no tempo
% plot(t,y(1,:),'-',t,y(2,:),'-')
% title('Pendulo Runge-Kutta');
% xlabel('Tempo t');
% ylabel('Solução y');
% grid on
% legend('omega','theta')
% y=y';
figure
plot(t,y(1,:),t,y(2,:),t,y(3,:),t,y(4,:),t,y(5,:),t,y(6,:),'LineWidth', 2);
title('Velocidades de Translação e Rotação');
ylabel('Velocidade [m/s] [rad/s]');
xlabel('Tempo');
grid on
legend('u','v','w','P','Q','R')

figure
plot(t,y(7,:),t,y(8,:),t,y(9,:),'LineWidth', 2);
title('ângulos de Euler');
ylabel('Ângulo [rad]');
xlabel('Tempo');
grid on
legend('fi','theta','psi')

figure
subplot(3,1,1)
plot(t,y(10,:))
subplot(3,1,2)
plot(t,y(11,:))
subplot(3,1,3)
plot(t,-y(12,:));
% title('ângulos de Euler');
% axis equal
% grid on

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