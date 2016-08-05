local function healthPercentage(p)
	return p.hp / game.maxPlayerHealth
end

local function playerCanDie()
	for i = 1, 5 do
		if cards[enemySlots[i]].action[1] == "damage" or
		cards[enemySlots[i]].action[1] == "damagedot" then
			if cards[enemySlots[i]].action[2] - player.defense >= player.hp and
				(enemy.energy >= cards[enemySlots[i]].energy
				 or enemy.energy + game.energyPerTurn >= cards[enemySlots[i]].energy) then
					return true
			end
		elseif cards[enemySlots[i]].action[1] == "udamage" and
			(enemy.energy >= cards[enemySlots[i]].energy
			 or enemy.energy + game.energyPerTurn >= cards[enemySlots[i]].energy) then
				return true
		end
	end

	return false
end

actionValues = {
	poison = {
		function(act, cost)
			local result =
				player.poisonTurns * player.poisonDamage < act[2] * act[3] / 2
				and 1 or -2

			local hpPercentage = healthPercentage(enemy)

			if hpPercentage <= 0.2 then
				result = result - 4
			end

			if playerCanDie() then
				result = result - 10
			end

			if cost > 0 then
				local efficiency = act[2] * act[3] / cost
				result = result + (efficiency <= 2 and -1 or 1)
			else
				result = result + 1
			end

			return result
		end
	},
	defense = {
		function(act, cost)
			local hpPercentage = healthPercentage(enemy)

			local result = enemy.defense >= act[2] and -10 or 0
			if enemy.defense <= 0 and hpPercentage >= 0.3 then
				result = result + 3
			end

			result = result + enemy.curse

			if playerCanDie() then
				result = result - 10
			end

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 1 and -1 or 1)
			else
				result = result + 1
			end

			return result
		end
	},
	curse = {
		function(act, cost)
			local result = player.curse >= act[2] and -10 or player.defense + act[2]

			if player.curse <= 0 then
				result = result + 2
			end

			if playerCanDie() then
				result = result - 10
			end

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 1 and -1 or 1)
			else
				result = result + 1
			end

			if enemy.companion[1] == "Kami" or player.companion[1] == "Kami" then
				result = result - 10
			end

			return result
		end
	},
	damage = {
		function(act, cost)
			local result = player.curse <= 0 and -1 or 0

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency <= 2 and -1 or act[2] / 2 + efficiency)
			else
				result = result + act[2] / 2 + 4
			end

			if act[2] + player.curse <= player.defense then
				result = result - 4
			end

			local playerHealthPercentage = healthPercentage(player)
			local enemyHealthPercentage = healthPercentage(enemy)

			result = result +
				(enemyHealthPercentage >= playerHealthPercentage and
					 (playerHealthPercentage > 0.5 and 1 or
							playerHealthPercentage > 0.25 and 2 or 3) or
					 (playerCanDie() and 2 or 1))

			result = result + player.curse

			return result
		end
	},
	dispelEnemy = {
		function(act, cost)
			local result =
				player.defense <= 0 and -10 or player.defense - player.curse

			if playerCanDie() then
				result = result - 10
			end

			return result
		end
	},
	dispelSelf = {
		function(act, cost)
			local result = enemy.curse <= 0 and enemy.defense > 0 and -10 or 0
			if enemy.curse >= player.curse + 1 and enemy.defense + 1 <= player.defense then
				result = result + 1
			end
			if enemy.defense <= 0 and enemy.curse >= 0 and player.defense >= 0 and player.curse >= 0 then
				result = result + 2
			end
			if player.defense <= 0 then
				result = result - 10
			end

			if playerCanDie() then
				result = result - 10
			end

			return result
		end
	},
	heal = {
		function(act, cost)
			local halfHealPower = math.floor(act[2] / 2)
			local lostHealth = game.maxPlayerHealth - enemy.hp
			local damageSpell = 0

			local result = halfHealPower > lostHealth and -10 or 0

			if lostHealth >= game.maxPlayerHealth / 2 then
				result = result + 2
			end
			if lostHealth >= game.maxPlayerHealth / 3 then
				result = result + 3
			end
			if enemy.hp * 2 <= player.hp then
				result = result + 2
			end
			if enemy.companion[1] ~= "" and player.companion[1] ~= "" then
				result = result + (enemy.companion[2] >= 5 and -1 or 1)
			end
			if enemy.defense >= 2 then
				result = result - 1
			end
			if enemy.hp <= 10 then
				result = result + act[2]
			end
			if enemy.poisonDamage >= enemy.hp then
				result = result + 3
			end

			if player.poisonDamage >= player.hp then
				result = result - 3
			end
			if player.hp * 2 <= enemy.hp then
				result = result - 2
			end
			if healthPercentage(player) <= 0.15 then
				result = result - 1
			end

			if playerCanDie() then
				result = result - 10
			end

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 5 and -1 or 1)
			else
				result = result + 1
			end

			return result
		end
	},
	damageall = {
		function(act, cost)
			local result = player.companion[1] ~= "" and
				(player.companion[2] <= act[2] and 1 or -2) or -3

			result = result + (player.hp < enemy.hp and 1 or -2)

			local hasHeal
			for i = 1, 5 do
				local thisCard = cards[enemySlots[i]]

				if thisCard.action[1] == "heal" then
					hasHeal = true
				end
			end

			result = result + (hasHeal and 1 or -2)

			if enemy.hp <= act[2] then
				result = result - 10
			end
			if player.hp + player.defense <= act[2] then
				result = result + 2
			end

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 5 and -1 or 1)
			else
				result = result + 1
			end

			return result
		end
	},
	udamage = {
		function(act, cost)
			local result = player.curse <= 0 and -1 or 0

			local playerHealthPercentage = healthPercentage(player)
			local enemyHealthPercentage = healthPercentage(enemy)

			result = result +
				(enemyHealthPercentage >= playerHealthPercentage and
					 (playerHealthPercentage > 0.5 and 1 or
							playerHealthPercentage > 0.25 and 2 or 3) or
					 (playerCanDie() and 2 or 1))

			result = result + player.curse

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 1.5 and -1 or 1)
			else
				result = result + 2
			end

			return result
		end
	},
	damagedot = {
		function(act, cost)
			local result = player.curse

			local totalDamage = act[2] + act[3] * act[4]

			local playerRemainingDamage = player.poisonTurns * player.poisonDamage

			result = result + (playerRemainingDamage >= totalDamage and -3 or 2)

			if player.poisonTurns > 1 then
				result = result - 1
			end

			if cost > 0 then
				efficiency = (act[2] + act[3] * act[4]) / cost
				result = result + (efficiency < 3 and -1 or 1)
			else
				result = result + 1
			end

			return result
		end
	},
	damagecurse = {
		function(act, cost)
			local result = act[2]

			if player.curse <= 0 then
				result = result + 1
			end
			result = result + (player.defense >= act[2] and -1 or 1)

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 1 and -1 or 1)
				efficiency = act[3] / cost
				result = result + (efficiency < 0.3 and -1 or 1)
			else
				result = result + 2
			end

			return result
		end
	},
	uncurseall = {
		function(act, cost)
			local result =  enemy.curse - player.curse

			if playerCanDie() then
				result = result - 10
			end

			return result
		end
	},
	discard = {
		function(act, cost)
			local result = playerCanDie() and -10 or 0

			result = result + deck.maxCards / #playerDeck -
				game.maxPlayerHealth / player.hp - game.maxPlayerHealth / enemy.hp

			if cost > 0 then
				efficiency = act[2] / cost
				result = result + efficiency < 1 and -1 or 1
			else
				result = result + 1
			end

			return result
		end
	},
	curePoison = {
		function(act, cost)
			local result = 0

			if enemy.poisonTurns >= 1 then
				result = result +
					(enemy.poisonDamage * enemy.poisonTurns > 4 and
						 enemy.poisonDamage * enemy.poisonTurns or -1)
				if enemy.poisonDamage >= enemy.hp then
					result = result + 3
				end
			end

			if enemy.poisonTurns <= 1 and enemy.poisonTurns > 0 then
				result = result - 1
			end
			if enemy.poisonTurns <= 0 then
				result = result - 10
			end

			if playerCanDie() then
				result = result - 10
			end

			return result
		end
	},
	companion = {
		function(act, cost)
			local newCompanionDamage = companions[act[2]].damage
			local newCompanionHealth = companions[act[2]].health

			local result = newCompanionDamage / cost

			if newCompanionDamage <= 0 then
				result = result - 1
			end

			if enemy.companion[1] ~= "" then
				local companionDamage = companions[enemy.companion[1]].damage
				local companionMaxHealth = companions[enemy.companion[1]].health
				local companionHealth = enemy.companion[2]
				if companionDamage < newCompanionDamage then
					local diff = newCompanionDamage - companionDamage
					result = result - (diff >= 3 and 3 or diff >= 2 and 2 or 1)
				end

				if newCompanionDamage <= player.defense then
					result = result - 1
				end

				if companionHealth < companionMaxHealth then
					if companionMaxHealth - companionHealth >= 7 then
						result = result + 3
					elseif companionMaxHealth - companionHealth >= 4 then
						result = result + 2
					elseif companionMaxHealth - companionHealth >= 2 then
						result = result + 1
					end
				else
					local diff = newCompanionHealth - companionHealth
					result = result -
						(diff > 0 and (diff >= 3 and 3 or diff >= 2 and 2 or 1) or
							 diff <= -3 and 3 or diff <= -2 and 2 or 1)
				end

				if player.companion[1] ~= "" then
					result = result + (newCompanionDamage > companionDamage and 3 or -3)

					if companions[enemy.companion[1]].damage > 0 then
						result = result - 3
					end
				end
			else
				result = result + 2
			end

			if player.companion[1] ~= "" and enemy.companion[1] == "" then
				result = result + 1
				result = result +
					(enemy.defense < companions[player.companion[1]].damage and
						 companions[player.companion[1]].damage - enemy.defense or -1)
			end

			if playerCanDie() then
				result = result - 10
			end

			return result
		end
	},
	banish = {
		function(act, cost)
			local result = player.companion[1] ~= "" and
				companions[player.companion[1]].damage - 1 or -10

			if playerCanDie() then
				result = result - 10
			end

			return  result
		end
	},
	destroy = {
		function(act, cost)
			local result = player.companion[1] ~= "" and
				player.companion[2] <= act[2] and
				companions[player.companion[1]].damage - player.companion[2] +
				companions[player.companion[1]].health or
				-10
			if enemy.companion[1] == "" then
				result = result - enemy.defense
			end

			if playerCanDie() then
				result = result - 10
			end

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 4 and -1 or 1)
			else
				result = result + 1
			end

			return result
		end
	},
	energytodamage = {
		function(act, cost)
			local result = enemy.energy

			result = result +
				(act[2] + act[3] * enemy.energy <= player.defense and -10 or
					 game.maxPlayerHealth / player.hp - player.curse - player.defense)

			if enemy.energy <= 2 then
				result = result - enemy.energy
			end

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 2 and -1 or 1)
			else
				result = result + 1
			end

			return result
		end
	},
	giveenergy = {
		function(act, cost)
			local result = 0

			if enemy.energy <= 1 then
				result = result + 2
			elseif enemy.energy <= 2 then
				result = result + 1
			elseif enemy.energy > 3 then
				result = result - 1
			end

			if playerCanDie() then
				result = result - 10
			end

			return result
		end
	},
	removeenergy = {
		function(act, cost)
			local result = 0

			local hp = healthPercentage(enemy)

			if hp <= 0.1 then
				result = result - 2
			end

			hp = healthPercentage(player)
			if hp <= 10 then
				result = result -  2
			end

			if player.energy <= 0 then
				result = result - 10
			end

			result = result + (player.energy >= enemy.energy and -1 or 1)

			if player.energy - act[2] <= 0 then
				result = result + 1
			end

			result = result + (enemy.energy >= game.maxPlayerEnergy and 1 or -1)

			if player.energy >= enemy.energy then
				result = result - 2
			end

			if playerCanDie() then
				result = result - 10
			end

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 2 and -1 or 1)
			else
				result = result + 1
			end

			return result
		end
	},
	companiontodamage = {
		function(act, cost)
			local result = 0

			if player.companion[1] == "" then
				result = -10
			else
				local companionDamage = companions[player.companion[1]].damage

				if companionDamage <= 0 then
					result = -3
				elseif companionDamage <= 1 then
					result = -2
				elseif companionDamage >= 2 and companionDamage < 3 then
					result = 1
				elseif companionDamage >= 3 then
					result = companionDamage
				end
			end

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 60 and -1 or 1)
			else
				result = result + 1
			end

			return result
		end
	},
	healboth = {
		function(act, cost)
			local result = 0

			if enemy.companion[1] ~= "" then
				local companionMaxHealth = companions[enemy.companion[1]].health
				local companionHealth = enemy.companion[2]

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

				if companionHealth >= companionMaxHealth then
					result = result - 1
				end
				if enemy.hp >= game.maxPlayerHealth then
					result = result - 1
				end
			else
				result = result - (enemy.hp + act[2] <= game.maxPlayerHealth and 2 or 3)
			end

			if playerCanDie() then
				result = result - 10
			end

			if cost > 0 then
				local efficiency = act[2] / cost
				result = result + (efficiency < 2 and -1 or 1)
			elseif cost <= 0 then
				result = result + 1
			end

			return result
		end
	},
	magicschool = {
		function(act, cost)
			local result = act[3]

			for i = 1, 5 do
				local thisCard = cards[enemySlots[i]]

				if thisCard.action[1] ~= "magicschool"
					and thisCard.action[1] ~= "companion"
					and thisCard.action[1] ~= "banish"
					and thisCard.action[1] ~= "uncurseall"
					and thisCard.action[1] ~= "dispelenemy"
					and thisCard.action[1] ~= "dispelself"
				and thisCard.school == act[2] then
					result = result + 1
				end
			end

			if playerCanDie() then
				result = result - 10
			end

			if cost > 0 then
				local efficiency = act[3] / cost
				result = result + (efficiency < 1 and -1 or 1)
			else
				result = result + 1
			end

			return result
		end
	}
}

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
