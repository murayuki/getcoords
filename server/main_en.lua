
RegisterServerEvent('GetGoords:CheckDisplayPermission')
AddEventHandler('GetGoords:CheckDisplayPermission', function ()
	if IsPlayerAceAllowed(source, "getcoords.command") then
		TriggerClientEvent('GetGoords:Display', source)
	else
		TriggerClientEvent('GetGoords:Notification', source, "error", "You have insufficient permissions")
	end
end)

RegisterServerEvent('GetGoords:ControlSwitch')
AddEventHandler('GetGoords:ControlSwitch', function ()
	if IsPlayerAceAllowed(source, "getcoords.command") then
		TriggerClientEvent('GetGoords:ControlSwitch', source)
	else
		TriggerClientEvent('GetGoords:Notification', source, "error", "You have insufficient permissions")
	end
end)