clear all
close all
clc

y = [0;pi/4];
ts = 30;
dt = 0.01;
t(1)=0;

for n = 1:ts/dt
    k1 = f(y(:,n));
    k2 = f(y(:,n) + dt*.5*k1);
    k3 = f(y(:,n) + dt*.5*k2);
    k4 = f(y(:,n) + dt*k3);
    y(:,n + 1) = y(:,n) + (dt/6)*(k1 + 2*k2 + 2*k3 + k4);
    t(n+1)=t(n)+dt;
end
%%
t0 = 0;
tf = 30;
t_span = [t0 tf];
ang_0 = 45;
x0 = [ang_0*(pi/180); 0];
[tode,yode] = ode45(@pendulo, t_span, x0);
subplot(2,2,1);
plot(tode,yode(:,1),'-',tode,yode(:,2),'-')
title('Pendulo ODE-45');
xlabel('Tempo t');
ylabel('Solução y');
grid on
legend('theta','omega')
%%

subplot(2,2,2);
plot(t,y(1,:),'-',t,y(2,:),'-')
title('Pendulo Runge-Kutta');
xlabel('Tempo t');
ylabel('Solução y');
grid on
legend('omega','theta')

%%
subplot(2,2,3);
plot(t,y(2,:),'.-',tode,yode(:,1),'-')
title('Pendulo Comparação');
xlabel('Tempo t');
ylabel('Solução y');
grid on
legend('RK','ODE')


%%
figure
%subplot(2,2,4);
for i = 1:length(tode)
    
    yp = -0.5*cos(yode(i,1));
    xp = -0.5*sin(yode(i,1));
    %subplot(2,2,4);
    
    plot([0 xp],[0 yp] ,'-',xp,yp,'o');
    title('Simulação');
    xlabel('x');
    ylabel('y');
    grid on
    ylim([-1 1]);
    xlim([-1 1]);
    drawnow
    pause(0.01)
    
end
%%
function x = f(y)
x(1) = -0.25*y(1) -5*sin(y(2));
x(2) = y(1);
x=x';
end