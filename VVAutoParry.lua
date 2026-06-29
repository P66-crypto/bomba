-- VV Ultimatum Auto Parry (Distância 40 - Sem Menu)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local parryRemote = nil

-- Encontra o Remote de Parry
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
    if v.Name == "Parry" and v:IsA("RemoteEvent") then
        parryRemote = v
        break
    end
end

if not parryRemote then
    warn("[VV] Remote Parry não encontrado!")
    return
end

local DISTANCE = 40
local rootPart = nil

local function updateCharacter(char)
    rootPart = char:WaitForChild("HumanoidRootPart", 5)
end

if player.Character then
    updateCharacter(player.Character)
end
player.CharacterAdded:Connect(updateCharacter)

RunService.Heartbeat:Connect(function()
    if not rootPart then return end

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot and (rootPart.Position - otherRoot.Position).Magnitude <= DISTANCE then
                parryRemote:FireServer()
                break
            end
        end
    end
end)

print("[VV Auto Parry] Ativado - Distância: 40 studs")
