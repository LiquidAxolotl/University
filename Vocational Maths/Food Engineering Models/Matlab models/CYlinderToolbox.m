%%% cylinder model with pdetoolbox

%create model
CylinderModel=createpde('thermal','transient');

%Create cylinder geometry
%set radius and height
R=0.05;
H=0.15;
gm = multicylinder(R,H);
%assign cylinder to model
CylinderModel.Geometry=gm;
generateMesh(CylinderModel);

%Plot geometry with face labels displayed
figure(1)
pdegplot(CylinderModel,'Facelabels','on')

%Thermal constants (use water)
% Thermal conductivity of food
k=0.6;
% specific heat capacity of food (using water)
cp = 4200;
% Density of food kg/m^3
rho=1090;
thermalProperties(CylinderModel,'ThermalConductivity',k,'SpecificHeat',cp,'MassDensity',rho)

%Boundary conditions. We want conditions on heat flux. Heat flux tends to
%be a function of time in our cases. We will definite heat flux for each
%face of the model using our assumption of surface energy balance (ie
%@surface, conduction = convection) so we need heat flux in z direction and
%heat flux in radial direction. 
% Or, pdetoolbox let's us specific convection on the boundary
h_con=10; %convection coefficient for air with low speed flow
U_air=135; %temperature of oven in degC
thermalBC(CylinderModel,'Face',[1:3],'ConvectionCoefficient',h_con,'AmbientTemperature',U_air)

% Initial conditons
U_t0=10; %initial temperature of food
thermalIC(CylinderModel,U_t0)

%Set time duration for model
t_final=180*60;
%Set vector t
t=0:60:t_final;

Result=solve(CylinderModel,t);

%Plot temperature distribution for final time
figure(2)
pdeplot3D(CylinderModel,'ColorMapData',Result.Temperature(:,end))
title('3D Temp. Dist. for Cylindrical food')
%Plot slice through solution 
%We will the x-y plane through the centre (gives a circle shape) and also
%the z-x (or z-y) plane (gives a rectangle)

%create grid of (x,y,z) points that cut through centre of cylinder. Take
%z=H/2 (half height of cylinder
xx=linspace(-R,R,200);
yy=linspace(-R,R,200);
[XX,YY]=meshgrid(xx,yy);
ZZ=H/2*ones(size(XX));
%interpolate solution onto this grid
TempInterp = interpolateTemperature(Result,XX,YY,ZZ,1:length(t));
%Take final cooking time interpolated solution ie
TempSolSlice = TempInterp(:,end);
%Plot
figure(3) %Slice through direct centre of cylinder, cutting in x-y plane
TempSolSlice=reshape(TempSolSlice,size(ZZ));
SlicePlot=surf(xx,yy,TempSolSlice);
colorbar
SlicePlot.EdgeColor = 'none';
title('Plot of Temp. Dist. of Cylindrical food through centre of food in x-y plane')
xlabel('Distance into food in x direction, m')
ylabel('Distance into food in y direction, m')
view(2)

%Plot a slice in the z-x or z-y plane (equivalent bc symmetry)
%create grid of (x,y,z) points that cut through centre of cylinder from one
%circle face to the other. Take y=0
xx2=linspace(-R,R,200);
zz2=linspace(0,H,200);
[XX2,ZZ2]=meshgrid(xx2,zz2);
YY2=zeros(size(ZZ2));
%interpolate solution onto this grid
TempInterp2 = interpolateTemperature(Result,XX2,YY2,ZZ2,1:length(t));
%Take final cooking time interpolated solution ie
TempSolSlice2 = TempInterp2(:,end);
%Plot
figure(4) %Slice through direct centre of cylinder, cutting in x-z plane
TempSolSlice2=reshape(TempSolSlice2,size(YY2));
SlicePlot2=surf(xx2,zz2,TempSolSlice2);
colorbar
SlicePlot2.EdgeColor = 'none';
title('Plot of Temp. Dist. of Cylindrical food through centre of food in x-z plane')
xlim([-(R+R/3),R+R/3])
xlabel('Distance into food in x direction, m')
ylabel('Height of food z direction, m')
view(2)

%Search for time when cooked
%search by taking the centre row vector from Temperature
%Set target temperature
target_temp=63; %from a source, minimum cooked temperature of pork is 63degC

for i=1:length(t)
    if Result.Temperature(:,i)>=target_temp
        t_cooked_mins=i-1;
        break
    end
end
disp(['Time for food to reach at least ',num2str(target_temp),char(176),'C is: ',num2str(t_cooked_mins),' minutes.']);

%Plot for this minimum time
figure(5)
pdeplot3D(CylinderModel,'ColorMapData',Result.Temperature(:,t_cooked_mins +1))
title(['3D Temp. Dist. for Cylindrical food at time ',num2str(t_cooked_mins),' minutes'])
%Plot slice through solution at min. time
%We will the x-y plane through the centre (gives a circle shape) and also
%the z-x (or z-y) plane (gives a rectangle)

%create grid of (x,y,z) points that cut through centre of cylinder. Take
%z=H/2 (half height of cylinder
xx=linspace(-R,R,200);
yy=linspace(-R,R,200);
[XX,YY]=meshgrid(xx,yy);
ZZ=H/2*ones(size(XX));
%interpolate solution onto this grid
TempInterp = interpolateTemperature(Result,XX,YY,ZZ,1:length(t));
%Take final cooking time interpolated solution ie
TempSolSlice = TempInterp(:,t_cooked_mins +1);
%Plot
figure(6) %Slice through direct centre of cylinder, cutting in x-y plane
TempSolSlice=reshape(TempSolSlice,size(ZZ));
SlicePlot=surf(xx,yy,TempSolSlice);
colorbar
SlicePlot.EdgeColor = 'none';
txt1={'Temp. Dist. of Cylindrical food through centre of food in x-y plane '};
txt2={' at time',num2str(t_cooked_mins),' minutes'};
title([txt1 , txt2])
xlabel('Distance into food in x direction, m')
ylabel('Distance into food in y direction, m')
view(2)

%Plot a slice in the z-x or z-y plane (equivalent bc symmetry)
%create grid of (x,y,z) points that cut through centre of cylinder from one
%circle face to the other. Take y=0
xx2=linspace(-R,R,200);
zz2=linspace(0,H,200);
[XX2,ZZ2]=meshgrid(xx2,zz2);
YY2=zeros(size(ZZ2));
%interpolate solution onto this grid
TempInterp2 = interpolateTemperature(Result,XX2,YY2,ZZ2,1:length(t));
%Take final cooking time interpolated solution ie
TempSolSlice2 = TempInterp2(:,t_cooked_mins +1);
%Plot
figure(7) %Slice through direct centre of cylinder, cutting in x-z plane
TempSolSlice2=reshape(TempSolSlice2,size(YY2));
SlicePlot2=surf(xx2,zz2,TempSolSlice2);
colorbar
SlicePlot2.EdgeColor = 'none';
txt1={'Temp. Dist. of Cylindrical food through centre of food in x-z plane '};
txt2={' at time',num2str(t_cooked_mins),' minutes'};
title([txt1 , txt2])
xlim([-(R+R/3),R+R/3])
xlabel('Distance into food in x direction, m')
ylabel('Height of food z direction, m')
view(2)