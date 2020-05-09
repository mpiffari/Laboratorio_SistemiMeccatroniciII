params = gyroparams

% Generate N samples at a sampling rate of Fs with a sinusoidal frequency
% of Fc.
N = 1000;
Fs = 100;
Fc = 0.25;

t = (0:(1/Fs):((N-1)/Fs)).';
acc = zeros(N, 3);
angvel = zeros(N, 3);
angvel(:,1) = sin(2*pi*Fc*t);

% imu = imuSensor('SampleRate', Fs, 'Gyroscope', params);
% [~, gyroData] = imu(acc, angvel);
% 
% figure
% plot(t, angvel(:,1), '--', t, gyroData(:,1))
% xlabel('Time (s)')
% ylabel('Angular Velocity (rad/s)')
% title('Ideal Gyroscope Data')
% legend('x (ground truth)', 'x (gyroscope)')
% 
% imu = imuSensor('SampleRate', Fs, 'Gyroscope', params);
% res = 65.5; % LSB / (°/s)
% res = 65.5 / (pi /180); % LSB / (ras/s)
% imu.Gyroscope.Resolution = 1/res; % (rad/s)/LSB
% [~, gyroData] = imu(acc, angvel);
% 
% figure
% plot(t, angvel(:,1), '--', t, gyroData(:,1))
% xlabel('Time (s)')
% ylabel('Angular Velocity (rad/s)')
% title('Quantized Gyroscope Data')
% legend('x (ground truth)', 'x (gyroscope)')

rng('default')

imu = imuSensor('SampleRate', Fs, 'Gyroscope', params);
noiseDens = 0.005 * pi / 180; 
imu.Gyroscope.NoiseDensity = noiseDens; % (rad/s)/sqrt(Hz)
res = 65.5; % LSB / (°/s)
res = 65.5 / (pi /180); % LSB / (ras/s)
imu.Gyroscope.Resolution = 1/res; % (rad/s)/LSB

gyroparams

[~, gyroData] = imu(acc, angvel);

figure
plot(t, angvel(:,1), '--', t, gyroData(:,1))
xlabel('Time (s)')
ylabel('Angular Velocity (rad/s)')
title('White Noise Gyroscope Data')
legend('x (ground truth)', 'x (gyroscope)')