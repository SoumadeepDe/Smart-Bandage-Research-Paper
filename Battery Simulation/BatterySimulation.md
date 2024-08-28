In order to foresee the life of smart bandage running on a battery, we developed simulation model using MATLAB/Simulink. The simulation is shown below:

![Battery Simulation Model Screenshot](/BattterySimulationPicture.png)

In the simulation, we select different batteries already modeled in MATLAB/Simulink 2024a version (the battery model can be found in library under Simscape / Battery / Cells). We then load the selected battery using all the different smart bandage current consumption profiles (varying the CPU1 clock speed) discussed in the previous section. We measure the battery temperature, voltage and State of Charge (SoC).

For one simulation run, we load the current consumption profile recorded for a particular CPU1 clock speed as repeating sequence, we then let the simulation run until the SoC comes below 1% or the battery voltage drops below 3.3 V (shown in simulation stop logic). The time at which the simulation stops marks the time till the smart bandage can be run on a selected battery type.  

