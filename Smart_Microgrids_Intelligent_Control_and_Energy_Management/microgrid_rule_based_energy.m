%% Energy Flow with Rule-Based Control
clear; clc; close all;

% Parameters
hours = 24;
solar_capacity = 50;
battery_capacity = 100;
battery_state = 50;  % initial battery energy
load_profile = [40 35 30 30 35 45 55 60 65 70 75 80 85 90 85 80 75 70 60 55 50 45 40 35];

% Solar generation
t = 1:hours;
solar_generation = solar_capacity * sin(pi * (t-6)/12);
solar_generation(solar_generation < 0) = 0;

% Initialize
battery_state_log = zeros(1,hours);
grid_usage = zeros(1,hours);
solar_used = zeros(1,hours);
battery_used = zeros(1,hours);

% Rule-based simulation loop
for i = 1:hours
    load_demand = load_profile(i);
    solar_power = solar_generation(i);
    
    if solar_power >= load_demand
        % Solar can supply load
        solar_used(i) = load_demand;
        surplus = solar_power - load_demand;
        charge = min(surplus, battery_capacity - battery_state);
        battery_state = battery_state + charge;
        battery_used(i) = 0;
        grid_usage(i) = 0;
    else
        % Solar cannot fully supply load
        solar_used(i) = solar_power;
        deficit = load_demand - solar_power;
        discharge = min(deficit, battery_state);
        battery_state = battery_state - discharge;
        battery_used(i) = discharge;
        grid_usage(i) = deficit - discharge;
    end
    
    battery_state_log(i) = battery_state;
end

% Plot results
figure;
subplot(4,1,1)
plot(t, solar_generation, 'b', 'LineWidth', 2); hold on;
plot(t, solar_used, 'c--', 'LineWidth', 2);
xlabel('Hour'); ylabel('Power (kW)');
title('Solar Generation vs Solar Used');
legend('Solar Generation','Solar Used');
grid on;

subplot(4,1,2)
plot(t, battery_state_log, 'LineWidth', 2, 'Color', [0.2 0.6 1]);
xlabel('Hour'); ylabel('Battery SOC (kWh)');
title('Battery State of Charge');
grid on;

subplot(4,1,3)
plot(t, battery_used, 'r', 'LineWidth', 2);
xlabel('Hour'); ylabel('Power (kW)');
title('Battery Discharge');
grid on;

subplot(4,1,4)
plot(t, grid_usage, 'm', 'LineWidth', 2);
xlabel('Hour'); ylabel('Power (kW)');
title('Power Imported from Grid');
grid on;

sgtitle('Rule-Based Energy Flow in Solar + Battery Microgrid');
