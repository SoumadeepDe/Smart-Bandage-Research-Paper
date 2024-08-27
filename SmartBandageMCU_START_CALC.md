If “START_CALC\r” command is received, it means that the central unit wants the smart bandage to perform measurement using the sensor nodes. As mentioned above, there are 8 sensor nodes connected to a smart bandage. The smart bandage CPU1 reads temperature (in deg C), pressure (in Pascals), humidity (in percentage), and gas resistance (in ohms) from EACH sensor node ([BME 688 SENSOR DATASHEET](https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme688-ds000.pdf)). Therefore, when the smart bandage MCU is done reading data from sensor node 0 through 7, the total data points read are 8*4 = 32 data points. This data point measurement is done by calling  “BME688_Program_Run” function. Please note that all the data points are read as integers for increased speed and reduced memory consumption.

The function in turn calls “I2C_Expander_RunSensor” function 8 times (for each sensor node), the input parameters are changed to collect data from all 8 sensor nodes serially. This function takes 2 inputs:

1)	MUX_ENABLE_PIN is set to HIGH, this powers ON the multiplexer([MUX DATASHEET](https://www.ti.com/lit/ds/symlink/tca9548a.pdf?ts=1724777111554&ref_url=https%253A%252F%252Fwww.mouser.com%252F))
2)	A delay of 50 ms is given to make sure that the multiplexer works correctly.
3)	S0_ENABLE_PIN is set to HIGH, this powers ON the sensor node 0
4)	0b00000001 is transmitted to the MUX via I2C1 peripheral, this tells the MUX that any I2C communication after this shall be transferred to channel 0 on the MUX. The table below shows the control data that needs to be sent to engage a particular sensor node:

| Sensor Node	| Control Data |
|:---:|:---:| 
| None selected	| 0b00000000 |
| 0	| 0b00000001 |
| 1	| 0b00000010 |
| 2	| 0b00000100 |
| 3	| 0b00001000 |
| 4	| 0b00010000 |
| 5	| 0b00100000 |
| 6	| 0b01000000 |
| 7	| 0b10000000 |

If ACK is not received from MUX, the MUX is restarted by powering it OFF and back ON. This is done by controlling MUX_ENABLE_PIN. This is done out of experience. Sometimes the MUX does not ACK back to the I2C communication. This restart is done 10 times, if the MUX still does not ACK, it means that the MUX is faulty and needs to be replaced. The corresponding message is sent to the UART1 port indicating the user of the fault. This is a debugging and quality control measure.

5)	Send initiate soft reset command to the sensor node.
6)	Send forced mode configuration command to sensor node
7)	Read sensor node data:
a)	Read temperature data from sensor node, do it 2 times to do running average. 
b)	Read pressure data from sensor node, do it 2 times to do running average. 
c)	Read humidity data from sensor node, do it 2 times to do running average. 
d)	Read gas resistance data from sensor node, do it 2 times to do running average. 
Note that a delay of 100ms is necessary between each measurement as it takes time for the sensor node to update the data in the corresponding register.
8)	S0_ENABLE_PIN is set to LOW, this powers OFF the sensor node 0
9)	0b00000000 is transmitted to the MUX via I2C1 peripheral to make sure no sensor node is selected.
10)	MUX_ENABLE_PIN is set to LOW, this powers OFF the multiplexer.
11)	A delay of 50 ms is given to make sure that the multiplexer works correctly.
12)	All the sensor data for sensor node 0 is returned to the “BME688_Program_Run” function.

The data points received as an output from “BME688_Program_Run” function are saved in an array.
 
Additionally, “BME688_Program_Run” function is called 7 more times. Therefore, the total number of data points come to 8 * 8 * 4 = 256 (8 times “BME688_Program_Run” function call * 8 sensor nodes * 4 data points measured per sensor). As mentioned above, after each “BME688_Program_Run” function call, the data points are stored in an array. This results in an array with a length of 256 data points. This array length is and should be inline with the data measured during the ML training stage. 
