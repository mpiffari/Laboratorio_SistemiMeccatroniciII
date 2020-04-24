function phi2_differenziabile = phi_secondo(alpha,q_2,q_2_p,u)
%PHI_SECONDO
%    PHI2_DIFFERENZIABILE = PHI_SECONDO(ALPHA,Q_2,Q_2_P,U)

%    This function was generated by the Symbolic Math Toolbox version 8.4.
%    24-Apr-2020 18:01:03

t2 = cos(q_2);
t3 = sin(q_2);
t4 = alpha.*2.0;
t5 = q_2.*2.0;
t6 = q_2+3.028848699999998e-1;
t7 = alpha+q_2;
t8 = q_2_p.^2;
t9 = cos(t6);
t10 = sin(t6);
t11 = cos(t7);
t12 = sin(t7);
t13 = t5+6.057697399999995e-1;
t17 = t4+t5;
t14 = sin(t13);
t15 = t9.^2;
t16 = t11.^2;
t18 = sin(t17);
phi2_differenziabile = ((u.*2.343025200000001e+25-t2.*t3.*3.318972055519999e+24-t3.*t8.*1.773201471360001e+25+t2.*t10.*2.830325366880004e+24+t3.*t9.*2.830325386955978e+24+t2.*t12.*7.25012076624e+25+t3.*t11.*7.250120788140993e+25+t8.*t10.*1.512136003745772e+25-t9.*t10.*2.41362132769475e+24+t8.*t12.*3.873465830387998e+26-t9.*t12.*6.182697690707374e+25-t10.*t11.*6.182697665528997e+25-t11.*t12.*1.583750944706698e+27-t2.*u.*8.324800000000002e+21+t9.*u.*7.099153709999992e+21+t11.*u.*1.818509000000001e+23+t15.*u.*4.3601295e+15-t16.*u.*6.5e+16+t2.*t8.*t14.*1.64987304064e+15-t3.*t8.*t15.*3.2997460056e+15+t3.*t8.*t16.*4.9192e+16-t2.*t8.*t18.*2.4596e+16-t8.*t9.*t14.*1.406965010269128e+15+t8.*t10.*t15.*2.813929956000496e+15-t8.*t11.*t14.*3.604061326712e+16-t8.*t10.*t16.*4.194954465e+16+t8.*t9.*t18.*2.0974772325e+16+t8.*t12.*t15.*7.208122488105011e+16-t8.*t12.*t16.*1.0745735e+18+t8.*t11.*t18.*5.3728675e+17).*-5.000000000000002e-5)./(t15.*2.707328411873411e+18+t16.*1.776474183325272e+21-t2.*t9.*6.349483066872005e+18-t2.*t11.*1.626474449599998e+20+t9.*t11.*1.387011351918886e+20+t2.^2.*3.72285056e+18-6.798475059815996e+21);
