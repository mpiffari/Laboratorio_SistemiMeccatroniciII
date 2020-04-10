function [coeffs_num,coeffs_den] = fdt_vab_lineare(alfa)

%Dinamica Veicolo Autobilanciato - gruppo Calegari
clc
digits(4)

%Definizione delle variabili simboliche
syms t; % tempo
syms T; % Energia cinetica del sistema
syms U; % Energia potenziale del sistema
syms C_m;
sym alpha; % Angolo di offset (inclinazione utente) che sposta in avanti il baricentro
%syms beta; % Angolo baricentro asta

syms q_1 q_1_p q_2 q_2_p; % Coordinate libere
syms phi(t); % Posizione carrello/r
vel = diff(phi, t); % Velocit� carello / r
syms theta(t); % Angolo inclinazione
vel_ang = diff(theta, t); % Vel angolare
%syms C_m; % Forza esterna

% %%%%%%%%%%%%%%%%%%%%%%%%% Definizione masse e gravit� %%%%%%%%%%%%%%%%%%%%%
% m_r = vba(3,4); % Massa singola ruota
% m_a = 3.5; % Massa asta
% m_c = 70; % Massa uomo
% m_b = 20; % Massa carello(base) + batterie: 
% % (Si suppongono le batterie all'interno di questa massa)
% 
% M = m_a + m_b + m_c + 2*m_r; % Massa totale del sistema
% g = 9.80665; % Costante di accelerazione di gravit�
% 
% %%%%%%%%%%%%%%%%%%%%%%%%% Definizione delle altezze %%%%%%%%%%%%%%%%%%%%%%%
% %Dimensioni espresse tutte in [m]
% h_a = 1.4; % Altezza asta
% h_b = 0.2; % Altezza base
% w_b = 0.5; % Profondit� base
% 
% z_b = 0.1; % Posizione baricentro base (valore assoluto)
% h_c = 1.70; % Altezza uomo
% 
% r = 0.22; % Raggio ruota
% %%%%%%%%%%%%%%%%%%%%%%%%% Definizione inerzie %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% J_a = 0.1669;% Inerzia asta
% J_b = 0.6667; % Inerzia della base
% 
% % Inerzia del corpo
% J_c = (1732353*h_c + 619298*2.20462*m_c - 277625773)*10e-7;
% J_r = 0.1452;% Inerzia della singola ruota
% Definizione masse e gravit�
% Massa singola ruota
m_r = sym('3');
% Massa asta
m_a = sym('3.5');
% Massa uomo (da far variare poi)
m_c = sym('70');

% Massa carello(base) + batterie: si suppongo le batterie all'interno di
% questa massa
m_b = sym('20');

% Massa totale del sistema
M = m_a+m_b+m_c+2*m_r;

% Costante di accelerazione di gravit�
g = sym('9.80665');
%Definizione delle altezze
%Dimensioni espresse tutte in [m]
% Altezza asta
h_a = sym('1.4');

% Altezza base
h_b = sym('0.2');

% Profondit� base
w_b = sym('0.5');

% Posizione baricentro base (valore assoluto)
z_b = sym('0.1');

% Altezza uomo
h_c = sym('1.70');

% Raggio ruota
r = sym('0.22');
%Definizione inerzie
% Inerzia asta
J_a = sym('0.1669');

% Inerzia della base
J_b = sym('0.6667');

% Inerzia del corpo
J_c = (1732353*h_c + 619298*2.20462*m_c - 277625773)*10e-7;

% Inerzia della singola ruota
J_r = sym('0.1452');
% Definizione delle costanti geometriche 
%%%%%%%%%%%%%%%%%%%%% Definizione delle costanti geometriche %%%%%%%%%%%%%%
temp_1 = (h_a / 2) + (h_b / 2);
temp_2 = w_b / 2;

l_c = 0.55 * h_c;
l_b = 0.1;
l_a = sqrt((temp_1)^2 + (temp_2)^2);

beta = atan(temp_2/temp_1);
alpha = alfa;

% Calcolo componenti dinamiche e potenziali per ogni corpo rigido del sistema
% Nello specifico abbiamo considerato il sistema composto da:
%%%% Asta
%%%% Utente a bordo dello chassis
%%%% Chassis (o base) ()
%%%% Ruota () che poi sar� considerata con un contributo doppio, essendo 2 le ruote del sistema
% Per ognuno di questi corpi rigidi siamo andati a calcolare:
%%%% Coordinate spaziali nel sistema di riferimento XZ, con l'aggiunta delle coordinate angolari  vettore 3 x 1
%%%% Vettore delle velocit�  vettore 3 x 1
%%%% Matrice delle masse  matrice 3 x 3
%%%% Energia cinetica dello specifico corpo rigido  
%%%% Energia potenziale dello specifico corpo rigido 
%%%% Lagrangiana dello specifico corpo rigido  

% Asta 
P_a = [phi*r+l_a*sin(theta+beta); l_a*cos(theta+beta); theta];
V_a = diff(P_a, t);
M_a = [m_a,0,0; 0,m_a,0; 0,0,J_a]; % Matrice delle masse/inerzie
T_a = 1/2 * transpose(V_a) * M_a * V_a;
U_a = m_a * g * l_a * cos(theta+beta);
L_a = T_a - U_a;

%Utente  
P_c = [phi*r+l_c*sin(theta+alpha); l_c*cos(theta+alpha); theta + alpha];
V_c = diff(P_c,t);
M_c = [m_c,0,0; 0,m_c,0; 0,0,J_c];
T_c = 1/2 * transpose(V_c) * M_c * V_c;
U_c = m_c * g * l_c * cos(alpha+theta);
L_c = T_c - U_c;

%Chassis (o base)  
P_b = [phi*r+l_b*sin(pi+theta); l_b*cos(pi+theta); theta];
V_b = diff(P_b,t);
M_b = [m_b,0,0; 0,m_b,0; 0,0,J_b];
T_b = 1/2 * transpose(V_b) * M_b * V_b;
U_b = m_b * g * l_b * cos(pi+theta);
L_b = T_b - U_b;

%Ruota 
P_r = [phi*r; 0; phi];
V_r = diff(P_r,t);
M_r = [m_r,0,0; 0,m_r,0; 0,0,J_r];
T_r = 1/2 * transpose(V_r) * M_r * V_r;
U_r = 0;
L_r = T_r - U_r;

%Lagrangiana dell'intero sistema
L = collect(simplify(2*L_r + L_a + L_b + L_c));
L_q = subs(L,{phi,vel,theta,vel_ang},{q_1 q_1_p q_2 q_2_p}); % Esprimo la Lagrangiana rispetto ai simboli di coordinate libere generiche (q_1...)

% Equazioni del moto 
% Calcolo equazioni del moto rispetto a  phi
dL_dq1 = diff(L_q,q_1);
dL_dphi = subs(dL_dq1,{q_1 q_1_p q_2 q_2_p},{phi,vel,theta,vel_ang});

dL_dq1p = diff(L_q,q_1_p);
dL_dvel = subs(dL_dq1p,{q_1 q_1_p q_2 q_2_p},{phi,vel,theta,vel_ang});
dL_dvel_dt = diff(dL_dvel,t);

E_L_phi = collect(simplify(dL_dvel_dt - dL_dphi == C_m));

% Calcolo equazioni del moto rispetto a  theta
dL_dq2 = diff(L_q,q_2);
dL_dtheta = subs(dL_dq2,{q_1 q_1_p q_2 q_2_p},{phi,vel,theta,vel_ang});

dL_dq2p = diff(L_q,q_2_p);
dL_dvel_ang = subs(dL_dq2p,{q_1 q_1_p q_2 q_2_p},{phi,vel,theta,vel_ang});
dL_dvel_ang_dt = diff(dL_dvel_ang,t);

E_L_theta = collect(simplify(dL_dvel_ang_dt - dL_dtheta == - C_m));

% Risoluzione delle equazioni del moto
syms q1_s q2_s; % Derivate seconde delle coordinate libere
acc_ang = diff(theta, t, 2);
acc = diff(phi, t, 2);

eqns = [subs(E_L_theta, {acc,acc_ang},{q1_s,q2_s}), subs(E_L_phi, {acc,acc_ang},{q1_s,q2_s})];
[phi2,theta2] = solve(eqns, q1_s ,q2_s)

% Avr� 2 equilibri per l'angolo theta
% 0 --> equilibrio instabile
% k +  --> equilibrio stabile
% Per l'altra variabile di stato (posizione x --> angolo phi) l'equilibrio non � rilevante ai fini del controllo dell'equilibrio del segway.
% Andiamo quindi a linearizzare intorno all'equilibrio instabile = [phi, vel, theta, vel_ang] = [0,0,0,0].
% Il vettore di stato con il quale andremo a lavorare � il seguente
% 
% Inoltre, per definire il nostro sistema SIMO in forma matriciale, avremo bisogno del supporto delle matrici A-B-C-D. Per fare questo definiamo queste funzioni di supporto:
% 
% Da qui � quindi possibile poi ricavare le matrici A-B-C-D come segue:

% Dove le matrici A e B hanno nello specifico questa forma:
syms u;
theta2_differenziabile = subs(theta2,{phi,vel,theta,vel_ang,C_m},{q_1 q_1_p q_2 q_2_p u});
phi2_differenziabile = subs(phi2,{phi,vel,theta,vel_ang,C_m},{q_1 q_1_p q_2 q_2_p u});

%phi, phi_primo, theta, theta_primo, C_m (u = INPUT)
equilibrio = {0,0,0,0,0};

A11 = 0;
A12 = 1;
A13 = 0;
A14 = 0;
A21 = subs(diff(phi2_differenziabile,q_1),{q_1 q_1_p q_2 q_2_p u},equilibrio);
A22 = subs(diff(phi2_differenziabile,q_1_p),{q_1 q_1_p q_2 q_2_p u},equilibrio);
A23 = subs(diff(phi2_differenziabile,q_2),{q_1 q_1_p q_2 q_2_p u},equilibrio);
A24 = subs(diff(phi2_differenziabile,q_2_p),{q_1 q_1_p q_2 q_2_p u},equilibrio);
A31 = 0;
A32 = 0;
A33 = 0;
A34 = 1;
A41 = subs(diff(theta2_differenziabile,q_1),{q_1 q_1_p q_2 q_2_p u},equilibrio);
A42 = subs(diff(theta2_differenziabile,q_1_p),{q_1 q_1_p q_2 q_2_p u},equilibrio);
A43 = subs(diff(theta2_differenziabile,q_2),{q_1 q_1_p q_2 q_2_p u},equilibrio);
A44 = subs(diff(theta2_differenziabile,q_2_p),{q_1 q_1_p q_2 q_2_p u},equilibrio);
A = [A11 A12 A13 A14;A21 A22 A23 A24;A31 A32 A33 A34; A41 A42 A43 A44];

B11 = 0;
B21 = subs(diff(phi2_differenziabile,u),{q_1 q_1_p q_2 q_2_p u},equilibrio);
B31 = 0;
B41 = subs(diff(theta2_differenziabile,u),{q_1 q_1_p q_2 q_2_p u},equilibrio);
B = [B11;B21;B31;B41];

C = [0,0,1,0]; % Riportiamo in uscita solamente l'angolo
% C = eye(4); % Riportiamo in uscita tutte le variabili di stato
D = 0;

syms s G(s);
G = collect(simplify(C*(s*eye(4)-A)^(-1)*B+D))
[num, den] = numden(G)
coeffs_num = double(coeffs(num,'all'));
coeffs_den = double(coeffs(den,'all'));
end

