function output = theta_filter(input)
%% SET PARAMS
theta = input;
windowWidth = 200;

%% GET VARIABLE FROM WS
check = evalin( 'base', 'exist(''m_a_theta'',''var'') == 0' );
if check
    m_a_theta = zeros(windowWidth,1);
else
    %altrimenti leggo il valore dalla workspace
    m_a_theta = evalin('base', 'm_a_theta');
end

%% FILTERING
kernel = ones(windowWidth,1)/windowWidth;
m_a_theta = [m_a_theta(2:end);theta];
theta_filtrato =filter(kernel, 1, m_a_theta);
theta_attuale = theta_filtrato(end);
output = theta_attuale;

%% SAVING IN WS
assignin('base','m_a_theta',m_a_theta);
end

