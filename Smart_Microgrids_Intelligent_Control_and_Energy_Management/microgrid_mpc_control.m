%% MPC Control for Microgrid Voltage Stabilization
clear; clc; close all;

% Simulation parameters
Ts = 1;                   % time step
Tsim = 50;                % total simulation time
N = Tsim / Ts;            % number of steps
t = 0:Ts:Tsim;

% System model (simplified)
A = 1; B = 0.5;           % state-space model x(k+1) = A*x + B*u
x = zeros(1,N+1);         % system voltage deviation
ref = 400;                % reference voltage
load_variation = 380 + 10*sin(0.2*pi*t); % simulated load voltage

% MPC parameters
Np = 10;                  % prediction horizon
Q = 1; R = 0.1;           % cost weights

u_opt = zeros(1,N);       % control signal (battery power)
x_meas = load_variation(1); % initial measurement

for k = 1:N
    % Prediction model setup
    x_pred = zeros(1,Np);
    u_pred = zeros(1,Np);
    
    % Simple optimization: proportional to future error
    for p = 1:Np
        error_pred = ref - load_variation(min(k+p, length(load_variation)));
        u_pred(p) = (Q/(R+Q)) * error_pred; % simplified MPC gain
        if p == 1
            x_pred(p) = A*x_meas + B*u_pred(p);
        else
            x_pred(p) = A*x_pred(p-1) + B*u_pred(p);
        end
    end
    
    % Apply the first control input
    u_opt(k) = u_pred(1);
    
    % System update
    x(k+1) = A*x_meas + B*u_opt(k);
    x_meas = load_variation(k) + 0.5*u_opt(k);
end

% Plot results
figure;
subplot(3,1,1)
plot(t, load_variation, 'r--', 'LineWidth', 1.5); hold on;
plot(t(1:end-1), x(1:end-1), 'b', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Voltage (V)');
title('Bus Voltage Regulation using MPC');
legend('Without Control','With MPC');
grid on;

subplot(3,1,2)
plot(t(1:end-1), u_opt, 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Battery Power Command');
title('MPC Control Signal');
grid on;

subplot(3,1,3)
plot(t(1:end-1), ref - x(1:end-1), 'k', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Voltage Error (V)');
title('Voltage Error Over Time');
grid on;

sgtitle('MPC-Based Voltage Control for Microgrid');
