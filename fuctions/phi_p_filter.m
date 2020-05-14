function output = phi_p_filter(input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Ts = evalin('base', 'Ts');
phi = input;

ise = evalin( 'base', 'exist(''phi_precedente'',''var'') == 0' );
if ise
    phi_precedente = 0;
%altrimenti leggo il valore dalla workspace
else
    phi_precedente = evalin('base', 'phi_precedente');
end
windowWidth = 200; % Whatever you want.
kernel = ones(windowWidth,1)/windowWidth;
check = evalin( 'base', 'exist(''m_a_phi_p'',''var'') == 0' );
if check
    m_a_phi_p = zeros(windowWidth,1);
%altrimenti leggo il valore dalla workspace
else
    m_a_phi_p = evalin('base', 'm_a_phi_p');
end
phi_p = (phi-phi_precedente)/Ts;
m_a_phi_p = [m_a_phi_p(2:end);phi_p];
phi_p_filtrato =filter(kernel, 1, m_a_phi_p);
phi_p_attuale = phi_p_filtrato(end);
output = phi_p_attuale;
assignin('base','m_a_phi_p',m_a_phi_p);
assignin('base','phi_precedente',phi);
end

