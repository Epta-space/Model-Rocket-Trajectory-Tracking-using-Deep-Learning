function [perturbacao]= disturb(t)

nt=length(t);
perturbacao=zeros(1,nt);

%%%%%%%% impulso unitário %%%%%%%
perturbacao(1)=30*pi/180;

%perturbacao(floor(0.1*nt))=-1*pi/180;

%perturbacao(floor(0.2*nt))=+1*pi/180;

perturbacao(floor(0.3*nt))=-1*pi/180;

%perturbacao(floor(0.4*nt))=1*pi/180;

%perturbacao(floor(0.5*nt))=-1*pi/180;

%perturbacao(floor(0.6*nt))=1*pi/180;

%perturbacao(floor(0.7*nt))=-1*pi/180;

%perturbacao(floor(0.8*nt))=1*pi/180;

end
