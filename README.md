## Instructions to enable GUI
1. Download MASM32 SDK [here](http://website.assemblercode.com/masm32/masm32v11r.zip).
1. Unzip the archive file.
1. Install the MASM32 into default directory (by default it goes under **\C:** directory; if it doesn't get installed in the default directory, **remember the directory where it was installed**).
1. in **Visual Studio**, do the following
  * Project -> ASM_Project Properties (the very bottom menu)
  * (left menu) Configuration Properties -> Linker -> Additional Library Directories
  * click Edit -> New Line (folder icon with star)
  * enter (or search for): **C:\masm32**
  * click OK -> click Apply
1. That's it! It should be working now.
