%Este algoritmo al tener instancias desbalanceadas, crea nuevas
%instancias de la clase minoritaria con el algoritmo Bds_Smote y luego les
%asigna una Bolsa a esta nueva instancia teniendo en cuenta el vecino mas
%cecano (de clase minoritaria) de esta nueva instancia. 

function [New_X,New_d,Bag]=Generar(X,d,Bag,smote_rate)

[n,p]=size(X); 

[New_X, New_d] = Bds_Smote(X, d, smote_rate, 3); %Crear nuevas Instancias usando SMOTE.  No me queda claro el smote_rate 0.4
[m,p]=size(New_X);
XT= New_X';  

%El array Bag esta desactualizado. Toca asignarles bolsas a las nuevas
%instancias. 

for columna=n:m 
    %Recorrer Columnas
    idx = nearestneighbour([columna], XT, 'NumberOfNeighbours', 3); %Determinar vecinos
    [fild,cold]=size(idx);
    for i=1:cold
    if (idx(i)<n)
        index_vecino=idx(i);
      break
    end
    end 
    B=Bag(index_vecino,1);   %Miro a cual Bolsa pertenece el vecino 
    Bag(columna,1)=B;    %Le asigno esa Bolsa a nueva instancia
    
    New_d(index_vecino,1);
end 


end 