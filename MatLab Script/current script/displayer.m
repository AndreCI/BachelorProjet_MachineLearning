clear;
complexity = 7;
filename = ['C:\Users\André\Documents\GitHub\BachelorProjet_MachineLearning\MatLab Script\result\results_route_month_ ' num2str(complexity) '.txt'];
Results = double(csvread(filename, 1, 0));
nbr_feature = complexity+12+17;
nbr_data_displayed = 300;

lambdas = Results(:,2);
crossValidationError = Results(:,3);
theta_matrix = Results(:,4:4+nbr_feature);

idx = 0;
CVE = 10;
for i=1:size(crossValidationError)
    if(crossValidationError(i)<CVE)
       idx=i;
       CVE=crossValidationError(i);
    end
end

filename = 'C:\Users\André\Documents\GitHub\BachelorProjet_MachineLearning\MatLab Script\data\dataCSV_second.txt';
Data = double(csvread(filename, 1, 0));
[m,n] = size(Data);
dates = Data(:,1);
routes = Data(:,3:19);
prices = Data(:,2); 
dateMax = max(dates);
priceMax = max(prices);

temp = randperm(m);
cloud = Data(temp(1:nbr_data_displayed),:);

figure;
Limits = [0,1*dateMax/(3600*24),0,1*priceMax];
    route_nbr = 6;
    month_nbr = 12;
    fplot(@(x)hypothesis_display(transpose(theta_matrix(idx,:)),x/(dateMax/(3600*24)),complexity,route_nbr,month_nbr)*priceMax, Limits)
    hold on;
    
    
Xaxis = double(cloud(:,1)/(3600*24));
Yaxis = double(cloud(:,2));
plot(Xaxis,Yaxis,'*')
title(['Ridge Regression : complexity = ' num2str(complexity) ',route = ' num2str(route_nbr) ', month = ' num2str(month_nbr) ', with ' num2str(nbr_feature) ' features']);
xlabel('Number of days before flight');
ylabel('Price (in €)');
ridge_legend = ['ridge, lambda = ' num2str(lambdas(idx)) ];%' ; TrainError : ' num2str(TE) ' ; CVError : ' num2str(CVE) ' ; TestError : ' num2str(TestE)];
data_legend = ['Data (' num2str(nbr_data_displayed) ')'];
legend(ridge_legend,data_legend);
%End of figure