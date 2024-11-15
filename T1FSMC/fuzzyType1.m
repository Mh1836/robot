clc;
clear;
% close all;

%% Create FIS Structure

fisName='Kr';
andMethod='min';
orMethod='max';
impMethod='min';
aggMethod='max';
defuzzMethod='centroid';

fis=mamfis('Name',fisName,'AndMethod',andMethod,'OrMethod',orMethod,...
    'ImplicationMethod',impMethod,'AggregationMethod',aggMethod,'DefuzzificationMethod',defuzzMethod);

%% Add Variables

fis=addInput(fis,[-0.1 0.1],'Name','Error');
fis=addMF(fis,'Error','trimf',[-0.15 -0.1 -0.05],'Name','NB');
fis=addMF(fis,'Error','trimf',[-0.1 -0.05 0],'Name','N');
fis=addMF(fis,'Error','trimf',[-0.05 0 0.05],'Name','ZE');
fis=addMF(fis,'Error','trimf',[0 0.05 0.1],'Name','P');
fis=addMF(fis,'Error','trimf',[0.05 0.1 0.15],'Name','PB');


 fis=addInput(fis,[-0.2 0.2],'Name','Rate of Error');
fis=addMF(fis,'Rate of Error','trimf',[-0.3 -0.2 -0.1],'Name','NB');
fis=addMF(fis,'Rate of Error','trimf',[-0.2 -0.1 0],'Name','N');
fis=addMF(fis,'Rate of Error','trimf',[-0.1 0 0.1],'Name','ZE');
fis=addMF(fis,'Rate of Error','trimf',[0 0.1 0.2],'Name','P');
fis=addMF(fis,'Rate of Error','trimf',[0.1 0.2 0.3],'Name','PB');

fis=addOutput(fis,[0 2],'Name','reaching gain');
fis=addMF(fis,'reaching gain','trimf',[-0.5 0.0 0.5],'Name','VS');
fis=addMF(fis,'reaching gain','trimf',[0 0.5 1],'Name','S');
fis=addMF(fis,'reaching gain','trimf',[0.5 1 1.5],'Name','M');
fis=addMF(fis,'reaching gain','trimf',[1 1.5 2],'Name','B');
fis=addMF(fis,'reaching gain','trimf',[1.5 2 2.5],'Name','VB');

%% Add Rules
Rules=[1 1, 3 1 1
1 2, 4 1 1
1 3, 5 1 1
1 4, 4 1 1
1 5, 3 1 1
2 1, 2 1 1
2 2, 3 1 1
2 3, 4 1 1
2 4, 3 1 1
2 5, 2 1 1
3 1, 1 1 1
3 2, 2 1 1
3 3, 3 1 1
3 4, 2 1 1
3 5, 1 1 1
4 1, 2 1 1
4 2, 3 1 1
4 3, 4 1 1
4 4, 3 1 1
4 5, 2 1 1
5 1, 3 1 1
5 2, 4 1 1
5 3, 5 1 1
5 4, 4 1 1
5 5, 3 1 1];

fis=addRule(fis,Rules);

%% Plots and Analysis

% surfview(fis)
% ruleview(fis)
subplot(2,2,1)
plotmf(fis,'input',1)
% legend('UpperMF','LowerMF','FOU','FontSize',20);
% title('')
% ylabel('Degree of membership','FontSize',20)
% xlabel('Error(m)','FontSize',20)

subplot(2,2,2)
plotmf(fis,'input',2)
% legend('UpperMF','LowerMF','FOU','FontSize',20);
% title('')
% ylabel('Degree of membership','FontSize',20)
% xlabel('Rate of Error(m)','FontSize',20)
subplot(2,2,[3 4])
plotmf(fis,'output',1)
% legend('UpperMF','LowerMF','FOU','FontSize',20);
% title('')
% ylabel('Degree of membership','FontSize',20)
% xlabel('reaching gain','FontSize',20)
% rad=linspace(0.3,1.9*pi,1000)';
% 
% out=evalfis(fis,[rad rad]);
% 
% plot(out);
% 
% hold on
plotmf(fis,'input',1)
ylabel('Degree of membership','FontSize',20)
xlabel('Error(m)','FontSize',20)
plotmf(fis,'input',2)
ylabel('Degree of membership','FontSize',20)
xlabel('Rate of Error(m)','FontSize',20)
plotmf(fis,'output',1)
ylabel('Degree of membership','FontSize',20)
xlabel('\rho','FontSize',20)
save('Myfis','fis')


