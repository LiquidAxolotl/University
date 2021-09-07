%%%SphereToolbox heat transfer in sphere with pdetoolbox

%create model
SphereModel=createpde('thermal','transient');

%Create sphere geometry
%set radius
R=0.005;
gm = multisphere(R);
%assign sphere to model
SphereModel.Geometry=gm;
generateMesh(SphereModel);

%Plot geometry with face labels displayed
figure(1)
pdegplot(SphereModel,'Facelabels','on')

%Thermal constants (use water)
% Thermal conductivity of food
k=0.6;
% specific heat capacity of food
cp = 4200;
% Density of food 
rho=997;
thermalProperties(SphereModel,'ThermalConductivity',k,'SpecificHeat',cp,'MassDensity',rho)

%Boundary conditions. We want conditions on heat flux. Heat flux tends to
%be a function of time in our cases.
% pdetoolbox let's us specific convection on the boundary
h_con=10; %convection coefficient for air with low speed flow
U_air=180; %temperature of oven
thermalBC(SphereModel,'Face',[1],'ConvectionCoefficient',h_con,'AmbientTemperature',U_air)

% Initial conditons
U_t0=10; %initial temperature of food
thermalIC(SphereModel,U_t0)

%Set time duration for model
t_final=6*60;
%Set vector t
t=0:120:t_final;

Result=solve(SphereModel,t);

%Plot temperature distribution for final time
figure(2)
pdeplot3D(SphereModel,'ColorMapData',Result.Temperature(:,end))
%The lowest tempreature on the colour bar can tell us the lowest internal
%temperature

%Plot slice through solution (take plane going through centre of sphere)
%create grid of (x,y,z) points that cut through centre of circle (ie x or y
%or z=0. Take z=0
xx=linspace(-R,R,500);
yy=linspace(-R,R,500);
[XX,YY]=meshgrid(xx,yy);
ZZ=zeros(size(XX));
%interpolate solution onto this grid
TempInterp = interpolateTemperature(Result,XX,YY,ZZ,1:length(t));
%Take final cooking time interpolated solution ie
TempSolSlice = TempInterp(:,end);

figure(3)
TempSolSlice=reshape(TempSolSlice,size(ZZ));
SlicePlot=surf(xx,yy,TempSolSlice);
colorbar
SlicePlot.EdgeColor = 'none';
title('Temp. Dist. through spherical food, cutting through centre of sphere')
view(2)

%%% NOTE: to find the time the object reaches internal temp, we can get
%%% data for every second of the cooking and then find which column has min
%%% temperature 75 first. This might be very taxing on the computer