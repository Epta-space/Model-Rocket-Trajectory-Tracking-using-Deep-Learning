function [yaw]=calcparam(param,dt,yaw)
r=param(3);
theta0=0;

yawp=(1/cos(theta0))*r;

yaw=yaw+yawp*dt;

end