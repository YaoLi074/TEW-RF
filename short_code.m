%% Clean
clc
clear all
close all
warning off

%% Load the original data
% Iwanuma
load REQUIRED_DATA
% % REQUIRED_DATA CONTAINING:
% % 1. bldg_center: containg the longitue and latitude of interested onshore
% % location
% % 2. earthquake_scenario: containing earthquake magnitude(col:1), latitude(col:2), and
% % longitude(col:3)
% % 3. offshore_station: containing ID of the offshroe sensors
% % 4. Tsunami_loss: response variable （US$）
% % 5. wave_amplitude: containing offshore sensors recorded wave amplitude
% (m) size: 120*119*500*8. (120: waiting time duration 1-120 min; 119: 99
% offshore sensors and 20 onshore locations; 500: number of earthquake
% events; 8: 8 bin earthquake magnitude M7.5 to M9.1 with M0.2 increment)





%% Analysis options/set-up

resp_variable_type = 2 %%Choose 1 (height) or 2 (loss)
full_model = 1 %% choose 1 (99 sensors) or 2 (6 sensors)
max_time = [30] %% set maximum waiting time

%% get data
% % get response data (Tsunami loss)
res1 = max(Tsunami_loss(:),0.0001); %% get response data
    
if full_model == 1
    selected_sensors = offshore_station; %% get selected sensors
else
    selected_sensors = [71 100 53 62 101 109]  
end

% $ get explanary data

% get earthquake information
EQdata = [reshape(earthquake_scenario(:,1,:),[4000 1]) reshape(abs((earthquake_scenario(:,2,:) - bldg_center(9))),[4000 1]) reshape(earthquake_scenario(:,3,:),[4000 1])];

% get wave amplitude information
for ii = 1:length(max_time)
    time_pick = 1:max_time(ii);    
    disp(['Warning waiting duration: ',num2str(max_time(ii)),' minutes']);

    % % Regression data based on 'max_time'
    data_t1 = [];
    for jj = 1:length(selected_sensors)  
        % Collect maximum wave amplitude during the waiting time 
        if length(time_pick) == 1
            datatmp1 = abs(wave_amplitude(time_pick,selected_sensors(jj),:,:)); 
        else
            datatmp1 = max(abs(wave_amplitude(time_pick,selected_sensors(jj),:,:)));
        end
        
        data_t1 = [data_t1 reshape(datatmp1(:),[4000 1])];
        clear datatmp1        
    end
end   
data_t1e = [EQdata data_t1];%(4000,102)


%% fit RF model
% offshore sensors + earthquake

% fit RF model
rf_esfm = fitensemble(data_t1e, log(res1),'Bag',500,'Tree','Type','regression');
% prediction
rf_esfm_prediction = predict(rf_esfm, data_t1e);
% calculate MSE
mse = sum((log(res1) - rf_esfm_prediction).^2)/length(rf_esfm_prediction)
disp(['MSE of tree model2 using selected sensor with eq is  ',num2str(mse)])

figure(30) %plot simulated data vs predicted
plot(res1, exp(rf_esfm_prediction),'b.')
hold on;
x = linspace(-2,1400);y = linspace(-2,1400);plot(x,y);
axis([0 1400 0 1400])
axis square
 
% only offshore sensors

% fit RF model
rf_sfm = fitensemble(data_t1, log(res1),'Bag',500,'Tree','Type','regression');
% prediction
rf_sfm_prediction = predict(rf_sfm, data_t1);
% calculate MSE
mse = sum((log(res1) - rf_sfm_prediction).^2)/length(rf_sfm_prediction)
disp(['MSE of tree model2 using using selected sensor with no eq is  ',num2str(mse)])

figure(40) %plot simulated data vs predicted
plot(res1, exp(rf_sfm_prediction),'b.')
hold on;
x = linspace(-2,1400);y = linspace(-2,1400);plot(x,y);
axis([0 1400 0 1400])
axis square
 

 