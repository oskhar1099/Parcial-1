clc
clear all
close all

rng(10)

L = readtable('abalone.dat');
D = table2array(L);
Y = D(:,end);
X = D(:,1:9);

[U,S,V] = svd(X,0);
dS = diag(S);
pv = sum(dS(1:2))/sum(dS);


fig = figure('Name', '2D Projection');
hold all
title(['PV = ',num2str(pv)],'fontsize',20);
colors_rings = colormap(colorcube(29));

%To project onto two dimensions
for k = 1:29
    grupo = find(Y==k);
    plot(U(grupo,1),U(grupo,2),'ok','MarkerFaceColor',colors_rings(k,:));
end
title(['PV = ',num2str(pv)],'fontsize',20);

le = legend(string(unique(Y)));
set(le,'fontsize',7,'location','bestoutside');

pv = sum(dS(1:3))/sum(dS);

fig = figure('Name', '3D Projection');
hold all
%To project onto three dimensions
for k = 1:29
    grupo = find(Y==k);
    plot3(U(grupo,1),U(grupo,2),U(grupo,3),'ok','MarkerFaceColor',colors_rings(k,:));    
end
title(['PV = ',num2str(pv)],'fontsize',20);

le = legend(string(unique(Y)));
set(le,'fontsize',7,'location','bestoutside');
eee

%Cross-Validation
[N,n] = size(X);

%Training
Ntra = round(0.7*N); %for training

for it = 1:1000

pos = randperm(N);
Xtra = X(pos(1:Ntra),:);
Xval = X(pos(Ntra+1:end),:);
%fig = figure;
%hold all
H = eye(4,5);
for k = -1:1
    grupo = find(Xtra(:,5)==k);
    %grupo_full = find(Y==k);
    %plot(U(grupo_full,1),U(grupo_full,2),'o');
    GX = Xtra(grupo,:);
    CG = cov(GX);
    mG = mean(GX);
    m{k+2} = H*(mG');
    C{k+2} = H*CG*H';
    %pmG = mG*PHI2;
    %plot(pmG(1),pmG(2),'ok','markersize',10 ...
   %     , 'markerfacecolor','k');  
end

%Validation
%We have 3 clusters
[Nval,~] = size(Xval);
cla = [-1 0 1];
for k = 1:Nval
    xg = Xval(k,:);
    yg = H*(xg');
    cg = xg(5);
for c=1:3
    pmc = m{c};
    pCc = C{c};
    pc(c) = mvnpdf(yg,pmc,pCc);
end
[~,posC] = max(pc);
cat_est(k) = cla(posC);
cat_rea(k) = cg;
end
A(it) = sum(cat_est==cat_rea)/Nval;
end

fig = figure;
hist(A);
   