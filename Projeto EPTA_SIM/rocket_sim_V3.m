function y = rocket_sim_V3(t, x)
% y = [ u. v. w. P. Q. R. fi. theta. psi. xe. ye. ze.]
% x = [ u  v  w  P  Q  R  fi  theta  psi xe ye ze]

global T g m I

%% Matriz de inercia
Ix = I(1);
Iy = I(2);
Iz = I(3);

%% Forças de Tração
if T(t) < 1
    Tr = 0;
else
    Tr = T(t);
end
Ftx = Tr;
Fty = 0;
Ftz = 0;

%% Forças aerodinâmicas
Fax = 0;
Fay = 10;
Faz = 0;

%% Momentos de Tração
Lt = 0;
Mt = 0;
Nt = 0;

%% Momentos Aerodinâmicos
La = 0;
Ma = 0;
Na = 0;

%% Equações de Translação
y(1) = x(2)*x(6) - x(3)*x(5) - g*sin(x(8)) + (Fax + Ftx)/m;
y(2) = x(3)*x(4) - x(1)*x(6) + g*sin(x(7))*cos(x(8)) + (Fay + Fty)/m;
y(3) = x(1)*x(5) - x(2)*x(4) + g*cos(x(7))*cos(x(8)) + (Faz + Ftz)/m;

%% Equações de Rotação 
y(4) = (La + Lt - (Iz - Iy)*x(6)*x(5))/Ix;
y(5) = (Ma + Mt - (Ix - Iz)*x(4)*x(6))/Iy;
y(6) = (Na + Nt - (Iy - Ix)*x(4)*x(5))/Iz;

%% Equações Cinemáticas
y(7) = x(4) + x(5)*sin(x(7))*tan(x(8)) + x(6)*cos(x(7))*tan(x(8));
y(8) = x(5)*cos(x(7)) - x(6)*sin(x(7));
y(9) = (x(5)*sin(x(7)) + x(6)*cos(x(7)))*sec(x(8));

%% Equações de Trajetória
% Método Descritivo
% y(10) = cos(x(8))*cos(9)*x(1) + (cos(x(9))*sin(x(7))*sin(x(8)) - sin(x(9))*cos(x(7)))*x(2) + (cos(x(9))*cos(x(7))*sin(x(8)) + sin(x(9))*sin(x(7)))*x(3);
% y(11) = cos(x(8))*sin(9)*x(1) + (sin(x(9))*sin(x(7))*sin(x(8)) + cos(x(9))*cos(x(7)))*x(2) + (sin(x(9))*cos(x(7))*sin(x(8)) - cos(x(9))*sin(x(7)))*x(3);
% y(12) = -(sin(x(8)))*x(1) + (sin(x(7))*cos(x(8)))*x(2) + (cos(x(8))*cos(x(7)))*x(3);

% Método com uso de transformação matricial
%Vics = C_b_i([x(7) x(8) x(9)],[x(1) x(2) x(3)]');
Vics = quaternions([x(7) x(8) x(9)],[x(1) x(2) x(3)]');
y(10) = Vics(1); 
y(11) = Vics(2);
y(12) = Vics(3);
y=y';
 
%% Angulos direcionais 
alpha = atan(y(3)/y(1));
beta = asin(y(2)/(sqrt(y(1).^2 + y(2).^2 + y(3).^2)));





 
end