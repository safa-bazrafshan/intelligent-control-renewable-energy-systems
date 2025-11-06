%% Simple PID Control for Microgrid Battery Power Regulation
clear; clc; close all;

% Simulation parameters
t = 0:0.1:50;       % simulation time
ref_voltage = 400;  % reference DC bus voltage [V]
load_variation = 380 + 10*sin(0.2*pi*t); % fluctuating voltage due to load

% PID parameters
Kp = 0.8;
Ki = 0.1;
Kd = 0.05;

% Initialization
error_prev = 0;
integral = 0;
voltage_out = zeros(size(t));
battery_power = zeros(size(t));

for k = 2:length(t)
    % Measure error
    error = ref_voltage - load_variation(k);
    
    % Integrate and differentiate
    integral = integral + error * 0.1;
    derivative = (error - error_prev) / 0.1;
    
    % PID control law
    control_signal = Kp*error + Ki*integral + Kd*derivative;
    
    % Simulate system response (simplified)
    voltage_out(k) = load_variation(k) + 0.5 * control_signal;
    battery_power(k) = control_signal;
    
    % Update
    error_prev = error;
end

% Plot results
figure;
subplot(3,1,1)
plot(t, load_variation, 'r--', 'LineWidth', 1.5); hold on;
plot(t, voltage_out, 'b', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Voltage (V)');
title('Bus Voltage Regulation with PID Control');
legend('Without Control','With PID');
grid on;

subplot(3,1,2)
plot(t, battery_power, 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Control Signal');
title('Battery Power Command (PID Output)');
grid on;

subplot(3,1,3)
plot(t, ref_voltage - voltage_out, 'k', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Error (V)');
title('Voltage Error Over Time');
grid on;

sgtitle('PID-Based Voltage Control for Microgrid');
