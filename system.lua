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
__VER = 1.11

screenWidth = 800
screenHeight = 480
screenScale = 1
fullscreen = false

minFilter, magFilter = "nearest", "nearest"

gameSpeed = 0.020

red = {255, 0, 0}
green = {0, 255, 0}
blue = {0, 0, 255}
white = {255, 255, 255}
black = {0, 0, 0}
yellow = {255, 255, 0, 255}
cyan = {0, 255, 255, 255}
pink = {255, 0, 255, 255}
gold = {130, 127, 0, 255}
silver = {178, 178, 178, 255}

gameMessage = ""
messageAlpha = 0
errorText = ""

hugeFont = love.graphics.newFont("data/fonts/font1.ttf", 30)
largeFont = love.graphics.newFont("data/fonts/font1.ttf", 23)
bigFont = love.graphics.newFont("data/fonts/font1.ttf", 15)
smallFont = love.graphics.newFont("data/fonts/font1.ttf", 13)

gameCanvas = nil

events = {}

devel = false

function sleep(amount)
	love.timer.sleep(amount)
end

function setScreen()
	screenWidth = screenWidth*screenScale
	screenHeight = screenHeight*screenScale
	
	love.graphics.setMode(screenWidth, screenHeight, fullscreen, false)
	
	love.graphics.setBackgroundColor(black)
	
	gameCanvas = love.graphics.newCanvas(screenWidth, screenHeight)
end

function doError(e_msg, e_type)
	e_type = e_type or "nonfatal"
	
	if e_type == "fatal" then
		error("FATAL ERROR: " .. e_msg)
		killMe()
	elseif e_type == "nonfatal" then
		errorText = "ERROR: " .. e_msg .. "\nPress ESCAPE to continue. Game may become unstable."
		game.status = "error"
	elseif e_type == "warning" then
		print("WARNING: " .. e_msg)
	end
end

function addEvent(_event, _time)
	_time = _time or 1
	events[#events+1] = {_event, _time}
	if devel then print("=> EVENT :: " .. tostring(_event)) end
end

function doEvents()
	if #events > 0 then
		thisEvent = events[1][1]()
				
		if thisEvent == false then
			if devel then print("<= EVENT :: " .. tostring(events[1][1])) end
			table.remove(events, 1)
		end
	end
end

function color(_color)
	r, g, b, a = _color[1] or 0, _color[2] or 0, _color[3] or 0, _color[4] or 255
	
	love.graphics.setColor(r, g, b, a)
end

function draw(image, x, y, scaleX, scaleY)
	scaleX, scaleY = scaleX or screenScale, scaleY or screenScale
	x, y = x or 0, y or 0
	
	x, y = x*scaleX, y*scaleY
	
	love.graphics.setCanvas(gameCanvas)
	image:setFilter(minFilter, magFilter)
	love.graphics.draw(image, x, y, 0, screenScale, screenScale)
	love.graphics.setCanvas()
end

function drawq(image, quad, x, y, scaleX, scaleY)
	scaleX, scaleY = scaleX or screenScale, scaleY or screenScale
	x, y = x or 0, y or 0
	
	x, y = x*scaleX, y*screenScale*scaleY
	
	love.graphics.setCanvas(gameCanvas)
	love.graphics.drawq(image, quad, x, y, 0, scaleX, scaleY)
	love.graphics.setCanvas()
end

function rectangle(mode, x, y, w, h)
	x, y = x or 0, y or 0
	
	--x, y = x*screenScale, y*screenScale
	
	love.graphics.setCanvas(gameCanvas)
	love.graphics.rectangle(mode, x, y, w*screenScale, h*screenScale)
	love.graphics.setCanvas()
end

function lprint(text, x, y, scaleX, scaleY, font)
	scaleX, scaleY = scaleX or screenScale, scaleY or screenScale
	x, y = x or 0, y or 0
	
	x, y = x*scaleX, y*scaleY
	
	if font == nil then
		love.graphics.setFont(bigFont)
	else
		love.graphics.setFont(font)
	end
	
	love.graphics.setCanvas(gameCanvas)
	love.graphics.print(text, x, y, 0, screenScale, screenScale)
	love.graphics.setCanvas()
end

function message(text)
	gameMessage = text
	messageAlpha = 355
end

function clearWorld()
	love.graphics.setCanvas(gameCanvas)
	love.graphics.clear()
	love.graphics.setCanvas()
end

function drawWorld()
	love.graphics.draw(gameCanvas, 0, 0)
end

function killMe()
	love.event.push("quit")
end

function framesPerSecond(deltaTime)
	if deltaTime <= gameSpeed then
		love.timer.sleep(gameSpeed - deltaTime)
	end
end

function tableToString( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result, key_to_str( k ) .. "=" .. val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and tableToString( v ) or
      tostring( v )
  end
end

function key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. val_to_str( k ) .. "]"
  end
end
