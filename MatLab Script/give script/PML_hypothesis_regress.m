function [ z ] = PML_hypothesis_regress( Theta,x)
if(size(Theta)<2)
    error('Size of Arguments n the hypothesis function are wrong');
end
[m,n] = size(Theta);
[o,p] = size(x);

if(m~=p)
    size_theta = size(Theta)
    size_x = size(x)
    error('Size of parameters and size of features are different');
end
if(n~=1)
    error('Theta matrix is wrong');
end

temp =x*Theta(1:m,n);

z= temp;
end

