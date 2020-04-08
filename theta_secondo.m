function theta2_ris = theta_secondo(C_m,alpa,q_2,q_2_p)
%THETA_SECONDO
%    THETA2_RIS = THETA_SECONDO(C_M,ALPA,Q_2,Q_2_P)

%    This function was generated by the Symbolic Math Toolbox version 8.4.
%    08-Apr-2020 15:23:19

t2 = cos(q_2);
t3 = sin(q_2);
t4 = alpa.*2.0;
t5 = q_2.*-1.0;
t6 = q_2.*1.0;
t7 = q_2.*-2.0;
t8 = q_2.*2.0;
t9 = alpa+q_2;
t10 = q_2_p.^2;
t11 = sin(t8);
t12 = q_2+t4;
t13 = t4+t5;
t14 = t4+t7;
t15 = t4+t8;
t16 = cos(t14);
t17 = cos(t15);
theta2_ris = ((C_m.*-7.151e+11+t11.*8.4845e+8+sin(alpa).*1.25e+7-cos(t8).*9.4415e+9-sin(t15).*2.8881e+13-cos(alpa+t8-7.40589999999429e-1).*1.0465e+12+C_m.*t2.*1.1e+9-C_m.*t3.*1.2034e+9+C_m.*t11.*5.623e+3+C_m.*t16.*3.9062e+5-C_m.*t17.*3.9062e+5+t10.*sin(alpa.*3.0+t5).*5.6245e+6-t2.*t10.*1.3769e+11-t3.*t10.*1.2587e+11+t10.*cos(alpa+t5).*8.096e+4+C_m.*cos(t9).*8.9995e+10-t10.*cos(t12).*7.521e+4+t10.*cos(t13).*7.521e+4-t10.*sin(t9).*1.0297e+13+t10.*sin(t12).*6.8755e+4+t10.*sin(t13).*6.8755e+4+2.5e+5).*-1.0)./(t11.*-2.8711e+4-t16.*6.9946e+6+t17.*6.4791e+11+cos(alpa+t8+8.302199999998265e-1).*2.3476e+10+cos(alpa-8.302018803115061e-1).*2.3476169385125e+10-cos(t8-1.481199999998353).*2.1266e+8+4.2997e+12);
