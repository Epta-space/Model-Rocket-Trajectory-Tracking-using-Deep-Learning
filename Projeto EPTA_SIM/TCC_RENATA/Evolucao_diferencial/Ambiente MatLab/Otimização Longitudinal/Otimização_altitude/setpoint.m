 function [set]= setpoint(t)
 
 nt=length(t);
 set=zeros(1,nt+1);
 
 %%%%%%%% Setar o climbing rate e altitude respectivamente %%%%%%
 for i=1:nt
     if t(i)<50
         set(i)=50;
     elseif (t(i)>=50 && t(i)<75 )
         set(i)=50;
     elseif (t(i)>=75 && t(i)<125 )
         set(i)=0;
     elseif t(i)>=125
         set(i)=0;
     end
 end
 
 end