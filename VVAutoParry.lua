-- VV Ultimatum Auto Parry - Versão Corrigida e Melhorada

print("[VV] Iniciando Auto Parry...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local parryRemote = nil
local DISTANCE = 35

-- ==================== Encontrar Remote ====================
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and (v.Name:find("Parry") or v.Name:find("parry") or v.Name:lower():find("block")) then
        parryRemote = v
        print("[VV] ✅ Remote Parry encontrado: " .. v.Name)
        break
    end
end

if not parryRemote then
    warn("[VV] ❌ Remote Parry não encontrado! Tentando método alternativo...")
    parryRemote = ReplicatedStorage:FindFirstChild("Parry", true) or 
                  ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent")
end

if not parryRemote then
    warn("[VV] ❌ Não foi possível encontrar o Remote de Parry!")
end

-- ==================== RootPart ====================
local rootPart = nil

local function updateCharacter(char)
    rootPart = char:WaitForChild("HumanoidRootPart", 5)
    print("[VV] Personagem carregado")
end

if player.Character then
    updateCharacter(player.Character)
end
player.CharacterAdded:Connect(updateCharacter)

-- ==================== Loop Principal ====================
RunService.Heartbeat:Connect(function()
    if not rootPart or not parryRemote then return end

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local distance = (rootPart.Position - otherRoot.Position).Magnitude
                
                if distance <= DISTANCE then
                    parryRemote:FireServer()
                    break  -- Para após parryar uma pessoa por frame
                end
            end
        end
    end
end)

print("[VV] Auto Parry ATIVADO - Distância: " .. DISTANCE .. " studs")
