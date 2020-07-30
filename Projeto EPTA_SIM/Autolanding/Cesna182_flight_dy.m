%% Cesna 182 Properties

clc; clear all; close all;


alpha_d = 0;
alpha_1 = 0*pi/180;
 
b = 10.9728;
S = 16.1651;
m = 1202.02;
c_bar = 1.49352;
q_bar_1 = 2374.861;
U_1 = 67.08648;
theta_1 = alpha_1;
g = 9.81;

I_xx = 1285.3154;
I_yy = 1824.9309;
I_zz = 2666.8939;
I_xz = 0;
[Ixxs, Izzs, Ixzs] = MOI(I_xx,I_zz,I_xz,alpha_d);

%% Longitudinal dynamics

% Derivatives
C_D_u = 0;
C_D_1 = 0.0270;
C_D_alpha = 0.121;
C_D_de = 0;
 
C_T_x_u = -0.096;
C_T_x_1 = 0.032;
 
C_L_1 = 0.307;
C_L_u = 0;
C_L_alpha = 4.41;
C_L_alpha_dot = 1.7;
C_L_q = 3.9;
C_L_de = 0.43;
 
C_m_u = 0;
C_m_1 = 0.04;
C_m_T_u = 0;
C_m_T_1 = 0;
C_m_alpha = -0.613;
C_m_alpha_dot = -7.27;
C_m_T_alpha = 0;
C_m_q = -12.4;
C_m_de = -1.122;
 

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

A1 = [X_u+X_T_u X_alpha 0 -g*cos(theta_1);
    Z_u/U_1 Z_alpha/U_1 Z_q/U_1+1 -g*sin(theta_1)/U_1;
    M_u+M_T_u M_alpha+M_T_alpha M_q 0
    0 0 1 0];

B1 = [X_de 0;
    Z_de/U_1 0;
    M_de 0;
    0 0];

C1 = [1 0 0 0;
    0 1-Z_alpha_dot/U_1 0 0;
    0 -M_alpha_dot 1 0;
    0 0 0 1];

D1 = [0 0;
    0 0;
    0 0;
    0 0];

sys1 = ss(A1, B1, C1, D1);
[num1, den1] = ss2tf(A1, B1, C1, D1, 1);
[num2, den1] = ss2tf(A1, B1, C1, D1, 2);

u_de = tf(num1(1,:),den1);
alpha_de = tf(num1(2,:),den1);
q_de = tf(num1(3,:),den1);
theta_de = tf(num1(4,:),den1);

Longitudinal_roots = roots(den1);
ROOTS.Longitudinal_roots = Longitudinal_roots;

figure
re_long = real(ROOTS.Longitudinal_roots);
im_long = imag(ROOTS.Longitudinal_roots);
plot(re_long,im_long,'x','MarkerSize',20)
set(gcf, 'Color', 'w');
set(gca,'GridLineStyle', '-');
title('Longitudinal Root Locus')
xlabel('real')
ylabel('imag')

% Longitudinal Damping and frequencies
% short period
[re_long,b]=sort(re_long); im_long = im_long(b);
WN.wn_ph = sqrt(im_long(3)^2+re_long(3)^2);
CSI.csi_ph = abs(re_long(3))/WN.wn_ph;

% % phugoid
WN.wn_sh = sqrt(im_long(1)^2+re_long(1)^2);
CSI.csi_sh = abs(re_long(1))/WN.wn_sh;

%% Lateral Dynamics
alpha_d = 0;
alpha_1 = 0*pi/180;
 
b = 10.9728;
S = 16.1651;
m = 1202.02;
c_bar = 1.49352;
q_bar_1 = 2374.861;
U_1 = 67.08648;
theta_1 = alpha_1;
g = 9.81;

I_xx = 1285.3154;
I_yy = 1824.9309;
I_zz = 2666.8939;
I_xz = 0;
[Ixxs, Izzs, Ixzs] = MOI(I_xx,I_zz,I_xz,alpha_d);

%%%%%%%%%%%%% Lateral Derivatives %%%%%%%%%%%%%%%%%%%%%%

C_y_beta = -0.393;
C_y_p = -0.075;
C_y_r = 0.214;
C_y_da = 0;
C_y_dr = 0.187;
 
C_l_beta = -0.0923;
C_l_p = -0.484;
C_l_r = 0.0798;
C_l_da = 0.229;
C_l_dr = 0.0147;
 
C_n_beta = 0.0587e-3;
C_n_T_beta = 0;
C_n_p = -0.0278;
C_n_r = -0.0937e-3;
C_n_da = -0.0216;
C_n_dr = -0.045;

%%%%%%%%%%%%%%%%%% Lateral Derivatives %%%%%%%%%%%%%%%%%

Y_beta = q_bar_1 * S * C_y_beta / m;
 
Y_p = q_bar_1 * S * b * C_y_p / (2 * m * U_1);
 
Y_r = q_bar_1 * S * b * C_y_r / (2 * m * U_1);
 
Y_da = q_bar_1 * S * C_y_da / m;
 
Y_dr = q_bar_1 * S * C_y_dr / m;
 
L_beta = q_bar_1 * S * b * C_l_beta / Ixxs;
 
L_p = q_bar_1 * S * b^2 * C_l_p / (2 * Ixxs * U_1);
 
L_r = q_bar_1 * S * b^2 * C_l_r / (2 * Ixxs * U_1);
 
L_da = q_bar_1 * S * b * C_l_da / Ixxs;
 
L_dr = q_bar_1 * S * b * C_l_dr / Ixxs;
 
N_beta = q_bar_1 * S * b * C_n_beta / Izzs;
 
N_T_beta = q_bar_1 * S * b * C_n_T_beta / Izzs;
 
N_p = q_bar_1 * S * b^2 * C_n_p / (2 * Izzs * U_1);
 
N_r = q_bar_1 * S * b^2 * C_n_r / (2 * Izzs * U_1);
 
N_da = q_bar_1 * S * b * C_n_da / Izzs;
 
N_dr = q_bar_1 * S * b * C_n_dr / Izzs;




%%%%%%%%%%%%%%%%%% Xdot = Ax + Bu : Lateral %%%%%%%%%%%%%%%%%%%%

A2 = [Y_beta/U_1 Y_p/U_1 Y_r/U_1-1 g*cos(theta_1)/U_1;
    L_beta L_p L_r 0;
    N_beta+N_T_beta N_p N_r 0;
    0 1 0 0];

B2 = [Y_da/U_1 Y_dr/U_1;
    L_da L_dr;
    N_da N_dr;
    0 0];

C2 = [1 0 0 0;
    0 1 -Ixzs/Ixxs 0;
    0 -Ixzs/Izzs 1 0;
    0 0 0 1];

D2 = [0 0;
    0 0;
    0 0;
    0 0];

sys2 = ss(A2, B2, C2, D2);
[num3, den3] = ss2tf(A2, B2, C2, D2, 1);
[num4, den4] = ss2tf(A2, B2, C2, D2, 2);

beta_da = tf(num3(1,:),den3);
p_da = tf(num3(2,:),den3);
r_da = tf(num3(3,:),den3);
phi_da = tf(num3(4,:),den3);

beta_dr = tf(num4(1,:),den4);
p_dr = tf(num4(2,:),den4);
r_dr = tf(num4(3,:),den4);
phi_dr = tf(num4(4,:),den4);

Lateral_roots = roots(den3);
ROOTS.Lateral_roots = Lateral_roots;


figure
re_lat = real(ROOTS.Lateral_roots);
im_lat = imag(ROOTS.Lateral_roots);
plot(re_lat,im_lat,'x','MarkerSize',20)
set(gcf, 'Color', 'w');
set(gca,'GridLineStyle', '-');
title('Lateral-Directional Root Locus')
xlabel('real')
ylabel('imag')



%% Lateral Diretional Damping, Frequencies, time constants
% roll
[re_lat,d]=sort(re_lat); im_lat = im_lat(d);
T.T_roll = -1/re_lat(1);


% spiral
if im_lat(2)== 0
    T.T_spiral = -1/re_lat(2);
else
    T.T_spiral = -1/re_lat(3);
    
end

% dutch Roll

if im_lat(2)== 0
    WN.wn_dr = sqrt(im_lat(3)^2+re_lat(3)^2);
    CSI.csi_dr = abs(re_lat(3))/WN.wn_dr;
else
    WN.wn_dr = sqrt(im_lat(2)^2+re_lat(2)^2);
    CSI.csi_dr = abs(re_lat(2))/WN.wn_dr;
end

%% save

% wndata= struct2cell(WN); wnnames = fieldnames(WN);
% xlswrite('Andorinha_Derivatives.xls', wnnames, Sheet, 'E12:E14')
% xlswrite('Andorinha_Derivatives.xls', wndata, Sheet, 'F12:F14')
% 
% csidata = struct2cell(CSI);
% xlswrite('Andorinha_Derivatives.xls', csidata, Sheet, 'G12:G14')
% 
% TDATA = struct2cell(T); TNAMES = fieldnames(T);
% xlswrite('Andorinha_Derivatives.xls', TNAMES, Sheet, 'E15:E16')
% xlswrite('Andorinha_Derivatives.xls', TDATA, Sheet, 'H15:H16')
% 
% 
% xlswrite('Andorinha_Derivatives.xls', Longitudinal_roots, Sheet, 'F18:F21')
% 
% 
% xlswrite('Andorinha_Derivatives.xls', Lateral_roots, Sheet, 'F23:F26')

%% Automatic Landiing

% Augmented state-space Model

 A3 = zeros(5,5);
A3(1:4,1:4)=A1;
A3(5,4)=U_1;A3(5,2)=-U_1;
%A3(6,1)=1;
B3 = [B1(:,1);zeros(1,1)];
C3 = eye(5);
D3 = zeros(5,1);
Cc = [0 0 0 0 1];

sys3 = ss(A3, B3, C3, D3);
[num3, den3] = ss2tf(A3, B3, C3, D3, 1);
h_de = tf(num3(5,:),den3);
%d_de = tf(num3(6,:),den3);

Ax = [0*eye(1,1) Cc;
    zeros(5,1) A3];

Bx = [zeros(1,1);B3];

Q=diag([1,0.1,1,5,5,10]);

rho=100000;
R=rho;
[K,Pr,Er]=lqr(Ax,Bx,Q,R);
K1 = K(:,1);
Kx = K(:,2:end);


 