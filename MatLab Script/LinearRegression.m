filename = 'dataCSV_second.txt';
Data = (int64(csvread(filename, 1, 0)));
[m,n] = size(Data);
k = randperm(m);

TrainingSet = Data(k(1:floor(m*0.6)),:);
CrossValidationSet = Data(k(floor(m*0.6):floor(m*0.6)+floor(m*0.2)),:);
TestSet = Data(k(floor(m*0.6)+floor(m*0.2):m),:);

routes = TrainingSet(:,3:19);
date_before_flight = TrainingSet(:,1);
prices = TrainingSet(:,2);
date_before_flight = date_before_flight/max(date_before_flight);
prices = prices/max(prices);

ThetaNbr=2 + 17;
Theta = ones(1,ThetaNbr).*rand(1,ThetaNbr);
ThetaOld = ones(size(Theta))*0;

threshold=0.001;
limit = ones(size(Theta))*threshold;

while(abs(ThetaOld-Theta)>limit)
   ThetaOld = Theta;
   Theta = gradient_descent(Theta,date_before_flight,routes,prices,0.01);
  % abs(ThetaOld-Theta)
end
Theta
TrainingError = cost_function(Theta,date_before_flight,routes,prices)
CrossValidationError = cost_function(Theta,CrossValidationSet(:,1),CrossValidationSet(:,3:19),CrossValidationSet(:,2))
TestError = cost_function(Theta,TestSet(:,1),TestSet(:,3:19),TestSet(:,2))


dbf_double = double(date_before_flight);
x0s2 = dbf_double.^2;
x0s3 = dbf_double.^3;
x0s4 = dbf_double.^4;
x0s5 = dbf_double.^5;
x0s6 = dbf_double.^6;
Xtotal = horzcat(dbf_double,x0s2,double(routes));
b = transpose(regress(double(prices),Xtotal))
TrainingError = cost_function(b,date_before_flight,routes,prices)
CrossValidationError = cost_function(b,CrossValidationSet(:,1),CrossValidationSet(:,3:19),CrossValidationSet(:,2))
TestError = cost_function(b,TestSet(:,1),TestSet(:,3:19),TestSet(:,2))



