%%%%%%%%%%Musk1%%%%%%%%%%%%%%
%a = prdataset('musk1');
%w = scalem(a,'variance');
%a = a*w;

%%%%%%%%%Musk2%%%%%%%%%%%%%%%
%a = prdataset('musk2');
%w = scalem(a,'variance'); 
%a = a*w;

a = prdataset('elephant');
%a = prdataset('fox');
%a = prdataset('tiger');
%a = prdataset('mutagenesis1');
%a = prdataset('mutagenesis2');
%a=prdataset('web1') 
%a=prdataset('web2') 
%%%%%%%Birds%%%%%%%
%x = prdataset('birds');
%a=changelablist(x,'WIWR')
%a = changelablist(x,'BRCR');
%a = genmil(a.data, a.labels, getbagid(a));
%a=prdataset('birds') 


%%%%%%COREL%%%%%%%%%%
%x = prdataset('corel');
%a=changelablist(x,'Horses')
%a = changelablist(x,'Cars');
%a = genmil(a.data, a.labels, getbagid(a));


%Mil2Balu
%[X,d,Bag] =mil2balu(a);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Balancear Datos [instancias]%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Algoritmos para Balancear instancias por Bolsa (Maximo,Minimo,Promedio)
%[X,d,Bag]=GenerarInstancias(X,d,Bag);
%[X,d,Bag]=EliminarInstancias(X,d,Bag);
%[X,d,Bag]=PromedioInstancias(X,d,Bag);

%%%%%%%%%%%%%%%%%%%%
%Balancear con OSSj%
%%%%%%%%%%%%%%%%%%%%
%Note: Se usa CNN. 
%UNDER-SAMPLING method, where the label for the majority class is 0 
% nd the label for the minority class is 1.
%Check this rule. 
%C = size(X(d==1),1);  %Tener un listado de los Ids de las Bolsas positivas
%E = size(X(d==0),1);   %Tener un listado de los Ids de las Bolsas negativas
%if (E>C)
%[X,d,Bag] = Bds_OSSJ(X,d,Bag); % Balancear con OSSJ Adaptado a instancias de Bolsas. 
%else 
%    disp('Error: No se cumple que insta - > insta +')
%    break;
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%%Balancear Bolsas %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%[X,d,Bag]=BalanceoBolsas(X,d,Bag); %Algoritmo Propio. 
%[X,d,Bag]=Bag_SMOTE(X,d,Bag); %Canadienses 

%BALU2MIL
%Creando MIL Data y Mil labels
%d_mil = genmillabels(d, 1);
%a = genmil(X,d_mil,Bag);       

%If necesary prmemory(1000000000000000000000000) 
%settings for classification:
reg = 1e-6;
w = {
    %apr_mil([],'presence',75,0.999,0.001,1);  %Listo  
    %milboostc([]);                            %Listo [default=100 rounds]
    %citation_mil([],'presence',1,1);          %Listo [ref1, cite1 (h) Frac= presence]
    %citation_mil([],'presence',3,5);          %Listo [ref3, cite5 (h)]
    %misvm([],'presence',1,'p',1);             %Listo p=1  
    misvm([],'presence',1,'r',10);            %r=10   
    %miles([],1,'p',1);                        %Listo p=1
    %miles([],1,'r',10);                       %r=10     
    %simple_mil([],'presence',loglc);          %
    %simple_mil([], 'presence', scalem('variance')*libsvc([],proxm('p',2),0.01)*classc);
    %milvector([],'m')*scalem([],'variance')*loglc([])*classc; %mean-inst+Logistic2 
    %milvector([],'e')*scalem([],'variance')*loglc([])*classc; %extremes+Logistic2
    %milvector([],'c')*scalem([],'variance')*loglc([])*classc; %DEMORADO!!
};
wnames = getwnames(w);

%set other parameters and storage:
nrfolds = 5;
nrw = length(w);
err = repmat(NaN,[nrw 2 nrfolds]);
err2 = repmat(NaN,[nrw 2 nrfolds]);
err3 = repmat(NaN,[nrw 2 nrfolds]);
err4 = repmat(NaN,[nrw 2 nrfolds]);
err5 = repmat(NaN,[nrw 2 nrfolds]);


RESULT = cell(1,10);
for k=1:10

% Randomize the data set
a = milrandomize(a);

% start the loops:
I = nrfolds;
for i=1:nrfolds   
    
	dd_message(3,'%d/%d ',i,nrfolds);  
	[x,z,I] = milcrossval(a,I);  % a Mil data set, I # folds, x train mil dataset, z test , I udated objecto noseque.  
    z = setprior(z,[]);
    
	for j=1:nrw
		dd_message(4,'.');
		
        %%%
        % Prueba datos originales
        %%%
        w_tr = x*w{j};   
		out = z*w_tr;   
        err(j,1,i) = dd_auc(out*milroc);   
        err(j,2,i) = out*testd;          %Que es out y que es testd
            metrics = num2cell(mil_evaluation(out));
            [TP, FN, FP, TN, P, R, F, G] = metrics{:};
            err(j,3,i) = F;
            err(j,4,i) = G;
           
        %%%
        % Prueba datos Balancear Datos [ Eliminar instancias]
        %%%
        [X2,d2,Bag2] = mil2balu(x);
        
        [X2,d2,Bag2]=EliminarInstancias(X2,d2,Bag2); 
         
        x2 = balu2mil(X2,d2,Bag2);
        clear X2;
        clear d2;
        clear Bag2; %INGRESE YO AQUI
        w_tr2 = x2*w{j};   
		out2 = z*w_tr2;   
        err2(j,1,i) = dd_auc(out2*milroc);   
        err2(j,2,i) = out2*testd;          
        metrics = num2cell(mil_evaluation(out2));
        [TP, FN, FP, TN, P, R, F, G] = metrics{:};
        err2(j,3,i) = F;
        err2(j,4,i) = G;
        clear x2; %CABIE YO AQUI 
        
        %%%
        % Prueba datos Balancear Datos [ Genear instancias]
        %%%
        [X3,d3,Bag3] = mil2balu(x);
        
        [X3,d3,Bag3]=GenerarInstancias(X3,d3,Bag3);  
        
        x3 = balu2mil(X3,d3,Bag3);
        clear X3;
        clear d3;
        clear Bag3; %INGRESE YO AQUI
        w_tr3 = x3*w{j};    
		out3 = z*w_tr3;   
        err3(j,1,i) = dd_auc(out3*milroc);   
        err3(j,2,i) = out3*testd;          
        metrics = num2cell(mil_evaluation(out3));
        [TP, FN, FP, TN, P, R, F, G] = metrics{:};
        err3(j,3,i) = F;
        err3(j,4,i) = G;
        
         clear x3; %CABIE YO AQUI
        
        %%%
        % Prueba datos Balancear Datos [ Promedio instancias]
        %%%
        [X4,d4,Bag4] = mil2balu(x);
        
        [X4,d4,Bag4]= PromedioInstancias(X4,d4,Bag4);
        
        x4 = balu2mil(X4,d4,Bag4);
        clear X4;
        clear d4;
        clear Bag4; %INGRESE YO AQUI
        w_tr4 = x4*w{j};  
		out4 = z*w_tr4;   
        err4(j,1,i) = dd_auc(out4*milroc);   
        err4(j,2,i) = out4*testd;          
        metrics = num2cell(mil_evaluation(out4));
        [TP, FN, FP, TN, P, R, F, G] = metrics{:};
        err4(j,3,i) = F;
        err4(j,4,i) = G;
        
         clear x4; %CABIE YO AQUI
        %%%
        % Prueba datos Balancear Datos [ OSSJ instancias]
        %%%
        %[X5,d5,Bag5] = mil2balu(x);
        
        %[X5,d5,Bag5]= Bds_OSSJ(X5,d5,Bag5);
        
        %x5 = balu2mil(X5,d5,Bag5);
        
         %clear X5;
        %clear d5;
        %clear Bag5; %INGRESE YO AQUI
        
        %w_tr5 = x5*w{j};  
		%out5 = z*w_tr5;   
        %err5(j,1,i) = dd_auc(out5*milroc);   
        %err5(j,2,i) = out5*testd;          
        %metrics = num2cell(mil_evaluation(out5));
        %[TP, FN, FP, TN, P, R, F, G] = metrics{:};
        %err5(j,3,i) = F;
        %err5(j,4,i) = G;
        
         %clear x5; %CABIE YO AQUI
	end
end
dd_message(3,'\n');



result = zeros(nrw,4);
for j=1:nrfolds
	result=result+err(:,:,j);
end
result=(result/nrfolds)*100;


result2 = zeros(nrw,4);
for j=1:nrfolds
	result2=result2+err2(:,:,j);
end
result2=(result2/nrfolds)*100;


result3 = zeros(nrw,4);
for j=1:nrfolds
	result3=result3+err3(:,:,j);
end
result3=(result3/nrfolds)*100;


result4 = zeros(nrw,4);
for j=1:nrfolds
	result4=result4+err4(:,:,j);
end
result4=(result4/nrfolds)*100;


%result5 = zeros(nrw,4);
%for j=1:nrfolds
%	result5=result5+err5(:,:,j);
%end
%result5=(result5/nrfolds)*100;

R = cell(1,5);
R{1} = result;
R{2} = result2;
R{3} = result3;
R{4} = result4;
%R{5} = result5;

RESULT{k} = R;

fprintf('\n\n\n----------------------------------\n TERMINO ITERACION %d\n-----------------------------\n', k);
save ('Result-elephant', 'RESULT', 'k');
end