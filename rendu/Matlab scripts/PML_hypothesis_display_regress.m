function [ z ] = PML_hypothesis_display_regress( Theta,x0,complexity,flightDuration,route_nbr,month_nbr)

if(size(Theta)<2)
    error('Size of Arguments n the hypothesis function are wrong');
end
route = ones(size([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]));
month = ones(size([0,0,0,0,0,0,0,0,0,0,0,0]));
for i=1:17
   if(i~=route_nbr)
       route(i)=0;
   end
end

for i=1:12
    if(i~=month_nbr)
        month(i)=0;
    end
end
x = PML_getInput(x0,complexity,flightDuration,route,month);
z = PML_hypothesis_regress(Theta,x);
end

