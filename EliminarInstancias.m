%Este algoritmo balancea el numero de instancias por bolsas elimindo
%instancias.Determinar el minimino numero de instancias por bolsas y
%elimina instancias hasta que todas las bolsas tengan este minimo. 

function [X,d,Bag]=EliminarInstancias(X,d,Bag)

%Encontrar el numero minimo de instancias x bolsas.
[a,b]=hist(Bag,unique(Bag));        %Contar instancias por bolsa
mini=min(a);                        %Averiguar la maxima cantidad de  instancia x Bolsa.

[fil,col]=size(X);
cold=col+1;
colB=col+2;
%Unir X, d y Bag.
X_new=[X,d,Bag];

[h,j]=size(b);                     %Contar Cuantas Bolsas existen.
Xfinal=[];


for i=1:h   
    idbolsa=b(i,1);                %Sacar id de la Bolsa.
    
    idx = ( X_new(:,colB)==idbolsa );
    Bolsa = X_new(idx,:) ;         %Todas las instancias de una Bolsa.
    
    [r, c] = size(Bolsa);          %Contar instancias en bolsa.
    
    N=r-mini;                      %# de instancias a eliminar
    
    while (N>0)
        [r, c] = size(Bolsa);
        e = randi(r);              %Seleccionar row al azar
        Bolsa(e,:)=[];              %Eliminar instancia al azar de la bolsa
        N=N-1;
    end;
    
    db=Bolsa(1,cold);              % Averigua el d de la bolsa
    bagb=Bolsa(1,colB);            %Averigua el id del Bag de la bolsa
    
    [filn,coln]=size(Bolsa);
    
    dbv=ones(filn, 1) * db;        %Actualiza el d de la bolsa.
    bagbv= ones(filn, 1) * bagb;   % Actualiza el id Bag de la bolsa.
    
    Bolsa(:,cold)=db;
    Bolsa(:,colB)=bagb;
    
    Xfinal=[Xfinal;Bolsa];
    
end

Bag=Xfinal(:,colB);
d=Xfinal(:,cold);
X=Xfinal;
X(:,col+1)=[];      %Quitar fila d
X(:,col+1)=[];      %Quitar fila Bag

end