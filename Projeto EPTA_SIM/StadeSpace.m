clc; clear all; close all;
%% Dimensional derivatives

S = 1;
m = 1;
U1 = 1;
Cd_u = 1;
Cd_1 = 1;



[T, a, P, rho] = atmosisa(H);

q1 = 0.5*rho*V^2;

%% Longitudinal

x_u = -q1*S*(Cd_u + 2*Cd_1)/(m*U1);



