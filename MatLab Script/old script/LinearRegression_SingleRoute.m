
%for i=1:17
figure;
route=4;
filename = ['C:\Users\andre\Documents\Projet\MatLab Script\data\dataCSV_route_' num2str(route) '.txt'];
Data = double(csvread(filename, 1, 0));
[m,n] = size(Data);
k = randperm(m);

%All set
TrainingSet = Data(k(1:floor(m*0.6)),:);
CrossValidationSet = Data(k(floor(m*0.6):floor(m*0.6)+floor(m*0.2)),:);
TestSet = Data(k(floor(m*0.6)+floor(m*0.2):m),:);
k = randperm(m);
cloud = Data(k(1:200),:);

%getting datas;
date_before_flight = TrainingSet(:,1);
prices = TrainingSet(:,2); 
xNormal = max(date_before_flight);
yNormal = max(prices);
date_before_flight = date_before_flight/xNormal;
prices = prices/yNormal;

date_before_flight_Cross = CrossValidationSet(:,1);
prices_Cross = CrossValidationSet(:,2);
xNormal_Cross = max(date_before_flight_Cross);
yNormal_Cross = max(prices_Cross);
date_before_flight_Cross = date_before_flight_Cross/xNormal_Cross;
prices_Cross=prices_Cross/yNormal_Cross;

date_before_flight_Test = TestSet(:,1);
prices_Test = TestSet(:,2); 
xNormal_Test = max(date_before_flight_Test);
yNormal_Test = max(prices_Test);
date_before_flight_Test = date_before_flight_Test/xNormal_Test;
prices_Test = prices_Test/yNormal_Test;
%end of getting datas

%Parameters
dbf_double = double(date_before_flight);
nbr_feature = 4;
base = ones(size(date_before_flight));
x0s2 = dbf_double.^2;
x0s3 = dbf_double.^3;
x0s4 = dbf_double.^4;
x0s5 = dbf_double.^5;
x0s6 = dbf_double.^6;
Xtotal = horzcat(base,dbf_double,x0s2,x0s3,x0s4);%,x0s5,x0s6);
Xtotal_ridge = horzcat(dbf_double,Xtotal);
%end parameters

%ridge regression coefficient
size_ridge_coef = 500;
lambda_coef = ones(size_ridge_coef,1);
lambda_coef_c = ones(size_ridge_coef,1);
lower_bound = 0; %0.15
upper_bound = 10; %0.2
for i=1:size_ridge_coef
    lambda_coef(i) = lower_bound + i * (upper_bound-lower_bound)/size_ridge_coef;
  %  lambda_coef_c(i) = lower_bound + i * (upper_bound-lower_bound)/size_ridge_coef;
end
%end of ridge regression coefficient


b_matrix = transpose(ridge(double(prices),Xtotal,lambda_coef,1));
%c_matrix = transpose(ridge(double(prices),Xtotal_ridge,lambda_coef_c,1));
[reg conf] = (regress(double(prices),Xtotal));
reg = transpose(reg);
indice_retenu=0;
indice_retenu_c=0;
old = 10^160;
old_c = 10^160;
%b_matrix = horzcat(ones(size(b_matrix(:,1))),b_matrix);
for i=1:size_ridge_coef
    b = b_matrix(i,1:nbr_feature+1);
%    c = c_matrix(i,1:nbr_feature);
   % TrainingError = cost_function_SingleRoute(b,date_before_flight,prices,lambda_coef(i));
  %  TrainingError = cost_function_SingleRoute(reg,date_before_flight,prices,-1);
    CrossValidationError = cost_function_SingleRoute(b,date_before_flight_Cross,prices_Cross,lambda_coef(i));
    if(CrossValidationError < old)
        indice_retenu = i;
        old = CrossValidationError;
    end
  %  CrossValidationError_c = cost_function_SingleRoute(c,CrossValidationSet(:,1),CrossValidationSet(:,2),lambda_coef_c(i));
  %  if(CrossValidationError_c < old_c)
  %      indice_retenu_c = i;
  %      old_c = CrossValidationError_c;
  %  end
end
old
%old_c
indice_retenu
%indice_retenu_c
lambda_actu = lambda_coef(indice_retenu);
%lambda_actu_c = lambda_coef_c(indice_retenu_c);
%TestError = cost_function_SingleRoute(c,TestSet(:,1),TestSet(:,2),lambda_actu_c)
   
Limits = [0,1*xNormal/(3600*24),0,1*yNormal];
%fplot(@(x)hypothesis_SingleRoute(Theta,x), Limits)
%hold on;
%fplot(@(x)hypothesis_SingleRoute(b_matrix(indice_retenu,1:nbr_feature+1),x/(xNormal/(3600*24)))*yNormal, Limits)
%hold on;
%fplot(@(x)hypothesis_SingleRoute(c_matrix(indice_retenu_c,1:nbr_feature),x/(xNormal/(3600*24)))*yNormal, Limits)
%hold on;
fplot(@(x)hypothesis_SingleRoute(reg,x/(xNormal/(3600*24)))*yNormal, Limits)
hold on;
TrainingError_WithoutRidge = cost_function_SingleRoute(reg,date_before_flight,prices,lambda_actu)
CrossValidationError_WithoutRidge = cost_function_SingleRoute(reg,date_before_flight_Cross,prices_Cross,lambda_actu)
TestError_WithoutRidge = cost_function_SingleRoute(reg,date_before_flight_Test,prices_Test,lambda_actu)

TrainingError = cost_function_SingleRoute(b_matrix(indice_retenu,1:nbr_feature+1),date_before_flight,prices,lambda_actu)
CrossValidationError = cost_function_SingleRoute(b_matrix(indice_retenu,1:nbr_feature+1),date_before_flight_Cross,prices_Cross,lambda_actu)
TestError = cost_function_SingleRoute(b_matrix(indice_retenu,1:nbr_feature+1),date_before_flight_Test,prices_Test,lambda_actu)


Xaxis = double(cloud(:,1)/(3600*24));
Yaxis = double(cloud(:,2));%/double(yNormal);
plot(Xaxis,Yaxis,'*')
title(['Linear regression route = ' num2str(route)]);
xlabel('Number of days before flight');
ylabel('Price (in €)');
%['ridge_c, lambda = ' num2str(lambda_actu_c)],
legend('Common trend obtain by multilinear regression','Data (200 example choosen randomly)');

%end
%pause;
