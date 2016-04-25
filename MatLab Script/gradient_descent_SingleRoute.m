function [ ThetaRet ] = gradient_descent_SingleRoute( Theta,x0,y, alpha )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if(size(Theta)<2)
    error('Wrong arg number for the Gradient Descent');
end
[m,~] =size(x0);
temp = Theta;
[~,s] = size(Theta);
for i=1:(s)
    temp(i) = Theta(i) - alpha*sum((hypothesis_SingleRoute(Theta,x0)-y).*(x0.^(i-1)))/(m);
end
    ThetaRet = temp;
end