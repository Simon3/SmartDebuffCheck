SmartDebuffCheck is a simple WoW 1.12 addon to check if your target has the proper debuffs applied, taking into consideration the raid composition. 
Originally written by Snelf and currently maintained by Dekos (*Nightcall* guild, Anathema server, Elysium Project). 

The in-game command to display missing debuffs on your target is /sdc (I would advise to macro this command so you can easily use it during a fight). 

The addon is delivered ready to use, but it's also highly customisable since different guilds might optimize their debuffs in different ways. For a list of all the commands available, type /sdchelp. To display your current settings, type /sdc settings. Among others, you can choose in which channel you want to display the missing debuffs, you can toggle the display of most of the debuffs like Faerie Fire, Shadow Weaving or Nightfall, and you can even personalize your mage and warlock debuffs. Note that if you don't change anything, the addon will decide himself which debuffs should be applied base on several factors like your raid composition, the raid instance you're in or even the boss you're facing. There is also a "Trash debuffs" option that allows you to display the debuffs that should *not* be on the boss, but it's currently experimental. 

The code of the addon is pretty straightforward so advanced users should not hesitate to browse SmartDebuffCheck.lua if they think they could improve it. Among others, you could : 
- Add or remove *dangerous bosses* that require Demo Shout and Thunderclap, if using the default settings (top of the file); 
- Add or remove *allowed debuffs* for the "Trash debuffs" option (top of the file too); 
- Change the way some debuffs are handled by default, for example mage debuffs or warlock curses. 
