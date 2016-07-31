--[[
Copyright 2013 Alberto Sáez

This file is part of Arcane Duel

	Arcane Duel is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Arcane Duel is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
--]]

--[[
ADDITIONAL CREDITS:

-> Cards art: 
		eleazzaar (Painterly Spell Icons packs @ opengameart.com)
		planetbaldursgate.com (lobotomy icon)
		dragonlady8 (summoning creatures background circle @ deviantart)
		salanchu (hell hound image @ deviantart)
		konetami (skeleton image @ deviantart)
		zeeksie (imp image @ deviantart)
		Louise Goalby (unicorn image @ deviantart)
		el-grimlock (dragon image @ deviantart)
		scribe (SPell Set @ opengameart.com)
		Paulius Jurgelevičius (some of the spell icons @ opengameart.com)
		Rpeh (Exile card art @ uesp.net)
		Nickoladze (Deadly Toxin card art @ dota2wiki.com)
		Illmaster (Energy Beam card art @ deviantart)
		Scribe (Unsummon card art @ opengameart.com)
		Luc Desmarchelier (Call of the Grave card art @ ldesmarchelier.com)
-> Card backpart image:
		FadedShadow589 (@ deviantart.com)
-> Mouse pointer:
		yd (from opengameart.com)
-> Energy icon image:
	qubodup (<- submitted by @ opengameart.com, but original author LoversHorizon @ deviantart)

--]]

game = {}

game.status = ""
game.lastPlayedCard = 0
game.playedCard = 0

game.maxPlayerHealth = 40
game.maxPlayerEnergy = 5
game.energyPerTurn = 2
game.difficulty = 4 -- 1:very easy, 2:easy, 3:medium, 4:hard

game.enemyRandom = true
game.playerRandom = true
customEnemyDeckPath = nil
customPlayerDeckPath = nil

enemy = {}
player = {}

enemy.hp = game.maxPlayerHealth
 enemy.poisonTurns = 0
 enemy.poisonDamage = 0
 enemy.defense = 0
 enemy.curse = 0
 enemy.companion = {"", 0}
 enemy.energy = 0
 enemy.elemental = 0
 enemy.mystic = 0
 enemy.dark = 0
 enemy.nature = 0
 enemy.void = 0
player.hp = game.maxPlayerHealth
 player.poisonTurns = 0
 player.poisonDamage = 0
 player.defense = 0
 player.curse = 0
 player.companion = {"", 0}
 player.energy = 0
 player.elemental = 0
 player.mystic = 0
 player.dark = 0
 player.nature = 0
 player.void = 0

function game.init()
	enemy.hp = game.maxPlayerHealth
	enemy.poisonTurns = 0
	enemy.poisonDamage = 0
	enemy.defense = 0
	enemy.curse = 0
	enemy.companion = {"", 0}
	enemy.energy = 1
	enemy.elemental = 0
	enemy.mystic = 0
	enemy.dark = 0
	enemy.nature = 0
	enemy.void = 0
	
	player.hp = game.maxPlayerHealth
	player.poisonTurns = 0
	player.poisonDamage = 0
	player.defense = 0
	player.curse = 0
	player.companion = {"", 0}
	player.energy = 1
	player.elemental = 0
	player.mystic = 0
	player.dark = 0
	player.nature = 0
	player.void = 0
	
	if game.enemyRandom == true then
		enemyDeck = deck.generateRandom(deck.maxCards)
	else
		game.loadCustomDeck(customEnemyDeckPath)
	end
	
	if game.playerRandom == true then
		playerDeck = deck.generateRandom(deck.maxCards)
	else
		game.loadCustomDeck(customPlayerDeckPath)
	end
	
	game.lastPlayedCard = 0
	
	slots.initialize()
	
	deck.drawCard(5, true)
	deck.drawCard(5)
	
	game.status = "match"
end

function game.loadCustomDeck(deckPath)
	if devel then print("~ Loading Custom Deck \"" .. deckPath .. "\"") end
	
	fileExists = io.open(deckPath,"r")
	
	if fileExists ~=nil then 
		io.close(fileExists) 
		loadfile(deckPath)()
	else 
		doError("Can't load deck \"" .. deckPath .. "\"", "fatal")
	end
end

function game.drawPlayersStatus()
	lprint(#playerDeck, 610, 435)
	lprint(#enemyDeck, 610, 5)
	
	color(red)
	lprint(player.hp, 520, 295, nil, nil, hugeFont)
	lprint(enemy.hp, 520, 145, nil, nil, hugeFont)
	color(white)
	lprint("You", 570, 300, nil, nil, largeFont)
	lprint("Enemy", 570, 150, nil, nil, largeFont)
	
	lprint("Companion", 690, 450, nil, nil, bigFont)
	lprint("Companion", 690, 10, nil, nil, bigFont)
	
	if player.companion[1] ~= "" then
		lprint(player.companion[1], 680, 421)
	end
	
	if enemy.companion[1] ~= "" then
		lprint(enemy.companion[1], 680, 152)
	end
	
	if enemy.poisonTurns > 0 then
		color(green)
		lprint(enemy.poisonTurns, 580, 205)
		draw(img_statusBubble, 575, 185)
	end
	if enemy.curse > 0 then
		color(pink)
		lprint(enemy.curse, 605, 205)
		draw(img_statusBubble, 600, 185)
	end
	if enemy.defense > 0 then
		color(yellow)
		lprint(enemy.defense, 630, 205)
		draw(img_statusBubble, 625, 185)
	end
	
	if player.poisonTurns > 0 then
		color(green)
		lprint(player.poisonTurns, 580, 260)
		draw(img_statusBubble, 575, 280)
	end
	if player.curse > 0 then
		color(pink)
		lprint(player.curse, 605, 260)
		draw(img_statusBubble, 600, 280)
	end
	if player.defense > 0 then
		color(yellow)
		lprint(player.defense, 630, 260)
		draw(img_statusBubble, 625, 280)
	end
	-- =============================================
	-- =============================================
	color(white)
	if player.elemental > 0 then
		if player.elemental < 10 then
			lprint(player.elemental, 350, 290)
		else
			lprint(player.elemental, 346, 290)
		end
		draw(img_elemental, 340, 310)
	end
	if player.nature > 0 then
		if player.nature < 10 then
			lprint(player.nature, 378, 290)
		else
			lprint(player.nature, 374, 290)
		end
		draw(img_nature, 368, 310)
	end
	if player.mystic > 0 then
		if player.mystic < 10 then
			lprint(player.mystic, 406, 290)
		else
			lprint(player.mystic, 402, 290)
		end
		draw(img_mystic, 396, 310)
	end
	if player.dark > 0 then
		if player.dark < 10 then
			lprint(player.dark, 434, 290)
		else
			lprint(player.dark, 430, 290)
		end
		draw(img_dark, 424, 310)
	end
	if player.void > 0 then
		if player.void < 10 then
			lprint(player.void, 462, 290)
		else
			lprint(player.void, 458, 290)
		end
		draw(img_void, 452, 310)
	end
	
	if enemy.elemental > 0 then
		if enemy.elemental < 10 then
			lprint(enemy.elemental, 350, 172)
		else
			lprint(enemy.elemental, 346, 172)
		end
		draw(img_elemental, 340, 150)
	end
	if enemy.nature > 0 then
		if enemy.nature < 10 then
			lprint(enemy.nature, 378, 172)
		else
			lprint(enemy.nature, 374, 172)
		end
		draw(img_nature, 368, 150)
	end
	if enemy.mystic > 0 then
		if enemy.mystic < 10 then
			lprint(enemy.mystic, 406, 172)
		else
			lprint(enemy.mystic, 402, 172)
		end
		draw(img_mystic, 396, 150)
	end
	if enemy.dark > 0 then
		if enemy.dark < 10 then
			lprint(enemy.dark, 434, 172)
		else
			lprint(enemy.dark, 430, 172)
		end
		draw(img_dark, 424, 150)
	end
	if enemy.void > 0 then
		if enemy.void < 10 then
			lprint(enemy.void, 462, 172)
		else
			lprint(enemy.void, 458, 172)
		end
		draw(img_void, 452, 150)
	end
	
	for i = 1, player.energy do
		draw(img_energyIcon, 530, 445 - 26*(i-1))
	end
	for i = 1, enemy.energy do
		draw(img_energyIcon, 530, 10 + 26*(i-1))
	end
end

function game.useCard(cardSlot)
	cardToUse = cards[ playerSlots[cardSlot] ]
	if cardToUse.energy <= player.energy then
		game.doAction(cardToUse.action, cardToUse.school)
		
		player.energy = player.energy - cardToUse.energy
	
		slots.remove(cardSlot)
		deck.drawCard(1)
		
		game.doPlayerTurn()
	else
		message("You don't have enough energy")
	end
	
	return false
end

function game.doAction(action, school, fromEnemy)
	action = game.enhanceBySchool(action, school, fromEnemy)
	
	if action[1] == "damage" then
		if fromEnemy then
			damage = action[2] - player.defense + player.curse
			
			if damage > 0 then
				player.hp = player.hp - damage
			end
		else
			damage = action[2] - enemy.defense + enemy.curse
			
			if damage > 0 then
				enemy.hp = enemy.hp - damage
			end
		end
	elseif action[1] == "damageall" then -- 1.0
		damage = action[2] - player.defense + player.curse
		if damage > 0 then
			player.hp = player.hp - damage
		end
		
		damage = action[2] - enemy.defense + enemy.curse
		if damage > 0 then
			enemy.hp = enemy.hp - damage
		end
		
		if player.companion[1] ~= "" then
			companion.dealDamage(action[2])
		end
		if enemy.companion[1] ~= "" then
			companion.dealDamage(action[2], true)
		end
	elseif action[1] == "damagecurse" then -- 1.0
		if fromEnemy then
			damage = action[2] - player.defense + player.curse
			
			if damage > 0 then
				player.hp = player.hp - damage
			end
			
			player.curse = player.curse + action[3]
		else
			damage = action[2] - enemy.defense + enemy.curse
			
			if damage > 0 then
				enemy.hp = enemy.hp - damage
			end
			
			enemy.curse = enemy.curse + action[3]
		end
	elseif action[1] == "udamage" then -- 1.0
		if fromEnemy then
			player.hp = player.hp - action[2] - player.curse
		else
			enemy.hp = enemy.hp - action[2] - enemy.curse
		end
	elseif action[1] == "poison" then
		if fromEnemy then
			player.poisonTurns = action[3]
			player.poisonDamage = action[2]
		else
			enemy.poisonTurns = action[3]
			enemy.poisonDamage = action[2]
		end
	elseif action[1] == "damagedot" then -- 1.0
		if fromEnemy then
			player.poisonTurns = action[4]
			player.poisonDamage = action[3]
			damage = action[2] - player.defense + player.curse
			
			if damage > 0 then
				player.hp = player.hp - damage
			end
		else
			enemy.poisonTurns = action[4]
			enemy.poisonDamage = action[3]
			damage = action[2] - enemy.defense + enemy.curse
			
			if damage > 0 then
				enemy.hp = enemy.hp - damage
			end
		end
	elseif action[1] == "defense" then
		if fromEnemy then
			enemy.defense = action[2]
		else
			player.defense = action[2]
		end
	elseif action[1] == "curse" then
		if fromEnemy then
			player.curse = action[2]
		else
			enemy.curse = action[2]
		end
	elseif action[1] == "dispelEnemy" then
		if fromEnemy then
			if player.defense > 0 then player.defense = 0 end
			if player.curse > 0 then player.curse = 0 end
		else
			if enemy.defense > 0 then enemy.defense = 0 end
			if enemy.curse > 0 then enemy.curse = 0 end
		end
	elseif action[1] == "dispelSelf" then
		if fromEnemy then
			if enemy.defense > 0 then enemy.defense = 0 end
			if enemy.curse > 0 then enemy.curse = 0 end
		else
			if player.defense > 0 then player.defense = 0 end
			if player.curse > 0 then player.curse = 0 end
		end
	elseif action[1] == "curePoison" then
		if fromEnemy then
			enemy.poisonTurns = 0
		else
			player.poisonTurns = 0
		end
	elseif action[1] == "uncurseall" then -- 1.0
		player.curse = 0
		enemy.curse = 0
	elseif action[1] == "heal" then
		if fromEnemy then
			enemy.hp = enemy.hp + action[2]
			if enemy.hp > game.maxPlayerHealth then enemy.hp = game.maxPlayerHealth end
		else
			player.hp = player.hp + action[2]
			if player.hp > game.maxPlayerHealth then player.hp = game.maxPlayerHealth end
		end
	elseif action[1] == "discard" then -- 1.0
		if fromEnemy then
			deck.removeCard(1, false, action[2])
		else
			deck.removeCard(1, true, action[2])
		end
	elseif action[1] == "companion" then -- 1.10
		if fromEnemy then
			enemy.companion = {action[2], companions[action[2]].health}
		else
			player.companion = {action[2], companions[action[2]].health}
		end
	elseif action[1] == "banish" then -- 1.10
		if fromEnemy then
			if player.companion[1] ~= "" then
				anim.createParticles(730, 375, 25, 100)
				addEvent(anim.flyParticles)
			end
			player.companion = {"", 0}
		else
			if enemy.companion[1] ~= "" then
				anim.createParticles(730, 105, 25, 100)
				addEvent(anim.flyParticles)
			end
			enemy.companion = {"", 0}
		end
	elseif action[1] == "destroy" then -- 1.10
		if fromEnemy then
			if player.companion[2] <= action[2] then
				if player.companion[1] ~= "" then
					anim.createParticles(730, 375, 25, 100)
					addEvent(anim.flyParticles)
				end
				player.companion = {"", 0}
			end
		else
			if enemy.companion[2] <= action[2] then
				if enemy.companion[1] ~= "" then
					anim.createParticles(730, 105, 25, 100)
					addEvent(anim.flyParticles)
				end
				enemy.companion = {"", 0}
			end
		end
	elseif action[1] == "energytodamage" then -- 1.11
		if fromEnemy then
			damage = action[2] - player.defense + player.curse + enemy.energy*action[3]
			
			if damage > 0 then
				player.hp = player.hp - damage
			end
			
			enemy.energy = 0
		else
			damage = action[2] - enemy.defense + enemy.curse + player.energy*action[3]
			
			if damage > 0 then
				enemy.hp = enemy.hp - damage
			end
			
			player.energy = 0
		end
	elseif action[1] == "giveenergy" then -- 1.11
		if fromEnemy then
			enemy.energy = enemy.energy + action[2]
			if enemy.energy > game.maxPlayerEnergy then
				enemy.energy = game.maxPlayerEnergy
			end
		else
			player.energy = player.energy + action[2]
			if player.energy > game.maxPlayerEnergy then
				player.energy = game.maxPlayerEnergy
			end
		end
	elseif action[1] == "removeenergy" then -- 1.11
		if fromEnemy then
			player.energy = player.energy - action[2]
			if player.energy < 0 then player.energy = 0 end
		else
			enemy.energy = enemy.energy - action[2]
			if enemy.energy < 0 then enemy.energy = 0 end
		end
	elseif action[1] == "companiontodamage" then -- 1.11
		if fromEnemy then
			if player.companion[1] ~= "" then
				companionDamage = companions[ player.companion[1] ].damage
				
				thisDamage = math.floor(companionDamage*action[2]/100)
				
				player.hp = player.hp - thisDamage
			end
		else
			if enemy.companion[1] ~= "" then
				companionDamage = companions[ enemy.companion[1] ].damage
				
				thisDamage = math.floor(companionDamage*action[2]/100)
				
				enemy.hp = enemy.hp - thisDamage
			end
		end
	elseif action[1] == "healboth" then -- 1.11
		if fromEnemy then
			enemy.hp = enemy.hp + action[2]
			
			if enemy.hp > game.maxPlayerHealth then enemy.hp = game.maxPlayerHealth end
			
			if enemy.companion[1] ~= "" then
				enemy.companion[2] = enemy.companion[2] + action[2]
				if enemy.companion[2] > companions[ enemy.companion[1] ].health then
					enemy.companion[2] = companions[ enemy.companion[1] ].health
				end
			end
		else
			player.hp = player.hp + action[2]
			
			if player.hp > game.maxPlayerHealth then player.hp = game.maxPlayerHealth end
			
			if player.companion[1] ~= "" then
				player.companion[2] = player.companion[2] + action[2]
				
				if player.companion[2] > companions[ player.companion[1] ].health then
					player.companion[2] = companions[ player.companion[1] ].health
				end
			end
		end
	elseif action[1] == "magicschool" then -- 1.11
		elemental = 0
		nature = 0
		mystic = 0
		dark = 0
		void = 0
		
		if action[2] == "elemental" then elemental = action[3] end
		if action[2] == "nature" then nature = action[3] end
		if action[2] == "mystic" then mystic = action[3] end
		if action[2] == "dark" then dark = action[3] end
		if action[2] == "void" then void = action[3] end
		
		if fromEnemy then
			enemy.elemental = enemy.elemental + elemental
			enemy.nature = enemy.nature + nature
			enemy.mystic = enemy.mystic + mystic
			enemy.dark = enemy.dark + dark
			enemy.void = enemy.void + void
		else
			player.elemental = player.elemental + elemental
			player.nature = player.nature + nature
			player.mystic = player.mystic + mystic
			player.dark = player.dark + dark
			player.void = player.void + void
		end
	end
end

function game.enhanceBySchool(action, school, fromEnemy)
	elemental, nature, mystic, dark, void = 0, 0, 0, 0, 0
	
	if fromEnemy then
		elemental = enemy.elemental
		nature = enemy.nature
		mystic = enemy.mystic
		dark = enemy.dark
		void = enemy.void
	else
		elemental = player.elemental
		nature = player.nature
		mystic = player.mystic
		dark = player.dark
		void = player.void
	end
	
	if school == "elemental" then
		if action[1] == "damage" or action[1] == "udamage" then action[2] = action[2] + elemental end
		if action[1] == "poison" then action[3] = action[3] + elemental end
		if action[1] == "defense" then action[2] = action[2] + math.floor(elemental/3) end
		if action[1] == "curse" then action[2] = action[2] + math.floor(elemental/2) end
		if action[1] == "heal" then action[2] = action[2] + math.floor(elemental/5) end
		if action[1] == "damageall" then action[2] = action[2] + elemental end
		if action[1] == "damagedot" then action[2] = action[2] + elemental; action[3] = action[3] + elemental end
		if action[1] == "discard" then end
		if action[1] == "damagecurse" then action[2] = action[2] + math.floor(elemental/2) end
		if action[1] == "destroy" then action[2] = action[2] + math.floor(elemental/2) end
		if action[1] == "energytodamage" then action[2] = action[2] + math.floor(elemental/2) end
		if action[1] == "giveenergy" then end
		if action[1] == "removeenergy" then end
		if action[1] == "companiontodamage" then action[2] = action[2] + math.floor(elemental*1.3) end
	elseif school == "nature" then
		if action[1] == "damage" or action[1] == "udamage" then action[2] = action[2] + math.floor(nature/1.7) end
		if action[1] == "poison" then action[3] = action[3] + math.floor(nature/1.5); action[2] = action[2] + nature end
		if action[1] == "defense" then action[2] = action[2] + math.floor(nature/2) end
		if action[1] == "curse" then action[2] = action[2] + math.floor(nature/5) end
		if action[1] == "heal" then action[2] = action[2] + math.floor(nature/1.2) end
		if action[1] == "damageall" then action[2] = action[2] + math.floor(nature/1.7) end
		if action[1] == "damagedot" then action[2] = action[2] + math.floor(nature/1.5); action[3] = action[3] + nature end
		if action[1] == "discard" then end
		if action[1] == "damagecurse" then action[2] = action[2] + math.floor(nature/5) end
		if action[1] == "destroy" then action[2] = action[2] + math.floor(nature/5) end
		if action[1] == "energytodamage" then action[2] = action[2] + math.floor(nature/1.5) end
		if action[1] == "giveenergy" then action[2] = action[2] + math.floor(nature/1.5) end
		if action[1] == "removeenergy" then end
		if action[1] == "companiontodamage" then action[2] = action[2] + math.floor(nature*1.7) end
	elseif school == "mystic" then
		if action[1] == "damage" or action[1] == "udamage" then action[2] = action[2] + math.floor(mystic/2) end
		if action[1] == "poison" then action[3] = action[3] + math.floor(mystic/2); action[2] = action[2] + math.floor(mystic/2) end
		if action[1] == "defense" then action[2] = action[2] + math.floor(mystic/1.3) end
		if action[1] == "curse" then action[2] = action[2] + math.floor(mystic/5) end
		if action[1] == "heal" then action[2] = action[2] + mystic end
		if action[1] == "damageall" then action[2] = action[2] + math.floor(mystic/2) end
		if action[1] == "damagedot" then action[2] = action[2] + math.floor(mystic/2); action[3] = action[3] + math.floor(mystic/2) end
		if action[1] == "discard" then end
		if action[1] == "damagecurse" then action[2] = action[2] + math.floor(mystic/5) end
		if action[1] == "destroy" then action[2] = action[2] + math.floor(mystic/4) end
		if action[1] == "energytodamage" then action[2] = action[2] + math.floor(mystic/1.7) end
		if action[1] == "giveenergy" then action[2] = action[2] + math.floor(mystic/1.7) end
		if action[1] == "removeenergy" then end
		if action[1] == "companiontodamage" then action[2] = action[2] + math.floor(mystic*1.5) end
	elseif school == "dark" then
		if action[1] == "damage" or action[1] == "udamage" then action[2] = action[2] + math.floor(dark/1.3) end
		if action[1] == "poison" then action[3] = action[3] + math.floor(dark/2); action[2] = action[2] + math.floor(dark/1.5) end
		if action[1] == "defense" then action[2] = action[2] + math.floor(dark/2) end
		if action[1] == "curse" then action[2] = action[2] + math.floor(dark/1.3) end
		if action[1] == "heal" then action[2] = action[2] + math.floor(dark/2) end
		if action[1] == "damageall" then action[2] = action[2] + math.floor(dark/1.3) end
		if action[1] == "damagedot" then action[2] = action[2] + math.floor(dark/1.5); action[3] = action[3] + math.floor(dark/2) end
		if action[1] == "discard" then action[2] = action[2] + math.floor(dark/2) end
		if action[1] == "damagecurse" then action[2] = action[2] + math.floor(dark/2); action[3] = action[3] + math.floor(dark/2) end
		if action[1] == "destroy" then action[2] = action[2] + math.floor(dark/2.3) end
		if action[1] == "energytodamage" then action[2] = action[2] + math.floor(dark/2.3) end
		if action[1] == "giveenergy" then action[2] = action[2] + math.floor(dark/2) end
		if action[1] == "removeenergy" then action[2] = action[2] + math.floor(dark/3) end
		if action[1] == "companiontodamage" then action[2] = action[2] + dark end
	elseif school == "void" then
		if action[1] == "damage" or action[1] == "udamage" then action[2] = action[2] + math.floor(void/1.5) end
		if action[1] == "poison" then action[3] = action[3] + math.floor(void/2.5); action[2] = action[2] + math.floor(void/1.7) end
		if action[1] == "defense" then action[2] = action[2] + math.floor(void/1.7) end
		if action[1] == "curse" then action[2] = action[2] + math.floor(void/2) end
		if action[1] == "heal" then end
		if action[1] == "damageall" then action[2] = action[2] + math.floor(void/1.5) end
		if action[1] == "damagedot" then action[2] = action[2] + math.floor(void/1.7); action[3] = action[3] + math.floor(void/2.2) end
		if action[1] == "discard" then action[2] = action[2] + math.floor(void/1.5) end
		if action[1] == "damagecurse" then action[2] = action[2] + math.floor(void/2.2); action[3] = action[3] + math.floor(void/2.2) end
		if action[1] == "destroy" then action[2] = action[2] + math.floor(void/2) end
		if action[1] == "energytodamage" then action[2] = action[2] + math.floor(void/1.1) end
		if action[1] == "giveenergy" then action[2] = action[2] + math.floor(void/1.2) end
		if action[1] == "removeenergy" then action[2] = action[2] + math.floor(void/2.2) end
		if action[1] == "companiontodamage" then action[2] = action[2] + math.floor(void/2) end
	end
	
	return action
end

function game.passTurn()
	needToPass = true
	
	for i = 1, 5 do
		if cards[ playerSlots[i] ].energy <= player.energy then
			needToPass = false
			break
		end
	end
	
	if needToPass then
		game.doPlayerTurn()
	else
		message("You can't pass turn")
	end
end

function game.playEnemy()
	playedCard = 0
	
	maxValue = -100
	
	for i = 1, 5 do
		cardEnergy = cards[   enemySlots[i]   ].energy
		cardValue = cards[   enemySlots[i]   ].value
		cardAction = cards[ enemySlots[i] ].action
		cardSchool = cards[ enemySlots[i] ].school
		typeValue = actionValues[    cardAction[1]    ][1](cardAction, cardEnergy)
		totalValue = 0
		
		if game.difficulty == 2 then
			typeValue = typeValue + math.random(-3, 3)
		elseif game.difficulty == 3 then
			typeValue = typeValue + math.random(-1, 1)
		end
		
		totalValue = cardValue + typeValue
		
		if game.difficulty == 1 then
			totalValue = math.random(-5, 5)
		end
		
		if devel then print("   ai think: " .. enemySlots[i] .. " @ " .. totalValue) end
		
		if cardEnergy <= enemy.energy then
			if cardSchool == "elemental" and enemy.elemental > 0 then totalValue = totalValue + enemy.elemental else totalValue = totalValue - 1 end
			if cardSchool == "nature" and enemy.nature > 0 then totalValue = totalValue + enemy.nature else totalValue = totalValue - 1 end
			if cardSchool == "mystic" and enemy.mystic > 0 then totalValue = totalValue + enemy.mystic else totalValue = totalValue - 1 end
			if cardSchool == "dark" and enemy.dark > 0 then totalValue = totalValue + enemy.dark else totalValue = totalValue - 1 end
			if cardSchool == "void" and enemy.void > 0 then totalValue = totalValue + enemy.void else totalValue = totalValue - 1 end
			
			if mustSaveEnergy(cardEnergy) then
				if devel then print("      ULTIMATE CARD FOUND :: SAVING ENERGY") end
				
				if cardEnergy <= 1 and cardValue <= 1 then totalValue = totalValue + 2
				elseif cardEnergy > 1 and cardEnergy <= game.energyPerTurn and cardValue <= 2 then totalValue = totalValue + 1
				elseif cardEnergy > game.energyPerTurn and cardValue > 2 then totalValue = totalValue - 2 end
				
				if cardValue <= 1 then totalValue = totalValue + 1 end
				if cardValue > 2 then totalValue = totalValue - 1 end
			end
			
			if totalValue > maxValue then
				playedCard = i
				if devel then print("    ^^POSSIBLE") end
				maxValue = totalValue
			else
				if devel then print("    ^^NO") end
			end
		else
			if devel then print("    ^^NO ENERGY") end
		end
	end
	
	if devel then
		if playedCard > 0 then
			print("AI DO: " .. enemySlots[playedCard] .. " @ " .. maxValue .. " ==> " .. cards[ enemySlots[playedCard] ].action[1] .. "\n---------------------")
		else
			print("AI DO: NO HAVE ENERGY TO PLAY ANY CARD\n---------------------")
			playedCard = -1
		end
	end
	
	if playedCard > 0 then
		anim.createMovement(cards[ enemySlots[playedCard] ].icon, 32 + (playedCard - 1)*102, 50, 234, 177)
		addEvent(anim.move)
	end
	
	game.playedCard = playedCard
	addEvent(game.lastAICard)
	addEvent(game.doEnemyTurn)
end

function game.lastAICard()
	if game.playedCard > 0 then
		game.doAction(cards[ enemySlots[game.playedCard] ].action, cards[ enemySlots[game.playedCard] ].school, true)
		enemy.energy = enemy.energy - cards[ enemySlots[game.playedCard] ].energy
		if enemy.energy < 0 then enemy.energy = 0 end
		
		game.lastPlayedCard = enemySlots[game.playedCard]
		
		slots.remove(game.playedCard, true)
		deck.drawCard(1, true)
	else
		game.lastPlayedCard = -1
	end
	
	return false
end

function game.doPlayerTurn()
	if player.poisonTurns > 0 then
		player.hp = player.hp - player.poisonDamage
		player.poisonTurns = player.poisonTurns - 1
	end
	
	if player.companion[2] > 0 then
		if player.companion[1] ~= "" then
			companions[ player.companion[1] ].skill()
		end
		if enemy.companion[2] > 0 then
			damage = companions[ player.companion[1] ].damage
				
			companion.dealDamage(damage, true)
		else
			damage = 0
			
			if companions[ player.companion[1] ].isMagical then
				damage = companions[ player.companion[1] ].damage - enemy.defense
			else
				damage = companions[ player.companion[1] ].damage
			end
			
			enemy.hp = enemy.hp - companions[ player.companion[1] ].damage
		end
	end
	
	if (enemy.hp <= 0 and player.hp > 0)  or (#enemyDeck <= 0 and #playerDeck > 0) then game.status = "win" end
	if (enemy.hp > 0 and player.hp <= 0) or (#enemyDeck > 0 and #playerDeck <= 0) then game.status = "lose" end
	if (enemy.hp <= 0 and player.hp <= 0) or (#enemyDeck <= 0 and #playerDeck <= 0) then game.status = "draw" end
	
	if enemy.companion[2] <= 0 then enemy.companion[1] = "" end
	if player.companion[2] <= 0 then player.companion[1] = "" end
	
	if enemy.hp > 0 then
		if game.status == "match" then
			enemy.energy = enemy.energy + game.energyPerTurn
			
			if enemy.energy > game.maxPlayerEnergy then enemy.energy = game.maxPlayerEnergy end
		end
		game.playEnemy()
	end
end

function game.doEnemyTurn()
	if enemy.poisonTurns > 0 then
		enemy.hp = enemy.hp - enemy.poisonDamage
		enemy.poisonTurns = enemy.poisonTurns - 1
	end
	
	if enemy.companion[1] ~= "" then
		companions[ enemy.companion[1] ].skill("enemy")
	end
	
	if enemy.companion[2] > 0 then
		if player.companion[2] > 0 then
			damage = companions[ enemy.companion[1] ].damage
			
			companion.dealDamage(damage, false)
		else
			damage = 0
			
			if companions[ enemy.companion[1] ].isMagical then
				damage = companions[ enemy.companion[1] ].damage - player.defense
			else
				damage = companions[ enemy.companion[1] ].damage
			end
			
			player.hp = player.hp - damage
		end
	end
	
	if (enemy.hp <= 0 and player.hp > 0)  or (#enemyDeck <= 0 and #playerDeck > 0) then game.status = "win" end
	if (enemy.hp > 0 and player.hp <= 0) or (#enemyDeck > 0 and #playerDeck <= 0) then game.status = "lose" end
	if (enemy.hp <= 0 and player.hp <= 0) or (#enemyDeck <= 0 and #playerDeck <= 0) then game.status = "draw" end
	
	if enemy.companion[2] <= 0 then enemy.companion[1] = "" end
	if player.companion[2] <= 0 then player.companion[1] = "" end
	
	if game.status == "match" then
		player.energy = player.energy + game.energyPerTurn
		
		if player.energy > game.maxPlayerEnergy then player.energy = game.maxPlayerEnergy end
	end
	
	return false
end

function pastebin()


if fromEnemy then
			
		else
			
		end
end
