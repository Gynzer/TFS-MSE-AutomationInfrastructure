# Bginfo_Automated_Windwos_Server_2016_2019 Installation

## Description

This script was written by Wim Matthyssen as a means to quickly install a standard BGInfo installation on Windows servers.

The script **BgInfo_Automated_Windows_Server_2016_2019.ps1** is basically as it was found on the Internet.   To run it required a connection to the Internet and you must run it with an elevated ID.   There is no additional syntax, simply run it as it is configured.   There are a few minor variables that can be adjusted, but they do not need to be changed.

The script **BgInfo_Automated_Windows_Server_2016_2019-redzone.ps1** has been modified to work within the Thermo Fisher Scientific environment at the USSLO location where an iDMZ has been implmented to separate OT servers from the business network.   The Internet is not available to the redzone and therefore changes had to be made.