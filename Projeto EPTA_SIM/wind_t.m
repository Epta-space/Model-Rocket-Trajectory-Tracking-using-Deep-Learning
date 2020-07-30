function Vics = wind_t(x, Vbcs)
% Função de Transformação, recebe um vetor no referencial do corpo
% e passa para o referencial inercial.

alpha     = x(1);
beta      = x(2);

R_a = [cos(alpha) 0 -sin(alpha); 0 1 0; sin(alpha) 0 cos(alpha)];
R_b = [cos(beta) -sin(beta) 0; sin(beta) cos(beta) 0; 0 0 1];

Vics = R_b*R_a*Vbcs;

end