%Este algoritmo balancea el numero de instancias por bolsas elimindo
%instancias.Determinar el minimino numero de instancias por bolsas y
%elimina instancias hasta que todas las bolsas tengan este minimo. 

function [X,d,Bag]=Eliminar(X,d,Bag)

[fil,col] = size(X); 

%Unir X, d y Bag. 
X_new=[X,d,Bag];

%Hacer un shuffle
ordering = randperm(fil);
[fil,col]=size(X)
X_new=X_new(ordering,:);

%Separar X, d y Bag
cold=col+1;
d=X_new(:,cold);
colB=col+2
Bag=X_new(:,colB)
X=X_new(:,1:col);


[a,b]=hist(Bag,unique(Bag));    %Contar instancias por bolsa
min(a);                         %Averiguar la minima instancia.

%Determinar cuales son las instancias a eliminar. 
[m,n] = size(Bag); 
for i=1:m
    bolsa=Bag(i,1);               %Identificar a que Bolsa pertenece la instancia. 
    if (a(1,bolsa)>2)             %Verificar si esta bolsa contiene mas instancias que min.    
        a(1,bolsa)=a(1,bolsa)-1;  %Restarle uno al contador de instanciasXbolsa.
        Bag(i,1)=-1;              %Ponerle -1 a la Bolsa de la instanica (eliminada luego)
        
    end
end

%Eliminando filas con Logical Indexing. 
XT=[X,Bag]
[fil,col]=size(XT)
idx = ( XT(:,col)~= -1 );
X = XT(idx,:)
d=d(idx,:)
Bag=X(:,col)
X(:,col)=[]

end 

