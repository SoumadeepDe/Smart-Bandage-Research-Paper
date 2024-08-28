%% Init
clc;clear; warning off
load('outPD3032.mat')
%% Downsample; round up
NumberOfDataPoints = 1000;

%3.2MHz
for i=1:8
    DownSampleBy=ceil(length(out(1,i).Results.time)/NumberOfDataPoints);
    Time(:,i) = downsample(out(1,i).Results.time,DownSampleBy);
    Temp(:,i) = downsample(out(1,i).Results.signals(1).values,DownSampleBy);
    BatterVoltage(:,i) = downsample(out(1,i).Results.signals(2).values,DownSampleBy);
    BatteryStateOfCharge(:,i) = downsample(out(1,i).Results.signals(3).values,DownSampleBy);
end

%Keep the last value
for i=1:8
    Time(NumberOfDataPoints+1,i) = out(1,i).Results.time(end);
    Temp(NumberOfDataPoints+1,i) = out(1,i).Results.signals(1).values(end);
    BatterVoltage(NumberOfDataPoints+1,i) = out(1,i).Results.signals(2).values(end);
    BatteryStateOfCharge(NumberOfDataPoints+1,i) = out(1,i).Results.signals(3).values(end);
end



%% Write Excel file
ExcelExportfilename = 'BatterySimulationResults_PD3032_1000DP.xlsx';
% Write Headings
writematrix('Time (s)',ExcelExportfilename,'Sheet',1,'Range','A1');
writematrix('MCU1_3_2MHz_BatterVoltage (V)',ExcelExportfilename,'Sheet',1,'Range','B1');
writematrix('MCU1_3_2MHz_Temp (degC)',ExcelExportfilename,'Sheet',1,'Range','C1');
writematrix('MCU1_3_2MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',1,'Range','D1');

writematrix('Time (s)',ExcelExportfilename,'Sheet',2,'Range','A1');
writematrix('MCU1_4MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',2,'Range','B1');
writematrix('MCU1_4MHz_Temp (degC)',ExcelExportfilename,'Sheet',2,'Range','C1');
writematrix('MCU1_4MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',2,'Range','D1');

writematrix('Time (s)',ExcelExportfilename,'Sheet',3,'Range','A1');
writematrix('MCU1_5_34MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',3,'Range','B1');
writematrix('MCU1_5_34MHz_Temp (degC)',ExcelExportfilename,'Sheet',3,'Range','C1');
writematrix('MCU1_5_34MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',3,'Range','D1');

writematrix('Time (s)',ExcelExportfilename,'Sheet',4,'Range','A1');
writematrix('MCU1_6_4MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',4,'Range','B1');
writematrix('MCU1_6_4MHz_Temp (degC)',ExcelExportfilename,'Sheet',4,'Range','C1');
writematrix('MCU1_6_4MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',3,'Range','D1');

writematrix('Time (s)',ExcelExportfilename,'Sheet',5,'Range','A1');
writematrix('MCU1_8MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',5,'Range','B1');
writematrix('MCU1_8MHz_Temp (degC)',ExcelExportfilename,'Sheet',5,'Range','C1');
writematrix('MCU1_8MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',3,'Range','D1');

writematrix('Time (s)',ExcelExportfilename,'Sheet',6,'Range','A1');
writematrix('MCU1_10_67MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',6,'Range','B1');
writematrix('MCU1_10_67MHz_Temp (degC)',ExcelExportfilename,'Sheet',6,'Range','C1');
writematrix('MCU1_10_67MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',3,'Range','D1');

writematrix('Time (s)',ExcelExportfilename,'Sheet',7,'Range','A1');
writematrix('MCU1_16MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',7,'Range','B1');
writematrix('MCU1_16MHz_Temp (degC)',ExcelExportfilename,'Sheet',7,'Range','C1');
writematrix('MCU1_16MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',3,'Range','D1');

writematrix('Time (s)',ExcelExportfilename,'Sheet',8,'Range','A1');
writematrix('MCU1_32MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',8,'Range','B1');
writematrix('MCU1_32MHz_Temp (degC)',ExcelExportfilename,'Sheet',8,'Range','C1');
writematrix('MCU1_32MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',3,'Range','D1');

% Write Data
for i=1:8
    writematrix(Time(:,i),ExcelExportfilename,'Sheet',i,'Range','A2');
    writematrix(BatterVoltage(:,i),ExcelExportfilename,'Sheet',i,'Range','B2');
    writematrix(Temp(:,i),ExcelExportfilename,'Sheet',i,'Range','C2');
    writematrix(BatteryStateOfCharge(:,i),ExcelExportfilename,'Sheet',i,'Range','D2');
end

%% Interpolation
DataOutput(:,1) = Time(:,1);
DataOutput(:,2) = Temp(:,1);
DataOutput(:,3) = BatterVoltage(:,1);
DataOutput(:,4) = BatteryStateOfCharge(:,1);
count = 5;
for j=2:8
    for i=1:NumberOfDataPoints+1
        if(Time(i,1)>max(Time(:,j)))
            break;
        end
    end
    timing_new_arr=Time(1:i,1);
    Temp_new_arr = interp1(Time(:,j),Temp(:,j),timing_new_arr,'spline');
    Temp_new_arr(length(Temp_new_arr): NumberOfDataPoints+1) = 0;
    DataOutput(:,count) = Temp_new_arr;
    count=count+1;

    BatterVoltage_new_arr = interp1(Time(:,j),BatterVoltage(:,j),timing_new_arr,'spline');
    BatterVoltage_new_arr(length(BatterVoltage_new_arr): NumberOfDataPoints+1) = 0;
    DataOutput(:,count) = BatterVoltage_new_arr;
    count=count+1;

    BatteryStateOfCharge_new_arr = interp1(Time(:,j),BatteryStateOfCharge(:,j),timing_new_arr,'spline');
    BatteryStateOfCharge_new_arr(length(BatteryStateOfCharge_new_arr): NumberOfDataPoints+1) = 0;
    DataOutput(:,count) = BatteryStateOfCharge_new_arr;
    count=count+1;
end

ExcelExportfilename = 'BatterySimulationResults_PD3032_1000DP_TimeInterpolation.xlsx';
% Write Headings
writematrix('Time (s)',ExcelExportfilename,'Sheet',1,'Range','A1');
writematrix('MCU1_3_2MHz_BatterVoltage (V)',ExcelExportfilename,'Sheet',1,'Range','C1');
writematrix('MCU1_3_2MHz_Temp (degC)',ExcelExportfilename,'Sheet',1,'Range','B1');
writematrix('MCU1_3_2MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',1,'Range','D1');

writematrix('MCU1_4MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',1,'Range','F1');
writematrix('MCU1_4MHz_Temp (degC)',ExcelExportfilename,'Sheet',1,'Range','E1');
writematrix('MCU1_4MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',1,'Range','G1');

writematrix('MCU1_5_34MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',1,'Range','I1');
writematrix('MCU1_5_34MHz_Temp (degC)',ExcelExportfilename,'Sheet',1,'Range','H1');
writematrix('MCU1_5_34MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',1,'Range','J1');

writematrix('MCU1_6_4MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',1,'Range','L1');
writematrix('MCU1_6_4MHz_Temp (degC)',ExcelExportfilename,'Sheet',1,'Range','K1');
writematrix('MCU1_6_4MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',1,'Range','M1');

writematrix('MCU1_8MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',1,'Range','O1');
writematrix('MCU1_8MHz_Temp (degC)',ExcelExportfilename,'Sheet',1,'Range','N1');
writematrix('MCU1_8MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',1,'Range','P1');

writematrix('MCU1_10_67MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',1,'Range','R1');
writematrix('MCU1_10_67MHz_Temp (degC)',ExcelExportfilename,'Sheet',1,'Range','Q1');
writematrix('MCU1_10_67MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',1,'Range','S1');

writematrix('MCU1_16MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',1,'Range','U1');
writematrix('MCU1_16MHz_Temp (degC)',ExcelExportfilename,'Sheet',1,'Range','T1');
writematrix('MCU1_16MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',1,'Range','V1');

writematrix('MCU1_32MHz_BatteryVoltage (V)',ExcelExportfilename,'Sheet',1,'Range','X1');
writematrix('MCU1_32MHz_Temp (degC)',ExcelExportfilename,'Sheet',1,'Range','W1');
writematrix('MCU1_32MHz_StateOfCharge (/100)',ExcelExportfilename,'Sheet',1,'Range','Y1');

% Write Data

writematrix(DataOutput,ExcelExportfilename,'Sheet',1,'Range','A2');
