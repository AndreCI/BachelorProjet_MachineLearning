function [ ThetaRet ] = gradient_descent( Theta,x0,x1,y, alpha )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if(size(Theta)<2)
    error('Wrong arg number for the Gradient Descent');
end
[m,~] =size(x0);
temp = Theta;
[~,s] = size(Theta);
[~,r] = size(x1);
for i=1:(s-r)
    temp(i) = Theta(i) - alpha*sum((hypothesis(Theta,x0,x1)-y).*(x0.^(i-1)))/(m+r);
end
for i=1:r
   temp(i+s-r) = Theta(i+s-r) - alpha*sum((hypothesis(Theta,x0,x1)-y).*x1(:,i))/(m+r); 
end
    ThetaRet = temp;
end

