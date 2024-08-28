The following list of actions are performed by the central unit MCU (These steps shall be read in conjuncture with Registration phase steps under the Smart Bandage Software Design):

1)	Set the Channel number to registration – discovery channel (0x4E53554C)
2)	Set data reception timeout to 5s and go into Receiving mode.
3)	Following actions are performed based on possible states reported by CPU2:
```
If CPU2 reports RX_OK_BUSY
{
  [This means that data has been received by the central unit MCU (the data is smart bandage MCU UDN) and CPU2 is now sending ACK]
  Store the smart bandage UDN number received in an array
}
Else if CPU2 reports TX_OK_READY
{
  -	Transmit the central unit UDN number to the smart bandage
  -	ISSUE START_CALC command
}
Else if CPU2 reports RX_TIMEOUT_READY or RX_CRC_KO_READY
{
[ACK was not received within the reception timeout period]
If the number of smart bandages registered > 0
  {
    [This will happen when the central unit has a few smart bandages registered and is going into discovery phase to look for any new bandages]
    ISSUE START_CALC command
  }
  Else
  {
    [There are NO registered smart bandages]
    GO BACK TO STEP 2
  }
}
```
