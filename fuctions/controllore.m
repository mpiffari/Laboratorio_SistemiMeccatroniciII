function desidered_cm = controllore(input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
current_state = input(1:4);
desidered_velocity = input(5);

k_simulazione_discreta = evalin('base', 'k_simulazione_discreta');
Ts = evalin('base', 'Ts');
K_integrazione = 0.002;

cm_state_feedback = k_simulazione_discreta*current_state;

current_phi_p = [0,1,0,0]*current_state;
difference_phi_p = current_phi_p - desidered_velocity;
%controllo se esiste la variabile per l'integrazione
ise = evalin( 'base', 'exist(''integrator_controller'',''var'') == 0' );
if ise
    integrator_controller = 0;
%altrimenti leggo il valore dalla workspace
else
    integrator_controller = evalin('base', 'integrator_controller');
end
cm_phi_p_setpoint = integrator_controller + K_integrazione*(1)*Ts*difference_phi_p;

assignin('base','integrator_controller',cm_phi_p_setpoint);
desidered_cm = cm_phi_p_setpoint - cm_state_feedback;
end

