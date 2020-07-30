function Vics = quaternions(x, Vbcs)
% Função de Transformação, recebe um vetor no referencial do corpo
% e passa para o referencial inercial utilizando a teoria dos
% Quaternions

fi      = x(1);
theta   = x(2);
psi     = x(3);


q0 = cos(psi/2)*cos(theta/2)*cos(fi/2)-sin(psi/2)*sin(theta/2)*sin(fi/2);
q1 = sin(theta/2)*sin(fi/2)*cos(psi/2)+sin(psi/2)*cos(theta/2)*cos(fi/2);
q2 = sin(theta/2)*cos(psi/2)*cos(fi/2)-sin(psi/2)*sin(fi/2)*cos(theta/2);
q3 = sin(fi/2)*cos(psi/2)*cos(theta/2)+sin(psi/2)*sin(theta/2)*cos(fi/2);

C_bi = [q0^2 + q1^2 - q2^2 - q3^2, 2*(q1*q2 - q0*q3), 2*(q1*q3 + q0*q2);
        2*(q1*q2 + q0*q3), q0^2 - q1^2 + q2^2 - q3^2, 2*(q2*q3 - q0*q1);
        2*(q1*q3 - q0*q2), 2*(q2*q3 + q0*q1), q0^2 - q1^2 - q2^2 + q3^2];

Vics = C_bi*Vbcs;

end