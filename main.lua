local localPlayer = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local aim = false
_G.AimbotEnabled = false
_G.AimbotPart = "Head"  -- Default aimbot part

local function findNearestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild(_G.AimbotPart) then
            local character = player.Character
            local targetPart = character[_G.AimbotPart]

            -- Calculate the screen position of the target part
            local targetScreenPos, onScreen = camera:WorldToScreenPoint(targetPart.Position)

            if onScreen then
                -- Calculate the distance from the mouse position to the target part
                local mousePos = UIS:GetMouseLocation()
                local distance = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(targetScreenPos.X, targetScreenPos.Y)).Magnitude

                -- Update the closest player if this player is closer
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

game:GetService("RunService").RenderStepped:Connect(function()
    if aim then
        local targetPlayer = findNearestPlayer()

        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(_G.AimbotPart) then
         if _G.AimbotEnabled == true then
            local targetPart = targetPlayer.Character[_G.AimbotPart]
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
                end
        end
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E and not processed then
        aim = true
    end
end)

UIS.InputEnded:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E and not processed then
        aim = false
    end
end)
-- i swear ive reverted more times then i can count 
