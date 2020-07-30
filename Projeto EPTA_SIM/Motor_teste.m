clear all;close all;clc

a = csvread('tt2.csv');

t = a(:,1);
T = a(:,2);

y = fit(t, T,'smoothingspline');
plot(y)
title('Curva de Queima no tempo');
xlabel('Tempo (s)');
ylabel('Empuxo (N)');
grid on
xlim([0 2.5]);