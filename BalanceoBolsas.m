%Cada bolsa se llena con una instancia positiva y las demas 'negativas' hasta llenar el promedio
%de instancias por Bolsa.
%Nota: Los labels de las instancias creadas son siempre 1 ya que estamos haciendo propagancion del label de la Bolsa a la instancia.

function [new_X,new_d,new_Bag]=BalanceoBolsas(X,d,Bag)

[a,b]=hist(Bag,unique(Bag));        %Contar instancias por bolsa
promedio=round(mean(a));            %Averiguar el promedio de   instancia x Bolsa.

p = 1; % Numero de instancias positivas a seleccionar por bolsa
n = 1; % Numero de instancias negativas a seleccionar por bolsa

%Pruebas. Escoger la Instancia mas positiva de una Bolsa.
% Se escogen SOLO las instancias de las Bolsas Negativas para la PDF
X_ = X(d==0,:);
d_ = ones(1,size(X_,1));

% Crea el dataset de ONE_CLASS para usr las funciones del Toolbox
A = oc_set(prdataset(X_, num2str(d_)), 1);  %????????????????????

%%%%%%%%
% Step 1: To model negative population (B-) with Kernel Density Estimation
%%%%%%%%
KDE = parzen_dd(A, 0.1);                %????????????????????

% Get every positive bag (B+)
C = unique(Bag(d==1));  %Tener un listado de los Ids de las Bolsas positivas
E = unique(Bag(d==0));  %Tener un listado de los Ids de las Bolsas negativas
D = unique(Bag);
N = size(C,1);
if (size(E,1)>size(C,1))
    
    POS = NaN(N, p);
    NEG = NaN(N, n);
    
    
    %%%%%%%%
    % Step 2: Get the p-most positive and the n-most negative instances for Bi
    %%%%%%%%
    for i=1:N
        
        aux = find(Bag==C(i), 1)-1;
        
        % Get xij instances for the Bag Bi
        x_bag = X(Bag==C(i), :);
        
        % For every postive instance Bi get the PDF: p(xij | B-) ??????
        PDF = x_bag*KDE;
        PDF = PDF.data;
        
        % Find instances with MIN and MAX values in the PDF
        [~, IX] = sort(PDF(:,1));
        POS(i,:) = IX(1:p)+aux;  %%%Con corremos el indice al adecuado.
        NEG(i,:) = fliplr(IX(end-n+1:end)')+aux;
    end
    
    
    Nuevas_Bolsas=size(E,1)-size(C,1);            % Numero de Bolsas a crear. 
    %CREAR UNA NUEVA BOLSA Y LLENARLA.
    for q=1:Nuevas_Bolsas
        %Crear Bolsa.
        newB=[];
        %La Bolsa debe tener un ID.
        D = unique(Bag);
        ID_Bolsa=max(D)+1;
        
        
        %Escoger Dos bolsas al azar diferentes a y b
        r= size(POS,1);
        a = randi(r);              %Seleccionar n al azar
        b=randi(r);                %Seleccionar m al azar.
        while a==b
            b=randi(r);                %Seleccionar m al azar.
        end
        
        %Crear instanica Positiva
        % De cada una Buscarle su punto mas positivo
        %sacar indices de los puntos mas positivos de las bolsas a y b
        % los indices seran f y g
        f = POS(a);
        g = POS(b);
        
        %Seleccionar los puntos de la Matriz.
        Ei= X(f,:);            %Seleccionar punto mas positivo de bulsa a
        Ej= X(g,:);            %Seleccionar punto mas positivo de bulsa b
        
        alpha = rand;
        new_P= Ei+(Ej-Ei)*alpha;   %Crear nuevo punto
        
        %Se debe extender el Bag donde dice en que bolsa esta cada instancia.
        extra_BID=[];
        extra_BID=[extra_BID;ID_Bolsa];
        %La Bolsa debe tener un label (Por defecto 1 porque es positiva la bolsa y en teoria todas las instancias)
        extrad=[];
        extrad=[extrad;1];
        %Por cada punto que se crea indicar en
        %Meter punto positivo nuevo en la Bolsa
        extraBag=[];
        extraBag=[extraBag;new_P];       %Agregar punto a la Bolsa
        
        %Nota= A los negativos Tambien le asigno un Label de 1 ya que la Bolsa es
        %positiva y estamos trabajando con propagacion. De todas maneras preguntar
        %a Mera.
        
        
        %Llenar de instancias Negativas.
        %Buscar instancia mas negativa de Bolsa a.
        h= NEG(a);
        Ei= X(h,:);     %Ei aqui puede ser cambiado por Ek para que no haya confucion con el de arriba.
        
       
        % Get xij instances for the Bag b
        b_insta= X(Bag==b, :);
        t=size(b_insta,1);
        %Crear nueva bolsa b menos la instancia mas positiva llamada New_b
        New_b=[];
        
        %Quitar de la Bolsa a la instancia mas positiva.
        for i=1:t
            if (isequal(Ej,b_insta(i,:))~=1)
                New_b=[New_b;b_insta(i,:)];     % Esto se puede optimizar
            end
        end
        
        t=size(New_b,1);
        
        %Llenarla tantas veces como el promedio de Bolsas-1
        N=promedio-1;
        while N>0
            m=randi(t);                    %Seleccionar m al azar de new_b (en esencia Solo con instances 'negativas')
            Ej=  New_b(m,:);
            alpha = rand;
            new_P= Ei+(Ej-Ei)*alpha;       %Crear nueva instancia negativa.
            
            %Agregar instancia nueva a la Bolsa.
            extraBag=[extraBag;new_P];    % Se puede optimizar.
            extra_BID=[extra_BID;ID_Bolsa];
            extrad=[extrad;1];  %Actualizar cantidad de labels.  % Se puede optimizar.
            N=N-1;
        end
        
        %Ya tenemos una Bolsa Extra %ExtraBag. Extra_BID
        
        %Se pueden hacer append de una a X B Y D ?
        %Intentemos
        X=[X;extraBag];
        Bag=[Bag;extra_BID];
        d=[d;extrad];
        
    end
    
    new_X=X;
    new_d=d;
    new_Bag=Bag;
    
else
    disp('Datos Balanceados')
    
end


end