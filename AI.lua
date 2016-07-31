actionValues = {}
actionValues["poison"] = {function(act, cost)
								result = 0
								if player.poisonTurns * player.poisonDamage < (act[2]*act[3])/2 then
									result = result + 1
								else
									result = result - 2
								end
								
								hpPercentage = enemy.hp*100/game.maxPlayerHealth
								
								if hpPercentage <= 20 then result = result - 4 end
								
								if playerCanDie() then result = result - 10 end
								
								if cost > 0 then
									efficiency = act[2]*act[3]/cost
									if efficiency <= 2 then result = result - 1
									elseif efficiency > 2 then result = result + 1 end
								elseif cost <= 0 then
									result = result + 1
								end
								
								return result
						  end}
actionValues["defense"] = {function(act, cost) 
							result = 0
							hpPercentage = enemy.hp*100/game.maxPlayerHealth
							
							if enemy.defense >= act[2] then result = result - 10 end
							if enemy.defense <= 0 and hpPercentage >= 30 then result = result + 3 end
							
							result = result + enemy.curse
							
							if playerCanDie() then result = result - 10 end
							
							if cost > 0 then
								efficiency = act[2]/cost
								if efficiency < 1 then result = result - 1
								elseif efficiency >= 1 then result = result + 1 end
							elseif cost <= 0 then
								result = result + 1
							end
							
							return result
						  end}
actionValues["curse"] = {function(act, cost)
							result = 0
							if player.curse >= act[2] then
								result = result - 10
							else
								result = result + player.defense + act[2]
							end
							
							if player.curse <= 0 then result = result + 2 end
							
							if playerCanDie() then result = result - 10 end
							
							if cost > 0 then
								efficiency = act[2]/cost
								if efficiency < 1 then result = result - 1
								elseif efficiency >= 1 then result = result + 1 end
							elseif cost <= 0 then
								result = result + 1
							end
							
							if enemy.companion[1] == "Kami" or player.companion[1] == "Kami" then
								result = result - 10
							end
							
							return result
						 end}
actionValues["damage"] = {function(act, cost)
							result = 0
							
							if player.curse <= 0 then
								result = result - 1
							end
							
							if cost > 0 then
								efficiency = act[2]/cost
								if efficiency <= 2 then result = result - 1
								elseif efficiency > 2 then 
									result = result + act[2]/2 + efficiency
								end
							elseif cost <= 0 then
								result = result + act[2]/2 + 4
							end
							
							if act[2] + player.curse <= player.defense then
								result = result - 4
							end
							
							playerHealthPercentage = player.hp*100/game.maxPlayerHealth
							enemyHealthPercentage = enemy.hp*100/game.maxPlayerHealth
							
							if enemyHealthPercentage - playerHealthPercentage >= 0 then
								if playerHealthPercentage > 50 then
									result = result + 1
								elseif playerHealthPercentage > 25 and playerHealthPercentage <= 50 then
									result = result + 2
								elseif playerHealthPercentage <= 25 then
									result = result + 3
								end
							else
								if playerCanDie() then
									result = result + 2
								else
									result = result + 1
								end
							end
							
							result = result + player.curse
							
							return result
						   end}
actionValues["dispelEnemy"] = {function(act, cost) 
									result = 0
									if player.defense <= 0 then
										result = result - 10
									else
										result = player.defense - player.curse 
									end
									
									if playerCanDie() then result = result - 10 end
									
									return result
								end}
actionValues["dispelSelf"] = {function(act, cost) 
									result = 0
									if enemy.curse <= 0 and enemy.defense > 0 then
										result = result - 10
									end
									if enemy.curse >= player.curse + 1 and enemy.defense + 1 <= player.defense then
										result = result + 1
									end
									if enemy.defense <= 0 and enemy.curse >= 0 and player.defense >= 0 and player.curse >= 0 then
										result = result + 2
									end
									if player.defense <= 0 then
										result = result - 10
									end
									
									if playerCanDie() then result = result - 10 end
									
									return result
							  end}
actionValues["heal"] = {function(act, cost) 
							result = 0
							halfHealPower = math.floor(act[2]/2)
							lostHealth = game.maxPlayerHealth - enemy.hp
							damageSpell = 0
							
							if halfHealPower > lostHealth then result = result - 10 end
							
							if lostHealth >= game.maxPlayerHealth/2 then result = result + 2 end
							if lostHealth >= game.maxPlayerHealth/3 then result = result + 3 end
							if enemy.hp*2 <= player.hp then result = result + 2 end
							if enemy.companion[1] ~= "" and player.companion[1] ~= "" then
								if enemy.companion[2] >= 5 then result = result - 1 end
								if enemy.companion[2] < 5 then result = result + 1 end
							end
							if enemy.defense >= 2 then result = result - 1 end
							if enemy.hp <= 10 then result = result + act[2] end
							if enemy.poisonDamage >= enemy.hp then result = result + 3 end
							
							if player.poisonDamage >= player.hp then result = result - 3 end
							if player.hp*2 <= enemy.hp then result = result - 2 end
							if player.hp*100/game.maxPlayerHealth <= 15 then result = result - 1 end
							
							if playerCanDie() then result = result - 10 end
							
							if cost > 0 then
								efficiency = act[2]/cost
								if efficiency < 5 then result = result - 1
								elseif efficiency >= 5 then result = result + 1 end
							elseif cost <= 0 then
								result = result + 1
							end
							
							return result
						end}
actionValues["damageall"] = {function(act, cost) 
								result = 0
								
								if player.companion[1] ~= "" then
									if player.companion[2] <= act[2] then
										result = result + 1
									else
										result = result - 2
									end
								else
									result = result - 3
								end
								
								if player.hp < enemy.hp then
									result = result + 1
								else
									result = result - 2
								end
								
								
								hasHeal = false
								for i = 1, 5 do
									thisCard = cards[ enemySlots[i] ]
									
									if thisCard.action[1] == "heal" then
										hasHeal = true
									end
								end
								
								if hasHeal then
									result = result + 1
								else
									result = result - 2
								end
								
								if enemy.hp <= act[2] then result = result - 10 end
								if player.hp + player.defense <= act[2] then result = result + 2 end
								
								if cost > 0 then
									efficiency = act[2]/cost
									if efficiency < 5 then result = result - 1
									elseif efficiency >= 5 then result = result + 1 end
								elseif cost <= 0 then
									result = result + 1
								end
								
								return result
							end}
actionValues["udamage"] = {function(act, cost) 
								result = 0
							
								if player.curse <= 0 then
									result = result - 1
								end
								
								playerHealthPercentage = player.hp*100/game.maxPlayerHealth
								enemyHealthPercentage = enemy.hp*100/game.maxPlayerHealth
								
								if enemyHealthPercentage - playerHealthPercentage >= 0 then
									if playerHealthPercentage > 50 then
										result = result + 1
									elseif playerHealthPercentage > 25 and playerHealthPercentage <= 50 then
										result = result + 2
									elseif playerHealthPercentage <= 25 then
										result = result + 3
									end
								else
									if playerCanDie() then
										result = result + 2
									else
										result = result + 1
									end
								end
								
								result = result + player.curse
								
								if cost > 0 then
									efficiency = act[2]/cost
									if efficiency < 1.5 then result = result - 1
									elseif efficiency >= 1.5 then result = result + 1 end
								elseif cost <= 0 then
									result = result + 2
								end
								
								return result
							end}
actionValues["damagedot"] = {function(act, cost) 
									result = player.curse
									
									totalDamage = act[2] + act[3]*act[4]
									
									playerRemainingDamage = player.poisonTurns*player.poisonDamage
										
									if playerRemainingDamage >= totalDamage then
										result = result - 3
									else
										result = result + 2
									end
									
									if player.poisonTurns > 1 then 
										result = result - 1
									end
									
									if cost > 0 then
										efficiency = (act[2] + act[3]*act[4])/cost
										if efficiency < 3 then result = result - 1
										elseif efficiency >= 3 then result = result + 1 end
									elseif cost <= 0 then
										result = result + 1
									end
									
									return result
								end}
actionValues["damagecurse"] = {function(act, cost) 
									result = 0
									
									result = result + act[2]
									
									if player.curse <= 0 then result = result + 1 end
									if player.defense >= act[2] then 
										result = result - 1
									else
										result = result + 1
									end
									
									if cost > 0 then
										efficiency = act[2]/cost
										if efficiency < 1 then result = result - 1
										elseif efficiency >= 1 then result = result + 1 end
									elseif cost <= 0 then
										result = result + 1
									end
									
									if cost > 0 then
										efficiency = act[3]/cost
										if efficiency < 0.3 then result = result - 1
										elseif efficiency >= 0.3 then result = result + 1 end
									elseif cost <= 0 then
										result = result + 1
									end
									
									return result
								end}
actionValues["uncurseall"] = {function(act, cost) 
								result = 0
								result =  enemy.curse - player.curse 
								
								if playerCanDie() then result = result - 10 end
								
								return result
							  end}
actionValues["discard"] = {function(act, cost) 
								result = 0
								
								if playerCanDie() then result = result - 10 end
								
								result = deck.maxCards/#playerDeck - game.maxPlayerHealth/player.hp - game.maxPlayerHealth/enemy.hp
								
								if cost > 0 then
									efficiency = act[2]/cost
									if efficiency < 1 then result = result - 1
									elseif efficiency >= 1 then result = result + 1 end
								elseif cost <= 0 then
									result = result + 1
								end
								
								return result
							end}
actionValues["curePoison"] = {function(act, cost)
									result = 0
									hasHeal = false
									
									if enemy.poisonTurns >= 1 then
										if enemy.poisonDamage*enemy.poisonTurns > 4 then
											result = result + enemy.poisonDamage*enemy.poisonTurns
										else
											result = result - 1
										end
										if enemy.poisonDamage >= enemy.hp then result = result + 3 end
									end
									
									if enemy.poisonTurns <= 1 and enemy.poisonTurns > 0 then result = result - 1 end
									if enemy.poisonTurns <= 0 then result = result - 10 end
									
									if playerCanDie() then result = result - 10 end
									
									return result
							  end}
actionValues["companion"] = {function(act, cost) 
								result = 0
								
								newCompanionDamage = companions[ act[2] ].damage
								newCompanionHealth = companions[ act[2] ].health
								
								result = result + newCompanionDamage/cost
								
								if newCompanionDamage <= 0 then result = result - 1 end
								
								if enemy.companion[1] ~= "" then
									companionDamage = companions[ enemy.companion[1] ].damage
									companionMaxHealth = companions[ enemy.companion[1] ].health
									companionHealth = enemy.companion[2]
									if companionDamage < newCompanionDamage then
										if newCompanionDamage - companionDamage >= 3 then
											result = result - 3
										elseif newCompanionDamage - companionDamage >= 2 and newCompanionDamage - companionDamage < 3 then
											result = result - 2
										elseif newCompanionDamage - companionDamage < 2 then
											result = result - 1
										end
									end
									
									if newCompanionDamage <= player.defense then
										result = result - 1
									end
									
									if enemy.companion[2] < companionMaxHealth then
										if companionMaxHealth - enemy.companion[2] >= 7 then
											result = result + 3
										elseif companionMaxHealth - enemy.companion[2] < 7 and companionMaxHealth - enemy.companion[2] >= 4 then
											result = result + 2
										elseif companionMaxHealth - enemy.companion[2] < 4 and companionMaxHealth - enemy.companion[2] >= 2 then
											result = result + 1
										end
									else
										if companionHealth < newCompanionHealth then
											if newCompanionHealth - companionHealth >= 3 then
												result = result - 3
											elseif newCompanionHealth - companionHealth >= 2 and newCompanionHealth - companionHealth < 3 then
												result = result - 2
											elseif newCompanionHealth - companionHealth < 2 then
												result = result - 1
											end
										else
											if companionHealth - newCompanionHealth >= 3 then
												result = result - 3
											elseif companionHealth - newCompanionHealth >= 2 and companionHealth - newCompanionHealth < 3 then
												result = result - 2
											elseif companionHealth - newCompanionHealth < 2 then
												result = result - 1
											end
										end
									end
									
									if player.companion[1] ~= "" then
										if newCompanionDamage > companionDamage then
											result = result + 3
										else
											result = result - 3
										end
										
										if companions[ enemy.companion[1] ].damage > 0 then result = result - 3 end
									end
								else
									result = result + 2
								end
								
								if player.companion[1] ~= "" and enemy.companion[1] == "" then
									result = result + 1
									if enemy.defense < companions[ player.companion[1] ].damage then
										result = result + companions[ player.companion[1] ].damage - enemy.defense
									else
										result = result - 1
									end
								end
								
								if playerCanDie() then result = result - 10 end
								
								return result
								end}
actionValues["banish"] = {function(act, cost) 
								result = 0
								if player.companion[1] ~= "" then
									result = result + companions[ player.companion[1] ].damage - 1
								else
									result = result - 10
								end
								
								if playerCanDie() then result = result - 10 end
								
								return  result
							end}
actionValues["destroy"] = {function(act, cost) 
								result = 0
								if player.companion[1] ~= "" then
									if player.companion[2] <= act[2] then
										result = result + companions[ player.companion[1] ].damage - (player.companion[2] - companions[ player.companion[1] ].health)
									else
										result = result - 10
									end
								else
									result = result - 10
								end
								if enemy.companion[1] == "" then
									result = result - enemy.defense
								end
								
								if playerCanDie() then result = result - 10 end
								
								if cost > 0 then
									efficiency = act[2]/cost
									if efficiency < 4 then result = result - 1
									elseif efficiency >= 4 then result = result + 1 end
								elseif cost <= 0 then
									result = result + 1
								end
								
								return result
						   end}
actionValues["energytodamage"] = {function(act, cost)
									result = 0
									
									result = enemy.energy
									
									if act[2] + act[3]*enemy.energy <= player.defense then 
										result = result - 10
									else
										result = result + game.maxPlayerHealth/player.hp - player.curse - player.defense
									end
									
									if enemy.energy <= 2 then
										result = result - enemy.energy
									end
									
									if cost > 0 then
										efficiency = act[2]/cost
										if efficiency < 2 then result = result - 1
										elseif efficiency >= 2 then result = result + 1 end
									elseif cost <= 0 then
										result = result + 1
									end
									
									return result
							   end}
actionValues["giveenergy"] = {function(act, cost)
									result = 0
									
									if enemy.energy <= 1 then
										result = result + 2
									elseif enemy.energy > 1 and enemy.energy <= 2 then
										result = result + 1
									elseif enemy.energy > 3 then
										result = result - 1
									end
									
									if playerCanDie() then result = result - 10 end
									
									return result
							   end}
actionValues["removeenergy"] = {function(act, cost)
									result = 0
									
									healthPercentage = enemy.hp*100/game.maxPlayerHealth
									
									if healthPercentage <= 10 then
										result = result - 2
									end
									
									healthPercentage = player.hp*100/game.maxPlayerHealth
									if healthPercentage <= 10 then
										result = result -  2
									end
									
									if player.energy <= 0 then result = result - 10 end
									
									if player.energy >= enemy.energy then
										result = result - 1
									else
										result = result + 1
									end
									
									if player.energy - act[2] <= 0 then
										result = result + 1
									end
									
									if enemy.energy >= game.maxPlayerEnergy then
										result = result + 1
									else
										result = result - 1
									end
									
									if player.energy >= enemy.energy then result = result - 2 end
									
									if playerCanDie() then result = result - 10 end
									
									if cost > 0 then
										efficiency = act[2]/cost
										if efficiency < 2 then result = result - 1
										elseif efficiency >= 2 then result = result + 1 end
									elseif cost <= 0 then
										result = result + 1
									end
									
									return result
							   end}
actionValues["companiontodamage"] = {function(act, cost)
										result = 0
										
										if player.companion[1] == "" then
											result = result - 10
										else
											companionDamage = companions[ player.companion[1] ].damage
											
											if companionDamage <= 0 then
												result = result - 3
											elseif companionDamage <= 1 and companionDamage > 0 then
												result = result - 2
											elseif companionDamage >= 2 and companionDamage < 3 then
												result = result + 1
											elseif companionDamage >= 3 then
												result = result + companionDamage
											end
										end
										
										if cost > 0 then
											efficiency = act[2]/cost
											if efficiency < 60 then result = result - 1
											elseif efficiency >= 60 then result = result + 1 end
										elseif cost <= 0 then
											result = result + 1
										end
										
										return result
									end}
actionValues["healboth"] = {function(act, cost)
								result = 0
								
								if enemy.companion[1] ~= "" then
									companionMaxHealth = companions[ enemy.companion[1] ].health
									companionHealth = enemy.companion[2]
									
									if enemy.hp + act[2] <= game.maxPlayerHealth and
										companionHealth + act[2] <= companionMaxHealth then
											result = result + 3
									elseif enemy.hp + act[2] <= game.maxPlayerHealth and
										companionHealth + act[2] > companionMaxHealth then
											result = result + 2
									elseif enemy.hp + act[2] <= game.maxPlayerHealth and
										companionHealth + act[2] > companionMaxHealth then
											result = result + 1
									end
									
									if companionHealth >= companionMaxHealth then result = result - 1 end
									if enemy.hp >= game.maxPlayerHealth then result = result - 1 end
								else
									if enemy.hp + act[2] <= game.maxPlayerHealth then
										result = result - 2
									else
										result = result - 3
									end
								end
								
								if playerCanDie() then result = result - 10 end
								
								if cost > 0 then
									efficiency = act[2]/cost
									if efficiency < 2 then result = result - 1
									elseif efficiency >= 2 then result = result + 1 end
								elseif cost <= 0 then
									result = result + 1
								end
								
								return result
							end}
actionValues["magicschool"] = {function(act, cost)
								result = 0
								
								result = result + act[3]
								
								cardsThisSchool = 0
								
								for i = 1, 5 do
									thisCard = cards[ enemySlots[i] ]
									
									if thisCard.action[1] ~= "magicschool" 
										and thisCard.action[1] ~= "companion"
										and thisCard.action[1] ~= "banish"
										and thisCard.action[1] ~= "uncurseall"
										and thisCard.action[1] ~= "dispelenemy"
										and thisCard.action[1] ~= "dispelself" then
											if thisCard.school == act[2] then
												cardsThisSchool = cardsThisSchool + 1
											end
									end
								end
								
								result = result + cardsThisSchool
								
								if playerCanDie() then result = result - 10 end
								
								if cost > 0 then
									efficiency = act[3]/cost
									if efficiency < 1 then result = result - 1
									elseif efficiency >= 1 then result = result + 1 end
								elseif cost <= 0 then
									result = result + 1
								end
								
								return result
							end}
function playerCanDie()
	canDie = false
	
	for i = 1, 5 do
		if cards[ enemySlots[i] ].action[1] == "damage" or
			cards[ enemySlots[i] ].action[1] == "damagedot" then
				if cards[ enemySlots[i] ].action[2] - player.defense >= player.hp and
					(enemy.energy >= cards[ enemySlots[i] ].energy 
					 or enemy.energy + game.energyPerTurn >= cards[ enemySlots[i] ].energy) then
						
						canDie = true
				end
		elseif cards[ enemySlots[i] ].action[1] == "udamage" and
				(enemy.energy >= cards[ enemySlots[i] ].energy 
				 or enemy.energy + game.energyPerTurn >= cards[ enemySlots[i] ].energy) then
				
					canDie = true
		end
	end
	
	return canDie
end

function mustSaveEnergy(cardEnergy)
	savingValue = 0
	pleaseSaveEnergy = false
	
	nextTurnEnergy = enemy.energy - cardEnergy + game.energyPerTurn
	
	for i = 1, 5 do
		energyCost = cards[ enemySlots[i] ].energy
		cardValue = cards[ enemySlots[i] ].value
		cardSchool = cards[ enemySlots[i] ].school
		
		if energyCost >= 4 and cardValue >= 4 and nextTurnEnergy < 4 then
			savingValue = savingValue + 1
		end
		
		if cardSchool == "elemental" and enemy.elemental >= 1 then savingValue = savingValue + 1 end
		if cardSchool == "nature" and enemy.nature >= 1 then savingValue = savingValue + 1 end
		if cardSchool == "mystic" and enemy.mystic >= 1 then savingValue = savingValue + 1 end
		if cardSchool == "dark" and enemy.dark >= 1 then savingValue = savingValue + 1 end
		if cardSchool == "void" and enemy.void >= 1 then savingValue = savingValue + 1 end
	end
	
	if savingValue >= 1 then
		pleaseSaveEnergy = true
	end
	
	return pleaseSaveEnergy
end
