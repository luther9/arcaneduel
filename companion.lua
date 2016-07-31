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

companion = {}

function companion.dealDamage(damage, isEnemy)
	if isEnemy then
		enemy.companion[2] = enemy.companion[2] - damage
		if enemy.companion[2] <= 0 then
			enemy.companion[2] = 0
			enemy.companion[1] = ""
			
			anim.createParticles(730, 105, 25, 100)
			addEvent(anim.flyParticles)
		end
	else
		player.companion[2] = player.companion[2] - damage
		if player.companion[2] <= 0 then
			player.companion[2] = 0
			player.companion[1] = ""
			
			anim.createParticles(730, 375, 25, 100)
			addEvent(anim.flyParticles)
		end
	end
end

function companion.hover()
	dx, dy = love.mouse.getX(), love.mouse.getY()
	cName = ""
	cHealth = ""
	cDamage = ""
	cSkill = ""
	enemyY = 0
	
	if dx >= 676 and dx <= 787  then
		if dy >= 35 and dy <= 174 and enemy.companion[1] ~= "" then
			cName = enemy.companion[1]
			cHealth = "Health: " .. enemy.companion[2] .. "/" .. companions[ enemy.companion[1] ].health
			if companions[ enemy.companion[1] ].isMagical then
				cDamage = "Damage: " .. companions[ enemy.companion[1] ].damage .. "\n(Magic Damage)"
			else
				cDamage = "Damage: " .. companions[ enemy.companion[1] ].damage .. "\n(Physical damage)"
			end
			if companions[ enemy.companion[1] ].skillDesc ~= "" then
				cSkill = "Skill:\n" .. companions[ enemy.companion[1] ].skillDesc
			else
				cSkill = "Skill: none"
			end
			
			enemyY = -75
			
		elseif dy >= 305 and dy <= 444 and player.companion[1] ~= "" then
			cName = player.companion[1]
			cHealth = "Health: " .. player.companion[2] .. "/" .. companions[ player.companion[1] ].health
			if companions[ player.companion[1] ].isMagical then
				cDamage = "Damage: " .. companions[ player.companion[1] ].damage .. "\n(Magic Damage)"
			else
				cDamage = "Damage: " .. companions[ player.companion[1] ].damage .. "\n(Physical damage)"
			end
			if companions[ player.companion[1] ].skillDesc ~= "" then
				cSkill = "Skill:\n" .. companions[ player.companion[1] ].skillDesc
			else
				cSkill = "Skill: none"
			end
		end
	end
	
	if cName ~= "" then
		color({0, 0, 0, 200})
		rectangle("fill", dx - 200, dy - 190 - enemyY, 200, 190)
		color(white)
		lprint(cName, dx - 190, dy - 180 - enemyY, nil, nil, largeFont)
		lprint(cHealth, dx - 190, dy - 150 - enemyY)
		lprint(cDamage, dx - 190, dy - 133 - enemyY)
		lprint(cSkill, dx - 190, dy - 80 - enemyY)
	end
end
