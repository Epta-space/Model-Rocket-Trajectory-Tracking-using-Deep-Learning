%FUNÇAO QUE FAZ O CONTROLE ADAPTATIVO

function [Cf,h,de,t]=calcadapt(prop)
 global C D G H dt % tornando essas variáveis globais para serem visualizadas  em todo programa

prop_SBRF1=[-prop 0 prop];
prop_SBRF2 = [-4.4664 0 4.4664];
 
 %%%% criação dos vetores theta e de:
 ttotal=150; %tempo total de simulação
 t=0:dt:ttotal;
 nt=length(t);
 set=setpoint(t);
 T=0.02;
 de_s=zeros(1,nt);
 de=zeros(1,nt);
 
 %%%%%% Determinação das condições iniciais %%%%%%%
 theta=0;
 set_theta=0;
 erro_theta=0;
 
 h=zeros(1,nt);
 erro_h=0;
 
 cr=zeros(1,nt);
 erro_cr=0;
 
 X=[0;0;0;0];
 
for i=2:nt
    erro_h=set(i)-h(i);
    if erro_h>20
        erro_h=20;
    elseif erro_h<-20
        erro_h=-20;
    end
    set_theta=control_NF_altitude(erro_h,prop_SBRF1);
    erro_theta=set_theta-theta;
    if erro_theta>20*pi/180
        erro_theta=20*pi/180;
    elseif erro_theta<-20*pi/180
        erro_theta=-20*pi/180;
    end
    de_s(i)=control_NF_theta(erro_theta,de_s(i-1),prop_SBRF2);
    if de_s(i)>23*pi/180
        de_s(i)=23*pi/180;
    elseif de_s(i)<-23*pi/180
        de_s(i)=-23*pi/180;
    end
    
    de(i)=(20*T*de_s(i)+de(i-1))/(1+20*T);
    
    [resp,X]=RespModelo(X,de(i),C,D,G,H); %%% entrada e saída: vetores nx1
    theta=resp(4);
    h(i+1)=calcparam(resp,dt,h(i)); 
end
 ref=refdet(set,h,dt);
 Cf=(1*sum(sqrt((ref-h).^2))/nt);

end 