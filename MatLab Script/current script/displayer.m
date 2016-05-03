
figure;
Limits = [0,1*dateMax/(3600*24),0,1*priceMax];
    route_nbr = 4;
    fplot(@(x)hypothesis_display(ridge_theta_matrix(1:nbr_feature+1,idx),x/(dateMax/(3600*24)),route_nbr)*priceMax, Limits)
    hold on;
    
    
Xaxis = double(cloud(:,1)/(3600*24));
Yaxis = double(cloud(:,2));
plot(Xaxis,Yaxis,'*')
title(['Linear regression route = ' num2str(route) ', with ' num2str(nbr_feature) ' features']);
xlabel('Number of days before flight');
ylabel('Price (in €)');
ridge_legend = ['ridge, lambda = ' num2str(lambda_CV) ];%' ; TrainError : ' num2str(TE) ' ; CVError : ' num2str(CVE) ' ; TestError : ' num2str(TestE)];
data_legend = ['Data (' num2str(nbr_data_displayed) ')'];
legend(ridge_legend,data_legend);
%End of figure