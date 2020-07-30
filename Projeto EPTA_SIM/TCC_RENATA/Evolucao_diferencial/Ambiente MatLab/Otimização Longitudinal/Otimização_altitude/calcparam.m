function [h]=calcparam(param,dt,h)
%param é o vetor de estados [u_ponto w q theta]
u=param(1); % param(1) é resp(1) que é u_ponto
U0=68.34;  % 68.34 é a velocidade de cruzeiro
U=U0+u; 

w=param(2); %param(2) é resp(2) que é w
W0=0; 
W=W0+w;

theta=param(4); % param(4) é theta
alpha=atan2(W,U);

gama=theta-alpha; %diferença entre arfagem e angulo de ataque da aeronave 
%gama = angulo de subida
cr=sqrt(U*U+W*W)*sin(gama); % mecanica classica

h=h+cr*dt;

end