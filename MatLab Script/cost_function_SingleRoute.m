function [ z ] = cost_function_SingleRoute(Theta,x0,y,lambda)

if(size(Theta)<2)
    error('Wrong arg number for the cost function');
end
       [m,~] =size(x0);
if(lambda==-1)
z = (1/m*2) * (sum((hypothesis_SingleRoute(Theta,x0) - y).^2));
    
else
[tM1,tM2] =size(Theta);
regu = Theta(tM1,2:tM2);

z = (1/m*2) * (sum((hypothesis_SingleRoute(Theta,x0) - y).^2) + lambda * sum(regu.^2));
end
end

