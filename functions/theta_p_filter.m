function output = theta_p_filter(input)
%% SET PARAMS
theta = input;
windowWidth = 200;

%% GET VARIABLES FROM WS
Ts = evalin('base', 'Ts');
check_theta_precedente = evalin( 'base', 'exist(''theta_precedente'',''var'') == 0' );
if check_theta_precedente
    theta_precedente = 0;
else
    %altrimenti leggo il valore dalla workspace
    theta_precedente = evalin('base', 'theta_precedente');
end

check_moving_avg = evalin( 'base', 'exist(''m_a_theta_p'',''var'') == 0' );
if check_moving_avg
    m_a_theta_p = zeros(windowWidth,1);
else
    %altrimenti leggo il valore dalla workspace
    m_a_theta_p = evalin('base', 'm_a_theta_p');
end

%% FILTERING
kernel = ones(windowWidth,1)/windowWidth;
theta_p = (theta-theta_precedente)/Ts;
m_a_theta_p = [m_a_theta_p(2:end);theta_p];
theta_p_filtrato =filter(kernel, 1, m_a_theta_p);
theta_p_attuale = theta_p_filtrato(end);
output = theta_p_attuale;

%% SAVING IN WS
assignin('base','m_a_theta_p',m_a_theta_p);
assignin('base','theta_precedente',theta);
end

