function [ z ] = PML_hypothesis( Theta,x)
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

temp =x*Theta(2:m,n)+temp;


z= temp;
end

