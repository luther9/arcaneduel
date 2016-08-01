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
		Eleazzaar (Painterly Spell Icons packs @ opengameart.com)
		Planetbaldursgate.com (Lobotomy)
		Dragonlady8 (summoning creatures background circle @ deviantart)
		Salanchu (hell hound image @ deviantart)
		Konetami (skeleton image @ deviantart)
		Zeeksie (imp image @ deviantart)
		Louise Goalby (unicorn image @ deviantart)
		El-grimlock (dragon image @ deviantart)
		Scribe (Spell Set @ opengameart.com)
		Paulius Jurgelevičius (several cards @ opengameart.com)
		Rpeh (Exile @ uesp.net)
		Nickoladze (Deadly Toxin @ dota2wiki.com)
		Illmaster (Energy Beam @ deviantart)
		Scribe (Unsummon @ opengameart.com)
		Luc Desmarchelier (Call of the Grave @ ldesmarchelier.com)
		Arcane Wonders (Energy Sink @ deviantart)
		SAB687 (Destroy Mind @ deviantart)
		tvlookplay (Pyroblast @ deviantart)
		Liiga Smilshkalne (Betrayal @ deviantart)
		Gucken (Nature's Balance @ deviantart)
		Nyktalgia (Nightfall @ deviantart)
		Edlo (Chaos Vortex @ deviantart)
		Isac Goulart (WIld Growth @ deviantart)
		Xzendor7 (Radiance @ deviantart)
		Sandara (Ominous Wrath @ deviantart)
		Zueuk (Cataclysm @ deviantart)
		Keepwalking07 (Golem @ deviantart)
		Wen-M (Nightmare @ deviantart)
		Etopsirhc (Unstable Archon @ deviantart)
		Mari-na (Kami @ deviantart)
-> Card backpart image:
		FadedShadow589 (@ deviantart.com)
-> Mouse pointer:
		yd (from opengameart.com)
-> Energy icon image:
	qubodup (<- submitted by @ opengameart.com, but original author LoversHorizon @ deviantart)

--]]

require "system"
require "game"
require "data"
require "deck"
require "slots"
require "companion"
require "anim"
require "AI"

function love.load()
	setScreen()
	
	if arg[2] ~= nil then
		customPlayerDeckPath = arg[2]
		game.playerRandom = false
	end
	
	game.init()
end

function love.update(dt)
	clearWorld()
end

function love.draw()
	draw(img_background)
	deck.drawDecks()
	slots.draw()
	game.drawPlayersStatus()
	
	doEvents()
	
	if messageAlpha > 0 then
		mid = 590/2 - (largeFont:getWidth(gameMessage)*screenScale)/2
		
		if messageAlpha <= 255 then
			color({0, 0, 0, messageAlpha})
		else
			color({0, 0, 0, 255})
		end
		lprint(gameMessage, mid+3, 308, nil, nil, largeFont)
		
		if messageAlpha <= 255 then
			color({255, 255, 100, messageAlpha})
		else
			color({255, 255, 100, 255})
		end
		lprint(gameMessage, mid, 305, nil, nil, largeFont)
			
		messageAlpha = messageAlpha - 0.5
			
		if messageAlpha <= 0 then
			messageAlpha = 0
		end
	end
	
	if game.status == "match" then
		hoverSlot = slots.isHovering()
		
		if hoverSlot > 0 and playerSlots[hoverSlot] > 0 then
			spellID = playerSlots[hoverSlot]
			slots.drawSpellDescription(spellID)
		end
		
		slots.hoverOverStatus()
		companion.hover()
	elseif game.status == "win" then
		draw(img_win)
		lprint("Press d to play again", 250, screenHeight - 20)
	elseif game.status == "lose" then
		draw(img_lose)
		lprint("Press d to play again", 250, screenHeight - 20)
	elseif game.status == "draw" then
		draw(img_draw)
		lprint("Press d to play again", 250, screenHeight - 20)
	elseif game.status == "error" then
		color(red)
		rectangle("fill", 0, screenHeight/2 - 15, screenWidth, 60)
		color(black)
		lprint(errorText, 10, screenHeight/2)
	end
	
	if devel then 
		lprint(love.mouse.getX() .. " " .. love.mouse.getY(), 10, 10) 
		lprint(love.timer.getFPS(), 10, 30) 
	end
	
	if #mouseParticles > 0 then
		anim.animateMouseParticles()
	end
	
	color(white)
	draw(img_mouse, love.mouse.getX()/screenScale, love.mouse.getY()/screenScale)
	
	if devel == true then
		love.mouse.setVisible(true)
	else
		love.mouse.setVisible(false)
	end
	
	drawWorld()
end

function love.keypressed(key)
	if key == "d" then
		game.init()
	elseif key == "f12" then
		if fullscreen == false then
			fullscreen = true
		else
			fullscreen = false
		end
		setScreen()
	elseif key == 'space' then
		game.passTurn()
	elseif key == "p" then
		devel = not devel
		print("Devel mode = " .. tostring(devel))
	elseif key == "t" then
		if devel then
			print("========PLAYER DECK========")
			deck.print(playerDeck)
			print("========ENEMY DECK========")
			deck.print(enemyDeck)
		end
	elseif key == "escape" then 
		if game.status == "error" then
			game.status = "match"
		else
			killMe() 
		end
	end
end

function love.mousepressed( x, y, button )
	anim.createMouseParticles(10)
	
	if game.status == "match" then
		if button == 1 then
			hoverSlot = slots.isHovering()
			
			if hoverSlot > 0 and playerSlots[hoverSlot] > 0 then
				game.useCard(hoverSlot)
			end
		end
	elseif game.status == "win" then
	
	elseif game.status == "lose" then
	
	elseif game.status == "draw" then
	
	end
end
