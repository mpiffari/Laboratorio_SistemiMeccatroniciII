function output = controllore_motore(input)
%% SET PARAMS
cm_setpoint = input(2);
corrente_attuale_noise = input(1);
windowWidth = 20;

%% GET VARIABLE FROM WS
check_moving_avg = evalin( 'base', 'exist(''m_a_motore'',''var'') == 0' );
if check_moving_avg
    m_a_motore = zeros(windowWidth,1);
else
    %altrimenti leggo il valore dalla workspace
    m_a_motore = evalin('base', 'm_a_motore');
end

check_I = evalin( 'base', 'exist(''integrator_controller_motor'',''var'') == 0' );
if check_I
    integrator_controller_motor = 0;
%altrimenti leggo il valore dalla workspace
else
    integrator_controller_motor = evalin('base', 'integrator_controller_motor');
end

k_t = evalin('base', 'k_t');
Ts = evalin('base', 'Ts_motore');
P = evalin('base', 'P');
I = evalin('base', 'I');

%% TORQUE SATURATION
if cm_setpoint > 2
    cm_setpoint = 2;
end

if cm_setpoint <-2
    cm_setpoint = -2;
end

%% MOVING AVERAGE FILTERING
kernel = ones(windowWidth,1)/windowWidth;
corrente_setpoint = cm_setpoint/k_t;
m_a_motore = [m_a_motore(2:end);corrente_attuale_noise];
corrente_filtrata = filter(kernel, 1, m_a_motore);
corrente_attuale = corrente_filtrata(end);
differenza_corrente = corrente_setpoint - corrente_attuale_noise;

%% PI CONTROLL
integrator_controller_motor_new = I*Ts*differenza_corrente + integrator_controller_motor;
output =  [P*differenza_corrente + integrator_controller_motor_new,corrente_attuale,corrente_attuale_noise];

%% SAVE TO WS
assignin('base','integrator_controller_motor',integrator_controller_motor_new);
assignin('base','m_a_motore',m_a_motore);
end

