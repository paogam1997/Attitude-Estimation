% Consideriamo brevi traiettorie rispetto alla superficie della Terra, 
% andiamo a definire soltanto 2 frame: l'inerziale con l'origine al
% centro  del workspace (funge da navigation frame) ed il body fisso 
% sul veicolo

%%  PARAMETRI GENERALI

time_max = 5*60;  % [s] tempo di simulazione
dt = 0.01;        % [s] tempo campionamento dei sensori
g = 9.81;         % [m/s^2] modulo della accelerazione di gravità
e3 = [0;0;1];     % inertial frame: convenzione NED
rumori_bias = 1;  % indice per attivare (1) o disattivare (0) i rumori e bias dei sensori

%% PARAMETRI CINEMATICA VTOL

%========================= C.I. angoli di Eulero =========================%
phi_0 = 15*pi/180;     % [rad] C.I. per rollio
theta_0 = 10*pi/180;   % [rad] C.I. per beccheggio
psi_0 = pi/4;          % [rad] C.I. per imbardata
% questi vengono sostituiti nella formula di R per trovare la R che definisca le C.I.
R_0_esatta = [cos(theta_0)*cos(psi_0),  -cos(phi_0)*sin(psi_0) + cos(psi_0)*sin(phi_0)*sin(theta_0),   sin(phi_0)*sin(psi_0) + cos(psi_0)*cos(phi_0)*sin(theta_0); 
              cos(theta_0)*sin(psi_0),   cos(phi_0)*cos(psi_0) + sin(psi_0)*sin(phi_0)*sin(theta_0),  -sin(phi_0)*cos(psi_0) + sin(psi_0)*cos(phi_0)*sin(theta_0);
              -sin(theta_0),             sin(phi_0)*cos(theta_0),                                      cos(phi_0)*cos(theta_0)];

%================ Parametri per imposizione angoli Eulero ================%
    % Ampiezze scritte come [deg]pi/180 e frequenze come 2pi/[periodo,s]
Phi1 = 40*pi/180;     % [rad] ampiezza oscillazione rollio a BF 
Phi2 = 20*pi/180;     % [rad] ampiezza oscillazione rollio a MF
Phi3 = 2*pi/180;      % [rad] ampiezza oscillazione rollio a AF
w_phi1 = 2*pi/27;     % [rad/s] frequenza oscillazione rollio a BF 
w_phi2 = 2*pi/18;     % [rad/s] frequenza oscillazione rollio a MF
w_phi3 = 2*pi/3;      % [rad/s] frequenza oscillazione rollio a AF

Theta1 = 50*pi/180;   % [rad] ampiezza oscillazione beccheggio a BF
Theta2 = 12*pi/180;   % [rad] ampiezza oscillazione beccheggio a MF
Theta3 = 3*pi/180;    % [rad] ampiezza oscillazione beccheggio a AF
w_theta1 = 2*pi/23;   % [rad/s] frequenza oscillazione beccheggio a BF
w_theta2 = 2*pi/12;   % [rad/s] frequenza oscillazione beccheggio a MF
w_theta3 = 2*pi/3.5;  % [rad/s] frequenza oscillazione beccheggio a AF

Psi1 = 160*pi/180;    % [rad] ampiezza oscillazione imbardata a BF
Psi2 = 35*pi/180;     % [rad] ampiezza oscillazione imbardata a MF
Psi3 = 5*pi/180;      % [rad] ampiezza oscillazione imbardata a AF
w_psi1 = 2*pi/30;     % [rad/s] frequenza oscillazione imbardata a BF
w_psi2 = 2*pi/15;     % [rad/s] frequenza oscillazione imbardata a MF
w_psi3 = 2*pi/4;      % [rad/s] frequenza oscillazione imbardata a AF

%========= Parametri per definizione velocità angolare (w_i|b)^b==========%
    % Ampiezze subito in rad/s e frequenze come 2pi/[periodo,s]
Omega11 = 0.075;      % [rad/s] ampiezza componente BF di omega(1)
Omega12 = 0.045;      % [rad/s] ampiezza componente MF di omega(1)
Omega13 = 0.02;       % [rad/s] ampiezza componente AF di omega(1)
w_11 = 2*pi/30;       % [rad/s] frequenza componente BF di omega(1)
w_12 = 2*pi/12;       % [rad/s] frequenza componente MF di omega(1)
w_13 = 2*pi/4;        % [rad/s] frequenza componente AF di omega(1)

Omega21 = 0.085;      % [rad/s] ampiezza componente BF di omega(2)
Omega22 = -0.03;      % [rad/s] ampiezza componente MF di omega(2)
Omega23 = 0.015;      % [rad/s] ampiezza componente AF di omega(2)
w_21 = 2*pi/25;       % [rad/s] frequenza componente BF di omega(2)
w_22 = 2*pi/18;       % [rad/s] frequenza componente MF di omega(2)
w_23 = 2*pi/3;        % [rad/s] frequenza componente AF di omega(2)

Omega31 = 0.1;        % [rad/s] ampiezza componente BF di omega(3)
Omega32 = 0.036;      % [rad/s] ampiezza componente MF di omega(3)
Omega33 = -0.025;     % [rad/s] ampiezza componente AF di omega(3)
w_31 = 2*pi/20;       % [rad/s] frequenza componente BF di omega(3)
w_32 = 2*pi/10;       % [rad/s] frequenza componente MF di omega(3)
w_33 = 2*pi/2;        % [rad/s] frequenza componente AF di omega(3)

%======================= C.I. posizione in frame I =======================%
x_0 = 0;                     % [m]
y_0 = 0;                     % [m]
z_0 = 10;                    % [m]
pos_0 = [x_0; y_0; z_0];     % [m] vettore posizione iniziale del VTOL

%======================= C.I. velocità in frame I ========================%
dx_0 = 0;                    % [m/s]  
dy_0 = 0;                    % [m/s]  
dz_0 = 0;                    % [m/s]  
vel_0 = [dx_0; dy_0; dz_0];  % [m/s] vettore velocità iniziale del VTOL

%% PARAMETRI SENSORI (IMU MEMS ADIS 16500, magnetometro HMR3300-Honeywell)

%============================= Accelerometro =============================%
    % bias dell'accelerometro
bias_a_x = 1.25*10^(-2);      % [m/s^2]
bias_a_y = 1.25*10^(-2);      % [m/s^2]
bias_a_z = 1.34*10^(-2);      % [m/s^2]
bias_accel = [bias_a_x; bias_a_y; bias_a_z];
    % deviazioni standard white noise dell'accelerometro
dev_std_a_x = 0.0248;         % [m/s^2]
dev_std_a_y = 0.0248;         % [m/s^2]
dev_std_a_z = 0.0203;         % [m/s^2]

%============================== Giroscopio ===============================%
    % bias del giroscopio 
bias_gyro_x = 2.182*10^(-3);           % [rad/s] 7.5 deg/min
bias_gyro_y = 2.356*10^(-3);           % [rad/s] 8.1 deg/min
bias_gyro_z = 1.425*10^(-3);           % [rad/s] 4.9 deg/min
bias_gyro = [bias_gyro_x; bias_gyro_y; bias_gyro_z];
    % deviazioni standard white noise del giroscopio
dev_std_gyro_x = 2.653*10^(-3);        % [rad/s]
dev_std_gyro_y = 2.653*10^(-3);        % [rad/s]
dev_std_gyro_z = 3.159*10^(-3);        % [rad/s]

%============================== Magnetometro =============================%
    % Definizione del campo magnetico terrestre in terna Inerziale
m_i_x = 1;                    % [μT]
m_i_z = 0.1;                  % [μT]
m_I = [m_i_x; 0; m_i_z];
    % somma dei bias e campi magnetici esterni (disturbi ambientali)
bias_magn_x = 0.1;            % [μT]
bias_magn_y = 0.12;           % [μT]
bias_magn_z = 0.085;          % [μT]
bias_magn = [bias_magn_x; bias_magn_y; bias_magn_z];
    % deviazioni standard white noise del magnetometro
dev_std_magn_x = 0.01;        % [μT]
dev_std_magn_y = 0.015;       % [μT]
dev_std_magn_z = 0.0175;      % [μT]

%% PARAMETRI PER FILTRI DINAMICI

%======================== Parametri Filtro Mahony ========================%
R0 = eye(3);                          % [adim] C.I. per la matrice di rotazione C_ib
b_omega_hat0 = [0;0;0];               % [rad/s] C.I. per il bias gyro
k1 = 1;                               % [adim] guadagno costante positivo, peso accelerometro nell'innovazione σ_R
k2 = 0.2;                             % [adim] guadagno costante positivo, peso magnetometro nell' innovazione σ_R
k_B = 1/32;                           % [adim] guadagno costante positivo per innovazione del bias σ_b
x_Mahony0 = [phi_0; theta_0; psi_0];  % [rad] C.I. su errori di stima degli angoli di Eulero per dinamica linearizzata

%==================== Parametri Filtro Martin e Salaun ===================%
k1_MS = 1;          % [adim] guadagno costante positivo, peso accelerometro nell'innovazione σ_R
k2_MS = 0.2;        % [adim] guadagno costante positivo, peso magnetometro nell' innovazione σ_R
k_B_MS = 1/32;      % [adim] guadagno costante positivo per innovazione del bias σ_b

%========== Parametri Osservatore Condizionato ==========%
    %  Gain per convergenza stime su angoli Eulero
k1_CO = 1;          % [adim >0] "Proportional Gain", peso accelerometro nell'innovazione σ_R
k2_CO = 0.2;        % [adim >0] "Proportional Gain", peso nuova misura inerziale nell'innovazione σ_R
    % Gain per convergenza stime su gyro bias
k3_CO = k1_CO/32;   % [adim >k4_CO] "Integral Gain", analogo di k1_CO ma per gyro bias σ_b
k4_CO = k2_CO/32;   % [adim >0] "Integral Gain", peso nuova misura inerziale per gyro bias σ_b
kB_CO = 16;         % [1/s] velocità convergenza del bias
Delta = 0.03;       % [rad/s] limite in norma del bias del giroscopio al tempo t=0

%% PARAMETRI PER STIME ALGEBRICHE

%======================= Misura Inerziale Fittizia =======================%
% Definizione di una misura inerziale fittizia (es. direzione rispetto ad
% una stella fissa) supposta nota nel frame inerziale ed ortogonale a
% gravità e campo magnetico. Va a sostituire il giroscopio per i filtri
% statici.
    % Valore noto in terna inerziale
csi_y_i = 1;                % [adim]
csi_i = [0; csi_y_i; 0]; 
    % bias del sensore ξ
bias_csi_x = 0.01;          % [adim]
bias_csi_y = 0.02;          % [adim]
bias_csi_z = 0.05;          % [adim]
bias_csi = [bias_csi_x; bias_csi_y; bias_csi_z];
    % deviazioni standard white noise del sensore ξ
dev_std_csi_x = 0.01;       % [adim]
dev_std_csi_y = 0.007;      % [adim]
dev_std_csi_z = 0.005;      % [adim]

%================== Parametri Algoritmo Ottimo di Wahba ==================%
    % pesi positivi arbitrari per misura dell'accel., ξ e magn.
    % autore propone l'inversa della varianza della misura,
    % ma avendole messe diverse per ogni componente ne uso il valore medio.
var_accel_mean = (dev_std_a_x^2 + dev_std_a_y^2 + dev_std_a_z^2)/3;
var_csi_mean = (dev_std_csi_x^2 + dev_std_csi_y^2 + dev_std_csi_z^2)/3;
var_magn_mean = (dev_std_magn_x^2 + dev_std_magn_y^2 + dev_std_magn_z^2)/3;

% versione dei gain proposta dall'articolo
% k_accel = var_accel_mean^-1;
% k_csi = var_csi_mean^-1;
% k_magn = var_magn_mean^-1;
% versione mia
k_accel = 1/3; 
k_csi = 1/3;
k_magn = 1/3;

flag = 1;  % flag per fare la ricerca max autovalore reale in Davenport
index = 0; % inizializzazione indice posizione lambda_max in Davenport

%============  Parametri filtro passa basso per stime statiche ===========% 
Ttriad = 1/30;   %[s] costante di tempo filro passa basso 