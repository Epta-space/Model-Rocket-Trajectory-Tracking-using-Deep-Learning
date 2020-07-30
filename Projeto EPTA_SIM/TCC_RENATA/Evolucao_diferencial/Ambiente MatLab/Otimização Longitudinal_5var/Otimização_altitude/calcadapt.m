%FUNÇAO QUE FAZ O CONTROLE ADAPTATIVO

function [Cf,h,de,t]=calcadapt(prop)
 global C D G H dt % tornando essas variáveis globais para serem visualizadas  em todo programa

prop_SBRF1=[-prop(2) -prop(1) 0 prop(1) prop(2)];
prop_SBRF2 = [-0.4210 0  0.4210];
 
 %%%% criação dos vetores theta e de:
 ttotal=150; %tempo total de simulação
 t=0:dt:ttotal;
 nt=length(t);
 set=setpoint(t);
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
    if erro_h>5
        erro_h=5;
    elseif erro_h<-5
        erro_h=-5;
    end
    set_theta=control_NF_altitude(erro_h,prop_SBRF1);
    erro_theta=set_theta-theta;
    if erro_theta>20*pi/180
        erro_theta=20*pi/180;
    elseif erro_theta<-20*pi/180
        erro_theta=-20*pi/180;
    end
    de(i)=control_NF_theta(erro_theta,de(i-1),prop_SBRF2);
    if de(i)>23*pi/180
        de(i)=23*pi/180;
    elseif de(i)<-23*pi/180
        de(i)=-23*pi/180;
    end
    [resp,X]=RespModelo(X,de(i),C,D,G,H); %%% entrada e saída: vetores nx1
    theta=resp(4);
    h(i+1)=calcparam(resp,dt,h(i)); 
end
 ref=refdet(set,h,dt);
 Cf=-(1*sum(sqrt((ref-h).^2))/nt);

end 