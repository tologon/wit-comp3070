GROUP 1 - MINESWEEPER
________________________________________________________________________________
TEAM MEMBERS:
Tologon Eshminkanov (C)
Terrance Curley
Daniel Zidelis
________________________________________________________________________________
TOTAL NUMBER OF LINES: 1089
Grid32.inc: 	667
minesweeper.asm:	422
________________________________________________________________________________
PARTS COMPLETED BY EACH PERSON:
Tologon:
* Core parts of GUI interface
  * Window Creation
	* Button Mechanics
* X and Y coordinate cell referencing system
* Flood-fill algorithm for opening cells
* Timer
* Code Refactoring

Terrance:
* Underlying grid generation
  * Randomized Mine Placement
	* Calculation of Cell Values
	* Displaying grid values in GUI window
* Flood-fill algorithm
	* Marking cells as visited
* Reset Button
  * Flags & Flag Button
	* Readme :)

Daniel:
* How-to-play text
* How-to-play GUI window
* Timer
________________________________________________________________________________
BUGS:
1.  The windows API PAINT calls stop working correctly after a cell is clicked
    This means that the timer stops updating, and the "Flag Mode" text does not
    appear when flag mode is active.

2.  We believe this is because of the interrupt system pausing the window.
    It's worth noting that resizing the window causes the timer and flag mode
    text to work correctly again, until the next button click.
