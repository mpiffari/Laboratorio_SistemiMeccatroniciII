function ris = fdt_vab_non_lineare()
%Dinamica Veicolo Autobilanciato - gruppo Calegari
clc
digits(4)
%Definizione delle variabili simboliche
syms t; % tempo
syms T; % Energia cinetica del sistema
syms U; % Energia potenziale del sistema
syms C_m;
syms alpa; % Angolo di offset (inclinazione utente) che sposta in avanti il baricentro

%syms beta; % Angolo baricentro asta

syms q_1 q_1_p q_2 q_2_p; % Coordinate libere
syms phi(t); % Posizione carrello/r
vel = diff(phi, t); % Velocità carello / r
syms theta(t); % Angolo inclinazione
vel_ang = diff(theta, t); % Vel angolare
%syms C_m; % Forza esterna

% Definizione masse e gravità
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

% Costante di accelerazione di gravità
g = sym('9.80665');
%Definizione delle altezze
%Dimensioni espresse tutte in [m]
% Altezza asta
h_a = sym('1.4');

% Altezza base
h_b = sym('0.2');

% Profondità base
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


temp_1 = (h_a / 2) + (h_b / 2);
temp_2 = w_b / 2;

l_c = 0.55 * h_c;
l_b = 0.1;
l_a = sqrt((temp_1)^2 + (temp_2)^2);


beta = atan(temp_2/temp_1);
% Calcolo componenti dinamiche e potenziali per ogni corpo rigido del sistema
% Nello specifico abbiamo considerato il sistema composto da:
% Asta ()
% Utente a bordo dello chassis ()
% Chassis (o base) ()
% Ruota () che poi sarà considerata con un contributo doppio, essendo 2 le ruote del sistema
% Per ognuno di questi corpi rigidi siamo andati a calcolare:
% Coordinate spaziali nel sistema di riferimento XZ, con l'aggiunta delle coordinate angolari  vettore 3 x 1
% Vettore delle velocità  vettore 3 x 1
% Matrice delle masse  matrice 3 x 3
% Energia cinetica dello specifico corpo rigido  
% Energia potenziale dello specifico corpo rigido 
% Lagrangiana dello specifico corpo rigido  
% Asta 
P_a = [phi*r+l_a*sin(theta+beta); l_a*cos(theta+beta); theta];
V_a = diff(P_a, t);
M_a = [m_a,0,0; 0,m_a,0; 0,0,J_a]; % Matrice delle masse/inerzie
T_a = 1/2 * transpose(V_a) * M_a * V_a;
U_a = m_a * g * l_a * cos(theta+beta);
L_a = T_a - U_a;
%Utente  
P_c = [phi*r+l_c*sin(theta+alpa); l_c*cos(theta+alpa); theta + alpa];
V_c = diff(P_c,t);
M_c = [m_c,0,0; 0,m_c,0; 0,0,J_c];
T_c = 1/2 * transpose(V_c) * M_c * V_c;
U_c = m_c * g * l_c * cos(alpa+theta);
L_c = T_c - U_c;
%Chassis (o base)  
P_b = [phi*r+l_b*sin(3.1415+theta); l_b*cos(3.1415+theta); 3.1415+theta];
V_b = diff(P_b,t);
M_b = [m_b,0,0; 0,m_b,0; 0,0,J_b];
T_b = 1/2 * transpose(V_b) * M_b * V_b;
U_b = m_b * g * l_b * cos(3.1415+theta);
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
L_q = subs(L,{phi,vel,theta,vel_ang},{q_1 q_1_p q_2 q_2_p}); % Esprimo la Lagrangiana rispetto ai simboli di coordinate libere generiche (q_1 etc)

% Equazioni del moto
% Andiamo ora a calcolare le equazioni del moto, considerando, come coordinate libere
% 
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
[theta2, phi2] = solve(eqns, [q1_s q2_s]);
theta2_ris = vpa(collect(simplify(subs(theta2,{phi,vel,theta,vel_ang},{q_1 q_1_p q_2 q_2_p}))),4)
phi2_ris = collect(simplify(subs(phi2,{phi,vel,theta,vel_ang},{q_1 q_1_p q_2 q_2_p})))
disp('funzione creata');
ris = 0;
matlabFunction(theta2_ris,'File','theta_secondo');
matlabFunction(phi2_ris,'File','p_secondo');
end

