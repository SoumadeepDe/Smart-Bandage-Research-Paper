Once the Registration phase is completed, the smart bandage MCU goes to Command Execution phase:
1)	Change the channel number to device UDN.
2)	Go to reception mode and stay in this mode till any data is received from the central unit MCU.
3)
```
If data is received from the central unit
{
  Save the data and wait for CPU2 to report TX_OK_READY
}
Else
{
  Go to Step 2
}
```
4)
```
If CPU2 reports TX_OK_READY
{
  Go to Step 5
}
Else
{
  Communication failed, go back to Step 2
}
```
6)
```
If data received is “START_CALC\r”
{
  Please refer to section on START_CALC command
}
Else if data received is “SEND_DATA\r”
{
  Please refer to section on SEND_DATA command
}
Else if data received is “LOOK_FOR_LEAF <leaf UDN number>\n<command>\r”
{
  Please refer to section on LOOK_FOR_LEAF” command
}
```
