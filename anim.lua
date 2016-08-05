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

anim = {}

local particles

mouseParticles = {}

function anim.createMovement(image, sX, sY, eX, eY, speed)
	anim.startX = sX
	anim.startY = sY
	anim.endX = eX
	anim.endY = eY
	anim.speed = speed or 1
	anim.image = image
end

function anim.move()
	draw(anim.image, anim.startX, anim.startY)

	local function move(axis)
		local start = 'start' .. axis
		local stop = 'end' .. axis
		if anim[start] < anim[stop] then
			anim[start] = anim[start] + anim.speed
		elseif anim[start] > anim[stop] then
			anim[start] = anim[start] - anim.speed
		end
	end

	move('X')
	move('Y')

	if anim.startX == anim.endX and anim.startY == anim.endY then
		return false
	end

	return true
end

function anim.createParticles(sX, sY, amount, duration)
	amount = amount or 10
	duration = duration or 1000

	particles = {}
	
	for i = 1, amount do
		while true do
			speedX = math.random(-6, 6)
			speedY = math.random(-6, 6)
			if speedX ~= 0 or speedY ~= 0 then break end
		end
		
		particles[i] = {x = sX, y = sY, 
						speedX = speedX, speedY = speedY, 
						dur = duration}
	end
end

function anim.flyParticles()
	gotParticles = true
	
	for i = 1, #particles do
		color({200, 200, 255, 255})
		
		draw(img_particle, particles[i].x, particles[i].y)
		
		for j = 1, 10 do
			color({200, 200, 255, 255 - 20*(j-1)})
			draw(img_particle, particles[i].x - particles[i].speedX*j, particles[i].y - particles[i].speedY*j)
		end
		
		particles[i].x = particles[i].x + particles[i].speedX
		particles[i].y = particles[i].y + particles[i].speedY
		
		particles[i].dur = particles[i].dur - 1
		
		noMoreParticles = true
	
		if particles[i].dur > 0 then
			noMoreParticles = false
		end
		
		if noMoreParticles == true then
			gotParticles = false
		end
	end
	
	color(white)
	
	return gotParticles
end

function anim.createMouseParticles(amount, x, y)
	
	mx, my = x or love.mouse.getX(), y or love.mouse.getY()
	
	for i = 1, amount do
		mouseParticles[#mouseParticles + 1] = {x = mx, y = my, xtravel = math.random(-50, 50), ytravel = math.random(-50, 50), alpha = 255}
	end
end

function anim.animateMouseParticles()
	if #mouseParticles >= 1 then
		for i = #mouseParticles, 1, -1 do
			if mouseParticles[i].xtravel > 0 then
				mouseParticles[i].xtravel = mouseParticles[i].x - 1
				mouseParticles[i].x = mouseParticles[i].x + 1
			elseif mouseParticles[i].xtravel < 0 then
				mouseParticles[i].xtravel = mouseParticles[i].xtravel + 1
				mouseParticles[i].x = mouseParticles[i].x - 1
			end
			
			if mouseParticles[i].ytravel < 0 then
				mouseParticles[i].y = mouseParticles[i].y - 1
				mouseParticles[i].ytravel = mouseParticles[i].ytravel + 1
			elseif mouseParticles[i].ytravel >= 0 then
				mouseParticles[i].y = mouseParticles[i].y + 1
			end
			
			color({255, 255, 0, mouseParticles[i].alpha})
			draw(img_particle, mouseParticles[i].x + math.random(-10, 10), mouseParticles[i].y)
			
			mouseParticles[i].alpha = mouseParticles[i].alpha - 1
			
			if mouseParticles[i].alpha <= 0 then table.remove(mouseParticles, i) end
		end
	end
	
	color(white)
	
	if #mouseParticles <= 0 then return false else return true end
end

function anim.createImageToAlpha(img, x, y, minAlpha, alphaSpeed)
	alphaSpeed = alphaSpeed or 1
	minAlpha = minAlpha or 0
	
	anim.image, anim.startX, anim.startY, anim.speed = img, x, y, alphaSpeed
end

function anim.imageToAlpha()
	notMinAlpha = true
	
	color({255, 255, 255, anim.alpha})
	draw(anim.image, anim.startX, anim.startY)
	
	anim.alpha = anim.alpha - anim.speed
	
	if anim.alpha <= anim.minAlpha or anim.alpha <= 0 then
		notMinAlpha = false
	end
	
	return notMinAlpha
end
