function output = theta_p_filter(input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Ts = evalin('base', 'Ts');
theta = input;

ise = evalin( 'base', 'exist(''theta_precedente'',''var'') == 0' );
if ise
    theta_precedente = 0;
%altrimenti leggo il valore dalla workspace
else
    theta_precedente = evalin('base', 'theta_precedente');
end
windowWidth = 200; % Whatever you want.
kernel = ones(windowWidth,1)/windowWidth;
check = evalin( 'base', 'exist(''m_a_theta_p'',''var'') == 0' );
if check
    m_a_theta_p = zeros(windowWidth,1);
%altrimenti leggo il valore dalla workspace
else
    m_a_theta_p = evalin('base', 'm_a_theta_p');
end
theta_p = (theta-theta_precedente)/Ts;
m_a_theta_p = [m_a_theta_p(2:end);theta_p];
theta_p_filtrato =filter(kernel, 1, m_a_theta_p);
theta_p_attuale = theta_p_filtrato(end);
output = theta_p_attuale;
assignin('base','m_a_theta_p',m_a_theta_p);
assignin('base','theta_precedente',theta);
end

