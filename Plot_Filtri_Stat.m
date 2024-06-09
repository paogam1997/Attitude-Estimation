%======================== ESTRAZIONE DEI SEGNALI =========================%
out = sim("Filtri_Statici.slx"); % Simulo e salvo i risultati in out

% Tempo di simulazione
time = out.time;

% Angoli Eulero reali
phi = out.phi.Data;
theta = out.theta.Data;
psi = out.psi.Data;

% Angoli Eulero stimati con TRIAD
phi_Triad = out.phi_Triad.Data;
theta_Triad = out.theta_Triad.Data;
psi_Triad = out.psi_Triad.Data;

% Angoli Eulero stimati con TRIAD e filtrati con passa-basso
phi_Triad_pb = out.phi_Triad_pb.Data;
theta_Triad_pb = out.theta_Triad_pb.Data;
psi_Triad_pb = out.psi_Triad_pb.Data;

% Angoli Eulero stimati con soluzione ottima di Wessner
phi_est_W = out.phi_est_W.Data;
theta_est_W = out.theta_est_W.Data;
psi_est_W = out.psi_est_W.Data;

% Angoli Eulero stimati con soluzione ottima di Davenport
phi_est_Dav = out.phi_est_D.Data;
theta_est_Dav = out.theta_est_D.Data;
psi_est_Dav = out.psi_est_D.Data;

% Angoli Eulero stimati con soluzione ottima di Farrell e Stuelpnagel
phi_est_FS = out.phi_est_FS.Data;
theta_est_FS = out.theta_est_FS.Data;
psi_est_FS = out.psi_est_FS.Data;

% Matrice di rotazione vera
R_vera = out.R_vera;

% Determinante della matrice d'assetto stimata
detR_triad = out.detR_triad.Data;
detR_FS = out.detR_FS.Data;
detR_W = out.detR_W.Data;
detR_Dav = out.detR_Dav.Data;

% Posizione e velocità in frame inerziale
pos_inertial = out.pos_inertial.Data;
v_inertial = out.vel_inertial.Data;

% Accelerazione vera in terna body
a_body = out.a_body.Data;

% Accelerazione misurata
a_meas_ = out.a_meas.Data;     time_a =out.a_meas.Time;
a_meas = interp1(time_a, a_meas_, time);

% Campo magnetico misurato
m_meas_ = out.m_meas.Data;     time_m =out.m_meas.Time;
m_meas = interp1(time_m, m_meas_, time);

% Velocità angolare in body vera
omega = out.omega.Data;

% Velocità angolare misurata
omega_meas_ = squeeze(out.omega_meas.Data);   time_o =out.omega_meas.Time;
omega_meas = interp1(time_o, omega_meas_', time);

% Misura del sensore ξ
csi_meas_ = out.csi_meas.Data;   time_csi =out.csi_meas.Time;
csi_meas = interp1(time_csi, csi_meas_, time);

%% PLOT RIFERIMENTI E MISURE 
%======================= 1. Angoli Eulero reali deg ======================%
fig1 = figure(1);
sgtitle('Angoli Eulero reali')
subplot(3,1,1)
plot(time,phi*180/pi,'r')
grid on; xlabel('time [sec]'); ylabel('\phi [deg]'); legend('Rollio')

subplot(3,1,2)
plot(time,theta*180/pi,'b')
grid on; xlabel('time [sec]'); ylabel('\vartheta [deg]'); legend('Beccheggio')

subplot(3,1,3)
plot(time,psi*180/pi,'g')
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

%======================== 40. Misura del sensore ξ =======================%
fig40 = figure(40);
sgtitle('Misura del sensore ξ')
subplot(3,1,1)
plot(time,csi_meas(:,1),'r')
grid on; xlabel('time [sec]'); ylabel('\xi_{meas_1} [adim]'); 

subplot(3,1,2)
plot(time,csi_meas(:,2),'b')
grid on; xlabel('time [sec]'); ylabel('\xi_{meas_2} [adim]');

subplot(3,1,3)
plot(time,csi_meas(:,3),'g')
grid on; xlabel('time [sec]'); ylabel('\xi_{meas_3} [adim]');

fontsize(fig40, scale=2)

%% PLOT RISULTATI APPLICANDO ALGORITMO TRIAD
%========== 25. Errori sugli angoli di Eulero ottenuti da Triad ==========%
fig25 = figure(25);
sgtitle('Errore su Eulero applicando algoritmo Triad')
subplot(3,1,1)
plot(time,phi_Triad-phi,'r')
grid on; xlabel('time [sec]'); ylabel('e_{\phi_{Triad}} [rad]'); 

subplot(3,1,2)
plot(time,theta_Triad-theta,'b')
grid on; xlabel('time [sec]'); ylabel('e_{\vartheta_{Triad}} [rad]'); 

subplot(3,1,3)
plot(time,psi_Triad-psi,'g')
grid on; xlabel('time [sec]'); ylabel('e_{\psi_{Triad}} [rad]'); 

fontsize(fig25, scale=2)

%=== 26. Errori sugli angoli di Eulero ottenuti da Triad con filtro pb ===%
fig26 = figure(26);
sgtitle('Errore su Eulero date da algoritmo Triad e filtraggio delle stime')
subplot(3,1,1)
plot(time,phi_Triad_pb-phi,'r')
grid on; xlabel('time [sec]'); ylabel('e_{\phi_{Triad_{pb}}} [rad]'); 

subplot(3,1,2)
plot(time,theta_Triad_pb-theta,'b')
grid on; xlabel('time [sec]'); ylabel('e_{\vartheta_{Triad_{pb}}} [rad]'); 

subplot(3,1,3)
plot(time,psi_Triad_pb-psi,'g')
grid on; xlabel('time [sec]'); ylabel('e_{\psi_{Triad_{pb}}} [rad]'); 

fontsize(fig26, scale=2)

%======= 27. Confronto tra angoli Eulero stimati con Triad vs veri =======%
fig27 = figure(27);
sgtitle('Confronto angoli Eulero stimati con Triad vs reali')
subplot(3,1,1)
plot(time,phi_Triad,'k'); hold on
plot(time,phi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\phi,\phi_{Triad} [rad]'); 
legend('Triad', 'reale')

subplot(3,1,2)
plot(time,theta_Triad,'b'); hold on
plot(time,theta,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\vartheta,\vartheta_{Triad} [rad]'); 
legend('Triad', 'reale')

subplot(3,1,3)
plot(time,psi_Triad,'g'); hold on
plot(time,psi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\psi,\psi_{Triad} [rad]'); 
legend('Triad', 'reale')

fontsize(fig27, scale=2)

% 28. Confronto tra angoli Eulero stimati con Triad e filtrati pb vs veri %
fig28 = figure(28);
sgtitle('Confronto angoli Eulero stimati con Triad e filtrati pb vs reali')
subplot(3,1,1)
plot(time,phi_Triad_pb,'k'); hold on
plot(time,phi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\phi,\phi_{Triad_{pb}} [rad]'); 
legend('Triad_{pb}', 'reale')

subplot(3,1,2)
plot(time,theta_Triad_pb,'b'); hold on
plot(time,theta,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\vartheta,\vartheta_{Triad_{pb}} [rad]'); 
legend('Triad_{pb}', 'reale')

subplot(3,1,3)
plot(time,psi_Triad_pb,'g'); hold on
plot(time,psi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\psi,\psi_{Triad_{pb}} [rad]'); 
legend('Triad_{pb}', 'reale')

fontsize(fig28, scale=2)

%============ 41. Determinante R stimata con algoritmo TRIAD =============%
fig41 = figure(41);
sgtitle('det(R estim TRIAD)')
plot(time, detR_triad)
grid on; xlabel('time [sec]'); ylabel('det(R TRIAD)  [adim]')

fontsize(fig41, scale=2)

%% PLOT RISULTATI DELLA SOLUZIONE DI FARREL E STUELPNAGER
%============ 29. Confronto tra angoli Eulero stimati con FS =============%
fig29 = figure(29);
sgtitle('Confronto angoli Eulero stimati con FS vs reali')
subplot(3,1,1)
plot(time,phi_est_FS,'k'); hold on
plot(time,phi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\phi,\phi_{FS} [rad]'); 
legend('FS', 'reale')

subplot(3,1,2)
plot(time,theta_est_FS,'b'); hold on
plot(time,theta,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\vartheta,\vartheta_{FS} [rad]'); 
legend('FS', 'reale')

subplot(3,1,3)
plot(time,psi_est_FS,'g'); hold on
plot(time,psi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\psi,\psi_{FS} [rad]'); 
legend('FS', 'reale')

fontsize(fig29, scale=2)

%=========== 30. Errori sugli angoli di Eulero ottenuti da FS ============%
fig30 = figure(30);
sgtitle('Errore su Eulero applicando algoritmo di FS')
subplot(3,1,1)
plot(time,phi_est_FS-phi,'r')
grid on; xlabel('time [sec]'); ylabel('e_{\phi_{FS}} [rad]'); 

subplot(3,1,2)
plot(time,theta_est_FS-theta,'b')
grid on; xlabel('time [sec]'); ylabel('e_{\vartheta_{FS}} [rad]'); 

subplot(3,1,3)
plot(time,psi_est_FS-psi,'g')
grid on; xlabel('time [sec]'); ylabel('e_{\psi_{FS}} [rad]'); 

fontsize(fig30, scale=2)

%========= 42. Determinante R stimata con algoritmo ottimo di FS =========%
fig42 = figure(42);
sgtitle('det(R estim FS)')
plot(time, detR_FS)
grid on; xlabel('time [sec]'); ylabel('det(R FS)  [adim]')

fontsize(fig42, scale=2)

%% PLOT RISULTATI CON LA SOLUZIONE DI WESSNER
%========== 31. Confronto tra angoli Eulero stimati con Wessner ==========%
fig31 = figure(31);
sgtitle('Confronto angoli Eulero stimati con Wessner vs reali')
subplot(3,1,1)
plot(time,phi_est_W,'k'); hold on
plot(time,phi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\phi,\phi_{W} [rad]'); 
legend('W', 'reale')

subplot(3,1,2)
plot(time,theta_est_W,'b'); hold on
plot(time,theta,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\vartheta,\vartheta_{W} [rad]'); 
legend('W', 'reale')

subplot(3,1,3)
plot(time,psi_est_W,'g'); hold on
plot(time,psi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\psi,\psi_{W} [rad]'); 
legend('W', 'reale')

fontsize(fig31, scale=2)

%========= 32. Errori sugli angoli di Eulero ottenuti da Wessner =========%
fig32 = figure(32);
sgtitle('Errore su Eulero applicando algoritmo di Wessner')
subplot(3,1,1)
plot(time,phi_est_W-phi,'r')
grid on; xlabel('time [sec]'); ylabel('e_{\phi_{W}} [rad]'); 

subplot(3,1,2)
plot(time,theta_est_W-theta,'b')
grid on; xlabel('time [sec]'); ylabel('e_{\vartheta_{W}} [rad]'); 

subplot(3,1,3)
plot(time,psi_est_W-psi,'g')
grid on; xlabel('time [sec]'); ylabel('e_{\psi_{W}} [rad]'); 

fontsize(fig32, scale=2)

%========= 43. Determinante R stimata con algoritmo ottimo di W ==========%
fig43 = figure(43);
sgtitle('det(R estim W)')
plot(time, detR_W)
grid on; xlabel('time [sec]'); ylabel('det(R W)  [adim]')

fontsize(fig43, scale=2)

%% PLOT RISULTATI DELLA SOLUZIONE DI DAVENPORT
%========= 33. Confronto tra angoli Eulero stimati con Davenport =========%
fig33 = figure(33);
sgtitle('Confronto angoli Eulero stimati con Davenport vs reali')
subplot(3,1,1)
plot(time,phi_est_Dav,'k'); hold on
plot(time,phi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\phi,\phi_{Dav} [rad]'); 
legend('Dav', 'reale')

subplot(3,1,2)
plot(time,theta_est_Dav,'b'); hold on
plot(time,theta,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\vartheta,\vartheta_{Dav} [rad]'); 
legend('Dav', 'reale')

subplot(3,1,3)
plot(time,psi_est_Dav,'g'); hold on
plot(time,psi,'r--'); hold off
grid on; xlabel('time [sec]'); ylabel('\psi,\psi_{Dav} [rad]'); 
legend('Dav', 'reale')

fontsize(fig33, scale=2)

%======== 34. Errori sugli angoli di Eulero ottenuti da Davenport ========%
fig34 = figure(34);
sgtitle('Errore su Eulero applicando algoritmo di Davenport')
subplot(3,1,1)
plot(time,phi_est_Dav-phi,'r')
grid on; xlabel('time [sec]'); ylabel('e_{\phi_{Dav}} [rad]'); 

subplot(3,1,2)
plot(time,theta_est_Dav-theta,'b')
grid on; xlabel('time [sec]'); ylabel('e_{\vartheta_{Dav}} [rad]'); 

subplot(3,1,3)
plot(time,psi_est_Dav-psi,'g')
grid on; xlabel('time [sec]'); ylabel('e_{\psi_{Dav}} [rad]'); 

fontsize(fig34, scale=2)

%===== 44. Determinante R stimata con algoritmo ottimo di Davenport ======%
fig44 = figure(44);
sgtitle('Scostamento del det(R Davenport) dall''unità')
plot(time, detR_Dav-ones(size(detR_Dav)))
grid on; xlabel('time [sec]'); ylabel('det(R Davenport) - 1  [adim]')

fontsize(fig44, scale=2)
