-- Global variables, saved between sessions (initialized in reset_settings())
useSay, useRaid, useYellow = nil, nil, nil -- where to display results of /sdc queries
displayTrash = nil -- if you want to display trash debuffs
displayFF, displaySW = nil, nil
defaultScorch, displayScorch, displayWC = nil, nil, nil
defaultNightfall, displayNightfall = nil, nil
customCurses, displayCoR, displayCoE, displayCoS = nil, nil, nil, nil
defaultDemo, displayDemo, defaultTC, displayTC = nil, nil, nil, nil
defaultDragonling, displayDragonling = nil, nil -- Dragonling's Flame Buffets

local allowed_debuffs = {
	"Interface\\Icons\\Ability_Physical_Taunt", -- taunt
	"Interface\\Icons\\Ability_Warrior_Punishingblow", -- Coup railleur
	"Interface\\Icons\\Spell_Shadow_ShadowBolt", -- ISB
	"Interface\\Icons\\Spell_Shadow_AbominationExplosion", -- Corruption
	"Interface\\Icons\\Spell_Shadow_ScourgeBuild", -- Shadowburn
	"Interface\\Icons\\Spell_Shadow_SiphonMana", -- Mindflay
	"Interface\\Icons\\Spell_Shadow_UnsummonBuilding", -- Vamp Embrace
	"Interface\\Icons\\Spell_Nature_ThunderClap", -- TC
	"Interface\\Icons\\Ability_BackStab", -- Deep Wounds
	"Interface\\Icons\\Spell_Fire_FlameBolt", -- Fireball
	"Interface\\Icons\\Spell_Nature_Cyclone", -- Thunderfury
	"Interface\\Icons\\Spell_Fire_Incinerate", -- Ignite
	"Interface\\Icons\\Spell_Shadow_ShadowWordPain", -- SW:P
	"Interface\\Icons\\INV_Axe_12", -- Annihilator stacks
	"Interface\\Icons\\Ability_Hunter_AimedShot", -- Hunter's mana drain
	"Interface\\Icons\\Spell_Shadow_SiphonMana", -- Warlock's mana drain
	--"Interface\\Icons\\Ability_Hunter_SniperShot", -- Hunter's Mark
	--"Interface\\Icons\\Ability_GhoulFrenzy", -- Druid's Rip
} 

local dangerous_bosses = {"Princess Huhuran", "Emperor Vek'nilash", "Ouro", "Ossirian the Unscarred", "Broodlord Lashlayer", "Chromaggus", "Nefarian", "Elder Mottled Boar",}
local nightfall_bosses = {"C'Thun", "Princess Huhuran", "Magmadar", "Baron Geddon", "Shazzrah",}
local dragonling_bosses = {"Eye of C'Thun", "C'Thun", "Ouro", "Fankriss the Unyielding", "Shazzrah", "High Priestess Arlokk", "Moam",}
local no_scorches_bosses = {"Ossirian the Unscarred",}
local no_scorches_instances = {"Molten Core", "Blackwing Lair", "Onyxia\'s Lair",}

function SDC_OnLoad()
	reset_settings()
	DEFAULT_CHAT_FRAME:AddMessage("SmartDebuffCheck v1.4 by Dekos & Snelf loaded. /sdchelp for more info", 1, 1, 0)
	SlashCmdList["SDCHELP"] = SDCHelp
	SLASH_SDCHELP1 = "/sdchelp"
	SlashCmdList["SDC"] = SmartDebuffCheck
	SLASH_SDC1 = "/sdc"
end

function SDCHelp()
	SDCChat("[SmartDebuffCheck] List of the commands: ")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc")
	SDCChat("Checks for missing debuffs on your target, based on raid composition. When outside a raid group it checks for all debuffs. ")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc settings")
	SDCChat("Displays current settings")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc reset")
	SDCChat("Reset settings to their default value")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc say | raid | yellow | last")
	SDCChat("Sets the channel to display results of /sdc. By default, it will be /s only. You can se it to the default yellow chat frame, or to the last chat frame used. ")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc trash")
	SDCChat("Toggles the display of trash debuffs (default: OFF)")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc curses default | cor &| coe &| cos | nothing")
	SDCChat("Sets the display of warlock curses. By default, it prioritizes CoR > CoE > CoS. Example : '/sdc curses coe cos' if you don't want to use CoR")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc scorch(es) default | always | never")
	SDCChat("Sets the display of mage debuffs to default: it will display Scorches only, and only if you're not in MC/BWL/Onyxia. ")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc wc")
	SDCChat("Toggles the display of mage Winter's Chill")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc ff")
	SDCChat("Toggles the display of Faerie Fire (default: ON)")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc sw")
	SDCChat("Toggles the display of Shadow Weaving (default: ON)")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc demo default | always | never")
	SDCChat("Sets the display of Demoralizing Shout. By default, it only displays it on some dangerous bosses. ")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc tc default | always | never")
	SDCChat("Sets the display of Thunderclap. By default, it only displays it on some dangerous bosses. ")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc nf default | always | never")
	SDCChat("Sets the display of Nightfall (default: OFF, except on some bosses)")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc dragonling default | always | never")
	SDCChat("Sets the display of the Dragonling's debuffs (default: OFF, except some bosses)")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc all")
	SDCChat("Sets the display of every debuff to true (you should probably not use this command)")
end

function SDCChat(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0)
end

function wrong_command()
	SDCChat("[SmartDebuffCheck] Command not matching any keyword...")
end

-- Default values
function reset_settings()
	useSay = true
	useRaid = false
	useYellow = false
	displayTrash = false
	displayFF = true
	displaySW = true
	defaultScorch = true
	displayScorch = false
	displayWC = false
	customCurses = false
	displayCoR = false
	displayCoE = false
	displayCoS = false 
	defaultDemo = true
	displayDemo = false
	defaultTC = true
	displayTC = false
	defaultNightfall = true
	displayNightfall = false
	defaultDragonling = true
	displayDragonling = false
end

function all_true()
	displayFF = true
	displaySW = true
	defaultScorch = false
	displayScorch = true
	displayWC = true
	customCurses = true
	displayCoR = true
	displayCoE = true
	displayCoS = true
	defaultDemo = false
	displayDemo = true
	defaultTC = false
	displayTC = true
	defaultNightfall = false
	displayNightfall = true
	defaultDragonling = false
	displayDragonling = true
end

function settings(msg)
	if msg == nil or string.len(msg) < 2 then wrong_command() -- empty command
	elseif msg == "settings" then do end -- do nothing, settings will be displayed anyway, but no 'wrong command' message
	elseif msg == "reset" then reset_settings()
	elseif msg == "all" then all_true()
	elseif msg == "say" then useSay = true; useRaid = false; useYellow = false
	elseif msg == "raid" then useRaid = true; useSay = false; useYellow = false
	elseif msg == "yellow" then useYellow = true; useSay = false; useRaid = false
	elseif msg == "last" then useSay = false; useRaid = false; useYellow = false
	elseif msg == "trash" then displayTrash = not displayTrash
	elseif msg == "ff" or msg == "faerie fire" then displayFF = not displayFF
	elseif msg == "sw" or msg == "shadow weaving" then displaySW = not displaySW

	elseif first_word(msg) == "curses" then
		if string.find(msg, "default") then customCurses = false
		else
			found = false
			if string.find(msg, "cor") then displayCoR = not displayCoR; found = true end
			if string.find(msg, "coe") then displayCoE = not displayCoE; found = true end
			if string.find(msg, "cos") then displayCoS = not displayCoS; found = true end
			
			if not found and not string.find(msg, "nothing") then wrong_command()
			else customCurses = true
			end
		end
	elseif first_word(msg) == "scorch" or first_word(msg) == "scorches" or first_word(msg) == "scorch(es)" then
		if second_word(msg) == "default" then defaultScorch = true
		elseif second_word(msg) == "always" then defaultScorch = false; displayScorch = true
		elseif second_word(msg) == "never" then defaultScorch = false; displayScorch = false
		else wrong_command() 
		end
	elseif msg == "wc" or msg == "winter" then displayWC = not displayWC

	elseif string.find(msg, "demo") or string.find(msg, "demo shout") or string.find(msg, "demoralizing shout") then
		if string.find(msg, "default") then defaultDemo = true
		elseif string.find(msg, "always") then
			defaultDemo = false
			displayDemo = true
		elseif string.find(msg, "never") then
			defaultDemo = false
			displayDemo = false
		end
	elseif string.find(msg, "tc") or string.find(msg, "thunder") or string.find(msg, "thunderclap") then
		if string.find(msg, "default") then defaultTC = true
		elseif string.find(msg, "always") then
			defaultTC = false
			displayTC = true
		elseif string.find(msg, "never") then
			defaultTC = false
			displayTC = false
		end
		
	elseif first_word(msg) == "nf" or first_word(msg) == "nightfall" then 
		if second_word(msg) == "default" then defaultNightfall = true
		elseif second_word(msg) == "always" then defaultNightfall = false; displayNightfall = true
		elseif second_word(msg) == "never" then defaultNightfall = false; displayNightfall = false
		else wrong_command()
		end

	elseif first_word(msg) == "dragonling" or first_word(msg) == "dl" then
		if second_word(msg) == "default" then defaultDragonling = true
		elseif second_word(msg) == "always" then defaultDragonling = false; displayDragonling = true
		elseif second_word(msg) == "never" then defaultDragonling = false; displayDragonling = false
		else wrong_command()
		end

	else wrong_command()
	end

	current = "[SmartDebuffCheck] Current settings: "
	current = current .. "Channel: "
	if useSay then current = current .. "Say, "
	elseif useRaid then current = current .. "Raid, "
	elseif useYellow then current = current .. "Yellow, "
	else current = current .. "Last" .. ", "
	end
	current = current .. "Trash: " .. tostring(displayTrash) .. ", "
	current = current .. "FF: " .. tostring(displayFF) .. ", "
	current = current .. "SW: " .. tostring(displaySW) .. ", "

	current = current .. "Curses: "
	if not customCurses then current = current .. "default, "
	else current = current .. "CoR=" .. tostring(displayCoR) .. ", CoE=" .. tostring(displayCoE) .. ", CoS=" .. tostring(displayCoS) .. ", "
	end
	current = current .. "Scorches: "
	if defaultScorch then current = current .. "default, "
	else current = current .. tostring(displayScorch) .. ", "
	end
	current = current .. "WC: " .. tostring(displayWC) .. ", "
	current = current .. "Demo: "
	if defaultDemo then current = current .. "default, "
	elseif displayDemo then current = current .. "always, "
	else current = current .. "never, "
	end
	current = current .. "TC: "
	if defaultTC then current = current .. "default, "
	elseif displayTC then current = current .. "always, "
	else current = current .. "never, "
	end

	current = current .. "Nightfall: "
	if defaultNightfall then current = current .. "default, "
	else current = current .. tostring(displayNightfall) .. ", "
	end
	current = current .. "Dragonling: "
	if defaultDragonling then current = current .. "default. "
	else current = current .. tostring(displayDragonling) .. ". "
	end

	SDCChat(current)
end

function SmartDebuffCheck(msg)
	if msg ~= nil and msg ~= "" then 
		settings(string.lower(msg))
		return
	end
	local haveShadow = false -- if you want to check for SP debuffs all the time, regardless of the fact that he is alive, in shadow form etc.
	local spriest, druid, mage, warrior, warlock, warlockno = haveShadow, false, false, false, false, 0
	local num, raid = GetNumRaidMembers(), "raid"
	if num == 0 then num, raid = GetNumPartyMembers(), "party" end
	if num == 0 then -- not in a party or raid, display all debuffs
		spriest, druid, mage, warrior, warlock, warlockno = true, true, true, true, true, 3
	else 
		for i = 1, num do
			if UnitClass(raid..i) == "Priest" and not spriest and UnitIsConnected(raid..i) then
				j = 1
				while UnitBuff(raid..i, j) ~= nil do
					if UnitBuff(raid..i, j) == "Interface\\Icons\\Spell_Shadow_Shadowform" and not UnitIsDeadOrGhost(raid..i) then
						spriest = true
						break
					end
					j = j + 1
				end
			elseif UnitClass(raid..i) == "Druid" and UnitIsConnected(raid..i) and not UnitIsDeadOrGhost(raid..i) then
				druid = true
			elseif UnitClass(raid..i) == "Warrior" and UnitIsConnected(raid..i) and not UnitIsDeadOrGhost(raid..i) then
				warrior = true
			elseif UnitClass(raid..i) == "Mage" and UnitIsConnected(raid..i) and not UnitIsDeadOrGhost(raid..i) then
				mage = true
			elseif UnitClass(raid..i) == "Warlock" and UnitIsConnected(raid..i) and not UnitIsDeadOrGhost(raid..i) then
				warlock = true
				warlockno = warlockno + 1
			end
		end
	end
	
	if UnitExists("target") and UnitCanAttack("target", "player") then
		CoS, CoE, CoR, FF, Scorch, SW, SA, WC, Demo, TC, Nightfall, Dragonling = false, false, false, false, false, false, false, false, false, false, false, false
		ScorchN, WCN, SWN, SAN, DragonlingN = 0, 0, 0, 0, 0
		i = 1
		trashN = 0
		t = "Trash debuffs:"
		while UnitDebuff("target", i) do
			db, stack = UnitDebuff("target",i)
			if db == "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde" then
				CoS = true
			elseif db == "Interface\\Icons\\Spell_Shadow_ChillTouch" then
				CoE = true
			elseif db == "Interface\\Icons\\Spell_Shadow_UnholyStrength" then
				CoR = true
			elseif db == "Interface\\Icons\\Spell_Nature_FaerieFire" then
				FF = true
			elseif db == "Interface\\Icons\\Spell_Fire_SoulBurn" then
				Scorch = true
				ScorchN = stack
			elseif db == "Interface\\Icons\\Spell_Frost_ChillingBlast" then
				WC = true
				WCN = stack
			elseif db == "Interface\\Icons\\Spell_Shadow_BlackPlague" then
				SW = true
				SWN = math.max(SWN, stack) -- since Devouring Plague has the same icon... can't differentiate them. 
			elseif db == "Interface\\Icons\\Ability_Warrior_WarCry" then
				Demo = true
			elseif db == "Interface\\Icons\\Spell_Nature_ThunderClap" then
				TC = true
			elseif db == "Interface\\Icons\\Spell_Holy_ElunesGrace" then
				Nightfall = true
			elseif db == "Interface\\Icons\\Ability_Warrior_Sunder" then
				SA = true
				SAN = stack
			elseif db == "Interface\\Icons\\Spell_Fire_Fireball" then
				Dragonling = true
				DragonlingN = stack
			elseif not has_value(allowed_debuffs, db) then
				t = t.." "..i..": "..string.sub(db, 17, -1)..","
			end
			i = i + 1
			if db == "Interface\\Icons\\Ability_BackStab" or db == "Interface\\Icons\\Spell_Fire_FlameBolt" then
				trashN = trashN + 1
			end
		end
		i = i - 1
		t = string.sub(t, 1, -2).."."
		
		-- Handle missing debuffs
		local target = UnitName("target")
		s = target.." ("..(i-trashN)..") is missing"
		
		if warrior then
			if not SA then 
				s = s.." 5xSunder," 
			elseif SAN < 5 then 
				s = s.." "..(5 - SAN).."xSunder," 
			end
			
			if not defaultDemo and displayDemo or defaultDemo and has_value(dangerous_bosses, target) then
				if not Demo then s = s.." Demo Shout," end
			end
			if not defaultTC and displayTC or defaultTC and has_value(dangerous_bosses, target) then
				if not TC then s = s.." Thunderclap," end
			end
		end

		if warlock then
			if customCurses then
				if displayCoR then
					if not CoR then s = s.." CoR," end
				end
				if displayCoE then
					if not CoE then s = s.." CoE," end
				end
				if displayCoS then
					if not CoS then s = s.." CoS," end
				end
			else
				if not CoR then s = s.." CoR," end
				if warlockno == 2 then
					if mage then
						if not CoE then s = s.." CoE," end
					else
						if not CoS then s = s.." CoS," end
					end
				elseif warlockno >= 3 then
					if mage then
						if not CoE then s = s.." CoE," end
					end
					if not CoS then s = s.." CoS," end
				end
			end
		end
		
		if mage then
			if defaultScorch and not has_value(no_scorches_instances, GetRealZoneText()) and not has_value(no_scorches_bosses, target) or not defaultScorch and displayScorch then
				if not Scorch then
					s = s.." 5xScorch,"
				elseif ScorchN < 5 then
					s = s.." "..(5 - ScorchN).."xScorch,"
				end
			end
			if displayWC then
				if not WC then
					s = s.." 5xWinter's Chill,"
				elseif WCN < 5 then
					s = s.." "..(5 - WCN).."xWinter's Chill,"
				end
			end
		end

		if displaySW and spriest then 
			if not SW then 
				s = s.." SW," 
			elseif SWN and SWN < 5 then
				s = s.." "..(5 - SWN).."xSW,"
			end
		end
		if displayFF and druid and not FF then s = s.." Faerie Fire," end
		
		if not defaultNightfall and displayNightfall or defaultNightfall and has_value(nightfall_bosses, target) then
			if not Nightfall then s = s.." Nightfall," end
		end
		
		if not defaultDragonling and displayDragonling or defaultDragonling and has_value(dragonling_bosses, target) then
			if not Dragonling then
				s = s.." Dragonling,"
			elseif DragonlingN and DragonlingN < 5 then
				s = s.." "..(5 - DragonlingN).."xDragonling,"
			end
		end

		s = string.sub(s, 1, -2).."!"
		
		-- Display results in the appropriate channel
		local channel, chatnumber = ChatFrameEditBox.chatType
		if channel == "EMOTE" or channel == "DND" or channel == "CHANNEL" or channel == "BATTLEGROUND" or channel == "AFK" then
			channel = "SAY"
		elseif channel == "RAID_WARNING" and not IsRaidLeader() and not IsRaidOfficer() then
			channel = "RAID"
		end
		if s == target.." ("..(i-trashN)..") is missin\!" then s = target.." ("..(i-trashN).."): no debuffs missing!" end
		if t == "Trash debuffs." then t = "No trash debuff!" end

		if useYellow then
			SDCChat(s)
			if displayTrash then SDCChat(t) end
		else
			if useRaid then channel = "RAID"
			elseif useSay or channel == "WHISPER" then channel = "SAY"
			end
			SendChatMessage(s, channel, nil, chatnumber)
			if displayTrash then SendChatMessage(t, channel, nil, chatnumber) end
		end
	end
end

-- Helper function checking is the string 'val' is contained in the table 'tab'
-- Note : the comparison is not case-sensitive
function has_value(tab, val)
    for index, value in ipairs (tab) do
        if string.lower(value) == string.lower(val) then
            return true
        end
    end
    return false
end

-- Split function, returns a table
function my_split(inputstr)
        local t={}
        for str in string.gfind(inputstr, "([^%s]+)") do -- Elysium implemented 'gfind' instead of 'gmatch'
			table.insert(t, str)
        end
        return t
end

-- Returns the first word of a string
function first_word(inputstr)
	local t = my_split(inputstr)
	return t[1] -- lua indexes start at 1
end

-- Returns the second word of a string
function second_word(inputstr)
	local t = my_split(inputstr)
	return t[2] -- lua indexes start at 1
end