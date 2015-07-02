function [X,d,Bag2] = mil2balu(a)

[BAG1,LAB1,BAGID1,IBAG1]=getbags(a);  %Extract the bags from a MIL set

X1=cell2mat(BAG1);

[m,n] = size(X1);         %Sacar tama?o de Matriz X
d = zeros(m,1);           %Crear vector d [llenar de ceros].
Bag2= zeros(m,1);         %Crear vector Bolsas [Llenar de ceros].   
[c,b] = size(IBAG1);      %c es cantidad de Bolsas.
LAB1 = cellstr(LAB1);     %Array de Strings.

for i=1:c                 %Recorrer todas las bolsas [].
    P=cell2mat(IBAG1(i)); %Convertir bolsa en vector. 
    [m2,n2] = size(P);    %tama?o del Vector
    for j=1:m2            %Recorrer todos los elementos del vector(bolsa)
        index=P(j,1);     %Hallar el indice de instancia. 
        if(strcmp(LAB1(i,1),'positive')==1)   %Verificar que esa bolsa sea positiva
        d(index,1)=1;     %Cambiar el label de la instancia a 1. 
        end
        Bag2(index,1)=i;
    end
end
X=X1;
end

