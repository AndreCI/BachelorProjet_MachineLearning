function [ z ] = getInput( x,complexity,routes )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

dbf_double = double(x);
base = ones(size(x));
x0s2 = dbf_double.^2;
x0s3 = dbf_double.^3;
x0s4 = dbf_double.^4;
x0s5 = dbf_double.^5;
x0s6 = dbf_double.^6;
[m,~]=size(x);
temp = ones(m,complexity);
for i=1:complexity
    temp(:,i) = dbf_double.^i;% = horzcat(temp,dbf_double.^i);
end
if(size(routes)~=[0,0])
    temp = horzcat(temp, routes);
end

z = temp;%horzcat(dbf_double,x0s2,x0s3,x0s4,x0s5,x0s6);
end

