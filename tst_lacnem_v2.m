%load('musk2-original')
%load('musk2-eliminacion')
load('musk2-generarinstancias')
%load('musk2-promedio')
%load('musk2-OSSJ')
%load('muta2-original')
%load('muta2-eliminacion')
%load('muta2-generarInstancias')
%load('muta2-promedio')
%load('Muta2-OSSJ')
%load('tiger-OSSJ')
%load('tiger-promedio')
%load('web1-original')
%load('web1-eliminacion')
%load('web1-generarInstancias')
%load('web1-promedio')
%load('web2-original')
%load('web2-eliminacion')
%load('web2-generarInstancias')
%load('web2-promedio')
%load('web2-OSSJ')
%load('web1-OSSJ')
 
 
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
err = repmat(NaN,[nrw 8 nrfolds]);


RESULT = cell(1,10);
for k=1:10
    
for i=1:nrfolds   
    
	dd_message(3,'%d/%d ',i,nrfolds);  
    	dd_message(4,'.');
		
        A=datos{k,i};
        x=A{1};
        z=A{2}; 
    
	for j=1:nrw
        
        w_tr = x*w{j};   
		out = z*w_tr;   
        err(j,1,i) = dd_auc(out*milroc);   
        err(j,2,i) = out*testd;          
            metrics = num2cell(mil_evaluation(out));
            [TP, FN, FP, TN, P, R, F, G] = metrics{:};
            err(j,3,i) = F;
            err(j,4,i) = G;
            err(j,5,i) = TP;
            err(j,6,i) = FN;
            err(j,7,i) = FP;
            err(j,8,i) = TN;

	end
end
dd_message(3,'\n');



result = zeros(nrw,8);
for j=1:nrfolds
	result=result+err(:,:,j);
end
result=(result/nrfolds)*100;


R = cell(1,1);
R{1} = result;

RESULT{k} = R;

fprintf('\n\n\n----------------------------------\n TERMINO ITERACION %d\n-----------------------------\n', k);
save ('Result-musk2-generar', 'RESULT', 'k');
end