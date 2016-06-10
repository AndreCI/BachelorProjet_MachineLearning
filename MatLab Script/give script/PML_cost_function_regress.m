function [ z ] = PML_cost_function_regress(Theta,x,y)

if(size(Theta)<2)
    error('Wrong arg number for the cost function');
end
      
z=(PML_hypothesis_regress(Theta,x)-y).^2;

end


