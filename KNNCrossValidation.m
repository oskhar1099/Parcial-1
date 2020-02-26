clc
clear all
close all

rng(10)

L = load('Data');
D = L.D;
Y = D(:,end);
X = D(:,1:5);

[U,S,V] = svd(X,0);
PHI = V/S;
PHI2 = PHI(:,1:2); %To project onto two dimensions
dS = diag(S);
pv = sum(dS(1:2))/sum(dS);

fig = figure;
hold all
for k = -1:1
    grupo = find(Y==k);
    plot(U(grupo,1),U(grupo,2),'o');
    GX = X(grupo,:);
    CG = cov(GX);
    mG = mean(GX);
    pmG = mG*PHI2;
    plot(pmG(1),pmG(2),'ok','markersize',10 ...
        , 'markerfacecolor','k');   
    m{k+2} = mG;
    C{k+2} = CG;
end

%Cross-Validation
[N,n] = size(X);

%Training
Ntra = round(0.7*N); %for training
H = eye(4,5);
for it = 1:1000
pos = randperm(N);
Xtra = X(pos(1:Ntra),:);
Xval = X(pos(Ntra+1:end),:);
[Nval,~]= size(Xval);

Xtra_atr = H*(X(pos(1:Ntra),:)');
Xval_atr = H*(X(pos(Ntra+1:end),:)');

ind = knnsearch(Xtra_atr',Xval_atr');
cat_est = Xtra(ind,5); %Estimated
cat_rea = Xval(:,5); %Actual
% for k = 1:Ntra
% cat_est(k) = Xtra(ind(k),5);
% end
A(it) = sum(cat_est==cat_rea)/Nval; 
end



