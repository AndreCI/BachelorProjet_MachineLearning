clear;
fileID_lambda = fopen('lambda_out.txt','w');
fileID_theta = fopen('theta_out.txt','w');
fileID_CVE = fopen('CVE_out.txt','w');

route=4;
nbr_feature_max = 8;
nbr_feature=6+17;
k_fold_number=10;
%filename = ['C:\Users\andre\Documents\Projet\MatLab Script\data\dataCSV_route_' num2str(route) '.txt'];
filename = 'C:\Users\andre\Documents\Projet\MatLab Script\data\dataCSV_second.txt';
Data = double(csvread(filename, 1, 0));
[m,n] = size(Data);
random_perm = randperm(m);
%data_decoupe = 100;
nbr_data_displayed = 300;
right_number_complexity=0;
size_ridge_coef=500;
CVE_D = 0;
CVE_matrix = ones(k_fold_number,1);
format = [''];
for l=1:nbr_feature+1
    format = [format '%6.6f '];
end
format

for j=0:1
%Getting datas
%End of getting datas

%All set
CrossValidationSet = Data(random_perm( floor(j*m/k_fold_number)+1:floor((j+1)*m/k_fold_number) ),:);
if(j~=k_fold_number-1)
    TrainingSet = vertcat(Data(random_perm(1:floor(j*m/k_fold_number)),:),Data(random_perm(floor((j+1)*m/k_fold_number):m),:)); 
else
    TrainingSet = Data(random_perm(1:floor(j*m/k_fold_number)),:); 
end
temp = randperm(m);
cloud = Data(temp(1:nbr_data_displayed),:);
%End of set creation

%getting datas;
dates = TrainingSet(:,1);
routes = TrainingSet(:,3:19);
prices = TrainingSet(:,2); 
dateMax = max(dates);
priceMax = max(prices);

dates_Cross = CrossValidationSet(:,1);
routes_Cross = CrossValidationSet(:,3:19);
prices_Cross = CrossValidationSet(:,2);
dateMax_Cross = max(dates_Cross);
priceMax_Cross = max(prices_Cross);

%Normalization
dates = dates/dateMax;
prices = prices/priceMax;
dates_Cross = dates_Cross/dateMax_Cross;
prices_Cross = prices_Cross/priceMax_Cross;
%end of getting datas

%Parameters
Xtotal = getInput(dates,6,routes);
Xtotal_Cross = getInput(dates_Cross,6,routes_Cross);
%Xtotal = Xtotal(:,1:nbr_feature);
%end parameters

%ridge regression parameters
lambda_coef = ones(size_ridge_coef,1);
lambda_coef(1) = 10^-5;
for i=2:size_ridge_coef
    lambda_coef(i) = lambda_coef(i-1)*10;
end

lower_bound = 0.1;
upper_bound =5;
for i=1:size_ridge_coef
    lambda_coef(i) = lower_bound + i * (upper_bound-lower_bound)/size_ridge_coef;
end
%end of ridge regression parameters

%ridge regression
ridge_theta_matrix = (ridge(double(prices),Xtotal,lambda_coef,0));
loop = j
%choising the right models with cross_validation_set
idx=0;
old_CV_Error = 10^160;
CVE_vector = ones(size_ridge_coef,1);
for i=1:size_ridge_coef
    ridge_theta = ridge_theta_matrix(1:nbr_feature+1,i);
    CVE = cost_function(ridge_theta,Xtotal_Cross,prices_Cross,lambda_coef(i));
    
    if(CVE < old_CV_Error)
        idx = i;
        CVE_matrix(j+1) = CVE;
        old_CV_Error = CVE;
    end
end
lambda_CV = lambda_coef(idx);
CVE_D = CVE_D+old_CV_Error;
%End of chosing the model


%Displaying some data
%End of datas

fprint(fileID_Theta,format,ridge_theta_matrix(1:nbr_feature+1,idx)');
fprint(fileID_Theta,'%d\n',j);
fprint(fileID_CVE,'%6.6f',old_CV_Error);
fprint(fileID_CVE,'%d\n',j);
fprint(fileID_lambda,'%6.6f',lambda_CV);
fprint(fileID_labmda,'%d\n',j);
end
CVE_D = CVE_D/k_fold_number
%preparing the figure

