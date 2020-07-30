function [G,H]= convc2d(A,B,dt)

G=expm(A*dt);
nm=length(A);
H=(A\(expm(A*dt)-eye(nm)))*B;

%%%% Quando tem um integrador em um dos estados, tem que fazer assim:
% G=expm(A*dt);
% G=[1 0.02 0 0; zeros(3,1) G];
% H=(A\(expm(A*dt)-eye(3)))*B;
% H=[zeros(1,4); zeros(3,1) H];

end