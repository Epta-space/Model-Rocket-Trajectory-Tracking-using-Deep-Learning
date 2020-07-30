function out = Aerodinamics(H,V,alpha,beta,ia)

global S


Cl = Cl_0 + Cl_a*alpha + Cl_ia*ia;

[T, a, P, rho] = atmosisa(H);

Lx = 0.5*rho*S*Cx*V^2;
Ly = 0.5*rho*S*Cy*V^2;
Lz = 0.5*rho*S*Cz*V^2;


out = [Fax, Fay, Faz, La, Ma, Na];

end