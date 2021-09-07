%%% 2D heat transfer for rectangular object with Dirichlet conditions
%Inputs:
% K = diffusitivty
% U_y0 = Temp at top surface of rect
% U_yN = Temp at bottom of rect
% U_t0 = starting internal temp of food

function [U,t,x,y] = Rect2DDirichlet(n, L_x, L_y, U_t0, U_x0, U_xN, U_y0, U_yN, target_temp,K)

%set x and y vectors
x=linspace(0,L_x,n);
y=linspace(0,L_y,n);
h_x=L_x/n;
h_y=L_y/n;
U=U_t0*ones(n); %initial internal temp 

%Set constant surface temperatures (dirichlet)
U(1,1:n)=U_y0; %Top of rect
U(n,1:n)=U_yN; %Bottom
U(1:n,1)=U_x0; %Left
U(1:n,n)=U_xN; %Right

%start time at 0
t=0;
%while loop while internal temp not 'cooked'
while min(min(abs(U)))< target_temp
% for loop for test
%for g =1:900
    t=t+1;
    Uold=U;
    %step through space x
    for i=2:n-1
        %step through space y
        for j=2:n-1
            %finite difference step
            U(i,j)= Uold(i,j) + K*( (Uold(i+1,j) -2*Uold(i,j) + Uold(i-1,j))/h_x^2 + (Uold(i,j+1) -2*Uold(i,j) + Uold(i,j-1))/h_y^2);
        end
       
    end
end




