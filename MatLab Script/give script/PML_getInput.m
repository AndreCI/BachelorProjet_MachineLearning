function [ z ] = PML_getInput( x,complexity,flightDuration,route,month )
%take some inputs in argument and does the horzcat rightfully to give back
%an xTotal

dbf_double = double(x);
[m,~]=size(x);
temp = ones(m,complexity);
for i=1:complexity
    temp(:,i) = dbf_double.^i;
end
temp = horzcat(temp,flightDuration);
if(size(route)~=[0,0])
    temp = horzcat(temp, route);
end
if(size(month)~=[0,0])
    temp = horzcat(temp, month);
end
z = temp;
end

