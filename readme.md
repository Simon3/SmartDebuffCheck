# SmartDebuffCheck

SmartDebuffCheck is a simple WoW 1.12 addon to check if your target has the proper debuffs applied, taking into consideration the raid composition and the current environment. 
Originally written by Snelf and currently maintained by Dekos (Nightcall guild, Anathema server, Elysium Project). 

![example](https://img11.hostingpics.net/pics/488511sdcexamplesmall.jpg)

The in-game command to display missing debuffs on your target is */sdc*, which default effect is illustrated on the above screenshot (I would advise to macro this command so you can easily use it during a fight). 

The addon is delivered ready to use, but it's also highly customisable since different guilds might optimize their debuffs in different ways. For a list of all the commands available, type /sdchelp. To display your current settings, type /sdc settings. Among others, you can choose in which channel you want to display the missing debuffs, you can toggle the display of most of the debuffs like Faerie Fire, Shadow Weaving or Nightfall, and you can even personalize your mage and warlock debuffs. Note that if you don't change anything, the addon will decide himself which debuffs should be applied based on several factors like your raid composition, the raid instance you're in or even the boss you're facing. There is also a "Trash debuffs" option that allows you to display the debuffs that should *not* be on the boss, but it's currently experimental. 

Here is an example of output of the */sdc* command with all the debuffs currently supported enabled (via */sdc all*), and displayed on the private "yellow chat" (via */sdc yellow*). Note that the (0) after the name of the target represents the number of debuffs currently applied on the target, excluding *Deep Wounds* and *Fireball*. 

![example](https://img11.hostingpics.net/pics/890735alldebuffs.png)

And here is a more concrete case: using the command in the beginning of the Phase 1 on C'Thun allows you to quickly figure out which debuffs are missing. For example, here you can remind your warriors that they still didn't stack 5 Sunder Armor, your warlocks that one curse is still missing, and your druids that they forgot to apply Faerie Fire. The command also shows that although it seems like all the debuff slots are currently used, 5 of them are low-priority debuffs that could be replaced by more important ones. Using /sdc later on would allow you to make sure that no debuffs are missing, and to check that no debuffs have faded so far. It's also useful to use it right before the transition to the Weakened Phase to make sure everything will be optimal for the next 45 seconds. 

![example](https://img11.hostingpics.net/pics/210276sdccthun.png)

The code of the addon is pretty straightforward so advanced users should not hesitate to browse SmartDebuffCheck.lua if they think they could improve it. Among others, you could : 
- Add or remove *dangerous bosses* that require Demo Shout and Thunderclap, if using the default settings; 
- Same for *Nightfall bosses*, *Dragonling bosses* and some other default settings; 
- Add or remove *allowed debuffs* for the "Trash debuffs" option; 
- Add new supported debuffs, or change the way some debuffs are handled by default, for example mage debuffs or warlock curses. 

## How to install
You can download the archive via Github by clicking on *Clone or Download* -> *Download ZIP*. Then you will need to extract it, remove the *-master* at the end of the name of the folder, and finally move it to your WoW/Interface/AddOns folder. 
