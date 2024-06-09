%======================== ESTRAZIONE DEI SEGNALI =========================%
out = sim("Filtri_Dinamici.slx"); % Simulo e salvo i risultati in out

% Tempo di simulazione
time = out.time;  

% Angoli Eulero reali
phi = out.phi.Data;
theta = out.theta.Data;
psi = out.psi.Data;

% Angoli Eulero meccanizzati
phi_mecc = out.phi_mecc.Data;
theta_mecc = out.theta_mecc.Data;
psi_mecc = out.psi_mecc.Data;

% Angoli Eulero ottenuti con meccanizzazione come cinematica esatta
phi_mce = out.phi_mce.Data;
theta_mce = out.theta_mce.Data;
psi_mce = out.psi_mce.Data;

% Angoli Eulero stimati con Osservatore Condizionato
phi_hat_CO = out.phi_hat_CO.Data;
theta_hat_CO = out.theta_hat_CO.Data;
psi_hat_CO = out.psi_hat_CO.Data;

% Angoli Eulero stimati con Mahony standard
phi_hat_Mahony = out.phi_hat_Mahony.Data;
theta_hat_Mahony = out.theta_hat_Mahony.Data;
psi_hat_Mahony = out.psi_hat_Mahony.Data;

% Angoli Eulero stimati con Martin e Salaun
phi_hat_MS = out.phi_hat_MS.Data;
theta_hat_MS = out.theta_hat_MS.Data;
psi_hat_MS = out.psi_hat_MS.Data;

% Matrici di rotazione, vera, stimate e meccanizzata
R_vera = out.R_vera;
R_hat_Mahony = out.R_hat_Mahony;
R_hat_MS = out.R_hat_MS;
R_hat_CO = out.R_hat_CO;
R_hat_mecc = out.R_hat_mecc;

% Determinante della matrice d'assetto stimata
detR_Mahony = out.detR_Mahony.Data;
detR_MS = out.detR_MS.Data;
detR_CO = out.detR_CO.Data;
% Valore di riferimento del bias gyro
bias_gyro = out.bias_gyro.Data;

% Bias gyro stimati con i vari metodi
b_omega_Mahony = out.b_omega_Mahony.Data;
b_omega_MS = out.b_omega_MS.Data;
b_omega_CO = out.b_omega_CO.Data;

% Stato del linearizzato
x = out.err_stima_Eul_lin.Data;

% Posizione e velocità in frame inerziale
pos_inertial = out.pos_inertial.Data;
v_inertial = out.vel_inertial.Data;

% Accelerazione vera in terna body
a_body = out.a_body.Data;

% Accelerazione misurata
a_meas_ = out.a_meas.Data;     time_a = out.a_meas.Time;
a_meas = interp1(time_a, a_meas_, time);

% Campo magnetico misurato
m_meas_ = out.m_meas.Data;     time_m = out.m_meas.Time;
m_meas = interp1(time_m, m_meas_, time);

% Velocità angolare in body vera
omega = out.omega.Data;

% Velocità angolare misurata
omega_meas_ = out.omega_meas.Data;   time_o = out.omega_meas.Time;
omega_meas = interp1(time_o, omega_meas_, time);

%% PLOT RIFERIMENTI E MISURE 
%======================= 1. Angoli Eulero reali deg ======================%
fig1 = figure(1);
sgtitle('Angoli Eulero reali' )
subplot(3,1,1)
plot(time, phi*180/pi, 'r')
grid on; xlabel('time [sec]'); ylabel('\phi [deg]'); legend('Rollio')

subplot(3,1,2)
plot(time, theta*180/pi, 'b')
grid on; xlabel('time [sec]'); ylabel('\vartheta [deg]'); legend('Beccheggio')

subplot(3,1,3)
plot(time, psi*180/pi, 'g')
grid on; xlabel('time [sec]'); ylabel('\psi [deg]'); legend('Imbardata')

fontsize(fig1, scale=2)

%====================== 2. Angoli Eulero reali rad =======================%
fig2 = figure(2);
sgtitle('Angoli Eulero reali')
subplot(3,1,1)
plot(time,phi,'r')
grid on; xlabel('time [sec]'); ylabel('\phi [rad]'); legend('Rollio')

subplot(3,1,2)
plot(time,theta,'b')
grid on; xlabel('time [sec]'); ylabel('\vartheta [rad]'); legend('Beccheggio')

subplot(3,1,3)
plot(time,psi,'g')
grid on; xlabel('time [sec]'); ylabel('\psi [rad]'); legend('Imbardata')

fontsize(fig2, scale=2)

%================== 3. Traiettoria sul piano e spaziale ==================%
fig3 = figure(3);
sgtitle('Traiettoria')
subplot(1,2,1)
plot(pos_inertial(1,1:end),pos_inertial(2,1:end))
hold on;
plot(pos_inertial(1,1),pos_inertial(2,1),'ro')     % posizione iniziale
plot(pos_inertial(1,end),pos_inertial(2,end),'r*') % posizione finale
hold off; grid on; xlabel('X [m]'); ylabel('Y [m]'); title('Planare'); axis equal
legend('traiettoria', 'posizione iniziale', 'posizione finale')
    
subplot(1,2,2)
plot3(pos_inertial(1,1:end),pos_inertial(2,1:end),pos_inertial(3,1:end))
hold on;
plot3(pos_inertial(1,1),pos_inertial(2,1),pos_inertial(3,1),'ro')       % posizione iniziale
plot3(pos_inertial(1,end),pos_inertial(2,end),pos_inertial(3,end),'r*') % posizione finale
hold off; grid on; xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]'); title('Spaziale'); 
legend('traiettoria', 'posizione iniziale', 'posizione finale')

fontsize(fig3, scale=2)

%=================== 4. Posizione nel frame inerziale ====================%
fig4 = figure(4);
sgtitle('Posizioni nel frame inerziale')
subplot(3,1,1)
plot(time,pos_inertial(1,1:end),'r')
grid on; xlabel('time [sec]'); ylabel('x_i [m]');
 
subplot(3,1,2)
plot(time,pos_inertial(2,1:end),'b')
grid on; xlabel('time [sec]'); ylabel('y_i [m]');
 
subplot(3,1,3)
plot(time,pos_inertial(3,1:end),'g')
grid on; xlabel('time [sec]'); ylabel('z_i [m]');

fontsize(fig4, scale=2)

%==================== 5. Velocità nel frame inerziale ====================%
fig5 = figure(5);
sgtitle('Velocità nel frame inerziale')
subplot(3,1,1)
plot(time,v_inertial(:,1),'r')
grid on; xlabel('time [sec]'); ylabel('v_{xi} [m/s]'); 

subplot(3,1,2)
plot(time,v_inertial(:,2),'b')
grid on; xlabel('time [sec]'); ylabel('v_{yi} [m/s]');

subplot(3,1,3)
plot(time,v_inertial(:,3),'g')
grid on; xlabel('time [sec]'); ylabel('v_{zi} [m/s]'); 

fontsize(fig5, scale=2)

%==================== 6. Accelerazione nel frame body ====================%
fig6 = figure(6);
sgtitle('Accelerazione vera nel frame body')
subplot(3,1,1)
plot(time,a_body(1,:),'r')
grid on; xlabel('time [sec]'); ylabel('a_{xb} [m/s^2]'); 

subplot(3,1,2)
plot(time,a_body(2,:),'b')
grid on; xlabel('time [sec]'); ylabel('a_{yb} [m/s^2]');

subplot(3,1,3)
plot(time,a_body(3,:),'g')
grid on; xlabel('time [sec]'); ylabel('a_{zb} [m/s^2]'); 

fontsize(fig6, scale=2)

%=================== 7. Accelerazione in body misurata ===================%
fig7 = figure(7);
sgtitle('Accelerazione misurata nel frame body')
subplot(3,1,1)
plot(time,a_meas(:,1),'r')
grid on; xlabel('time [sec]'); ylabel('a_{meas_x} [m/s^2]'); 

subplot(3,1,2)
plot(time,a_meas(:,2),'b')
grid on; xlabel('time [sec]'); ylabel('a_{meas_y} [m/s^2]');

subplot(3,1,3)
plot(time,a_meas(:,3),'g')
grid on; xlabel('time [sec]'); ylabel('a_{meas_z} [m/s^2]'); 

fontsize(fig7, scale=2)

%================== 8. Campo magnetico misurato in body ==================%
fig8 = figure(8);
sgtitle('Campo magnetico misurato nel frame body')
subplot(3,1,1)
plot(time,m_meas(:,1),'r')
grid on; xlabel('time [sec]'); ylabel('m_{meas_x} [\muT]'); 

subplot(3,1,2)
plot(time,m_meas(:,2),'b')
grid on; xlabel('time [sec]'); ylabel('m_{meas_y} [\muT]');

subplot(3,1,3)
plot(time,m_meas(:,3),'g')
grid on; xlabel('time [sec]'); ylabel('m_{meas_z} [\muT]'); 

fontsize(fig8, scale=2)

%===================== 9. Velocità angolare in body ======================%
fig9 = figure(9);
sgtitle('Velocità angolare in body')
subplot(3,1,1)
plot(time,omega(1,:),'r')
grid on; xlabel('time [sec]'); ylabel('\omega_{1} [rad/s]'); 

subplot(3,1,2)
plot(time,omega(2,:),'b')
grid on; xlabel('time [sec]'); ylabel('\omega_{2} [rad/s]');

subplot(3,1,3)
plot(time,omega(3,:),'g')
grid on; xlabel('time [sec]'); ylabel('\omega_{3} [rad/s]'); 

fontsize(fig9, scale=2)

%================= 10. Velocità angolare in body misurata ================%
fig10 = figure(10);
sgtitle('Velocità angolare in body misurata')
subplot(3,1,1)
plot(time,omega_meas(:,1),'r')
grid on; xlabel('time [sec]'); ylabel('\omega_{meas_1} [rad/s]'); 

subplot(3,1,2)
plot(time,omega_meas(:,2),'b')
grid on; xlabel('time [sec]'); ylabel('\omega_{meas_2} [rad/s]');

subplot(3,1,3)
plot(time,omega_meas(:,3),'g')
grid on; xlabel('time [sec]'); ylabel('\omega_{meas_3} [rad/s]');

fontsize(fig10, scale=2)

%% EFFETTO DELLA SOLA MECCANIZZAZIONE
%==== 11. Confronto angoli Eulero veri vs ottenuti da meccanizzazione 
%                         proposta dall'articolo                      ====%
fig11 = figure(11);
sgtitle('Confronto angoli Eulero veri vs dati da meccanizzazione articolo')
subplot(3,1,1)
plot(time,phi_mecc,'k'); hold on
plot(time,phi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\phi,\phi_{mecc} [rad]'); 
legend('meccanizzazione', 'reale')

subplot(3,1,2)
plot(time,theta_mecc,'b'); hold on
plot(time,theta,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\vartheta,\vartheta_{mecc} [rad]'); 
legend('meccanizzazione', 'reale')

subplot(3,1,3)
plot(time,psi_mecc,'g'); hold on
plot(time,psi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\psi,\psi_{mecc} [rad]'); 
legend('meccanizzazione', 'reale')

fontsize(fig11, scale=2)

%========= 35. Confronto angoli Eulero veri vs ottenuti con meccanizzazione
%                           esatta della cinematica              =========%
fig35 = figure(35);
sgtitle('Confronto angoli Eulero veri vs dati da meccanizzazione esatta')
subplot(3,1,1)
plot(time,phi_mce,'k'); hold on
plot(time,phi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\phi,\phi_{mce} [rad]'); 
legend('mce', 'reale')

subplot(3,1,2)
plot(time,theta_mce,'b'); hold on
plot(time,theta,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\vartheta,\vartheta_{mce} [rad]'); 
legend('mce', 'reale')

subplot(3,1,3)
plot(time,psi_mce,'g'); hold on
plot(time,psi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\psi,\psi_{mce} [rad]'); 
legend('mce', 'reale')

fontsize(fig35, scale=2)

%==== 36. Errore angoli meccanizzati coi due tipi di meccanizzzazione ====%
fig36 = figure(36);
sgtitle('Errore introdotto da integrazione di R')
subplot(3,1,1)
plot(time, phi_mce-phi_mecc,'r')
grid on; xlabel('time [sec]'); ylabel('e_{\phi int} [rad]');

subplot(3,1,2)
plot(time, theta_mce-theta_mecc,'b')
grid on; xlabel('time [sec]'); ylabel('e_{\vartheta int} [rad]');

subplot(3,1,3)
plot(time, psi_mce-psi_mecc,'g')
grid on; xlabel('time [sec]'); ylabel('e_{\psi int} [rad]');

fontsize(fig36, scale=2)

%% PLOT RISULTATI CON FILTRO DI MAHONY
%======= 12. Errore sulla stima del bias del giroscopio con Mahony =======%
fig12 = figure(12);
sgtitle('Errore stima bias gyro con Mahony')
subplot(3,1,1)
plot(time,b_omega_Mahony(1,:)-bias_gyro_x,'r')
grid on; xlabel('time [sec]'); ylabel('e_b_{\omega_1} [rad/s]'); 

subplot(3,1,2)
plot(time,b_omega_Mahony(2,:)-bias_gyro_y,'b')
grid on; xlabel('time [sec]'); ylabel('e_b_{\omega_2} [rad/s]');

subplot(3,1,3)
plot(time,b_omega_Mahony(3,:)-bias_gyro_z,'g')
grid on; xlabel('time [sec]'); ylabel('e_b_{\omega_3} [rad/s]');

fontsize(fig12, scale=2)

%======= 13. Confronto bias giroscopio stimato con Mahony vs reale =======%
fig13 = figure(13);
sgtitle('Confronto bias gyro stimato con Mahony vs reale')
subplot(3,1,1)
plot(time,b_omega_Mahony(1,:),'k'); hold on
plot(time,bias_gyro_x*ones(size(time)),'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('b_{\omega_{Mahony_1}},b_{\omega_1} [rad/s]'); 
legend('Mahony', 'reale')

subplot(3,1,2)
plot(time,b_omega_Mahony(2,:),'b'); hold on
plot(time,bias_gyro_y*ones(size(time)),'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('b_{\omega_{Mahony_2}},b_{\omega_2} [rad/s]'); 
legend('Mahony', 'reale')

subplot(3,1,3)
plot(time,b_omega_Mahony(3,:),'g'); hold on
plot(time,bias_gyro_z*ones(size(time)),'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('b_{\omega_{Mahony_3}},b_{\omega_3} [rad/s]'); 
legend('Mahony', 'reale')

fontsize(fig13, scale=2)

%======== 14. Confronto angoli Eulero veri vs stimati con Mahony =========%
fig14 = figure(14);
sgtitle('Confronto angoli Eulero veri vs stimati con Mahony')
subplot(3,1,1)
plot(time,phi_hat_Mahony,'k'); hold on
plot(time,phi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\phi,\phi_{Mahony} [rad]'); 
legend('Mahony', 'reale')

subplot(3,1,2)
plot(time,theta_hat_Mahony,'b'); hold on
plot(time,theta,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\vartheta,\vartheta_{Mahony} [rad]'); 
legend('Mahony', 'reale')

subplot(3,1,3)
plot(time,psi_hat_Mahony,'g'); hold on
plot(time,psi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\psi,\psi_{Mahony} [rad]'); 
legend('Mahony', 'reale')

fontsize(fig14, scale=2)

%========== 15. Errore sulla stima angoli di Eulero con Mahony ===========%
fig15 = figure(15);
sgtitle('Errore stima angoli Eulero con Mahony')
subplot(3,1,1)
plot(time,phi_hat_Mahony-phi,'r')
grid on; xlabel('time [sec]'); ylabel('e_{\phi_{Mahony}} [rad]'); 

subplot(3,1,2)
plot(time,theta_hat_Mahony-theta,'b')
grid on; xlabel('time [sec]'); ylabel('e_{\vartheta_{Mahony}} [rad]'); 

subplot(3,1,3)
plot(time,psi_hat_Mahony-psi,'g')
grid on; xlabel('time [sec]'); ylabel('e_{\psi_{Mahony}} [rad]'); 

fontsize(fig15, scale=2)

%============ 16. Errore linearizzato sugli angoli di Eulero =============%
fig16 = figure(16);
sgtitle('Errore linearizzato Eulero')
subplot(3,1,1)
plot(time,x(1,:),'r')
grid on; xlabel('time [sec]'); ylabel('x(1) [rad]');

subplot(3,1,2)
plot(time,x(2,:),'b')
grid on; xlabel('time [sec]'); ylabel('x(2) [rad]');

subplot(3,1,3)
plot(time,x(3,:),'g')
grid on; xlabel('time [sec]'); ylabel('x(3) [rad]');

fontsize(fig16, scale=2)

%================= 37. Determinante R stimata con Mahony =================%
fig37 = figure(37);
sgtitle('Scostamento del det(R hat Mahony) dall''unità')
plot(time, detR_Mahony-ones(size(detR_Mahony)))
grid on; xlabel('time [sec]'); ylabel('det(R Mahony) - 1   [adim]')

fontsize(fig37, scale=2)

%% PLOT RISULTATI CON FILTRO DI MARTIN E SALAUN
%=== 17. Errore sulla stima del bias del giroscopio con Martin & Salaun ==%
fig17 = figure(17);
sgtitle('Errore stima bias gyro con MS')
subplot(3,1,1)
plot(time,b_omega_MS(1,:)-bias_gyro_x,'r')
grid on; xlabel('time [sec]'); ylabel('e_b_{\omega_1} [rad/s]'); 

subplot(3,1,2)
plot(time,b_omega_MS(2,:)-bias_gyro_y,'b')
grid on; xlabel('time [sec]'); ylabel('e_b_{\omega_2} [rad/s]');

subplot(3,1,3)
plot(time,b_omega_MS(3,:)-bias_gyro_z,'g')
grid on; xlabel('time [sec]'); ylabel('e_b_{\omega_3} [rad/s]');

fontsize(fig17, scale=2)

%=== 18. Confronto bias giroscopio stimato con Martin&Salaun vs reale ====%
fig18 = figure(18);
sgtitle('Confronto bias gyro stimato con MS vs reale')
subplot(3,1,1)
plot(time,b_omega_MS(1,:),'k'); hold on
plot(time,bias_gyro_x*ones(size(time)),'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('b_{\omega_{MS_1}},b_{\omega_1} [rad/s]'); 
legend('MS', 'reale')

subplot(3,1,2)
plot(time,b_omega_MS(2,:),'b'); hold on
plot(time,bias_gyro_y*ones(size(time)),'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('b_{\omega_{MS_2}},b_{\omega_2} [rad/s]'); 
legend('MS', 'reale')

subplot(3,1,3)
plot(time,b_omega_MS(3,:),'g'); hold on
plot(time,bias_gyro_z*ones(size(time)),'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('b_{\omega_{MS_3}},b_{\omega_3} [rad/s]'); 
legend('MS', 'reale')

fontsize(fig18, scale=2)

%===== 19. Confronto angoli Eulero veri vs stimati con Martin&Salaun =====%
fig19 = figure(19);
sgtitle('Confronto angoli Eulero veri vs stimati con MS')
subplot(3,1,1)
plot(time,phi_hat_MS,'k'); hold on
plot(time,phi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\phi,\phi_{MS} [rad]'); 
legend('MS', 'reale')

subplot(3,1,2)
plot(time,theta_hat_MS,'b'); hold on
plot(time,theta,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\vartheta,\vartheta_{MS} [rad]'); 
legend('MS', 'reale')

subplot(3,1,3)
plot(time,psi_hat_MS,'g'); hold on
plot(time,psi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\psi,\psi_{MS} [rad]'); 
legend('MS', 'reale')

fontsize(fig19, scale=2)

%====== 20. Errore sulla stima angoli di Eulero con Martin & Salaun ======%
fig20 = figure(20);
sgtitle('Errore stima angoli Eulero con MS')
subplot(3,1,1)
plot(time,phi_hat_MS-phi,'r')
grid on; xlabel('time [sec]'); ylabel('e_{\phi_{MS}} [rad]'); 

subplot(3,1,2)
plot(time,theta_hat_MS-theta,'b')
grid on; xlabel('time [sec]'); ylabel('e_{\vartheta_{MS}} [rad]'); 

subplot(3,1,3)
plot(time,psi_hat_MS-psi,'g')
grid on; xlabel('time [sec]'); ylabel('e_{\psi_{MS}} [rad]'); 

fontsize(fig20, scale=2)

%============ 38. Determinante R stimata con Martin e Salaun =============%
fig38 = figure(38);
sgtitle('Scostamento del det(R hat MS) dall''unità')
plot(time, detR_MS-ones(size(detR_MS)))
grid on; xlabel('time [sec]'); ylabel('det(R MS) - 1   [adim]')

fontsize(fig38, scale=2)

%% PLOT RISULTATI CON OSSERVATORE CONDIZIONATO
%=================== 21. Errore sulla stima del bias del giroscopio 
%                        con Osservatore Condizionato ====================%
fig21 = figure(21);
sgtitle('Errore stima bias gyro con CO')
subplot(3,1,1)
plot(time,b_omega_CO(1,:)-bias_gyro_x,'r')
grid on; xlabel('time [sec]'); ylabel('e_b_{\omega_1} [rad/s]'); 

subplot(3,1,2)
plot(time,b_omega_CO(2,:)-bias_gyro_y,'b')
grid on; xlabel('time [sec]'); ylabel('e_b_{\omega_2} [rad/s]');

subplot(3,1,3)
plot(time,b_omega_CO(3,:)-bias_gyro_z,'g')
grid on; xlabel('time [sec]'); ylabel('e_b_{\omega_3} [rad/s]');

fontsize(fig21, scale=2)

%============== 22. Confronto bias giroscopio stimato 
%                   con Osservatore Condizionato vs reale ================%
fig22 = figure(22);
sgtitle('Confronto bias gyro stimato con CO vs reale')
subplot(3,1,1)
plot(time,b_omega_CO(1,:),'k'); hold on
plot(time,bias_gyro_x*ones(size(time)),'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('b_{\omega_{CO_1}},b_{\omega_1} [rad/s]'); 
legend('CO', 'reale')

subplot(3,1,2)
plot(time,b_omega_CO(2,:),'b'); hold on
plot(time,bias_gyro_y*ones(size(time)),'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('b_{\omega_{CO_2}},b_{\omega_2} [rad/s]'); 
legend('CO', 'reale')

subplot(3,1,3)
plot(time,b_omega_CO(3,:),'g'); hold on
plot(time,bias_gyro_z*ones(size(time)),'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('b_{\omega_{CO_3}},b_{\omega_3} [rad/s]'); 
legend('CO', 'reale')

fontsize(fig22, scale=2)

% 23. Confronto angoli Eulero veri vs stimati con Ossrvatore Condizionato %
fig23 = figure(23);
sgtitle('Confronto angoli Eulero veri vs stimati con CO')
subplot(3,1,1)
plot(time,phi_hat_CO,'k'); hold on
plot(time,phi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\phi,\phi_{CO} [rad]'); 
legend('CO', 'reale')

subplot(3,1,2)
plot(time,theta_hat_CO,'b'); hold on
plot(time,theta,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\vartheta,\vartheta_{CO} [rad]'); 
legend('CO', 'reale')

subplot(3,1,3)
plot(time,psi_hat_CO,'g'); hold on
plot(time,psi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\psi,\psi_{CO} [rad]'); 
legend('CO', 'reale')

fontsize(fig23, scale=2)

%= 24. Errore sulla stima angoli di Eulero con  Osservatore Condizionato =%
fig24 = figure(24);
sgtitle('Errore stima angoli Eulero con CO')
subplot(3,1,1)
plot(time,phi_hat_CO-phi,'r')
grid on; xlabel('time [sec]'); ylabel('e_{\phi_{CO}} [rad]'); 

subplot(3,1,2)
plot(time,theta_hat_CO-theta,'b')
grid on; xlabel('time [sec]'); ylabel('e_{\vartheta_{CO}} [rad]'); 

subplot(3,1,3)
plot(time,psi_hat_CO-psi,'g')
grid on; xlabel('time [sec]'); ylabel('e_{\psi_{CO}} [rad]'); 

fontsize(fig24, scale=2)

%======== 39. Determinante R stimata con Osservatore Condizionato ========%
fig39 = figure(39);
sgtitle('Scostamento del det(R hat CO) dall''unità')
plot(time, detR_CO-ones(size(detR_MS)))
grid on; xlabel('time [sec]'); ylabel('det(R CO) - 1   [adim]')

fontsize(fig39, scale=2)
