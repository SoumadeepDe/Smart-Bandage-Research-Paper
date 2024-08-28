At this point, all the hardware configuration on the smart bandage MCU is complete. Now, the MCU goes into the Registration Phase. In this phase, the smart bandage MCU continuously tries to register itself to the central unit MCU.
The following list of actions are performed by the smart bandage MCU (These steps shall be read in conjuncture with Discovery phase steps under the Central Unit Software Design):

1)	Set the Channel number to registration – discovery channel (0x4E53554C)
2)	Set ACK reception timeout to 1ms
3)	Send smart bandage MCU UDN (Unique Device Number, 32 bit number):
```
If CPU2 reports TX_OK_BUSY, do nothing
{
  [means that CPU2 is still transmitting]
}
Else if CPU2 reports RX_OK_READY
{
  If the data received is ACK
  {
    Set reception timeout time to 5 seconds
    Go into receiving mode (step 4)
  }
  Else
  {
    Wait for 1 second
    Communication failed, retry transmission
  }
}
Else if CPU2 reports RX_TIMEOUT_READY [ACK not received from central unit=>means that central unit is not in listening mode]
{
  Wait for 1 second
 Communication failed, retry transmission
}
Else
{
  [Communication failed due to some other reason]
  Wait for 1 second
  Communication failed, retry transmission
}
```
5)	Receive central unit MCU UDN
```
If CPU2 reports RX_OK_BUSY
{
  Inform the user that the smart bandage is successfully registered.
}
Else if CPU2 reports TX_OK_READY
{
  GO TO COMMAND EXECUTION PHASE / DATA ACQUISITION PHASE
}
```
The device UDN (Unique Device Number) is unique to each MCU. The purpose of sending smart bandage UDN is so that the central unit MCU can uniquely identify each bandage and thus targeted communication towards a particular smart bandage MCU can be achieved.
If central unit MCU is not in Discovery mode (central unit MCU is busy or is communicating with other some other smart bandage MCU), the communication will fail (CPU2 will report RX_TIMEOUT_READY status), in that case, smart bandage MCU is programmed to retry transmission and it continues to do so till it receives ACK from central unit MCU.
