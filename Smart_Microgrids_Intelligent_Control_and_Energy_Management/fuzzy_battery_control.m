%% Fuzzy Logic Controller for Battery Charging in a Solar Microgrid
clear; clc; close all;

% Define input variables
solar_power = 0:10:100;   % [kW]
battery_soc = 0:10:100;   % [%]

% Fuzzy sets for solar power
solar_low = trapmf(solar_power, [0 0 20 40]);
solar_med = trapmf(solar_power, [30 50 60 80]);
solar_high = trapmf(solar_power, [70 90 100 100]);

% Fuzzy sets for battery SOC
soc_low = trapmf(battery_soc, [0 0 20 40]);
soc_med = trapmf(battery_soc, [30 50 60 80]);
soc_high = trapmf(battery_soc, [70 90 100 100]);

% Define output variable (charge rate)
charge_rate = 0:10:100;
charge_low = trapmf(charge_rate, [0 0 20 40]);
charge_med = trapmf(charge_rate, [30 50 60 80]);
charge_high = trapmf(charge_rate, [70 90 100 100]);

% Define rule base (simplified)
% Rule 1: If solar is high and SOC is low -> charge high
% Rule 2: If solar is medium and SOC is medium -> charge medium
% Rule 3: If solar is low or SOC is high -> charge low

% Compute a fuzzy surface manually for visualization
[SP, SOC] = meshgrid(solar_power, battery_soc);
ChargeSurface = 0.5 * (SP/100) .* (1 - SOC/100) * 100;

% Plot fuzzy control surface
figure;
surf(SP, SOC, ChargeSurface);
xlabel('Solar Power (kW)');
ylabel('Battery SOC (%)');
zlabel('Charge Rate (%)');
title('Fuzzy Logic Control Surface for Battery Charging');
grid on;
