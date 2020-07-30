clear;
clc;
close;

%%%% LIMITES ANGULOS CESSNA 

%%%%% Inicializando comunica��o com X-Plane

display('Iniciando comunica��o...');
sockUDP = udp('127.0.0.1', 'RemotePort', 49000, 'LocalPort', 49004);
fopen(sockUDP);
display('Comunica��o UDP inicializada.');

%%%%%%%%%%% Vari�veis de controle e armazenamento %%%%%%%%%%
tic;
flag=1;

%%%%%%%%%%%%%%% Estado Inicial %%%%%%%%%%%%%%%%%%%%%
vel=0;q=0;p=0;r=0;pitch=0;roll=0;yaw=0;lat=0;long=0;h=0;

%%%%%%%%%%% Parametros Iniciais Controlador %%%%%%%%%
set_pitch=0;
set_roll=0;

%%%%%%%%%%% Din�mica Longitudinal %%%%%%%%%%%
prop_SBRF1=[-29.6770 0 29.6770];
prop_SBRF2 = [-4.4664 0 4.4664];

%%%%%%%%%%% Din�mica L�tero-Direcional %%%%%%%%%%%
prop_SBRF3=[-0.5376 0 0.5376];
prop_SBRF4 = [-3.6937 0 3.6937];
prop_SBRF5 = [-0.1000 0 0.1000];


while 1
    
    %%%%%%%%%%%%%%% Computa Estado %%%%%%%%%%%%%%%%%%%
    msgRecv = fread(sockUDP);
    [vel,q,p,r,pitch,roll,yaw,lat,long,h]=state(msgRecv,vel,q,p,r,pitch,roll,yaw,lat,long,h);
    dt = toc;
    tic;
    
    %%%%%%%%%%%%%%%% Navega��o %%%%%%%%%%%%%%%%%%%%%%
    [set_h,set_vel,set_yaw,flag] = navigation(lat,long,yaw,vel,h,flag);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%% Controle Longitudinal %%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% determina��o do erro de altitude %%%%%%%%%
    erro_h=set_h-h;
    
    if erro_h>20
        erro_h=20;
    elseif erro_h<-20
        erro_h=-20;
    end
    
    %%%%% determina��o do valor de refer�ncia de pitch
    input=erro_h;
    set_pitch=control_NF_altitude(input,prop_SBRF1);
    
    %%%%% determina��o do erro de pitch
    erro_pitch=set_pitch-pitch;

    
    %%%%% determina��o do comando de profundor
    de=control_NF_theta(erro_pitch,prop_SBRF2);
    if de>23*pi/180
        de=23*pi/180;
    elseif de<-23*pi/180
        de=-23*pi/180;
    end
    elevatorValue=-1*(de/(23*pi/180));
    
    %%% determina��o do erro de altitude %%%%%%%%%
    erro_h=set_h-h;
    
    %%%%% determina��o do comando de throtle
    accValue=0.8;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% Controle L�tero-Direcional %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% determina��o do erro de yaw %%%%%%%%%
    erro_yaw=set_yaw-yaw;
    
    if erro_yaw>20*pi/180
        erro_yaw=20*pi/180;
    elseif erro_yaw<-20*pi/180
        erro_yaw=-20*pi/180;
    end
  
    %%%%% determina��o do valor de refer�ncia de roll
    input=erro_yaw;
    set_roll=control_NF_roll(input,prop_SBRF3);

    %%%%% determina��o do erro de roll
    erro_roll=set_roll-roll;
    
    if erro_roll>20*pi/180
        erro_roll=20*pi/180;
    elseif erro_roll<-20*pi/180
        erro_roll=-20*pi/180;
    end
    
    
    %%%%% determina��o do comando de aileron
    da=control_NF_da(erro_roll,prop_SBRF4);
    if da>15*pi/180
        da=15*pi/180;
    elseif da<-15*pi/180
        da=-15*pi/180;
    end
    aileronValue=1*(da/(15*pi/180));
    
    %%% determina��o do erro de yaw %%%%%%%%%
    erro_yaw=set_yaw-yaw;
    
    if erro_yaw>20*pi/180
        erro_yaw=20*pi/180;
    elseif erro_yaw<-20*pi/180
        erro_yaw=-20*pi/180;
    end
    
    %%%%% determina��o do comando de rudder
    dr=control_NF_dr(erro_yaw,prop_SBRF5);
    if dr>16*pi/180
        dr=16*pi/180;
    elseif dr<-16*pi/180
        dr=-16*pi/180;
    end
    rudderValue=-1*(dr/(16*pi/180));
    
    % Envio dos dados ao X-Plane ao XPlane
    setCommands(accValue,elevatorValue,aileronValue,rudderValue,sockUDP);
end