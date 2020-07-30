function [reff]=reference(set,signal,dt)

fd=0.6; % fator de decaimento da resposta em dire��o ao setpoint.
%ddelta/dt=-fd*delta     range: [0 a inf]
%                        quanto maior, mais decai
%                        se for neg: sistema inst�vel

delta=(signal-set);
delta=delta*exp(-fd*dt);
reff=delta+set;

end