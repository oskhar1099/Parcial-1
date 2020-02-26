clc
clear all
close all

rng(10)

L = load('Data');

D = L.D;

X = D(:,1:4);

H = [1 0 0 0;0 1 0 0;0 0 0 1];
X = X(1:end-1,:);

Y = D(1:end-1,end);
yl = D(end,end);

[U,S,V] = svd(X,0);
PHI = V/S;
PHI2 = PHI(:,1:2); %To project onto two dimensions
dS = diag(S);
pv = sum(dS(1:2))/sum(dS);

%Iris-Setosa
indLa = find(Y==1);
US = U(indLa,[1 2]);
XS = X(indLa,:);
xe = XS(end,:);
XS = XS(1:end-1,:);

%Mean and Covariance
xb = mean(XS);
B  = cov(XS);

%Estimation
sig = 100;
eobs = sig*randn(3,1);
y = H*(xe')+eobs;
%Posterior
xa = (inv(B)+(1/sig^2)*H'*H)\(B\(xb')+(1/sig^2)*H'*y);
%Covarianza posterior
Ca = inv(inv(B)+(1/sig^2)*H'*H);

est3 = xa(3);
var3 = Ca(3,3);

syms z
fig = figure
ezplot(normpdf(z,est3,var3))


%Two dimensional projections
xbh = xb*PHI2; %2D Mean
Bh  = PHI2'*B*PHI2;
xeh = xe*PHI2;

fig = figure;
hold all
plot(U(indLa,1),U(indLa,2),'ok',...
    'markersize',20,'markerfacecolor','m');
plot(xbh(1),xbh(2),'ok',...
    'markersize',20,'markerfacecolor','k');
plot(xeh(1),xeh(2),'ob',...
    'markersize',40,'markerfacecolor','b');
title(['PV = ',num2str(pv)],'fontsize',20);
le = legend('Iris-Setosa','Mean');
set(le,'fontsize',20,'location','best');
grid on

C = corr(XS);
fig = figure;
imagesc(C);
colorbar


%Case 1 - Estimate xb y B Rn, sampling Rn, Project
MR = mvnrnd(xb,B,4000);
MRh = MR*PHI2;

fig = figure;
hold all

plot(MRh(:,1),MRh(:,2),'ok','markersize',10,...
    'markerfacecolor','k');
plot(U(indLa,1),U(indLa,2),'ok',...
    'markersize',10,'markerfacecolor','m');
title('EO-MO-PS','fontsize',20);
grid on

%Case 2 - Estimate xb y B Rn, Project xbh Bh, Sampling en R2
MRh = mvnrnd(xbh,Bh,4000);

fig = figure;
hold all
plot(MRh(:,1),MRh(:,2),'ok','markersize',10,...
    'markerfacecolor','k');
plot(U(indLa,1),U(indLa,2),'ok',...
    'markersize',10,'markerfacecolor','m');
title('EO-P-MP','fontsize',20);
grid on

%Case 3 - All onto R2
xbh = mean(US);
Bh  = cov(US);
MRh = mvnrnd(xbh,Bh,4000);
fig = figure;
hold all
plot(MRh(:,1),MRh(:,2),'ok','markersize',10,...
    'markerfacecolor','k');
plot(U(indLa,1),U(indLa,2),'ok',...
    'markersize',10,'markerfacecolor','m');
title('P','fontsize',20);
grid on

















