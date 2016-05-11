clear;
figure;
Xaxis = 1:8;
for c=1:8

    filename = ['C:\Users\andre\Documents\Projet\MatLab Script\result\results_route_month_ ' num2str(c) '.txt'];
    Results = double(csvread(filename, 1, 0));
    CVE = Results(:,3);
    CVE_max(c) = max(CVE);
    CVE_min(c) = min(CVE);
    crossValidationError(:,c) = CVE;
     CVE_m(c) = 0;
    for i=1:size(CVE)
        CVE_m(c) = CVE_m(c) + CVE(i);
    end
    CVE_m(c) = CVE_m(c)/i;
end
plot(Xaxis,CVE_m);
hold on;
plot(Xaxis,CVE_max);
hold on;
plot(Xaxis,CVE_min);
xlabel('Complexity');
ylabel('Cross Validation Error');
title('Cross Validation Error as a function of complexity');
legend('Average CVE','Maximum CVE','Minimum CVE');
