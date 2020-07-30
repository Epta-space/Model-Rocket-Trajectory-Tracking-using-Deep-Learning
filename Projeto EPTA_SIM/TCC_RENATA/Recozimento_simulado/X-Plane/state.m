function [vel,q,p,r,pitch,roll,yaw,lat,long,alt] = state(msgRecv,vel,q,p,r,pitch,roll,yaw,lat,long,alt)
if(length(msgRecv)~=149) %149 é o número de dados em cada iteração.
    erro_com=1;
else
    erro_com=0;
end

if erro_com==0
    vel=getData(msgRecv,2)*0.514444;
    q = getData(msgRecv,11);
    p = getData(msgRecv,12);
    r=getData(msgRecv,13);
    pitch = getData(msgRecv,20)*pi/180;
    roll = getData(msgRecv,21)*pi/180;
    yaw=getData(msgRecv,22)*pi/180;
    lat=getData(msgRecv,29);
    long=getData(msgRecv,30);
    alt=getData(msgRecv,31)*0.3048;
end

end