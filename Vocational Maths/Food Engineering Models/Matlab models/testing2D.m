%Testing 2D code

% Set data
n=15;
L_x=0.2;
L_y=0.01;
U_t0=15;
U_x0=200;
U_xN=200;
U_y0=200;
U_yN=200;
target_temp=160;
K=0.143*10^-6;

%FUnction
[U,t,x,y] = Rect2DDirichlet(n, L_x, L_y, U_t0, U_x0, U_xN, U_y0, U_yN, target_temp,K);

%Plot
% temperature gradient
figure(1)
set(pcolor(x,y,U),'EdgeColor','none')
colorbar
%axis([0 L_x+L_x/n 0 L_y+L_y/n])
title('Temperature gradient of 2D shape')
xlabel('x (m), distance into shape in x direction');
ylabel('y (m), distance into shape in y direction');
