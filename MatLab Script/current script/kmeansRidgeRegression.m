clear;
a=3;
writerFile = fopen(['C:\Users\Public\matlab_output\results_mixture_TbF_route_month_b ' num2str(a) '.txt'],'w');
%route=4;
nbr_feature=a+1+12+17;
fprintf(writerFile,'Idx,lambda,TrainingError, CrossValidationError, TestError, ThetaParas (%d)...\n',nbr_feature);
k_fold_number=10;
%filename = ['C:\Users\andre\Documents\Projet\MatLab Script\data\dataCSV_route_' num2str(route) '.txt'];
filename = 'C:\Users\andre\Documents\Projet\MatLab Script\data\csv_route_month_TBF.txt';
Data = double(csvread(filename, 1, 0));
[m,~] = size(Data);
random_perm = randperm(m);
TestSet = Data(random_perm(1:floor(m*2/10)),:);
[m,n] =size(Data);
%data_decoupe = 100;
%nbr_data_displayed = 300;
%right_number_complexity=0;
size_ridge_coef=500;
CVE_D = 0;
TrE_D_1 = 0;
TrE_D_2 = 0;
TeE_D = 0;
CVE_matrix = ones(k_fold_number,1);
TrE_matrix_1 = ones(k_fold_number,1);
TrE_matrix_2 = ones(k_fold_number,1);
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

%Getting datas
%End of getting datas

%All set


CrossValidationSet = Data(random_perm(floor(m*2/10):floor(m*4/10)),:);
TrainingSet = Data(random_perm(floor(m*4/10):m),:);
[sizeTS,largeur]=size(TrainingSet);
TrendMask = (rand(sizeTS,1)>.5);
%End of set creation

%getting datas;
dateMax = max(TrainingSet(:,1));
priceMax = max(TrainingSet(:,2));
flightDurationMax = max(TrainingSet(:,3));


dates = TrainingSet(:,1)/dateMax;
routes = TrainingSet(:,4:20);
month =  TrainingSet(:,22:33);
prices = TrainingSet(:,2)/priceMax;
flightDuration = TrainingSet(:,3)/flightDurationMax;
Xtotal = getInput(dates,a,flightDuration,routes, month);
TrendMask1 = TrendMask;

for p=1:largeur-1
    TrendMask1 = horzcat(TrendMask1,TrendMask);
end
TrendMask = TrendMask==0;
TrendMask2 = TrendMask;

for p=1:largeur-1
    TrendMask2 = horzcat(TrendMask2,TrendMask);
end


for j=1:3
    Loop = j
%defining trend 1 & 2
TrainingSet_1 = TrainingSet.*TrendMask1;
TrainingSet_1( ~any(TrainingSet_1,2), : ) = [];
TrainingSet_2 = TrainingSet.*TrendMask2;
TrainingSet_2( ~any(TrainingSet_2,2), : ) = [];

dates_1 = TrainingSet_1(:,1);
prices_1 = TrainingSet_1(:,2);
flightDuration_1 = TrainingSet_1(:,3);
month_1 =  TrainingSet_1(:,22:33);
routes_1 = TrainingSet_1(:,4:20);

dates_2 = TrainingSet_2(:,1);
prices_2 = TrainingSet_2(:,2);
flightDuration_2 = TrainingSet_2(:,3);
month_2 =  TrainingSet_2(:,22:33);
routes_2 = TrainingSet_2(:,4:20);

dates_Cross = CrossValidationSet(:,1);
routes_Cross = CrossValidationSet(:,4:20);
month_Cross =  CrossValidationSet(:,22:33);
prices_Cross = CrossValidationSet(:,2);
flightDuration_Cross = CrossValidationSet(:,3);
dateMax_Cross = max(dates_Cross);
priceMax_Cross = max(prices_Cross);
flightDurationMax_Cross = max(flightDuration_Cross);

%Normalization
dates_1 = dates_1/dateMax;
prices_1 = prices_1/priceMax;
flightDuration_1 = flightDuration_1/flightDurationMax;
dates_2 = dates_2/dateMax;
prices_2 = prices_2/priceMax;
flightDuration_2 = flightDuration_2/flightDurationMax;

dates_Cross = dates_Cross/dateMax_Cross;
prices_Cross = prices_Cross/priceMax_Cross;
flightDuration_Cross = flightDuration_Cross/flightDurationMax_Cross;
%end of getting datas

%Parameters
Xtotal_1 = getInput(dates_1,a,flightDuration_1,routes_1, month_1);
Xtotal_2 = getInput(dates_2,a,flightDuration_2,routes_2, month_2);
Xtotal_Cross = getInput(dates_Cross,a,flightDuration_Cross,routes_Cross,month_Cross);
Xtotal_Test = getInput(dates_Test,a,flightDuration_Test,routes_Test, month_Test);
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
ridge_theta_matrix_1 = (ridge(double(prices_1),Xtotal_1,lambda_coef,0));
ridge_theta_matrix_2 = (ridge(double(prices_2),Xtotal_2,lambda_coef,0));
ridge_theta_matrix = (ridge(double(prices),Xtotal,lambda_coef,0));
%choising the right models with cross_validation_set
idx=0;
idx_1=0;
idx_2=0;
old_CV_Error = 10^160;
old_Tr_Error_1 = 10^160;
old_Tr_Error_2 = 10^160;
old_Te_Error = 10^160;
CVE_vector = ones(size_ridge_coef,1);
TrE_vector = ones(size_ridge_coef,1);
TeE_vector = ones(size_ridge_coef,1);
for i=1:size_ridge_coef
    ridge_theta_1 = ridge_theta_matrix_1(1:nbr_feature+1,i);
    ridge_theta_2 = ridge_theta_matrix_2(1:nbr_feature+1,i);
    ridge_theta = ridge_theta_matrix(1:nbr_feature+1,i);
    
    TrE_1 = cost_function(ridge_theta_1,Xtotal_1,prices_1,lambda_coef(i));
    TrE_2 = cost_function(ridge_theta_2,Xtotal_2,prices_2,lambda_coef(i));
    
    CVE = cost_function(ridge_theta,Xtotal_Cross,prices_Cross,lambda_coef(i));
    TeE = cost_function(ridge_theta,Xtotal_Test,prices_Test,lambda_coef(i));
    if(CVE < old_CV_Error)
        idx = i;
        CVE_matrix(j+1) = CVE;
        old_CV_Error = CVE;
    end
    if(TrE_1 < old_Tr_Error_1)
        idx_1=i;
        TrE_matrix_1(j+1) = TrE_1;
        old_Tr_Error_1 = TrE_1;
    end
    if(TrE_2 < old_Tr_Error_2)
        idx_2=i;
        TrE_matrix_2(j+1) = TrE_2;
        old_Tr_Error_2 = TrE_2;
    end
    if(TeE < old_Te_Error)
        TeE_matrix(j+1) = TeE;
        old_Te_Error = TeE;
    end
end
lambda_CV = lambda_coef(idx);
CVE_D = CVE_D+old_CV_Error;
TeE_D = TeE_D + old_Te_Error;
TrE_D_1 = TrE_D_1 + old_Tr_Error_1;
TrE_D_2 = TrE_D_2 + old_Tr_Error_2;

TrendError(:,1) = cost_function_matrix(ridge_theta_matrix_1(1:nbr_feature+1,idx_1),Xtotal,prices,lambda_coef(idx_1));
TrendError(:,2) = cost_function_matrix(ridge_theta_matrix_2(1:nbr_feature+1,idx_2),Xtotal,prices,lambda_coef(idx_2));
%End of chosing the model
%Choosing trend
TrendMask = TrendError(:,1)<TrendError(:,2);
end;

fprintf(writerFile,'%d,',j);
fprintf(writerFile,'%f,',lambda_CV);
fprintf(writerFile,'%f,',old_Tr_Error_1);
fprintf(writerFile,'%f,',old_CV_Error);
fprintf(writerFile,'%f,',old_Te_Error);
for p=1:nbr_feature
   fprintf(writerFile,'%f,',ridge_theta_matrix_1(p,idx)); 
end
fprintf(writerFile,'%f\n',ridge_theta_matrix_1(nbr_feature+1,idx));

fprintf(writerFile,'%d,',j);
fprintf(writerFile,'%f,',lambda_CV);
fprintf(writerFile,'%f,',old_Tr_Error_2);
fprintf(writerFile,'%f,',old_CV_Error);
fprintf(writerFile,'%f,',old_Te_Error);
for p=1:nbr_feature
   fprintf(writerFile,'%f,',ridge_theta_matrix_2(p,idx)); 
end
fprintf(writerFile,'%f\n',ridge_theta_matrix_2(nbr_feature+1,idx));


fclose(writerFile);

