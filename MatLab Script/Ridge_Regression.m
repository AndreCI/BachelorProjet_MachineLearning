clear;
route=4;
nbr_feature_max = 8;

switcher=-1;
data_decoupe = 100;
nbr_data_displayed_max = 300;
right_ridge_theta=0;

if(switcher~=-1)
    total_boucle=0;
else
    total_boucle=2;
end
for a=0:total_boucle;
    nbr_data_displayed = nbr_data_displayed_max;
    if(total_boucle~=0)
    if(a==0)
        switcher=1;
    elseif(a==1)
        switcher=2;
        nbr_feature_max=display_nbr_feature;
    else
        switcher=0;
        right_ridge_theta = display_ridge_theta;
        right_linear_theta = display_linear_theta;
        right_lambda = lambda_CV;
    end
    end
if(switcher==0)
    indice_boucle=data_decoupe;
elseif(switcher==1)
    indice_boucle=nbr_feature_max; 
    choiceMaker = 100;
else
      indice_boucle=1;  
end

for j=1:indice_boucle
    if(switcher==0 || switcher==2)
        nbr_feature = nbr_feature_max;
           nbr_data_displayed = floor(nbr_data_displayed_max/(data_decoupe+1-j));
    elseif(switcher==1)
        if(j==1)
            j=j+1;
        end
        nbr_feature = j;
    end
%Getting datas
filename = ['dataCSV_route_' num2str(route) '.txt'];
Data = double(csvread(filename, 1, 0));
[m,n] = size(Data);
if(switcher==0)
    k = randperm(m);
    Data = Data(k(1:floor(m/(data_decoupe+1-j))),:); % j% of data used
    [m,n] = size(Data);
end
%End of getting datas

%All set
k = randperm(m);
TrainingSet = Data(k(1:floor(m*0.6)),:); %60 %
CrossValidationSet = Data(k(floor(m*0.6):floor(m*0.6)+floor(m*0.2)),:); %20 %
TestSet = Data(k(floor(m*0.6)+floor(m*0.2):m),:);%20 %
k = randperm(m);
cloud = Data(k(1:nbr_data_displayed),:);
%End of set creation

%getting datas;
dates = TrainingSet(:,1);
prices = TrainingSet(:,2); 
dateMax = max(dates);
priceMax = max(prices);

dates_Cross = CrossValidationSet(:,1);
prices_Cross = CrossValidationSet(:,2);
dateMax_Cross = max(dates_Cross);
priceMax_Cross = max(prices_Cross);

dates_Test = TestSet(:,1);
prices_Test = TestSet(:,2); 
dateMax_Test = max(dates_Test);
priceMax_Test = max(prices_Test);

%Normalization
dates_Test = dates_Test/dateMax_Test;
prices_Test = prices_Test/priceMax_Test;
dates = dates/dateMax;
prices = prices/priceMax;
dates_Cross = dates_Cross/dateMax_Cross;
prices_Cross = prices_Cross/priceMax_Cross;
%end of getting datas

%Parameters
dbf_double = double(dates);
base = ones(size(dates));
x0s2 = dbf_double.^2;
x0s3 = dbf_double.^3;
x0s4 = dbf_double.^4;
x0s5 = dbf_double.^5;
x0s6 = dbf_double.^6;
x0s7 = dbf_double.^7;
x0s8 = dbf_double.^8;
x0s9 = dbf_double.^9;
Xtotal = horzcat(dbf_double,x0s2,x0s3,x0s4,x0s5,x0s6,x0s7,x0s8,x0s9);
Xtotal = Xtotal(:,1:nbr_feature);
%end parameters

%ridge regression parameters
if(switcher==0)
    size_ridge_coef = 100;
elseif(switcher==1)
    size_ridge_coef=300;
elseif(switcher==2)
    size_ridge_coef=500;
end
lambda_coef = ones(size_ridge_coef,1);
lower_bound = 0.1;
upper_bound =5;
for i=1:size_ridge_coef
    lambda_coef(i) = lower_bound + i * (upper_bound-lower_bound)/size_ridge_coef;
end
%end of ridge regression parameters

%ridge and linear regression
ridge_theta_matrix = transpose(ridge(double(prices),Xtotal,lambda_coef,0));
linear_theta = transpose(regress(double(prices),horzcat(base,Xtotal)));

%choising the right models with cross_validation_set
idx=0;
old_CV_Error = 10^160;
CVE_vector = ones(size_ridge_coef,1);
for i=1:size_ridge_coef
    ridge_theta = ridge_theta_matrix(i,1:nbr_feature);
    CVE = cost_function_SingleRoute(ridge_theta,dates_Cross,prices_Cross,lambda_coef(i));
    
    if(CVE < old_CV_Error)
        idx = i;
        old_CV_Error = CVE;
    end
    if(switcher==2)
        CVE_vector(i,1)=CVE;
    end
end
lambda_CV = lambda_coef(idx);
%End of chosing the model


%Displaying some data
TEwR = cost_function_SingleRoute(linear_theta,dates,prices,lambda_CV);
CVEwR = cost_function_SingleRoute(linear_theta,dates_Cross,prices_Cross,lambda_CV);
TestEwR = cost_function_SingleRoute(linear_theta,dates_Test,prices_Test,lambda_CV);

TE = cost_function_SingleRoute(ridge_theta_matrix(idx,1:nbr_feature),dates,prices,lambda_CV);
CVE = cost_function_SingleRoute(ridge_theta_matrix(idx,1:nbr_feature),dates_Cross,prices_Cross,lambda_CV);
TestE = cost_function_SingleRoute(ridge_theta_matrix(idx,1:nbr_feature),dates_Test,prices_Test,lambda_CV);
%End of datas
if(switcher~=1)
display_ridge_theta = ridge_theta_matrix(idx,1:nbr_feature);
display_linear_theta = linear_theta;
display_nbr_feature = nbr_feature;
end
if(switcher==0)
    TE_m_d(j,1)=TEwR;
    CV_m_d(j,1)=CVEwR;
    TestE_m_d(j,1)=TestEwR;
    TE_m_d_r(j,1)=TE;
    CV_m_d_r(j,1)=CVE;
    TestE_m_d_r(j,1)=TestE;
elseif(switcher==1)
    TE_matrix(j,1)=TE;
    CV_matrix(j,1)=CVE;
    TestE_matrix(j,1)=TestE;
    if(CVE<choiceMaker)
        choiceMaker = CVE;
        display_ridge_theta = ridge_theta_matrix(idx,1:nbr_feature);
        display_linear_theta = linear_theta;
        display_nbr_feature = nbr_feature;
    end
end
end

if (switcher==0)
    figure;
    Xaxis = 1:data_decoupe;
    plot(Xaxis,TE_m_d_r);
    hold on;
    plot(Xaxis,CV_m_d_r);
    hold on;
    plot(Xaxis,TestE_m_d_r);
    xlabel('% of data used');
    ylabel('Error');
    legend('Training Error','Cross Validation Error','Test Error');  
    title('Error depending of size of data (ridge regression)');
elseif(switcher==1)

Xaxis = 1:nbr_feature_max;
    figure;
    plot(Xaxis,TE_matrix(:,1));
    hold on;
    plot(Xaxis,CV_matrix(:,1));
    hold on;
    plot(Xaxis,TestE_matrix(:,1));
    xlabel('Complexity');
    ylabel('Error');
    legend('Training Error','Cross Validation Error','Test Error')
    title('Error With Ridge Regression');

elseif(switcher==2)
    figure;
    Xaxis = lower_bound:(upper_bound-lower_bound)/size_ridge_coef:(upper_bound-(upper_bound-lower_bound)/size_ridge_coef);
    plot(Xaxis,CVE_vector);
    xlabel('lambda');
    ylabel('CrossValidation Error');
    legend('Influence of lambda on the cross validation error');
end

end

%preparing the figure
figure;
Limits = [0,1*dateMax/(3600*24),0,1*priceMax];
if(right_ridge_theta~=0)
       display_ridge_theta = right_ridge_theta;
       display_linear_theta = right_linear_theta;
       lambda_CV = right_lambda;
end
    fplot(@(x)hypothesis_SingleRoute(display_ridge_theta,x/(dateMax/(3600*24)))*priceMax, Limits)
    hold on;
    fplot(@(x)hypothesis_SingleRoute(display_linear_theta,x/(dateMax/(3600*24)))*priceMax, Limits)
    hold on;
    
Xaxis = double(cloud(:,1)/(3600*24));
Yaxis = double(cloud(:,2));
plot(Xaxis,Yaxis,'*')
title(['Linear regression route = ' num2str(route) ', with ' num2str(display_nbr_feature) ' features']);
xlabel('Number of days before flight');
ylabel('Price (in €)');
ridge_legend = ['ridge, lambda = ' num2str(lambda_CV) ' ; TrainError : ' num2str(TE) ' ; CVError : ' num2str(CVE) ' ; TestError : ' num2str(TestE)];
regress_legend = ['regress ; TrainError : ' num2str(TEwR) ' ; CVError : ' num2str(CVEwR) ' ; TestError : ' num2str(TestEwR)];
data_legend = ['Data (' num2str(nbr_data_displayed) ')'];
legend(ridge_legend,regress_legend,data_legend);
%End of figure
