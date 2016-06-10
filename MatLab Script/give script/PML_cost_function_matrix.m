function [ z ] = PML_cost_function_matrix(Theta,x,y,lambda)

if(size(Theta)<2)
    error('Wrong arg number for the cost function');
end
       [m,~] =size(x);
if(lambda==-1)
z = (1/m*2) * (sum((PML_hypothesis(Theta,x) - y).^2));
    
else
z=(PML_hypothesis(Theta,x)-y).^2;
end
end

