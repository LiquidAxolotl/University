%%% 1D heat transfer with Neumann boundary conditions
% For case of food in oven, we assume air in oven is steady and constant
% and has low speed flow. We can use convective heat transfer coefficient
% of h_con=10 for this

% Set data
% Number of nodes, n
N=20;
% Food thickness in metres
L=0.01;
%node thickness
h=L/N;
%convective heat transfer coefficient of water (assume low speed flow)
h_con=10;
%thermal conductivity (use water)
k=0.6;
%density (of water) kg/m^3
rho=997;
%specific heat capacity (of water) J/kg
cp = 4200;
%thermal diffusivity;
alpha = k/(rho*cp);

%Oven air temperature, degC
U_air=200; 
%Initial uniform temp of food
U_t0 = 15;

% Set initial food temperature (at time=0)
U = 15*ones(N+1,1);

%Set end time
t_final = 30*60; %seconds
% Set size of time step (dt=1 is time step of 1s)
dt=0.1;
%vector t
t=0:dt:t_final;
%Vector x
x=linspace(0,L,N+1);

% Step through time
for j=1:length(t)
    Uold=U;
    %Step through space
    %Nodes at surface boundary. We use the value for heat flux at time t
    %here. ie node 1 and node N+1
    U(1) = Uold(1) + (dt*alpha/(h^2))*(2*Uold(2) - 2*Uold(1) + (2*h/k)*h_con*(U_air - Uold(1)));
    U(N+1) = Uold(N+1) + (dt*alpha/(h^2))*(2*Uold(N) - 2*Uold(N+1) - (2*h/k)*(h_con*(Uold(N+1)-U_air)));
    %Interior nodes
    for i=2:N
        U(i)=Uold(i) + (dt*alpha/(h^2))*(Uold(i+1) - 2*Uold(i) + Uold(i-1));
    end
    
end

figure(1)
plot(x,U)
axis([0 L 0 210])
xlabel('Distance into food, m')
ylabel('Temperature (\circC)')
pause(0.01)