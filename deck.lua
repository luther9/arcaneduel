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

deck = {}

enemyDeck = {}
playerDeck = {}

-- recommended maximun number of repeated cards = maxDeckCards/10
-- otherwise it may be not enough cards to build the deck
-- for example, 50 cards, 5 max repeat
deck.maxCards = 40
deck.maxRepeteatedCards = 4

function deck.generateRandom(numOfCards, deckType)
	thisDeck = {}
	
	for i = 1, numOfCards do
		while true do
			aux = deck.getRandomCard()
			
			repetition = 0
			
			for i = 1, #thisDeck do
				if thisDeck[i] == aux then
					repetition = repetition + 1
				end
			end
			
			if repetition < deck.maxRepeteatedCards then 
				thisDeck[#thisDeck + 1] = aux
				break
			end
		end
	end
	
	return thisDeck
end

function deck.drawDecks()
	if #playerDeck >= 27 then
		draw(img_deckMany, 569, 344 - 12)
	elseif #playerDeck < 27 and #playerDeck >= 14 then
		draw(img_deckMid, 569, 344 - 12)
	elseif #playerDeck < 14 and #playerDeck > 0 then
		draw(img_deckLow, 569, 344 - 12)
	end
	
	if #enemyDeck >= 27 then
		draw(img_deckMany, 569, -1)
	elseif #enemyDeck < 27 and #enemyDeck >= 14 then
		draw(img_deckMid, 569, -1)
	elseif #enemyDeck < 14 and #enemyDeck > 0 then
		draw(img_deckLow, 569, -1)
	end
end

function deck.print(baseDeck)
	deckCards = {}
	for i = 1, #baseDeck do
		cardName = cards[ baseDeck[i] ].name
		tempCardName = ""
		for m = 1, #cardName do
			if string.sub(cardName, m, m) ~= "\n" and string.sub(cardName, m, m) ~= "-" then
				tempCardName = tempCardName .. string.sub(cardName, m, m)
			elseif string.sub(cardName, m, m) == "\n" then
				if string.sub(cardName, m-1, m-1) ~= "-" then
					tempCardName = tempCardName .. " "
				end
			end
		end
		
		if baseDeck[i] < 10 then
			print("ID: " .. baseDeck[i] .. "  = " .. tempCardName)
		else
			print("ID: " .. baseDeck[i] .. " = " .. tempCardName)
		end
	end
end

function deck.getRandomCard()
	rnd = math.random(1, #cards)
	
	return rnd
end

function deck.shuffle(baseDeck)
	deckSize = #baseDeck
	shuffleDeck = {}
	
	for i = 1, deckSize do
		shuffleDeck[i] = ""
	end
	
	for i = 1, deckSize do
		while true do
			rnd = math.random(1, deckSize)
			
			if shuffleDeck[rnd] == "" then
				shuffleDeck[rnd] = baseDeck[i]
				break
			end
		end
	end
	
	return shuffleDeck
end

function deck.removeCard(cardID, fromEnemy, removeAmount)
	if removeAmount then
		for i = 1, removeAmount do
			if fromEnemy then
				table.remove(enemyDeck, cardID)
			else
				table.remove(playerDeck, cardID)
			end
		end
	else
		if fromEnemy then
			table.remove(enemyDeck, cardID)
		else
			table.remove(playerDeck, cardID)
		end
	end
end

function deck.drawCard(amount, fromEnemy)
	drawn = 0
	
	if not fromEnemy then
		for i = 1, 5 do
			if playerSlots[i] == 0 then
				playerSlots[i] = playerDeck[1]
				deck.removeCard(1)
				
				drawn = drawn + 1
				
				if drawn >= amount then break end
			end
		end
	else
		for i = 1, 5 do
			if enemySlots[i] == 0 then
				enemySlots[i] = enemyDeck[1]
				deck.removeCard(1, true)
				
				drawn = drawn + 1
				
				if drawn >= amount then break end
			end
		end
	end
end
