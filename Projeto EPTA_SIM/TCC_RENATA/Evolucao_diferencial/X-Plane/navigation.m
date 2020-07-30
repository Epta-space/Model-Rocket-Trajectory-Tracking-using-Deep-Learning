function [set_h,set_vel,set_yaw,flag] = navigation(lat,long,yaw,vel,h,flag)
tol=0.008;
pos=[lat long];
stdh=10;
%%%%%% DEFINIÇÃO DO VOO %%%%%
h0=121.1580;
%%% latitude longitude %%%%
p=[47.4636 -122.3079;
    47.4319 -122.3079;
    47.4319 -122.3279;
    47.4736 -122.3279;
    47.4736 -122.3079];
np=length(p(:,1));
%%%%%%% Determinação de Onde Estamos: FLAG %%%%%%%
if flag<np
    li=flag+1;
    for i=li:np
        d=sqrt((p(i,2)-pos(2))^2+(p(i,1)-pos(1))^2);
        if d<tol
            flag=i;
            break;
        end
    end
end
%%%%%%%%%% Determinação de onde queremos ir : SET %%%%%
if flag==np
    set=1;
else
    set=flag+1;
end

%%%%%%%%%% Determinação de set_yaw %%%%%
los=atan2(p(set,2)-pos(2),p(set,1)-pos(1));
 if los<0
     los=los+2*pi;
 end
 hip_1=los-yaw;
 hip_2=los+2*pi-yaw;
 if abs(hip_1)<abs(hip_2)
     set_yaw=hip_1+yaw;
 else
     set_yaw=hip_2+yaw;
 end

%%%%%%%%%% Determinação de set_h e set_vel %%%%%
if flag==1
    set_vel=40;
    if vel>35
        set_h=300;
    else
        set_h=h0;
    end
elseif flag==np
    if h >(h0+2*stdh)
        set_vel=35;
       set_h=h+stdh;
    else
        set_vel=0;
        set_h=h+2*stdh;
    end
else
    set_h=300;
    set_vel=40;
end

end