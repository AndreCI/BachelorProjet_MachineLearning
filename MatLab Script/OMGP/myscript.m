%
% Tests functions omgp_gen and omgp
%

clear all 
close all

% Number of time instants per GP, dimensions, and GPs

n = 100;
D = 1;
M = 2;


% Tunable hyperparameters
timescale = 20;
sigvar = 1;
noisevar = 0.002;

% Data generation and plotting
close all
loghyper = [log(timescale); 0.5*log(sigvar); 0.5*log(noisevar)];
% [x, Y] = omgp_gen(loghyper, n, D, M);
% 
% x_train = x(1:2:end);
% Y_train = Y(1:2:end,:);
% x_test = x(2:2:end);
% Y_test = Y(2:2:end,:);

filename = 'C:\Users\andre\Documents\Projet\MatLab Script\data\data_double.txt';
Data = double(csvread(filename, 1, 0));
[m,n] = size(Data);
%random_perm = randperm(m);
%Data = Data(random_perm,:);
Data = Data(1:2000,:);
x = Data(:,1);
x = x/max(x);
x_train = x(1:2:end);
x_test = x(2:2:end);
Y = Data(:,2);
Y=Y/max(Y);
Y_train = Y(1:2:end);
Y_test = Y(2:2:end);



figure
plot(x_train, Y_train, 'kx')
title(sprintf('%d trajectories to be separated (drag to see)',M))
pause


% OMGP tracking and plotting
covfunc = {};
for m=1:1       % Same type of covariance function for every GP in the model
    covfunc = {covfunc{:} {'covSEiso'}};
end

[F, qZ, loghyperinit, mu, C, pi0] = omgp(covfunc, M, x_train, Y_train, x_test);

pi0

[NMSE, NLPD] = quality(Y_test, mu, C, pi0);

[nada, label] = max(qZ,[],2);
figure
colors = get(gcf,'DefaultAxesColorOrder');
for c = 1:M
    plot(x_train(label==c),Y_train(label==c),'color',colors(mod(c+1,7)+1,:),'marker','x','linestyle','none');
    hold on
    plot(x_test,mu(:,1,c),'color',colors(mod(c+1,7)+1,:));
end