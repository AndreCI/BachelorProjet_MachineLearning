function [ z ] = hypothesis( Theta,x0,x1 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if(size(Theta)<2)
    error('Size of Arguments n the hypothesis function are wrong');
end

temp=0;
[~,s] = size(Theta);
[~,r] = size(x1);
for i=1:(s-r)
    temp = temp + Theta(i)*x0.^(i-1);
end
for i=1:r
    temp = temp + Theta(i+s-r)*x1(:,i);
end
z= temp;
end

