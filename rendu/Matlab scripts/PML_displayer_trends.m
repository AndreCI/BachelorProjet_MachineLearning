function PML_displayer_trends

clear;

    f = figure('Visible','off');
complexity = 4;
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
    
    month_array = {'January','February','March','April','May','June','July', 'August','September','October','November','December' };
  
  display();


function display()
        
        filename = ['C:\Users\andre\Documents\Projet\MatLab Script\result\results_mixture_TbF_route_month_regress_3_ 4.txt'];
Results = double(csvread(filename, 1, 0));
nbr_feature = complexity+1+12+17;

theta_matrix_1 = Results(1,1:nbr_feature);
theta_matrix_2 = Results(2,1:nbr_feature);

            clf; %clear the figure
        
  
f.Visible = 'on';
    plot(Xaxis,Yaxis,'*')
    hold on;
   
    fplot(@(x)PML_hypothesis_display_regress(transpose(theta_matrix_1),x/(dateMax/(3600*24)),complexity,currentFlightDur/flightDurationMax,route_nbr,month_nbr)*priceMax, Limits)
   hold on;
   fplot(@(x)PML_hypothesis_display_regress(transpose(theta_matrix_2),x/(dateMax/(3600*24)),complexity,currentFlightDur/flightDurationMax,route_nbr,month_nbr)*priceMax, Limits)
   hold on;
    
title('Two trends, Multilinear Regression mixture'); 
text(10,380,['complexity : ' num2str(complexity)]);
text(10,360,['duration of flight : ' num2str(HoursFromUnix(currentFlightDur)) 'h' num2str(MinutesFromUnix(currentFlightDur))]);
text(150,360,['month : ' month_array(month_nbr)]);

xlabel('Number of days before flight');
ylabel('Price (in €)');
ridge_legend = ['regression trend 1' ];
ridge_legend2 = ['regression trend 2' ];%' ; TrainError : ' num2str(TE) ' ; CVError : ' num2str(CVE) ' ; TestError : ' num2str(TestE)];
data_legend = ['Data (' num2str(nbr_data_displayed) ')'];
legend(data_legend,ridge_legend,ridge_legend2);
    

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

