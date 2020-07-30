function[Ixxs, Izzs, Ixzs] = MOI(Ixx,Izz,Ixz,Alpha)

a = Alpha*pi/180;

Hbs = [cos(a)^2 sin(a)^2 -sin(2*a)
    sin(a)^2 cos(a)^2 sin(2*a)
    .5*sin(2*a) -.5*sin(2*a) cos(2*a)];

I = Hbs*[Ixx; Izz; Ixz];

Ixxs = I(1);
Izzs = I(2);
Ixzs = I(3);