ParseMemoryAllocationBug
========================

Environment:

Parse SDK 1.1.29

XCode Version 4.6 (4H127)


Overview:
This project demonstrates that Parse is not releasing all allocated memory after saveAllInBackground.


Setup:

In order to run this project, you will need to edit ParseMemoryAllocationBugAppDelegate.m and enter your own credentials
for clientKey and setApplicationId.

Details:
There are 2 buttons to cause the app to write a set of records to Parse.  One button executes a single save and the 
other button recursively executes multiple saves.  For each save a record with single note field of 3,600 bytes is 
used.

Two defines in ParseMemoryAllocationBugViewController.m control how many records are written per save (affects both
buttons) and how many saves occur (for the multi save button):

NUM_RECORDS_PER_SAVE

NUM_LOOPS_FOR_MULTI_SAVE

Run the app with Instruments (Leaks, Allocations).

I noted in an earlier version of the SDK (1.1.15) there were leaks that have apparently been cleaned up in
1.1.29. 

In the current (and earlier) version of the SDK, the Parse framework apparently does not release all memory
after a save.  Memory usage goes from 795K to 1.6Mbytes and stays there.

Increase the size of the record from 3,600 bytes to 36,000 bytes and the memory usage rises to an unreleased
steady state of 4.06 Mbytes.




