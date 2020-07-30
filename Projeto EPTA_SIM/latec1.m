clear all;close all;clc
%% Condições Iniciais
global g
global I
global T
global m

% Atribuicao das variaveis globais
m = 2;                  % Massa do Foguete [Kg]
g = 9.80665;            % Gravidade [m/s^2]

% Propriedades de inercia do foguete
Ixx = 1;
Iyy = 1;
Izz = 1;
I = [Ixx Iyy Izz];      % Inercia do Foguete


% Condicoes iniciais de lancamento
u_init =        0;      % [m/s]
v_init =        0;      % [m/s]
w_init =        0;      % [m/s]
P_init =        0;      % [rad/s]
Q_init =        0;      % [rad/s]
R_init =        0;      % [rad/s]
fi_init =       0;      % [rad]
theta_init =    pi/2;   % [rad]
psi_init =      0;      % [rad]
y = [u_init  v_init  w_init  P_init  Q_init  R_init  fi_init  theta_init  psi_init]';

% Tempo de Simulacao
t(1) = 0;       % Tempo Inicial
dt = 0.01;      % Passo
ts = 10;        % Tempo Final