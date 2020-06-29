# UpdateMoonlightQtGamesList
A script to automatically update the RetroPie Moonlight games list with streamable games for Moonlight Qt from the desired game stream server.

This script can be run directly from RetroPie in the Moonlight/Steam games list menu to automatically update/sync the games list with streamable games for Moonlight Qt on a desired chosen game stream server. 

What this script does is to pull available games from the desired game stream server from the /home/pi/.config/Moonlight\ Game\ Streaming\ Project/Moonlight.conf file, delete game entries made previously from the script, create a new the list of games in RetroPie and restart Emulationstation to relaod the game list.

The script, specifically the "grep"-part for fetching the games list from Moonlight is loosely inspired by https://github.com/rpf16rj/moonlight_script_retropie and too many other blogs/forum posts to mention.

Pardon any bugs, as I'm still noob in bash scripts.

Feel free to copy, modify and use as you want. The script does what it's supposed to on my home system and won't be very actively supported, updated or maintained.

# Prerequisites
- Raspberry Pi 4 with Rapbian/Linux (but should work on most Linux devices and distros that can run Moonlight Qt, as well)
- [Moonlight Qt](https://github.com/moonlight-stream/moonlight-qt)
- Latest RetroPie/Emulationstation with [Steam or other games menu folders that execute .sh-scripts](#Example-of-sh-script-games-menu-in-Emulationstation)

# Features
- Automatically update the RetroPie Moonlight games list with streamable games for Moonlight Qt on the desired game stream server.
- Can be run directly from the RetroPie Moonlight/Steam games list.
- Restarts EmulationStation to update the games list with new entries.
- Game files already present and not previously created by this script are not overwritten.
- Has a "list" parameter, like in ```./_UpdateMoonlightQtGamesList.sh list```, to only list the games on the chosen server from the command line.
- Other scripts to quit the running game and start Moonlight-QT GUI from RetroPie are included.

# Usage

1 - Make sure Moonlight Qt is installed, run at least once and paired to the desired game streaming server.

2 - Download and copy the scripts into your RetroPie Moonlight/Steam roms folder, typically "/home/pi/RetroPie/roms/moonlight-qt". Make sure they're executable. <br>
    Alternatively, in same folder, run:<BR>
    ```git clone https://github.com/Vegz78/UpdateMoonlightQtGamesList && sudo chmod +x ./UpdateMoonlightQtGamesList/_*.sh```

3 - Edit _UpdateMoonlightQtGamesList.sh with the desired global variables correct for your setup(server IP/Hostname, roms folder path etc.)

4 - Start RetroPie and navigate to the Moonlight/Steam games list menu.

5 - Run the _UpdateMoonlightQtGamesList entry.

# Example of sh script games menu in Emulationstation
Edit the file /etc/emulationstation/es_systems.cfg as loosely inspired by [TechWizTime](https://github.com/TechWizTime/moonlight-retropie).

Add something like this:
```
  <system>
    <name>Steam</name>
    <fullname>Steam</fullname>
    <path>/home/pi/RetroPie/roms/moonlight-qt</path>
    <extension>.sh .SH</extension>
    <command>%ROM%</command>
    <platform>steam</platform>
    <theme>steam</theme>
  </system>
```
