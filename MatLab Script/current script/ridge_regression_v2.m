clear;
for a=3:6
writerFile = fopen(['C:\Users\Public\matlab_output\results_route_month_ ' num2str(a) '.txt'],'w');
%route=4;
nbr_feature=a+1+12+17;
fprintf(writerFile,'Idx,lambda,TrainingError, CrossValidationError, TestError, ThetaParas (%d)...\n',nbr_feature);
k_fold_number=10;
%filename = ['C:\Users\andre\Documents\Projet\MatLab Script\data\dataCSV_route_' num2str(route) '.txt'];
filename = 'C:\Users\André\Documents\GitHub\BachelorProjet_MachineLearning\MatLab Script\data\dataCSV_route_month.txt';
Data = double(csvread(filename, 1, 0));
[m,~] = size(Data);
TestSet_random_perm = randperm(m);
TestSet = Data(TestSet_random_perm(1:floor(m*2/10)),:);
Data = Data(TestSet_random_perm(floor(m*2/10):m),:);
[m,n] =size(Data);
random_perm = randperm(m);
%data_decoupe = 100;
%nbr_data_displayed = 300;
%right_number_complexity=0;
size_ridge_coef=500;
CVE_D = 0;
TrE_D = 0;
TeE_D = 0;
CVE_matrix = ones(k_fold_number,1);
TrE_matrix = ones(k_fold_number,1);
TeE_matrix = ones(k_fold_number,1);

dates_Test = TestSet(:,1);
routes_Test = TestSet(:,4:20);
month_Test =  TestSet(:,22:33);
prices_Test = TestSet(:,2);
flightDuration_Test = TestSet(:,3);
dateMax_Test = max(dates_Test);
priceMax_Test = max(prices_Test);
flightDurationMax_Test = max(flightDuration_Test);
dates_Test = dates_Test/dateMax_Test;
prices_Test = prices_Test/priceMax_Test;
flightDuration_Test = flightDuration_Test/flightDurationMax_Test;

for j=0:k_fold_number-1
%Getting datas
%End of getting datas

%All set
CrossValidationSet = Data(random_perm( floor(j*m/k_fold_number)+1:floor((j+1)*m/k_fold_number) ),:);
if(j~=k_fold_number-1)
    TrainingSet = vertcat(Data(random_perm(1:floor(j*m/k_fold_number)),:),Data(random_perm(floor((j+1)*m/k_fold_number):m),:)); 
else
    TrainingSet = Data(random_perm(1:floor(j*m/k_fold_number)),:); 
end
%End of set creation

%getting datas;
dates = TrainingSet(:,1);
routes = TrainingSet(:,4:20);
month =  TrainingSet(:,22:33);
prices = TrainingSet(:,2);
flightDuration = TrainingSet(:,3);
dateMax = max(dates);
priceMax = max(prices);
flightDurationMax = max(flightDuration);

dates_Cross = CrossValidationSet(:,1);
routes_Cross = CrossValidationSet(:,4:20);
month_Cross =  CrossValidationSet(:,22:33);
prices_Cross = CrossValidationSet(:,2);
flightDuration_Cross = CrossValidationSet(:,3);
dateMax_Cross = max(dates_Cross);
priceMax_Cross = max(prices_Cross);
flightDurationMax_Cross = max(flightDuration_Cross);

%Normalization
dates = dates/dateMax;
prices = prices/priceMax;
flightDuration = flightDuration/flightDurationMax;
dates_Cross = dates_Cross/dateMax_Cross;
prices_Cross = prices_Cross/priceMax_Cross;
flightDuration_Cross = flightDuration_Cross/flightDurationMax_Cross;
%end of getting datas

%Parameters
Xtotal = getInput(dates,a,flightDuration,routes, month);
Xtotal_Cross = getInput(dates_Cross,a,flightDuration_Cross,routes_Cross,month_Cross);
Xtotal_Test = getInput(dates_Test,a,flightDuration_Test,routes_Test, month_Test);
%Xtotal = Xtotal(:,1:nbr_feature);
%end parameters

%ridge regression parameters
lambda_coef = ones(size_ridge_coef,1);
%lambda_coef(1) = 10^-5;
%for i=2:size_ridge_coef
%    lambda_coef(i) = lambda_coef(i-1)*10;
%end

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
old_Tr_Error = 10^160;
old_Te_Error = 10^160;
CVE_vector = ones(size_ridge_coef,1);
TrE_vector = ones(size_ridge_coef,1);
TeE_vector = ones(size_ridge_coef,1);
for i=1:size_ridge_coef
    ridge_theta = ridge_theta_matrix(1:nbr_feature+1,i);
    CVE = cost_function(ridge_theta,Xtotal_Cross,prices_Cross,lambda_coef(i));
    TrE = cost_function(ridge_theta,Xtotal,prices,lambda_coef(i));
    TeE = cost_function(ridge_theta,Xtotal_Test,prices_Test,lambda_coef(i));
    if(CVE < old_CV_Error)
        idx = i;
        CVE_matrix(j+1) = CVE;
        old_CV_Error = CVE;
    end
    if(TrE < old_Tr_Error)
      
        TrE_matrix(j+1) = TrE;
        old_Tr_Error = TrE;
    end
    if(TeE < old_Te_Error)
        TeE_matrix(j+1) = TeE;
        old_Te_Error = TeE;
    end
end
lambda_CV = lambda_coef(idx);
CVE_D = CVE_D+old_CV_Error;
TeE_D = TeE_D + old_Te_Error;
TrE_D = TrE_D + old_Tr_Error;
%End of chosing the model


%Displaying some data
%End of datas

fprintf(writerFile,'%d,',j);
fprintf(writerFile,'%f,',lambda_CV);
fprintf(writerFile,'%f,',old_Tr_Error);
fprintf(writerFile,'%f,',old_CV_Error);
fprintf(writerFile,'%f,',old_Te_Error);
for p=1:nbr_feature
   fprintf(writerFile,'%f,',ridge_theta_matrix(p,idx)); 
end
fprintf(writerFile,'%f\n',ridge_theta_matrix(nbr_feature+1,idx));
   
end
CVE_D = CVE_D/k_fold_number
TrE_D = TrE_D/k_fold_number
TeE_D = TeE_D/k_fold_number
fclose(writerFile);
end
%preparing the figure

