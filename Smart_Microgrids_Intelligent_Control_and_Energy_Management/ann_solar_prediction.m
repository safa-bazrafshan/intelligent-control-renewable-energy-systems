%% ANN for Solar Power Prediction
clear; clc; close all;

% Generate synthetic dataset
time = linspace(0, 24, 200)';              % time of day [hours]
temperature = 15 + 10*sin(pi*time/12);     % temperature profile
solar_power = max(0, 100*sin(pi*time/12)); % idealized solar curve

X = [time temperature]';
T = solar_power';

% Split data
trainInd = 1:150; testInd = 151:200;
Xtrain = X(:,trainInd); Ttrain = T(trainInd);
Xtest  = X(:,testInd);  Ttest  = T(testInd);

% Create and train neural network
net = feedforwardnet(10); % 10 neurons in hidden layer
net.trainParam.showWindow = false; % silent training
net = train(net, Xtrain, Ttrain);

% Predict
predicted = net(Xtest);

% Plot results
figure;
plot(time(trainInd), Ttrain, 'b', 'LineWidth', 2); hold on;
plot(time(testInd), Ttest, 'r--', 'LineWidth', 1.5);
plot(time(testInd), predicted, 'k', 'LineWidth', 2);
xlabel('Time of Day (h)');
ylabel('Solar Power (kW)');
title('ANN-Based Solar Power Prediction');
legend('Training Data','True Test Data','Predicted');
grid on;
