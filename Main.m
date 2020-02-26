clc
clear all
close all

L = load('Data');

D = L.D;

X = D(:,1:4);
Y = D(:,end);
[U,S,V] = svd(X,0);
dS = diag(S);
pv = sum(dS(1:2))/sum(dS);
fig = figure;
C = {'b','r','m'}
hold all
for la = -1:1
indLa = find(Y==la);
plot(U(indLa,1),U(indLa,2),'ok',...
    'markersize',20,'markerfacecolor',C{la+2});
end
title(['PV = ',num2str(pv)],'fontsize',20);
le = legend('Iris-Virginica','Iris-Versicolour','Iris-Setosa');
set(le,'fontsize',20,'location','best');
grid on


fig = figure;
pv = sum(dS(1:3))/sum(dS);
C = {'b','r','m'}
hold all
for la = -1:1
indLa = find(Y==la);
plot3(U(indLa,1),U(indLa,2),U(indLa,3),'ok',...
    'markersize',20,'markerfacecolor',C{la+2});
end
title(['PV = ',num2str(pv)],'fontsize',20);
le = legend('Iris-Virginica','Iris-Versicolour','Iris-Setosa');
set(le,'fontsize',20,'location','best');
grid on




