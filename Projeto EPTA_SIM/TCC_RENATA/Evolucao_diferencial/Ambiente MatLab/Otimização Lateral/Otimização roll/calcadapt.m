%FUNÇAO QUE FAZ O CONTROLE ADAPTATIVO

function [Cf,roll,da,t]=calcadapt(prop) 
 global C D G H dt % tornando essas variáveis globais para serem visualizadas  em todo programa

 prop=[-prop 0 prop];
 
 %%%% criação dos vetores theta e de:
 ttotal=100; %tempo total de simulação
 t=0:dt:ttotal;
 nt=length(t);
 roll=zeros(1,nt);
 perturbacao=disturb(t);
 set=setpoint(t);
 T=0.02; %tempo de amostragem
 da_s=zeros(1,nt);
 da=zeros(1,nt);
 erro0=0;
 interro=0;
 erro_roll=0;
 
 %%%%%% Determinação das condições iniciais %%%%%%%
 roll(1)=perturbacao(1);
 X=[0;0;0;perturbacao(1)];
 erro_roll=(set(1)-roll(1));

 
 for i=2:nt
     if erro_roll>20*pi/180
        erro_roll=20*pi/180;
    elseif erro_roll<-20*pi/180
        erro_roll=-20*pi/180;
    end
     da_s(i)=control_NF(erro_roll,da_s(i-1),prop);
     if da_s(i)>15*pi/180
         da_s(i)=15*pi/180;
     elseif da_s(i)<-15*pi/180
         da_s(i)=-15*pi/180;
     end
     
     da(i)=(20*T*da_s(i)+da(i-1))/(1+20*T);
     
     if perturbacao(i)==0
         [resp,X]=RespModelo(X,da(i),C,D,G,H); %%% entrada e saída: vetores nx1
         roll(i)=resp(4);
     else
         [resp,X]=RespModelo(X,da(i),C,D,G,H); %%% entrada e saída: vetores nx1
         roll(i)=resp(4)+perturbacao(i);
         X(4)=resp(4)+perturbacao(i);
     end
     erro0=erro_roll;
     erro_roll=(set(i)-roll(i));
 end
 
 
 ref=refdet(set,roll,dt);
 
 Cf=(-1*sum(sqrt((ref-roll).^2))/nt);
 
end 