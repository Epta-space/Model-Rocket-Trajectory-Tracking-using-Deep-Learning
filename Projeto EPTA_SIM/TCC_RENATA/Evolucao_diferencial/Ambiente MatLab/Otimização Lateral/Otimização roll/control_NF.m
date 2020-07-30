%FUNÇÃO QUE FAZ O CONTROLADOR NEURO-FUZZY
%FUNÇÃO QUE CALCULA A AÇÃO DE CONTROLE 
%CONTROLE LONGITUDINAL

function output=control_NF(erro,da,prop)

%normalização das entradas do sistema
erro = erro/(20*pi/180);


%prop é a matriz linha que vem do método de otimização
%matriz de alfas utilizado na camada 4
prop=prop';
prop=[prop(1);prop(2);prop(3)];

%nesse caso em específico, u vai ser a ação de controle 
%POSIÇÃO DO AILERON NO TEMPO K+1 (DELTA_AILE_K1)

% O sistema possui 2 entradas com 3 subconjuntos cada uma 
input=1; %número de entradas
sub_NF=3; %numero de subconjuntos fuzzy
u1=zeros(input,1); % entradas na camada 1 (1 entradas)
u2=zeros(input,sub_NF); % entradas na camada 2 (1 entradas, 3 conjuntos fuzzy cada)
m=[-1 0 1]; %-1 0 1];% média associada a funcao de pert gaussiana
s=ones(input,sub_NF)*0.4; %desvio padrao das normais associadas a função de pert gaussiana
s2=s.^2;

%De acordo com o esquema que criei:
rules = 3; %Número de regras Fuzzy (Critérios "E" "OU") (camada 3)
u3=zeros(rules,1); % Regras Fuzzy (camada 3)
u4=zeros(rules,1); % Função (camada 4)
output = 0; %Saída do sistema

%%%CAMADA 1: entrada de dados 
    u1(1)=erro;
    
%%%CAMADA 2: obtenção dos graus de pertinência
for i=1:input
    for j=1:sub_NF
        u2(i,j)=exp(-(u1(i)-m(i,j))^2/s2(i,j));
    end
end

%%%CAMADA 3: operador "e" e "ou"

%u3(1) - associado a saida pequeno
%u3(2) - associado a saida médio
%u3(3) - associado a saida grande

%u2(1,1) - associado a theta pequeno
%u2(1,2) - associado a theta medio
%u2(1,3) - associado a theta grande

%u2(2,1) - associado a profundor pequeno
%u2(2,2) - associado a profundor médio
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
    plano=prop(aux,:); %prop é a matriz de alfa que vem do método de otimização
    u4(i)= u3(i)*plano(1);
    %ex: plano(1) = alfa1, plano(2) = alfa2;
end

%%% CAMADA 5: saída do sistema neurofuzzy
output=sum(u4)/sum(u3);

%Para manter a saída no intervalo [-1,1]
if output>1
    output=1;
end
if output<-1
    output=-1;
end

%Desnormalizando a saída
output = output*(15*pi/180);

end