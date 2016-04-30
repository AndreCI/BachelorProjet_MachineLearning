function [ z ] = hypothesis( Theta,x)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if(size(Theta)<2)
    error('Size of Arguments n the hypothesis function are wrong');
end
[m,n] = size(Theta);
[o,p] = size(x);

if(m-1~=p)
    size_theta = size(Theta)
    size_x = size(x)
    error('Size of parameters and size of features are different');
end
if(n~=1)
    error('Theta matrix is wrong');
end
temp = ones(o,1)*Theta(1,1);

temp =temp+x*Theta(2:m,n);
%[~,s] = size(Theta);
%for i=1:(s)
 %   temp = temp + double(Theta(i))*double(x).^(i-1);
%end


z= temp;
end

