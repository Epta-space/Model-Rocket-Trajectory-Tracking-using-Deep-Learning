 function [set]= setpoint(t)
 
 nt=length(t);
 set=zeros(1,nt+1);
 
 %%%%%%%% Setar o climbing rate e altitude respectivamente %%%%%%
 for i=1:nt
     if t(i)<50
         set(i)=90*pi/180;
     end
 end
 
 end