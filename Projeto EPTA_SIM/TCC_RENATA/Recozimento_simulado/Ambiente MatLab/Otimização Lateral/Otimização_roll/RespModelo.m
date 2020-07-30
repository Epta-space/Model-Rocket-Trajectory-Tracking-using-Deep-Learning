function [new_output,new_state]=RespModelo(old_state,u,C,D,G,H) %%% entrada e saída: vetores nx1

u=[ u;0];
new_state=G*old_state+H*u;
new_output=C*new_state+D*u;

end