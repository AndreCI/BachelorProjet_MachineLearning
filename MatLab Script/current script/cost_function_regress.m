function [ z ] = cost_function_regress(Theta,x,y)

if(size(Theta)<2)
    error('Wrong arg number for the cost function');
end
      
z=(hypothesis_regress(Theta,x)-y).^2;

%z = (1/m*2) * (sum((hypothesis(Theta,x) - y).^2) + lambda * sum(regu.^2));
end


