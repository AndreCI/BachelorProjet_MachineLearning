function [ z ] = hypothesis_SingleRoute( Theta,x0)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if(size(Theta)<2)
    error('Size of Arguments n the hypothesis function are wrong');
end

temp=0;
[~,s] = size(Theta);
for i=1:(s)
    temp = temp + double(Theta(i))*double(x0).^(i-1);
end
z= temp;
end

