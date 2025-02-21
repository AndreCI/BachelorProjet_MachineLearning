
clear;

    f = figure('Visible','off');


input_user = 3;
complexity = input_user;
nbr_data_displayed = 300;
filename = 'C:\Users\andre\Documents\Projet\MatLab Script\data\dataCSV_TbF_route_month.txt';
Data = double(csvread(filename, 1, 0));
[m,n] = size(Data);
dates = Data(:,1);
flightDuration = Data(:,3);
routes = Data(:,4:20);
prices = Data(:,2); 
dateMax = max(dates);
priceMax = max(prices);
flightDurationMax = max(flightDuration);

temp = randperm(m);
cloud = Data(temp(1:nbr_data_displayed),:);

 route_nbr =  floor(rand()*17+1);
 month_nbr = floor(rand()*12+1);
 currentFlightDur = 8400000;
  
 Limits = [0,1*dateMax/(3600*24),0,1*priceMax];
 Xaxis = double(cloud(:,1)/(3600*24));
 Yaxis = double(cloud(:,2));
    
while(input_user~='B')
filename = ['C:\Users\andre\Documents\Projet\MatLab Script\result\results_TbF_route_month_ ' num2str(complexity) '.txt'];
Results = double(csvread(filename, 1, 0));
nbr_feature = complexity+1+12+17;

lambdas = Results(:,2);
trainingError = Results(:,3);
crossValidationError = Results(:,4);
testError = Results(:,5);
theta_matrix = Results(:,6:6+nbr_feature);

idx = 0;
CVE = 10;
TrE = 10;
TeE = 10;
TrE_m = 0;
TeE_m = 0;
CVE_m = 0;
for i=1:size(crossValidationError)
    TrE_m = TrE_m + trainingError(i);
    CVE_m = CVE_m + crossValidationError(i);
    TeE_m = TeE_m + testError(i);
    if(trainingError(i)<TrE)
       TrE=trainingError(i);
    end
    if(crossValidationError(i)<CVE)
       idx=i;
       CVE=crossValidationError(i);
    end
    if(testError(i)<TeE)
       TeE=testError(i);
    end
end
TrE_m = TrE_m / i
CVE_m = CVE_m / i
TeE_m = TeE_m / i
TrE_v = 0;
CVE_v = 0;
TeE_v = 0;
for i=1:size(crossValidationError)
    TrE_v = TrE_v + (trainingError(i) - TrE_m)*(trainingError(i) - TrE_m);
    CVE_v = CVE_v + (crossValidationError(i) - CVE_m)*(crossValidationError(i) - CVE_m);
    TeE_v = TeE_v + (testError(i) - TeE_m)*(testError(i) - TeE_m);
end
TrE_v = TrE_v/i
CVE_v = CVE_v/i
TeE_v = TeE_v/i

  input_user = '42';
while(input_user~='B' & input_user~='D' & input_user~='C')
    clf; %clear the figure
    
        popup = uicontrol('Style', 'popup',...
           'String', {'Janvier','Fevrier','Mars','Avril','Mai','Juin'},...
           'Position', [20 20 50 20],...
           'Callback', @setMonth_test);
    
    
f.Visible = 'on';
    plot(Xaxis,Yaxis,'*')
    hold on;
   
    fplot(@(x)hypothesis_display(transpose(theta_matrix(idx,:)),x/(dateMax/(3600*24)),complexity,currentFlightDur/flightDurationMax,route_nbr,month_nbr)*priceMax, Limits)
  %  hold on;
    
title(['Ridge Regression : complexity = ' num2str(complexity) ', flight duration = ' num2str(currentFlightDur) ',route = ' num2str(route_nbr) ', month = ' num2str(month_nbr) ', with ' num2str(nbr_feature) ' features']);
xlabel('Number of days before flight');
ylabel('Price (in �)');
ridge_legend = ['ridge, lambda = ' num2str(lambdas(idx)) ];%' ; TrainError : ' num2str(TE) ' ; CVError : ' num2str(CVE) ' ; TestError : ' num2str(TestE)];
data_legend = ['Data (' num2str(nbr_data_displayed) ')'];
legend(data_legend,ridge_legend);

input_user = upper(input('Q/W to increments/decrements route, S/X for month, D/C for complexity, F/V for flightDuration, B to quit : ', 's'));

    if(input_user=='Q')
        if(route_nbr<17)
           route_nbr = route_nbr+1;
        end
    elseif(input_user=='W')
        if(route_nbr>1)
         route_nbr=route_nbr-1;
        end
    elseif(input_user=='S')
        if(month_nbr<12)
        month_nbr=month_nbr+1;
        end
    elseif(input_user=='X')
        if(month_nbr>1)
       month_nbr=month_nbr-1; 
        end
    elseif(input_user=='D')
        if(complexity<6)
        complexity=complexity +1;
        end
    elseif(input_user=='C')
        if(complexity>3)
        complexity=complexity-1;
        end
    elseif(input_user=='F')
        if(currentFlightDur>0)
        currentFlightDur=currentFlightDur-100000;
        end
    elseif(input_user=='V')
        if(currentFlightDur<flightDurationMax)
        currentFlightDur=currentFlightDur+100000;
        end
    end
end
end



%End of figure