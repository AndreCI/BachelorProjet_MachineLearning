clear;
a=4;
writerFile = fopen(['C:\Users\Public\matlab_output\results_mixture_TbF_route_month_regress_3_ ' num2str(a) '.txt'],'w');
nbr_feature=a+1+12+17;
fprintf(writerFile,'Idx,lambda,TrainingError, CrossValidationError, TestError, ThetaParas (%d)...\n',nbr_feature);
filename = 'C:\Users\andre\Documents\Projet\MatLab Script\data\csv_route_month_TBF.txt';
Data = double(csvread(filename, 1, 0));
[m,~] = size(Data);
random_perm = randperm(m);
TestSet = Data(random_perm(1:floor(m*2/10)),:);
[m,n] =size(Data);

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
Xtotal = PML_getInput(dates,a,flightDuration,routes, month);
TrendMask1 = TrendMask;




for j=1:100
    TrendMask1 = TrendMask;
    for p=1:largeur-1
      TrendMask1 = horzcat(TrendMask1,TrendMask);
    end
    TrendMask = TrendMask==0;
    
    TrendMask2 = TrendMask;
    for p=1:largeur-1
       TrendMask2 = horzcat(TrendMask2,TrendMask);
    end
%defining trend 1 & 2
TrainingSet_1 = TrainingSet.*TrendMask1;
TrainingSet_1( ~any(TrainingSet_1,2), : ) = [];
TrainingSet_2 = TrainingSet.*TrendMask2;
TrainingSet_2( ~any(TrainingSet_2,2), : ) = [];

dates_1 = TrainingSet_1(:,1);
prices_1 = TrainingSet_1(:,2);
flightDuration_1 = TrainingSet_1(:,3);
month_1 =  TrainingSet_1(:,22:33);
keep_r_1 = TrainingSet_1(:,4:20);
routes_1 = TrainingSet_1(:,4:20)*0;

dates_2 = TrainingSet_2(:,1);
prices_2 = TrainingSet_2(:,2);
flightDuration_2 = TrainingSet_2(:,3);
month_2 =  TrainingSet_2(:,22:33);
keep_r_2 = TrainingSet_2(:,4:20);
routes_2 = TrainingSet_2(:,4:20)*0;

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
Xtotal_1 = PML_getInput_regress(dates_1,a,flightDuration_1,routes_1, month_1);
Xtotal_2 = PML_getInput_regress(dates_2,a,flightDuration_2,routes_2, month_2);
Xtotal_Cross = PML_getInput_regress(dates_Cross,a,flightDuration_Cross,routes_Cross,month_Cross);
Xtotal_Test = PML_getInput_regress(dates_Test,a,flightDuration_Test,routes_Test, month_Test);
%end parameters


%ridge regression
reg_1 = regress(double(prices_1),Xtotal_1);
reg_2 = regress(double(prices_2),Xtotal_2);

TrendError(:,1) = PML_cost_function_regress(reg_1,Xtotal,prices);

TrendError(:,2) = PML_cost_function_regress(reg_2,Xtotal,prices);
%End of chosing the model
%Choosing trend
TrendMask = TrendError(:,1)<TrendError(:,2);
end;

[~,largeur] = size(routes);
TrendMaskFinal=TrendMask;
for p=1:largeur-1
   TrendMaskFinal = horzcat(TrendMaskFinal,TrendMask); 
end
c1 = routes.*TrendMaskFinal;
TrendMask = TrendMask==0;
TrendMaskFinal=TrendMask;
for p=1:largeur-1
   TrendMaskFinal = horzcat(TrendMaskFinal,TrendMask); 
end
c2 = routes.*TrendMaskFinal;

c1( ~any(c1,2), : ) = [];
c2( ~any(c2,2), : ) = [];
cb1 = sum(c1)
cb2 = sum(c2)
clusters = ones(1,largeur)*10;
for p=1:largeur
    if(cb1(p)>cb2(p))
        clusters(p)=1;
    elseif(cb1(p)<cb2(p))
        clusters(p)=0;
    else
        clusters(p)=-1;
    end
end
clusters


for p=1:nbr_feature-1
   fprintf(writerFile,'%f,',reg_1(p)); 
end
fprintf(writerFile,'%f\n',reg_1(nbr_feature));

for p=1:nbr_feature-1
   fprintf(writerFile,'%f,',reg_2(p)); 
end
fprintf(writerFile,'%f\n',reg_2(nbr_feature));


fclose(writerFile);

