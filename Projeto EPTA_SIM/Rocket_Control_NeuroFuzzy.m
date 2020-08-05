clc; clear all; close all;
%% Modelo dinâmico %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha_d = 0;                        % Ângulo alfa de trimagem [rad]
alpha_1 = 0*pi/180;                 % Ângulo alfa desejado [rad]
H = 250;                            % Altitude do voo [m]
[T, a, P, rho] = atmosisa(H);       % Condições atmosféricas para altitude desejada

Cr = 0.0748;                        % Corda Raiz [m]
Ct = 0.056;                         % Corda Ponta [m]
b = 0.2118;                         % Envergadura [m]
S = b*(Cr + Ct)/2;                  % Área de Referência [m^2] (Para aleta trapezoidal)
m = 0.7819;                         % Massa [Kg]
U_1 = 0.35*340;                     % Velocidade [m/s]
g = 9.81;                           % Gravidade [m/s^2]
q_bar_1 = 0.5*rho*U_1^2;            % Pressão dinâmica
theta_1 = alpha_1;

lamb = Ct/Cr;                                   % Relação de Afilamento
c_bar = (2/3)*Cr*((1+lamb+lamb^2)/(1+lamb));    % Corda média aerodinâmica [m]

I_xx = 0.0012;                      % Componente inercial Ixx [Kg*m^2]
I_yy = 0.2248;                      % Componente inercial Iyy [Kg*m^2]
I_zz = 0.2248;                      % Componente inercial Izz [Kg*m^2]
I_xz = 0;
[Ixxs, Izzs, Ixzs] = MOI(I_xx,I_zz,I_xz,alpha_d);

%% Dinâmica Longitudinal

% Derivatives
C_D_u = -0.016;              % Taxa de variação do arrasto em função do mach [regressão/datcom]
C_D_1 = 0.027;               % Taxa de variação do arrasto em função da condição de trimagem [datcom direto]
C_D_alpha = 0;               % Taxa de variação do arrasto em função do ângulo de ataque [Regressão/datcom ou aerolab]
C_D_de = 0;                  % Taxa de variação do arrasto em função do ângulo de deflexão [regressão/datcom]
 
C_T_x_u = 0;
C_T_x_1 = 0;
 
C_L_1 = 0.06;                % Taxa de variação da sustentação em função da condição de trimagem [datcom direto]
C_L_u = 0.006;               % Taxa de variação do sustentação em função do mach [regressão/datcom]
C_L_alpha = 0.0305;
C_L_alpha_dot = 0;  
C_L_q = 0.2034;
C_L_de = 0.0098;
 
C_m_u = -0.027;
C_m_1 = -0.1387;
C_m_T_u = 0;
C_m_T_1 = 0;
C_m_alpha = -0.0701;
C_m_alpha_dot = 0;
C_m_T_alpha = 0;
C_m_q = -0.5789;
C_m_de = -0.0344;
 

%%%%%%%%% Longitudinal Derivatives %%%%%%%%%%

X_u = - q_bar_1 * S * (C_D_u + 2 * C_D_1) / (m * U_1);
X_T_u = q_bar_1 * S * (C_T_x_u + 2 * C_T_x_1) / (m * U_1);
X_alpha = - q_bar_1 * S * (C_D_alpha - C_L_1) / m;
X_de = - q_bar_1 * S * C_D_de / m;
Z_u = - q_bar_1 * S * (C_L_u + 2 * C_L_1) / (m * U_1);
Z_alpha = - q_bar_1 * S * (C_L_alpha + C_D_1) / m;
Z_alpha_dot = - q_bar_1 * S * c_bar * C_L_alpha_dot / (2 * m * U_1);
Z_q = - q_bar_1 * S * c_bar * C_L_q / (2 * m * U_1);
Z_de = - q_bar_1 * S * C_L_de / m;
M_u = q_bar_1 * S * c_bar * (C_m_u + 2 * C_m_1) / (I_yy * U_1);
M_T_u = q_bar_1 * S * c_bar * (C_m_T_u + 2 * C_m_T_1) / (I_yy * U_1);
M_alpha = q_bar_1 * S * c_bar * C_m_alpha / I_yy;
M_T_alpha = q_bar_1 * S * c_bar * C_m_T_alpha / I_yy;
M_alpha_dot = q_bar_1 * S * c_bar^2 * C_m_alpha_dot / (2 * I_yy * U_1);
M_q = q_bar_1 * S * c_bar^2 * C_m_q / (2 * I_yy * U_1);
M_de = q_bar_1 * S * c_bar * C_m_de / I_yy;

%%%%%%%%%%%%%%%%% Xdot = Ax + Bu : Longitudinal %%%%%%%%%%%%%%%%%

global A1;
global B1;
global C1;
global D1;
A1 = [X_u+X_T_u X_alpha 0 -g*cos(theta_1);
    Z_u/U_1 Z_alpha/U_1 Z_q/U_1+1 -g*sin(theta_1)/U_1;
    M_u+M_T_u M_alpha+M_T_alpha M_q 0
    0 0 1 0];

B1 = [X_de;
    Z_de/U_1;
    M_de;
    0];

C1 = [1 0 0 0;
    0 1-Z_alpha_dot/U_1 0 0;
    0 -M_alpha_dot 1 0;
    0 0 0 1];

D1 = [0;
    0;
    0;
    0];

sys1 = ss(A1, B1, C1, D1);
[num1, den1] = ss2tf(A1, B1, C1, D1, 1);
%[num2, den1] = ss2tf(A1, B1, C1, D1, 2);

u_de = tf(num1(1,:),den1);
alpha_de = tf(num1(2,:),den1);
q_de = tf(num1(3,:),den1);
theta_de = tf(num1(4,:),den1);

Longitudinal_roots = roots(den1);
ROOTS.Longitudinal_roots = Longitudinal_roots;

figure;
re_long = real(ROOTS.Longitudinal_roots);
im_long = imag(ROOTS.Longitudinal_roots);
subplot(2,1,1);
plot(re_long,im_long,'x','MarkerSize',20)
grid on;
set(gcf, 'Color', 'w');
set(gca,'GridLineStyle', '-');
title('Longitudinal Root Locus OL')
xlabel('real')
ylabel('imag')

% Longitudinal Damping and frequencies
% short period
[re_long,b]=sort(re_long); im_long = im_long(b);
WN.wn_ph = sqrt(im_long(3)^2+re_long(3)^2);
CSI.csi_ph = abs(re_long(3))/WN.wn_ph;

% phugoid
WN.wn_sh = sqrt(im_long(1)^2+re_long(1)^2);
CSI.csi_sh = abs(re_long(1))/WN.wn_sh;

%% Extenção da matriz dinâmica %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ar = zeros(6,6);
% Ar(1:4,1:4) = A1;
% Ar(5,1) = sin(theta_1);
% Ar(5,2) = cos(theta_1)*U_1;
% Ar(5,4) = U_1*(sin(theta_1 + cos(theta_1)*alpha_1));
% Ar(6,1) = cos(theta_1);
% Ar(6,2) = -sin(theta_1)*U_1;
% Ar(6,4) = -U_1*(cos(theta_1 - sin(theta_1)*alpha_1));
% Br = [B1(:,1); 0; 0];
% Cr = eye(6);
% Dr = zeros(6,1);
% sys_r = ss(Ar, Br, Cr, Dr);
% [numr, denr] = ss2tf(Ar, Br, Cr, Dr, 1);
% z_de = tf(numr(5,:),denr);
% x_de = tf(numr(6,:),denr);
% 
% Q=diag([1,0.1,1,5,5,10]);
% rho=100;
% R=rho;
% Kreg=lqr(Ar,Br,Q,R);
% % Fechando a malha
% Ac = (Ar-Br*Kreg);
% Bc = Br;
% Cc = Cr;
% figure;
% impulse(Ac,Bc,Cc,Dr,1);

%% Longitudinal Control LQR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,1,2);
impulse(A1,B1,C1,D1,1)
title('Resposta em Malha Aberta')

%%%%%%%% Controlador do tipo LQR com Otimização %%%%%%%%%%%%%%%%%%%%%%%%%%
Q = zeros(4,4);
f_lqr = @LQR;

% Otimização por meio de mínimo da função
% x0 = zeros(1,5);
% x0(1) = 1;
% x0(3) = 1;
% x0(5) = 1;
% [aux, fval] = fminsearch(f_lqr, x0);
% PARA ESSA OTIMIZACAO: 0.8609    0.0004    1.0789   0    1.0616

%  Otimização por meio de Algorítimo genético
%[Ma,Da] = otmin(); % RODAR APENAS UMA VEZ PQ DEMORA PRA PORRA
% Ma = 0.0003    0.1124    0.1218    0.1148    1.4859
% Da = 0.0007    0.2442    0.2679    0.2580    0.7437

% Aplicação da otimização
Q(1,1) = 0.0003;
Q(1,1) = 0.1124;
Q(3,3) = 0.1218;
Q(4,4) = 0.1148;
R = 1.4859;

Kreg=lqr(A1,B1,Q,R);
% Fechando a malha
Ac = (A1-B1*Kreg);
Bc = B1;
Cc = C1;
figure;
y = impulse(Ac,Bc,Cc,D1,1);
for i=1:length(y)
    u(:,i) = (-Kreg*y(i,:)')';
end
plot(u(1,:))
title('Deflexão da Aleta')
xlabel('Time')
ylabel('Angle [rad]')
grid on;
figure
impulse(Ac,Bc,Cc,D1,1);
grid on;
title('Resposta em Malha Fechada (LQR)')

% Modelagem do filtro de Kalman
[n_b,m_b] = size(B1);
Bnoise = eye(n_b);
W_k = eye(n_b);
V_k = 0.01*eye(m_b);
D_k = zeros(4,5);
Estss = ss(A1,[B1 Bnoise], C1, D_k);
[Kess, Ke] = kalman(Estss, W_k, V_k);



%% 


