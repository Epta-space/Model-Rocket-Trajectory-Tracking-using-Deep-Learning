 function [ref]=refdet(set,signal,dt)
 
 nd=length(set);
 fd=0.6; % fator de decaimento da resposta em direção ao setpoint.
         %ddelta/dt=-fd*delta     range: [0 a inf]
         %                        quanto maior, mais decai
         %                        se for neg: sistema instável
 ref=signal;
 
 for i=2:nd
     delta=(signal(i-1)-set(i-1));
     delta=delta*exp(-fd*dt);
     ref(i)=delta+set(i-1);
 end
 
 end