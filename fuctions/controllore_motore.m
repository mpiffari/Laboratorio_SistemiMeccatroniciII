function output = controllore_motore(input)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cm_setpoint = input(2);
corrente_attuale_noise = input(1);
windowWidth = 20; % Whatever you want.
kernel = ones(windowWidth,1)/windowWidth;
check = evalin( 'base', 'exist(''m_a_motore'',''var'') == 0' );
if check
    m_a_motore = zeros(windowWidth,1);
%altrimenti leggo il valore dalla workspace
else
    m_a_motore = evalin('base', 'm_a_motore');
end
k_t = evalin('base', 'k_t');
Ts = evalin('base', 'Ts_motore');
P = evalin('base', 'P');
I = evalin('base', 'I');

if cm_setpoint > 2
    cm_setpoint = 2;
end

if cm_setpoint <-2
    cm_setpoint = -2;
end

corrente_setpoint = cm_setpoint/k_t;
m_a_motore = [m_a_motore(2:end);corrente_attuale_noise];
corrente_filtrata = filter(kernel, 1, m_a_motore);
corrente_attuale = corrente_filtrata(end);
differenza_corrente = corrente_setpoint - corrente_attuale_noise;

ise = evalin( 'base', 'exist(''integrator_controller_motor'',''var'') == 0' );
if ise
    integrator_controller_motor = 0;
%altrimenti leggo il valore dalla workspace
else
    integrator_controller_motor = evalin('base', 'integrator_controller_motor');
end
integrator_controller_motor_new = I*Ts*differenza_corrente + integrator_controller_motor;
output =  [P*differenza_corrente + integrator_controller_motor_new,corrente_attuale,corrente_attuale_noise];
assignin('base','integrator_controller_motor',integrator_controller_motor_new);
assignin('base','m_a_motore',m_a_motore);
end

