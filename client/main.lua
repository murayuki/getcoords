local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local display = false
local ControlSwitch = false
local ControlSwitchTime = true
local TypeCoords = 1
local Nbr = 0

RegisterCommand("showcoords", function(source)
    TriggerServerEvent('GetGoords:CheckDisplayPermission')
end)


RegisterCommand("swcoords", function(source)
    TriggerServerEvent('GetGoords:ControlSwitch')
end)

RegisterNetEvent("GetGoords:ControlSwitch")
AddEventHandler("GetGoords:ControlSwitch", function()
	if ControlSwitch then
		ControlSwitch = false
		Notification('error', '關閉 [~]按鍵 開關座標視窗')
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	else
		ControlSwitch = true
		Notification('success', '開啟 [~]按鍵 開關座標視窗')
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end

	Citizen.CreateThread(function()
		while ControlSwitch do
			Citizen.Wait(0)
			if IsControlJustPressed(0, Keys["~"]) and ControlSwitchTime and ControlSwitch then -- "~"
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				TriggerServerEvent('GetGoords:CheckDisplayPermission')
				Notification('success', '開啟 座標視窗')
				
				--- Control Timer
				ControlSwitchTime = false
				Citizen.Wait(5000)
				ControlSwitchTime = true
			end
		end
	end)
end)

RegisterNetEvent("GetGoords:Display")
AddEventHandler("GetGoords:Display", function()
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    SetDisplay(not display)
end)

function SetDisplay(bool, TypeCoords)
	local Ped = GetPlayerPed(-1)
	local PedCoods = GetEntityCoords(Ped, true)
    local Heading = GetEntityHeading(Ped)
	local x, y, z = table.unpack(PedCoods)
	
    local PedCoordsA = "{x = "..round(x,2)..", y = "..round(y,2)..", z = "..round(z,2).."}"
	local PedCoordsB = round(x,2)..", "..round(y,2)..", "..round(z,2)
	local PedCoordsC = "vector3(".. round(x,2)..", "..round(y,2)..", "..round(z,2)..")"
    local PedCoordsHeading = round(Heading, 2)
	
    display = bool
    SetNuiFocus(bool, bool)

	if TypeCoords ~= nil then
		Coods = TypeCoords
	else
		Coods = 0
	end
	
	SendNUIMessage ({
        type = "Hud",
        display = bool,
		TypeCoords = Coods,
		PedA = PedCoordsA,
		PedB = PedCoordsB,
		PedC = PedCoordsC,
		PedHeading = PedCoordsHeading,
    })
end

RegisterNetEvent("GetGoords:Notification")
AddEventHandler("GetGoords:Notification", function(type, msg)
    Notification(type, msg)
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
	
	Citizen.Wait(100)
	
	Notification("exit", data.exitmsg)
	
	Nbr = 0
end)

RegisterNUICallback("switch", function(data)
	SetDisplay(false)
	Citizen.Wait(250)
	SetDisplay(not display, TypeCoords)

	if Nbr >= 3 then
		Nbr = 1
	elseif Nbr == 0 then
		Nbr = 2
	else
		Nbr = Nbr + 1
	end
	
	if TypeCoords == 0 then
		TypeCoords = 1
	elseif TypeCoords == 1 then
		TypeCoords = 2
	elseif TypeCoords == 2 then
		TypeCoords = 0
	end
	Notification("success", data.msg .. " | 格式: " .. Nbr .. " |")
end)

function Notification(type, msg)
	SendNUIMessage ({
		type = 'Notice', 
		NoticeMsg = msg, 
		NoticeType = type
	})
end
	
Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

function round(num, numDecimalPlaces)
	local mult = 5^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end
