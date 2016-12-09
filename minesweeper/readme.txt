GROUP 1 - MINESWEEPER

Tologon Eshminkanov (C)
Terrance Curley
Daniel Zidelis

TOTAL NUMBER OF LINES: 1053
Grid32.inc: 	668
minesweeper.asm:	385

PARTS COMPLETED BY EACH PERSON:

Tologon:
	Core parts of GUI interface
		Window Creation
		Button Mechanics
	X and Y coordinate cell referencing system
	Flood-fill algorithm for opening cells
	Timer
	Code Refactoring
	
Terrance:
	Underlying grid generation
		Randomized Mine Placement
		Calculation of Cell Values
		Displaying grid values in GUI window
	Flood-fill algorithm
		marking cells as visited
	Reset Button
	Flags & Flag Button
	Readme :)
	
Dan:
	How-to-play text
	How-to-play GUI window
	Timer
	

BUGS:
	The windows API PAINT calls stop working correctly after a cell is clicked
	This means that the timer stops updating, and the "Flag Mode" text does not
	appear when flag mode is active.
	
	We believe this is because of the interrupt system pausing the window.
	It's worth noting that resizing the window causes the timer and flag mode
	text to work correctly again, until the next button click.