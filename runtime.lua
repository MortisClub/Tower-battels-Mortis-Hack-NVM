-- Mortis NVM HACK v3.3 - Runtime
-- Rayfield GUI + Fine Tuning for Tower Battles

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if LocalPlayer.PlayerGui:FindFirstChild("NVM MENU") then
    return
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Mortis NVM HACK v3.3",
    LoadingTitle = "Mortis NVM HACK v3.3",
    LoadingSubtitle = "Rayfield GUI + Fine Tuning",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MortisNVMHack",
        FileName = "v3_3_Config"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false
})

local Settings = {
    AutoUpgrade = { Enabled = false, Delay = 0.12 },
    FreeUpgrades = false,
    MaxRange = { Enabled = false, Value = 3500 },
    SuperFire = { Enabled = false, Bullets = 99999, Cooldown = 0.0001 },
    DJBuff = { Enabled = false, Multi = 99999 },
    CashKill = { Enabled = false, Amount = 9999999, Delay = 0.35 },
    VisualBoost = { Enabled = true }
}

local Connections = {}
local FreeHook = false

-- F1 Toggle (Custom for Rayfield)
local IsVisible = true
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        IsVisible = not IsVisible
        -- Rayfield doesn't expose toggle, but this hides/shows the whole GUI
        for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui.Name == "Rayfield Interface" or gui.Name:find("Rayfield") then
                gui.Enabled = IsVisible
            end
        end
        print(IsVisible and "GUI Показан (F1)" or "GUI Скрыт (F1)")
    end
end)

local CheatsTab = Window:CreateTab("Cheats", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- Auto Upgrade
CheatsTab:CreateToggle({
    Name = "Auto Upgrade (Free)",
    CurrentValue = false,
    Callback = function(Value)
        Settings.AutoUpgrade.Enabled = Value
        if Value then
            Connections.AutoUpgrade = task.spawn(function()
                while Settings.AutoUpgrade.Enabled do
                    pcall(function()
                        for _, tower in pairs(Workspace.Towers:GetChildren()) do
                            if tower:FindFirstChild("Owner") and tower.Owner.Value == LocalPlayer then
                                Workspace.UpgradeTower:InvokeServer(tower.Name, 0)
                            end
                        end
                    end)
                    task.wait(Settings.AutoUpgrade.Delay)
                end
            end)
        else
            if Connections.AutoUpgrade then
                task.cancel(Connections.AutoUpgrade)
                Connections.AutoUpgrade = nil
            end
        end
    end,
})

CheatsTab:CreateSlider({
    Name = "Upgrade Delay",
    Range = { 0.01, 2 },
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.12,
    Callback = function(Value)
        Settings.AutoUpgrade.Delay = Value
    end,
})

-- Free Upgrades
CheatsTab:CreateToggle({
    Name = "Free Upgrades (Cost = 0)",
    CurrentValue = false,
    Callback = function(Value)
        if Value and not FreeHook then
            FreeHook = true
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = { ... }
                if method == "InvokeServer" and self.Name == "UpgradeTower" then
                    return oldNamecall(self, args[1], 0)
                end
                if (method == "InvokeServer" or method == "FireServer")
                    and (self.Name:lower():find("cost")
                        or self.Name:lower():find("spend")
                        or self.Name:lower():find("price")
                        or self.Name:lower():find("upgrade")
                        or self.Name:lower():find("enough")) then
                    return true
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
            Rayfield:Notify({
                Title = "Mortis NVM HACK",
                Content = "Free Upgrades Hooked (Permanent)",
                Duration = 3
            })
        end
    end,
})

-- Max Range
CheatsTab:CreateToggle({
    Name = "Max Range",
    CurrentValue = false,
    Callback = function(Value)
        Settings.MaxRange.Enabled = Value
        if Value then
            Connections.MaxRange = RunService.Heartbeat:Connect(function()
                pcall(function()
                    for _, tower in pairs(Workspace.Towers:GetChildren()) do
                        if tower:FindFirstChild("Owner") and tower.Owner.Value == LocalPlayer then
                            for _, v in pairs(tower:GetDescendants()) do
                                if (v:IsA("NumberValue") or v:IsA("IntValue")) and v.Name:lower():find("range") then
                                    v.Value = Settings.MaxRange.Value
                                end
                            end
                        end
                    end
                end)
            end)
        else
            if Connections.MaxRange then
                Connections.MaxRange:Disconnect()
                Connections.MaxRange = nil
            end
        end
    end,
})

CheatsTab:CreateSlider({
    Name = "Range Value",
    Range = { 100, 5000 },
    Increment = 50,
    Suffix = "",
    CurrentValue = 3500,
    Callback = function(Value)
        Settings.MaxRange.Value = Value
    end,
})

-- Super Fire
CheatsTab:CreateToggle({
    Name = "Max Fire Rate (99999 Bullets)",
    CurrentValue = false,
    Callback = function(Value)
        Settings.SuperFire.Enabled = Value
        if Value then
            Connections.SuperFire = RunService.Heartbeat:Connect(function()
                pcall(function()
                    for _, tower in pairs(Workspace.Towers:GetChildren()) do
                        if tower:FindFirstChild("Owner") and tower.Owner.Value == LocalPlayer then
                            for _, obj in pairs(tower:GetDescendants()) do
                                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                                    local nl = obj.Name:lower()
                                    if nl:find("burst")
                                        or nl:find("projectiles")
                                        or nl:find("shots")
                                        or nl:find("bullets")
                                        or nl:find("multi")
                                        or nl:find("count")
                                        or nl:find("amount")
                                        or nl:find("pellets") then
                                        obj.Value = Settings.SuperFire.Bullets
                                    end
                                    if nl:find("cooldown")
                                        or nl:find("firerate")
                                        or nl:find("rate")
                                        or nl:find("delay")
                                        or nl:find("interval")
                                        or nl:find("reload") then
                                        obj.Value = Settings.SuperFire.Cooldown
                                    end
                                end
                            end
                        end
                    end
                end)
            end)
        else
            if Connections.SuperFire then
                Connections.SuperFire:Disconnect()
                Connections.SuperFire = nil
            end
        end
    end,
})

CheatsTab:CreateSlider({
    Name = "Bullets/Projectiles",
    Range = { 1, 100000 },
    Increment = 1000,
    Suffix = "",
    CurrentValue = 99999,
    Callback = function(Value)
        Settings.SuperFire.Bullets = Value
    end,
})

CheatsTab:CreateSlider({
    Name = "Cooldown/Fire Rate",
    Range = { 0.0001, 1 },
    Increment = 0.001,
    Suffix = "s",
    CurrentValue = 0.0001,
    Callback = function(Value)
        Settings.SuperFire.Cooldown = Value
    end,
})

-- DJ/Commander Buff
CheatsTab:CreateToggle({
    Name = "DJ/Commander Buff",
    CurrentValue = false,
    Callback = function(Value)
        Settings.DJBuff.Enabled = Value
        if Value then
            Connections.DJBuff = RunService.Heartbeat:Connect(function()
                pcall(function()
                    for _, tower in pairs(Workspace.Towers:GetChildren()) do
                        if tower:FindFirstChild("Owner") and tower.Owner.Value == LocalPlayer then
                            for _, obj in pairs(tower:GetDescendants()) do
                                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                                    local nl = obj.Name:lower()
                                    if nl:find("multiplier")
                                        or nl:find("buff")
                                        or nl:find("boost")
                                        or nl:find("dj")
                                        or nl:find("commander")
                                        or nl:find("rangeboost")
                                        or nl:find("damageboost")
                                        or nl:find("firerateboost")
                                        or nl:find("speedboost")
                                        or nl:find("attackboost") then
                                        obj.Value = Settings.DJBuff.Multi
                                    end
                                end
                            end
                        end
                    end
                end)
            end)
        else
            if Connections.DJBuff then
                Connections.DJBuff:Disconnect()
                Connections.DJBuff = nil
            end
        end
    end,
})

CheatsTab:CreateSlider({
    Name = "Buff Multiplier",
    Range = { 1, 100000 },
    Increment = 1000,
    Suffix = "x",
    CurrentValue = 99999,
    Callback = function(Value)
        Settings.DJBuff.Multi = Value
    end,
})

-- Cash per Kill
CheatsTab:CreateToggle({
    Name = "x9999 Cash Per Kill",
    CurrentValue = false,
    Callback = function(Value)
        Settings.CashKill.Enabled = Value
        if Value then
            Connections.CashKill = task.spawn(function()
                while Settings.CashKill.Enabled do
                    pcall(function()
                        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                            if v:IsA("RemoteEvent")
                                and v.Name:lower():match("kill|enemykilled|reward|cash|credit|earn|gain|money") then
                                v:FireServer(Settings.CashKill.Amount)
                            end
                        end
                    end)
                    task.wait(Settings.CashKill.Delay)
                end
            end)
        else
            if Connections.CashKill then
                task.cancel(Connections.CashKill)
                Connections.CashKill = nil
            end
        end
    end,
})

CheatsTab:CreateSlider({
    Name = "Cash Amount",
    Range = { 100, 10000000 },
    Increment = 100000,
    Suffix = "",
    CurrentValue = 9999999,
    Callback = function(Value)
        Settings.CashKill.Amount = Value
    end,
})

CheatsTab:CreateSlider({
    Name = "Cash Delay",
    Range = { 0.1, 2 },
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.35,
    Callback = function(Value)
        Settings.CashKill.Delay = Value
    end,
})

-- Visual Boost
VisualsTab:CreateToggle({
    Name = "Boost Particles & Lightning Texts (+9999999%)",
    CurrentValue = true,
    Callback = function(Value)
        Settings.VisualBoost.Enabled = Value
        if Value then
            Connections.VisualBoost = task.spawn(function()
                while Settings.VisualBoost.Enabled do
                    pcall(function()
                        -- Texts
                        for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                            if (gui:IsA("TextLabel") or gui:IsA("TextButton"))
                                and (gui.Text:find("⚡")
                                    or gui.Text:lower():find("lightning")
                                    or gui.Text:lower():find("bolt")
                                    or gui.Text:lower():find("shock")) then
                                if gui.Text:find("+%d") or gui.Text:find("%%") then
                                    gui.Text = "+9999999%"
                                    gui.TextColor3 = Color3.fromRGB(255, 215, 0)
                                    gui.TextStrokeTransparency = 0.3
                                    gui.TextStrokeColor3 = Color3.fromRGB(255, 140, 0)
                                    gui.Font = Enum.Font.GothamBlack
                                    gui.TextSize = math.max(18, (gui.TextSize or 16) + 2)
                                end
                            end
                        end

                        -- Particles
                        for _, obj in pairs(Workspace:GetDescendants()) do
                            if obj:IsA("ParticleEmitter")
                                and (obj.Name:lower():find("lightning")
                                    or obj.Name:lower():find("bolt")
                                    or obj.Name:lower():find("shock")
                                    or obj.Name:lower():find("⚡")) then
                                obj.Rate = 999999
                                obj.Speed = NumberRange.new(200, 400)
                                obj.Lifetime = NumberRange.new(1.5, 3)
                                obj.Enabled = true
                            end
                        end
                    end)
                    task.wait(0.4)
                end
            end)
        else
            if Connections.VisualBoost then
                task.cancel(Connections.VisualBoost)
                Connections.VisualBoost = nil
            end
        end
    end,
})

Rayfield:Notify({
    Title = "Mortis NVM HACK v3.3 Loaded!",
    Content = "F1 - toggle, RightShift - Rayfield menu",
    Duration = 6.0,
    Image = 4483362458
})

-- Cleanup on destroy (Rayfield handles)
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "Rayfield Interface" or child.Name:find("Rayfield") then
        for _, conn in pairs(Connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            elseif typeof(conn) == "thread" then
                task.cancel(conn)
            end
        end
    end
end)

