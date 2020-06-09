function output = phi_p_filter(input)
%% SET PARAMS
phi = input;
windowWidth = 200;

%% GET VARIABLES FROM WS
Ts = evalin('base', 'Ts');
check_phi_precedente = evalin( 'base', 'exist(''phi_precedente'',''var'') == 0' );
if check_phi_precedente
    phi_precedente = 0;
else
    %altrimenti leggo il valore dalla workspace
    phi_precedente = evalin('base', 'phi_precedente');
end


check_moving_avg = evalin( 'base', 'exist(''m_a_phi_p'',''var'') == 0' );
if check_moving_avg
    m_a_phi_p = zeros(windowWidth,1);
else
    %altrimenti leggo il valore dalla workspace
    m_a_phi_p = evalin('base', 'm_a_phi_p');
end

%% FILTERING
kernel = ones(windowWidth,1)/windowWidth;
phi_p = (phi-phi_precedente)/Ts;
m_a_phi_p = [m_a_phi_p(2:end);phi_p];
phi_p_filtrato =filter(kernel, 1, m_a_phi_p);
phi_p_attuale = phi_p_filtrato(end);
output = phi_p_attuale;

%% SAVING IN WS
assignin('base','m_a_phi_p',m_a_phi_p);
assignin('base','phi_precedente',phi);
end

