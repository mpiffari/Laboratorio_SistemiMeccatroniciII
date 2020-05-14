function sensedStates = sensors(input)
%% GET INPUT
actual_phi_quantized = input(1);
actual_theta_quantized = input(2);
%% GET DATA FROM WS
Ts = evalin('base', 'Ts');

%% DERIVATION

% Esistono le variabili salvate al ciclo precedente?
ise_phi = evalin( 'base', 'exist(''last_phi_quantized'',''var'') == 0' );
ise_theta = evalin( 'base', 'exist(''last_theta_quantized'',''var'') == 0' );

% Se non esistono le creo e le inizializzo
if ise_phi && ise_theta
    last_phi_quantized = 0;
    last_theta_quantized = 0;

% Altrimenti leggo il valore assegnatogli al ciclo precedente
else
    last_phi_quantized = evalin('base', 'last_phi_quantized');
    last_theta_quantized = evalin('base', 'last_theta_quantized');
end

actual_phi_derived = (actual_phi_quantized - last_phi_quantized) / Ts;
actual_theta_derived = (actual_theta_quantized - last_theta_quantized) / Ts;

assignin('base','last_phi_quantized', actual_phi_quantized);
assignin('base','last_theta_quantized', actual_theta_quantized);

%% MOVING AVERAGE
windowLen = 200;

ise_window_phi = evalin('base', 'exist(''window_phi'',''var'') == 0' );
ise_window_theta = evalin('base', 'exist(''window_theta'',''var'') == 0' );
ise_window_phi_derived = evalin('base', 'exist(''window_phi_derived'',''var'') == 0' );
ise_window_theta_derived = evalin('base', 'exist(''window_theta_derived'',''var'') == 0' );

if ise_window_phi && ise_window_theta && ise_window_phi_derived && ise_window_theta_derived
    window_phi = zeros(windowLen,1);
    window_theta = zeros(windowLen,1);
    window_phi_derived = zeros(windowLen,1);
    window_theta_derived = zeros(windowLen,1);
else
    window_phi = evalin('base', 'window_phi');
    window_theta = evalin('base', 'window_theta');
    window_phi_derived = evalin('base', 'window_phi_derived');
    window_theta_derived = evalin('base', 'window_theta_derived');
end

% PHI
temp_window_phi = zeros(size(window_phi));
temp_window_phi(1:end-1)= window_phi(2:end);
temp_window_phi(end) = actual_phi_quantized;
window_phi = temp_window_phi;
actual_phi_quantized = sum(window_phi) / windowLen;

% THETA
temp_window_theta = zeros(size(window_theta));
temp_window_theta(1:end-1)= window_theta(2:end);
temp_window_theta(end) = actual_theta_quantized;
window_theta = temp_window_theta;
actual_theta_quantized = sum(window_theta) / windowLen;

% PHI_P
temp_window_phi_derived = zeros(size(window_phi_derived));
temp_window_phi_derived(1:end-1)= window_phi_derived(2:end);
temp_window_phi_derived(end) = actual_phi_derived;
window_phi_derived = temp_window_phi_derived;
actual_phi_derived = sum(window_phi_derived) / windowLen;

% THETA_P
temp_window_theta_derived = zeros(size(window_theta_derived));
temp_window_theta_derived(1:end-1)= window_theta_derived(2:end);
temp_window_theta_derived(end) = actual_theta_derived;
window_theta_derived = temp_window_theta_derived;
actual_theta_derived = sum(window_theta_derived) / windowLen;

assignin('base','window_phi', window_phi);
assignin('base','window_theta', window_theta);
assignin('base','window_phi_derived', window_phi_derived);
assignin('base','window_theta_derived', window_theta_derived);

%% SENSED STATES COMPOSITION
sensedStates = [actual_phi_quantized, actual_phi_derived, actual_theta_quantized, actual_theta_derived];
end

