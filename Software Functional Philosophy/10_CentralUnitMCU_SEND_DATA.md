If the central unit wants to issue this command, pseudo code is shown below shows the list of actions taken:
```
Number of Available Bandages variable = 0;
Number of Un-available Bandages variable = 0;
For counter=0 to counter<Number of registered smart bandages
{
    Set channel number = Array Of UDN numbers of smart bandages [counter];
    ACK reception timeout to 10ms
    Transmit “SEND_DATA\r”
    Following actions are performed based on possible states reported by CPU2:
    If CPU2 reports TX_OK_BUSY, do nothing
    {
    [means that CPU2 is still transmitting]
    }
    Else if CPU2 reports RX_OK_READY
    {
	    If the data received is ACK
        {
        •	Increment Number of Available Bandages variable by 1
        •	Set data reception time to 5 seconds
        •	Receive data from the smart bandage MCU
        •	Send the data to Edge device
        }
	    Else
        {
			Wait for 1 second and retry transmission 5 times if still don’t get an ACK:
            •	Increment Number of Un-available Bandages variable by 1
        }
    }
    Else
    {
	    [Communication failed due to some other reason]
        Wait for 1 second and retry transmitting information 5 times, if still don’t get an ACK:
        •	Increment Number of Un-available Bandages variable by 1
    }
}
```
_---Now we decide if we need to execute LOOK_FOR_LEAF command_
```
If Number of Un-available Bandages variable>0
	If Number of Available Bandages variable = 0
		[All smart bandages are lost]
		Delete all the UDN numbers stored in the array
		GO BACK TO THE DISCOVERY PHASE
	Else
		[Some bandages are LOST, some or one is(are) available]
		For counterUN_AV = 0 to counterUN_AV< Number of Un-available Bandages
			For counterAV = 0 to counterAV< Number of Available Bandages
                Set channel to smart bandage with UDN number[counterAV]
                ISSUE LOOK_FOR_LEAF command to smart bandage with UDN number[counterAV] to command smart bandage with UDN number[counterUN_AV] to perform “SEND_DATA\r”

                If LOOK_FOR_LEAF command returned NOT EQUAL TO “0\r”
                smart bandage with UDN number[counterAV] FOUND smart bandage with UDN number[counterUN_AV]!! YAY!!
                Increment counterUN_AV counter
                Send data received from smart bandage with UDN number[counterAV] to the Edge device
                End if
			End for
            If after the for loop the return value of LOOK_FOR_LEAF command is “0\r”
				[The smart bandage is NOT REACHABLE or POWERED OFF]
                Delete the smart bandage with UDN number[counterUN_AV] from the list of registered smart bandages.
			End if
		End for
	End if
GO BACK TO DISCOVERY MODE
```
**_Brief code description:_**
When central unit wants to issue “SEND_DATA\r” command to all the registered smart bandages, the central unit goes through the list of registered bandages (technically, the list of UDN number(s) of the registered smart bandages) one by one:
-	Issue “SEND_DATA\r” command
-	Receive data from the smart bandage
-	Send this data to edge device
-	Go through this chain of events for all registered available smart bandages.

Assuming there were no problems faced, the central unit would move on to discovery phase; otherwise LOOK_FOR_LEAF command will be issued for the “LOST” smart bandage(s) to all the available smart bandages in a serial fashion; if one of the available smart bandages responds with anything other than “0\r” (meaning that the smart bandage (deputy central unit) was able to successfully issue “SEND_DATA\r” command and receive sensor node data, ML data from the “LOST” smart bandage, this data will be passed on to the central unit which will be passed onto the edge device), then central unit STOPS issuing LOOK_FOR_LEAF command to any further available smart bandages, else if the none of the available smart bandages return anything other than “0\r” to LOOK_FOR_LEAF command, the “LOST” smart bandage is deemed as “POWERED OFF” and is removed from the list of registered smart bandages.
