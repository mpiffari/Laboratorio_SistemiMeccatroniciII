function output = phi_filter(input)
%% SET PARAMS
phi = input;
windowWidth = 200;

%% GET VARIABLE FROM WS
check = evalin( 'base', 'exist(''m_a_phi'',''var'') == 0' );
if check
    m_a_phi = zeros(windowWidth,1);
else
    %altrimenti leggo il valore dalla workspace
    m_a_phi = evalin('base', 'm_a_phi');
end

%% FILTERING
kernel = ones(windowWidth,1)/windowWidth;
m_a_phi = [m_a_phi(2:end);phi];
phi_filtrato =filter(kernel, 1, m_a_phi);
phi_attuale = phi_filtrato(end);
output = phi_attuale;

%% SAVING IN WS
assignin('base','m_a_phi',m_a_phi);
end

