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

slots = {}

playerSlots = {}
enemySlots = {}

function slots.initialize()
	for i = 1, 5 do
		playerSlots[i] = 0
		enemySlots[i] = 0
	end
end

function slots.isHovering()
	x, y = love.mouse.getX()/screenScale, love.mouse.getY()/screenScale
	hoverSlot = 0
	
	if x >= 30 and x <= 110 and y >= 344 and y <= 470 then
		hoverSlot = 1
	elseif x >= 132 and x <= 212 and y >= 344 and y <= 470 then
		hoverSlot = 2
	elseif x >= 234 and x <= 314 and y >= 344 and y <= 470 then
		hoverSlot = 3
	elseif x >= 336 and x <= 416 and y >= 344 and y <= 470 then
		hoverSlot = 4
	elseif x >= 438 and x <= 518 and y >= 344 and y <= 470 then
		hoverSlot = 5
	end
	
	-- hovering over enemy played card
	if x >= 234 and x <= 313 and y >= 177 and y <= 302 and 
	   game.lastPlayedCard > 0 then
		slots.drawSpellDescription(game.lastPlayedCard, true)
	end
	
	return hoverSlot
end

function slots.remove(slot, fromEnemy)
	if fromEnemy then
		enemySlots[slot] = 0
	else
		playerSlots[slot] = 0
	end
end

function slots.draw()
	for i = 1, 5 do
		if playerSlots[i] > 0 then
			if player.energy < cards[  playerSlots[i]  ].energy then
				color({100, 0, 0, 255})
			else
				color(white)
			end
			draw(cards[  playerSlots[i]  ].icon, 30 + (i - 1)*102, 344)
			color(elementColors[  cards[ playerSlots[i] ].school  ])
			lprint(cards[  playerSlots[i]  ].name, 32 + (i - 1)*102, 432)
		else
			lprint("NOCARD", 30 + (i - 1)*102, 344)
		end
		color(white)
		
		if enemySlots[i] > 0 then
			draw(img_card, 30 + (i - 1)*102, 10)
			
			if devel then
				lprint(cards[  enemySlots[i]  ].name, 32 + (i - 1)*102, 50)
			end
		else
			lprint("NOCARD", 30 + (i - 1)*102, 10)
		end
	end
	
	if game.lastPlayedCard > 0 then
		draw(cards[  game.lastPlayedCard  ].icon, 234, 177)
		color(elementColors[ cards[game.lastPlayedCard].school ])
		lprint(cards[  game.lastPlayedCard  ].name, 235, 266)
	elseif game.lastPlayedCard < 0 then
		draw(img_passTurn, 234, 177)
	end
	color(white)
	
	if player.companion[1] ~= "" then
		draw(companions[ player.companion[1] ].icon, 676, 305)
	end
	
	if enemy.companion[1] ~= "" then
		draw(companions[ enemy.companion[1] ].icon, 676, 35)
	end
end

function slots.drawSpellDescription(spellID, enemySpell)
	mx, my = love.mouse.getX(), love.mouse.getY()
	
	cardEnergy = cards[spellID].energy
	cardSchool = cards[spellID].school
	cardColor = elementColors[ cardSchool ]
	cardName = cards[spellID].name
	cardDescription = cards[spellID].description
	
	cardSchool = string.upper(string.sub(cardSchool, 1, 1)) .. string.sub(cardSchool, 2, #cardSchool)
	
	tempCardName = ""
	for i = 1, #cardName do
		if string.sub(cardName, i, i) ~= "\n" and string.sub(cardName, i, i) ~= "-" then
			tempCardName = tempCardName .. string.sub(cardName, i, i)
		elseif string.sub(cardName, i, i) == "\n" then
			if string.sub(cardName, i-1, i-1) ~= "-" then
				tempCardName = tempCardName .. " "
			end
		end
	end
	
	cardName = tempCardName
	
	color({0, 0, 0, 200})
	if not enemySpell then
		posX, posY = mx, my - (250*screenScale)
		
		rectangleCenter = posX + 125*screenScale
		
		rectangle("fill", posX, posY, 250, 250)
		
		color(cardColor)
		fontSize = largeFont:getWidth(cardName)
		lprint(cardName, rectangleCenter - fontSize*screenScale/2 , posY+2, 1, 1, largeFont)
		fontSize = bigFont:getWidth("~= " .. cardSchool .. " magic school =~")
		lprint("~= " .. cardSchool .. " magic school =~", rectangleCenter - fontSize*screenScale/2, posY + 40, 1, 1, bigFont)
		
		if cardEnergy > 0 then
			startX = (26*screenScale)*cardEnergy/2
			if cardEnergy > player.energy then 
				color(red) 
			else
				color(white)
			end
			for i = 1, cardEnergy do
				draw(img_energyIcon, rectangleCenter - startX + (26*screenScale)*(i-1), posY + 68*screenScale, 1, 1)
			end
		end
		
		color(white)
		
		lprint(cardDescription, posX + 2, posY + 100*screenScale, 1, 1, bigFont)
	else
		posX, posY = mx-(250*screenScale), my - (100*screenScale)
		
		rectangleCenter = posX + 128*screenScale
		
		rectangle("fill", posX, posY, 256, 250)
		
		color(cardColor)
		fontSize = largeFont:getWidth(cardName)
		lprint(cardName, rectangleCenter - fontSize*screenScale/2, posY - 2, 1, 1, largeFont)
		fontSize = bigFont:getWidth("~= " .. cardSchool .. " magic school =~")
		lprint("~= " .. cardSchool .. " magic school =~", rectangleCenter - fontSize*screenScale/2, posY + 40, 1, 1, bigFont)
		
		if cardEnergy > 0 then
			startX = (26*screenScale)*cardEnergy/2
			color(white)
			for i = 1, cardEnergy do
				draw(img_energyIcon, rectangleCenter - startX + (26*screenScale)*(i-1), posY + 68*screenScale, 1, 1)
			end
		end
		
		color(white)
		lprint(cardDescription, posX + 2, posY + 100, 1, 1, bigFont)
	end
	
	color(white)
end

function slots.hoverOverStatus()
	mx, my = love.mouse.getX(), love.mouse.getY()
	text = ""
	
	if my >= 185*screenScale and my <= 202*screenScale then
		if (mx >= 575*screenScale and mx <= 593*screenScale)  and enemy.poisonTurns > 0 then
			text = "Periodic dmg\n(" .. enemy.poisonDamage .. " damage)"
		elseif (mx >= 600*screenScale and mx <= 617*screenScale)  and enemy.curse > 0 then
			text = "Curse value"
		elseif (mx >= 625*screenScale and mx <= 642*screenScale) and enemy.defense > 0 then
			text = "Defense value"
		end
	elseif my >= 280*screenScale and my <= 298*screenScale then
		if (mx >= 575*screenScale and mx <= 593*screenScale) and player.poisonTurns > 0 then
			text = "Periodic dmg\n(" .. player.poisonDamage .. " damage)"
		elseif (mx >= 600*screenScale and mx <= 617*screenScale) and player.curse > 0 then
			text = "Curse value"
		elseif (mx >= 625*screenScale and mx <= 642*screenScale) and player.defense > 0 then
			text = "Defense value"
		end
	end
	
	if my >= 150*screenScale and my <= 177*screenScale then
		if (mx >= 340*screenScale and mx <= 365*screenScale) and enemy.elemental > 0 then
			text = "Elemental\nMagic level"
		elseif (mx >= 369*screenScale and mx <= 394*screenScale) and enemy.nature > 0 then
			text = "Nature\nMagic level"
		elseif (mx >= 398*screenScale and mx <= 421*screenScale) and enemy.mystic > 0 then
			text = "Mystic\nMagic level"
		elseif (mx >= 426*screenScale and mx <= 448*screenScale) and enemy.dark > 0 then
			text = "Dark\nMagic level"
		elseif (mx >= 454*screenScale and mx <= 477*screenScale) and enemy.void > 0 then
			text = "Void\nMagic level"
		end
	elseif my >= 311*screenScale and my <= 335*screenScale then
		if (mx >= 340*screenScale and mx <= 365*screenScale) and player.elemental > 0 then
			text = "Elemental\nMagic level"
		elseif (mx >= 369*screenScale and mx <= 394*screenScale) and player.nature > 0 then
			text = "Nature\nMagic level"
		elseif (mx >= 398*screenScale and mx <= 421*screenScale) and player.mystic > 0 then
			text = "Mystic\nMagic level"
		elseif (mx >= 426*screenScale and mx <= 448*screenScale) and player.dark > 0 then
			text = "Dark\nMagic level"
		elseif (mx >= 454*screenScale and mx <= 477*screenScale) and player.void > 0 then
			text = "Void\nMagic level"
		end
	end
	
	if text ~= "" then
		color({0, 0, 0, 200})
		rectangle("fill", mx - 110, my - 10, 105, 50)
		color(white)
		lprint(text, mx - 108, my - 8)
	end
end
