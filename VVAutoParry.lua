-- VV Ultimatum Auto Parry - Versão Foco em Funcionar (Melhorada)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local parryRemote = nil

local DISTANCE = 40
local enabled = true
local lastParry = 0
local PARRY_COOLDOWN = 0.13

-- ==================== GUI Simples ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 100)
Frame.Position = UDim2.new(0.5, -120, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.Text = "VV Auto Parry - Melhorado"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0.4, 0)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(0, 255, 100)
Status.Font = Enum.Font.Gotham
Status.TextSize = 16
Status.Text = "Status: Ativado"
Status.Parent = Frame

-- ==================== Encontrar Remote (Método Forte) ====================
local function findRemote()
    -- Método 1: Busca por nome
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local name = v.Name:lower()
            if name:find("parry") or name:find("block") or name:find("counter") or name:find("defend") or name:find("dodge") then
                parryRemote = v
                print("✅ Remote encontrado por nome:", v.Name)
                return
            end
        end
    end
    
    -- Método 2: Último recurso
    if not parryRemote then
        parryRemote = ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent", true)
        print("⚠️ Usando Remote genérico")
    end
end

findRemote()

-- ==================== RootPart ====================
local rootPart = nil
local function updateCharacter(char)
    rootPart = char:WaitForChild("HumanoidRootPart", 5)
end
if player.Character then updateCharacter(player.Character) end
player.CharacterAdded:Connect(updateCharacter)

-- ==================== Detecção Melhorada ====================
local function isAttacking(character)
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    -- Detecção por animação
    local animator = humanoid:FindFirstChild("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track.IsPlaying and track.Speed and track.Speed > 0.75 then
                return true
            end
        end
    end
    
    -- Detecção alternativa (movimento agressivo)
    if humanoid.WalkSpeed > 16 or humanoid:GetState() == Enum.HumanoidStateType.Jumping then
        return true
    end
    
    return false
end

-- ==================== LOOP PRINCIPAL ====================
RunService.Heartbeat:Connect(function()
    if not enabled or not rootPart or not parryRemote then return end
    if tick() - lastParry < PARRY_COOLDOWN then return end

    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player and other.Character then
            local char = other.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            
            if root then
                local distance = (rootPart.Position - root.Position).Magnitude
                
                if distance <= DISTANCE and isAttacking(char) then
                    
                    -- Randomização natural
                    local delay = math.random(22, 78) / 1000
                    task.wait(delay)
                    
                    parryRemote:FireServer()
                    lastParry = tick()
                    
                    print(string.format("[Parry] → %s | Dist: %.1f | Delay: %dms", other.Name, distance, math.floor(delay*1000)))
                    break
                end
            end
        end
    end
end)

print("✅ VV Auto Parry carregado com melhorias (Distância: " .. DISTANCE .. ")")
