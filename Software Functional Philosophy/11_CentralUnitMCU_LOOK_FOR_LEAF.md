If the central unit wants to issue this command, pseudo code is shown below shows the list of actions taken (the command format followed is as follows “LOOK_FOR_LEAF leaf UDN number\n command \r”), we will explain this command with the help of example UDN numbers previously discussed:
1)	Package the command as mentioned above, using the example mentioned earlier, let’s assume this command is to be sent to smart bandage with UDN number 3829280 to find the “LOST” smart bandage with UDN number 115260, then the packaged command transmitted with smart bandage with UDN number 3829280 (deputy central unit) shall be: “LOOK_FOR_LEAF 115260\nSTART_CALC\r”
2)	Set the channel number to the 3829280
3)	Set ACK reception time to 1ms
4)	Transmit the packaged command
Following actions are performed based on possible states reported by CPU2:

If CPU2 reports TX_OK_BUSY, do nothing
{
[means that CPU2 is still transmitting]
}
Else if CPU2 reports RX_OK_READY
{
	If the data received is ACK
    {
        •	Receive data from deputy central unit
        •	Return the data from deputy central unit to the parent function calling the LOOK_FOR_LEAF command
    }
    Else
    {
		Wait for 1 second and retry transmission
    }
}
Else
{
	[Communication failed due to some other reason]
    Wait for 1 second and retry transmission
}
 
**_Brief code description:_**
The LOOK_FOR_LEAF command will be always called from a parent command (EG: START_CALC, or SEND_DATA) function and it will be issued to an available smart bandage (deputy central unit) to find a “LOST” smart bandage. The central unit will first package the data and send it to the deputy central unit, the data received from the deputy central unit will be passed back to the command function calling the LOOK_FOR_LEAF command. Further necessary actions are programmed in the parent command function.
