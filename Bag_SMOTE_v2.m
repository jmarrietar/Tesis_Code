function [new_X,new_d,new_Bag]=Bag_SMOTE_v2(X,d,Bag)


C = unique(Bag(d==1));  %Tener un listado de los Ids de las Bolsas positivas
N = size(C,1);    %Numero de Bolsas
D = unique(Bag);
ID_Bolsa=max(D)+1;

for i=1:N    %Recorrer Bolsas positivas
    
    ID= C(i,1);
    Bolsa=X(Bag == ID,:);  %Instancias de la Bolsa ID
    
    extraBag=[]; %Se crea Nueva Bolsa
    extra_BID=[];
    extrad=[];
    
    Sminc= X(d==1& Bag~=ID,:); %Cambiar 1 por ID
    I= nearestneighbour(Bolsa', Sminc');
    I = I'; %Indices del punto mas cercado
    
    %Se recorren las instancias de cada bolsa y por cada una se crea otra nueva
    %instancia xnew de una nueva bolsa.
    s=size(Bolsa,1);
    for j =1:s
        Ei= Bolsa(j,:); %Poner j aqui.
        Ej= Sminc(I(j),:);  %j .
        alpha = rand;
        new_P= Ei+(Ej-Ei)*alpha;   %Crear nuevo punto
        
        %Agrego informacion del nuevo punto y lo agrego a la nueva Bolsa
        extraBag=[extraBag;new_P];
        extra_BID=[extra_BID;ID_Bolsa];
        extrad=[extrad;1];
        
        
        
    end
    
    X=[X;extraBag];      %Actualizo el X
    Bag=[Bag;extra_BID]; %Actualizo el Bag
    d=[d;extrad];        %Actualizo el d
    
    ID_Bolsa=ID_Bolsa+1; %Cambie aqui esto
    
    
end
%FINAL
new_X=X;
new_d=d;
new_Bag=Bag;


end