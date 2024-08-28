In order to foresee the life of smart bandage running on a battery, we developed simulation model using MATLAB/Simulink. The simulation is shown below:

![Battery Simulation Model Screenshot][BS_Screenshot]

In the simulation, we select different batteries already modeled in MATLAB/Simulink 2024a version (the battery model can be found in library under Simscape / Battery / Cells). We then load the selected battery using all the different smart bandage current consumption profiles (varying the CPU1 clock speed) discussed in the research paper. We measure the battery temperature, voltage and State of Charge (SoC).

For one simulation run, we load the current consumption profile recorded for a particular CPU1 clock speed as repeating sequence, we then let the simulation run until the SoC comes below 1% or the battery voltage drops below 3.3 V (shown in simulation stop logic). The time at which the simulation stops marks the time till the smart bandage can be run on a selected battery type.  

The simulation model and supporting files are available at: [MATLAB Simulation Model](/Battery%20Simulation/MATLAB_Simulation).

The user can run the simulation by running the [m01 file](/Battery%20Simulation/MATLAB_Simulation/m01_LaunchSimul.m). The output of the simulation is a .mat file (filename: outPD3032.mat). We are not able to upload the file in GitHub due to its size. However, the file is availabe in [Google Drive](https://drive.google.com/file/d/1Nqu55oOnl0QuLhT_wvRSx1nfoSLC379Z/view?usp=sharing). The user can choose to directly download the .mat file and run the [m02 file](/Battery%20Simulation/MATLAB_Simulation/m02_DataConditioning.m). This will generate the output excel files with [1000 data points](/Battery%20Simulation/MATLAB_Simulation/BatterySimulationResults_PD3032_1000DP.xlsx) and [time interpolated 1000 data points](/Battery%20Simulation/MATLAB_Simulation/BatterySimulationResults_PD3032_1000DP_TimeInterpolation.xlsx). The second file is used to generate the graphs pertaining to battery life.

Please note that the files in the [directory](/Battery%20Simulation/MATLAB_Simulation/CurrentConsumptionProfile/) are the **recorded current consumption (uA) of smart bandage in operation**. These files are pulled directly in the simulation model. Also, the [m01 file](/Battery%20Simulation/MATLAB_Simulation/m01_LaunchSimul.m) is written to run the same simulation for all the different clock speeds in parallel to reduce computation time. 



[BS_Screenshot]: /Battery%20Simulation/BatterySimulationPicture.png
