filename = 'dataCSV_displayer.txt';

seed = input('rentrez une valeur entre 0 et 500 000 : ');
Data =csvread(filename, 1, 0);
Value = int64(Data(seed,3));
Route = Data(seed,1);
Mask = int64(Data);

RouteMask = Mask(:,1).*int64(Mask(:,3)==Value);
DataTime = Mask(:,2).*int64((Mask(:,3)==Value).*(RouteMask==Route));
FlightTime = Mask(:,3).*int64((Mask(:,3)==Value).*(RouteMask==Route));
Xaxis = FlightTime - DataTime;
Yaxis = Mask(:,4).*int64((Mask(:,3)==Value).*(RouteMask==Route));

Xaxis(Xaxis==0) = [];
Yaxis(Yaxis==0) = [];
start = Xaxis(1);
endA = Xaxis(length(Xaxis));
Xa = datetime(Xaxis, 'ConvertFrom', 'posixtime' );
xx = datenum(Xa);
plot(xx, Yaxis, '*')
datetick('x')
V=axis;
axis([V(1) V(2) 0 (V(4)+10)]);
dt = datetime(Value, 'ConvertFrom', 'posixtime' );
title(['Route : ', num2str(Route), ', date : ', datestr(dt)]);