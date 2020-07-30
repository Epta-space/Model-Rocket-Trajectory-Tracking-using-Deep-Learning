clear;
clc;
close;

display('Iniciando comunicação...');
sockUDP = udp('127.0.0.1', 'RemotePort', 49000, 'LocalPort', 49004);
fopen(sockUDP);
display('Comunicação UDP inicializada.');

% Variáveis de controle e armazenamento
tic;
t = 0;
% Variáveis relacionadas ao PID

iepp = 0;
epp = zeros(1,2);

ierr = 0;
err = zeros(1,2);


while 1
    
    %%%%%%%%%%%%%%% Computa Estado %%%%%%%%%%%%%%%%%%%
    msgRecv = fread(sockUDP);
    [sp,q,p,r,pitch,roll,yaw,lat,long,alt]=state(msgRecv);
    dt = toc;
    tic;
    
    %%%%%%%%%%%% Código que computa o PID para o pitch %%%%%%%%%%%%%
    kpp = 1.9510; kip = 1; kdp = 0.0236;
    input = pitch;
    ref = 0;
    epp(1) = ref - input;
    perr = kpp*epp(1);
    if abs(epp(1))<0.02
        iepp = iepp + (epp(1)*dt);
    else
        iepp =0;
    end
    intp=kip*iepp;
    derr = kdp*(epp(1) - epp(2))/dt;
    output = perr + intp + derr;
    if output>23*pi/180
        output=23*pi/180;
    end
    if output<-23*pi/180
        output=-23*pi/180;
    end
    output=output/(23*pi/180);
    epp(2) = epp(1);
    elevatorValue = output;

    %%%%%%%%%%%% Código que computa o PID para o roll %%%%%%%%%%%%%
    kpr = 0.634; kir = 1; kdr = 0.0682;
    input = roll;
    ref = 0;
    err(1) = ref - input;
    perr = kpr*err(1);
    if abs(err(1))<0.02
        ierr = ierr + (err(1)*dt);
    else
        ierr =0;
    end
    intr=kir*ierr;
    derr = kdr*(err(1) - err(2));
    output = perr + intr + derr;
    if output>15*pi/180
        output=15*pi/180;
    end
    if output<-15*pi/180
        output=-15*pi/180;
    end
    output=output/(15*pi/180);
    err(2) = err(1);
    aileronValue = output;
    rudderValue=0;
    accValue=1;
    
    % Envio dos dados ao X-Plane ao XPlane
    setCommands(accValue,elevatorValue,aileronValue,rudderValue,sockUDP);
end



