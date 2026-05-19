local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/twinkilya0-jpg/This-is-Not-Your-place/refs/heads/master/Addons/MinifyMain.txt"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/twinkilya0-jpg/This-is-Not-Your-place/refs/heads/master/Addons/SaveManager.txt"))()
local FBM = loadstring(game:HttpGet("https://raw.githubusercontent.com/twinkilya0-jpg/This-is-Not-Your-place/refs/heads/master/Addons/FBM.txt"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/twinkilya0-jpg/This-is-Not-Your-place/refs/heads/master/Addons/InterfaceManager.txt"))()

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
    SubTitle = "1.0.0 Made By Carey",
    TabWidth = 160,
    Size = UDim2.fromOffset(540, 390),
    Acrylic = false,
    Theme = "Darker",
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://7733960981" }),
    AutoFarm = Window:AddTab({ Title = "Farm", Icon = "rbxassetid://10709811110" }),
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
openshit.Parent = LocalPlayer.PlayerGui
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

Tabs.Main:AddParagraph({
    Title = "Esp",
    Content = " "
})

Tabs.Main:AddSection("Billboard")
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

Tabs.Main:AddSection("Tracer")

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

Tabs.Main:AddSection("Highlight")

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


Tabs.Main:AddSection("Map Modification")

_G.RemoveInvisWalls = false
local invisibleWalls = {}

local function scanWalls()
    table.clear(invisibleWalls)
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide == true and part.Transparency >= 0.9 and not part:IsDescendantOf(d.Character) then
            local isPlayer = false
            for _, player in pairs(a:GetPlayers()) do
                if player.Character and part:IsDescendantOf(player.Character) then
                    isPlayer = true
                    break
                end
            end
            if not isPlayer then
                table.insert(invisibleWalls, part)
            end
        end
    end
end

Tabs.Main:AddToggle("RemoveInvisWallsToggle", {
        Title = "Remove Invisible Walls",
        Default = false,
        Callback = function(state)
            _G.RemoveInvisWalls = state
            
            if state then
                scanWalls()
                for _, part in pairs(invisibleWalls) do
                    if part and part.Parent then
                        part.CanCollide = false
                    end
                end
            else
                for _, part in pairs(invisibleWalls) do
                    if part and part.Parent then
                        part.CanCollide = true
                    end
                end
                table.clear(invisibleWalls)
            end
        end
    }
)

task.spawn(function()
    while task.wait(5) do
        if _G.RemoveInvisWalls then
            scanWalls()
            for _, part in pairs(invisibleWalls) do
                if part and part.Parent then
                    part.CanCollide = false
                end
            end
        end
    end
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

local genCounter = 1
local addedGenerators = {}

for _, object in pairs(workspace:GetDescendants()) do
    local name = object.Name:lower()
    
    if name:find("generator") or name == "gen" then
        
        local genModel = object:IsA("Model") and object or object:FindFirstAncestorOfClass("Model")
        
        if genModel and not addedGenerators[genModel] then
            
            local isCompleted = genModel:GetAttribute("Completed") or genModel:GetAttribute("Activated") or genModel:GetAttribute("Done")
            
            if isCompleted ~= true then
                addedGenerators[genModel] = true
                local currentGenNumber = genCounter
                
                Tabs.Main:AddButton({
                    Title = "Teleport to Generator " .. tostring(currentGenNumber),
                    Description = "",
                    Callback = function()
                        if d and d.Character then
                            local root = d.Character:FindFirstChild("HumanoidRootPart")
                            if root and genModel then
                                -- Безопасно получаем координаты всей модели (Pivot)
                                root.CFrame = genModel:GetPivot() * CFrame.new(0, 3, 0)
                            end
                        end
                    end
                })
                
                genCounter = genCounter + 1
            end
        end
    end
end


-- Farm

Tabs.AutoFarm:AddParagraph({
        Title = "Bro This is Beta Test",
        Content = "XD"
    })

-- Combat

Tabs.Combat:AddParagraph({
        Title = "Sorry Script Beta!",
        Content = ""
    })

-- Misc

Tabs.Misc:AddSection("Player Adjustments")

_G.WalkSpeedValue = 16
_G.JumpValue = 50
_G.TPWalkSpeed = 1

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

_G.WalkSpeedValue = _G.WalkSpeedValue or 16

task.spawn(function()
    while true do
        pcall(function()
            local char = localPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = _G.WalkSpeedValue
                end
            end
        end)
        task.wait(0.1)
    end
end)

local WalkSpeedInput = Tabs.Misc:AddInput("WalkSpeedInput", {
    Title = "Player Speed",
    Default = tostring(_G.WalkSpeedValue), 
    Placeholder = "16-150",
    NumericOnly = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value) or 16
        if num < 16 then num = 16 end
        if num > 150 then num = 150 end
        _G.WalkSpeedValue = num
    end
})



local JumpInput = Tabs.Misc:AddInput("JumpInput", {
    Title = "Jump Power",
    Default = "50",
    Placeholder = "50-200",
    NumericOnly = true,
    Finished = false,
    Callback = function(Value) end
})

local function updateJumpLogic(text)
    _G.JumpValue = tonumber(text) or 50
end

if JumpInput.InputFrame and JumpInput.InputFrame:FindFirstChild("TextBox") then
    JumpInput.InputFrame.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateJumpLogic(JumpInput.InputFrame.TextBox.Text)
    end)
end
JumpInput:OnChanged(function() updateJumpLogic(JumpInput.Value) end)

local TPWalkInput = Tabs.Misc:AddInput("TPWalkInput", {
    Title = "TPWalk Multiplier",
    Default = "1",
    Placeholder = "1-200",
    NumericOnly = true,
    Finished = false,
    Callback = function(Value) end
})

local function updateTPWalkLogic(text)
    local num = tonumber(text) or 1
    if num < 1 then num = 1 end
    _G.TPWalkSpeed = num
end

if TPWalkInput.InputFrame and TPWalkInput.InputFrame:FindFirstChild("TextBox") then
    TPWalkInput.InputFrame.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateTPWalkLogic(TPWalkInput.InputFrame.TextBox.Text)
    end)
end
TPWalkInput:OnChanged(function() updateTPWalkLogic(TPWalkInput.Value) end)

c.RenderStepped:Connect(function(dt)
    if _G.TPWalkSpeed > 1 and d and d.Character then
        local character = d.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
            local isStunned = character:GetAttribute("Stunned") or character:GetAttribute("IsStunned") or character:GetAttribute("Frozen")
            if not isStunned and humanoid.PlatformStand == false then
                rootPart.CFrame = rootPart.CFrame + (humanoid.MoveDirection * (humanoid.WalkSpeed * (_G.TPWalkSpeed - 1)) * dt)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        
        if d and d.Character then
            local character = d.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                local isStunned = character:GetAttribute("Stunned") or character:GetAttribute("IsStunned") or character:GetAttribute("Frozen")
                
                if not isStunned and humanoid.PlatformStand == false then
                    if _G.WalkSpeedValue ~= 16 and humanoid.WalkSpeed ~= _G.WalkSpeedValue then
                        humanoid.WalkSpeed = _G.WalkSpeedValue
                    end
                    
                    humanoid.UseJumpPower = true
                    if humanoid.JumpPower ~= _G.JumpValue then
                        humanoid.JumpPower = _G.JumpValue
                    end
                else
                    task.wait(0.4)
                end
            end
        end
    end
end)


Tabs.Misc:AddSection("Attributes")



_G.JumpButtonEnabled = false

local playerGui = d:WaitForChild("PlayerGui")

local function forceJumpButtonState()
    local touchGui = playerGui:FindFirstChild("TouchGui")
    local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
    local jumpButton = touchFrame and touchFrame:FindFirstChild("JumpButton")
    if jumpButton then
        jumpButton.Visible = _G.JumpButtonEnabled
    end
end

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

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

_G.AntiStunActive = false

task.spawn(function()
    while true do
        if _G.AntiStunActive then
            local char = localPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                if humanoid.PlatformStand then humanoid.PlatformStand = false end
                if humanoid.Sit then humanoid.Sit = false end
                
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and root.Anchored then root.Anchored = false end
                
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        if part.Anchored then part.Anchored = false end
                    end
                    
                    local name = part.Name:lower()
                    if name:find("stun") or name:find("freeze") or name:find("ragdoll") or name:find("paralyze") or name:find("ice") then
                        part:Destroy()
                    end
                end
                
                local state = humanoid:GetState()
                if state == Enum.HumanoidStateType.StrafingNoPhysics or state == Enum.HumanoidStateType.Physics then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end
        task.wait(0.1)
    end
end)

local AntiStunToggle = Tabs.Misc:AddToggle("AntiStunToggle", {
    Title = "Anti Stun",
    Default = false,
    Callback = function(Value)
        _G.AntiStunActive = Value
    end
})


-- Visual

Tabs.Visual:AddSection("Camera Adjustment")
local wyrm_fov = 70

getgenv().WyrmResolution = {
    ["Aori_Stretch"] = 1
}

_G.NoCameraShake = false
_G.NoVignette = false

local function disableVignette()
    local currentCam = workspace.CurrentCamera
    if currentCam then
        for _, effect in pairs(currentCam:GetChildren()) do
            if effect:IsA("PostEffect") or effect.Name:lower():find("vignette") then
                effect.Enabled = not _G.NoVignette
            end
        end
    end
    if d and d.PlayerGui then
        for _, gui in pairs(d.PlayerGui:GetDescendants()) do
            if gui:IsA("ImageLabel") and (gui.Name:lower():find("vignette") or gui.Image:find("vignette")) then
                gui.Visible = not _G.NoVignette
            end
        end
    end
end

Tabs.Visual:AddInput("FOV_Val", {
    Title = "FOV", 
    Default = "70", 
    Callback = function(v) 
        local num = tonumber(v)
        if num then
            wyrm_fov = num 
        end
    end
})

Tabs.Visual:AddInput("Res_Val", {
    Title = "Stretch Res",
    Default = "1",
    Callback = function(v)
        local num = tonumber(v)
        if num then
            getgenv().WyrmResolution["Aori_Stretch"] = num
        end
    end
})

Tabs.Visual:AddToggle("NoCameraShakeToggle", {
    Title = "No Camera Shake",
    Default = false,
    Callback = function(state)
        _G.NoCameraShake = state
    end
})

Tabs.Visual:AddToggle("NoVignetteToggle", {
    Title = "No Vignette",
    Default = false,
    Callback = function(state)
        _G.NoVignette = state
        disableVignette()
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

Tabs.Visual:AddInput("MaxZoomInput", {
    Title = "Max Zoom Distance",
    Description = "Zoom Unlock",
    Default = "128",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            game.Players.LocalPlayer.CameraMaxZoomDistance = num
        else
            game.Players.LocalPlayer.CameraMaxZoomDistance = 128
        end
    end
})

Tabs.Visual:AddToggle("NoclipCam", {
    Title = "Noclip Camera",
    Description = "",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if state then
            player.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        else
            player.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
        end
    end
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
    Title = "🥀🥀🥀🥀🥀",
    Content = "🥀🥀🥀🥀🥀"
})

Tabs.Info:AddParagraph({
    Title = "Fluent UI",
    Content = "By dawid-scripts"
})


Tabs.Extension:AddSection("Character Extension")

Tabs.Extension:AddButton(
    {
        Title = "Korblox",
        Description = "",
        Callback = function()
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local RunService = game:GetService("RunService")
            
            local KORBLOX_MESH_ID = "rbxassetid://101851696" -- Korblox Right leg mesh
            local KORBLOX_COLOR = Color3.fromRGB(50, 50, 50) -- Dark Grey for Korblox color

            local function applyKorbloxLeg(character)
                -- Handle R6
                local rightLeg = character:WaitForChild("Right Leg", 9e9) or character:WaitForChild("RightUpperLeg", 9e9)
                if not rightLeg then
                    warn("Right Leg/Upper Leg not found!")
                    return
                end

                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
                        child:Destroy()
                    end
                end

                rightLeg.Color = KORBLOX_COLOR
                rightLeg:GetPropertyChangedSignal("Color"):Connect(
                    function()
                        if rightLeg.Color ~= KORBLOX_COLOR then
                            rightLeg.Color = KORBLOX_COLOR
                        end
                    end
                )

                local korbloxMesh = Instance.new("SpecialMesh")
                korbloxMesh.MeshType = Enum.MeshType.FileMesh
                korbloxMesh.MeshId = KORBLOX_MESH_ID
                korbloxMesh.Scale = Vector3.new(1, 1, 1)
                korbloxMesh.Parent = rightLeg
            end

            local function applyCharacter(character)
                applyKorbloxLeg(character)
            end

            local function applyToLocalPlayer()
                if player.Character then
                    applyCharacter(player.Character)
                end
            end

            player.CharacterAdded:Connect(
                function(character)
                    applyCharacter(character)
                end
            )

            applyToLocalPlayer()
        end
    }
)

Tabs.Extension:AddButton(
    {
        Title = "Korblox 2",
        Description = "",
        Callback = function()
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            
            local KORBLOX_MESH_ID = "rbxassetid://101851582"
            local KORBLOX_COLOR = Color3.fromRGB(50, 50, 50)

            local function applyKorbloxLeg(character)
                local leftLeg = character:WaitForChild("Left Leg", 9e9)
                if not leftLeg then
                    return
                end

                for _, child in ipairs(leftLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
                        child:Destroy()
                    end
                end

                leftLeg.Color = KORBLOX_COLOR
                leftLeg:GetPropertyChangedSignal("Color"):Connect(
                    function()
                        if leftLeg.Color ~= KORBLOX_COLOR then
                            leftLeg.Color = KORBLOX_COLOR
                        end
                    end
                )

                local korbloxMesh = Instance.new("SpecialMesh")
                korbloxMesh.MeshType = Enum.MeshType.FileMesh
                korbloxMesh.MeshId = KORBLOX_MESH_ID
                korbloxMesh.Scale = Vector3.new(1, 1, 1)
                korbloxMesh.Parent = leftLeg
            end

            if player.Character then
                applyKorbloxLeg(player.Character)
            end

            player.CharacterAdded:Connect(
                function(character)
                    applyKorbloxLeg(character)
                end
            )
        end
    }
)


Tabs.Extension:AddButton(
    {
        Title = "Headless",
        Description = "",
        Callback = function()
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local RunService = game:GetService("RunService")
            local HEADLESS_MESH_ID = "rbxassetid://1095708"    -- Tiny invisible headless mesh

            local function applyHeadless(head)
                if not head then
                    return
                end

                head.Transparency = 1
                head.CanCollide = false
                
                local function removeFace()
                    local face = head:FindFirstChild("face")
                    if face then
                        face:Destroy()
                    end
                end

                removeFace()

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = HEADLESS_MESH_ID
                mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
                mesh.Parent = head

                head:GetPropertyChangedSignal("Transparency"):Connect(
                    function()
                        if head.Transparency ~= 1 then
                            head.Transparency = 1
                        end
                    end
                )

                head.ChildAdded:Connect(
                    function(child)
                        if child.Name == "face" and child:IsA("Decal") then
                            child:Destroy()
                        end
                    end
                )
            end

            local function applyCharacter(character)
                local head = character:WaitForChild("Head", 9e9)
                if head then
                    applyHeadless(head)
                end
            end

            local function applyToLocalPlayer()
                if player.Character then
                    applyCharacter(player.Character)
                end
            end

            
            player.CharacterAdded:Connect(
                function(character)
                    applyCharacter(character)
                end
            )

            applyToLocalPlayer()
        end
    }
)

_G.Players = game:GetService("Players")
_G.LPlayer = _G.Players.LocalPlayer


_G.ExtStates = {
    Wings = false,
    Poison = false,
    Frozen = false,
    Fire = false
}


_G.ApplySingleExt = function(id, name, state)
    if not state then
        if _G.LPlayer.Character and _G.LPlayer.Character:FindFirstChild(name) then
            _G.LPlayer.Character[name]:Destroy()
        end
        return
    end
    
    if not _G.LPlayer.Character or _G.LPlayer.Character:FindFirstChild(name) then return end
    
    local s, obj = pcall(function() return game:GetObjects("rbxassetid://" .. id)[1] end)
    if s and obj then
        obj.Name = name
        obj.Parent = _G.LPlayer.Character
        local h = obj:FindFirstChild("Handle")
        if h then
            local w = Instance.new("Weld", h)
            w.Part0 = h
            w.Part1 = _G.LPlayer.Character:FindFirstChild("Head")
            w.C0 = obj.AttachmentPoint
            w.C1 = CFrame.new(0, 0.5, 0)
            w.Parent = h
        end
    end
end


_G.RefreshExts = function()
    if _G.ExtStates.Wings then _G.ApplySingleExt(192557913, "Wings_Acc", true) end
    if _G.ExtStates.Poison then _G.ApplySingleExt(1744060292, "Poison_Acc", true) end
    if _G.ExtStates.Frozen then _G.ApplySingleExt(74891470, "Frozen_Acc", true) end
    if _G.ExtStates.Fire then _G.ApplySingleExt(215718515, "Fire_Acc", true) end
end


_G.LPlayer.CharacterAdded:Connect(function()
    task.wait(1.5) 
    _G.RefreshExts()
end)

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
loadstring(game:HttpGet("https://raw.githubusercontent.com/twinkilya0-jpg/This-is-Not-Your-place/refs/heads/master/ScriptsLoL/SENSITIVITY"))()
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

task.spawn(function()
    local L = game:GetService("Lighting")
    local skyData = {
                ["Default"] = "",
        ["BlackHole3D"] = "rbxassetid://80849072113452",
        ["BlackHole2D"] = "rbxassetid://107612473658715",
        ["Moon"] = "rbxassetid://130749862399911",
        ["Retro"] = "rbxassetid://103427685372239",
        ["Gojo"] = "rbxassetid://127514067186397",
        ["Saturn"] = "rbxassetid://117249211734513",
        ["PhantomWyrm"] = "rbxassetid://75138310179914",
        ["RetroDiscord"] = "rbxassetid://89057708562209",
        ["ScaryCat"] = "rbxassetid://120407577036889" ,
        ["RobloxCat"] = "rbxassetid://127289321458446",
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
    
    DFunctions.rbConn = nil

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

do
    local Lighting = game:GetService("Lighting")
    
    local defaultGlobalShadows = Lighting.GlobalShadows
    local defaultTechnology = Lighting.Technology

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
end

getgenv().OptimizeRendering = false

local OptimizeToggle = Tabs.Extension:AddToggle("OptimizeToggle", {Title = "Render Optimization", Default = false})

local function safeOptimize(obj)
    if obj:IsA("BasePart") then
        if obj.Transparency >= 1 or (obj.Material == Enum.Material.Plastic and obj.Transparency > 0) then
            obj.CastShadow = false
     
            pcall(function()
                obj.RenderFidelity = Enum.RenderFidelity.Performance
            end)
        end
    end
end

OptimizeToggle:OnChanged(function()
    getgenv().OptimizeRendering = OptimizeToggle.Value
    
    if getgenv().OptimizeRendering then
        for _, obj in ipairs(workspace:GetDescendants()) do
            safeOptimize(obj)
        end
    end
end)

workspace.DescendantAdded:Connect(function(obj)
    if getgenv().OptimizeRendering then
        safeOptimize(obj)
    end
end)


local Lighting = game:GetService("Lighting")

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

do
    local FpsConfig = {
        Enabled = false
    }

    local function updateFps()
        pcall(function()
            local target = FpsConfig.Enabled and 9999 or 60
            
            if setfflag then
                setfflag("TaskSchedulerTargetFps", tostring(target))
                setfflag("DFIntTaskSchedulerTargetFps", tostring(target))
            end
            
            if setfpscap then
                setfpscap(target)
            end
        end)
    end
    
local networkPausedConn

local AntiGPTPause = Tabs.Extension:AddToggle("AntiNetworkPause", {
    Title = "Anti Gameplay Paused", 
    Default = false, 
    Description = ""
})

AntiGPTPause:OnChanged(function(Value)
    if Value then
        pcall(function()
            local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
            local currentPause = RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
            
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


    Tabs.Extension:AddToggle("FpsUnlockToggle", {
        Title = "Unlock FPS",
        Description = "Removes the frame rate cap",
        Default = false,
        Callback = function(Value)
            FpsConfig.Enabled = Value
            updateFps()
        end
    })

    task.spawn(function()
        while true do
            if FpsConfig.Enabled then
                updateFps()
            end
            task.wait(5)
        end
    end)
end



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