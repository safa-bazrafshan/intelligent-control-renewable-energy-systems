%% Q-Learning for Microgrid Battery Management
clear; clc; close all;

% Simulation parameters
T = 24; % 24-hour simulation
states = 0:10:100; % battery SOC [%]
actions = [-20 0 20]; % discharge, idle, charge [kW]
Q = zeros(length(states), length(actions)); % Q-table
alpha = 0.5; gamma = 0.9; epsilon = 0.1; % learning rate, discount, exploration
episodes = 500;

% Synthetic solar and load profiles
solar = max(0, 100*sin(pi*(1:T)/12));
load_demand = 50 + 20*sin(pi*(1:T)/12 + pi/6);

% Q-Learning loop
for ep = 1:episodes
    SOC = 50; % initial state
    for t = 1:T
        % choose action (epsilon-greedy)
        if rand < epsilon
            a_idx = randi(length(actions));
        else
            [~, a_idx] = max(Q(find(states==SOC), :));
        end
        action = actions(a_idx);
        
        % Environment update
        SOC_new = min(max(SOC + action, 0), 100);
        net_power = solar(t) + action;
        grid_power = max(0, load_demand(t) - net_power);
        
        % Reward: minimize grid use
        reward = -grid_power;
        
        % Q-Table update
        s_idx = find(states==SOC);
        s_new_idx = find(states==SOC_new);
        Q(s_idx, a_idx) = Q(s_idx, a_idx) + alpha*(reward + gamma*max(Q(s_new_idx,:)) - Q(s_idx, a_idx));
        
        SOC = SOC_new;
    end
end

% Simulate learned policy
SOC = zeros(1,T+1); SOC(1)=50;
action_history = zeros(1,T);
grid_history = zeros(1,T);
for t=1:T
    s_idx = find(states==SOC(t));
    [~, a_idx] = max(Q(s_idx,:));
    action = actions(a_idx);
    SOC(t+1) = min(max(SOC(t)+action,0),100);
    action_history(t) = action;
    net_power = solar(t) + action;
    grid_history(t) = max(0, load_demand(t)-net_power);
end

% Plot results
figure;
subplot(3,1,1)
plot(0:T, SOC,'b','LineWidth',2);
xlabel('Hour'); ylabel('Battery SOC [%]');
title('Battery State of Charge (RL)');
grid on;

subplot(3,1,2)
stairs(1:T, action_history,'LineWidth',2);
xlabel('Hour'); ylabel('Action (kW)');
title('Battery Actions (charge/discharge/idle)');
grid on;

subplot(3,1,3)
plot(1:T, grid_history,'r','LineWidth',2);
xlabel('Hour'); ylabel('Grid Power (kW)');
title('Power Imported from Grid');
grid on;
