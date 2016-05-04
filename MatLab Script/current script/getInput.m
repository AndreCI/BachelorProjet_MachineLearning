function [ z ] = getInput( x,complexity,w )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

dbf_double = double(x);
base = ones(size(x));
[m,~]=size(x);
temp = ones(m,complexity);
for i=1:complexity
    temp(:,i) = dbf_double.^i;% = horzcat(temp,dbf_double.^i);
end
if(size(w)~=[0,0])
    temp = horzcat(temp, w);
end
z = temp;%horzcat(dbf_double,x0s2,x0s3,x0s4,x0s5,x0s6);
end

