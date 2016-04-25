function [ z ] = cost_function( Theta,x0,x1,y )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if(size(Theta)<2)
    error('Wrong arg number for the cost function');
end
[m,~] =size(x0);
z = (1/m)*2 * sum((hypothesis(Theta,x0,x1) - y).^2);

end

