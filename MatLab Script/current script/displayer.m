clear;
figure;
input_user = 6;
complexity = input_user;
nbr_data_displayed = 300;
filename = 'C:\Users\Andr�\Documents\GitHub\BachelorProjet_MachineLearning\MatLab Script\data\dataCSV_second.txt';
Data = double(csvread(filename, 1, 0));
[m,n] = size(Data);
dates = Data(:,1);
routes = Data(:,3:19);
prices = Data(:,2); 
dateMax = max(dates);
priceMax = max(prices);

temp = randperm(m);
cloud = Data(temp(1:nbr_data_displayed),:);

 route_nbr =  floor(rand()*17+1);
 month_nbr = floor(rand()*12+1);
  
 Limits = [0,1*dateMax/(3600*24),0,1*priceMax];
 Xaxis = double(cloud(:,1)/(3600*24));
 Yaxis = double(cloud(:,2));
    
while(input_user~='V')
filename = ['C:\Users\Andr�\Documents\GitHub\BachelorProjet_MachineLearning\MatLab Script\result\results_route_month_ ' num2str(complexity) '.txt'];
Results = double(csvread(filename, 1, 0));
nbr_feature = complexity+12+17;

lambdas = Results(:,2);
crossValidationError = Results(:,3);
theta_matrix = Results(:,4:4+nbr_feature);

idx = 0;
CVE = 10;
CVE_m = 0;
for i=1:size(crossValidationError)
    CVE_m = CVE_m + crossValidationError(i);
    if(crossValidationError(i)<CVE)
       idx=i;
       CVE=crossValidationError(i);
    end
end
CVE_m = CVE_m / i
CVE_v = 0;
for i=1:size(crossValidationError)
    CVE_v = CVE_v + (crossValidationError(i) - CVE_m)*(crossValidationError(i) - CVE_m);
end
CVE_v = CVE_v/i

  input_user = '42';
while(input_user~='V' & input_user~='D' & input_user~='C')
    clf;

    plot(Xaxis,Yaxis,'*')
    hold on;
   
    fplot(@(x)hypothesis_display(transpose(theta_matrix(idx,:)),x/(dateMax/(3600*24)),complexity,route_nbr,month_nbr)*priceMax, Limits)
  %  hold on;
    
title(['Ridge Regression : complexity = ' num2str(complexity) ',route = ' num2str(route_nbr) ', month = ' num2str(month_nbr) ', with ' num2str(nbr_feature) ' features']);
xlabel('Number of days before flight');
ylabel('Price (in �)');
ridge_legend = ['ridge, lambda = ' num2str(lambdas(idx)) ];%' ; TrainError : ' num2str(TE) ' ; CVError : ' num2str(CVE) ' ; TestError : ' num2str(TestE)];
data_legend = ['Data (' num2str(nbr_data_displayed) ')'];
legend(data_legend,ridge_legend);

input_user = upper(input('Q/W to increments/decrements route, S/X for month, D/C for complexity, V to quit : ', 's'));

    if(input_user=='Q')
         route_nbr = route_nbr+1;
    elseif(input_user=='W')
        route_nbr=route_nbr-1;
    elseif(input_user=='S')
        month_nbr=month_nbr+1;
    elseif(input_user=='X')
       month_nbr=month_nbr-1; 
    elseif(input_user=='D')
        complexity=complexity +1;
    elseif(input_user=='C')
        complexity=complexity-1;
    end
end

end
%End of figure