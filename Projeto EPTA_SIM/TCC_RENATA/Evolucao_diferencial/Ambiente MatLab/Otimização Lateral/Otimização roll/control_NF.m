%FUN��O QUE FAZ O CONTROLADOR NEURO-FUZZY
%FUN��O QUE CALCULA A A��O DE CONTROLE 
%CONTROLE LONGITUDINAL

function output=control_NF(erro,da,prop)

%normaliza��o das entradas do sistema
erro = erro/(20*pi/180);


%prop � a matriz linha que vem do m�todo de otimiza��o
%matriz de alfas utilizado na camada 4
prop=prop';
prop=[prop(1);prop(2);prop(3)];

%nesse caso em espec�fico, u vai ser a a��o de controle 
%POSI��O DO AILERON NO TEMPO K+1 (DELTA_AILE_K1)

% O sistema possui 2 entradas com 3 subconjuntos cada uma 
input=1; %n�mero de entradas
sub_NF=3; %numero de subconjuntos fuzzy
u1=zeros(input,1); % entradas na camada 1 (1 entradas)
u2=zeros(input,sub_NF); % entradas na camada 2 (1 entradas, 3 conjuntos fuzzy cada)
m=[-1 0 1]; %-1 0 1];% m�dia associada a funcao de pert gaussiana
s=ones(input,sub_NF)*0.4; %desvio padrao das normais associadas a fun��o de pert gaussiana
s2=s.^2;

%De acordo com o esquema que criei:
rules = 3; %N�mero de regras Fuzzy (Crit�rios "E" "OU") (camada 3)
u3=zeros(rules,1); % Regras Fuzzy (camada 3)
u4=zeros(rules,1); % Fun��o (camada 4)
output = 0; %Sa�da do sistema

%%%CAMADA 1: entrada de dados 
    u1(1)=erro;
    
%%%CAMADA 2: obten��o dos graus de pertin�ncia
for i=1:input
    for j=1:sub_NF
        u2(i,j)=exp(-(u1(i)-m(i,j))^2/s2(i,j));
    end
end

%%%CAMADA 3: operador "e" e "ou"

%u3(1) - associado a saida pequeno
%u3(2) - associado a saida m�dio
%u3(3) - associado a saida grande

%u2(1,1) - associado a theta pequeno
%u2(1,2) - associado a theta medio
%u2(1,3) - associado a theta grande

%u2(2,1) - associado a profundor pequeno
%u2(2,2) - associado a profundor m�dio
%u2(2,3) - associado a profundor grande

%operador "e" = *
%operador "ou" = max([])

u3(1)=u2(1,1); 
u3(2)=u2(1,2);
u3(3)=u2(1,3); 

%%%CAMADA 4
aux=0;
for i=1:rules
    aux=aux+1;
    plano=prop(aux,:); %prop � a matriz de alfa que vem do m�todo de otimiza��o
    u4(i)= u3(i)*plano(1);
    %ex: plano(1) = alfa1, plano(2) = alfa2;
end

%%% CAMADA 5: sa�da do sistema neurofuzzy
output=sum(u4)/sum(u3);

%Para manter a sa�da no intervalo [-1,1]
if output>1
    output=1;
end
if output<-1
    output=-1;
end

%Desnormalizando a sa�da
output = output*(15*pi/180);

end