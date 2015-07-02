function metrics = mil_evaluation( Z, W )

if nargin < 2
	d = Z;
else
	d = Z*W;
end

truelab = getlab(d);
outlab = d*labeld;

truelab = ispositive(truelab);
outlab = ispositive(outlab);

out = NaN(size(d,1),2);
It = find(truelab);
out(It,1) = ~outlab(It);
Io = find(~truelab);
out(Io,2) = outlab(Io);

TP = sum(out(:,1)==0);
FN = sum(out(:,1)==1);

FP = sum(out(:,2)==1);
TN = sum(out(:,2)==0);

P = TP/(TP+FP);
R = TP/(TP+FN);

F = 2*(R*P)/(R+P); 
G = sqrt(R * (TN/(TN+FP)));
%La G se hace como se dice en los archivos. 

if isnan(F); F = 0; end;
if isnan(G); G = 0; end;

if isnan(P); P = 0; end;
if isnan(R); R = 0; end;

metrics = [TP, FN, FP, TN, P, R, F, G];

end

