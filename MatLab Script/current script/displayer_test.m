function displayer_test

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

  display();

function setMonth_test(source,callbackdata) 
        month_nbr = source.Value;
        display();
end
function setRoute_test(source,callbackdata) 
        route_nbr = source.Value;
        display();
end
function setFlightDuration_test(source,callbackdata) 
        currentFlightDur = floor(source.Value);
        display();
end

    function display()
            clf; %clear the figure
        
    route_array = {'BCN BUD','BUD BCN','CRL OTP','MLH SKP','MMX SKP','OTP CRL','SKP MLH','SKP MMX','BGY OTP','BUD VKO','CRL WAW','LTN OTP','LTN PRG','OTP BGY','OTP LTN','PRG LTN','VKO BUD'};
    month_array = {'January','February','March','April','May','June','July', 'August','September','October','November','December' };
         
            uicontrol('Style', 'popup',...
           'String', month_array,...
            'Value',(month_nbr),...
            'Position', [20 20 80 20],...
           'Callback', @setMonth_test);
       
            uicontrol('Style', 'popup',...
           'String', route_array,...
           'Value',(route_nbr),...
           'Position', [20 20 80 50],...
           'Callback', @setRoute_test);
       
        uicontrol('Style', 'slider',...
        'Min',1,'Max',flightDurationMax,'Value',currentFlightDur,...
        'Position', [20 80 120 20],...
        'Callback', @setFlightDuration_test); 
            
    
f.Visible = 'on';
    plot(Xaxis,Yaxis,'*')
    hold on;
   
    fplot(@(x)hypothesis_display(transpose(theta_matrix(idx,:)),x/(dateMax/(3600*24)),complexity,currentFlightDur/flightDurationMax,route_nbr,month_nbr)*priceMax, Limits)
  %  hold on;
    
title('Ridge Regression'); 
text(10,380,['complexity : ' num2str(complexity)]);
text(10,360,['duration of flight : ' num2str(HoursFromUnix(currentFlightDur)) 'h' num2str(MinutesFromUnix(currentFlightDur))]);
text(60,380,['route : ' route_array(route_nbr)]);
text(60,360,['month : ' month_array(month_nbr)]);

xlabel('Number of days before flight');
ylabel('Price (in €)');
ridge_legend = ['ridge, lambda = ' num2str(lambdas(idx)) ];%' ; TrainError : ' num2str(TE) ' ; CVError : ' num2str(CVE) ' ; TestError : ' num2str(TestE)];
data_legend = ['Data (' num2str(nbr_data_displayed) ')'];
legend(data_legend,ridge_legend);
    

    end

    function [z] = HoursFromUnix(time)
        temp = time/1000;
        temp = temp/60;
        temp = temp/60;
        z = floor(temp);
    end

    function [z] = MinutesFromUnix(time)
        temp = time/1000;
        temp = temp/60;
        z = temp - HoursFromUnix(time)*60;
    end    
    
end

