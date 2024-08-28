We have made a video detailing how we programmed the STM32WB55 MCU. [Click here](https://drive.google.com/file/d/1YXEPnsyDhuFEmH0LkoI3qICSROmOGj9Z/view?usp=drive_link) to access the video.

**_Notes:_**

1) In this paper, we used STLINK from another NUCLEO Development Board (you can see this in the video). The PIN connection (on CN4 connector) between the STLINK board and the PCB is as follows:
    | STLINK Debug Board Pin Number | PCB Pin Number | Description |
    |:---:|:---:|:---:|
    | 2 | 9 | SWCLK |
    | 3 | 10 | GND |
    | 4 |11 | SWDIO |

    The RX on the STLINK borad has to be connected to TX of the PCB and TX on the STLINK has to be connected to RX of the PCB.

2) Sometimes when programming an MCU for the first time, the CPU2 might not get programmed correctly => the MCU does not work as intended, this can be resolved by performing a full chip erase and re-programming CPU2. Please note that CPU2 needs to be programmed ONLY ONCE, after that, the user code can programmed into CPU1 memory in the usual manner (STMCubeIDE or STMCubeProgrammer).
