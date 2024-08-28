If “SEND_DATA\r” command is received, the central unit wants the smart bandage to send all the measured data to back to it. This is achieved as follows:

1)	Call the function implementing the ML algorithm (RunNanoEdgeAI), the function considers the array of data generated when START_CALC command was executed, as its input and returns the class based on the measured data (Please refer to ML section for more information on ML classes), and the percentage confidence on the data set classified.
2)	Package the average of the measured data from each sensor node with the ML class and percentage confidence. For example, as mentioned above, the CPU1 on smart bandage would have measured temperature from sensor node 0 8 times by the end of START_CALC command. Now, in order to calculate the average of this temperature data from sensor node 0, all the temperature data is added together and then shifted RIGHT 3 times to divide the total value by 8.
3)	Send the packaged data to the central unit:
```
If CPU2 reports TX_OK_BUSY, do nothing
{
  [means that CPU2 is still transmitting]
}
Else if CPU2 reports RX_OK_READY
{
  If the data received is ACK
  {
    Go to reception mode (COMMAND EXECUTION PHASE / DATA ACQUISITION PHASE) and stay in this mode till any data is received from the central unit MCU.
  }
  Else
  {
    Wait for 1 second and retry transmitting information 5 times, if still don’t get an ACK, go back to reception mode (COMMAND EXECUTION PHASE / DATA ACQUISITION PHASE).
    Please note that all the data still is available. Data gets overwritten if START_CALC command is received.
  }
Else if CPU2 reports RX_TIMEOUT_READY
{
  [ACK not received from central unit=>means that central unit is not in listening mode or is out of range]
  Wait for 1 second and retry transmitting information 5 times, if still don’t get an ACK, go back to reception mode (COMMAND EXECUTION PHASE / DATA ACQUISITION PHASE).
  Please note that all the data still is available. Data gets overwritten if START_CALC command is received.
}
Else
{
  [Communication failed due to some other reason]
  Wait for 1 second and retry transmitting information 5 times, if still don’t get an ACK, go back to reception mode (COMMAND EXECUTION PHASE / DATA ACQUISITION PHASE).
  Please note that all the data still is available. Data gets overwritten if START_CALC command is received.
}
```
