ESAME DI SISTEMI DI GUIDA E NAVIGAZIONE - Introduzione alla stima non lineare d'assetto
Candidato: Paolo Gambino
-------------------------------------------------------------------------------------------------------------------------------
Il presente Read-me è stato creato per guidare all'uso degli script Matlab e Simulink necessari per ottenere i risultati 
presentati nella relazione finale.

Il primo file da eseguire è "Main_Articolo", contiene la definizione di tutti i parametri utili per far funzionare i modelli
	Simulink. In particolare, nella sezione "PARAMETRI GENERALI" c'è "rumori_bias" che si può settare a 0 per escludere 
	l'effetto di tutti i rumori e bias nei sensori, e simulare allora il "caso ideale", oppure a 1 per integrarli, 
	simulo il "caso reale".

Se si volessero ottenere subito i grafici della relazione eseguire gli script "Plot_Filtri_Dinamici" (per i filtri di Mahony
	standard, versione di Martin e Salaun ed Osservatore Condizionato) e "Plot_Filtri_Statici" (per gli algoritmi TRIAD e
	gli ottimi basati sul problema di Wahba). Non è necessario avviare manualmente i Simulink in quanto vengono eseguiti
	all'interno degli script stessi. 

Per l'algoritmo TRIAD si può scegliere la combinazione delle misure inerziali da usare per la stima, per farlo:
	- Aprire il file Simulink "Filtri_Statici"
	- Aprire la Matlab function "Algoritmo TRIAD"
	- Selezionare la riga corrispondente alla coppia delle misure che si vogliono usare

"Filtri_Dinamici" e "Filtri_Statici" sono gli schemi Simulink con cui si possono simulare tutti i filtri presentati, inoltre
	al loro interno sono presenti degli scope per ottenere gli stessi grafici presenti in relazione.

"Sim3D_VTOL_dyn" è uno script aggiuntivo, non sono riuscito a farlo funzionare bene, dovrebbe mostrare un cubo rappresentante il velivolo 
	ed i suoi assi principali. C'è un cubo che ruota seguendo gli angoli veri di Eulero e poi un cubo per ogni metodo di stima
	dinamica rotante secondo gli angoli stimati con tale metodologia.
