%============================ SETTING INIZIALE ===========================%
% Per prima cosa avviare la simulaizone del file Simulink desiderato
run("Main_Articolo.m")                 % carico i parametri
out = sim("Filtri_Dinamici.slx");      % avvio simulazione
disegno_drone_vero  = true;            % settare su true per rappresentare il drone vero
disegno_drone_meccanizzazione = true;  % settare su true per rappresentare il drone dato da meccanizzazione
disegno_drone_Mahony = true;           % settare su true per disegnare drone stimato da Mahony
disegno_drone_MS = false;
disegno_drone_CO = false;

%==================== ESTRAGGO I DATI DI SIMULAZIONE =====================%
time = out.time;             % tempo di simulazione
R_vera = out.R_vera;         % Matrice C_bi vera
R_mecc = out.R_hat_mecc;     % Matrice C_bi stimata dalla sola meccanizzazione
R_Mahony = out.R_hat_Mahony; % Matrice C_bi stimata con filtro di Mahony
R_MS = out.R_hat_MS;
R_CO = out.R_hat_CO;

%======================= CREAZIONE DEL DRONE VERO ========================%
ldv = 0.3; % mezzo lato del cubo di schematizzazione VTOL vero
% Definisco il drone vero come un cubo centrato nell'origine
drone_vero_lati1 = [[-ldv -ldv -ldv]; [-ldv -ldv ldv] ;
    [-ldv -ldv -ldv]; [-ldv ldv -ldv] ;
    [-ldv -ldv -ldv]; [ldv -ldv -ldv] ];
drone_vero_lati2 = [[ldv ldv ldv]; [-ldv ldv ldv] ;
    [ldv ldv ldv]; [ldv ldv -ldv] ;
    [ldv ldv ldv]; [ldv -ldv ldv] ];
drone_vero_lati3 = [[-ldv -ldv ldv]; [ldv -ldv ldv];
    [-ldv -ldv ldv]; [-ldv ldv ldv]];
drone_vero_lati4 = [[ldv ldv -ldv]; [ldv -ldv -ldv];
    [ldv ldv -ldv]; [-ldv ldv -ldv]];
drone_vero_lati5 = [[ldv -ldv ldv]; [ldv -ldv -ldv]];
drone_vero_lati6 = [[-ldv ldv ldv]; [-ldv ldv -ldv]];
% Seleziono a parte i vertici della faccia davanti così da avere un
% riferimento di posizione
drone_vertici_anteriori = [[ldv -ldv -ldv]; [ldv ldv -ldv];
    [ldv ldv ldv]; [ldv -ldv ldv]];
% Definizione dei versori solidali al drone vero
drone_vero_versori = [[0 0 0]; [ldv 0 0];
    [0 0 0]; [0 ldv 0]; [0 0 0]; [0 0 ldv]];

%============ CREAZIONE DRONE STIMATO DA SOLA MECCANIZZAZIONE ============%
ldmecc = 0.5; % metà lato  VTOL stimato da meccanizzazione
drone_mecc_lati1 = [[-ldmecc -ldmecc -ldmecc]; [-ldmecc -ldmecc ldmecc] ;
    [-ldmecc -ldmecc -ldmecc]; [-ldmecc ldmecc -ldmecc] ;
    [-ldmecc -ldmecc -ldmecc]; [ldmecc -ldmecc -ldmecc] ];
drone_mecc_lati2 = [[ldmecc ldmecc ldmecc]; [-ldmecc ldmecc ldmecc] ;
    [ldmecc ldmecc ldmecc]; [ldmecc ldmecc -ldmecc] ;
    [ldmecc ldmecc ldmecc]; [ldmecc -ldmecc ldmecc] ];
drone_mecc_lati3 = [[-ldmecc -ldmecc ldmecc]; [ldmecc -ldmecc ldmecc];
    [-ldmecc -ldmecc ldmecc]; [-ldmecc ldmecc ldmecc]];
drone_mecc_lati4 = [[ldmecc ldmecc -ldmecc]; [ldmecc -ldmecc -ldmecc];
    [ldmecc ldmecc -ldmecc]; [-ldmecc ldmecc -ldmecc]];
drone_mecc_lati5 = [[ldmecc -ldmecc ldmecc]; [ldmecc -ldmecc -ldmecc]];
drone_mecc_lati6 = [[-ldmecc ldmecc ldmecc]; [-ldmecc ldmecc -ldmecc]];
% Seleziono a parte i vertici della faccia davanti così da avere un
% riferimento di posizione
drone_vertici_ant_mecc = [[ldmecc -ldmecc -ldmecc]; [ldmecc ldmecc -ldmecc];
    [ldmecc ldmecc ldmecc]; [ldmecc -ldmecc ldmecc]];
% Definizione dei versori solidali al drone meccanizzato
drone_mecc_versori = [[0 0 0]; [ldmecc 0 0];
    [0 0 0]; [0 ldmecc 0]; [0 0 0]; [0 0 ldmecc]];

%================ CREAZIONE DEL DRONE STIMATO CON MAHONY =================%
ldMahony = 0.7; % metà lato  VTOL stimato con filtro di Mahony
% Definizione dei versori solidali al drone stimato
drone_Mahony_versori = [[0 0 0]; [ldMahony 0 0];
    [0 0 0]; [0 ldMahony 0]; [0 0 0]; [0 0 ldMahony]];

%================ CREAZIONE DEL DRONE STIMATO CON MS =================%
ldMS = 0.9; % metà lato  VTOL stimato con filtro di MS
% Definizione dei versori solidali al drone stimato
drone_MS_versori = [[0 0 0]; [ldMS 0 0];
    [0 0 0]; [0 ldMS 0]; [0 0 0]; [0 0 ldMS]];

%================ CREAZIONE DEL DRONE STIMATO CON CO =================%
ldCO = 1.2; % metà lato  VTOL stimato con filtro CO
% Definizione dei versori solidali al drone stimato
drone_CO_versori = [[0 0 0]; [ldCO 0 0];
    [0 0 0]; [0 ldCO 0]; [0 0 0]; [0 0 ldCO]];

%======================= CREAZIONE DELLA FIGURA 3D =======================%
figure;  % Apro figura vuota
axis([-1, 1, -1, 1, -1, 1]); % Imposto i limiti degli assi XYZ
view(3);                     % impostazione del punto di osservazione

% Aggiorno la figura nel tempo con un ciclo for dove creo e cancello
% l'immagine per creare un video

for ind = 1:numel(time)  % va avanti finchè trova elementi in time
    % Applico la rotazione vera ai lati del drone
    drone_vero_lati1 = (R_vera(:,:,ind) * drone_vero_lati1')';
    drone_vero_lati2 = (R_vera(:,:,ind) * drone_vero_lati2')';
    drone_vero_lati3 = (R_vera(:,:,ind) * drone_vero_lati3')';
    drone_vero_lati4 = (R_vera(:,:,ind) * drone_vero_lati4')';
    drone_vero_lati5 = (R_vera(:,:,ind) * drone_vero_lati5')';
    drone_vero_lati6 = (R_vera(:,:,ind) * drone_vero_lati6')';
    % Applico la rotazione vera ai vertici anteriori del drone
    drone_vertici_anteriori = (R_vera(:,:,ind) * drone_vertici_anteriori')';
    % Applico la rotazione ai versori veri del drone
    drone_vero_versori = (R_vera(:,:,ind) * drone_vero_versori')';
    
    % Applico la rotazione data da meccanizzazione ai versori del drone
    drone_mecc_versori = (R_mecc(:,:,ind) * drone_mecc_versori')';

    % Applico la rotazione stimata con Mahony ai versori del drone
    drone_Mahony_versori = (R_Mahony(:,:,ind) * drone_Mahony_versori')';

    % Applico la rotazione stimata con MS ai versori del drone
    drone_MS_versori = (R_MS(:,:,ind) * drone_MS_versori')';

    % Applico la rotazione stimata con CO ai versori del drone
    drone_CO_versori = (R_CO(:,:,ind) * drone_CO_versori')';

    % Disegna il drone in verde se la flag corrispondente è settata su 'true'
    if disegno_drone_vero == true
        % Disegno i versori
        plot3(drone_vero_versori(:, 1), drone_vero_versori(:, 2), drone_vero_versori(:, 3),'b-',LineWidth=1);
        hold on; % Continua a disegnare sullo stesso grafico
        axis equal
        grid on; % Attivazione griglia
        xlabel('X'); ylabel('Y'); zlabel('Z'); % Rinomino assi
        set(gca, 'YDir','reverse');set(gca, 'XDir','reverse'); % inverto direzioni assi x e y per farli crescere verso l'esterno
%         plot3(drone_vero_lati1(:, 1), drone_vero_lati1(:, 2), drone_vero_lati1(:, 3),'b-');
%         plot3(drone_vero_lati2(:, 1), drone_vero_lati2(:, 2), drone_vero_lati2(:, 3),'b-');
%         plot3(drone_vero_lati3(:, 1), drone_vero_lati3(:, 2), drone_vero_lati3(:, 3),'b-');
%         plot3(drone_vero_lati4(:, 1), drone_vero_lati4(:, 2), drone_vero_lati4(:, 3),'b-');
%         plot3(drone_vero_lati5(:, 1), drone_vero_lati5(:, 2), drone_vero_lati5(:, 3),'b-');
%         plot3(drone_vero_lati6(:, 1), drone_vero_lati6(:, 2), drone_vero_lati6(:, 3),'b-');  
%         % Disegno i verici della faccia anteriore come * blu
%         plot3(drone_vertici_anteriori(:, 1), drone_vertici_anteriori(:, 2), drone_vertici_anteriori(:, 3), 'b*');
    end
    
    % Disegna il drone dato da meccanizzazione in verde se la flag corrispondente è settata su 'true'
    if disegno_drone_meccanizzazione == true
        % Disegno i versori
        plot3(drone_mecc_versori(:, 1), drone_mecc_versori(:, 2), drone_mecc_versori(:, 3),'g-',LineWidth=1);
        hold on; % Continua a disegnare sullo stesso grafico
        axis equal
        grid on; % Attivazione griglia
        xlabel('X'); ylabel('Y'); zlabel('Z'); % Rinomino assi
        set(gca, 'YDir','reverse');set(gca, 'XDir','reverse'); % inverto direzioni assi x e y per farli crescere verso l'esterno
     end

    % Disegna il drone stimato con Mahony in nero se la flag corrispondente è settata su 'true'
    if disegno_drone_Mahony == true
        % Disegno i versori
        plot3(drone_Mahony_versori(:, 1), drone_Mahony_versori(:, 2), drone_Mahony_versori(:, 3),'k-',LineWidth=1);
        hold on; % Continua a disegnare sullo stesso grafico
        axis equal
        grid on; % Attivazione griglia
        xlabel('X'); ylabel('Y'); zlabel('Z'); % Rinomino assi
        set(gca, 'YDir','reverse');set(gca, 'XDir','reverse'); % inverto direzioni assi x e y per farli crescere verso l'esterno
     end

    % Disegna il drone stimato con MS in rosso se la flag corrispondente è settata su 'true'
    if disegno_drone_MS == true
        % Disegno i versori
        plot3(drone_MS_versori(:, 1), drone_MS_versori(:, 2), drone_MS_versori(:, 3),'r-',LineWidth=1);
        hold on; % Continua a disegnare sullo stesso grafico
        axis equal
        grid on; % Attivazione griglia
        xlabel('X'); ylabel('Y'); zlabel('Z'); % Rinomino assi
        set(gca, 'YDir','reverse');set(gca, 'XDir','reverse'); % inverto direzioni assi x e y per farli crescere verso l'esterno
    end

    % Disegna il drone stimato con CO in magenta se la flag corrispondente è settata su 'true'
    if disegno_drone_CO == true
        % Disegno i versori
        plot3(drone_CO_versori(:, 1), drone_CO_versori(:, 2), drone_CO_versori(:, 3),'m-',LineWidth=1);
        hold on; % Continua a disegnare sullo stesso grafico
        axis equal
        grid on; % Attivazione griglia
        xlabel('X'); ylabel('Y'); zlabel('Z'); % Rinomino assi
        set(gca, 'YDir','reverse');set(gca, 'XDir','reverse'); % inverto direzioni assi x e y per farli crescere verso l'esterno
    end

    % Traccia l'origine degli assi come x rossa
    plot3(0,0,0,'rx'); 
    % Disegna pin invisibili per tenere fermi gli assi
    plot3(1.2,1.2,1.2); plot3(-1.2,1.2,1.2); plot3(-1.2,-1.2,1.2); plot3(1.2,-1.2,1.2); plot3(1.2,-1.2,-1.2); plot3(1.2,1.2,-1.2); plot3(-1.2,1.2,-1.2); plot3(-1.2,-1.2,-1.2);
    hold off; 
    % Imposto il titolo
    title(sprintf('Tempo: %.2f secondi', time(ind))); 
    pause(0.5); % Pausa per rendere visibile l'animazione
end
