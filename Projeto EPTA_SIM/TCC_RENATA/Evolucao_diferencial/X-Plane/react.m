function [ds,int_erro_euler]=react(erro_euler,int_erro_euler,dt,euler_hist,euler_ref,kp,ki,div)

if abs(erro_euler)>div && euler_hist(length(euler_hist))~=0
    int_erro_euler=0;
    z=abs(euler_hist(1)-euler_ref(1))/std(euler_hist-euler_ref); %%%a média da normal é central!
    if abs(z)>3
        ds=1*kp*(euler_hist(1)-euler_hist(2))/dt;
    else
        ds=0;
    end
elseif abs(erro_euler)<=div
    int_erro_euler=int_erro_euler+erro_euler*dt;    %%% da forma como está, kp e ki são positivos!!!!! 
    ds=-1*ki*int_erro_euler;
else
    int_erro_euler=0;
    ds=0;
end


end