clear;
figure;
Xaxis = 1:8;
for c=1:8

    filename = ['C:\Users\André\Documents\GitHub\BachelorProjet_MachineLearning\MatLab Script\result\results_route_month_ ' num2str(c) '.txt'];
    Results = double(csvread(filename, 1, 0));
    CVE = Results(:,3);
    crossValidationError(:,c) = CVE;
     CVE_m(c) = 0;
    for i=1:size(CVE)
        CVE_m(c) = CVE_m(c) + CVE(i);
    end
    CVE_m(c) = CVE_m(c)/i;
end
for i=1:size(CVE)
   plot(Xaxis, crossValidationError(i,:));
   hold on;
end
plot(Xaxis,CVE_m);