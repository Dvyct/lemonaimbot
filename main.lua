local localPlayer = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local aim = false
_G.AimbotEnabled = false
_G.AimbotSensitivity = 0.1
local function findNearestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local character = player.Character
            local head = character.Head

            -- Calculate the screen position of the player's head
            local headScreenPos, onScreen = camera:WorldToScreenPoint(head.Position)

            if onScreen then
                -- Calculate the distance from the mouse position to the player's head
                local mousePos = UIS:GetMouseLocation()
                local distance = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(headScreenPos.X, headScreenPos.Y)).Magnitude

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

        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local targetHead = targetPlayer.Character.Head
            local targetCFrame = CFrame.new(camera.CFrame.Position, targetHead.Position)

            -- Tween camera to targetCFrame with quad easing and 1 second duration
            local tweenInfo = TweenInfo.new(_G.AimbotSensitivity, Enum.EasingStyle.Quad)  -- Duration: 1 second, EasingStyle: Quad
            TweenService:Create(camera, tweenInfo, { CFrame = targetCFrame }):Play()
        end
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E and not processed then
        if _G.AimbotEnabled == true then
            aim = true
        end
    end
end)

UIS.InputEnded:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E and not processed then
        if _G.AimbotEnabled == true then
            aim = false
        end
    end
end)
