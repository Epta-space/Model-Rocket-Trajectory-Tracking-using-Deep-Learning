%FUNÇÃO QUE REALIZA O CRITÉRIO DE PARADA DA OTIMIZAÇAO
%CRITÉRIO: EVOLUÇÃO DIFERENCIAL

function var=Ev_Dif

nmaxgeracoes=30;
nind=30;
nvar=1;

pcruz=0.95;%Probabilidade de cruzamento
F=0.4;

X=zeros(nind,nvar); %individuos
V=X;
C=X;
fX=zeros(nind,1); %valor da fobj para cada individuo
fC=fX;
var=zeros(nvar,1);

%Definição dos limites  da busca das variáveis

for i=1:nvar
    linf(i)=0;
    lsup(i)=5;
end

%POPULACAO INICIAL
for i=1:nind
    for j=1:nvar
        X(i,j)=rand;        
    end
end

%AVALIAÇÃO DOS individuos
for i=1:nind
    for j=1:nvar
        var(j)=(lsup(j)-linf(j))*X(i,j)+linf(j);
    end
    fX(i)= calcadapt(var);
end

contadorgeracoes=0;
flag=1;
flag1=0;
flag2=0;
c1=0;
c2=0;
auxf=inf;
%INICIO DA ED
while (flag)
    contadorgeracoes=contadorgeracoes+1
    vetcontador(contadorgeracoes)=contadorgeracoes;
    
    %%%%%%%%%%%%%%%%%%% OPERADOR MUTAÇÃO %%%%%%%%%%%%%%%%%%%%% 
    
    mut1=randperm(nind);
    mut2=randperm(nind);
    for i=1:nind
        for j=1:nvar
            V(i,j)=X(i,j)+F*(X(mut1(i),j)-X(mut2(i),j));
            if V(i,j)<0
                V(i,j)=0;
            end
            if V(i,j)>1
                V(i,j)=1;
            end
        end
    end
    
    %%%%%%%%%%%%%%%% OPERADOR CRUZAMENTO %%%%%%%%%%%%%%%
    
    for i=1:1:nind % etapa do cruzamento
        el=randperm(nvar);
        el=el(1);
        for j=1:1:nvar
            if(rand<pcruz || j == el)
                C(i,j)= V(i,j);
            else
                C(i,j)= X(i,j);
            end
        end
    end
    
    %%%%%%%%%%%%%%%% OPERADOR SELEÇÃO %%%%%%%%%%%%%%%
    
    for i=1:nind
        for j=1:nvar
            var(j)=(lsup(j)-linf(j))*C(i,j)+linf(j);
        end
        fC(i)= calcadapt(var);
        if (fC(i)>fX(i))
            X(i,:)= C(i,:);
            fX(i) = fC(i);
        end
    end
    
 %%%%%%%%%%%%%%%%%%%%% TESTE CONVERGÊNCIA %%%%%%%%%%%%%%%%%%%%%%
     
    if (contadorgeracoes>=nmaxgeracoes)
        flag=0;
    end
    mfX=max(fX);
    if (abs(mfX-auxf)<0.00001)
        c1=c1+1;
        if (c1>=100)
            flag1=1;
        end
    else
        c1=0;
        flag1=0;
    end
    
    if (abs(mfX-auxf)/max(abs(mfX),10^(-10))<0.001)
        c2=c2+1;
        if (c2>=100)
            flag2=1;
        end
    else
        c2=0;
        flag2=0;
    end
    
    if flag1==1 && flag2==1
        flag=0;
    end
       
    auxf=mfX;
    
    vetmin(contadorgeracoes)=-1*auxf;
       
end
[erro_min ind_adapt]=max(fX);
erro_min=-1*erro_min

var=(lsup-linf).*X(ind_adapt,:)+linf

contadorgeracoes


figure (3)
plot(vetcontador,vetmin,'LineWidth',2)
xlabel('Iteração','FontSize',16)
ylabel('Cf','FontSize',16)
set(gca,'FontSize',16)


end