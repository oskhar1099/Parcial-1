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
Ntra = round(0.7*N); %for training
pos = randperm(N);
Xtra = X(pos(1:Ntra),:);
Xval = X(pos(Ntra+1:end),:);

H = eye(4,5);

%We have 3 clusters
for c=1:3
    mc = m{c};
    Cc = C{c};
    pmc = H*(mc');
    pCc = H*Cc*H';
    
    %normpdf()
end
    
    








eeeeeeee





%Iris-Setosa
indLa = find(Y==1);
US = U(indLa,[1 2]);
XSO = X(indLa,:);
[N,n] = size(XSO);



H = [1 0 0 0;0 0 0 1];



for k = 1:10000
per = randperm(N);
XSP = XSO(per,:);
xe = XSP(end,:); %We let out a single point (can be more)
XS = XSP(1:end-1,:); %We use 1->(N-1) data to train our
%model (fit a Gaussian distribution as prior)

%Mean and Covariance (FIT)
xb = mean(XS);
B  = cov(XS);

%Estimation
sig = 0.01;
eobs = sig*randn(2,1);
y = H*(xe')+eobs;
%Posterior
xa = (inv(B)+(1/sig^2)*H'*H)\(B\(xb')+(1/sig^2)*H'*y);
%Covarianza posterior
Ca = inv(inv(B)+(1/sig^2)*H'*H);

est3 = xa([2 3]);
%var3 = Ca(3,3);
ERR(k) = norm(est3-xe([2 3])',1)/norm(xe([2 3]),1);
end


fig = figure
hist(ERR);










