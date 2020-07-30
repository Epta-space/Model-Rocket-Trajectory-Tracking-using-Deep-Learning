%MODELO OTIMIZADO DA PLANTA

function [A,B,C,D]= model()

%%%%%%%%% CÁLCULO DOS PARÂMETROS %%%%%%%%%%%%%%%%%

%%%%%%%%%%% Parâmetros de Trimagem %%%%%%%%%%%%%%

U0=68.34;
Q0=0;
W0=0;
theta0=0;
phi0=0;
dagust=0;
dbgust=0;
%%% O empuxo é definido de 0 a 1!!

%%%%%%%%%%%% Parâmetros de Inércia %%%%%%%%%%%%%%%

m=1202;  %kg
Ix=1285; %kgm2
Iy=1825; %kgm2
Iz=2667; %kgm2
Ixz=0; %kgm2

%%%%% Parâmetros Aerodinâmicos e Propulsivos %%%%

g=9.81; %m/s2
c=1.49; %m corda média aerodinâmica
b=10.97;%m comprimento da semiasa
S=16.165; %m2
rho =1.0170; %kg/m3
p_din = 0.5*rho*U0^2;

%%%%%%%% parâmetros longitudinais

Clap=1.7000;
Cmap=-7.2700;

Cxup=0; Xup=0;
Cxwp=0; Xwp=0;
Cxqp=0; Xqp=0;
Czup=0; Zup=0;
Czwp=Clap; Zwp=-(Czwp*p_din*S*c)/(2*U0*U0);
Czqp=0; Zqp=0;
Cmup=0; Mup=0;
Cmwp=Cmap; Mwp=(Cmwp*p_din*S*c*c)/(2*U0*U0);
Cmqp=0; Mqp=0;

Cdu=0;
Cd1=0.0300;
Ctxu=-0.0960;
Ctx1=0.0320;
Cda=0.1210;
Cl1=0.3070;
Clu=0;
Cla=4.4100;
Clq=3.9000;
Cmu=0;
Cm1=0;
Cmtu=0;
Cmt1=0;
Cma=-0.6130;
Cmta=0;

Cxu=Ctxu+2*Ctx1-Cdu-2*Cd1; Xu=Cxu*p_din*S/U0;
Cxw=Cda-Cl1; Xw=-Cxw*p_din*S/U0;
Cxq=0; Xq=0;
Czu=Clu+2*Cl1; Zu=-Czu*p_din*S/U0;
Czw=Cla+Cd1; Zw=-Czw*p_din*S/U0;
Czq=Clq; Zq=-Czq*p_din*S*c/(2*U0);
Cmu=Cmu+2*Cm1+Cmtu+2*Cmt1; Mu=Cmu*p_din*S*c/U0;
Cmw=Cma+Cmta; Mw=Cmw*p_din*S*c/U0;
Cmq=-12.4000; Mq=Cmq*p_din*S*c*c/(2*U0);

Cdde=0;
Clde=0.4300;


Cxdt=3500; Xdt=Cxdt;
Cxde=Cdde; Xde=-Cxde*p_din*S;
Cxdf=0; Xdf=0;
Czdt=0; Zdt=0;
Czde=Clde; Zde=-Czde*p_din*S;
Czdf=0; Zdf=0;
Cmdt=0; Mdt=0;
Cmde=-1.1220; Mde=Cmde*p_din*S*c;
Cmdf=0; Mdf=0;


%%%%%%%% parâmetros laterais

Cyvp=0; Yvp=0;
Cypp=0; Ypp=0;
Cyrp=0; Yrp=0;
Clvp=0; Lvp=0;
Clpp=0; Lpp=0;
Clrp=0; Lrp=0;
Cnvp=0; Nvp=0;
Cnpp=0; Npp=0;
Cnrp=0; Nrp=0;

Cyb=-0.3930;
Clb=-0.0923;
Cnb=0.0587;
Cntb=0;

Cyv=Cyb; Yv=Cyv*p_din*S/U0;
Cyp=-0.0750; Yp=Cyp*p_din*S*b/(2*U0);
Cyr=0.2140; Yr=Cyr*p_din*S*b/(2*U0);
Clv=Clb; Lv=Clv*p_din*S*b/U0;
Clp=-0.4840; Lp=Clp*p_din*S*b*b/(2*U0);
Clr=0.0798; Lr=Clr*p_din*S*b*b/(2*U0);
Cnv=Cnb+Cntb; Nv=Cnv*p_din*S*b/U0;
Cnp=-0.0278; Np=Cnp*p_din*S*b*b/(2*U0);
Cnr=-0.0937; Nr=Cnr*p_din*S*b*b/(2*U0);


Cyda=0; Yda=Cyda*p_din*S;
Cydr=0.1870; Ydr=Cydr*p_din*S;
Clda=0.2290; Lda=Clda*p_din*S*b;
Cldr=0.0147; Ldr=Cldr*p_din*S*b;
Cnda=-0.0216; Nda=Cnda*p_din*S*b;
Cndr=-0.0645; Ndr=Cndr*p_din*S*b;


%%%%%%%%%% OBTENÇÃO DAS MATRIZES %%%%%%%%%%%%%%%%%


%%%%%%%%%%  Matrizes Dinâmicas - restrições dinâmicas: %%%%%%%%%%%%%%%%

%%%% modelo longitudinal:

Mlong1=[m 0 0;0 m 0; 0 0 Iy];
Klong1=[0 m*Q0 m*W0; -m*Q0 0 -m*U0; 0 0 0];
Tlong=[m*g*cos(theta0); m*g*sin(theta0)*cos(phi0);0];

%%%% modelo lateral:

Mlat1=[m 0 0;0 Ix -Ixz;0 -Ixz Iz];
Klat1=[0 -m*W0 m*U0;0 -Ixz*Q0 (Iz-Iy)*Q0; 0 (Iy-Ix)*Q0 Ixz*Q0];
Tlat=[-m*g*cos(theta0)*cos(phi0);0;0];

%%%%%%%%%%  Matrizes Dinâmicas - esforços aerodinâmicos e propulsivos: %%%%%%%%%%%%%%%%

%%%% modelo longitudinal:

Mlong2=[Xup Xwp Xqp;Zup Zwp Zqp; Mup Mwp Mqp];
Klong2=[Xu Xw Xq;Zu Zw Zq; Mu Mw Mq];
Uclong=[Xdt Xde Xdf;Zdt Zde Zdf; Mdt Mde Mdf];

%%%% modelo lateral:

Mlat2=[Yvp Ypp Yrp;Lvp Lpp Lrp; Nvp Npp Nrp];
Klat2=[Yv Yp Yr;Lv Lp Lr; Nv Np Nr];
Uclat=[Yda Ydr;Lda Ldr;Nda Ndr];


%%%%%%%%%%  Matrizes Dinâmicas Universais  %%%%%%%%%%%%%%%%

%%%% modelo longitudinal:

Mlong=Mlong1-Mlong2;
Klong=Klong1-Klong2;
Tlong;
Uclong;

%%%% modelo lateral:

Mlat=Mlat1-Mlat2;
Klat=Klat1-Klat2;
Tlat;
Uclat;

%%%% Modelo Dinâmico (Contínuo)

%%%% modelo longitudinal:

%ESTADO: {u,w,q,theta}
% ENTRADAS: {dt de df}

Along=[(-Mlong^(-1)*Klong) (-Mlong^(-1)*Tlong); 0 0 1 0];
Blong=[(Mlong^(-1)*Uclong);zeros(1,3)];

%%%% modelo lateral:

%ESTADO: {v,p,r,roll}
% ENTRADAS: {da dr}

Alat=[(-Mlat^(-1)*Klat) (-Mlat^(-1)*Tlat); 0 1 tan(theta0) 0];
Blat=[(Mlat^(-1)*Uclat);zeros(1,2)];

A=Along;
B=Blong;
C = eye(4,4);
D = zeros(4,3);

end