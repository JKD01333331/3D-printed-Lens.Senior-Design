clear all
close all
%% Eqs
% k0*(n/N)*sin(theta)+(n*m*2*pi)/N + pi = k0*sqrt(eps_r(n))*(h-2delt)
% where 
% n = is a slice of constant er
% N = number of slices per cell
% m = multiples of 2pi
% h = height of lens + 2*matching layers
% sin(theta) = angle off zenith
% LHS pi = decribes the phase effect of matching layer (180deg)


%%  CONSTANTS
eps_0 = 8.85*10^(-12); %permittivity
eps_air = 1.0006;
mu_0 = 1; %permeability
c = 299792458;
f = 5.85e9;
lam0 = c/f;
k0 = (2*pi)/lam0;
N = 4;
er = linspace(1,10,1000);
er = er';
m_max = 10;
n = 1:4;
phi = 2*pi;


%% setting up vectors
er_mat = repmat( er, size(n));
n_mat = repmat(n, 1000, 1);

% Set up height struct
h.m = struct('v',{});
for m = 0:m_max
    h.m{m+1} = (((phi*m+(2*pi).*n_mat))./(N.*(k0*sqrt(er_mat))))+(lam0./(2*(er_mat).^(1/4)));
end

% for m = 0:m_max
%     h.m{m+1} = (k0*(lam0/2)*er_mat.^(1/4)+k0*(lam0*n_mat)/4+(2*pi.*n_mat*m)/N + pi)./(k0*sqrt(er_ mat));
% end

%% Plots visualizing h vs er_n at various multiples of m

figure
plot(h.m{2}, er_mat)
legend('n = 1','n = 2','n = 3','n = 4')
xlabel('Total height h = h'' + 2\delta')
ylabel('\bf\epsilon_r')

%% Find ern from given height
% Height is obsevered as valid from plot
%EXAMPLE: THIS GETS er_n FOR 6.5cm, at m = 0
h_t = .035; %Total structure height
tmp = abs(h.m{2}-h_t);
[~,index] = min(tmp);
er_n = er_mat(index);
er_m = sqrt(er_n);

%% Calculate lens layer height
% h_t = total height
% delt = height of the matching layers (2)
% h_p = height of the lens sans matching layer
delt = zeros(1,4);
for ii = n
    delt(ii) = lam0/(4*er_n(ii)^(1/4));
end
h_p = h_t*ones(1,4) - 2.*(delt);

