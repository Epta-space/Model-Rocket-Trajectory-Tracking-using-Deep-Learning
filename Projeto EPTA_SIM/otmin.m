function [Ma,Da] = otmin()
    rng default % Para Reprodutibilidade 
    nvar = 5;
    A = zeros(5,5);
    for j=1:5
        A(j,j) = -1;
    end
    q = zeros(6,25);
    f_lqr = @LQR;
    b = zeros(5,1);
    
    for i = 1:25
        [aux, fval] = ga(f_lqr, nvar,A,b);
        for k = 1:5
            if aux(k) < 0
               aux(k) = 0; 
            end
        end
        q(1,i) = aux(1);
        q(2,i) = aux(2);
        q(3,i) = aux(3);
        q(4,i) = aux(4);
        q(5,i) = aux(5);
        q(6,i) = fval;
    end
    Ma = zeros(1,5);
    Da = zeros(1,5);
    Ma(1) = mean(q(1,:));
    Ma(2) = mean(q(2,:));
    Ma(3) = mean(q(3,:));
    Ma(4) = mean(q(4,:));
    Ma(5) = mean(q(5,:));
    Da(1) = std(q(1,:));
    Da(2) = std(q(2,:));
    Da(3) = std(q(3,:));
    Da(4) = std(q(4,:));
    Da(5) = std(q(5,:));

end

