%% Init
clc;clear;warning off;
%% Import all current profiles
disp('...Importing Current Consumption Data');
cd ./CurrentConsumptionProfile
%3.2MHz
load('Simul_SM_3_2MHz_CurrentConsumption.mat')
DataForSimulation{1,:,:}=DataForSimul;
%4MHz
load('Simul_SM_4MHz_CurrentConsumption.mat')
DataForSimulation{2,:,:}=DataForSimul;
%5.34MHz
load('Simul_SM_5_34MHz_CurrentConsumption.mat')
DataForSimulation{3,:,:}=DataForSimul;
%6.4MHz
load('Simul_SM_6_4MHz_CurrentConsumption.mat')
DataForSimulation{4,:,:}=DataForSimul;
%8MHz
load('Simul_SM_8MHz_CurrentConsumption.mat')
DataForSimulation{5,:,:}=DataForSimul;
%10.67MHz
load('Simul_SM_10_67MHz_CurrentConsumption.mat')
DataForSimulation{6,:,:}=DataForSimul;
%16MHz
load('Simul_SM_16MHz_CurrentConsumption.mat')
DataForSimulation{7,:,:}=DataForSimul;
%32MHz
load('Simul_SM_32MHz_CurrentConsumption.mat')
DataForSimulation{8,:,:}=DataForSimul;
cd ..
%% Prepare Variables
clearvars DataForSimul
%Open Model
mdl               = 'BatterySimulation';
isModelOpen       = bdIsLoaded(mdl);
open_system(mdl);

%Set Parameters
sigEditBlk = [mdl '/Repeating Sequence'];
for idx = 1:8
    in(idx) = Simulink.SimulationInput(mdl);
    set_param(mdl,'SimulationMode','Accelerator')
    %Set Time
    in(idx) = setVariable(in(idx),'time',DataForSimulation{idx,1}(:,1));
    %Set Current
    in(idx) = setVariable(in(idx),'current',DataForSimulation{idx,1}(:,2));
end
%Run batch Simulation
out = parsim(in, 'ShowSimulationManager', 'on');
%% Gather Data
disp('...Saving Simulation Data');
save("outPD3032.mat","out","-v7.3","-nocompression")
% for i = 1:8
% %Battery Life in seconds
% SimlationResults{i,1} = out(1,i).Results.time(end);
% %Battery Temperature with time
% SimlationResults{i,2} = [out(1,i).Results.time out(1,i).Results.signals(1).values];
% %Battery Voltage with time
% SimlationResults{i,3} = [out(1,i).Results.time out(1,i).Results.signals(2).values];
% %Battery SoC with time
% SimlationResults{i,4} = [out(1,i).Results.time out(1,i).Results.signals(3).values];
% end

%% Extract data
%plot(DataForSimulation{1,1}(:,1),DataForSimulation{1,1}(:,2))