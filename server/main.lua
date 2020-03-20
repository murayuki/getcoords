
RegisterServerEvent('GetGoords:CheckDisplayPermission')
AddEventHandler('GetGoords:CheckDisplayPermission', function ()
	if IsPlayerAceAllowed(source, "getcoords.command") then
		TriggerClientEvent('GetGoords:Display', source)
	else
		TriggerClientEvent('GetGoords:Notification', source, "error", "你的權限不足無法執行")
	end
end)

RegisterServerEvent('GetGoords:ControlSwitch')
AddEventHandler('GetGoords:ControlSwitch', function ()
	if IsPlayerAceAllowed(source, "getcoords.command") then
		TriggerClientEvent('GetGoords:ControlSwitch', source)
	else
		TriggerClientEvent('GetGoords:Notification', source, "error", "你的權限不足無法執行")
	end
end)