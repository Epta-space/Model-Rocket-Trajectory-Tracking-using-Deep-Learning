 %%%%%%%%%%%% Controle do Ângulo de Arfagem Através do Profundor %%%%%%
 
 clc
 clear all
 close all
 
 tic;
 
 global C D G H dt % tornando essas variáveis globais para serem visualizadas  em todo programa
 
 %%% Definição do meu modelo em espaço de estados
 [A B C D]= model(); %"model()" faz o cálculo do modelo da planta 
 
 %%% Discretização do modelo da planta
 dt=0.02; % tempo de amostragem adotado 0.02s
 [G,H]= convc2d(A,B,dt); %"convc2d()" faz a discretização da planta
 % As matrizes C, D (geralmente D=0), G e H definem o modelo em tempo discreto
 prop=Ev_Dif; %EvDif faz o critério de parada da otimização (devolve os parametros do controlador)
 prop=prop';
 [Cf,theta,de,t]=calcadapt(prop); 
 
 de=de*180/pi;
 theta=theta*180/pi;
 
figure (1)
plot(t,theta,'LineWidth',2)
xlabel('Tempo (s)','FontSize',16)
ylabel('Ângulo de Arfagem (º)','FontSize',16)
set(gca,'FontSize',16)

figure (2)
plot(t,de,'LineWidth',2)
xlabel('Tempo (s)','FontSize',16)
ylabel(' Deflexão Profundor (º)','FontSize',16)
set(gca,'FontSize',16)
 
  

 figure (4)
 plot(t,theta,'LineWidth',2)
 hold on
 plot(t,de,'LineWidth',2)
 
 toc;