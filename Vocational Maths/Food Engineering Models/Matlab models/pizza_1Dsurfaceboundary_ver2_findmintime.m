%%% Pizza heat model for boundary where surface of pizza is same temp. as
%%% air in oven. Using fwd Euler method (might need to change to better
%%% num. method

%Constants
L=0.01; %m, pizza thickness
n=25; %number of nodes
T0 = -18; %deg C, initial temp. of wall (15 degC for roughly cold pizza out of fridge)
T1s = 200; %surface 1 temp
T2s = 200; %surface 2 temp

dx = L/n; %node thickness (step size in space)

alpha = 1.43e-7; %PLACEHOLDER NEED VALUE. thermal diffusitivty (of water or pizza)
%note using alpha for water. Could calculate for pizza using formula and
%online values
t_final = 6*60; %seconds, simulation time. Using results from Sam's calculations/results from pizza instructions
dt = 0.1; %seconds, fixed time step

x = dx/2:dx:L-dx/2; 

T = ones(n,1)*T0;

dTdt = zeros(n,1);

t = 0:dt:t_final;

target_temp = 75;
%Step through time
for j = 1:length(t)
    %step through 1D space 
    for i = 2:n-1 %interior nodes (since they depend on node before AND after)
        dTdt(i)= alpha*(-(T(i)-T(i-1))/dx^2 + (T(i+1)-T(i))/dx^2);
    end
    %end nodes
    dTdt(1) = alpha*(-(T(1)-T1s)/dx^2 + (T(2)-T(1))/dx^2); 
    dTdt(n) = alpha*(-(T(n)-T(n-1))/dx^2 + (T2s-T(n))/dx^2);
    %euler step
    T= T + dTdt*dt;
    if min(min(abs(T)))> target_temp
        break
    end
end

end_time = j*dt;
disp(['Time for temperature distribution to reach target temperature is ',num2str(end_time),' seconds']);
%Plot this temperature dist
figure(1)
plot(x,T)
axis([0 L T0-10 210])
title(['Temperature distribution of pizza at target temperature of ',num2str(target_temp),'\circC'])
xlabel('Distance into pizza, m')
ylabel('Temperature (\circC)')
%hold off
%plot temperature distribution every 30 seconds
%if (j*dt)/30 == floor((j*dt)/30)
    %current_t=num2str(j*dt);
    %label=string(['t=',current_t]);
    %labels(j*dt/30)=label;
    %figure(1)
    %plot(x,T)
    %axis([0 L T0-10 210])
    %title('Temperature distribution of pizza for different times, t, in seconds')
    %xlabel('Distance into pizza, m')
    %ylabel('Temperature (\circC)')
    %legend(labels,'Location','northeastoutside')
    %hold on
