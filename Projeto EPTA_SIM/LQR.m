function J = LQR(q)
    global A1;
    global B1;
    global C1;
    global D1;
    Q = zeros(4,4);
    
    Q(1,1) = q(1);
    Q(2,2) = q(2);
    Q(3,3) = q(3);
    Q(4,4) = q(4);
    R = q(5);
    try
        K=lqr(A1,B1,Q,R);
        Ac = (A1-B1*K);
        Bc = B1;
        Cc = C1;
        figure;
        y = impulse(Ac,Bc,Cc,D1,1);
        close;
        for i=1:length(y)
            u(:,i) = (-K*y(i,:)')';
        end
        J = rms(u);
    catch
        J = 1000000;
    end
end