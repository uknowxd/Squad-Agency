ESX = exports["es_extended"]:getSharedObject()

local Squad_State = {}

AddEventHandler(Config["Base_Events"]["setJob"], function(source, job, lastJob)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for k,v in pairs(Config['Squad']) do
		if k == job then
			_data = {
				src = playerId,
				name = xPlayer.name,
				job = xPlayer.job.name
			}
			Squad_State[playerId] = _data
			TriggerClientEvent("Qwerty_Xenon:Squad:Toggle", playerId, true)
		end
	end
	Squad_State[source] = nil
	TriggerClientEvent("Qwerty_Xenon:Squad:Toggle", _source, false)
end)

RegisterServerEvent("Qwerty_Xenon:Squad:Check")
AddEventHandler("Qwerty_Xenon:Squad:Check", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for k,v in pairs(Config['Squad']) do
		if k == xPlayer.job.name then
			if v.Enable then
				_data = {
					src = _source,
					name = xPlayer.name,
					job = xPlayer.job.name
				}
				Squad_State[_source] = _data
				print(ESX.DumpTable(Squad_State))
				TriggerClientEvent("Qwerty_Xenon:Squad:Toggle", _source, true)
			end
		end
	end
end)

RegisterServerEvent("Qwerty_Xenon:Squad:Die")
AddEventHandler("Qwerty_Xenon:Squad:Die", function()
	local _source = source
	Squad_State[_source] = nil
	TriggerClientEvent("Qwerty_Xenon:Toggle", _source, false)
end)

RegisterServerEvent("Qwerty_Xenon:Squad:SV-Update")
AddEventHandler("Qwerty_Xenon:Squad:SV-Update", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for id, info in pairs(Squad_State) do
		if info.job == xPlayer.job.name then
			Squad_State[id].coords = GetEntityCoords(GetPlayerPed(id))
			TriggerClientEvent("Qwerty_Xenon:Squad:CL-Update", id, Squad_State)
		end
	end
end)

Citizen.CreateThread(function()
	local lastUpdateTime = os.time()
	while true do
		if os.difftime(os.time(), lastUpdateTime) >= 1 then
			for id, info in pairs(Squad_State) do
				for k,v in pairs(Config['Squad']) do
					if k == info.job then
						Squad_State[id].coords = GetEntityCoords(GetPlayerPed(id))
						TriggerClientEvent("Qwerty_Xenon:Squad:CL-Update", id, Squad_State)
					end
				end
			end
			lastUpdateTime = os.time()
		end
		Wait(Config['ServerDelay'])
	end
end)

AddEventHandler(Config["Base_Events"]["playerDropped"], function()
	if Squad_State[source] then
		Squad_State[source] = nil
	end
end)