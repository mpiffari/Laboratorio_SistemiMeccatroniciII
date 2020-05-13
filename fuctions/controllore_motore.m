function output = controllore_motore(input)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cm_setpoint = input(2);
corrente_attuale_noise = input(1);

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
% fc = 30/(2*pi);
% fs = 1/Ts;
% [b,a] = butter(2,fc/(fs/2));
% corrente_attuale = filter(b,a,corrente_attuale_noise);
corrente_attuale = corrente_attuale_noise;
differenza_corrente = corrente_setpoint - corrente_attuale;

ise = evalin( 'base', 'exist(''integrator_controller_motor'',''var'') == 0' );
if ise
    integrator_controller_motor = 0;
%altrimenti leggo il valore dalla workspace
else
    integrator_controller_motor = evalin('base', 'integrator_controller_motor');
end
integrator_controller_motor_new = I*Ts*differenza_corrente + integrator_controller_motor;
output =  [P*differenza_corrente + integrator_controller_motor_new,differenza_corrente,integrator_controller_motor_new];
assignin('base','integrator_controller_motor',integrator_controller_motor_new);
end

