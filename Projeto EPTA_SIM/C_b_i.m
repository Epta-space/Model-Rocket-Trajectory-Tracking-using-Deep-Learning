function Vics = C_b_i(x, Vbcs)
% Função de Transformação, recebe um vetor no referencial do corpo
% e passa para o referencial inercial.

fi      = x(1);
theta   = x(2);
psi     = x(3);

R_fi    = [1 0 0; 0 cos(fi) sin(fi); 0 -sin(fi) cos(fi)];
R_theta = [cos(theta) 0 -sin(theta);0 1 0; sin(theta) 0 cos(theta)];
R_psi   = [cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];

Vics = (R_psi*R_theta*R_fi)^-1 * Vbcs;

end