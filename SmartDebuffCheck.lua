-- Global variables, saved between sessions (initialized in resetSettings())
useSay, useRaid, useYellow = nil, nil, nil -- where to display results of /sdc queries
displayTrash = nil -- if you want to display trash debuffs
displayFF, displaySW = nil, nil
customMage, displayScorch, displayWC = nil, nil, nil
displayNightfall = nil
customCurses, displayCoR, displayCoE, displayCoS = nil, nil, nil, nil
customDemo, displayDemo, customTC, displayTC = nil, nil, nil, nil
displayDragonling = nil -- Dragonling's Flame Buffets

local allowed_debuffs = {
	"Interface\\Icons\\Ability_Physical_Taunt", -- taunt
	"Interface\\Icons\\Ability_Warrior_Punishingblow", -- Coup railleur
	"Interface\\Icons\\Spell_Shadow_ShadowBolt", -- ISB
	"Interface\\Icons\\Spell_Shadow_AbominationExplosion", -- Corruption
	"Interface\\Icons\\Spell_Shadow_ScourgeBuild", -- Shadowburn
	"Interface\\Icons\\Spell_Shadow_SiphonMana", -- Mindflay
	"Interface\\Icons\\Spell_Shadow_UnsummonBuilding", -- Vamp Embrace
	"Interface\\Icons\\Spell_Nature_ThunderClap", -- TC
	"Interface\\Icons\\Spell_Holy_ElunesGrace", -- Nightfall
	"Interface\\Icons\\Ability_BackStab", -- Deep Wounds
	"Interface\\Icons\\Spell_Fire_FlameBolt", -- Fireball
	"Interface\\Icons\\Spell_Fire_Fireball", -- Dragonling
	"Interface\\Icons\\Spell_Nature_Cyclone", -- Thunderfury
	"Interface\\Icons\\Spell_Fire_Incinerate", -- Ignite
	"Interface\\Icons\\Spell_Shadow_ShadowWordPain", -- SW:P
}

local dangerous_bosses = {"Princess Huhuran", "Emperor Vek'nilash", "Ouro", "Ossirian the Unscarred", "Broodlord Lashlayer", "Chromaggus", "Nefarian", "Elder Mottled Boar",}

function SDC_OnLoad()
	resetSettings()
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
	DEFAULT_CHAT_FRAME:AddMessage("/sdc mage default | scorch &| wc | nothing")
	SDCChat("Sets the display of mage debuffs. By default, it will display Scorches only, if you're not in MC/BWL/Onyxia. You can also choose to display scorches and/or WC all the time. ")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc ff")
	SDCChat("Toggles the display of Faerie Fire (default: ON)")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc sw")
	SDCChat("Toggles the display of Shadow Weaving (default: ON)")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc demo default | always | never")
	SDCChat("Sets the display of Demoralizing Shout. By default, it only displays it on some dangerous bosses. ")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc tc default | always | never")
	SDCChat("Sets the display of Thunderclap. By default, it only displays it on some dangerous bosses. ")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc nf")
	SDCChat("Toggles the display of Nightfall (default: OFF, except on C'thun)")
	DEFAULT_CHAT_FRAME:AddMessage("/sdc dragonling")
	SDCChat("Toggles the display of the Dragonling's debuffs (default: OFF, except on C'thun)")
end

function SDCChat(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0)
end

function settings(msg)
	if msg == "reset" then resetSettings()
	elseif msg == "say" then useSay = true; useRaid = false; useYellow = false
	elseif msg == "raid" then useRaid = true; useSay = false; useYellow = false
	elseif msg == "yellow" then useYellow = true; useSay = false; useRaid = false
	elseif msg == "last" then useSay = false; useRaid = false; useYellow = false
	elseif msg == "trash" then displayTrash = not displayTrash
	elseif msg == "ff" or msg == "faerie fire" then displayFF = not displayFF
	elseif msg == "sw" or msg == "shadow weaving" then displaySW = not displaySW
	elseif msg == "nf" or msg == "nightfall" then displayNightfall = not displayNightfall
	elseif msg == "dragonling" or msg == "dragon" or msg == "dl" then displayDragonling = not displayDragonling

	elseif string.find(msg, "curses") then
		if string.find(msg, "default") then customCurses = false
		else
			customCurses = true
			if string.find(msg, "cor") then displayCoR = not displayCoR end
			if string.find(msg, "coe") then displayCoE = not displayCoE end
			if string.find(msg, "cos") then displayCoS = not displayCoS end
		end
	elseif string.find(msg, "mage") then
		if string.find(msg, "default") then customMage = false
		else
			customMage = true
			if string.find(msg, "scorch") or string.find(msg, "scorches") then displayScorch = not displayScorch end
			if string.find(msg, "wc") or string.find(msg, "winter") then displayWC = not displayWC end
		end

	elseif string.find(msg, "demo") or string.find(msg, "demo shout") or string.find(msg, "demoralizing shout") then
		if string.find(msg, "default") then customDemo = false
		elseif string.find(msg, "always") then
			customDemo = true
			displayDemo = true
		elseif string.find(msg, "never") then
			customDemo = true
			displayDemo = false
		end
	elseif string.find(msg, "tc") or string.find(msg, "thunder") or string.find(msg, "thunderclap") then
		if string.find(msg, "default") then customTC = false
		elseif string.find(msg, "always") then
			customTC = true
			displayTC = true
		elseif string.find(msg, "never") then
			customTC = true
			displayTC = false
		end

	elseif msg ~= "settings" then SDCChat("Command not matching any keyword")
	end
	current = "Current settings: "
	current = current .. "Channel: "
	if useSay then current = current .. "Say, "
	elseif useRaid then current = current .. "Raid, "
	elseif useYellow then current = current .. "Yellow, "
	else current = current .. "Last" .. ", "
	end
	current = current .. "Trash: " .. tostring(displayTrash) .. ", "
	current = current .. "FF: " .. tostring(displayFF) .. ", "
	current = current .. "SW: " .. tostring(displaySW) .. ", "
	current = current .. "Nightfall: " .. tostring(displayNightfall) .. ", "
	current = current .. "Dragonling: " .. tostring(displayDragonling) .. ", "
	current = current .. "Curses: "
	if not customCurses then current = current .. "default, "
	else current = current .. "CoR=" .. tostring(displayCoR) .. ", CoE=" .. tostring(displayCoE) .. ", CoS=" .. tostring(displayCoS) .. ", "
	end
	current = current .. "Mage debuffs: "
	if not customMage then current = current .. "default, "
	else current = current .. "Scorches=" .. tostring(displayScorch) .. ", WC=" .. tostring(displayWC) .. ", "
	end
	current = current .. "Demo: "
	if not customDemo then current = current .. "default, "
	elseif displayDemo then current = current .. "always, "
	else current = current .. "never, "
	end
	current = current .. "TC: "
	if not customTC then current = current .. "default."
	elseif displayTC then current = current .. "always."
	else current = current .. "never."
	end
	SDCChat(current)
end

-- Default values
function resetSettings()
	useSay = true
	useRaid = false
	useYellow = false
	displayTrash = false
	displayFF = true
	displaySW = true
	customMage = false
	displayScorch = false
	displayWC = false
	displayNightfall = false
	customCurses = false
	displayCoR = false
	displayCoE = false
	displayCoS = false
	customDemo = false
	displayDemo = false
	customTC = false
	displayTC = false
	displayDragonling = false
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
		s = UnitName("target").." ("..(i-trashN)..") is missing"
		
		if warrior then
			if not SA then 
				s = s.." 5xSunder Armor," 
			elseif SAN < 5 then 
				s = s.." "..(5 - SAN).."xSunder Armor," 
			end
			
			if customDemo and displayDemo or not customDemo and isDangerous(UnitName("target")) then
				if not Demo then s = s.." Demo Shout," end
			end
			if customTC and displayTC or not customTC and isDangerous(UnitName("target")) then
				if not TC then s = s.." Thunderclap," end
			end
		end
		if displayNightfall or UnitName("target") == "C'thun" then
			if not Nightfall then s = s.." Nightfall," end
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
					if not CoS then s = s.." CoS," end
					if mage then
						if not CoE then s = s.." CoE," end
					end
				end
			end
		end
		
		if mage then
			if GetRealZoneText() ~= "Molten Core" and GetRealZoneText() ~= "Blackwing Lair" and GetRealZoneText() ~= "Onyxia\'s Lair" or customMage and displayScorch then
				if not Scorch then
					s = s.." 5xScorch,"
				elseif ScorchN < 5 then
					s = s.." "..(5 - ScorchN).."xScorch,"
				end
			elseif customMage and displayWC then
				if not WC then
					s = s.." 5xWinter's Chill,"
				elseif WCN < 5 then
					s = s.." "..(5 - WCN).."xWinter's Chill,"
				end
			end
		end
		if displayFF and druid and not FF then s = s.." Faerie Fire," end
		if displaySW and spriest then 
			if not SW then 
				s = s.." Shadow Weaving," 
			elseif SWN and SWN < 5 then
				s = s.." "..(5 - SWN).."xShadow Weaving,"
			end
		end
		if displayDragonling or UnitName("target") == "C'thun" then
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
		if s == UnitName("target").." ("..(i-trashN)..") is missin\!" then s = UnitName("target").." ("..(i-trashN).."): no debuffs missing!" end
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

function isDangerous(boss)
    return has_value(dangerous_bosses, boss)
end

-- Helper function
function has_value(tab, val)
    for index, value in ipairs (tab) do
        if value == val then
            return true
        end
    end
    return false
end