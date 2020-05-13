function sensedStates = sensors(actual_phi,actual_phi_p,actual_theta,actual_theta_p)
%actual_phi = actualStates(1);
%actual_theta = actualStates(3);

%% GET DATA FROM WS
Ts = evalin('base', 'Ts');
sensitivity_giroscopio = evalin('base', 'sensitivity_giroscopio');
sensitivity_encoder = evalin('base', 'sensitivity_encoder');

%% NOISE
power = 10^-7;
seed = 23341;
imp = 1;
noise = wgn(1,1,power, imp, seed);

actual_phi_noised = actual_phi + noise;
actual_theta_noised = actual_theta + noise;

%% QUANTIZATION
quantumEncoder = 1 / sensitivity_encoder;
quantumGiroscope = 1 / sensitivity_giroscopio;

actual_phi_quantized = round(actual_phi_noised/quantumEncoder)*quantumEncoder; 
actual_theta_quantized = round(actual_theta_noised/quantumGiroscope)*quantumGiroscope;

%% FILTERING
filter_order = 2;
w_n = 30; % w_n [rad / s]
f_c = w_n / (2 * pi); % [Hz]
f_s = 1/ Ts;

[b,a] = butter(filter_order, f_c / (f_s/2));
actual_phi_filtered = filter(b,a, actual_phi_quantized);
actual_theta_filtered = filter(b, a, actual_theta_quantized);

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

K = 1.0;
actual_phi_derived = K *(last_phi_quantized - actual_phi_quantized) / Ts;
actual_theta_derived = K * (last_theta_quantized - actual_theta_quantized) / Ts;

assignin('base','last_phi_quantized', actual_phi_quantized);
assignin('base','last_theta_quantized', actual_theta_quantized);

%% MOVING AVERAGE
windowLen = 200;
n = 1; % Shift units

ise_window_phi = evalin( 'base', 'exist(''window_phi'',''var'') == 0' );
ise_window_theta = evalin( 'base', 'exist(''window_theta'',''var'') == 0' );

if ise_window_phi && ise_window_theta
    window_phi = zeros(windowLen,1);
    window_theta = zeros(windowLen,1);
end

temp_window_phi = zeros(size(window_phi));
temp_window_phi(n+1:end)= window_phi(1:end-n);
temp_window_phi(1,1) = actual_phi_derived;
actual_phi_derived = sum(window_phi) / windowLen;
window_phi = temp_window_phi;

temp_window_theta = zeros(size(window_theta));
temp_window_theta(n+1:end)= window_theta(1:end-n);
temp_window_theta(1,1) = actual_theta_deriveded;
actual_theta_deriveded = sum(window_theta) / windowLen;
window_theta = temp_window_theta;

assignin('base','window_phi', window_phi);
assignin('base','window_theta', window_theta);
%% SENSED STATES COMPOSITION
sensedStates = [actual_phi_quantized, actual_phi_derived, actual_theta_quantized, actual_theta_deriveded];
end

