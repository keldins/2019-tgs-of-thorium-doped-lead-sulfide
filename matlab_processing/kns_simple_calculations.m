% All simple calculations for the paper will go here for ease
% of review and repetition. These will include things like unit 
% conversions, and density calculations.




x1 = 1.5; %cm
x2 = 1; % cm
thickness = 500e-7 % 500 nm = 500e-7 cm

V_tot = x1*x2*thickness; % cm^3



atomwt_Pb = 207.2; % g/mol
atomwt_S = 32.066;
atomwt_Th = 232.038;
rho_Pb = 11.34; % g/cm^3
rho_S = 2.07;
rho_Th = 11.74;

N_A =  6.022140857e23; % atoms/mol



N_S = V_tot*N_A / (atomwt_Pb/rho_Pb + atomwt_S/rho_S);
n_S = V_tot     / (atomwt_Pb/rho_Pb + atomwt_S/rho_S);

N_Pb = N_S; % rock salt stoichiometry
n_Pb = n_S;


m_S = atomwt_S * n_S;
m_Pb = atomwt_Pb * n_Pb;
m_tot = m_Pb + m_S
m_Th = m_tot*150/1e9;



n_Th = m_Th/atomwt_Th;
N_Th = N_A*n_Th;



t_half = 1.9125 * 365 * 24 * 3600; % from yrs to seconds
lambda_Th = log(2)/t_half; % decay const


Act_Th = lambda_Th*N_Th
