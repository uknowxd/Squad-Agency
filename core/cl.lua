ESX = exports["es_extended"]:getSharedObject()

local Active = false
local firstSpawn = false
local isDead = false
local PlayerData = {}
local Squad_Blips = {}

RegisterNetEvent(Config["Base_Events"]["playerLoaded"])
AddEventHandler(Config["Base_Events"]["playerLoaded"], function()
	Citizen.SetTimeout(1500, function() 
		PlayerData = ESX.GetPlayerData()
		if not firstSpawn then
			TriggerServerEvent('Qwerty_Hub:Squad:Check')
			firstSpawn = true
		end
	end)
end)

AddEventHandler(Config["Base_Events"]["playerSpawned"], function(data)
	if isDead then
		for k,v in pairs(Config['Squad']) do
			if PlayerData.job.name == k and not v.PlayerDeathShow then
				TriggerServerEvent('Qwerty_Hub:Squad:Check')
				isDead = false
			end
		end
	end
end)

AddEventHandler(Config["Base_Events"]["onPlayerDeath"], function(spawn)
	if not isDead then
		for k,v in pairs(Config['Squad']) do
			if PlayerData.job.name == k and not v.PlayerDeathShow then
				TriggerServerEvent('Qwerty_Hub:Squad:Die')
				RemoveAnyExistingSquadBlips()
				isDead = true
			end
		end
	end
end)

RegisterNetEvent("Qwerty_Hub:Squad:Toggle")
AddEventHandler("Qwerty_Hub:Squad:Toggle", function(data)
	Active = data
	PlayerData = ESX.GetPlayerData()
	if not Active then
		RemoveAnyExistingSquadBlips()
	end
end)

RegisterNetEvent("Qwerty_Hub:Squad:CL-Update")
AddEventHandler("Qwerty_Hub:Squad:CL-Update", function(_data)
	if Active then
		RemoveAnyExistingSquadBlips()
		RefreshBlips(_data)
	end
end)


Citizen.CreateThread(function()
	local previousCoords = GetEntityCoords(PlayerPedId())
	while true do
		Citizen.Wait(Config['ClientDelay'])
		if Active then
			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = #(playerCoords - previousCoords)
			if distance > Config['ClientDistance'] then
				TriggerServerEvent('Qwerty_Hub:Squad:SV-Update')
				previousCoords = playerCoords
			end
		end
		if not Active then
			Citizen.Wait(5000)
		end
	end
end)

function RemoveAnyExistingSquadBlips()
	for i = #Squad_Blips, 1, -1 do
		local b = Squad_Blips[i]
		if b ~= 0 then
			RemoveBlip(b)
			table.remove(Squad_Blips, i)
		end
	end
end

function RefreshBlips(_data)
	local myServerId = GetPlayerServerId(PlayerId())
	for src, info in pairs(_data) do
		for _, data in pairs(Config['Squad']) do
			if PlayerData.job ~= nil and PlayerData.job.name == info.job and _ == PlayerData.job.name then
				if src ~= myServerId then
					if info and info.coords then
						local blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
						SetBlipSprite(blip, data.BlipSprite)
						SetBlipColour(blip, data.BlipColour)
						SetBlipScale(blip, data.BlipScale)
						SetBlipAsShortRange(blip, true)
						SetBlipDisplay(blip, 4)
						SetBlipShowCone(blip, true)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString('['.. data.Label ..']'..info.name)
						EndTextCommandSetBlipName(blip)
						table.insert(Squad_Blips, blip)
					end
				end
			end
		end
	end
end