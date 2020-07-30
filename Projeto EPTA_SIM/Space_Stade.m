%% Stade_space

clc; clear all; close all;


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

%% Longitudinal dynamics

% Derivatives
C_D_u = -0.016;                     % Taxa de variação do arrasto em função do mach [regressão/datcom]
C_D_1 = 0.027;                      % Taxa de variação do arrasto em função da condição de trimagem [datcom direto]
C_D_alpha = 0;                      % Taxa de variação do arrasto em função do ângulo de ataque [Regressão/datcom ou aerolab]
C_D_de = 0;                         % Taxa de variação do arrasto em função do ângulo de deflexão [regressão/datcom]
 
C_T_x_u = 0;
C_T_x_1 = 0;
 
C_L_1 = 0.06;                       % Taxa de variação da sustentação em função da condição de trimagem [datcom direto]
C_L_u = 0.006;                      % Taxa de variação do sustentação em função do mach [regressão/datcom]
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

%% Longitudinal Control

subplot(2,1,2);
impulse(A1,B1,C1,D1,1)
title('Resposta em Malha Aberta')

%%%%%%%%% Controlador do tipo LQR com Otimização %%%%%%%%%%%%%%%%%%%%%%%%%%
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

K=lqr(A1,B1,Q,R);
% Fechando a malha
Ac = (A1-B1*K);
Bc = B1;
Cc = C1;
figure;
y = impulse(Ac,Bc,Cc,D1,1);
for i=1:length(y)
    u(:,i) = (-K*y(i,:)')';
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



%% PARA FOGUETES SIMÉTRICOS APENAS A DINAMICA LONGITUDINAL BASTA PARA DEFINIR COMPLETAMENTE O MODELO!!!!!!!!!!!!!!!!!!!!!!!!
%% Lateral Dynamics
% alpha_d = 0;
% alpha_1 = 0*pi/180;
%  
% b = 10.9728;
% S = 16.1651;
% m = 1202.02;
% c_bar = 1.49352;
% q_bar_1 = 2374.861;
% U_1 = 67.08648;
% theta_1 = alpha_1;
% g = 9.81;
% 
% I_xx = 1285.3154;
% I_yy = 1824.9309;
% I_zz = 2666.8939;
% I_xz = 0;
% [Ixxs, Izzs, Ixzs] = MOI(I_xx,I_zz,I_xz,alpha_d);

%%%%%%%%%%%%% Lateral Derivatives %%%%%%%%%%%%%%%%%%%%%%

% C_y_beta = -0.393;
% C_y_p = -0.075;
% C_y_r = 0.214;
% C_y_da = 0;
% C_y_dr = 0.187;
%  
% C_l_beta = -0.0923;
% C_l_p = -0.484;
% C_l_r = 0.0798;
% C_l_da = 0.229;
% C_l_dr = 0.0147;
%  
% C_n_beta = 0.0587;
% C_n_T_beta = 0;
% C_n_p = -0.0278;
% C_n_r = -0.0937;
% C_n_da = -0.0216;
% C_n_dr = -0.045;

%%%%%%%%%%%%%%%%%% Lateral Derivatives %%%%%%%%%%%%%%%%%

% Y_beta = q_bar_1 * S * C_y_beta / m;
%  
% Y_p = q_bar_1 * S * b * C_y_p / (2 * m * U_1);
%  
% Y_r = q_bar_1 * S * b * C_y_r / (2 * m * U_1);
%  
% Y_da = q_bar_1 * S * C_y_da / m;
%  
% Y_dr = q_bar_1 * S * C_y_dr / m;
%  
% L_beta = q_bar_1 * S * b * C_l_beta / Ixxs;
%  
% L_p = q_bar_1 * S * b^2 * C_l_p / (2 * Ixxs * U_1);
%  
% L_r = q_bar_1 * S * b^2 * C_l_r / (2 * Ixxs * U_1);
%  
% L_da = q_bar_1 * S * b * C_l_da / Ixxs;
%  
% L_dr = q_bar_1 * S * b * C_l_dr / Ixxs;
%  
% N_beta = q_bar_1 * S * b * C_n_beta / Izzs;
%  
% N_T_beta = q_bar_1 * S * b * C_n_T_beta / Izzs;
%  
% N_p = q_bar_1 * S * b^2 * C_n_p / (2 * Izzs * U_1);
%  
% N_r = q_bar_1 * S * b^2 * C_n_r / (2 * Izzs * U_1);
%  
% N_da = q_bar_1 * S * b * C_n_da / Izzs;
%  
% N_dr = q_bar_1 * S * b * C_n_dr / Izzs;


%%%%%%%%%%%%%%%%%% Xdot = Ax + Bu : Lateral %%%%%%%%%%%%%%%%%%%%

% A2 = [Y_beta/U_1 Y_p/U_1 Y_r/U_1-1 g*cos(theta_1)/U_1;
%     L_beta L_p L_r 0;
%     N_beta+N_T_beta N_p N_r 0;
%     0 1 0 0];
% 
% B2 = [Y_da/U_1 Y_dr/U_1;
%     L_da L_dr;
%     N_da N_dr;
%     0 0];
% 
% C2 = [1 0 0 0;
%     0 1 -Ixzs/Ixxs 0;
%     0 -Ixzs/Izzs 1 0;
%     0 0 0 1];
% 
% D2 = [0 0;
%     0 0;
%     0 0;
%     0 0];
% 
% sys2 = ss(A2, B2, C2, D2);
% [num3, den3] = ss2tf(A2, B2, C2, D2, 1);
% [num4, den4] = ss2tf(A2, B2, C2, D2, 2);
% 
% beta_da = tf(num3(1,:),den3);
% p_da = tf(num3(2,:),den3);
% r_da = tf(num3(3,:),den3);
% phi_da = tf(num3(4,:),den3);
% 
% beta_dr = tf(num4(1,:),den4);
% p_dr = tf(num4(2,:),den4);
% r_dr = tf(num4(3,:),den4);
% phi_dr = tf(num4(4,:),den4);
% 
% Lateral_roots = roots(den3);
% ROOTS.Lateral_roots = Lateral_roots;
% 
% 
% figure
% re_lat = real(ROOTS.Lateral_roots);
% im_lat = imag(ROOTS.Lateral_roots);
% plot(re_lat,im_lat,'x','MarkerSize',20)
% set(gcf, 'Color', 'w');
% set(gca,'GridLineStyle', '-');
% title('Lateral-Directional Root Locus')
% xlabel('real')
% ylabel('imag')



%% Lateral Diretional Damping, Frequencies, time constants
% roll
% [re_lat,d]=sort(re_lat); im_lat = im_lat(d);
% T.T_roll = -1/re_lat(1);


% spiral
% if im_lat(2)== 0
%     T.T_spiral = -1/re_lat(2);
% else
%     T.T_spiral = -1/re_lat(3);
%     
% end

% dutch Roll
% if im_lat(2)== 0
%     WN.wn_dr = sqrt(im_lat(3)^2+re_lat(3)^2);
%     CSI.csi_dr = abs(re_lat(3))/WN.wn_dr;
% else
%     WN.wn_dr = sqrt(im_lat(2)^2+re_lat(2)^2);
%     CSI.csi_dr = abs(re_lat(2))/WN.wn_dr;
% end
