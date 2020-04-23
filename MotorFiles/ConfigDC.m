function m = ConfigDC(id)

switch (id)
    case 1
        % Nome motore
        m.name = 'Sinobi Serie 75 PX 053';
        % Velocità nominale [rpm]
        m.Vn = 2050;
        % Potenza nominale [W]
        m.Wn = 870;
        % Coppia nominale [Nm]
        m.Cn = 3.6;
        % Corrente nominale [A]
        m.In = 37;
        % Corrente di picco [A]
        m.Imax = 2;
        % Resistenza avvolgimento [ohm]
        m.Ra = 0.13;
        % Induttanza avvolgimento [H]
        m.La = 0.10e-03;
        % Costante di coppia [Nm / A]
        m.K = 0.10;
        % Costante di tempo elettrica [s]
        m.tee = 1.22e-03;
        % Momento d'inerzia rotore [kg m^2]
        m.Jm = 3.7e-04;
        % Massa [kg]
        m.m = 8.1;
        % Carico radiale [N]
        m.radialLoad = 380;
        % Carico assiale [N]
        m.axialLoad = 110;
end

% Elaborazione dei dati elementari
m.te = m.La/m.Ra; % Costante di tempo elettrica
m.tm = m.Ra*m.Jm/m.K^2 % Costante di tempo elettr - meccanica

%Funzione di traferimento della parte elettrica
tf_V_I_e = tf([1/m.Ra],[m.te,1]);

% Fdt completa I/V
tf_V_I = tf([m.tm/m.Ra, 0],[m.tm*m.te,m.tm,1]);

%Funzione di traferimento tra Va e w
tf_V_w = tf([1/m.K],[m.te*m.tm, m.tm, 1]);
set(tf_V_w,'Name',['motore', m.name], 'InputName', 'Va', 'OutputName', 'omega');


m.tf_V_I_simple = tf_V_I_e;
m.tf_V_w = tf_V_w;
m.tf_V_I = tf_V_I;