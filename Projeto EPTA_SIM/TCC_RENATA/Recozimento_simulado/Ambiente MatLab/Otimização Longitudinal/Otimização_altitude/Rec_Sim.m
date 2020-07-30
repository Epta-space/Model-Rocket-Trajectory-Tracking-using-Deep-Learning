%Método do Recozimento Simulado

function var=Rec_Sim


T = 10; %Definição da temperatura inicial
nT_max = 60; %Numero de ciclos de resfriamento / ~nmaxgeracoes
nX_max = 5; %Numero de iterações para cada T / ~nind
sigma = 0.06; % Desvio padrão da distribuição normal
m = 1; %Numero de elementos do vetor X / ~nvar
X_novo = zeros(m,1); %Vetor vizinho candidato a ser o novo X
E_novo = zeros(m,1); % E = f(X) // Função Custo do vetor vizinho 
delta = 0; %Diferença entre Enovo e E
Prob = 0; %função probabilidade
w = 0; %numero aleatorio
alfa = 0.9; % Parametro para modificar a temperatura (decaimento de T)
E_v = []; %vetor de melhores E


%Definição dos limites  da busca das variáveis
for i=1:m
    linf(i)=0;
    lsup(i)=30;
end

%Inicialização
X = rand([m 1]); % Arbitrar X inicial
nT = 0; % numero do ciclo de resfriamento
nX = 0; % numero da iteração dentro de T
% var = X;
% E = calcadapt(var); % E = f(X) // Função Custo

%AVALIAÇÃO DOS individuos
for j=1:m
    var(j)=(lsup(j)-linf(j))*X(j)+linf(j);
end
E = calcadapt(var); % E = f(X) // Função Custo


%INICIO DO RECOZIMENTO SIMULADO
while (nT<=nT_max)
    nT
    while (nX<=nX_max)
        nX = nX+1;
        for(i=1:1:m)
            X_novo(i,1) = X(i,1)+sigma*randn;
             if X_novo(i,1)<0
               X_novo(i,1)=0;
            end
            if X_novo(i,1)>1
                X_novo(i,1)=1;
            end
        end
        for j=1:m
            var(j)=(lsup(j)-linf(j))*X(j)+linf(j);
        end
        E_novo = calcadapt(X_novo);
        delta = E_novo - E;
        
        if (delta<0)
            for(i=1:1:m)
                X(i,1) = X_novo(i,1);
            end
            E = E_novo;
        else
            Prob = exp(-delta/T);
            w = rand;
            if (w<Prob)
                for(i=1:1:m)
                    X(i,1) = X_novo(i,1);
                end
                E = E_novo;
            end
        end
        E_v =[E_v E];
    end
    
    T = alfa*T;
    nX = 0;
    nT = nT+1;
    
    
end


var=(lsup-linf).*X+linf;

vetcontador = (1:length(E_v));


figure (3)
plot(vetcontador,E_v,'LineWidth',2)
xlabel('Iteração','FontSize',16)
ylabel('Cf','FontSize',16)
set(gca,'FontSize',16)


end 
