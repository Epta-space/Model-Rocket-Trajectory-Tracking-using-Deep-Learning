clear all
close all
clc
%% Condições Iniciais
y = [0;pi/4];
ts = 30;
dt = 0.01;
t(1)=0;

%% Método de Integração Numérica Runge-Kutta
for n = 1:ts/dt
    k1 = f(y(:,n));
    k2 = f(y(:,n) + dt*.5*k1);
    k3 = f(y(:,n) + dt*.5*k2);
    k4 = f(y(:,n) + dt*k3);
    y(:,n + 1) = y(:,n) + (dt/6)*(k1 + 2*k2 + 2*k3 + k4);
    t(n+1)=t(n)+dt;
end

%% Plot das saídas no tempo
plot(t,y(1,:),'-',t,y(2,:),'-')
title('Pendulo Runge-Kutta');
xlabel('Tempo t');
ylabel('Solução y');
grid on
legend('omega','theta')

%% Simulação
figure
for i = 1:length(t)
    
    yp = -0.5*cos(y(2,i));
    xp = -0.5*sin(y(2,i));
    
    plot([0 xp],[0 yp] ,'-',xp,yp,'o');
    title('Simulação');
    xlabel('x');
    ylabel('y');
    grid on
    ylim([-.6 .1]);
    xlim([-.6 .6]);
    drawnow
    %pause(0.001)
    
end

%% Extras
function x = f(y)
x(1) = -0.25*y(1) -5*sin(y(2));
x(2) = y(1);
x=x';
end