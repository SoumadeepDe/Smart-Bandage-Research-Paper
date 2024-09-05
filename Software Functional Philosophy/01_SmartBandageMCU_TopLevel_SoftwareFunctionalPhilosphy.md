This section details the software programming implemented on the MCUs in the smart bandage(s). The BLE communication on central unit and Smart Bandage MCUs is implemented using LLD (Low Level Drivers). LLD APIs are used because they provide a high degree of customization of BLE parameters and give a high degree of control over how the BLE communication and user code execution are achieved. The downside to using LLD APIs is that STM32CubeMX code generation software does not support these APIs; thus all configurations described in the following section is done by C programming ([STMCubeMX Supported Projects - Page 6 of 8](https://github.com/SoumadeepDe/Smart-Bandage-Research-Paper/blob/main/Software%20Functional%20Philosophy/STM32CubeProjectsList.pdf)). The central unit follows all the same steps stated for hardware configuration and initialization for the smart bandage except GPIO and I2C initialization as these peripherals are not used by it. 

At startup (or Main PCB Power UP), the smart bandage MCU goes through the system initialization phase. In this phase, the MCU is programmed to initialize all the hardware configurations that will be used by the MCU: 
1)	Initialize the HAL Library (provided by STMicroelectronics)
2)	The system clock (SYSCLK) is programmed to run using MSI (Medium Speed Internal clock) oscillator. MSI is programmed to run at 32 MHz. This is done because in order for CPU2 to perform BLE communication it has to run at 32 MHz, however, the CPU1 speed can be varied by changing the pre-scalar (CPU1 HPRE).
    -  RF Wakeup peripheral, clock source => LSE (Low Speed External) oscillator => 32.768kHz
    -  UART1 peripheral, clock source => HSI => 16MHz
    -  LPUART1 peripheral, clock source => HSI => 16MHz
    -  I2C1 peripheral, clock source => HSI => 16MHz
5)	Initialize the system and memory channel between CPU1 and CPU2 in MCU. Start CPU2. At this point, CPU2 is now ready to receive commands from CPU1. Initialization and startup of CPU2 are performed in line with documents an5289, um2804, and rm0478(need to put these documents as reference).
6)	Initialize UART1 and LPUART1 communication peripheral of the MCU on the smart bandage; this is done to observe real-time behavior of the MCU. The settings are as follows:
    -  Baud Rate: 921600 bits/second for full speed operation
    -  Word Length: 8 bits
    -  Stop bits: 1
    -  Parity Setting: No parity
    -  Data Direction: Receive and Transmit
    -  Over Sampling: 16 samples
    -  Hardware Flow Control mode: Disabled
    -  One bit sampling mode: Disabled
    -  Clock Source Prescalar vale: Divided by 1
    -  Advanced Features: All advanced features are Disabled
    -  FIFO mode: Disabled
  
7)	Initialize all General-Purpose Input/Output (GPIO) pins used to run the TCA9548A 1:8 Multiplexer and each sensor node. These GPIO pins are used to power the MUX and the individual sensor node. This approach is taken to control the power consumption of each component therefore increasing battery life. We also initialize all the clocks used by the assigned ports. The GPIO pin settings used are as follows:
    -  Pin mode: Push Pull Mode
    -  Pullup mode: No Pull Up
    -  Pin speed: Low
  
In total 10 GPIO pins are configured in this stage, their functions are as follows:
  +  MUX_ENABLE_PIN: This pin is connected to the Vcc pin of the TCA9548A 1:8 Multiplexer. Pin used is PC2.
  +  S#_ENABLE_PIN: This pin is connected to the sensor node “#” via FFC connector, # ranges from 0 to 7 signifying 8 sensor nodes => in total 8 GPIO pins. Pins used are PA0 through PA7. Please refer to supplementary for PCB schematic drawing.
  +  ERROR_ENUNCIATOR_PIN: This pin is connected to an LED on the Main PCB; this LED is used to indicate communication failure between the smart bandage MCU and sensor node (Pin used is PC3). The table below shows the number of times the LED will blink in case of corresponding failure:

| Number of times LED blinks	| Failure type |
|:---:|:---:|
|2	| Initiate Soft Reset |
|3	| Forced Mode Configuration |
|4	| Temperature Measurement |
|5	| Pressure Measurement |
|6	| Humidity Measurement |
|7	| Gas Resistance Measurement |

8)	Initialize I2C communication peripheral of the MCU on the smart bandage to communicate with the TCA9548A 1:8 Multiplexer:
-  Initialize I2C1 specific registers with the following setting:
    -  I2C1 timing register value: 0x00707CBB
    -  Addressing Mode: 7 bit addressing 
    -  Dual address mode: Disabled
    -  General call mode: Disabled
    -  No stretch mode: Disabled
-  Initialize I2C1 specific resources, this is done by overriding HAL_MspInit function:
    -  Enable the Clock Source for port B as we are going to use port PB8 and PB9 for I2C communication
    -  Serial Clock Line (SCL) Pin settings:
    -  Selected Pin: PB8
    -  Pin operating Mode: Alternate Function of the pin is enabled in Open Drain mode
    -  Pullup mode: No Pull Up
    -  Pin speed: Low
    -  Serial DAta line (SDA) Pin settings:
    -  Selected Pin: PB9
    -  Pin operating Mode: Alternate Function of the pin is enabled in Open Drain mode
    -  Pullup mode: No Pull Up
    -  Pin speed: Low
    -  Enable the Clock Source defined in Step 3 for I2C1
