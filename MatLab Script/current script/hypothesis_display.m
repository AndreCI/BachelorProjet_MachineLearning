function [ z ] = hypothesis_display( Theta,x0,route_nbr)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if(size(Theta)<2)
    error('Size of Arguments n the hypothesis function are wrong');
end
route = ones(size([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]));
for i=1:17
   if(i~=route_nbr)
       route(i)=0;
   end
end
x = getInput(x0,6,route);
z = hypothesis(Theta,x);
end

