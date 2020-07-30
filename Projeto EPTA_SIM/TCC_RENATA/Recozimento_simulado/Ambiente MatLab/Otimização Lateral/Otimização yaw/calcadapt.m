%FUNÇAO QUE FAZ O CONTROLE ADAPTATIVO

function [Cf,yaw,da,dr,t]=calcadapt(prop)
 global C D G H dt % tornando essas variáveis globais para serem visualizadas  em todo programa 
 
prop_SBRF1=[-prop(1) 0 prop(1)];
prop_SBRF2 = [-3.6937 0 3.6937];
prop_SBRF3 = [-prop(2) 0 prop(2)];
 
 %%%% criação dos vetores theta e de:
 ttotal=100; %tempo total de simulação
 t=0:dt:ttotal;
 nt=length(t);
 set=setpoint(t);
 T=0.02; %tempo de amostragem
 da_s=zeros(1,nt);
 da=zeros(1,nt);
 dr_s=zeros(1,nt);
 dr=zeros(1,nt);
 
 %%%%%% Determinação das condições iniciais %%%%%%%
 roll=0;
 set_roll=0;
 erro_roll=0;
 
 yaw=zeros(1,nt);
 erro_yaw=0;
 
 
 X=[0;0;0;0];

 
for i=2:nt
    erro_yaw=set(i)-yaw(i);
    if erro_yaw>20*pi/180
        erro_yaw=20*pi/180;
    elseif erro_yaw<-20*pi/180
        erro_yaw=-20*pi/180;
    end
    set_roll=control_NF_roll(erro_yaw,prop_SBRF1);
    
    erro_roll=set_roll-roll;
    if erro_roll>20*pi/180
        erro_roll=20*pi/180;
    elseif erro_roll<-20*pi/180
        erro_roll=-20*pi/180;
    end
    da_s(i)=control_NF_da(erro_roll,prop_SBRF2);
    if da_s(i)>15*pi/180
        da_s(i)=15*pi/180;
    elseif da_s(i)<-15*pi/180
        da_s(i)=-15*pi/180;
    end
    
    da(i)=(20*T*da_s(i)+da(i-1))/(1+20*T);
    
    dr_s(i)=control_NF_dr(erro_yaw,prop_SBRF3);
    if dr_s(i)>16*pi/180
        dr_s(i)=16*pi/180;
    elseif dr_s(i)<-16*pi/180
        dr_s(i)=-16*pi/180;
    end
    
    dr(i)=(20*T*dr_s(i)+dr(i-1))/(1+20*T);
    
    [resp,X]=RespModelo(X,da(i),dr(i),C,D,G,H); %%% entrada e saída: vetores nx1
    roll=resp(4);
    yaw(i+1)=calcparam(resp,dt,yaw(i)); 
end
 ref=refdet(set,yaw,dt);
 Cf=(1*sum(sqrt((ref-yaw).^2))/nt);

end 