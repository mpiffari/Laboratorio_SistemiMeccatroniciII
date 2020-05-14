function output = theta_filter(input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
theta = input;
windowWidth = 200; % Whatever you want.
kernel = ones(windowWidth,1)/windowWidth;
check = evalin( 'base', 'exist(''m_a_theta'',''var'') == 0' );
if check
    m_a_theta = zeros(windowWidth,1);
%altrimenti leggo il valore dalla workspace
else
    m_a_theta = evalin('base', 'm_a_theta');
end

m_a_theta = [m_a_theta(2:end);theta];
theta_filtrato =filter(kernel, 1, m_a_theta);
theta_attuale = theta_filtrato(end);
output = theta_attuale;
assignin('base','m_a_theta',m_a_theta);
end

