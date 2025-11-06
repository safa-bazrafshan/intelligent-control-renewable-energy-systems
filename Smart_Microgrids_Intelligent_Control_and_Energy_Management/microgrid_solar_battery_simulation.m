%% Simple Solar + Battery Microgrid Simulation
clear; clc; close all;

% Parameters
hours = 24;                         % Simulation period (24 hours)
solar_capacity = 50;                % Max solar power [kW]
battery_capacity = 100;             % Battery capacity [kWh]
battery_state = 50;                 % Initial battery energy [kWh]
load_profile = [40 35 30 30 35 45 55 60 65 70 75 80 85 90 85 80 75 70 60 55 50 45 40 35]; % hourly load [kW]

% Generate simple solar power curve (sunrise to sunset)
t = 1:hours;
solar_generation = solar_capacity * sin(pi * (t-6)/12);
solar_generation(solar_generation < 0) = 0; % no negative power

% Initialize storage
battery_state_log = zeros(1, hours);
grid_usage = zeros(1, hours);

% Simulation loop
for i = 1:hours
    net_power = solar_generation(i) - load_profile(i);
    
    if net_power > 0
        % Extra power: charge battery
        charge = min(net_power, battery_capacity - battery_state);
        battery_state = battery_state + charge;
        grid_usage(i) = 0;
    else
        % Deficit: discharge battery or import from grid
        discharge = min(-net_power, battery_state);
        battery_state = battery_state - discharge;
        grid_usage(i) = (-net_power) - discharge;
    end
    
    battery_state_log(i) = battery_state;
end

% Plot results
figure;
subplot(3,1,1)
plot(t, solar_generation, 'LineWidth', 2); hold on;
plot(t, load_profile, 'LineWidth', 2);
xlabel('Hour'); ylabel('Power (kW)');
title('Solar Generation vs Load Profile');
legend('Solar Generation','Load');
grid on;

subplot(3,1,2)
plot(t, battery_state_log, 'LineWidth', 2, 'Color', [0.2 0.6 1]);
xlabel('Hour'); ylabel('Energy (kWh)');
title('Battery State of Charge');
grid on;

subplot(3,1,3)
plot(t, grid_usage, 'LineWidth', 2, 'Color', [1 0.4 0.4]);
xlabel('Hour'); ylabel('Power (kW)');
title('Power Imported from Grid');
grid on;

sgtitle('Simple Microgrid Simulation (Solar + Battery)');
