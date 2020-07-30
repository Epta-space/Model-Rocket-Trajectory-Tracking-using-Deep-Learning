%FUNÇAO QUE FAZ O CONTROLE ADAPTATIVO

function [Cf,theta,de,t]=calcadapt(prop) 
 global C D G H dt % tornando essas variáveis globais para serem visualizadas  em todo programa

 prop=[-prop 0 prop];
 
 %%%% criação dos vetores theta e de:
 ttotal=100; %tempo total de simulação
 t=0:dt:ttotal;
 nt=length(t);
 theta=zeros(1,nt);
 perturbacao=disturb(t);
 set=setpoint(t);
 T=0.02;
 de_s=zeros(1,nt);
 de=zeros(1,nt);
 erro0=0;
 interro=0;
 erro_theta=0;
 
 %%%%%% Determinação das condições iniciais %%%%%%%
 theta(1)=perturbacao(1);
 X=[0;0;0;perturbacao(1)];
 erro_theta=(set(1)-theta(1));

 
 for i=2:nt
     if erro_theta>20*pi/180
        erro_theta=20*pi/180;
    elseif erro_theta<-20*pi/180
        erro_theta=-20*pi/180;
    end
     de_s(i)=control_NF(erro_theta,de_s(i-1),prop);
     if de_s(i)>23*pi/180
        de_s(i)=23*pi/180;
    elseif de_s(i)<-23*pi/180
        de_s(i)=-23*pi/180;
     end
    
     de(i)=(20*T*de_s(i)+de(i-1))/(1+20*T);
     
     if perturbacao(i)==0
        [resp,X]=RespModelo(X,de(i),C,D,G,H); %%% entrada e saída: vetores nx1
        theta(i)=resp(4);
     else
         [resp,X]=RespModelo(X,de(i),C,D,G,H); %%% entrada e saída: vetores nx1
         theta(i)=resp(4)+perturbacao(i);
         X(4)=resp(4)+perturbacao(i);
     end
     erro0=erro_theta;
     erro_theta=(set(i)-theta(i));
     
 end
 
 ref=refdet(set,theta,dt);
 
 Cf=(1*sum(sqrt((ref-theta).^2))/nt);
 
end 