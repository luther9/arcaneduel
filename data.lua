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

img_mouse = love.graphics.newImage("data/images/mouse.png")
img_background = love.graphics.newImage("data/images/background.png")
img_deckMany = love.graphics.newImage("data/images/deckMany.png")
img_deckMid = love.graphics.newImage("data/images/deckMid.png")
img_deckLow = love.graphics.newImage("data/images/deckLow.png")
img_card = love.graphics.newImage("data/images/cards/background.png")
img_lose = love.graphics.newImage("data/images/loseBack.png")
img_win = love.graphics.newImage("data/images/winBack.png")
img_draw = love.graphics.newImage("data/images/drawBack.png")
img_statusBubble = love.graphics.newImage("data/images/statusBubble.png")
img_energyIcon = love.graphics.newImage("data/images/energyIcon.png")
img_particle = love.graphics.newImage("data/images/particle.png")
img_elemental = love.graphics.newImage("data/images/elementalSymbol.png")
img_nature = love.graphics.newImage("data/images/natureSymbol.png")
img_mystic = love.graphics.newImage("data/images/mysticSymbol.png")
img_dark = love.graphics.newImage("data/images/darkSymbol.png")
img_void = love.graphics.newImage("data/images/voidSymbol.png")
img_passTurn = love.graphics.newImage("data/images/cards/passTurn.png")

-- ###################################################
-- ###################################################

elementColors = {}
elementColors["elemental"] = {255, 0, 0, 255}
elementColors["mystic"] = {255, 255, 0, 255}
elementColors["dark"] = {255, 0, 255, 255}
elementColors["nature"] = {0, 255, 0, 255}
elementColors["void"] = {100, 200, 255, 255}

-- ###################################################
-- ###################################################

companions = {}
-- image | damage | health | isMagical
companions["Hound"] = {icon = love.graphics.newImage("data/images/companions/Hound.png"), damage = 1, health = 10, isMagical = false, skill = function() return false end,
																																			skillDesc = ""}
																																			
companions["Skeleton"] = {icon = love.graphics.newImage("data/images/companions/Skeleton.png"), damage = 0, health = 13, isMagical = false, skill = function() return false end,
																																			skillDesc = ""}
																																			
companions["Imp"] = {icon = love.graphics.newImage("data/images/companions/Imp.png"), damage = 2, health = 8, isMagical = false, skill = function(who)
																																				if who == "enemy" then 
																																					player.hp = player.hp - 1 
																																				else 
																																					enemy.hp = enemy.hp - 1
																																				end
																																			end,
																																	skillDesc = "At the end of it's owner\nturn, deals 1 damage to\nenemy"}
																																	
companions["Unicorn"] = {icon = love.graphics.newImage("data/images/companions/Unicorn.png"), damage = 2, health = 10, isMagical = true, skill = function() return false end,
																																			skillDesc = ""}
																																			
companions["Dragonkin"] = {icon = love.graphics.newImage("data/images/companions/Dragonkin.png"), damage = 3, health = 7, isMagical = true, skill = function() 
																																						player.hp = player.hp - 1
																																						enemy.hp = enemy.hp - 1
																																					end,
																																			skillDesc = "At the end of it's owner\nturn deals 1 damage to all\nplayers"}

companions["Golem"] = {icon = love.graphics.newImage("data/images/companions/Golem.png"), damage = 0, health = 8, isMagical = false, skill = function(who) 
																																						if who == "enemy" then
																																							enemy.companion[2] = enemy.companion[2] + 1
																																							if enemy.companion[2] > 6 then
																																								enemy.companion[2] = 6
																																							end
																																						else
																																							player.companion[2] = player.companion[2] + 1
																																							if player.companion[2] > 6 then
																																								player.companion[2] = 6
																																							end
																																						end
																																					end,
																																			skillDesc = "At the end of it's owner\nturn Golem regenerates\n1 health point"}

companions["Nightmare"] = {icon = love.graphics.newImage("data/images/companions/Nightmare.png"), damage = 3, health = 5, isMagical = false, skill = function(who) 
																																						if who == "enemy" then
																																							enemy.hp = enemy.hp - 1
																																						else
																																							player.hp = player.hp - 1
																																						end
																																					end,
																																			skillDesc = "At the end of it's owner\nNightmare deals to\nowner 1 damage"}

companions["VoidMage"] = {icon = love.graphics.newImage("data/images/companions/VoidMage.png"), damage = 1, health = 5, isMagical = true, skill = function(who) 
																																						if who == "enemy" then
																																							if enemy.energy >= game.maxPlayerEnergy - 1 then
																																								enemy.hp = enemy.hp - 2
																																							end
																																							
																																							enemy.energy = enemy.energy + 1
																																							
																																							if enemy.energy >= game.maxPlayerEnergy then
																																								enemy.energy = game.maxPlayerEnergy
																																							end
																																						else
																																							if player.energy >= game.maxPlayerEnergy - 1 then
																																								player.hp = player.hp - 2
																																							end
																																							
																																							player.energy = player.energy + 1
																																							
																																							if player.energy >= game.maxPlayerEnergy then
																																								player.energy = game.maxPlayerEnergy
																																							end
																																						end
																																					end,
																																			skillDesc = "At the end of it's owner\nVoid Mage gives to\nowner 1 energy"}

companions["Kami"] = {icon = love.graphics.newImage("data/images/companions/Kami.png"), damage = 2, health = 7, isMagical = true, skill = function(who) 
																																				if who == "enemy" then
																																					if enemy.defense <= 0 then
																																						enemy.defense = 1
																																						anim.createMouseParticles(20, 608*screenScale, 193*screenScale)
																																					end
																																				else
																																					if player.defense <= 0 then
																																						player.defense = 1
																																						anim.createMouseParticles(20, 608*screenScale, 289*screenScale)
																																					end
																																				end
																																				
																																				player.curse = 0
																																				enemy.curse = 0
																																			end,
																																			skillDesc = "Removes all curses in all\nplayers and sets your\ndefense to 1 if it's zero"}

cards = {}
-- 1.11
-- Magic Schools: elemental, nature, mystic, void, dark

-- 0.91
-- actions: poison:[turns, damage], defense:[def_amount], curse:[curse_amount], damage:[damage_amount], dispelEnemy:[none], dispelSelf:[none], heal:[amount]
cards[1] = {icon = love.graphics.newImage("data/images/cards/Poison.png"), name = "Poison", school = "nature", energy = 0, value = 1, action = {"poison", 1, 4}, description = "Sets poison in your enemy body \nmaking him to receive 1 damage\nevery turn for 4 turns"}
cards[2] = {icon = love.graphics.newImage("data/images/cards/Bless.png"), name = "Bless", school = "mystic", energy = 1, value = 3, action = {"defense", 1}, description = "A holy praying that will increase\nyour resistance against any\nmagical attack, increasing your\ndefense by 1"} 
cards[3] = {icon = love.graphics.newImage("data/images/cards/Curse.png"), name = "Curse", school = "dark", energy = 1, value = 4, action = {"curse", 1}, description = "A shadow word from darkness\nturning your enemy weak and\nvulnerable to your attacks\nincreasing magical damage\nreceived by 1"}
cards[4] = {icon = love.graphics.newImage("data/images/cards/Venom.png"), name = "Venom", school = "nature", energy = 1, value = 2, action = {"poison", 2, 3}, description = "Throws a venomous cloud at \nyour enemy, making him\nto receive 2 damage every\nturn for 3 turns"}
cards[5] = {icon = love.graphics.newImage("data/images/cards/Acid.png"), name = "Acid", school = "dark", energy = 2, value = 3, action = {"poison", 2, 4}, description = "Summons a pool of pure acid  \nslowly melting your enemy's flesh\nand bones dealing 2 damage every\nturn for 4 turns"}
cards[6] = {icon = love.graphics.newImage("data/images/cards/Spark.png"), name = "Spark", school = "elemental", energy = 1, value = 1, action = {"damage", 3}, description = "Throws a burning spark at your\nenemy to deal him 3 damage"}
cards[7] = {icon = love.graphics.newImage("data/images/cards/Shock.png"), name = "Shock", school = "elemental", energy = 2, value = 2, action = {"damage", 6}, description = "You create pure electricity that\nwill be thrown at your enemy to\ndeal him 6 damage"}
cards[8] = {icon = love.graphics.newImage("data/images/cards/Lightning.png"), name = "Lightning", school = "elemental", energy = 3, value = 3, action = {"damage", 9}, description = "You create a terrifying storm\nto electrocute your enemy and\ndeal him 9 damage"}
cards[9] = {icon = love.graphics.newImage("data/images/cards/Burn.png"), name = "Burn", school = "elemental", energy = 0, value = 1, action = {"damage", 2}, description = "Concentrating pure heat in the\nenemy body, you burn him alive\nfor 2 damage"}
cards[10] = {icon = love.graphics.newImage("data/images/cards/Incinerate.png"), name = "Incinerate", school = "elemental", energy = 2, value = 2, action = {"damage", 5}, description = "You send at your enemy a\nbeam of pure heat and flames to\ndeal him 5 damage"}
cards[11] = {icon = love.graphics.newImage("data/images/cards/FireRain.png"), name = "Fire\nRain", school = "elemental", energy = 3, value = 3, action = {"damage", 10}, description = "You melt the sky itself to make\nit fall upon your enemy to deal\nhim 8 damage"}
cards[12] = {icon = love.graphics.newImage("data/images/cards/DispelEnemy.png"), name = "Dispel\nEnemy", school = "void", energy = 3, value = 2, action = {"dispelEnemy"}, description = "Manipulates the enemy magic\npower to dispell all magical stats\non him"}
cards[13] = {icon = love.graphics.newImage("data/images/cards/DispelSelf.png"), name = "Dispel\nSelf", school = "void", energy = 2, value = 1, action = {"dispelSelf"}, description = "You concentrate part of your own\nmagic power on you to dispell\nevery magic stats on you"}
cards[14] = {icon = love.graphics.newImage("data/images/cards/Cure.png"), name = "Cure", school = "nature", energy = 1, value = 1, action = {"curePoison"}, description = "Cleanses your body removing\nall periodic damage effects on you"}
cards[15] = {icon = love.graphics.newImage("data/images/cards/MagicShield.png"), name = "Magic\nShield", school = "mystic", energy = 2, value = 4, action = {"defense", 2}, description = "You create a shield of\nenergy around your that will\nincrease your resistance agains all\nmagical damage by 2"}
cards[16] = {icon = love.graphics.newImage("data/images/cards/Desintegrate.png"), name = "Disinte-\ngrate", school = "dark", energy = 5, value = 4, action = {"damage", 12}, description = "A fearful spell that creates a\nwave of destruction that will\npunish your enemy, dealing 12\ndamage"}
cards[17] = {icon = love.graphics.newImage("data/images/cards/Renew.png"), name = "Renew", school = "nature", energy = 0, value = 1, action = {"heal", 5}, description = "A healing spell that will recover\npart of the damage dealt to you\nhealing you for 5"}
cards[18] = {icon = love.graphics.newImage("data/images/cards/Revive.png"), name = "Revive", school = "mystic", energy = 2, value = 1, action = {"heal", 10}, description = "Calls upon you the essence of life\ngiving you back up to 10 health\npoints lost."}


-- 1.0
-- actions: damageall:[damage], udamage:[damage], damagedot:[damage, damage, turns], uncurseall:[none], discard:[amount], damagecurse:[damage,curse]
cards[19] = {icon = love.graphics.newImage("data/images/cards/Meteor.png"), name = "Meteor", school = "nature", energy = 3, value = 3, action = {"damageall", 10}, description = "Creates a great meteor that\nwill destroy every form of life\ndealing 10 damage to all players\nand companions"}
cards[20] = {icon = love.graphics.newImage("data/images/cards/Implossion.png"), name = "Implossion", school = "elemental", energy = 2, value = 2, action = {"udamage", 3}, description = "Converts the enemy body into\na timed bomb that will detonate\ndealing 3 damage. This damage\nis unaffected by the enemy\ndefense amount."}
cards[21] = {icon = love.graphics.newImage("data/images/cards/Malediction.png"), name = "Maledic-\ntion", school = "dark", energy = 2, value = 5, action = {"curse", 2}, description = "Curses your enemy with terrible\nwords of darkness, making him\nvulnerable to all magic attacks and\nincreasing damage received by 2"}
cards[22] = {icon = love.graphics.newImage("data/images/cards/AcidSplash.png"), name = "Acid\nSplash", school = "nature", energy = 3, value = 4, action = {"damagedot", 4, 1, 4}, description = "Hurls an acidic ball to your\nenemy dealing 4 damage and\npoisoning him for 1 damage\nduring 4 turns"}
cards[23] = {icon = love.graphics.newImage("data/images/cards/Benediction.png"), name = "Benedic-\ntion", school = "mystic", energy = 2, value = 0, action = {"uncurseall"}, description = "A praying of hope that removes\nall curse effects in all players"}
cards[24] = {icon = love.graphics.newImage("data/images/cards/MemoryLeak.png"), name = "Memory\nLeak", school = "void", energy = 1, value = 0, action = {"discard", 1}, description = "Access the enemy mind creating\nmomentary confussion on him\nand forcing him to forget one\nspell"}
cards[25] = {icon = love.graphics.newImage("data/images/cards/Lobotomy.png"), name = "Lobotomy", school = "void", energy = 2, value = 1, action = {"discard", 2}, description = "Reaches the most inner part\nof enemy mind, extracting from\nhim two spells and forcing him to\nforget them"}
cards[26] = {icon = love.graphics.newImage("data/images/cards/EmberRune.png"), name = "Rune of\nEmbers", school = "elemental", energy = 3, value = 3, action = {"damagecurse", 3, 1}, description = "Places a flaming rune on\nyour enemy to deal 3 damage\nand increasing his vulnerablity\nto magic"}
cards[27] = {icon = love.graphics.newImage("data/images/cards/IceRain.png"), name = "Icerain", school = "nature", energy = 3, value = 3, action = {"udamage", 4}, description = "Summons sharpened ice shards\nand makes them to fall upon your\nenemy at great speed, dealing\n4 damage. This damage is\nunaffected by enemy defense\namount."}

-- 1.10
-- actions: companion:[companion_name], banish:[none], destroy:[limit]
cards[28] = {icon = love.graphics.newImage("data/images/cards/SummonHound.png"), name = "Summon\nHound", school = "nature", energy = 1, value = 1, action = {"companion", "Hound"}, description = "Summons a fierce hound to aid\nyou during combat with 10 health\nand 1 damage."}
cards[29] = {icon = love.graphics.newImage("data/images/cards/SummonImp.png"), name = "Summon\nImp", school = "dark", energy = 1, value = 1, action = {"companion", "Imp"}, description = "Summons a magical imp that will\naid you in combat with 8 health\ndealing 2 damage."}
cards[30] = {icon = love.graphics.newImage("data/images/cards/SummonUnicorn.png"), name = "Summon\nUnicorn", school = "mystic", energy = 2, value = 4, action = {"companion", "Unicorn"}, description = "Summons a mystical unicorn that\nwill aid you in combat that has\n10 health and deals 2 damage."}
cards[31] = {icon = love.graphics.newImage("data/images/cards/SummonSkeleton.png"), name = "Summon\nSkeleton", school = "dark", energy = 0, value = 4, action = {"companion", "Skeleton"}, description = "Reanimates a humanoid skeleton\nto server you until dead.\nHe has 13 health but deals no\ndamage"}
cards[32] = {icon = love.graphics.newImage("data/images/cards/SummonDragonkin.png"), name = "Summon\nDragonkin", school = "elemental", energy = 3, value = 4, action = {"companion", "Dragonkin"}, description = "Calls a Dragonkin to aid you in\nbattle, and is able to deal 3\ndamage and with a total health of\n7"}
cards[33] = {icon = love.graphics.newImage("data/images/cards/Unsummon.png"), name = "Unsumon\nCreature", school = "void", energy = 4, value = 1, action = {"banish"}, description = "Unsummons the enemy creature\nsending him back to the\nnetherworld."}
cards[34] = {icon = love.graphics.newImage("data/images/cards/Obliterate.png"), name = "Obliterate", school = "dark", energy = 2, value = 0, action = {"destroy", 8}, description = "Destroys the enemy companion\nif his health is at or below 8"}
cards[35] = {icon = love.graphics.newImage("data/images/cards/SalvePotion.png"), name = "Healing\nSalve", school = "nature", energy = 3, value = 2, action = {"heal", 15}, description = "A potion that contains pure\nessence of light and life that\nwill grant you a total amount of\n15 health regeneration."}

-- 1.11
-- actions: energytodamage:[damage, damage_per_energy], giveenergy:[energy], removeenergy:[energy], companiontodamage:[damage_percent], magicschool:[school, amount]
cards[36] = {icon = love.graphics.newImage("data/images/cards/Exile.png"), name = "Exile", school = "mystic", energy = 1, value = 0, action = {"destroy", 4}, description = "Destroys the enemy companion\nif his health is at or below 4"}
cards[37] = {icon = love.graphics.newImage("data/images/cards/DeadlyToxin.png"), name = "Deadly\nToxin", school = "dark", energy = 3, value = 1, action = {"poison", 4, 3}, description = "Grows terrible toxins in your\nenemy body, dealing 4 damage\nevery turn for 3 turns"}
cards[38] = {icon = love.graphics.newImage("data/images/cards/EnergyRay.png"), name = "Energy\nRay", school = "void", energy = 0, value = 1, action = {"energytodamage", 2, 2}, description = "Redirects all your energy towards\nyour enemy to deal him 2\ndamage plus 2 damage per each\npoint of energy you have.\nThis spell consumes all your\nenergy."}
cards[39] = {icon = love.graphics.newImage("data/images/cards/BlastOfLight.png"), name = "Blast of\nLight", school = "mystic", energy = 3, value = 2, action = {"damage", 5}, description = "Creates a ball of pure light to\npunish your enemy dealing him\n5 damage"}
cards[40] = {icon = love.graphics.newImage("data/images/cards/CallOfGrave.png"), name = "Call of\nthe Grave", school = "dark", energy = 3, value = 2, action = {"damage", 7}, description = "You remove life essence from\nyour enemy, calling it to the grave\nand dealing him 7 damage."}
cards[41] = {icon = love.graphics.newImage("data/images/cards/EnergyVial.png"), name = "Energy\nVial", school = "void", energy = 0, value = 3, action = {"giveenergy", 1}, description = "A small vial that contains\na little amount of energy essence\nthat you can use to recover 1 point\nof energy"}
cards[42] = {icon = love.graphics.newImage("data/images/cards/EnergyPotion.png"), name = "Energy\nPotion", school = "void", energy = 1, value = 4, action = {"giveenergy", 2}, description = "A bigger potion of energy\nwith a moderate amount of energy\nessence, granting you up to 2\npoints of energy"}
cards[43] = {icon = love.graphics.newImage("data/images/cards/EnergyFlask.png"), name = "Energy\nFlask", school = "void", energy = 2, value = 5, action = {"giveenergy", 4}, description = "This flask contains a large\namount of magic essence, that\nwill recover a total of 4 energy\npoints"}
cards[44] = {icon = love.graphics.newImage("data/images/cards/EnergySink.png"), name = "Energy\nSink", school = "void", energy = 1, value = 1, action = {"removeenergy", 3}, description = "Destroy up to 2 energy points\nfrom your enemy energy reserve."}
cards[45] = {icon = love.graphics.newImage("data/images/cards/DestroyMind.png"), name = "Destroy\nMind", school = "void", energy = 2, value = 2, action = {"removeenergy", 4}, description = "Assaults the enemy's mind to\ndestroy up to 4 points of magic\nenergy"}
cards[46] = {icon = love.graphics.newImage("data/images/cards/Pyroblast.png"), name = "Pyroblast", school = "elemental", energy = 4, value = 4, action = {"damagedot", 7, 1, 6}, description = "Hurls a giant ball of flames and\nmagma that will anihilate your\nenemy dealing him 6 damage and\nmaking him to burn for 1 extra\ndamage each turn during 6 turns"}
cards[47] = {icon = love.graphics.newImage("data/images/cards/NatureWrath.png"), name = "Nature's\nWrath", school = "nature", energy = 3, value = 2, action = {"damage", 6}, description = "Summons a destructive hurricane\nthat will destroy everything in\nit's path and dealing 6 damage\nto your enemy."}
cards[48] = {icon = love.graphics.newImage("data/images/cards/Betrayal.png"), name = "Betrayal", school = "dark", energy = 4, value = 4, action = {"companiontodamage", 250}, description = "A dark pact with your enemy's\ncompanion that will make him to\nattack his master dealing him\ndamage equal to 250% of the\ncompanion's attack.\nThis damage can't be blocked or\nreduced by defense."}
cards[49] = {icon = love.graphics.newImage("data/images/cards/NatureBalance.png"), name = "Nature's\nBalance", school = "nature", energy = 5, value = 4, action = {"healboth", 10}, description = "A gift of the nature that will heal\nyou and your companion by up to\n10 health points."}
cards[50] = {icon = love.graphics.newImage("data/images/cards/Nightfall.png"), name = "Nightfall", school = "dark", energy = 4, value = 4, action = {"magicschool", "dark", 1}, description = "A dark ritual that will increase\nyour Dark Magic School level by\n1"}
cards[51] = {icon = love.graphics.newImage("data/images/cards/ChaosVortex.png"), name = "Chaos\nVortex", school = "void", energy = 4, value = 4, action = {"magicschool", "void", 1}, description = "Summons a chaos vortex that will\nincreate your Void Magic School\nlevel by 1"}
cards[52] = {icon = love.graphics.newImage("data/images/cards/Radiance.png"), name = "Radiance", school = "mystic", energy = 4, value = 4, action = {"magicschool", "mystic", 1}, description = "Creates a radiant light that will\nincrease your Mystic Magic\nSchool level by 1"}
cards[53] = {icon = love.graphics.newImage("data/images/cards/WildGrowth.png"), name = "Wild\nGrowth", school = "nature", energy = 4, value = 4, action = {"magicschool", "nature", 1}, description = "Makes nature to growth wild\nincreasing your Nature Magic\nSchool level by 1"}
cards[54] = {icon = love.graphics.newImage("data/images/cards/OminousWrath.png"), name = "Ominous\nWrath", school = "elemental", energy = 4, value = 4, action = {"magicschool", "elemental", 1}, description = "A wave or rage and wrath\nthat fills you with destructive\npower increasing you Elemental\nMagic School level by 1"}
cards[55] = {icon = love.graphics.newImage("data/images/cards/Cataclysm.png"), name = "Cataclysm", school = "elemental", energy = 5, value = 4, action = {"damageall", 15}, description = "Calls forth the whole power of\nelements creating a devastating\ncataclysm to deal 15 damage to\nall players and companions"}
cards[56] = {icon = love.graphics.newImage("data/images/cards/SummonGolem.png"), name = "Summon\nGolem", school = "nature", energy = 3, value = 3, action = {"companion", "Golem"}, description = "Creates a stone and wood golem\nwith 8 health but unable to attack.\nThe Golem will regenerate 1 health\npoint at the end of each turn"}
cards[57] = {icon = love.graphics.newImage("data/images/cards/SummonNightmare.png"), name = "Summon\nNightmare", school = "dark", energy = 1, value = 4, action = {"companion", "Nightmare"}, description = "Summons a bone a flesh creature\nwith 5 health, that will deal 3\ndamage to enemy.\nNightmare deals also 1 point of\ndamage to it's owner at the end of\nthe turn"}
cards[58] = {icon = love.graphics.newImage("data/images/cards/SummonVoidMage.png"), name = "Summon\nVoidmage", school = "void", energy = 4, value = 4, action = {"companion", "VoidMage"}, description = "Summons a Void Mage with 5\nhealth, that will deal 1 damage to\nenemy. While Void Mage is in\nplay if your energy amount is " .. game.maxPlayerEnergy - 1 .. " or\nmore you recive 2 damage at the\nend of your turn. At the end of\nyour turn Void Mage gives\nyou 1 energy point."}
cards[59] = {icon = love.graphics.newImage("data/images/cards/SummonKami.png"), name = "Summon\nKami", school = "mystic", energy = 1, value = 4, action = {"companion", "Kami"}, description = "Calls a helpful Kami God to aid\nyou in combat with 7 health and\nable to do 2 damage. At the\nend of your turn if your defense\nis zero, Kami will increase it by 1.\nAt the end of your turn, Kami\nwill dispell all curses in all\nplayers."}
