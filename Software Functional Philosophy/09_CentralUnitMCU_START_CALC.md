If the central unit wants to issue this command, pseudo code is shown below shows the list of actions taken:
```
Number of Available Bandages variable = 0;
Number of Un-available Bandages variable = 0;
For counter=0 to counter<Number of registered smart bandages
{
  Set channel number = Array Of UDN numbers of smart bandages [counter];
  ACK reception timeout to 10ms
  Transmit “START_CALC\r”
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
    }
	  Else
    {
      Wait for 1 second and retry transmission 5 times if still don’t get an ACK:
      •	Increment Number of Un-available Bandages variable by 1
    }
  Else
  {
	  [Communication failed due to some other reason]
    Wait for 1 second and retry transmitting information 5 times, if still don’t get an ACK:
    •	Increment Number of Un-available Bandages variable by 1
  }
}
```
_Now we decide if we need to execute LOOK_FOR_LEAF command_
```
If Number of Un-available Bandages variable>0
  If Number of Available Bandages variable = 0
		[All smart bandages are lost]
		Delete all the UDN numbers stored in the array
		GO BACK TO THE DISCOVERY PHASE
  Else
    WAIT FOR 140 SECONDS [This is done so that the available smart bandages can complete performing START_CALC command] 
    [Some bandages are LOST, some or one is(are) available]
    For counterUN_AV = 0 to counterUN_AV< Number of Un-available Bandages
      For counterAV = 0 to counterAV< Number of Available Bandages
        Set channel to smart bandage with UDN number[counterAV]
        ISSUE LOOK_FOR_LEAF command to smart bandage with UDN number[counterAV] to command smart bandage with UDN number[counterUN_AV] to perform “START_CALC\r”

        If LOOK_FOR_LEAF command returned NOT EQUAL TO “0\r”
          smart bandage with UDN number[counterAV] FOUND smart bandage with UDN number[counterUN_AV]!! YAY!!
          Increment counterUN_AV counter
        End if
      End for
      If after the for loop the return value of LOOK_FOR_LEAF command is “0\r”
        [The smart bandage is NOT REACHABLE or POWERED OFF]
        Delete the smart bandage with UDN number[counterUN_AV] from the list of registered smart bandages.
      End if
    End for
  End if
	ISSUE SEND_DATA command
```
**_Brief code description:_**
When central unit wants to issue “START_CALC\r” command to all the registered smart bandages, the central unit goes through the list of registered bandages (technically, the list of UDN number(s) of the registered smart bandages) one by one; it first switches its channel to the first smart bandage channel, issues the command, the moves to next channel and issues command to the second smart bandage and so on and so forth.

Assuming there were no problems faced (the command was issued successfully to all the registered smart bandages), the central unit would move on to issuing “SEND_DATA\r” command; otherwise LOOK_FOR_LEAF command will be issued for the “LOST” smart bandage(s) to all the available smart bandages in a serial fashion; if one of the available smart bandages responds with anything other than “0\r” (meaning that the smart bandage (deputy central unit) was able to successfully issue “START_CALC\r” command to the “LOST” smart bandage), then central unit STOPS issuing LOOK_FOR_LEAF command to any further available smart bandages, else if the none of the available smart bandages return anything other than “0\r” to LOOK_FOR_LEAF command, the “LOST” smart bandage is deemed as “POWERED OFF” and is removed from the list of registered smart bandages.
