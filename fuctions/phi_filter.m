function output = phi_filter(input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
phi = input;
windowWidth = 200; % Whatever you want.
kernel = ones(windowWidth,1)/windowWidth;
check = evalin( 'base', 'exist(''m_a_phi'',''var'') == 0' );
if check
    m_a_phi = zeros(windowWidth,1);
%altrimenti leggo il valore dalla workspace
else
    m_a_phi = evalin('base', 'm_a_phi');
end

m_a_phi = [m_a_phi(2:end);phi];
phi_filtrato =filter(kernel, 1, m_a_phi);
phi_attuale = phi_filtrato(end);
output = phi_attuale;
assignin('base','m_a_phi',m_a_phi);
end

