P% compression with nothing in tank

% stroke length in mm
sl = 50;
% piston diameter in mm
pd = 20;
% volume of stroke in m^3
vs = sl/1000*((pd/1000)^2*pi/4);

% volume of tubing up until first check valve
% diameter of tubing in in. area of tubing in m^3
dt = .25;
at = (dt*.0254)^2*pi/4;
% length of tubing up until check valve enter in in.
lc = 3;
lc = lc*.0254;
% volume of tubing up until first check valve
vc = lc*at;

% length of tubing from firs check valve to tank enter in in.
lt = 16;
lt = lt*.0254;
% volume of tubing from first check valve to tank
vt = lt*at;

% diameter of tank enter in in.
d = 2.5;
% area of tank
aT = (d*.0254)^2*pi/4;
% length of tank enter in in.
lT = 10;
lT = lT*.0254;
% volume of tank 
vT = lT*aT;


% if pressure is less than that of the tank
Vinitial = vs + vc;
Vfinal = vc;

% if pressure is more than that of the tank 
vinitial = vs + vc + vt + vT;
vfinal = vc + vt + vT;

Pinitial = 101325;

% initiate array of all pressure readings 
P(1) = Pinitial;

% just say we look at 200 strokes with no usage
N = 400;
W(1) = 0;
for j=2:N
    
    % we need to check if the pressure in the piston is more or less than
    % in the tank, if it's less the volume will only be up until the first
    % check valve
    i = 1;
    p1(i) = Pinitial;
    V = linspace(Vinitial,Vfinal,1001);
    M = length(V);
    while p1(i) < P(j-1)
        p1(i+1) = p1(i)*V(i)/V(i+1);  
        i = i+1;
    end
    P(j) = p1(i);
    % work calculation of first process
    W1 = -Pinitial*V(1)*log(V(i)/V(1)) - Pinitial*(V(1)-V(i));
    W2 = 0;
    % check if during that initial stroke the piston hits the end of the
    % cylinder, if so we can not compress any farther, regardless of
    % difference between pressure in cylinder and pressure in tank
    if i < M
        % find the volume taken up by first process
        v = vinitial-(Vinitial - V(i));
        
        % calculate work input on the final step of process
        W2 = -P(j)*v*log(vfinal/v) - P(j)*(v-vfinal);
        P(j) = P(j)*v/vfinal;
    end
    W(j) = W1+W2;
end
      

% convert pressures to gauge and psi
P = (P - 101325)./6894.76;
F = P*((pd/(25.4))^2*pi/4);

