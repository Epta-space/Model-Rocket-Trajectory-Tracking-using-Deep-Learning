function [h]=calcparam(param,dt,h)
%param � o vetor de estados [u_ponto w q theta]
u=param(1); % param(1) � resp(1) que � u_ponto
U0=68.34;  % 68.34 � a velocidade de cruzeiro
U=U0+u; 

w=param(2); %param(2) � resp(2) que � w
W0=0; 
W=W0+w;

theta=param(4); % param(4) � theta
alpha=atan2(W,U);

gama=theta-alpha; %diferen�a entre arfagem e angulo de ataque da aeronave 
%gama = angulo de subida
cr=sqrt(U*U+W*W)*sin(gama); % mecanica classica

h=h+cr*dt;

end