The LOOK_FOR_LEAF command is sent to the smart bandage MCU with the following variables:
-	The other smart bandage UDN number, marked as leaf UDN number
-	The command that the smart bandage MCU wants to send to the other smart bandage MCU, marked as <command> (the commands shall be “START_CALC\r” or “SEND_DATA\r”)

An example of this command: LOOK_FOR_LEAF 115260\nSTART_CALC\r. For the purpose of the discussion, lets assume that this command is issued to a smart bandage MCU with UDN number 3829280. Once it receives this command from central unit, it starts acting as deputy central unit and sends START_CALC command to smart bandage with UDN number 115260.

The program flow below articulates how LOOK_FOR_LEAF command is executed on a smart bandage MCU:
1)	Change channel number to leaf UDN number
2)	Set ACK reception timeout to 10ms
3)	Transmit the command
```
If CPU2 reports TX_OK_BUSY, do nothing
{
  [means that CPU2 is still transmitting]
}
Else if CPU2 reports RX_OK_READY
{
  If the data received is ACK
  {
    If <command> transmitted was “START_CALC\r”
    {
      •	switch channel number to current device UDN number
      •	set ACK timeout to 1ms
      •	transmit “1\r” to central unit
      •	go back to reception mode (COMMAND EXECUTION PHASE).
    }
    Else if <command> transmitted was “SEND_DATA\r”
    {
      •	set reception timeout to 5 seconds
      •	go into reception mode, and receive data from the other smart bandage MCU
      •	switch channel number to current device UDN number
      •	set ACK timeout to 1ms
      •	Transmit the data received from the other smart bandage MCU to the Central unit.
      •	go back to reception mode (COMMAND EXECUTION PHASE).
    }
  }
  Else
  {
    Wait for 1 second and retry transmitting information 5 times, if still don’t get an ACK:
    •	switch channel number to current device UDN number
    •	set ACK timeout to 1ms
    •	transmit “0\r” to central unit
    •	go back to reception mode (COMMAND EXECUTION PHASE).
  }
}
Else if CPU2 reports RX_TIMEOUT_READY
  {
    [ACK not received from central unit=>means that central unit is not in listening mode]
    Wait for 1 second and retry transmitting information 5 times, if still don’t get an ACK:
    •	switch channel number to current device UDN number
    •	set ACK timeout to 1ms
    •	transmit “0\r” to central unit
    •	go back to reception mode (COMMAND EXECUTION PHASE).
  }
Else
{
  [Communication failed due to some other reason]
  Wait for 1 second and retry transmitting information 5 times, if still don’t get an ACK:
  •	switch channel number to current device UDN number
  •	set ACK timeout to 1ms
  •	transmit “0\r” to central unit
  •	go back to reception mode (COMMAND EXECUTION PHASE).
}

