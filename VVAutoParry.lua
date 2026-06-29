-- VV Ultimatum Auto Parry - Versão Melhorada

print("[VV] Iniciando Auto Parry...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local parryRemote = nil

-- Tentando encontrar o Remote de Parry
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
    if (v.Name:find("Parry") or v.Name:find("parry")) and v:IsA("RemoteEvent") then
        parryRemote = v
        print("[VV] ✅ Remote Parry encontrado: " .. v.Name)
        break
    end
end

if not parryRemote then
    warn("[VV] ❌ Remote Parry não encontrado!")
    -- Tenta método alternativo
    parryRemote = ReplicatedStorage:FindFirstChild("Parry", true) or ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent")
end

local DISTANCE = 35

local rootPart = nil
local function updateCharacter(char)
    rootPart = char:WaitForChild("HumanoidRootPart", 5)
    print("[VV] Personagem carregado")
end

if player.Character then updateCharacter(player.Character) end
player.CharacterAdded:Connect(updateCharacter)

RunService.Heartbeat:Connect(function()
    if not rootPart or not parryRemote then return end

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local distance = (rootPart.Position - otherRoot.Position).Magnitude
                if distance <= DISTANCE then
                    parryRemote:FireServer()
                    break
                end
            end
        end
    end
end)

print("[VV] Auto Parry ATIVADO - Distância: " .. DISTANCE)
