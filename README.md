# GH_to_Matlab
This repository intends to share some scripts devoted to communication between Grasshopper3d and Matlab.
It makes use of the *User Datagram Protocol* (UDP), which is easy to set-up and is implemented in many commercial softwares.

# Prerequisites
The scripts make use of two external libraries that handle the UDP communication routine.

## gHowl for Grasshopper 
gHowl is a GH library that implements severall components suited for communication between apps.
It can be downloaded from the [Food4Rhino website](http://www.food4rhino.com/app/ghowl) or from the [GitHub repository](https://github.com/gHowl/gHowlComponents).
In the examples of the repository, only the two components *UDP Sender* and *UDP Listener* are used. 
A number of GH libraries implements the UDP protocol (ex. [Firefly](http://www.food4rhino.com/app/firefly)), but gHowl components have proven to be robust.

## JUDP for Matlab
JUDP is a simple .m Matlab script wirtten by Kevin Barlett that implements UDP communication functions. It can be downloaded from the [MathWorks website](https://fr.mathworks.com/matlabcentral/fileexchange/24525-a-simple-udp-communications-application?focused=5148131&tab=function). It is included in this repository, as it has to be included in the MATALAB working directory in order to be called.
