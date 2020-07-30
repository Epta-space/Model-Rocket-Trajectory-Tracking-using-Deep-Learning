function y = rocket_sim(x,t)
% y = [ u. v. w. P. Q. R. fi. theta. psi. xe. ye. ze.]
% x = [ u  v  w  P  Q  R  fi  theta  psi xe ye ze]

global T g m I

% Matriz de inercia
Ixx = I(1);
Iyy = I(2);
Izz = I(3);

% Forças de Tração
Ftx = T(t);
Fty = 0;
Ftz = 0;

% Forças aerodinâmicas
Fax = 0;
Fay = 0;
Faz = 0;

% Momentos de Tração
Lt = 0;
Mt = 0;
Nt = 0;

% Momentos Aerodinâmicos
La = 0;
Ma = 0;
Na = 0;

% Equações de Translação
y(1) = x(2)*x(6) - x(3)*x(5) - g*sin(x(8)) + (Fax + Ftx)/m;
y(2) = -x(1)*x(6) + x(3)*x(4) + g*sin(x(7))*cos(x(8)) + (Fay + Fty)/m;
y(3) = x(1)*x(5) - x(2)*x(4) + g*cos(x(7))*cos(x(8)) + (Faz + Ftz)/m;
% Equações de Rotação
y(4) = (La + Lt - (Izz - Iyy)*x(6)*x(5))/Ixx;
y(5) = (Ma + Mt - (Ixx - Izz)*x(4)*x(6))/Iyy;
y(6) = (Na + Nt - (Iyy - Ixx)*x(4)*x(5))/Izz;
% Equações Cinemáticas
y(7) = x(4) + x(5)*sin(x(7))*tan(x(8)) + x(6)*cos(x(7))*tan(x(8));
y(8) = x(5)*cos(x(7)) - x(6)*sin(x(7));
y(9) = (x(5)*sin(x(7)) + x(6)*cos(x(7)))*sec(x(8));
% Posicao no ics
Vics = transform([x(7) x(8) x(9)],[ x(1) x(2) x(3)]');
y(10) = Vics(1);
y(11) = Vics(2);
y(12) = Vics(3);

% y=y';
end