if getgenv().DaraHubExecuted then
    NotifyToast({
        title = "WARNING!",
        content = "Script Is Already Loaded, rejoin of you want to re-execute.",
        duration = 8,
        icon = "triangle-exclamation",
        iconColor = "#FFFF00",
    })
    return
end
getgenv().DaraHubExecuted = true
loadstring(game:HttpGet("https://darahub.pages.dev/Module/Library/GUI/LoadAll.lua"))()
local WindUI = loadstring(game:HttpGet("https://darahub.pages.dev/Module/Library/GUI/WindUI-Moded/main.lua"))()

Window = WindUI:CreateWindow({
    NewElements = true,
    Title = "Dara Hub | Murder Mystery 2",
    Icon = "rbxassetid://137330250139083",
    Author = "Made by: Pnsdg And Yomka",
    Folder = "DaraHub/Games/Murder-Mystery-2(Normal-Mode)",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    HidePanelBackground = false,
    Acrylic = false,
    HideSearchBar = false,
    SideBarWidth = 200,
    OpenButton = {
        Enabled = false,
        Scale = 0
    },
})
WindUI.TransparencyValue = 0.7
Window:ToggleTransparency(true)
Window:DisableTopbarButtons({ "Fullscreen" })
pcall(updateWindowOpenState)
Window:SetIconSize(48)
Window:Tag({
    Title = "V1.1.5",
    Color = Color3.fromHex("#30ff6a")
})
executor = identifyexecutor()
if type(executor) == "table" then
    for key, value in pairs(executor) do
        print(key .. ": " .. tostring(value))
    end
elseif type(executor) == "string" then
    Window:Tag({
        Title = "" .. executor
    })
else
    print("The injector does not support identifyexecutor()")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Character
local Humanoid
local HumanoidRootPart

local function setupCharacter(character)
    Character = character
    Humanoid = character:FindFirstChildOfClass("Humanoid")
    HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
end

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)

local CurrentRoundClient = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CurrentRoundClient"))

function GetPlayerData()
    return CurrentRoundClient.GetLatestPlayerData()
end

function GetPlayerRole(playerName)
    local playerData = GetPlayerData()
    if playerData and playerData[playerName] then
        return playerData[playerName].Role
    end
    return nil
end

function GetMurderer()
    local playerData = GetPlayerData()
    if playerData then
        for name, data in pairs(playerData) do
            if data.Role == "Murderer" then
                return Players:FindFirstChild(name)
            end
        end
    end
    return nil
end

function GetSheriff()
    local playerData = GetPlayerData()
    if playerData then
        for name, data in pairs(playerData) do
            if data.Role == "Sheriff" then
                return Players:FindFirstChild(name)
            end
        end
    end
    return nil
end

function GetHero()
    local playerData = GetPlayerData()
    if playerData then
        for name, data in pairs(playerData) do
            if data.Role == "Hero" then
                return Players:FindFirstChild(name)
            end
        end
    end
    return nil
end

function IsPlayerAlive(playerName)
    local playerData = GetPlayerData()
    if playerData and playerData[playerName] then
        local data = playerData[playerName]
        return not (data.Killed or data.Dead)
    end
    return false
end

function IsPlayerDead()
    local playerData = GetPlayerData()
    if playerData and playerData[LocalPlayer.Name] then
        local data = playerData[LocalPlayer.Name]
        return data.Killed or data.Dead
    end
    return false
end

function GetPlayerPerk(playerName)
    local playerData = GetPlayerData()
    if playerData and playerData[playerName] then
        return playerData[playerName].Perk
    end
    return nil
end

function GetMurdererPerk()
    return CurrentRoundClient.GetMurdererPerk()
end
RoleList = {
    Innocent = Color3.fromRGB(0, 255, 0),
    Sheriff = Color3.fromRGB(0, 0, 255),
    Hero = Color3.fromRGB(255, 255, 0),
    Murderer = Color3.fromRGB(255, 0, 0),
    Assassin = Color3.fromRGB(255, 0, 0),
    Zombie = Color3.fromRGB(25, 172, 0),
    Survivor = Color3.fromRGB(43, 154, 238),
    Red = Color3.fromRGB(217, 35, 35),
    Blue = Color3.fromRGB(63, 176, 224),
    Juggernaut = Color3.fromRGB(217, 35, 35),
    Gladiator = Color3.fromRGB(63, 176, 224),
    Freezer = Color3.fromRGB(150, 220, 250),
    Runner = Color3.fromRGB(0, 200, 100)
}
TPWALK = false
TpwalkValue = 1
JumpBoost = false
JumpPower = 5
SpeedHack = false
SpeedValue = 16
Noclip = false

function IsAlive(Player, currentRoles)
    for i, v in pairs(currentRoles) do
        if Player.Name == i then
            if not v.Killed and not v.Dead then
                return true
            else
                return false
            end
        end
    end
    return false
end

function getOutlineColor(c)
    local lum = 0.299 * c.R + 0.587 * c.G + 0.114 * c.B
    if lum > 0.5 then
        return Color3.new(0,0,0)
    else
        return Color3.new(1,1,1)
    end
end

Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "layout-grid" }),
    Player = Window:Tab({ Title = "Player", Icon = "user" }),
    Combat = Window:Tab({ Title = "Combat", Icon = "swords" }),
    Visuals = Window:Tab({ Title = "Visuals", Icon = "camera" }),
    ESP = Window:Tab({ Title = "Esp", Icon = "eye" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "navigation" }),
    Troll = Window:Tab({ Title = "Troll Shit stuffs", Icon = "rbxassetid://6862780932" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "star" }),
    Utility = Window:Tab({ Title = "Utility", Icon = "wrench" }),
    Settings = Window:Tab({ Title = "Settings", Icon = "settings" }),
    info = Window:Tab({ Title = "Info", Icon = "info" }),
    Others = Window:Tab({ Title = "Others", Icon = "https://em-content.zobj.net/source/apple/419/pile-of-poo_1f4a9.png" })
}

local socialsModule = loadstring(game:HttpGet("https://darahub.pages.dev/Module/info.lua"))()
socialsModule(Tabs)

local UniverseServerTools = loadstring(game:HttpGet("https://darahub.pages.dev/Module/UniverseServerTools.lua"))()
UniverseServerTools(Tabs)

Window:OnOpen(function()
    ButtonLib:OpenButton(false)
end)
Window:OnClose(function()
    ButtonLib:OpenButton(true)
end)
Window:OnDestroy(function()
    ButtonLib:DestroyScreengui()
end)

playerCountParagraph = Tabs.Main:Paragraph({
    Title = "Player Count",
    Desc = "Waiting..."
})

ModelPlayerAntiBrokenServer = Tabs.Main:Paragraph({
    Title = "Player Model Server Status",
    Desc = "Waiting..."
})

playerModelCheckConnection = RunService.Heartbeat:Connect(function()
    local players = Players:GetPlayers()
    local playerCount = #players
    local modelCount = 0

    for _, player in ipairs(players) do
        if player.Character then
            modelCount = modelCount + 1
        end
    end

    playerCountParagraph:SetDesc(playerCount .. " Online | Player Models Found: " .. modelCount)

    if playerCount == modelCount and playerCount > 0 then
        ModelPlayerAntiBrokenServer:SetDesc("Player Model Is Correct Definitely Playable")
    else
        ModelPlayerAntiBrokenServer:SetDesc("Unplayable Server Detected! Missing Player Model, Find a new server")
    end
end)

Tabs.Player:Section({ Title = "Player", TextSize = 40 })
Tabs.Player:Divider()

function onCharacterAdded(newCharacter)
    setupCharacter(newCharacter)
    if JumpBoost and Humanoid then
        Humanoid.JumpPower = JumpPower
        Humanoid.JumpHeight = JumpPower
        setupJumpBoost()
    end
    if SpeedHack and Humanoid then
        Humanoid.WalkSpeed = SpeedValue
    end
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end
local InfiniteJump = {
    State = nil,
    Connection = nil,
    Enabled = false
}

local function StartInfiniteJump()
    if InfiniteJump.Enabled then return end
    InfiniteJump.Enabled = true
    InfiniteJump.Connection = RunService.RenderStepped:Connect(function()
        if not InfiniteJump.Enabled then return end
        if not Humanoid then
            if LocalPlayer.Character then
                Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
            if not Humanoid then return end
        end
        if Humanoid.Jump then
            if InfiniteJump.State then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                InfiniteJump.State = false
            end
        else
            InfiniteJump.State = true
        end
    end)
end

local function StopInfiniteJump()
    InfiniteJump.Enabled = false
    if InfiniteJump.Connection then
        InfiniteJump.Connection:Disconnect()
        InfiniteJump.Connection = nil
    end
    InfiniteJump.State = nil
end


InfiniteJumpToggle = Tabs.Player:Toggle({
    Title = "Infinite Jump",
    Flag = "InfiniteJumpToggle",
    Value = false,
    Callback = function(state)
        if state then
        StartInfiniteJump()
        else
        StopInfiniteJump()
        end
    end
})

Tabs.Player:Space()

SpeedToggle = Tabs.Player:Toggle({
    Title = "Speed Hack",
    Flag = "SpeedToggle",
    Value = SpeedHack,
    Callback = function(state)
        SpeedHack = state
        if state and Humanoid then
            Humanoid.WalkSpeed = SpeedValue
        elseif Humanoid then
            Humanoid.WalkSpeed = 16
        end
    end
})

SpeedSlider = Tabs.Player:Slider({
    Title = "Speed Value",
    Flag = "SpeedSlider",
    Desc = "Adjust walk speed",
    Value = { Min = 16, Max = 200, Default = SpeedValue, Step = 1 },
    Callback = function(value)
        SpeedValue = value
        if SpeedHack and Humanoid then
            Humanoid.WalkSpeed = value
        end
    end
})

SpeedGlitchMode = "Air Acceleration"
SpeedGlitchEnabled = false
SpeedGlitchSpeed = 50
local speedGlitchCurrentSpeed = 0
local speedGlitchWasMoving = false
local speedGlitchConnection = nil
local wasOnGround = false
local realisticHolder = nil
local currentCharacter = nil
local currentRoot = nil
local currentHumanoid = nil

function applyAirAccelerationGlitch(character, humanoid, rootPart)
    local moveDir = humanoid.MoveDirection
    if moveDir.Magnitude > 0 then
        speedGlitchCurrentSpeed = speedGlitchCurrentSpeed + (SpeedGlitchSpeed * 0.1)
        local velocity = moveDir * speedGlitchCurrentSpeed
        rootPart.Velocity = Vector3.new(velocity.X, rootPart.Velocity.Y, velocity.Z)
        speedGlitchWasMoving = true
    else
        speedGlitchWasMoving = false
    end
end

function recreateRealisticHolder(character, rootPart)
    if realisticHolder then
        realisticHolder:Destroy()
        realisticHolder = nil
    end

    if not character or not rootPart then return end

    local ws = SpeedGlitchSpeed
    local holder = Instance.new("Part")
    holder.Size = Vector3.new(2, 2, 2)
    holder.Anchored = false
    holder.CanCollide = false
    holder.Transparency = 1
    holder.CFrame = rootPart.CFrame * CFrame.new(10 + (ws * 0.5), 10, -ws)
    holder.Name = "PhysicHolder"
    holder.Parent = character

    local ActualWeld = Instance.new("WeldConstraint")
    ActualWeld.Part0 = rootPart
    ActualWeld.Part1 = holder
    ActualWeld.Parent = rootPart

    realisticHolder = holder
end

function applyRealisticGlitch(character, humanoid, rootPart)
    if not character or not rootPart then return end
    if not realisticHolder or not realisticHolder.Parent or realisticHolder.Parent ~= character then
        recreateRealisticHolder(character, rootPart)
    end
end

function startSpeedGlitch(character, humanoid, rootPart)
    if not character or not humanoid or not rootPart then return end

    currentCharacter = character
    currentRoot = rootPart
    currentHumanoid = humanoid

    if speedGlitchConnection then
        speedGlitchConnection:Disconnect()
        speedGlitchConnection = nil
    end

    speedGlitchConnection = RunService.Heartbeat:Connect(function()
        if SpeedGlitchEnabled and currentHumanoid and currentHumanoid.Parent then
            local isOnGround = currentHumanoid.FloorMaterial ~= Enum.Material.Air
            local isMoving = currentHumanoid.MoveDirection.Magnitude > 0

            if isOnGround and wasOnGround and not isMoving then
                speedGlitchCurrentSpeed = 0
                speedGlitchWasMoving = false
                if currentRoot then
                    local currentVel = currentRoot.Velocity
                    currentRoot.Velocity = Vector3.new(currentVel.X * 0.95, currentVel.Y, currentVel.Z * 0.95)
                end
            end

            wasOnGround = isOnGround

            if currentHumanoid.FloorMaterial == Enum.Material.Air and currentHumanoid:GetState() ~= Enum.HumanoidStateType.Climbing and currentHumanoid:GetState() ~= Enum.HumanoidStateType.Swimming and currentHumanoid:GetState() ~= Enum.HumanoidStateType.Seated and currentHumanoid:GetState() ~= Enum.HumanoidStateType.PlatformStanding then
                if SpeedGlitchMode == "Air Acceleration" then
                    applyAirAccelerationGlitch(currentCharacter, currentHumanoid, currentRoot)
                elseif SpeedGlitchMode == "Realistic" then
                    applyRealisticGlitch(currentCharacter, currentHumanoid, currentRoot)
                end
            end
        end
    end)
end

function stopSpeedGlitch()
    if speedGlitchConnection then
        speedGlitchConnection:Disconnect()
        speedGlitchConnection = nil
    end
    speedGlitchCurrentSpeed = 0
    speedGlitchWasMoving = false
    wasOnGround = false
    if realisticHolder then
        realisticHolder:Destroy()
        realisticHolder = nil
    end
end

function updateSpeedValue()
    if SpeedGlitchEnabled and SpeedGlitchMode == "Realistic" and currentCharacter and currentRoot then
        recreateRealisticHolder(currentCharacter, currentRoot)
    end
end

function onCharacterAdded(character)
    task.wait(0.5)
    if SpeedGlitchEnabled then
        speedGlitchCurrentSpeed = 0
        local hum = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if hum and root then
            stopSpeedGlitch()
            startSpeedGlitch(character, hum, root)
        end
    end
end

function onCharacterRemoving()
    stopSpeedGlitch()
    currentCharacter = nil
    currentRoot = nil
    currentHumanoid = nil
end

Tabs.Player:Space()
Tabs.Player:Divider()
Tabs.Player:Section({ Title = "Speed Glitch (InDev)", TextSize = 20 })
Tabs.Player:Divider()

SpeedGlitchToggle = Tabs.Player:Toggle({
    Title = "Speed Glitch",
    Flag = "SpeedGlitchToggle",
    Value = false,
    Callback = function(state)
        SpeedGlitchEnabled = state
        if state then
            speedGlitchCurrentSpeed = 0
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and root then
                    startSpeedGlitch(char, hum, root)
                end
            end
            if ButtonLib and ButtonLib.SpeedGlitch then
                ButtonLib.SpeedGlitch:Set(true)
            end
        else
            stopSpeedGlitch()
            if ButtonLib and ButtonLib.SpeedGlitch then
                ButtonLib.SpeedGlitch:Set(false)
            end
        end
    end
})

SpeedGlitchModeDropdown = Tabs.Player:Dropdown({
    Title = "Speed Glitch Mode",
    Flag = "SpeedGlitchModeDropdown",
    Values = {"Air Acceleration", "Realistic"},
    Value = "Air Acceleration",
    Callback = function(value)
        SpeedGlitchMode = value
        if SpeedGlitchEnabled then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and root then
                    stopSpeedGlitch()
                    startSpeedGlitch(char, hum, root)
                end
            end
        end
        if SpeedGlitchMode == "Realistic" and SpeedGlitchEnabled then
            updateSpeedValue()
        end
    end
})

SpeedGlitchSpeedInput = Tabs.Player:Input({
    Title = "Speed Value",
    Flag = "SpeedGlitchSpeedInput",
    Placeholder = "50",
    Value = "50",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            SpeedGlitchSpeed = num
            updateSpeedValue()
        end
    end
})

ButtonLib.Create:Toggle({
    Text = "Speed Glitch",
    Flag = "SpeedGlitch",
    Default = false,
    Visible = false,
    Callback = function(s)
        if SpeedGlitchToggle then
            SpeedGlitchToggle:Set(s)
        end
    end
}).Position = UDim2.new(0.5, -125, 0.35, 0)

ShowSpeedGlitchButtonToggle = Tabs.Player:Toggle({
    Title = "Show Speed Glitch Button",
    Flag = "ShowSpeedGlitchButtonToggle",
    Value = false,
    Callback = function(state)
        if ButtonLib and ButtonLib.SpeedGlitch then
            ButtonLib.SpeedGlitch:SetVisible(state)
        end
    end
})

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)

Noclip = nil
Clip = nil

function noclip()
    Clip = false
    function Nocl()
        if Clip == false and LocalPlayer.Character ~= nil then
            for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA('BasePart') and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
        wait(0.21)
    end
    Noclip = RunService.Stepped:Connect(Nocl)
end

function clip()
    if Noclip then 
        Noclip:Disconnect() 
    end
    Clip = true
    if LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA('BasePart') then
                v.CanCollide = true
            end
        end
    end
end

Tabs.Player:Space()
NoclipToggle = Tabs.Player:Toggle({
    Title = "Noclip",
    Flag = "NoclipToggle",
    Value = Noclip,
    Callback = function(state)
        Noclip = state
        if state then
            noclip()
        else
            clip()
        end
    end
})

IsOnMobile = false
xpcall(function()
    IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform()) ~= nil
end, function()
    IsOnMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end)

if IsOnMobile then
    LocalPlayer:WaitForChild("PlayerGui")
    local touchGui = PlayerGui:WaitForChild("TouchGui")
    local touchControlFrame = touchGui:WaitForChild("TouchControlFrame")
    local originalJumpButton = touchControlFrame:WaitForChild("JumpButton")
    local DownWardJumpBtn = nil

    function createDownwardButton()
        if DownWardJumpBtn and DownWardJumpBtn.Parent then
            DownWardJumpBtn:Destroy()
        end

        DownWardJumpBtn = Instance.new("ImageButton")
        DownWardJumpBtn.Name = "DownWardJumpBtn"
        DownWardJumpBtn.Size = originalJumpButton.Size
        DownWardJumpBtn.Image = originalJumpButton.Image
        DownWardJumpBtn.ImageRectOffset = originalJumpButton.ImageRectOffset
        DownWardJumpBtn.ImageRectSize = originalJumpButton.ImageRectSize
        DownWardJumpBtn.BackgroundTransparency = 1
        DownWardJumpBtn.AnchorPoint = Vector2.new(1, 0)
        DownWardJumpBtn.AutoButtonColor = false
        DownWardJumpBtn.Position = UDim2.new(1, 0, originalJumpButton.Position.Y.Scale, originalJumpButton.Position.Y.Offset)
        DownWardJumpBtn.Rotation = 180

        local originalRectOffset = originalJumpButton.ImageRectOffset
        local isHoldingDown = false

        DownWardJumpBtn.MouseButton1Down:Connect(function()
            isHoldingDown = true
            DownWardJumpBtn.ImageRectOffset = Vector2.new(146, 146)
            flyDownPressed = true
        end)

        DownWardJumpBtn.MouseButton1Up:Connect(function()
            if isHoldingDown then
                isHoldingDown = false
                DownWardJumpBtn.ImageRectOffset = originalRectOffset
                flyDownPressed = false
            end
        end)

        DownWardJumpBtn.MouseLeave:Connect(function()
            if isHoldingDown then
                isHoldingDown = false
                DownWardJumpBtn.ImageRectOffset = originalRectOffset
                flyDownPressed = false
            end
        end)

        DownWardJumpBtn.Parent = touchControlFrame

        function preventOverlap()
            if not DownWardJumpBtn or not DownWardJumpBtn.Parent then return end
            local buttonWidth = DownWardJumpBtn.AbsoluteSize.X
            local originalButton = touchControlFrame:FindFirstChild("JumpButton")

            if originalButton then
                local originalRightEdge = originalButton.AbsolutePosition.X + originalButton.AbsoluteSize.X
                local duplicateLeftEdge = DownWardJumpBtn.AbsolutePosition.X
                local distance = duplicateLeftEdge - originalRightEdge

                if distance < 1 then
                    local neededOffset = 1 - distance
                    local newXOffset = DownWardJumpBtn.Position.X.Offset - neededOffset
                    DownWardJumpBtn.Position = UDim2.new(1, newXOffset, DownWardJumpBtn.Position.Y.Scale, DownWardJumpBtn.Position.Y.Offset)
                elseif distance > 1 then
                    local neededOffset = distance - 1
                    local newXOffset = DownWardJumpBtn.Position.X.Offset + neededOffset
                    DownWardJumpBtn.Position = UDim2.new(1, newXOffset, DownWardJumpBtn.Position.Y.Scale, DownWardJumpBtn.Position.Y.Offset)
                end
            end
        end

        DownWardJumpBtn:GetPropertyChangedSignal("AbsoluteSize"):Connect(preventOverlap)
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(preventOverlap)
        preventOverlap()
    end

    local isHoldingJump = false
    local originalJumpRectOffset = originalJumpButton.ImageRectOffset

    originalJumpButton.MouseButton1Down:Connect(function()
        isHoldingJump = true
        originalJumpButton.ImageRectOffset = Vector2.new(146, 146)
        flyUpPressed = true
    end)

    originalJumpButton.MouseButton1Up:Connect(function()
        if isHoldingJump then
            isHoldingJump = false
            originalJumpButton.ImageRectOffset = originalJumpRectOffset
            flyUpPressed = false
        end
    end)

    originalJumpButton.MouseLeave:Connect(function()
        if isHoldingJump then
            isHoldingJump = false
            originalJumpButton.ImageRectOffset = originalJumpRectOffset
            flyUpPressed = false
        end
    end)
end

FLYING = false
flyspeed = 5
flyKeyDown = nil
flyKeyUp = nil
flyVelocityHandlerName = "FlyVelocity_" .. math.random(1000, 9999)
flyGyroHandlerName = "FlyGyro_" .. math.random(1000, 9999)
mfly1 = nil
mfly2 = nil
flyUpPressed = false
flyDownPressed = false

function getRoot(character)
    return character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"))
end

function unmobilefly(speaker)
    pcall(function()
        FLYING = false
        flyUpPressed = false
        flyDownPressed = false
        local root = getRoot(speaker.Character)
        if root then
            local bv = root:FindFirstChild(flyVelocityHandlerName)
            local bg = root:FindFirstChild(flyGyroHandlerName)
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
        if speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") then
            speaker.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
        end
        if mfly1 then mfly1:Disconnect() mfly1 = nil end
        if mfly2 then mfly2:Disconnect() mfly2 = nil end

        if DownWardJumpBtn and DownWardJumpBtn.Parent then
            DownWardJumpBtn:Destroy()
            DownWardJumpBtn = nil
        end
    end)
end

function mobilefly(speaker)
    unmobilefly(speaker)
    FLYING = true
    createDownwardButton()

    local root = getRoot(speaker.Character)
    if not root then return end

    local camera = workspace.CurrentCamera
    local v3none = Vector3.new()
    local v3zero = Vector3.new(0, 0, 0)
    local v3inf = Vector3.new(9e9, 9e9, 9e9)

    local controlModule = nil
    pcall(function()
        controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    end)

    local bv = Instance.new("BodyVelocity")
    bv.Name = flyVelocityHandlerName
    bv.Parent = root
    bv.MaxForce = v3zero
    bv.Velocity = v3zero

    local bg = Instance.new("BodyGyro")
    bg.Name = flyGyroHandlerName
    bg.Parent = root
    bg.MaxTorque = v3inf
    bg.P = 1000
    bg.D = 50

    mfly2 = RunService.RenderStepped:Connect(function()
        local currentRoot = getRoot(speaker.Character)
        local currentCamera = workspace.CurrentCamera
        local currentHumanoid = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")

        if currentHumanoid and currentRoot and currentRoot:FindFirstChild(flyVelocityHandlerName) and currentRoot:FindFirstChild(flyGyroHandlerName) then
            local VelocityHandler = currentRoot:FindFirstChild(flyVelocityHandlerName)
            local GyroHandler = currentRoot:FindFirstChild(flyGyroHandlerName)

            VelocityHandler.MaxForce = v3inf
            GyroHandler.MaxTorque = v3inf
            currentHumanoid.PlatformStand = true
            GyroHandler.CFrame = currentCamera.CoordinateFrame

            local moveVector = Vector3.new(0, 0, 0)

            if controlModule then
                local direction = controlModule:GetMoveVector()
                local speed = flyspeed * 50

                moveVector = (currentCamera.CFrame.RightVector * direction.X * speed) +
                             (-currentCamera.CFrame.LookVector * direction.Z * speed)
            end

            if flyUpPressed then
                moveVector = moveVector + Vector3.new(0, flyspeed * 50, 0)
            end
            if flyDownPressed then
                moveVector = moveVector - Vector3.new(0, flyspeed * 50, 0)
            end

            VelocityHandler.Velocity = moveVector
        end
    end)
end

function pcfly()
    local plr = LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        repeat task.wait() until char:FindFirstChildOfClass("Humanoid")
        humanoid = char:FindFirstChildOfClass("Humanoid")
    end

    if flyKeyDown or flyKeyUp then
        flyKeyDown:Disconnect()
        flyKeyUp:Disconnect()
    end

    local T = getRoot(char)
    if not T then return end

    local WPressed = false
    local SPressed = false
    local APressed = false
    local DPressed = false
    local SpacePressed = false
    local CtrlPressed = false

    function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        task.spawn(function()
            while FLYING do
                task.wait()
                local camera = workspace.CurrentCamera
                humanoid.PlatformStand = true

                local moveDirection = Vector3.new(0, 0, 0)

                if WPressed then
                    moveDirection = moveDirection + camera.CFrame.LookVector * flyspeed
                end
                if SPressed then
                    moveDirection = moveDirection - camera.CFrame.LookVector * flyspeed
                end
                if APressed then
                    moveDirection = moveDirection - camera.CFrame.RightVector * flyspeed
                end
                if DPressed then
                    moveDirection = moveDirection + camera.CFrame.RightVector * flyspeed
                end
                if SpacePressed then
                    moveDirection = moveDirection + Vector3.new(0, flyspeed * 2, 0)
                end
                if CtrlPressed then
                    moveDirection = moveDirection - Vector3.new(0, flyspeed * 2, 0)
                end

                BV.Velocity = moveDirection * 16
                BG.CFrame = camera.CFrame
            end

            BG:Destroy()
            BV:Destroy()
            if humanoid then humanoid.PlatformStand = false end
        end)
    end

    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then
            WPressed = true
        elseif input.KeyCode == Enum.KeyCode.S then
            SPressed = true
        elseif input.KeyCode == Enum.KeyCode.A then
            APressed = true
        elseif input.KeyCode == Enum.KeyCode.D then
            DPressed = true
        elseif input.KeyCode == Enum.KeyCode.Space then
            SpacePressed = true
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            CtrlPressed = true
        end
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
    end)

    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then
            WPressed = false
        elseif input.KeyCode == Enum.KeyCode.S then
            SPressed = false
        elseif input.KeyCode == Enum.KeyCode.A then
            APressed = false
        elseif input.KeyCode == Enum.KeyCode.D then
            DPressed = false
        elseif input.KeyCode == Enum.KeyCode.Space then
            SpacePressed = false
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            CtrlPressed = false
        end
    end)

    FLY()
end

function NOFLY()
    FLYING = false
    flyUpPressed = false
    flyDownPressed = false
    if flyKeyDown then 
        flyKeyDown:Disconnect()
        flyKeyDown = nil
    end
    if flyKeyUp then 
        flyKeyUp:Disconnect()
        flyKeyUp = nil
    end

    if IsOnMobile then
        unmobilefly(LocalPlayer)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
            LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
        end
        local root = getRoot(LocalPlayer.Character)
        if root then
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

function onCharacterAdded()
    if FlyToggle and FlyToggle.Value then
        task.wait(1)
        if IsOnMobile then
            mobilefly(LocalPlayer)
        else
            pcfly()
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    NOFLY()
    onCharacterAdded()
end)

Tabs.Player:Space()

FlyToggle = Tabs.Player:Toggle({
    Title = "Fly",
    Flag = "FlyToggle",
    Value = false,
    Callback = function(state)
        if state then
            if IsOnMobile then
                mobilefly(LocalPlayer)
            else
                pcfly()
            end
        else
            NOFLY()
        end
    end
})

FlySpeedInput = Tabs.Player:Input({
    Title = "Fly Speed",
    Flag = "FlySpeedInput",
    Placeholder = "Enter speed value",
    Value = tostring(flyspeed),
    NumbersOnly = true,
    Callback = function(value)
        local speed = tonumber(value)
        if speed and speed > 0 then
            flyspeed = speed
        end
    end
})

ShowFlyButtonToggle = Tabs.Player:Toggle({
    Title = "Fly Button",
    Flag = "ShowFlyButton",
    Value = false,
    Callback = function(state)
        IY = IY or {}
        IY.FlightBtn = state

        if ButtonLib and ButtonLib.Flight then
            ButtonLib.Flight:SetVisible(state)
        end
    end
})

ButtonLib.Create:Toggle({
    Text = "Flight",
    Flag = "Flight",
    Default = false,
    Visible = false,
    Callback = function(s) 
        if FlyToggle then
            FlyToggle:Set(s)
        end
    end
}).Position = UDim2.new(0.5, -125, 0.4, 0)

local godModeEnabled = false
local godModeConnection = nil
local godModeMethod = "Health Math.huge"

function applyHumanoidReplacement()
    local Char = LocalPlayer.Character
    local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
    if not Human then return end

    local nHuman = Human:Clone()
    nHuman.Parent = Char
    LocalPlayer.Character = nil
    nHuman:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    nHuman:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    nHuman:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    nHuman.BreakJointsOnDeath = true
    nHuman.MaxHealth = math.huge
    nHuman.Health = math.huge
    Human:Destroy()
    LocalPlayer.Character = Char
    nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

    local Script = Char:FindFirstChild("Animate")
    if Script then
        Script.Disabled = true
        wait()
        Script.Disabled = false
    end
end

function applyHealthMathHuge()
    local Char = LocalPlayer.Character
    local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
    if not Human then return end

    Human.MaxHealth = math.huge
    Human.Health = math.huge

    Human:GetPropertyChangedSignal("Health"):Connect(function()
        if godModeEnabled and Human.Health < Human.MaxHealth then
            Human.Health = Human.MaxHealth
        end
    end)
end

function applyGodMode()
    if godModeMethod == "Humanoid Replacement (Very buggy)" then
        applyHumanoidReplacement()
    elseif godModeMethod == "Health Math.huge" then
        applyHealthMathHuge()
    end
end

function startGodMode()
    if godModeConnection then return end

    godModeConnection = RunService.Heartbeat:Connect(function()
        if godModeEnabled and LocalPlayer.Character then
            local Human = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if Human and Human.Health < math.huge then
                applyGodMode()
            end
        end
    end)
end

function stopGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
end

Tabs.Player:Space()
GodModeToggle = Tabs.Player:Toggle({
    Title = "God Mode",
    Flag = "GodModeToggle",
    Desc = "Become invincible",
    Value = false,
    Callback = function(state)
        godModeEnabled = state
        if state then
            applyGodMode()
            startGodMode()
        else
            stopGodMode()
        end
    end
})

Tabs.Player:Space()
GodModeMethodDropdown = Tabs.Player:Dropdown({
    Title = "God Mode Method",
    Flag = "GodModeMethodDropdown",
    Values = {"Health Math.huge", "Humanoid Replacement (Very buggy)"},
    Value = "Health Math.huge",
    MenuWidth = 400,
    Callback = function(value)
        godModeMethod = value
        if godModeEnabled then
            applyGodMode()
        end
    end
})

ToggleTpwalk = false
TpwalkConnection = nil

function Tpwalking()
    if ToggleTpwalk and Character and Humanoid and HumanoidRootPart then
        local moveDirection = Humanoid.MoveDirection
        local moveDistance = TpwalkValue
        local origin = HumanoidRootPart.Position
        local direction = moveDirection * moveDistance
        local targetPosition = origin + direction
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local raycastResult = workspace:Raycast(origin, direction, raycastParams)
        if raycastResult then
            local hitPosition = raycastResult.Position
            local distanceToHit = (hitPosition - origin).Magnitude
            if distanceToHit < math.abs(moveDistance) then
                targetPosition = origin + (direction.Unit * (distanceToHit - 0.1))
            end
        end
        HumanoidRootPart.CFrame = CFrame.new(targetPosition) * HumanoidRootPart.CFrame.Rotation
        HumanoidRootPart.CanCollide = true
    end
end

function startTpwalk()
    ToggleTpwalk = true
    if TpwalkConnection then
        TpwalkConnection:Disconnect()
    end
    TpwalkConnection = RunService.Heartbeat:Connect(Tpwalking)
end

function stopTpwalk()
    ToggleTpwalk = false
    if TpwalkConnection then
        TpwalkConnection:Disconnect()
        TpwalkConnection = nil
    end
    if HumanoidRootPart then
        HumanoidRootPart.CanCollide = false
    end
end

Tabs.Player:Space()
TPWALKToggle = Tabs.Player:Toggle({
    Title = "TP WALK",
    Flag = "TPWALKToggle",
    Value = TPWALK,
    Callback = function(state)
        TPWALK = state
        if state then
            startTpwalk()
        else
            stopTpwalk()
        end
    end
})

TPWALKSlider = Tabs.Player:Slider({
    Title = "TPWALK VALUE",
    Flag = "TPWALKSlider",
    Desc = "Adjust TPWALK speed",
    Value = { Min = 1, Max = 200, Default = TpwalkValue, Step = 1 },
    Callback = function(value)
        TpwalkValue = value
    end
})

jumpCount = 0
MAX_JUMPS = math.huge

function setupJumpBoost()
    if not Character or not Humanoid then return end
    Humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Landed then
            jumpCount = 0
        end
    end)
    Humanoid.Jumping:Connect(function(isJumping)
        if isJumping and JumpBoost and jumpCount < MAX_JUMPS then
            jumpCount = jumpCount + 1
            Humanoid.JumpHeight = JumpPower
            if jumpCount > 1 then
                HumanoidRootPart:ApplyImpulse(Vector3.new(0, JumpPower * HumanoidRootPart.Mass, 0))
            end
        end
    end)
end

function startJumpBoost()
    if Humanoid then
        Humanoid.JumpPower = JumpPower
        Humanoid.JumpHeight = JumpPower
    end
    setupJumpBoost()
end

function stopJumpBoost()
    jumpCount = 0
    if Humanoid then
        Humanoid.JumpPower = 50
        Humanoid.JumpHeight = 50
    end
end

Tabs.Player:Space()
JumpBoostToggle = Tabs.Player:Toggle({
    Title = "Jump Height",
    Flag = "JumpBoostToggle",
    Value = JumpBoost,
    Callback = function(state)
        JumpBoost = state
        if state then
            startJumpBoost()
        else
            stopJumpBoost()
        end
    end
})

JumpBoostSlider = Tabs.Player:Slider({
    Title = "Jump Power",
    Flag = "JumpBoostSlider",
    Desc = "Adjust jump height",
    Value = { Min = 1, Max = 200, Default = JumpPower, Step = 1 },
    Callback = function(value)
        JumpPower = value
        if JumpBoost then
            if Humanoid then
                Humanoid.JumpPower = JumpPower
                Humanoid.JumpHeight = JumpPower
            end
        end
    end
})

Tabs.Player:Space()
Tabs.Player:Button({
    Title = "Walk on Walls (must reset to stop)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty21.lua"))()
    end
})

Tabs.Player:Space()
Tabs.Player:Toggle({
    Title = "Fake dead (lays)",
    Compact = true,
    Value = false,
    Callback = function(v)
        local char = LocalPlayer.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")

        if v then
            if hrp and hum then
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    animator:Destroy()
                end

                hum:ChangeState(Enum.HumanoidStateType.Physics)
                hrp.Anchored = true
                hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(90), 0, 0)
                hrp.CFrame = hrp.CFrame + Vector3.new(0, -2, 0)
            end
        else
            if hrp and hum then
                hrp.Anchored = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)

                if not hum:FindFirstChild("Animator") then
                    local newAnimator = Instance.new("Animator")
                    newAnimator.Parent = hum
                end
            end
        end
    end
})

local cameraInputModule = nil
local cameraLockEnabled = false
local lockedTarget = nil
local cameraLockConnection = nil

AimbotEnabled = false
ShowFOV = false
FOVThickness = 2
FOVColor = Color3.new(0, 1, 0)
targetTypes = {}
aimPart = "Head"
aimLockType = "Realistic"
smoothnessValue = 10
wallCheckEnabled = false
fovRadius = 100
lockFOVToCenter = true
maxDistance = 1000
AimbotCircle = nil
aimbotRenderConnection = nil
aimbotRunning = false
aimbotConnection = nil

roleTargets = {}
roleCacheTime = 0
ROLE_CACHE_DURATION = 0.5

function IsOtherPlayerDead(player)
    local playerData = GetPlayerData()
    if playerData and playerData[player.Name] then
        local data = playerData[player.Name]
        return data.Killed or data.Dead
    end
    return false
end

function getRoleListValues()
    local roles = {}
    for roleName, _ in pairs(RoleList) do
        table.insert(roles, roleName)
    end
    table.sort(roles)
    return roles
end

function updateRoleCache()
    local currentTime = tick()
    if currentTime - roleCacheTime < ROLE_CACHE_DURATION then
        return
    end
    roleCacheTime = currentTime
    
    roleTargets = {}
    
    local playerData = GetPlayerData()
    if not playerData then return end
    
    for playerName, data in pairs(playerData) do
        local role = data.Role
        if role and RoleList[role] then
            local player = Players:FindFirstChild(playerName)
            if player and player ~= LocalPlayer and player.Character then
                if not IsOtherPlayerDead(player) then
                    if not roleTargets[role] then
                        roleTargets[role] = {}
                    end
                    local aimPartInstance = getAimPart(player.Character)
                    if aimPartInstance then
                        table.insert(roleTargets[role], {
                            character = player.Character,
                            aimPart = aimPartInstance,
                            player = player,
                            role = role
                        })
                    end
                end
            end
        end
    end
end

function getTargetsByRole(roleName)
    updateRoleCache()
    return roleTargets[roleName] or {}
end

function getAimPart(character)
    if not character then return nil end
    if aimPart == "Head" then
        return character:FindFirstChild("Head")
    elseif aimPart == "Body" then
        return character:FindFirstChild("HumanoidRootPart") or 
            character:FindFirstChild("Torso") or 
            character:FindFirstChild("UpperTorso")
    elseif aimPart == "Legs" then
        return character:FindFirstChild("HumanoidRootPart") or
            character:FindFirstChild("LowerTorso") or
            character:FindFirstChild("Left Leg") or
            character:FindFirstChild("Right Leg")
    end
    return character:FindFirstChild("Head")
end

function isVisible(part)
    if not wallCheckEnabled or not part then
        return true
    end
    local character = LocalPlayer.Character
    if not character then return false end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local origin = humanoidRootPart.Position
    local target = part.Position
    local direction = (target - origin).Unit
    local ray = Ray.new(origin, direction * (target - origin).Magnitude)
    local ignoreList = {character, part.Parent}
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    return hit == nil or hit:IsDescendantOf(part.Parent)
end

function getAllTargets()
    local targets = {}
    local character = LocalPlayer.Character
    local playerPos = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position or nil
    
    if #targetTypes == 0 then
        local allRoles = getRoleListValues()
        for _, roleName in ipairs(allRoles) do
            local roleTargetsList = getTargetsByRole(roleName)
            for _, target in ipairs(roleTargetsList) do
                if target.aimPart then
                    if not playerPos or (target.aimPart.Position - playerPos).Magnitude <= maxDistance then
                        table.insert(targets, target)
                    end
                end
            end
        end
    else
        for _, targetType in ipairs(targetTypes) do
            local roleTargetsList = getTargetsByRole(targetType)
            for _, target in ipairs(roleTargetsList) do
                if target.aimPart then
                    if not playerPos or (target.aimPart.Position - playerPos).Magnitude <= maxDistance then
                        table.insert(targets, target)
                    end
                end
            end
        end
    end
    return targets
end

function isValidTarget(target)
    if not target or not target.aimPart then
        return false
    end
    local character = LocalPlayer.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false
    end
    if IsOtherPlayerDead(target.player) then
        return false
    end
    if not target.aimPart.Parent then
        return false
    end
    local distance = (target.aimPart.Position - character.HumanoidRootPart.Position).Magnitude
    if distance > maxDistance then
        return false
    end
    local Camera = workspace.CurrentCamera
    if not Camera then return false end
    local screenPos, onScreen = Camera:WorldToViewportPoint(target.aimPart.Position)
    if not onScreen then
        return false
    end
    local screenCenter = lockFOVToCenter and 
        Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or 
        UserInputService:GetMouseLocation()
    local fovDistance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
    if fovDistance > fovRadius then
        return false
    end
    if not isVisible(target.aimPart) then
        return false
    end
    return true
end

function getClosestEnemyInFOV()
    local allTargets = getAllTargets()
    if #allTargets == 0 then
        return nil
    end
    
    if lockedTarget and isValidTarget(lockedTarget) then
        return lockedTarget
    end
    
    local closestTarget = nil
    local closestDistance = math.huge
    local Camera = workspace.CurrentCamera
    if not Camera then return nil end
    local screenCenter = lockFOVToCenter and 
        Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or 
        UserInputService:GetMouseLocation()
    
    for _, targetData in ipairs(allTargets) do
        local aimPartInstance = targetData.aimPart
        if aimPartInstance then
            local screenPos, onScreen = Camera:WorldToViewportPoint(aimPartInstance.Position)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                if distance < fovRadius and distance < closestDistance and isVisible(aimPartInstance) then
                    closestDistance = distance
                    closestTarget = targetData
                end
            end
        end
    end
    return closestTarget
end

function createFOVCircle()
    if AimbotCircle then 
        AimbotCircle:Remove() 
        AimbotCircle = nil
    end
    if not ShowFOV then return end
    local Camera = workspace.CurrentCamera
    if not Camera then return end
    local circle = Drawing.new("Circle")
    circle.Visible = ShowFOV
    circle.Radius = fovRadius
    circle.Color = FOVColor
    circle.Thickness = FOVThickness
    circle.Filled = false
    circle.NumSides = 60
    if lockFOVToCenter then
        local viewportSize = Camera.ViewportSize
        circle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    else
        circle.Position = UserInputService:GetMouseLocation()
    end
    AimbotCircle = circle
    if aimbotRenderConnection then
        aimbotRenderConnection:Disconnect()
    end
    aimbotRenderConnection = RunService.RenderStepped:Connect(function()
        local Camera = workspace.CurrentCamera
        if AimbotCircle and ShowFOV and Camera then
            if lockFOVToCenter then
                local viewportSize = Camera.ViewportSize
                AimbotCircle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
            else
                AimbotCircle.Position = UserInputService:GetMouseLocation()
            end
        end
    end)
end

function updateFOVCircle()
    if AimbotCircle then
        AimbotCircle.Radius = fovRadius
        AimbotCircle.Color = FOVColor
        AimbotCircle.Thickness = FOVThickness
        AimbotCircle.Visible = ShowFOV
    elseif ShowFOV then
        createFOVCircle()
    end
end

function setupCameraLock()
    if cameraInputModule then return true end
    
    local success = false
    
    pcall(function()
        local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
        if not playerScripts then return end
        local playerModule = playerScripts:FindFirstChild("PlayerModule")
        if not playerModule then return end
        local cameraModule = playerModule:FindFirstChild("CameraModule")
        if cameraModule then
            local cameraInput = cameraModule:FindFirstChild("CameraInput")
            if cameraInput then
                cameraInputModule = require(cameraInput)
                if cameraInputModule and cameraInputModule.getRotation then
                    local originalGetRotation = cameraInputModule.getRotation
                    cameraInputModule.getRotation = function(disableRotation)
                        if cameraLockEnabled and lockedTarget and lockedTarget.aimPart then
                            local camera = workspace.CurrentCamera
                            if camera then
                                local targetPos = lockedTarget.aimPart.Position
                                local lookVector = (targetPos - camera.CFrame.Position).Unit
                                local targetCFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + lookVector)
                                local smoothFactor = math.clamp(1 - (smoothnessValue / 100), 0.001, 1)
                                camera.CFrame = camera.CFrame:Lerp(targetCFrame, smoothFactor)
                            end
                        end
                        
                        local rotation = originalGetRotation(disableRotation)
                        return rotation
                    end
                    success = true
                end
            end
        end
    end)
    
    return success
end

function startAimbot()
    if aimbotRunning then return end
    createFOVCircle()
    aimbotRunning = true
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not AimbotEnabled or not aimbotRunning then
            return
        end
        local Camera = workspace.CurrentCamera
        if not Camera then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            return
        end
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            return
        end
        local closestTarget = getClosestEnemyInFOV()
        if closestTarget and closestTarget.aimPart then
            if not cameraLockEnabled or lockedTarget ~= closestTarget then
                cameraLockEnabled = true
                lockedTarget = closestTarget
                if not cameraInputModule then
                    setupCameraLock()
                end
            end
        else
            cameraLockEnabled = false
            lockedTarget = nil
        end
    end)
end

function stopAimbot()
    aimbotRunning = false
    cameraLockEnabled = false
    lockedTarget = nil
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    if AimbotCircle then
        AimbotCircle:Remove()
        AimbotCircle = nil
    end
    if aimbotRenderConnection then
        aimbotRenderConnection:Disconnect()
        aimbotRenderConnection = nil
    end
    if cameraLockConnection then
        cameraLockConnection:Disconnect()
        cameraLockConnection = nil
    end
end

Tabs.Combat:Section({ Title = "Aimbot" })

AimbotToggle = Tabs.Combat:Toggle({
    Title = "Aimbot",
    Flag = "AimbotToggle",
    Value = false,
    Callback = function(state)
        AimbotEnabled = state
        if state then
            startAimbot()
        else
            stopAimbot()
        end
    end
})

AimPartDropdown = Tabs.Combat:Dropdown({
    Title = "Aim Part",
    Flag = "AimPartDropdown",
    Values = { "Head", "Body", "Legs" },
    Value = "Head",
    Callback = function(value)
        aimPart = value
    end
})

local roleValues = getRoleListValues()

TargetTypeDropdown = Tabs.Combat:Dropdown({
    Title = "Target Roles",
    Flag = "TargetTypeDropdown",
    Values = roleValues,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        targetTypes = values
    end
})

AimLockTypeDropdown = Tabs.Combat:Dropdown({
    Title = "Aim Lock Type",
    Flag = "AimLockTypeDropdown",
    Values = { "Realistic", "Stimulate" },
    Value = "Realistic",
    Callback = function(value)
        aimLockType = value
    end
})

SmoothnessSlider = Tabs.Combat:Slider({
    Title = "Smoothness",
    Flag = "SmoothnessSlider",
    Step = 0.01,
    Value = { Min = 0.01, Max = 100, Default = 10 },
    Callback = function(value)
        smoothnessValue = value
    end
})

MaxDistanceInput = Tabs.Combat:Input({
    Title = "Max Distance",
    Value = "99999999999",
    Placeholder = "Enter max distance",
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue then
            maxDistance = numValue
        end
    end
})

WallCheckToggle = Tabs.Combat:Toggle({
    Title = "Wall Check",
    Flag = "WallCheckToggle",
    Value = false,
    Callback = function(state)
        wallCheckEnabled = state
    end
})

Tabs.Combat:Section({ Title = "FOV Settings" })

ShowFOVToggle = Tabs.Combat:Toggle({
    Title = "Show FOV Circle",
    Flag = "ShowFOVToggle",
    Value = false,
    Callback = function(state)
        ShowFOV = state
        updateFOVCircle()
    end
})

LockFOVToggle = Tabs.Combat:Toggle({
    Title = "Lock FOV On Middle Screen",
    Flag = "LockFOVToggle",
    Value = true,
    Callback = function(state)
        lockFOVToCenter = state
        updateFOVCircle()
    end
})

FOVRadiusSlider = Tabs.Combat:Slider({
    Title = "FOV Radius",
    Flag = "FOVRadiusSlider",
    Value = { Min = 10, Max = 500, Default = 100, Step = 5 },
    Callback = function(value)
        fovRadius = value
        updateFOVCircle()
    end
})

FOVColorPicker = Tabs.Combat:Colorpicker({
    Title = "FOV Color",
    Flag = "FOVColorPicker",
    Default = Color3.fromRGB(0, 255, 0),
    Locked = false,
    Callback = function(color)
        FOVColor = color
        updateFOVCircle()
    end
})

FOVThicknessSlider = Tabs.Combat:Slider({
    Title = "FOV Thickness",
    Flag = "FOVThicknessSlider",
    Value = { Min = 1, Max = 10, Default = 2, Step = 1 },
    Callback = function(value)
        FOVThickness = value
        updateFOVCircle()
    end
})
Tabs.Combat:Section({ Title = "Gun Combat", TextSize = 20 })
Tabs.Combat:Divider()

Tabs.Combat:Section({ Title = "Gun Combat", TextSize = 20 })
Tabs.Combat:Divider()

local autoShootEnabled = false
local shootOffset = 0
local pingMultiplier = 0
local wallCheckEnabled = false
local magicBulletSideOffset = 5

function IsMurdererBehindWall(murdererCharacter)
    if not wallCheckEnabled then return false end

    local camera = workspace.CurrentCamera
    if not camera then return false end

    local character = LocalPlayer.Character
    if not character then return true end

    local cameraPos = camera.CFrame.Position

    local targetPart = murdererCharacter:FindFirstChild("HumanoidRootPart") or 
                       murdererCharacter:FindFirstChild("Head") or
                       murdererCharacter:FindFirstChild("UpperTorso") or
                       murdererCharacter:FindFirstChild("Torso")

    if not targetPart then return true end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character, murdererCharacter, camera}

    local rayResult = workspace:Raycast(cameraPos, (targetPart.Position - cameraPos), raycastParams)

    if rayResult then
        local hit = rayResult.Instance
        if hit and hit:IsA("BasePart") then
            local isWindow = hit.Name:lower():find("window") or 
                             hit.Name:lower():find("glass") or
                             hit.Material == Enum.Material.Glass

            if not isWindow and not hit:IsDescendantOf(character) and not hit:IsDescendantOf(murdererCharacter) then
                return true
            end
        end
    end

    return false
end

local MagicBulletEnabled = false

function ShootMurderer()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer.Character.Humanoid.Health <= 0 then
        return false
    end
    local murderer = GetMurderer()
    if not murderer or not murderer.Character or not murderer.Character:FindFirstChild("Humanoid") or murderer.Character.Humanoid.Health <= 0 then
        return false
    end
    if not MagicBulletEnabled then
        if IsMurdererBehindWall(murderer.Character) then
            return false
        end
    end
    local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart") or 
                       murderer.Character:FindFirstChild("Head") or
                       murderer.Character:FindFirstChild("UpperTorso") or
                       murderer.Character:FindFirstChild("Torso")
    if not targetPart then
        return false
    end
    local targetPos = targetPart.Position
    
    local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
    if not gun then
        return false
    end
    local shootEvent = gun:FindFirstChild("Shoot")
    if not shootEvent then
        return false
    end
    
    local character = LocalPlayer.Character
    local isGunEquipped = character:FindFirstChild("Gun") ~= nil
    local shootOrigin
    
    if isGunEquipped then
        local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildWhichIsA("Part")
        if handle then
            shootOrigin = handle.Position
        else
            local rightHand = character:FindFirstChild("RightHand")
            if rightHand then
                shootOrigin = rightHand.Position
            else
                shootOrigin = character:FindFirstChild("HumanoidRootPart").Position
            end
        end
    else
        local rightHand = character:FindFirstChild("RightHand")
        if rightHand then
            shootOrigin = rightHand.Position
        else
            shootOrigin = character:FindFirstChild("HumanoidRootPart").Position
        end
    end
    
    local lookAtCFrame
    local targetCFrame = CFrame.new(targetPos)
    
    if MagicBulletEnabled then
        local rightDirection = CFrame.new(shootOrigin, targetPos).RightVector
        local sideOffset = magicBulletSideOffset
        local sidePos = targetPos + (rightDirection * sideOffset)
        local lookDirection = (targetPos - sidePos).Unit
        lookAtCFrame = CFrame.new(sidePos, sidePos + lookDirection)
    else
        local gunCFrame = CFrame.new(shootOrigin, targetPos)
        lookAtCFrame = gunCFrame
    end
    
    shootEvent:FireServer(lookAtCFrame, targetCFrame)
    return true
end

function startAutoShoot()
    while autoShootEnabled do
        ShootMurderer()
        task.wait(0.1)
    end
end

Tabs.Combat:Toggle({
    Title = "Auto Shoot Murderer",
    Flag = "AutoShoot",
    Value = false,
    Callback = function(state)
        autoShootEnabled = state
        if state then
            task.spawn(startAutoShoot)
        end
    end
})

Tabs.Combat:Toggle({
    Title = "Magic Bullet",
    Flag = "MagicBullet",
    Desc = "Allow Shoot through walls (70% work)",
    Value = false,
    Callback = function(state)
        MagicBulletEnabled = state
        if state then
            if ButtonLib and ButtonLib.SheriffBtn then
                ButtonLib.SheriffBtn:SetText("MAGIC BULLET SHOOT")
            end
            if manualShootMurd then
                manualShootMurd:SetTitle("MAGIC BULLET BUTTON")
            end
            if ShootKeybind then
                ShootKeybind:SetTitle("MAGIC BULLET KEY")
            end
        else
            if ButtonLib and ButtonLib.SheriffBtn then
                ButtonLib.SheriffBtn:SetText("Shoot Murderer")
            end
            if manualShootMurd then
                manualShootMurd:SetTitle("Shoot Murderer")
            end
            if ShootKeybind then
                ShootKeybind:SetTitle("Shoot Murderer Keybind")
            end
        end
    end
})

Tabs.Combat:Toggle({
    Title = "Wall Check (Prevent shooting through walls)",
    Flag = "ShootWallCheck",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        wallCheckEnabled = state
    end
})

Tabs.Combat:Input({
    Title = "Magic Bullet SideOffset",
    Flag = "MagicBulletSideOffset",
    Placeholder = "5",
    Value = "5",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            magicBulletSideOffset = num
        end
    end
})

Tabs.Combat:Input({
    Title = "Shoot Position Offset",
    Flag = "ShootPositionOffset",
    Placeholder = "0",
    Value = "0",
    Callback = function(text)
        shootOffset = tonumber(text) or 0
    end
})

Tabs.Combat:Input({
    Title = "Offset-to-Ping Multiplier",
    Flag = "Offset-to-PingMultiplier",
    Placeholder = "0",
    Value = "0",
    Callback = function(text)
        pingMultiplier = tonumber(text) or 1
    end
})

manualShootMurd = Tabs.Combat:Button({
    Title = "Shoot Murderer",
    Callback = function()
        ShootMurderer()
    end
})

ShootKeybind = Tabs.Combat:Keybind({
    Title = "Shoot Murderer Keybind",
    Value = "E",
    Callback = function(key)
        local keyCode = Enum.KeyCode[key]
        if keyCode then
            local connection
            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == keyCode then
                    ShootMurderer()
                end
            end)

            return function()
                if connection then
                    connection:Disconnect()
                end
            end
        end
    end
})

Tabs.Combat:Button({
    Title = "Toggle Shoot Button",
    Desc = "Show/Hide Shoot button",
    Callback = function()
        SheriffBtnVisible = not SheriffBtnVisible
        ButtonLib.SheriffBtn:SetVisible(SheriffBtnVisible)
    end
})

ButtonLib.Create:Button({
    Text = "Shoot Murder",
    Flag = "SheriffBtn",
    Visible = false,
    Callback = function() ShootMurderer() end
}).Position = UDim2.new(0.5, -125, 0.2, 0)
local GunSystem = {
    AutoGrabEnabled = false,
    NotifyGun = false,
    GunDropCheckInterval = 1,
    ActiveGunDrops = {},
    Mode = "Grab only"
}

local notifiedGunPickups = {}
local notifiedGunSpawns = {}

function GunTP()
    local gunDrop = nil

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and obj:IsA("BasePart") then
            gunDrop = obj
            break
        end
    end

    if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(gunDrop.Position + Vector3.new(0, 3, 0))
    end
end

function ScanForGunDrops()
    GunSystem.ActiveGunDrops = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and obj:IsA("BasePart") then
            table.insert(GunSystem.ActiveGunDrops, obj)
        end
    end
end

function safeTeleport(cframe)
    pcall(function()
        if Character and HumanoidRootPart then
            HumanoidRootPart.CFrame = cframe
        end
    end)
end

function hasKnife()
    return LocalPlayer.Backpack:FindFirstChild("Knife") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife"))
end

function collectAllGunDrops()
    if hasKnife() then
        WindUI:Notify({Title = "Gun System", Content = "You already have a knife!", Icon = "x-circle", Duration = 3})
        return
    end

    local currentPosition = HumanoidRootPart.Position
    ScanForGunDrops()

    if #GunSystem.ActiveGunDrops == 0 then
        WindUI:Notify({Title = "Gun System", Content = "No guns available on the map", Icon = "x-circle", Duration = 3})
        return
    end

    for _, gunDrop in ipairs(GunSystem.ActiveGunDrops) do
        if gunDrop and gunDrop.Parent then
            safeTeleport(gunDrop.CFrame + Vector3.new(0, 3, 0))
            task.wait(0.05)
            safeTeleport(CFrame.new(currentPosition))
            task.wait(0.05)
        end
    end

    WindUI:Notify({Title = "Gun System", Content = "Successfully collected all guns!", Icon = "check-circle", Duration = 3})
end

function ManualGrab()
    if IsPlayerDead() then
        WindUI:Notify({Title = "Gun System", Content = "You are dead! Cannot grab gun.", Icon = "skull", Duration = 3})
        return false
    end

    if hasKnife() then
        WindUI:Notify({Title = "Gun System", Content = "You already have a knife!", Icon = "x-circle", Duration = 3})
        return false
    end

    if GunSystem.Mode == "Grab only" then
        collectAllGunDrops()
        return true
    elseif GunSystem.Mode == "Grab & shoot murderer" then
        local gunDrop = nil
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                gunDrop = obj
                break
            end
        end

        if not gunDrop then
            WindUI:Notify({Title = "Gun System", Content = "No guns available on the map", Icon = "x-circle", Duration = 3})
            return false
        end

        local nearestGun = nil
        local minDistance = math.huge
        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                    local distance = (humanoidRootPart.Position - obj.Position).Magnitude
                    if distance < minDistance then
                        nearestGun = obj
                        minDistance = distance
                    end
                end
            end
        end

        if nearestGun and LocalPlayer.Character then
            if IsPlayerDead() then
                WindUI:Notify({Title = "Gun System", Content = "You are dead! Cannot grab gun.", Icon = "skull", Duration = 3})
                return false
            end

            local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = nearestGun.CFrame
                task.wait(0.3)

                if IsPlayerDead() then
                    WindUI:Notify({Title = "Gun System", Content = "You died while trying to grab the gun!", Icon = "skull", Duration = 3})
                    return false
                end

                local prompt = nearestGun:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                    WindUI:Notify({Title = "Gun System", Content = "Successfully grabbed the gun!", Icon = "check-circle", Duration = 3})
                    task.wait(0.5)
                    ShootMurderer()
                    return true
                end
            end
        end
        return false
    end
end

function ImprovedGrabOnly()
    local isTeleporting = false
    local teleportDelay = 0.5

    function teleportLoop()
        if isTeleporting then return end

        if IsPlayerDead() then
            return
        end

        if hasKnife() then return end

        local character = LocalPlayer.Character
        if not character then return end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        isTeleporting = true

        local currentPosition = humanoidRootPart.Position
        ScanForGunDrops()

        if #GunSystem.ActiveGunDrops == 0 then
            isTeleporting = false
            return
        end

        for _, gunDrop in ipairs(GunSystem.ActiveGunDrops) do
            if IsPlayerDead() then
                break
            end

            if gunDrop and gunDrop.Parent then
                safeTeleport(gunDrop.CFrame + Vector3.new(0, 3, 0))
                task.wait(0.05)
                safeTeleport(CFrame.new(currentPosition))
                task.wait(0.05)
            end
        end

        isTeleporting = false
    end

    while GunSystem.AutoGrabEnabled and GunSystem.Mode == "Grab only" do
        if not IsPlayerDead() and not hasKnife() then
            teleportLoop()
        end
        task.wait(teleportDelay)
    end
end

function AutoGrabGun()
    while GunSystem.AutoGrabEnabled do
        if IsPlayerDead() then
            task.wait(GunSystem.GunDropCheckInterval)
        elseif hasKnife() then
            task.wait(GunSystem.GunDropCheckInterval)
        else
            if GunSystem.Mode == "Grab only" then
                ImprovedGrabOnly()
            elseif GunSystem.Mode == "Grab & shoot murderer" then
                ScanForGunDrops()
                if #GunSystem.ActiveGunDrops > 0 then
                    if not IsPlayerDead() then
                        local character = LocalPlayer.Character
                        if character then
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            if humanoidRootPart then
                                local nearestGun = nil
                                local minDistance = math.huge
                                for _, gunDrop in ipairs(GunSystem.ActiveGunDrops) do
                                    local distance = (humanoidRootPart.Position - gunDrop.Position).Magnitude
                                    if distance < minDistance then
                                        nearestGun = gunDrop
                                        minDistance = distance
                                    end
                                end
                                if nearestGun then
                                    humanoidRootPart.CFrame = nearestGun.CFrame
                                    task.wait(0.3)

                                    if not IsPlayerDead() then
                                        local prompt = nearestGun:FindFirstChildOfClass("ProximityPrompt")
                                        if prompt then
                                            fireproximityprompt(prompt)
                                            task.wait(0.5)
                                            ShootMurderer()
                                            task.wait(1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(GunSystem.GunDropCheckInterval)
            end
        end
    end
end

function monitorGunEvents()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer then
            otherPlayer.CharacterAdded:Connect(function(character)
                character.ChildAdded:Connect(function(child)
                    if child.Name == "Gun" and GunSystem.NotifyGun then
                        if not notifiedGunPickups[otherPlayer.Name] then
                            WindUI:Notify({
                                Title = "Gun System", 
                                Content = otherPlayer.Name .. " took the gun!", 
                                Icon = "alert-circle", 
                                Duration = 5
                            })
                            notifiedGunPickups[otherPlayer.Name] = true
                        end
                    end
                end)
            end)

            if otherPlayer.Character then
                otherPlayer.Character.ChildAdded:Connect(function(child)
                    if child.Name == "Gun" and GunSystem.NotifyGun then
                        if not notifiedGunPickups[otherPlayer.Name] then
                            WindUI:Notify({
                                Title = "Gun System", 
                                Content = otherPlayer.Name .. " took the gun!", 
                                Icon = "alert-circle", 
                                Duration = 5
                            })
                            notifiedGunPickups[otherPlayer.Name] = true
                        end
                    end
                end)
            end
        end
    end

    workspace.DescendantAdded:Connect(function(child)
        if child.Name == "GunDrop" and child:IsA("BasePart") and GunSystem.NotifyGun then
            if not notifiedGunSpawns[child] then
                WindUI:Notify({
                    Title = "Gun System", 
                    Content = "A gun has spawned!", 
                    Icon = "target", 
                    Duration = 5
                })
                notifiedGunSpawns[child] = true
            end
        end
    end)
end

function resetGunNotifications()
    workspace.DescendantAdded:Connect(function(child)
        if child.Name == "GunDrop" and child:IsA("BasePart") then
            for playerName, _ in pairs(notifiedGunPickups) do
                notifiedGunPickups[playerName] = nil
            end
            notifiedGunSpawns[child] = nil
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(newChar)
    setupCharacter(newChar)
end)

Tabs.Combat:Toggle({
    Title = "Auto Grab Gun",
    Desc = "Auto Steal Gun by teleport",
    Flag = "TPStealGun",
    Value = false,
    Callback = function(state)
        GunSystem.AutoGrabEnabled = state
        if state then
            coroutine.wrap(AutoGrabGun)()
        end
    end
})

local GunAuraEnabled = false
local GunAuraConnection = nil

local function touch(a, b)
    firetouchinterest(a, b, 0)
    firetouchinterest(a, b, 1)
end

local function BringGun()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local gunDrop = workspace:FindFirstChild("GunDrop", true)

    if rootPart and gunDrop then
        touch(rootPart, gunDrop)
    end
end

Tabs.Combat:Toggle({
    Title = "Gun Aura",
    Flag = "TouchInstantFireGun",
    Desc = "Auto Steal Gun without teleport",
    Value = false,
    Callback = function(state)
        GunAuraEnabled = state
        if state then
            GunAuraConnection = RunService.Heartbeat:Connect(function()
                if GunAuraEnabled then
                    BringGun()
                end
            end)
        else
            if GunAuraConnection then
                GunAuraConnection:Disconnect()
                GunAuraConnection = nil
            end
        end
    end
})

Tabs.Combat:Button({
    Title = "Manual Grab Gun",
    Callback = function()
        ManualGrab()
    end
})

Tabs.Combat:Dropdown({
    Title = "Auto Grab Mode",
    Values = {"Grab only", "Grab & shoot murderer"},
    Value = "Grab only",
    Callback = function(value)
        GunSystem.Mode = value
    end
})

Tabs.Combat:Toggle({
    Title = "Notify Gun",
    Value = false,
    Flag = "NotifyGunDrop",
    Callback = function(state)
        GunSystem.NotifyGun = state
    end
})

task.spawn(function()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    ScanForGunDrops()
    if GunSystem.AutoGrabEnabled then
        coroutine.wrap(AutoGrabGun)()
    end
    monitorGunEvents()
    resetGunNotifications()
end)

Tabs.Combat:Section({ Title = "Knife Combat", TextSize = 20 })
Tabs.Combat:Divider()

KnifeCombat = {
    killMode = "Kill Aura",
    killAuraRadius = 10,
    autoKillEnabled = false,
    showAuraCircle = false,
    autoEquipKnife = false,
    killConnection = nil,
    auraConnection = nil,
    equipConnection = nil,
    anchoredPlayers = {},
    auraCircle = nil,
    autoThrowKnife = false,
    throwKnifeConnection = nil,
    wallCheckType = {"None"},
    StabReach = {
        Enabled = false,
        Radius = 10,
        Connection = nil,
        KnifeAddedConnection = nil
    },
    HitboxConfig = {
        Enabled = false,
        Radius = 10,
        MultipleTargets = false
    },
    hitboxHeartbeatConnection = nil,
    hitboxDescendantConnection = nil,
    lastHitboxCheck = 0,
    hitboxCheckCooldown = 0.1
}

function KnifeCombat.getPlayerRole(plr)
    return GetPlayerRole(plr.Name)
end

function KnifeCombat.isTargetVisible(targetPart)
    if not table.find(KnifeCombat.wallCheckType, "Manual Throw Knife") and 
       not table.find(KnifeCombat.wallCheckType, "Auto Throw Knife") then
        return true
    end

    local localCharacter = LocalPlayer.Character
    if not localCharacter then return false end

    local localHead = localCharacter:FindFirstChild("Head")
    local targetHead = targetPart.Parent:FindFirstChild("Head")

    if not localHead or not targetHead then return false end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localCharacter, targetPart.Parent}

    local direction = (targetHead.Position - localHead.Position)
    local raycastResult = workspace:Raycast(localHead.Position, direction, raycastParams)

    return raycastResult == nil
end

function KnifeCombat.getBestTarget()
    local localCharacter = LocalPlayer.Character
    if not localCharacter then return nil end

    local localRoot = localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end

    local bestTarget = nil
    local bestDistance = math.huge
    local sheriffHeroTarget = nil
    local sheriffHeroDistance = math.huge

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer and targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")

            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (targetRoot.Position - localRoot.Position).Magnitude
                local role = KnifeCombat.getPlayerRole(targetPlayer)

                if role == "Sheriff" or role == "Hero" then
                    if distance < sheriffHeroDistance then
                        sheriffHeroTarget = targetPlayer
                        sheriffHeroDistance = distance
                    end
                elseif role == "Innocent" or role == nil then
                    if distance < bestDistance then
                        bestTarget = targetPlayer
                        bestDistance = distance
                    end
                end
            end
        end
    end

    local finalTarget = nil
    if sheriffHeroTarget and sheriffHeroDistance < 100 then
        finalTarget = sheriffHeroTarget
    else
        finalTarget = bestTarget
    end

    if finalTarget and finalTarget.Character then
        local targetRoot = finalTarget.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local needsManualWallCheck = table.find(KnifeCombat.wallCheckType, "Manual Throw Knife")
            local needsAutoWallCheck = table.find(KnifeCombat.wallCheckType, "Auto Throw Knife")

            if (needsManualWallCheck or needsAutoWallCheck) and not KnifeCombat.isTargetVisible(targetRoot) then
                return nil
            end
        end
    end

    return finalTarget
end

function KnifeCombat.GetKnife()
    local char = LocalPlayer.Character
    if not char then return nil end

    local knife = char:FindFirstChild("Knife")
    if knife then return knife end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        knife = backpack:FindFirstChild("Knife")
    end

    return knife
end

function KnifeCombat.GetMurderer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife")) then
            return plr
        end
    end
    return nil
end

function KnifeCombat.getKnifeRemotes()
    local knife = KnifeCombat.GetKnife()
    local events = nil
    local remotes = {}

    if not knife then
        knife = workspace:FindFirstChild("Knife") or ReplicatedStorage:FindFirstChild("Knife")
    end

    if not knife then
        local knives = ReplicatedStorage:FindFirstChild("Knives")
        if knives then
            knife = knives:FindFirstChild("Knife")
        end
    end

    if knife then
        events = knife:FindFirstChild("Events")
    end

    if not events then
        local function findKnifeRemotes(obj)
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("RemoteEvent") and (child.Name:find("Knife") or child.Name:find("Stab") or child.Name:find("Throw")) then
                    table.insert(remotes, child)
                end
                findKnifeRemotes(child)
            end
        end
        findKnifeRemotes(ReplicatedStorage)
        findKnifeRemotes(workspace)
    else
        for _, child in pairs(events:GetChildren()) do
            if child:IsA("RemoteEvent") then
                table.insert(remotes, child)
            end
        end
    end

    return remotes
end

function KnifeCombat.attackPlayer(targetChar)
    if not targetChar then return end
    local humanoid = targetChar:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    local remotes = KnifeCombat.getKnifeRemotes()
    if #remotes == 0 then return end

    for _, remote in pairs(remotes) do
        pcall(function()
            if remote.Name == "KnifeStabbed" then
                remote:FireServer()
            elseif remote.Name == "HandleTouched" then
                local part = targetChar:FindFirstChild("Head") or 
                             targetChar:FindFirstChild("HumanoidRootPart") or
                             targetChar:FindFirstChild("Torso")
                if part then
                    remote:FireServer(part)
                end
            elseif remote.Name == "KnifeThrown" then
                local targetPos = targetChar.PrimaryPart and targetChar.PrimaryPart.Position or 
                                  (targetChar:FindFirstChild("HumanoidRootPart") and targetChar.HumanoidRootPart.Position)
                if targetPos then
                    local fakeHandle = Instance.new("Part")
                    fakeHandle.Name = "Handle"
                    fakeHandle.CFrame = CFrame.new(0, 9999, 0)
                    fakeHandle.Parent = workspace
                    fakeHandle.Transparency = 1
                    game:GetService("Debris"):AddItem(fakeHandle, 1)
                    remote:FireServer(fakeHandle.CFrame, targetPos)
                end
            else
                remote:FireServer()
                remote:FireServer(targetChar)
                remote:FireServer(humanoid)
            end
        end)
    end
end

function KnifeCombat.stabReachAttack()
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer.Character and targetPlayer ~= LocalPlayer then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Torso")
            if targetRoot then
                local distance = (targetRoot.Position - localRoot.Position).Magnitude
                if distance <= KnifeCombat.StabReach.Radius then
                    KnifeCombat.attackPlayer(targetPlayer.Character)
                end
            end
        end
    end
end

function KnifeCombat.connectKnifeActivated(knife)
    if not knife then return end

    if KnifeCombat.StabReach.Connection then
        KnifeCombat.StabReach.Connection:Disconnect()
    end

    KnifeCombat.StabReach.Connection = knife.Activated:Connect(function()
        if KnifeCombat.StabReach.Enabled and KnifeCombat.GetMurderer() == LocalPlayer then
            KnifeCombat.stabReachAttack()
        end
    end)
end

function KnifeCombat.startStabReach()
    KnifeCombat.stopStabReach()

    local knife = KnifeCombat.GetKnife()
    if knife then
        KnifeCombat.connectKnifeActivated(knife)
    end

    if KnifeCombat.StabReach.KnifeAddedConnection then
        KnifeCombat.StabReach.KnifeAddedConnection:Disconnect()
    end

    KnifeCombat.StabReach.KnifeAddedConnection = LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        char.ChildAdded:Connect(function(child)
            if child.Name == "Knife" and KnifeCombat.StabReach.Enabled then
                task.wait(0.1)
                KnifeCombat.connectKnifeActivated(child)
            end
        end)

        if LocalPlayer.Backpack then
            LocalPlayer.Backpack.ChildAdded:Connect(function(child)
                if child.Name == "Knife" and KnifeCombat.StabReach.Enabled then
                    task.wait(0.1)
                    KnifeCombat.connectKnifeActivated(child)
                end
            end)
        end
    end)

    if LocalPlayer.Character then
        LocalPlayer.Character.ChildAdded:Connect(function(child)
            if child.Name == "Knife" and KnifeCombat.StabReach.Enabled then
                task.wait(0.1)
                KnifeCombat.connectKnifeActivated(child)
            end
        end)
    end

    if LocalPlayer.Backpack then
        LocalPlayer.Backpack.ChildAdded:Connect(function(child)
            if child.Name == "Knife" and KnifeCombat.StabReach.Enabled then
                task.wait(0.1)
                KnifeCombat.connectKnifeActivated(child)
            end
        end)
    end
end

function KnifeCombat.stopStabReach()
    if KnifeCombat.StabReach.Connection then
        KnifeCombat.StabReach.Connection:Disconnect()
        KnifeCombat.StabReach.Connection = nil
    end
    if KnifeCombat.StabReach.KnifeAddedConnection then
        KnifeCombat.StabReach.KnifeAddedConnection:Disconnect()
        KnifeCombat.StabReach.KnifeAddedConnection = nil
    end
end

function KnifeCombat.throwKnife()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or 
       LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
        return false
    end

    local knife = LocalPlayer.Character:FindFirstChild("Knife")
    if not knife then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            knife = backpack:FindFirstChild("Knife")
            if knife then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(knife)
                end
                task.wait(0.2)
            end
        end
    end

    if not knife then return false end

    local eventsFolder = knife:FindFirstChild("Events")
    if not eventsFolder then return false end

    local throwEvent = eventsFolder:FindFirstChild("KnifeThrown")
    if not throwEvent then return false end

    local targetPlayer = KnifeCombat.getBestTarget()
    if not targetPlayer or not targetPlayer.Character then return false end

    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or 
                       targetPlayer.Character:FindFirstChild("Head") or
                       targetPlayer.Character:FindFirstChild("UpperTorso") or
                       targetPlayer.Character:FindFirstChild("Torso")
    if not targetRoot then return false end

    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return false end

    local targetPos = targetRoot.Position
    local distance = (targetPos - localRoot.Position).Magnitude
    local pitchAngle = math.clamp(distance / 50, 10, 45)

    local startCFrame = localRoot.CFrame * CFrame.new(0, 1.5, -2) * CFrame.Angles(math.rad(-pitchAngle), 0, 0)
    local targetCFrame = CFrame.new(targetPos + Vector3.new(0, 1.5, 0))

    throwEvent:FireServer(startCFrame, targetCFrame)
    return true
end

function KnifeCombat.killAura()
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer.Character and targetPlayer ~= LocalPlayer then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Torso")
            if targetRoot then
                local distance = (targetRoot.Position - localRoot.Position).Magnitude
                if distance <= KnifeCombat.killAuraRadius then
                    KnifeCombat.attackPlayer(targetPlayer.Character)
                end
            end
        end
    end
end

function KnifeCombat.killNearby()
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer.Character and targetPlayer ~= LocalPlayer then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Torso")
            if targetRoot then
                local distance = (targetRoot.Position - localRoot.Position).Magnitude
                if distance <= 5 then
                    KnifeCombat.attackPlayer(targetPlayer.Character)
                end
            end
        end
    end
end

function KnifeCombat.killAll()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer.Character and targetPlayer ~= LocalPlayer then
            KnifeCombat.attackPlayer(targetPlayer.Character)
        end
    end
end

function KnifeCombat.startAutoThrow()
    if KnifeCombat.throwKnifeConnection then
        KnifeCombat.throwKnifeConnection:Disconnect()
    end

    KnifeCombat.throwKnifeConnection = RunService.Heartbeat:Connect(function()
        if KnifeCombat.autoThrowKnife and KnifeCombat.GetMurderer() == LocalPlayer then
            local success = KnifeCombat.throwKnife()
            if success then
                task.wait(1)
            end
        end
    end)
end

function KnifeCombat.stopAutoThrow()
    if KnifeCombat.throwKnifeConnection then
        KnifeCombat.throwKnifeConnection:Disconnect()
        KnifeCombat.throwKnifeConnection = nil
    end
end

function KnifeCombat.startAutoKill()
    if KnifeCombat.killConnection then return end

    KnifeCombat.killConnection = RunService.Heartbeat:Connect(function()
        if KnifeCombat.autoKillEnabled and KnifeCombat.GetMurderer() == LocalPlayer then
            if KnifeCombat.killMode == "Kill Aura" then
                KnifeCombat.killAura()
            elseif KnifeCombat.killMode == "Kill Nearby" then
                KnifeCombat.killNearby()
            elseif KnifeCombat.killMode == "Kill All" then
                KnifeCombat.killAll()
            end
        end
    end)
end

function KnifeCombat.stopAutoKill()
    if KnifeCombat.killConnection then
        KnifeCombat.killConnection:Disconnect()
        KnifeCombat.killConnection = nil
    end
end

function KnifeCombat.updateAuraCircle()
    if KnifeCombat.auraCircle and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            KnifeCombat.auraCircle.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(90))
        end
    end
end

function KnifeCombat.createAuraCircle()
    if KnifeCombat.auraCircle then
        KnifeCombat.auraCircle:Destroy()
        KnifeCombat.auraCircle = nil
    end

    if KnifeCombat.showAuraCircle and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            KnifeCombat.auraCircle = Instance.new("Part")
            KnifeCombat.auraCircle.Name = "AuraRange"
            KnifeCombat.auraCircle.Shape = Enum.PartType.Cylinder
            KnifeCombat.auraCircle.Material = Enum.Material.Neon
            KnifeCombat.auraCircle.BrickColor = BrickColor.new("Bright red")
            KnifeCombat.auraCircle.Transparency = 0.7
            KnifeCombat.auraCircle.Anchored = true
            KnifeCombat.auraCircle.CanCollide = false
            KnifeCombat.auraCircle.Size = Vector3.new(1, KnifeCombat.killAuraRadius * 2, KnifeCombat.killAuraRadius * 2)
            KnifeCombat.auraCircle.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(90))
            KnifeCombat.auraCircle.Parent = workspace

            if KnifeCombat.auraConnection then
                KnifeCombat.auraConnection:Disconnect()
            end

            KnifeCombat.auraConnection = RunService.Heartbeat:Connect(function()
                KnifeCombat.updateAuraCircle()
            end)
        end
    else
        if KnifeCombat.auraConnection then
            KnifeCombat.auraConnection:Disconnect()
            KnifeCombat.auraConnection = nil
        end
    end
end

function KnifeCombat.checkNearbyPlayer()
    local Character = LocalPlayer.Character
    if not Character then return end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local localRoot = Character:FindFirstChild("HumanoidRootPart")
            if targetRoot and localRoot then
                if (targetRoot.Position - localRoot.Position).Magnitude <= KnifeCombat.killAuraRadius then
                    local knife = KnifeCombat.GetKnife()
                    if knife and knife.Parent ~= Character then
                        Humanoid:EquipTool(knife)
                    end
                    return
                end
            end
        end
    end
end

function KnifeCombat.KillTarget(targetRoot)
    local knife = KnifeCombat.GetKnife()
    if not knife then return end

    local events = knife:FindFirstChild("Events")
    if events then
        if events:FindFirstChild("KnifeStabbed") then
            events.KnifeStabbed:FireServer()
        end
        if events:FindFirstChild("HandleTouched") then
            events.HandleTouched:FireServer(targetRoot)
        end
    end
end

function KnifeCombat.GetClosestTarget(knifePosition, targets)
    local closest = nil
    local closestDist = math.huge

    for _, target in pairs(targets) do
        local distance = (knifePosition - target.Position).Magnitude
        if distance < closestDist then
            closestDist = distance
            closest = target
        end
    end

    return closest
end

function KnifeCombat.ProcessThrownKnife(knifePart)
    local radius = KnifeCombat.HitboxConfig.Radius
    local multiple = KnifeCombat.HitboxConfig.MultipleTargets

    local targets = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

            if rootPart and humanoid and humanoid.Health > 0 then
                local distance = (rootPart.Position - knifePart.Position).Magnitude
                if distance < radius then
                    table.insert(targets, rootPart)
                end
            end
        end
    end

    if #targets == 0 then return end

    if multiple then
        for _, target in pairs(targets) do
            KnifeCombat.KillTarget(target)
        end
    else
        local closest = KnifeCombat.GetClosestTarget(knifePart.Position, targets)
        if closest then
            KnifeCombat.KillTarget(closest)
        end
    end
end

function KnifeCombat.StartHitboxKnifeThrownLoop()
    KnifeCombat.StopHitboxKnifeThrownLoop()

    KnifeCombat.hitboxDescendantConnection = workspace.DescendantAdded:Connect(function(obj)
        local currentTime = tick()
        if currentTime - KnifeCombat.lastHitboxCheck < KnifeCombat.hitboxCheckCooldown then return end
        KnifeCombat.lastHitboxCheck = currentTime

        local knifePart = nil

        if obj.Name == "StuckKnife" and obj:IsA("BasePart") then
            knifePart = obj
        elseif obj.Name == "ThrowingKnife" then
            knifePart = obj:FindFirstChild("KnifeVisual") or obj:FindFirstChildWhichIsA("BasePart")
        elseif obj.Name == "KnifeStickWeld" and obj.Parent then
            knifePart = obj.Parent
        end

        if knifePart then
            KnifeCombat.ProcessThrownKnife(knifePart)
        end
    end)
end

function KnifeCombat.StopHitboxKnifeThrownLoop()
    if KnifeCombat.hitboxHeartbeatConnection then 
        KnifeCombat.hitboxHeartbeatConnection:Disconnect() 
        KnifeCombat.hitboxHeartbeatConnection = nil
    end
    if KnifeCombat.hitboxDescendantConnection then 
        KnifeCombat.hitboxDescendantConnection:Disconnect() 
        KnifeCombat.hitboxDescendantConnection = nil
    end
end

function KnifeCombat.EnableKnifeHitbox()
    if KnifeCombat.HitboxConfig.Enabled then return end
    KnifeCombat.HitboxConfig.Enabled = true
    KnifeCombat.lastHitboxCheck = 0
    KnifeCombat.StartHitboxKnifeThrownLoop()
end

function KnifeCombat.DisableKnifeHitbox()
    if not KnifeCombat.HitboxConfig.Enabled then return end
    KnifeCombat.HitboxConfig.Enabled = false
    KnifeCombat.StopHitboxKnifeThrownLoop()
end

Tabs.Combat:Section({ Title = "Stab Reach", TextSize = 16 })

Tabs.Combat:Toggle({
    Title = "Stab Reach",
    Desc = "Only work when you spam clicking",
    Flag = "StabReachToggle",
    Value = false,
    Callback = function(state)
        KnifeCombat.StabReach.Enabled = state
        if state then
            KnifeCombat.startStabReach()
        else
            KnifeCombat.stopStabReach()
        end
    end
})

Tabs.Combat:Slider({
    Title = "Stab Reach Range",
    Desc = "Range for stab reach",
    Value = { Min = 1, Max = 500, Default = 10, Step = 1 },
    Callback = function(value)
        KnifeCombat.StabReach.Radius = tonumber(value)
    end
})

Tabs.Combat:Section({ Title = "Thrown Knife", TextSize = 16 })

Tabs.Combat:Toggle({
    Title = "Auto Throw Knife",
    Desc = "Automatically throw knife at nearby players",
    Flag = "AutoThrown",
    Value = false,
    Callback = function(state)
        KnifeCombat.autoThrowKnife = state
        if state then
            if KnifeCombat.GetMurderer() == LocalPlayer then
                KnifeCombat.startAutoThrow()
            else
                KnifeCombat.autoThrowKnife = false
            end
        else
            KnifeCombat.stopAutoThrow()
        end
    end
})

Tabs.Combat:Button({
    Title = "Manual Throw Knife",
    Desc = "Throw knife at nearest player",
    Icon = "target",
    Callback = function()
        if KnifeCombat.GetMurderer() == LocalPlayer then
            KnifeCombat.throwKnife()
        end
    end
})

ButtonLib.Create:Button({
    Text = "THROW KNIFE",
    Flag = "ThrowKnifeBtn",
    Visible = false,
    Callback = function()
        if KnifeCombat.GetMurderer() == LocalPlayer then
            KnifeCombat.throwKnife()
        end
    end
}).Position = UDim2.new(0.5, -125, 0.3, 0)

Tabs.Combat:Button({
    Title = "Toggle Throw Knife Button",
    Desc = "Show/Hide throw knife button",
    Callback = function()
        ThrowKnifeBtnVisible = not ThrowKnifeBtnVisible
        ButtonLib.ThrowKnifeBtn:SetVisible(ThrowKnifeBtnVisible)
    end
})

Tabs.Combat:Keybind({
    Title = "Throw Knife Keybind",
    Desc = "Keybind to throw knife",
    Value = "T",
    Callback = function(key)
        local keyCode = Enum.KeyCode[key]
        if keyCode then
            local connection
            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == keyCode then
                    if KnifeCombat.GetMurderer() == LocalPlayer then
                        KnifeCombat.throwKnife()
                    end
                end
            end)

            return function()
                if connection then
                    connection:Disconnect()
                end
            end
        end
    end
})

Tabs.Combat:Dropdown({
    Title = "Wall Check For Thrown Knife",
    Values = {"Manual Throw Knife", "Auto Throw Knife"},
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        KnifeCombat.wallCheckType = values
    end
})

Tabs.Combat:Section({ Title = "Thrown Hitbox", TextSize = 16 })

Tabs.Combat:Toggle({
    Title = "Enable Thrown Hitbox",
    Flag = "ThrownHitboxScalerToggle",
    Desc = "Expands thrown knife hit detection",
    Value = false,
    Callback = function(state)
        if state then
            KnifeCombat.EnableKnifeHitbox()
        else
            KnifeCombat.DisableKnifeHitbox()
        end
    end
})

Tabs.Combat:Slider({
    Title = "Hitbox Radius",
    Desc = "Radius for knife hitbox detection",
    Value = { Min = 1, Max = 500, Default = 10, Step = 1 },
    Callback = function(value)
        KnifeCombat.HitboxConfig.Radius = tonumber(value)
    end
})

Tabs.Combat:Toggle({
    Title = "Hit Multiple Targets",
    Desc = "Hit multiple players with one thrown knife",
    Value = false,
    Flag = "TSHMT",
    Type = "Checkbox",
    Callback = function(state)
        KnifeCombat.HitboxConfig.MultipleTargets = state
    end
})

Tabs.Combat:Section({ Title = "Auto Kill", TextSize = 16 })

Tabs.Combat:Toggle({
    Title = "Auto Kill",
    Flag = "AutoKillToggle",
    Flag = "KnifeAutoKillToggle",
    Value = false,
    Callback = function(state)
        KnifeCombat.autoKillEnabled = state
        if state then
            KnifeCombat.startAutoKill()
        else
            KnifeCombat.stopAutoKill()
        end
    end
})

Tabs.Combat:Toggle({
    Title = "Auto Equip Knife",
    Flag = "AutoEquipKnife",
    Value = false,
    Callback = function(state)
        KnifeCombat.autoEquipKnife = state
        if state then
            KnifeCombat.equipConnection = RunService.Heartbeat:Connect(KnifeCombat.checkNearbyPlayer)
        else
            if KnifeCombat.equipConnection then
                KnifeCombat.equipConnection:Disconnect()
                KnifeCombat.equipConnection = nil
            end
        end
    end
})

Tabs.Combat:Dropdown({
    Title = "Kill Mode",
    Flag = "KillModeDropdown",
    Values = {"Kill Aura", "Kill Nearby", "Kill All"},
    Value = "Kill Aura",
    Callback = function(value)
        KnifeCombat.killMode = value
    end
})

Tabs.Combat:Slider({
    Title = "Knife Kill Aura Range",
    Flag = "KillAuraSlider",
    Desc = "Adjust kill aura radius",
    Value = { Min = 1, Max = 500, Default = 10, Step = 1 },
    Callback = function(value)
        KnifeCombat.killAuraRadius = tonumber(value)
        if KnifeCombat.auraCircle then
            KnifeCombat.auraCircle.Size = Vector3.new(1, KnifeCombat.killAuraRadius * 2, KnifeCombat.killAuraRadius * 2)
        end
    end
})

Tabs.Combat:Toggle({
    Title = "Show Aura Circle",
    Flag = "ShowAuraToggle",
    Value = false,
    Callback = function(state)
        KnifeCombat.showAuraCircle = state
        KnifeCombat.createAuraCircle()
    end
})

Tabs.Combat:Button({
    Title = "Kill All",
    Desc = "Kill all players instantly",
    Icon = "target",
    Callback = function()
        if KnifeCombat.GetMurderer() ~= LocalPlayer then return end
        KnifeCombat.killAll()
    end
})

Tabs.Visuals:Section({ Title = "Visual", TextSize = 20 })
Tabs.Visuals:Divider()

local cameraStretchConnection

function setupCameraStretch()
    cameraStretchConnection = nil
    local stretchHorizontal = 0.80
    local stretchVertical = 0.80
    CameraStretchToggle = Tabs.Visuals:Toggle({
        Title = "Camera Stretch",
        Flag = "CameraStretchToggle",
        Value = false,
        Callback = function(state)
            if state then
                if cameraStretchConnection then cameraStretchConnection:Disconnect() end
                cameraStretchConnection = RunService.RenderStepped:Connect(function()
                    local Camera = workspace.CurrentCamera
                    Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
                end)
            else
                if cameraStretchConnection then
                    cameraStretchConnection:Disconnect()
                    cameraStretchConnection = nil
                end
            end
        end
    })

    CameraStretchHorizontalInput = Tabs.Visuals:Input({
        Title = "Camera Stretch Horizontal",
        Flag = "CameraStretchHorizontalInput",
        Placeholder = "0.80",
        Numeric = true,
        Value = tostring(stretchHorizontal),
        Callback = function(value)
            local num = tonumber(value)
            if num then
                stretchHorizontal = num
                if cameraStretchConnection then
                    cameraStretchConnection:Disconnect()
                    cameraStretchConnection = RunService.RenderStepped:Connect(function()
                        local Camera = workspace.CurrentCamera
                        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
                    end)
                end
            end
        end
    })

    CameraStretchVerticalInput = Tabs.Visuals:Input({
        Title = "Camera Stretch Vertical",
        Flag = "CameraStretchVerticalInput",
        Placeholder = "0.80",
        Numeric = true,
        Value = tostring(stretchVertical),
        Callback = function(value)
            local num = tonumber(value)
            if num then
                stretchVertical = num
                if cameraStretchConnection then
                    cameraStretchConnection:Disconnect()
                    cameraStretchConnection = RunService.RenderStepped:Connect(function()
                        local Camera = workspace.CurrentCamera
                        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
                    end)
                end
            end
        end
    })
end
setupCameraStretch()

Tabs.Visuals:Space()
FullBrightToggle = Tabs.Visuals:Toggle({
    Title = "Full Bright",
    Flag = "FullBrightToggle",
    Desc = "Ya Like drinking Night Vision while mining in da cave and sceard of creeper blow you up dawg?",
    Value = false,
    Callback = function(state)
        FullBright = state
        if state then
            local Lighting = game:GetService("Lighting")

            originalBrightness = Lighting.Brightness
            originalAmbient = Lighting.Ambient
            originalOutdoorAmbient = Lighting.OutdoorAmbient
            originalColorShiftBottom = Lighting.ColorShift_Bottom
            originalColorShiftTop = Lighting.ColorShift_Top

            function applyFullBright()
                if Lighting.Brightness ~= 1 then
                    Lighting.Brightness = 1
                end
                if Lighting.Ambient ~= Color3.new(1, 1, 1) then
                    Lighting.Ambient = Color3.new(1, 1, 1)
                end
                if Lighting.OutdoorAmbient ~= Color3.new(1, 1, 1) then
                    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                end
                if Lighting.ColorShift_Bottom ~= Color3.new(1, 1, 1) then
                    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
                end
                if Lighting.ColorShift_Top ~= Color3.new(1, 1, 1) then
                    Lighting.ColorShift_Top = Color3.new(1, 1, 1)
                end
            end

            applyFullBright()

            if fullBrightConnection then
                fullBrightConnection:Disconnect()
            end

            fullBrightConnection = RunService.Heartbeat:Connect(function()
                if FullBright then
                    applyFullBright()
                end
            end)

            fullBrightCharConnection = LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                if FullBright then
                    applyFullBright()
                end
            end)

        else
            if fullBrightConnection then
                fullBrightConnection:Disconnect()
                fullBrightConnection = nil
            end

            if fullBrightCharConnection then
                fullBrightCharConnection:Disconnect()
                fullBrightCharConnection = nil
            end

            if originalBrightness then
                local Lighting = game:GetService("Lighting")
                Lighting.Brightness = originalBrightness
                Lighting.Ambient = originalAmbient
                Lighting.OutdoorAmbient = originalOutdoorAmbient
                Lighting.ColorShift_Bottom = originalColorShiftBottom
                Lighting.ColorShift_Top = originalColorShiftTop
            end
        end
    end
})

Tabs.Visuals:Space()
FOVSlider = Tabs.Visuals:Slider({
    Title = "Field of View",
    Flag = "FOVSlider",
    Value = { Min = 1, Max = 120, Default = workspace.CurrentCamera.FieldOfView, Step = 1 },
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = tonumber(value)
    end
})

local roundTimerEnabled = false
local roundTimerGui = nil
local roundTimerLabel = nil
local roundTimerConnection = nil
local clearTweensConnection = nil
local loadingMapConnection = nil
local roleSelectConnection = nil
local victoryConnection = nil
local lastTimerText = ""
local freezeCheckTime = 0
local freezeThreshold = 3
local isWaitingForMapVote = false
local isLoadingMap = false
local roleDisplayTime = 0
local roleDisplayDuration = 5
local countdownStartTime = 0
local isInCountdown = false
local timeUpDisplayTime = 0
local timeUpDisplayDuration = 3
local victoryDisplayTime = 0
local victoryDisplayDuration = 5
local currentVictoryPlayer = nil
local victoryBillboardCheckConnection = nil

function createRoundTimerGui()
    if roundTimerGui then
        roundTimerGui:Destroy()
        roundTimerGui = nil
    end

    roundTimerGui = Instance.new("ScreenGui")
    roundTimerGui.Name = "RoundTimerGui"
    roundTimerGui.IgnoreGuiInset = true
    roundTimerGui.ResetOnSpawn = false
    roundTimerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    roundTimerGui.Parent = PlayerGui

    local uiScale = Instance.new("UIScale")
    uiScale.Parent = roundTimerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 40)
    frame.Position = UDim2.new(0.5, -100, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = roundTimerGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = frame

    roundTimerLabel = Instance.new("TextLabel")
    roundTimerLabel.Size = UDim2.new(1, 0, 1, 0)
    roundTimerLabel.BackgroundTransparency = 1
    roundTimerLabel.Text = "Round Timer: --:--"
    roundTimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    roundTimerLabel.Font = Enum.Font.RobotoMono
    roundTimerLabel.TextSize = 18
    roundTimerLabel.TextScaled = false
    roundTimerLabel.TextXAlignment = Enum.TextXAlignment.Center
    roundTimerLabel.TextYAlignment = Enum.TextYAlignment.Center
    roundTimerLabel.Parent = frame
end

function checkVictoryBillboard()
    if tick() - victoryDisplayTime < victoryDisplayDuration then
        return true
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local victoryBillboard = humanoidRootPart:FindFirstChild("VictoryBillboard")
                if victoryBillboard and victoryBillboard:IsA("BillboardGui") then
                    currentVictoryPlayer = player
                    victoryDisplayTime = tick()
                    roundTimerLabel.Text = player.Name .. " Win"
                    return true
                end
            end
        end
    end

    if currentVictoryPlayer and tick() - victoryDisplayTime >= victoryDisplayDuration then
        currentVictoryPlayer = nil
    end

    return false
end

function checkRoleSelectorCountdown()
    local mainGUI = PlayerGui:FindFirstChild("MainGUI")
    if not mainGUI then return false end

    local gameFrame = mainGUI:FindFirstChild("Game")
    if not gameFrame then return false end

    local roleSelector = gameFrame:FindFirstChild("RoleSelector")
    if not roleSelector or not roleSelector.Visible then return false end

    local roleText = roleSelector:FindFirstChild("Role")
    if not roleText then return false end

    local text = roleText.Text
    local number = tonumber(text)

    if number then
        roundTimerLabel.Text = "Round start in " .. number
        countdownStartTime = tick()
        isInCountdown = true
        return true
    end

    return false
end

function updateRoundTimer()
    if not roundTimerEnabled or not roundTimerLabel then return end

    if checkVictoryBillboard() then
        return
    end

    if tick() - timeUpDisplayTime < timeUpDisplayDuration then
        return
    end

    if isInCountdown then
        if tick() - countdownStartTime >= 1 then
            isInCountdown = false
        else
            return
        end
    end

    if checkRoleSelectorCountdown() then
        return
    end

    if tick() - roleDisplayTime < roleDisplayDuration then
        return
    end

    if isLoadingMap then
        roundTimerLabel.Text = "Loading map..."
        return
    end

    if isWaitingForMapVote then
        roundTimerLabel.Text = "Waiting for map vote"
        return
    end

    local timerPart = workspace:FindFirstChild("RoundTimerPart")
    if not timerPart then
        roundTimerLabel.Text = "Round Timer: --:--"
        lastTimerText = ""
        freezeCheckTime = tick()
        return
    end

    local surfaceGui = timerPart:FindFirstChildOfClass("SurfaceGui")
    if not surfaceGui then
        roundTimerLabel.Text = "Round Timer: --:--"
        lastTimerText = ""
        freezeCheckTime = tick()
        return
    end

    local timerLabel = surfaceGui:FindFirstChild("Timer")
    if not timerLabel then
        roundTimerLabel.Text = "Round Timer: --:--"
        lastTimerText = ""
        freezeCheckTime = tick()
        return
    end

    local currentText = timerLabel.Text
    local displayText = "Round Timer: " .. currentText

    if currentText == "1s" or currentText == "0s" then
        roundTimerLabel.Text = "Time's up"
        timeUpDisplayTime = tick()
        return
    end

    if currentText == lastTimerText then
        if tick() - freezeCheckTime >= freezeThreshold then
            roundTimerLabel.Text = displayText
            return
        end
    else
        lastTimerText = currentText
        freezeCheckTime = tick()
    end

    roundTimerLabel.Text = displayText
end

function setupClearTweensListener()
    if clearTweensConnection then
        clearTweensConnection:Disconnect()
        clearTweensConnection = nil
    end

    local ClientTweenEvents = ReplicatedStorage:WaitForChild("ClientTweenEvents")
    local ClearTweens = ClientTweenEvents:WaitForChild("ClearTweens")

    clearTweensConnection = ClearTweens.OnClientEvent:Connect(function(...)
        if roundTimerEnabled and roundTimerLabel then
            isWaitingForMapVote = true
            isLoadingMap = false
            lastTimerText = ""
            freezeCheckTime = tick()
            timeUpDisplayTime = 0
            victoryDisplayTime = 0
            currentVictoryPlayer = nil
        end
    end)
end

function setupLoadingMapListener()
    if loadingMapConnection then
        loadingMapConnection:Disconnect()
        loadingMapConnection = nil
    end

    local Remotes = ReplicatedStorage:WaitForChild("Remotes")
    local Gameplay = Remotes:WaitForChild("Gameplay")
    local LoadingMap = Gameplay:WaitForChild("LoadingMap")

    loadingMapConnection = LoadingMap.OnClientEvent:Connect(function(mapName)
        if roundTimerEnabled and roundTimerLabel then
            isLoadingMap = true
            isWaitingForMapVote = false
            lastTimerText = ""
            freezeCheckTime = tick()
            timeUpDisplayTime = 0
            victoryDisplayTime = 0
            currentVictoryPlayer = nil
        end
    end)
end

function setupRoleSelectListener()
    if roleSelectConnection then
        roleSelectConnection:Disconnect()
        roleSelectConnection = nil
    end

    local RoleSelect = ReplicatedStorage.Remotes.Gameplay.RoleSelect
    roleSelectConnection = RoleSelect.OnClientEvent:Connect(function(role, ...)
        if roundTimerEnabled and roundTimerLabel then
            local roleName = role or "Unknown"
            roundTimerLabel.Text = "Your role is " .. roleName
            roleDisplayTime = tick()
            isLoadingMap = false
            isWaitingForMapVote = false
            timeUpDisplayTime = 0
            victoryDisplayTime = 0
            currentVictoryPlayer = nil
        end
    end)
end

function startVictoryBillboardCheck()
    if victoryBillboardCheckConnection then
        victoryBillboardCheckConnection:Disconnect()
        victoryBillboardCheckConnection = nil
    end

    victoryBillboardCheckConnection = RunService.Heartbeat:Connect(function()
        if roundTimerEnabled and roundTimerLabel then
            checkVictoryBillboard()
        end
    end)
end

function startRoundTimer()
    if roundTimerConnection then return end

    createRoundTimerGui()
    setupClearTweensListener()
    setupLoadingMapListener()
    setupRoleSelectListener()
    startVictoryBillboardCheck()

    lastTimerText = ""
    freezeCheckTime = tick()
    isWaitingForMapVote = false
    isLoadingMap = false
    roleDisplayTime = 0
    countdownStartTime = 0
    isInCountdown = false
    timeUpDisplayTime = 0
    victoryDisplayTime = 0
    currentVictoryPlayer = nil

    roundTimerConnection = RunService.Heartbeat:Connect(function()
        updateRoundTimer()
    end)
end

function stopRoundTimer()
    if roundTimerConnection then
        roundTimerConnection:Disconnect()
        roundTimerConnection = nil
    end

    if clearTweensConnection then
        clearTweensConnection:Disconnect()
        clearTweensConnection = nil
    end

    if loadingMapConnection then
        loadingMapConnection:Disconnect()
        loadingMapConnection = nil
    end

    if roleSelectConnection then
        roleSelectConnection:Disconnect()
        roleSelectConnection = nil
    end

    if victoryBillboardCheckConnection then
        victoryBillboardCheckConnection:Disconnect()
        victoryBillboardCheckConnection = nil
    end

    if roundTimerGui then
        roundTimerGui:Destroy()
        roundTimerGui = nil
        roundTimerLabel = nil
    end

    lastTimerText = ""
    freezeCheckTime = 0
    isWaitingForMapVote = false
    isLoadingMap = false
    roleDisplayTime = 0
    countdownStartTime = 0
    isInCountdown = false
    timeUpDisplayTime = 0
    victoryDisplayTime = 0
    currentVictoryPlayer = nil
end

Tabs.Visuals:Space()
RoundTimerToggle = Tabs.Visuals:Toggle({
    Title = "Round Timer Display",
    Flag = "RoundTimerToggle",
    Desc = "Show round timer in top middle of screen",
    Value = false,
    Callback = function(state)
        roundTimerEnabled = state
        if state then
            startRoundTimer()
        else
            stopRoundTimer()
        end
    end
})

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == LocalPlayer then
        stopRoundTimer()
    end
end)

Tabs.Visuals:Space()
local xRay = false

Tabs.Visuals:Space()
Tabs.Visuals:Toggle({
    Title = "X-ray Vision",
    Flag = "Xray",
    Compact = true,
    Callback = function(state)
        xRay = state
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
                part.LocalTransparencyModifier = state and 0.7 or 0
            end
        end
    end
})

Tabs.Visuals:Space()
Tabs.Visuals:Button({
    Title = "Remove Footsteps",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        character:WaitForChild("Footsteps").Disabled = true
        if workspace:FindFirstChild("Footsteps") then workspace.Footsteps:Destroy() end 
    end
})

Tabs.Visuals:Space()
StuckKnifeRemoved = false
Tabs.Visuals:Space()
Tabs.Visuals:Button({
    Title = "Remove StuckKnife",
    Callback = function()
        if workspace:FindFirstChild("StuckKnife") then workspace.StuckKnife:Destroy() end
    end
})

Tabs.Visuals:Space()
Tabs.Visuals:Button({
    Title = "Auto Remove Dead Body",
    Callback = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Raggy" and obj:IsA("Model") then
                pcall(function()
                    obj:Destroy()
                end)
            end
        end
    end
})

Tabs.Visuals:Space()
Tabs.Visuals:Toggle({
    Title = "Disable CoinVisualizer",
    Flag = "Anti CoinLag",
    Callback = function(state)
        LocalPlayer.PlayerScripts.CoinVisualizer.Disabled = state
    end
})

SpectateService = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("SpectateService"))

originalToggle = SpectateService.ToggleSpectate
originalSetSpectating = SpectateService.SetSpectating

CurrentRoundClient = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CurrentRoundClient"))

forceSpectate = false
customSpectateEnabled = false
customSpectateTarget = nil
customSpectateConnection = nil
forceSpectateConnection = nil

function forceDeadState()
    local playerData = CurrentRoundClient.PlayerData[LocalPlayer.Name]
    if playerData then
        playerData.Dead = true
    end
end

function restoreAliveState()
    local playerData = CurrentRoundClient.PlayerData[LocalPlayer.Name]
    if playerData then
        playerData.Dead = false
    end
end

function stopForceSpectate()
    if forceSpectateConnection then
        forceSpectateConnection:Disconnect()
        forceSpectateConnection = nil
    end
    restoreAliveState()
    pcall(function()
        SpectateService.CancelSpectate()
    end)
    pcall(function()
        originalSetSpectating(SpectateService, false)
    end)
end

function startForceSpectate()
    forceDeadState()
    task.wait(0.1)
    pcall(function()
        SpectateService.ToggleSpectate()
    end)
    task.wait(0.1)
    pcall(function()
        SpectateService.SetSpectating(SpectateService, true)
    end)
end

function SpectateService.ToggleSpectate()
    if forceSpectate then
        forceDeadState()
    end
    pcall(function()
        originalToggle(SpectateService)
    end)
end

function SpectateService.SetSpectating(_, enabled)
    if enabled and forceSpectate then
        forceDeadState()
    elseif not enabled then
        restoreAliveState()
    end
    return originalSetSpectating(SpectateService, enabled)
end

function autoSpectate()
    if forceSpectate then
        forceDeadState()
        task.wait(0.1)
        pcall(function()
            SpectateService.ToggleSpectate()
        end)
        task.wait(0.1)
        pcall(function()
            SpectateService.SetSpectating(SpectateService, true)
        end)
    end
end

function startCustomSpectate(player)
    if customSpectateConnection then
        customSpectateConnection:Disconnect()
        customSpectateConnection = nil
    end

    if not player or not player.Character then
        return false
    end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return false
    end

    Camera.CameraSubject = humanoid

    customSpectateConnection = RunService.RenderStepped:Connect(function()
        if not customSpectateEnabled or not customSpectateTarget then
            return
        end

        if not customSpectateTarget.Character or not customSpectateTarget.Character:FindFirstChildOfClass("Humanoid") then
            return
        end

        local targetHumanoid = customSpectateTarget.Character:FindFirstChildOfClass("Humanoid")
        if targetHumanoid and Camera.CameraSubject ~= targetHumanoid then
            Camera.CameraSubject = targetHumanoid
        end
    end)

    return true
end

function stopCustomSpectate()
    if customSpectateConnection then
        customSpectateConnection:Disconnect()
        customSpectateConnection = nil
    end

    customSpectateEnabled = false
    customSpectateTarget = nil

    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            Camera.CameraSubject = humanoid
        else
            Camera.CameraSubject = nil
        end
    else
        Camera.CameraSubject = nil
    end
end

function getPlayerList()
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    if #players == 0 then
        players = {"None"}
    end
    return players
end

selectedPlayerForSpectate = "None"
customSpectateToggleObject = nil
spectatePlayerDropdownObject = nil

Tabs.Visuals:Space()
forceSpectateToggleObject = Tabs.Visuals:Toggle({
    Title = "Force Spectate",
    Flag = "ForceSpectateToggle",
    Desc = "Force Spectate While In Round Started",
    Value = false,
    Callback = function(state)
        forceSpectate = state
        if state then
            startForceSpectate()
            forceSpectateConnection = LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                if forceSpectate then
                    startForceSpectate()
                end
            end)
        else
            if forceSpectateConnection then
                forceSpectateConnection:Disconnect()
                forceSpectateConnection = nil
            end
            stopForceSpectate()
        end
    end
})

Tabs.Visuals:Space()

customSpectateToggleObject = Tabs.Visuals:Toggle({
    Title = "Custom Spectate Selected Player",
    Flag = "CustomSpectateToggle",
    Desc = "Spectate any player without game logic",
    Value = false,
    Callback = function(state)
        if state then
            if selectedPlayerForSpectate and selectedPlayerForSpectate ~= "None" then
                local targetPlayer = Players:FindFirstChild(selectedPlayerForSpectate)
                if targetPlayer and targetPlayer.Character then
                    customSpectateEnabled = true
                    customSpectateTarget = targetPlayer
                    startCustomSpectate(targetPlayer)
                else
                    customSpectateToggleObject:Set(false)
                end
            else
                customSpectateToggleObject:Set(false)
            end
        else
            stopCustomSpectate()
        end
    end
})

spectatePlayerDropdownObject = Tabs.Visuals:Dropdown({
    Title = "Select Player To Spectate",
    Flag = "SpectatePlayerDropdown",
    Values = getPlayerList(),
    Value = "None",
    Callback = function(value)
        selectedPlayerForSpectate = value

        if value == "None" or value == nil then
            if customSpectateEnabled then
                customSpectateToggleObject:Set(false)
                stopCustomSpectate()
            end
            return
        end

        if customSpectateEnabled then
            local targetPlayer = Players:FindFirstChild(value)
            if targetPlayer then
                customSpectateTarget = targetPlayer
                startCustomSpectate(targetPlayer)
            else
                if customSpectateEnabled then
                    customSpectateToggleObject:Set(false)
                    stopCustomSpectate()
                end
            end
        end
    end
})

function updateSpectateDropdown()
    if spectatePlayerDropdownObject and spectatePlayerDropdownObject.Refresh then
        local currentValue = selectedPlayerForSpectate
        local players = getPlayerList()

        if currentValue ~= "None" and not Players:FindFirstChild(currentValue) then
            currentValue = "None"
            selectedPlayerForSpectate = "None"
            if customSpectateEnabled then
                customSpectateToggleObject:Set(false)
                stopCustomSpectate()
            end
        end

        if #players == 0 then
            players = {"None"}
            currentValue = "None"
            selectedPlayerForSpectate = "None"
            if customSpectateEnabled then
                customSpectateToggleObject:Set(false)
                stopCustomSpectate()
            end
        end

        spectatePlayerDropdownObject:Refresh(players, currentValue)
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(0.1)
    updateSpectateDropdown()
end)

Players.PlayerRemoving:Connect(function(player)
    task.wait(0.1)
    if customSpectateEnabled and customSpectateTarget == player then
        customSpectateToggleObject:Set(false)
        stopCustomSpectate()
        selectedPlayerForSpectate = "None"
    end
    updateSpectateDropdown()
end)

LocalPlayer.CharacterAdded:Connect(function()
    if not customSpectateEnabled then
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                Camera.CameraSubject = humanoid
            end
        end
    end
end)

Tabs.Visuals:Space()
Tabs.Visuals:Button({
    Title = "Shit Render", 
    Callback = function()
        Lighting = game:GetService("Lighting")
        Terrain = workspace:FindFirstChildOfClass("Terrain")
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
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
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

function spawnWeapon(name)
    local DataBase, PlayerData = require(ReplicatedStorage.Database.Sync.Item),
    require(ReplicatedStorage.Modules.ProfileData)
    local newOwned = {}
    newOwned[name] = 1
    local PlayerWeapons = PlayerData.Weapons
    RunService:BindToRenderStep("InventoryUpdate", 0, function()
        PlayerWeapons.Owned = newOwned
    end)
    LocalPlayer.Character:BreakJoints()
end

local WeaponOwnedRange = { min = 1, max = 100000 }

Tabs.Visuals:Section({ Title = "Weapon Visuals", Desc = "" })

Tabs.Visuals:Paragraph({
    Title = "VISUAL WARNING",
    Desc = "ALL items are in fact visual and not real you do not get to keep any of the items after rejoining the game they are only for show and do not actually exist ",
    Image = "eye"
})

Tabs.Visuals:Slider({
    Title = "Min",
    Value = {Min = 1, Max = 100000, Default = 1},
    Compact = true,
    Callback = function(value) WeaponOwnedRange.min = value end
})

Tabs.Visuals:Slider({
    Title = "Max",
    Value = {Min = 1, Max = 100000, Default = 150},
    Compact = true,
    Callback = function(value) WeaponOwnedRange.max = value end
})

Tabs.Visuals:Button({
    Title = "spawn random Godlys (if they don't spawn reset ",
    Compact = true,
    Callback = function()
        local DataBase = require(ReplicatedStorage.Database.Sync.Item)
        local PlayerData = require(ReplicatedStorage.Modules.ProfileData)
        local newOwned = {}
        for i, v in pairs(DataBase) do
            newOwned[i] = math.random(WeaponOwnedRange.min, WeaponOwnedRange.max)
        end
        RunService:BindToRenderStep("InventoryUpdate", 0, function()
            PlayerData.Weapons.Owned = newOwned
        end)
        WindUI:Notify({ Title = "Visuals Enabled", Content = "Fake counts activated!", Duration = 2 })
    end
})

Tabs.Visuals:Section({ Title = "Item Spawner", Desc = "" })

Tabs.Visuals:Input({
    Title = "Weapon Name",
    Placeholder = "Enter weapon name..",
    Compact = true,
    Callback = function(inputText)
        if inputText and inputText ~= "" then
            spawnWeapon(inputText)
            WindUI:Notify({ Title = "Weapon Spawned", Content = inputText.." added!", Duration = 2 })
        end
    end
})

Tabs.Visuals:Section({ Title = "weapon dupe ", Desc = "" })

Tabs.Visuals:Section({ Title = "Duplication Options", Desc = "Select amount to duplicate by and choose a specific item to duplicate." })

Tabs.Visuals:Input({
    Title = "Duplication Multiplier",
    Placeholder = "Enter multiplier (e.g., 2, 3)",
    Compact = true,
    Callback = function(inputText)
        local multiplier = tonumber(inputText)
        if multiplier and multiplier > 0 then
            DupeMultiplier = multiplier
            WindUI:Notify({ Title = "Multiplier Set", Content = "Duplication multiplier set to x" .. multiplier, Duration = 2 })
        else
            WindUI:Notify({ Title = "Invalid Multiplier", Content = "Please enter a valid multiplier (greater than 0).", Duration = 2 })
        end
    end
})

Tabs.Visuals:Input({
    Title = "Specific Item to Duplicate",
    Placeholder = "Enter item name to dupe (e.g., Christmas Knife)",
    Compact = true,
    Callback = function(inputText)
        DupeSpecificItem = inputText
        WindUI:Notify({ Title = "Item Set", Content = "Specific item set to duplicate: " .. inputText, Duration = 2 })
    end
})

Tabs.Visuals:Button({
    Title = "Duplicate Inventory",
    Compact = true,
    Callback = function()
        local UIPath

        if PlayerGui.MainGUI.Game:FindFirstChild("Inventory") ~= nil then
            UIPath = PlayerGui.MainGUI.Game.Inventory.Main
        else
            UIPath = PlayerGui.MainGUI.Lobby.Screens.Inventory.Main
        end

        function VisualDupe()
            local multiplier = DupeMultiplier or 2
            local specificItem = DupeSpecificItem

            for _, item in pairs(UIPath.Weapons.Items.Container:GetChildren()) do
                for _, weapon in pairs(item.Container:GetChildren()) do
                    if weapon:IsA("Frame") then
                        local itemName = weapon.ItemName.Label.Text
                        if (not specificItem or itemName == specificItem) and itemName ~= "Default Knife" and itemName ~= "Default Gun" then
                            local amount = weapon.Container.Amount.Text
                            if amount == "" or amount == "None" then
                                weapon.Container.Amount.Text = "x" .. tostring(multiplier)
                            else
                                local num = tonumber(amount:match("x(%d+)"))
                                if num then
                                    weapon.Container.Amount.Text = "x" .. tostring(num * multiplier)
                                end
                            end
                        end
                    end
                end
            end

            for _, pet in pairs(UIPath.Pets.Items.Container.Current.Container:GetChildren()) do
                if pet:IsA("Frame") then
                    local amount = pet.Container.Amount.Text
                    if amount == "" or amount == "None" then
                        pet.Container.Amount.Text = "x" .. tostring(multiplier)
                    else
                        local num = tonumber(amount:match("x(%d+)"))
                        if num then
                            pet.Container.Amount.Text = "x" .. tostring(num * multiplier)
                        end
                    end
                end
            end
        end

        VisualDupe()

        WindUI:Notify({ Title = "Inventory Visual Duplication", Content = "Your inventory has been visually duplicated!", Duration = 2 })
    end
})

gunEspElements = {}
roleEspElements = {}

gunBoxesEnabled = false
gunNamesEnabled = false
gunDistanceEnabled = false
gunHighlightsEnabled = false
gunBoxType = "2D"
roleSettings = {}
for roleName in pairs(RoleList) do
    roleSettings[roleName] = {
        boxesEnabled = false,
        namesEnabled = false,
        distanceEnabled = false,
        highlightsEnabled = false,
        boxType = "2D"
    }
end

isRendering = true
windowFocused = true

local frameSkipCounter = 0
local FRAME_SKIP = 3
local gunUpdateInterval = 0.3
local lastGunUpdate = 0
local lastRoleUpdate = 0
local roleUpdateInterval = 0.2
local lastGunScanTime = 0
local cachedGuns = {}

function getDistanceFromCamera(targetPosition)
    local camera = workspace.CurrentCamera
    if not camera then return 0 end
    return (targetPosition - camera.CFrame.Position).Magnitude
end

function calculateBoxScale(distance)
    if distance <= 17 then
        return 1
    else
        local scale = 17 / distance
        return math.max(scale, 0.013)
    end
end

local roundDataCache = nil
local roundDataCacheTime = 0
local roundDataCacheDuration = 0.5

function getRoundData()
    local currentTime = tick()
    if roundDataCache and (currentTime - roundDataCacheTime) < roundDataCacheDuration then
        return roundDataCache
    end
    
    local currentRoundModule = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("CurrentRoundClient")
    if currentRoundModule then
        local success, roundData = pcall(function()
            return require(currentRoundModule)
        end)
        if success and roundData and roundData.PlayerData then
            roundDataCache = roundData
            roundDataCacheTime = currentTime
            return roundData
        end
    end
    return nil
end

function getPlayerRoleAndStatus(player)
    local roundData = getRoundData()
    if roundData then
        local playerData = roundData.PlayerData[player.Name]
        if playerData then
            return playerData.Role, playerData.Dead
        end
    end
    return nil, nil
end

function getRoleColor(role, isDead)
    if isDead then
        return Color3.fromRGB(255, 255, 255)
    end
    return RoleList[role] or Color3.fromRGB(200, 200, 200)
end

function getRoleHexColor(role)
    local color = RoleList[role]
    if not color then return "#C8C8C8" end
    return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
end

function create3DBox(character, color, size)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local folderName = "ESP_3DBox"
    local folder = character:FindFirstChild(folderName)
    if folder then
        folder:Destroy()
    end

    folder = Instance.new("Folder")
    folder.Name = folderName
    folder.Parent = character

    size = size or Vector3.new(4, 5, 3)
    local offsetX = size.X / 2
    local offsetY = size.Y / 2
    local offsetZ = size.Z / 2

    local edges = {
        {Vector3.new(0, offsetY, offsetZ), Vector3.new(size.X, 0.1, 0.1), "TopFront"},
        {Vector3.new(0, offsetY, -offsetZ), Vector3.new(size.X, 0.1, 0.1), "TopBack"},
        {Vector3.new(-offsetX, offsetY, 0), Vector3.new(0.1, 0.1, size.Z), "TopLeft"},
        {Vector3.new(offsetX, offsetY, 0), Vector3.new(0.1, 0.1, size.Z), "TopRight"},
        {Vector3.new(0, -offsetY, offsetZ), Vector3.new(size.X, 0.1, 0.1), "BottomFront"},
        {Vector3.new(0, -offsetY, -offsetZ), Vector3.new(size.X, 0.1, 0.1), "BottomBack"},
        {Vector3.new(-offsetX, -offsetY, 0), Vector3.new(0.1, 0.1, size.Z), "BottomLeft"},
        {Vector3.new(offsetX, -offsetY, 0), Vector3.new(0.1, 0.1, size.Z), "BottomRight"},
        {Vector3.new(-offsetX, 0, offsetZ), Vector3.new(0.1, size.Y, 0.1), "FrontLeft"},
        {Vector3.new(offsetX, 0, offsetZ), Vector3.new(0.1, size.Y, 0.1), "FrontRight"},
        {Vector3.new(-offsetX, 0, -offsetZ), Vector3.new(0.1, size.Y, 0.1), "BackLeft"},
        {Vector3.new(offsetX, 0, -offsetZ), Vector3.new(0.1, size.Y, 0.1), "BackRight"}
    }

    for _, edge in ipairs(edges) do
        local position = edge[1]
        local boxSize = edge[2]
        local name = edge[3]

        local adornment = Instance.new("BoxHandleAdornment")
        adornment.Name = name
        adornment.Adornee = rootPart
        adornment.Size = boxSize
        adornment.CFrame = CFrame.new(position)
        adornment.Color3 = color
        adornment.Transparency = 0.2
        adornment.ZIndex = 10
        adornment.AlwaysOnTop = true
        adornment.Visible = true
        adornment.Parent = folder
    end

    return folder
end

function update3DBoxColor(character, color)
    local folder = character:FindFirstChild("ESP_3DBox")
    if folder then
        for _, adornment in ipairs(folder:GetChildren()) do
            if adornment:IsA("BoxHandleAdornment") then
                adornment.Color3 = color
            end
        end
    end
end

function remove3DBox(character)
    local folder = character:FindFirstChild("ESP_3DBox")
    if folder then
        folder:Destroy()
    end
end

function createBillboard(character, name, color)
    local existing = character:FindFirstChild("ESP_Billboard")
    if existing then
        existing:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        billboard.Adornee = rootPart
        billboard.Parent = rootPart
    else
        billboard.Adornee = character
        billboard.Parent = character
    end

    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.ClipsDescendants = false
    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    billboard.Active = true

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = billboard

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = color
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamSemibold
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    nameLabel.Parent = mainFrame

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0, 16)
    distanceLabel.Position = UDim2.new(0, 0, 0, 20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = ""
    distanceLabel.TextColor3 = color
    distanceLabel.TextSize = 12
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distanceLabel.TextStrokeTransparency = 0.3
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Center
    distanceLabel.TextYAlignment = Enum.TextYAlignment.Top
    distanceLabel.Parent = mainFrame

    return {
        billboard = billboard,
        nameLabel = nameLabel,
        distanceLabel = distanceLabel
    }
end

function updateBillboard(billboardData, name, distance, color)
    if not billboardData then return end

    if name then
        billboardData.nameLabel.Text = name
        billboardData.nameLabel.TextColor3 = color
    end

    if distance then
        billboardData.distanceLabel.Text = string.format("%.1f studs", distance)
        billboardData.distanceLabel.TextColor3 = color
    end

    billboardData.nameLabel.Visible = name ~= nil
    billboardData.distanceLabel.Visible = distance ~= nil
end

function create2DBox(character, color, scale)
    local existing = character:FindFirstChild("ESP_2DBox")
    if existing then
        existing:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_2DBox"

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        billboard.Adornee = rootPart
        billboard.Parent = rootPart
    else
        billboard.Adornee = character
        billboard.Parent = character
    end

    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 80 * scale, 0, 100 * scale)
    billboard.StudsOffset = Vector3.new(0, 0, 0)
    billboard.ClipsDescendants = false

    local boxFrame = Instance.new("Frame")
    boxFrame.Name = "BoxFrame"
    boxFrame.Size = UDim2.new(1, 0, 1, 0)
    boxFrame.BackgroundTransparency = 1
    boxFrame.BorderSizePixel = 0
    boxFrame.Parent = billboard

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = math.max(1.5 * scale, 1)
    uiStroke.Transparency = 0
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uiStroke.Color = color
    uiStroke.Parent = boxFrame

    return {
        billboard = billboard,
        boxFrame = boxFrame,
        stroke = uiStroke,
        scale = scale
    }
end

function update2DBox(boxData, color, scale)
    if boxData then
        if boxData.stroke then
            boxData.stroke.Color = color
        end
        if boxData.billboard then
            boxData.billboard.Size = UDim2.new(0, 80 * scale, 0, 100 * scale)
        end
        if boxData.stroke then
            boxData.stroke.Thickness = math.max(1.5 * scale, 1)
        end
        boxData.scale = scale
    end
end

function remove2DBox(character)
    local box = character:FindFirstChild("ESP_2DBox")
    if box then
        box:Destroy()
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local boxInRoot = rootPart:FindFirstChild("ESP_2DBox")
        if boxInRoot then
            boxInRoot:Destroy()
        end
    end
end

function createHighlight(character, color)
    local existing = character:FindFirstChild("ESP_Highlight")
    if existing then
        existing:Destroy()
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = character
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.3
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    return highlight
end

function updateHighlight(highlight, color)
    if highlight then
        highlight.FillColor = color
        highlight.OutlineColor = color
    end
end

function removeHighlight(character)
    local highlight = character:FindFirstChild("ESP_Highlight")
    if highlight then
        highlight:Destroy()
    end
end

function getGunColor()
    return Color3.fromRGB(255, 0, 255)
end

function findGunParts()
    local currentTime = tick()
    if currentTime - lastGunScanTime < gunUpdateInterval then
        return cachedGuns
    end
    
    local guns = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "GunDrop" and obj.Parent then
            table.insert(guns, obj)
        end
    end
    
    cachedGuns = guns
    lastGunScanTime = currentTime
    return guns
end

function cleanupGunESP()
    for gun, esp in pairs(gunEspElements) do
        if esp.box2D then
            local box = gun:FindFirstChild("ESP_2DBox")
            if box then box:Destroy() end
            local rootPart = gun:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local boxInRoot = rootPart:FindFirstChild("ESP_2DBox")
                if boxInRoot then boxInRoot:Destroy() end
            end
        end
        if esp.box3D then remove3DBox(gun) end
        if esp.highlight then removeHighlight(gun) end
        if esp.billboard then
            local bill = gun:FindFirstChild("ESP_Billboard")
            if bill then bill:Destroy() end
            local rootPart = gun:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local billInRoot = rootPart:FindFirstChild("ESP_Billboard")
                if billInRoot then billInRoot:Destroy() end
            end
        end
    end
    gunEspElements = {}
end

function cleanupRoleESP()
    for character, esp in pairs(roleEspElements) do
        if esp.box2D then
            local box = character:FindFirstChild("ESP_2DBox")
            if box then box:Destroy() end
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local boxInRoot = rootPart:FindFirstChild("ESP_2DBox")
                if boxInRoot then boxInRoot:Destroy() end
            end
        end
        if esp.box3D then remove3DBox(character) end
        if esp.highlight then removeHighlight(character) end
        if esp.billboard then
            local bill = character:FindFirstChild("ESP_Billboard")
            if bill then bill:Destroy() end
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local billInRoot = rootPart:FindFirstChild("ESP_Billboard")
                if billInRoot then billInRoot:Destroy() end
            end
        end
    end
    roleEspElements = {}
end

function removeDeadESPEntries()
    local toRemove = {}
    for gun, esp in pairs(gunEspElements) do
        if not gun or not gun.Parent then
            if esp.box2D then
                pcall(function() remove2DBox(gun) end)
            end
            if esp.box3D then
                pcall(function() remove3DBox(gun) end)
            end
            if esp.highlight then
                pcall(function() removeHighlight(gun) end)
            end
            if esp.billboard then
                pcall(function()
                    local bill = gun:FindFirstChild("ESP_Billboard")
                    if bill then bill:Destroy() end
                end)
            end
            table.insert(toRemove, gun)
        end
    end
    
    for _, gun in ipairs(toRemove) do
        gunEspElements[gun] = nil
    end
end

function updateGunESP()
    if not isRendering or not windowFocused then return end
    if not workspace.CurrentCamera then return end
    
    frameSkipCounter = frameSkipCounter + 1
    if frameSkipCounter % FRAME_SKIP ~= 0 then return end

    local currentTime = tick()
    if currentTime - lastGunUpdate < gunUpdateInterval then return end
    lastGunUpdate = currentTime

    removeDeadESPEntries()

    local currentTargets = {}
    local guns = findGunParts()

    for _, gun in ipairs(guns) do
        if gun and gun.Parent then
            currentTargets[gun] = true

            if not gunEspElements[gun] then
                gunEspElements[gun] = {}
            end

            local esp = gunEspElements[gun]
            local distance = getDistanceFromCamera(gun.Position)
            local scale = calculateBoxScale(distance)
            local gunColor = getGunColor()

            if gunBoxesEnabled then
                if gunBoxType == "2D" then
                    if not esp.box2D then
                        esp.box2D = create2DBox(gun, gunColor, scale)
                    end
                    if esp.box2D then
                        update2DBox(esp.box2D, gunColor, scale)
                    end
                    if esp.box3D then
                        remove3DBox(gun)
                        esp.box3D = nil
                    end
                else
                    if not esp.box3D then
                        esp.box3D = create3DBox(gun, gunColor, Vector3.new(3, 3, 3))
                    end
                    if esp.box3D then
                        update3DBoxColor(gun, gunColor)
                    end
                    if esp.box2D then
                        remove2DBox(gun)
                        esp.box2D = nil
                    end
                end
            else
                if esp.box2D then 
                    remove2DBox(gun)
                    esp.box2D = nil
                end
                if esp.box3D then 
                    remove3DBox(gun)
                    esp.box3D = nil
                end
            end

            if gunHighlightsEnabled then
                if not esp.highlight then
                    esp.highlight = createHighlight(gun, gunColor)
                end
                if esp.highlight then
                    updateHighlight(esp.highlight, gunColor)
                end
            else
                if esp.highlight then
                    removeHighlight(gun)
                    esp.highlight = nil
                end
            end

            if gunNamesEnabled or gunDistanceEnabled then
                if not esp.billboard then
                    esp.billboard = createBillboard(gun, "Gun", gunColor)
                end
                if esp.billboard then
                    local displayDistance = gunDistanceEnabled and distance or nil
                    updateBillboard(esp.billboard, gunNamesEnabled and "Gun" or nil, displayDistance, gunColor)
                end
            else
                if esp.billboard then
                    local bill = gun:FindFirstChild("ESP_Billboard")
                    if bill then bill:Destroy() end
                    local rootPart = gun:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local billInRoot = rootPart:FindFirstChild("ESP_Billboard")
                        if billInRoot then billInRoot:Destroy() end
                    end
                    esp.billboard = nil
                end
            end
        end
    end

    local gunsToRemove = {}
    for gun, esp in pairs(gunEspElements) do
        if not currentTargets[gun] then
            if esp.box2D then 
                remove2DBox(gun)
            end
            if esp.box3D then 
                remove3DBox(gun)
            end
            if esp.highlight then 
                removeHighlight(gun)
            end
            if esp.billboard then
                local bill = gun:FindFirstChild("ESP_Billboard")
                if bill then bill:Destroy() end
                local rootPart = gun:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local billInRoot = rootPart:FindFirstChild("ESP_Billboard")
                    if billInRoot then billInRoot:Destroy() end
                end
            end
            table.insert(gunsToRemove, gun)
        end
    end
    
    for _, gun in ipairs(gunsToRemove) do
        gunEspElements[gun] = nil
    end
end

function updateRoleESP()
    if not isRendering or not windowFocused then return end
    if not workspace.CurrentCamera then return end
    
    local currentTime = tick()
    if currentTime - lastRoleUpdate < roleUpdateInterval then return end
    lastRoleUpdate = currentTime

    local currentTargets = {}

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer then
            local character = otherPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local role, isDead = getPlayerRoleAndStatus(otherPlayer)
                    if role and RoleList[role] then
                        currentTargets[character] = true

                        if not roleEspElements[character] then
                            roleEspElements[character] = {}
                        end

                        local esp = roleEspElements[character]
                        local distance = getDistanceFromCamera(character.HumanoidRootPart.Position)
                        local scale = calculateBoxScale(distance)
                        local roleColor = getRoleColor(role, isDead)
                        local settings = roleSettings[role]

                        if settings and settings.boxesEnabled then
                            if settings.boxType == "2D" then
                                if not esp.box2D then
                                    esp.box2D = create2DBox(character, roleColor, scale)
                                end
                                if esp.box2D then
                                    update2DBox(esp.box2D, roleColor, scale)
                                end
                                if esp.box3D then
                                    remove3DBox(character)
                                    esp.box3D = nil
                                end
                            else
                                local boxSize = Vector3.new(4, 5, 3)
                                if humanoid then
                                    boxSize = Vector3.new(2, humanoid.HipHeight + 5, 2)
                                end
                                if not esp.box3D then
                                    esp.box3D = create3DBox(character, roleColor, boxSize)
                                end
                                if esp.box3D then
                                    update3DBoxColor(character, roleColor)
                                end
                                if esp.box2D then
                                    remove2DBox(character)
                                    esp.box2D = nil
                                end
                            end
                        else
                            if esp.box2D then 
                                remove2DBox(character)
                                esp.box2D = nil
                            end
                            if esp.box3D then 
                                remove3DBox(character)
                                esp.box3D = nil
                            end
                        end

                        if settings and settings.highlightsEnabled then
                            if not esp.highlight then
                                esp.highlight = createHighlight(character, roleColor)
                            end
                            if esp.highlight then
                                updateHighlight(esp.highlight, roleColor)
                            end
                        else
                            if esp.highlight then
                                removeHighlight(character)
                                esp.highlight = nil
                            end
                        end

                        if settings and (settings.namesEnabled or settings.distanceEnabled) then
                            if not esp.billboard then
                                esp.billboard = createBillboard(character, otherPlayer.Name, roleColor)
                            end
                            if esp.billboard then
                                local displayDistance = settings.distanceEnabled and distance or nil
                                updateBillboard(esp.billboard, settings.namesEnabled and otherPlayer.Name or nil, displayDistance, roleColor)
                            end
                        else
                            if esp.billboard then
                                local bill = character:FindFirstChild("ESP_Billboard")
                                if bill then bill:Destroy() end
                                local rootPart = character:FindFirstChild("HumanoidRootPart")
                                if rootPart then
                                    local billInRoot = rootPart:FindFirstChild("ESP_Billboard")
                                    if billInRoot then billInRoot:Destroy() end
                                end
                                esp.billboard = nil
                            end
                        end
                    end
                end
            end
        end
    end

    local charsToRemove = {}
    for character, esp in pairs(roleEspElements) do
        if not currentTargets[character] then
            if esp.box2D then 
                remove2DBox(character)
            end
            if esp.box3D then 
                remove3DBox(character)
            end
            if esp.highlight then 
                removeHighlight(character)
            end
            if esp.billboard then
                local bill = character:FindFirstChild("ESP_Billboard")
                if bill then bill:Destroy() end
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local billInRoot = rootPart:FindFirstChild("ESP_Billboard")
                    if billInRoot then billInRoot:Destroy() end
                end
            end
            table.insert(charsToRemove, character)
        end
    end
    
    for _, character in ipairs(charsToRemove) do
        roleEspElements[character] = nil
    end
end

function isESPNeded()
    if gunBoxesEnabled or gunNamesEnabled or gunDistanceEnabled or gunHighlightsEnabled then
        return true
    end
    
    for roleName, settings in pairs(roleSettings) do
        if settings.boxesEnabled or settings.namesEnabled or settings.distanceEnabled or settings.highlightsEnabled then
            return true
        end
    end
    
    return false
end

function createRoleSections()
    for roleName, roleColor in pairs(RoleList) do
        local hexColor = getRoleHexColor(roleName)
        local richTitle = "<font color='" .. hexColor .. "'>" .. roleName .. " ESP</font>"
        
        local CollapsedSection = Tabs.ESP:Section({
            Title = richTitle,
            Opened = false,
            TextSize = 16
        })

        CollapsedSection:Toggle({
            Title = roleName .. " Boxes",
            Flag = roleName .. "Boxes",
            Value = false,
            Callback = function(state)
                if roleSettings[roleName] then
                    roleSettings[roleName].boxesEnabled = state
                end
                checkAndUpdateRenderLoop()
            end
        })

        CollapsedSection:Dropdown({
            Title = roleName .. " Box Type",
            Flag = roleName .. "BoxType",
            Values = {"2D", "3D"},
            Value = "2D",
            Callback = function(value)
                if roleSettings[roleName] then
                    roleSettings[roleName].boxType = value
                end
            end
        })

        CollapsedSection:Toggle({
            Title = roleName .. " Names",
            Flag = roleName .. "Names",
            Value = false,
            Callback = function(state)
                if roleSettings[roleName] then
                    roleSettings[roleName].namesEnabled = state
                end
                checkAndUpdateRenderLoop()
            end
        })

        CollapsedSection:Toggle({
            Title = roleName .. " Distance",
            Flag = roleName .. "Distance",
            Value = false,
            Callback = function(state)
                if roleSettings[roleName] then
                    roleSettings[roleName].distanceEnabled = state
                end
                checkAndUpdateRenderLoop()
            end
        })

        CollapsedSection:Toggle({
            Title = roleName .. " Highlights",
            Flag = roleName .. "Highlights",
            Value = false,
            Callback = function(state)
                if roleSettings[roleName] then
                    roleSettings[roleName].highlightsEnabled = state
                end
                checkAndUpdateRenderLoop()
            end
        })
    end
end

renderConnection = nil
lastRenderTime = tick()
renderCheckConnection = nil

function onRenderStepped()
    lastRenderTime = tick()
    isRendering = true

    if gunBoxesEnabled or gunNamesEnabled or gunDistanceEnabled or gunHighlightsEnabled then
        updateGunESP()
    else
        if next(gunEspElements) ~= nil then
            cleanupGunESP()
        end
    end

    local anyRoleActive = false
    for roleName, settings in pairs(roleSettings) do
        if settings.boxesEnabled or settings.namesEnabled or settings.distanceEnabled or settings.highlightsEnabled then
            anyRoleActive = true
            break
        end
    end

    if anyRoleActive then
        updateRoleESP()
    else
        if next(roleEspElements) ~= nil then
            cleanupRoleESP()
        end
    end
    
    if not isESPNeded() then
        stopRenderLoop()
    end
end

function startRenderLoop()
    if renderConnection then return end
    if not isESPNeded() then return end
    renderConnection = RunService.RenderStepped:Connect(onRenderStepped)
end

function stopRenderLoop()
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
end

function checkAndUpdateRenderLoop()
    if isESPNeded() then
        startRenderLoop()
    else
        cleanupAllESP()
        stopRenderLoop()
    end
end

function cleanupAllESP()
    cleanupGunESP()
    cleanupRoleESP()
end

createRoleSections()

renderCheckConnection = RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    if currentTime - lastRenderTime > 1 then
        isRendering = false
        cleanupAllESP()
    end
end)

UserInputService.WindowFocusReleased:Connect(function()
    windowFocused = false
    isRendering = false
    cleanupAllESP()
end)

UserInputService.WindowFocused:Connect(function()
    windowFocused = true
    isRendering = true
    checkAndUpdateRenderLoop()
end)

game:GetService("GuiService"):GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
    if game:GetService("GuiService").MenuIsOpen then
        isRendering = false
        cleanupAllESP()
    else
        isRendering = true
        checkAndUpdateRenderLoop()
    end
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == LocalPlayer then
        cleanupAllESP()
        stopRenderLoop()
    end
end)

local GunESPSection = Tabs.ESP:Section({
    Title = "Gun ESP",
    Opened = false,
    TextSize = 16
})

GunESPSection:Toggle({
    Title = "Gun Boxes",
    Flag = "GunBoxes",
    Value = false,
    Callback = function(state) 
        gunBoxesEnabled = state
        checkAndUpdateRenderLoop()
    end
})

GunESPSection:Dropdown({
    Title = "Gun Box Type",
    Flag = "GunBoxType",
    Values = {"2D", "3D"},
    Value = "2D",
    Callback = function(value) gunBoxType = value end
})

GunESPSection:Toggle({
    Title = "Gun Names",
    Flag = "GunNames",
    Value = false,
    Callback = function(state) 
        gunNamesEnabled = state
        checkAndUpdateRenderLoop()
    end
})

GunESPSection:Toggle({
    Title = "Gun Distance",
    Flag = "GunDistance",
    Value = false,
    Callback = function(state) 
        gunDistanceEnabled = state
        checkAndUpdateRenderLoop()
    end
})

GunESPSection:Toggle({
    Title = "Gun Highlights",
    Flag = "GunHighlights",
    Value = false,
    Callback = function(state) 
        gunHighlightsEnabled = state
        checkAndUpdateRenderLoop()
    end
})

Tabs.Teleport:Section({ Title = "Teleport", TextSize = 20 })
Tabs.Teleport:Divider()

function GetPlayerList()
    local playerList = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local success, content = pcall(function()
                return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
            local iconUrl = success and content or "user"
            table.insert(playerList, {
                Title = plr.DisplayName,
                Desc = "@" .. plr.Name,
                Icon = iconUrl
            })
        end
    end
    if #playerList == 0 then
        return {{Title = "No players found", Desc = "", Icon = "user"}}
    end
    return playerList
end

TeleportPlayerDropdown = Tabs.Teleport:Dropdown({
    Title = "Select Player",
    Flag = "TeleportPlayerDropdown",
    Values = GetPlayerList(),
    Value = "Select a player",
    Callback = function(value)
        selectedPlayerOption = value
    end
})

function UpdatePlayerList()
    TeleportPlayerDropdown:Refresh(GetPlayerList(), "Select a player")
end

function TeleportToPlayer(x, y, z)
    if selectedPlayerOption and selectedPlayerOption.Title ~= "No players found" then
        local targetPlayer = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.DisplayName == selectedPlayerOption.Title or plr.Name == selectedPlayerOption.Desc:sub(2) then
                targetPlayer = plr
                break
            end
        end

        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(x or 0, y or 0, z or 0)
            end
        end
    end
end

function TeleportToRandomPlayer(x, y, z)
    local otherPlayers = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(otherPlayers, plr)
        end
    end

    if #otherPlayers > 0 then
        local randomPlayer = otherPlayers[math.random(1, #otherPlayers)]
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(x or 0, y or 0, z or 0)
        end
    end
end

function TeleportToCoin(x, y, z)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local coinServer = workspace:FindFirstChild("Coin_Server")
    if not coinServer then
        return
    end

    local coins = {}
    for _, coin in ipairs(coinServer:GetChildren()) do
        if coin:IsA("BasePart") then
            table.insert(coins, coin)
        end
    end

    if #coins == 0 then
        return
    end

    local targetCoin = coins[math.random(1, #coins)]
    local targetPos = targetCoin.Position + Vector3.new(x or 0, y or 5, z or 0)

    humanoidRootPart.CFrame = CFrame.new(targetPos)
end

function TeleportToMap(x, y, z)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local spawnParts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Spawn" then
            local isInLobby = false
            local parent = obj.Parent
            while parent ~= nil do
                if (parent.Name == "Lobby" or parent.Name == "RegularLobby") and parent.Parent == workspace then
                    isInLobby = true
                    break
                end
                parent = parent.Parent
            end

            if not isInLobby then
                table.insert(spawnParts, obj)
            end
        end
    end

    if #spawnParts == 0 then
        return
    end

    local randomIndex = math.random(1, #spawnParts)
    local randomSpawn = spawnParts[randomIndex]

    humanoidRootPart.CFrame = randomSpawn.CFrame * CFrame.new(x or 0, y or 5, z or 0)
end

function TeleportToLobby(x, y, z)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local lobby = workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("RegularLobby")
    if not lobby then
        return
    end

    local spawns = lobby:FindFirstChild("Spawns")
    if not spawns then
        return
    end

    local spawnLocations = {}
    for _, obj in pairs(spawns:GetChildren()) do
        if obj:IsA("SpawnLocation") then
            table.insert(spawnLocations, obj)
        end
    end

    if #spawnLocations == 0 then
        return
    end

    local randomIndex = math.random(1, #spawnLocations)
    local randomSpawn = spawnLocations[randomIndex]

    humanoidRootPart.CFrame = randomSpawn.CFrame * CFrame.new(x or 0, y or 3, z or 0)
end

function TeleportToInnocent(x, y, z)
    local murderer = GetMurderer()
    local sheriff = GetSheriff()

    local innocents = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr ~= murderer and plr ~= sheriff and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hasKnife = plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife"))
            local hasGun = plr.Backpack:FindFirstChild("Gun") or (plr.Character and plr.Character:FindFirstChild("Gun"))
            if not hasKnife and not hasGun then
                table.insert(innocents, plr)
            end
        end
    end

    if #innocents > 0 then
        local randomInnocent = innocents[math.random(1, #innocents)]
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = randomInnocent.Character.HumanoidRootPart.CFrame * CFrame.new(x or 0, y or 0, z or 0)
        end
    end
end

function TeleportToMurderer(x, y, z)
    local murderer = GetMurderer()
    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame * CFrame.new(x or 0, y or 0, z or 0)
        end
    end
end

function TeleportToSheriff(x, y, z)
    local sheriff = GetSheriff()
    if sheriff and sheriff.Character and sheriff.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = sheriff.Character.HumanoidRootPart.CFrame * CFrame.new(x or 0, y or 0, z or 0)
        end
    end
end

function TeleportToSecurityPart(x, y, z)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local securityParts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "SecurityPart" and obj:IsA("BasePart") then
            table.insert(securityParts, obj)
        end
    end

    if #securityParts == 0 then
        return
    end

    local randomIndex = math.random(1, #securityParts)
    local targetPart = securityParts[randomIndex]

    humanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(x or 0, y or 3, z or 0)
end

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport to Player",
    Desc = "Teleport to the selected player",
    Icon = "user",
    Callback = function()
        TeleportToPlayer(0, 0, 0)
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport to Random Player",
    Desc = "Teleport to a random player in the server",
    Icon = "users",
    Callback = function()
        TeleportToRandomPlayer(0, 0, 0)
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport to Innocent",
    Desc = "Teleport to a random innocent player",
    Icon = "user",
    Callback = function()
        TeleportToInnocent(0, 0, 0)
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport to Murderer",
    Icon = "user-x",
    Callback = function()
        TeleportToMurderer(0, 0, 0)
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport to Sheriff",
    Icon = "user-check",
    Callback = function()
        TeleportToSheriff(0, 0, 0)
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport to Dropped Gun",
    Icon = "target",
    Callback = function()
        GunTP()
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport to Coin",
    Icon = "dollar-sign",
    Callback = function()
        TeleportToCoin(0, 5, 0)
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport to Map",
    Icon = "map",
    Callback = function()
        TeleportToMap(0, 5, 0)
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport Above Map",
    Desc = "Teleport high above a random map spawn",
    Icon = "arrow-up",
    Callback = function()
        TeleportToMap(0, 950, 0)
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport to Lobby",
    Icon = "home",
    Callback = function()
        TeleportToLobby(0, 3, 0)
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Teleport to SecurityPart",
    Desc = "Teleport to Safe Spot",
    Icon = "shield",
    Callback = function()
        TeleportToSecurityPart(0, 3, 0)
    end
})

Players.PlayerAdded:Connect(function()
    UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(function()
    UpdatePlayerList()
end)

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    setupCharacter(newCharacter)
end)

local Troll = loadstring(game:HttpGet("https://darahub.pages.dev/Module/Troll-Stuffs.lua"))()
Troll(Tabs)

Tabs.Misc:Section({ Title = "Misc", TextSize = 40 })
Tabs.Misc:Divider()

AntiAFKConnection = nil

startAntiAFK = function()
    AntiAFKConnection = LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

stopAntiAFK = function()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
end

AntiAFKToggle = Tabs.Misc:Toggle({
    Title = "Anti AFK",
    Flag = "AntiAFKToggle",
    Value = AntiAFK,
    Callback = function(state)
        if state then
            startAntiAFK()
        else
            stopAntiAFK()
        end
    end
})

Tabs.Misc:Section({ Title = "Auto Glitch Vote Map", TextSize = 20 })
Tabs.Misc:Divider()

AutoVote = {
    Enabled = false,
    MapType = 1,
    Connection = nil
}

function findVotePadContainer()
    local possibleLocations = {
        workspace:FindFirstChild("Lobby"),
        workspace:FindFirstChild("MapVote"),
        workspace:FindFirstChild("VotePad"),
        workspace
    }
    for _, location in pairs(possibleLocations) do
        if location then
            local mapVote = location:FindFirstChild("MapVote")
            if mapVote then
                return mapVote
            end
            local testPad = location:FindFirstChild("VotePad1")
            if testPad then
                return location
            end
        end
    end
    for _, child in pairs(workspace:GetChildren()) do
        local votePad = child:FindFirstChild("VotePad1")
        if votePad then
            return child
        end
    end
    return nil
end

function findAvailableVotePad()
    local votePadContainer = findVotePadContainer()
    if not votePadContainer then
        return nil, nil
    end
    local targetPad = votePadContainer:FindFirstChild("VotePad" .. AutoVote.MapType)
    if targetPad then
        return targetPad, AutoVote.MapType, votePadContainer
    end
    for i = 1, 10 do
        local pad = votePadContainer:FindFirstChild("VotePad" .. i)
        if pad then
            AutoVote.MapType = i
            return pad, i, votePadContainer
        end
    end
    return nil, nil, votePadContainer
end

function killYourself()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end

function teleportToVotePad()
    if not AutoVote.Enabled then
        return
    end
    local votePadModel, currentMapType = findAvailableVotePad()
    if not votePadModel then
        return
    end
    local mapInfoGui = votePadModel:FindFirstChild("MapInfoGui")
    if not mapInfoGui then
        return
    end
    local mapIcon = mapInfoGui:FindFirstChild("MapIcon")
    if not mapIcon or not mapIcon:IsA("ImageLabel") then
        return
    end
    local imageId = mapIcon.Image
    if imageId == "" or imageId == "rbxasset://textures/UI/ImagePlaceholder.png" then
        return
    end
    local primaryPart = votePadModel.PrimaryPart
    if not primaryPart then
        primaryPart = votePadModel:FindFirstChildWhichIsA("BasePart")
    end
    if primaryPart then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local teleportPosition = primaryPart.Position + Vector3.new(0, 3, 0)
            humanoidRootPart.CFrame = CFrame.new(teleportPosition)
            task.wait(0.4)
            killYourself()
        end
    end
end

function voteLoop()
    while AutoVote.Enabled do
        teleportToVotePad()
        task.wait()
    end
end

Tabs.Misc:Toggle({
    Title = "Auto Vote Teleport",
    Flag = "VoteGlitch",
    Value = AutoVote.Enabled,
    Callback = function(state)
        AutoVote.Enabled = state
        if state then
            if AutoVote.Connection then
                task.cancel(AutoVote.Connection)
            end
            AutoVote.Connection = task.spawn(voteLoop)
        else
            if AutoVote.Connection then
                task.cancel(AutoVote.Connection)
            end
            AutoVote.Connection = nil
        end
    end
})

Tabs.Misc:Dropdown({
    Title = "Map Selection",
    Values = {"Map 1", "Map 2", "Map 3"},
    Value = "Map 1",
    Flag = "VoteMapGlitchType",
    Callback = function(mode)
        local mapNumber = tonumber(mode:match("%d+"))
        if mapNumber then
            AutoVote.MapType = mapNumber
            local votePadContainer = findVotePadContainer()
            if votePadContainer then
                local pad = votePadContainer:FindFirstChild("VotePad" .. AutoVote.MapType)
                if not pad then
                    for i = 1, 10 do
                        pad = votePadContainer:FindFirstChild("VotePad" .. i)
                        if pad then
                            AutoVote.MapType = i
                            break
                        end
                    end
                end
            end
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    character:WaitForChild("Humanoid")
    if AutoVote.Enabled then
        teleportToVotePad()
    end
end)

if AutoVote.Enabled then
    AutoVote.Connection = task.spawn(voteLoop)
end

if not workspace:FindFirstChild("SecurityPart") then
    local SecurityPart = Instance.new("Part")
    SecurityPart.Name = "SecurityPart"
    SecurityPart.Size = Vector3.new(1000, 1, 1000)
    SecurityPart.Position = Vector3.new(50000, 50000, 50000)
    SecurityPart.Anchored = true
    SecurityPart.CanCollide = true
    SecurityPart.Parent = workspace
end

function startExpFarm()
    local securityPart = workspace:FindFirstChild("SecurityPart")
    if not securityPart then
        print("SecurityPart not found")
        return
    end
    ExpFarmConnection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if character and rootPart then
            rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
        end
    end)
end

function stopExpFarm()
    if ExpFarmConnection then
        ExpFarmConnection:Disconnect()
        ExpFarmConnection = nil
    end
end

local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

COIN_TAG = "Coin_Server"
for _, coin in ipairs(workspace:GetDescendants()) do
    if coin.Name == "Coin_Server" and coin:IsA("BasePart") then
        CollectionService:AddTag(coin, COIN_TAG)
    end
end

coinsCache = CollectionService:GetTagged(COIN_TAG)

AutoFarm = {
    Enabled = false,
    CoinCollectType = "Nearby",
    FullBagAction = "Reset",
    TweenSpeed = 20,
    TeleportDelay = 2,
    UndergroundFarm = false,
    AutoFarmType = "Tween"
}

local currentCoins = 0
local maxCoins = 0
local lastCacheUpdate = 0
local CACHE_UPDATE_INTERVAL = 0.5
local coinCache = {}
local moving = false
local currentTarget = nil
local currentTween = nil
local lastTeleportTime = 0
local isLaying = false
local layConnection = nil
local originalPlatformStand = false
local autoFarmLoopConnection = nil
local endRoundShootConnection = nil
local endRoundShootEnabled = false
local safeSpotPosition = nil

function GetSafeSpot()
    if not safeSpotPosition then
        local securityPart = workspace:FindFirstChild("SecurityPart")
        if securityPart then
            safeSpotPosition = securityPart.CFrame + Vector3.new(0, 3, 0)
        else
            safeSpotPosition = CFrame.new(50000, 50000, 50000)
        end
    end
    return safeSpotPosition
end

function TeleportToSafeSpot()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = GetSafeSpot()
    end
end

function toggleLay(state)
    isLaying = state
    if state and not IsPlayerDead() then
        originalPlatformStand = Humanoid.PlatformStand
        Humanoid.Sit = true
        Humanoid.PlatformStand = true
        local currentPos = HumanoidRootPart.Position
        HumanoidRootPart.CFrame = CFrame.new(currentPos) * CFrame.Angles(math.pi * 0.5, 0, 0)
        for _, anim in ipairs(Humanoid:GetPlayingAnimationTracks()) do
            anim:Stop()
        end
        if layConnection then layConnection:Disconnect() end
        layConnection = RunService.Heartbeat:Connect(function()
            if isLaying and HumanoidRootPart then
                local currentPos = HumanoidRootPart.Position
                HumanoidRootPart.CFrame = CFrame.new(currentPos) * CFrame.Angles(math.pi * 0.5, 0, 0)
            end
        end)
    else
        if layConnection then
            layConnection:Disconnect()
            layConnection = nil
        end
        Humanoid.Sit = false
        Humanoid.PlatformStand = originalPlatformStand
        local currentPos = HumanoidRootPart.Position
        HumanoidRootPart.CFrame = CFrame.new(currentPos)
    end
end

function isCoinCollected(coin)
    return coin:GetAttribute("Collected") == true
end

function isFullCoinBag()
    return currentCoins >= maxCoins and maxCoins > 0
end

function ResetCoinBag()
    currentCoins = 0
    maxCoins = 0
end

function stopCurrentTween()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if HumanoidRootPart then
        HumanoidRootPart.Anchored = false
    end
    moving = false
    currentTarget = nil
end

function TeleportToLobby()
    local lobby = workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("RegularLobby")
    if not lobby then return end
    local spawns = lobby:FindFirstChild("Spawns")
    if not spawns then return end
    local spawnLocations = {}
    for _, obj in pairs(spawns:GetChildren()) do
        if obj:IsA("SpawnLocation") then
            table.insert(spawnLocations, obj)
        end
    end
    if #spawnLocations == 0 then return end
    local randomSpawn = spawnLocations[math.random(1, #spawnLocations)]
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = randomSpawn.CFrame + Vector3.new(0, 3, 0)
    end
end

function startEndRoundShoot()
    if endRoundShootConnection then endRoundShootConnection:Disconnect() end
    endRoundShootEnabled = true
    endRoundShootConnection = RunService.Heartbeat:Connect(function()
        if endRoundShootEnabled then
            if IsPlayerDead() then
                stopEndRoundShoot()
                ResetCoinBag()
                return
            end
            local murderer = GetMurderer()
            if murderer and murderer.Character and murderer.Character:FindFirstChild("Humanoid") and murderer.Character.Humanoid.Health > 0 then
                TeleportToSafeSpot()
                task.wait(0.1)
                ShootMurderer()
            end
            task.wait(2)
        end
    end)
end

function stopEndRoundShoot()
    endRoundShootEnabled = false
    if endRoundShootConnection then
        endRoundShootConnection:Disconnect()
        endRoundShootConnection = nil
    end
end

function handleFullBag()
    if AutoFarm.FullBagAction == "Reset" then
        if isLaying then
            toggleLay(false)
        end
        if Humanoid and Humanoid.Health > 0 then
            Humanoid.Health = 0
        end
    elseif AutoFarm.FullBagAction == "Teleport to lobby" then
        stopCurrentTween()
        if isLaying then
            toggleLay(false)
        end
        TeleportToLobby()
    elseif AutoFarm.FullBagAction == "End Round" then
        if isLaying then
            toggleLay(false)
        end
        local playerRole = nil
        if GetPlayerRole then
            playerRole = GetPlayerRole(LocalPlayer.Name)
        elseif LocalPlayer:FindFirstChild("Role") then
            playerRole = LocalPlayer.Role.Value
        elseif LocalPlayer:FindFirstChild("PlayerRole") then
            playerRole = LocalPlayer.PlayerRole.Value
        end
        if playerRole == "Innocent" then
            FlingRole("Murderer")
        elseif playerRole == "Hero" or playerRole == "Sheriff" then
            MagicBulletEnabled = true
            startEndRoundShoot()
        elseif playerRole == "Murderer" or playerRole == "Assassin" then
            if KnifeCombat and KnifeCombat.killAll then
                KnifeCombat.killAll()
            end
        end
    end
end

workspace.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "Coin_Server" and descendant:IsA("BasePart") then
        CollectionService:AddTag(descendant, COIN_TAG)
        if not isCoinCollected(descendant) then
            table.insert(coinsCache, descendant)
        end
    end
end)

workspace.DescendantRemoving:Connect(function(descendant)
    if descendant.Name == "Coin_Server" and descendant:IsA("BasePart") then
        CollectionService:RemoveTag(descendant, COIN_TAG)
        local index = table.find(coinsCache, descendant)
        if index then
            table.remove(coinsCache, index)
        end
        if currentTarget == descendant then
            currentTarget = nil
        end
    end
end)

attributeChangedConnections = {}
function monitorCoinAttributes(coin)
    local conn = coin.AttributeChanged:Connect(function(attributeName)
        if attributeName == "Collected" and coin:GetAttribute("Collected") == true then
            local index = table.find(coinsCache, coin)
            if index then
                table.remove(coinsCache, index)
            end
            if currentTarget == coin then
                currentTarget = nil
            end
        end
    end)
    attributeChangedConnections[coin] = conn
end

for _, coin in ipairs(coinsCache) do
    monitorCoinAttributes(coin)
end

remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Gameplay"):WaitForChild("CoinCollected")

remote.OnClientEvent:Connect(function(coinType, currentCoin, maxCoin, data)
    currentCoins = currentCoin    maxCoins = maxCoin
    if AutoFarm.Enabled and currentCoins >= maxCoins and maxCoins > 0 then
        stopCurrentTween()
        handleFullBag()
    end
end)

function updateCoinCacheList()
    coinCache = {}
    for _, coin in ipairs(coinsCache) do
        if coin and coin.Parent and not isCoinCollected(coin) then
            table.insert(coinCache, coin)
        end
    end
end

function findNearestCoinOptimized()
    updateCoinCacheList()
    if #coinCache == 0 then return nil end
    local nearest = nil
    local minDist = math.huge
    local rootPos = HumanoidRootPart.Position
    for _, coin in ipairs(coinCache) do
        local dist = (coin.Position - rootPos).Magnitude
        if dist < minDist then
            minDist = dist
            nearest = coin
        end
    end
    return nearest
end

function findRandomCoinOptimized()
    updateCoinCacheList()
    if #coinCache == 0 then return nil end
    return coinCache[math.random(1, #coinCache)]
end

function getTargetCoin()
    if AutoFarm.CoinCollectType == "Nearby" then
        return findNearestCoinOptimized()
    elseif AutoFarm.CoinCollectType == "Random" then
        return findRandomCoinOptimized()
    else
        return findNearestCoinOptimized()
    end
end

function teleportToTarget(target)
    if IsPlayerDead() then ResetCoinBag() return end
    if isFullCoinBag() then return end
    if not target or not target.Parent or isCoinCollected(target) then return end
    local currentTime = tick()
    if currentTime - lastTeleportTime < AutoFarm.TeleportDelay then
        task.wait(AutoFarm.TeleportDelay - (currentTime - lastTeleportTime))
    end
    local targetPos = target.Position + Vector3.new(0, 3, 0)
    if AutoFarm.UndergroundFarm then
        targetPos = target.Position + Vector3.new(0, -2, 0)
    end
    HumanoidRootPart.CFrame = CFrame.new(targetPos)
    if AutoFarm.UndergroundFarm and isLaying then
        HumanoidRootPart.CFrame = CFrame.new(targetPos) * CFrame.Angles(math.pi * 0.5, 0, 0)
    end
    lastTeleportTime = tick()
end

function tweenToTarget(target)
    if IsPlayerDead() then ResetCoinBag() return end
    if isFullCoinBag() then return end
    if not target or not target.Parent or isCoinCollected(target) then return end
    stopCurrentTween()
    if AutoFarm.UndergroundFarm and not isLaying then
        toggleLay(true)
    end
    HumanoidRootPart.Anchored = true
    local targetPos = target.Position + Vector3.new(0, 3, 0)
    if AutoFarm.UndergroundFarm then
        targetPos = target.Position + Vector3.new(0, -0.5, 0)
    end
    local targetCFrame
    if AutoFarm.UndergroundFarm and isLaying then
        targetCFrame = CFrame.new(targetPos) * CFrame.Angles(math.pi * 0.5, 0, 0)
    else
        targetCFrame = CFrame.new(targetPos)
    end
    local distance = (targetPos - HumanoidRootPart.Position).Magnitude
    local duration = distance / AutoFarm.TweenSpeed
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {CFrame = targetCFrame}
    currentTween = TweenService:Create(HumanoidRootPart, tweenInfo, goal)
    currentTween.Completed:Connect(function()
        HumanoidRootPart.Anchored = false
        moving = false
        currentTarget = nil
        if AutoFarm.UndergroundFarm and isLaying then
            local currentPos = HumanoidRootPart.Position
            HumanoidRootPart.CFrame = CFrame.new(currentPos) * CFrame.Angles(math.pi * 0.5, 0, 0)
        end
    end)
    currentTween:Play()
    moving = true
    currentTarget = target
end

function startAutoFarmLoop()
    if autoFarmLoopConnection then return end
    autoFarmLoopConnection = RunService.Heartbeat:Connect(function()
        if IsPlayerDead() then ResetCoinBag() return end
        if isFullCoinBag() then return end
        if not AutoFarm.Enabled then
            stopCurrentTween()
            if isLaying then
                toggleLay(false)
            end
        elseif not moving then
            local target = getTargetCoin()
            if target and not isCoinCollected(target) then
                if AutoFarm.AutoFarmType == "Teleport" then
                    teleportToTarget(target)
                elseif AutoFarm.AutoFarmType == "Tween" then
                    tweenToTarget(target)
                end
            end
        end
    end)
end

function stopAutoFarmLoop()
    if autoFarmLoopConnection then
        autoFarmLoopConnection:Disconnect()
        autoFarmLoopConnection = nil
    end
    stopCurrentTween()
    if isLaying then
        toggleLay(false)
    end
end

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    setupCharacter(newCharacter)
    stopCurrentTween()
    stopEndRoundShoot()
    ResetCoinBag()
    if isLaying then
        toggleLay(false)
    end
    coinCache = {}
    lastCacheUpdate = 0
end)

local connection
local Enabled = true

local function GetCoinContainer()
    for _, v in pairs(workspace:GetChildren()) do
        local coinContainer = v:FindFirstChild("CoinContainer") or v:FindFirstChild("CoinsAreas")
        if coinContainer then
            return coinContainer
        end
    end
end

local function CollectAllCoins()
    local CoinContainer = GetCoinContainer()
    if not CoinContainer then return end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart

    for _, coin in pairs(CoinContainer:GetChildren()) do
        if coin.Name == "Coin_Server" and coin:FindFirstChildWhichIsA("TouchTransmitter") and coin:FindFirstChild("CoinVisual") then
            firetouchinterest(hrp, coin, 1)
            firetouchinterest(hrp, coin, 0)
        end
    end
end

local function StartCoinAura()
    if connection then connection:Disconnect() end
    connection = RunService.Heartbeat:Connect(function()
        if Enabled then
            CollectAllCoins()
        end
    end)
end

local function StopCoinAura()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

Tabs.Misc:Section({ Title = "Auto Farm", TextSize = 20 })
Tabs.Misc:Divider()

autoFarmToggle = Tabs.Misc:Toggle({
    Title = "Enable Auto Farm",
    Flag = "AutoFarm",
    Value = false,
    Callback = function(state)
        AutoFarm.Enabled = state
        if state then
            AntiAFKToggle:Set(true)
            startAutoFarmLoop()
        else
            stopAutoFarmLoop()
            stopEndRoundShoot()
        end
    end
})

coinCollectTypeDropdown = Tabs.Misc:Dropdown({
    Title = "Coin Collect Type",
    Values = {"Nearby", "Random"},
    Flag = "coinCollectTypeDropdown",
    Value = "Nearby",
    Callback = function(value)
        AutoFarm.CoinCollectType = value
        currentTarget = nil
    end
})

autoFarmTypeDropdown = Tabs.Misc:Dropdown({
    Title = "Auto Farm Type",
    Values = {"Teleport", "Tween"},
    Flag = "autoFarmTypeDropdown",
    Value = "Tween",
    Callback = function(value)
        AutoFarm.AutoFarmType = value
        stopCurrentTween()
        if not AutoFarm.UndergroundFarm and isLaying then
            toggleLay(false)
        end
    end
})

fullBagActionDropdown = Tabs.Misc:Dropdown({
    Title = "Action Do when full bag",
    Values = {"Reset", "Teleport to lobby", "End Round"},
    Value = "Reset",
    Flag = "fullBagActionDropdown",
    Callback = function(value)
        AutoFarm.FullBagAction = value
    end
})

undergroundFarmToggle = Tabs.Misc:Toggle({
    Title = "Underground Farm",
    Description = "Farm coins underground and lay down",
    Value = false,
    Flag = "undergroundFarmToggle",
    Type = "Checkbox",
    Callback = function(state)
        AutoFarm.UndergroundFarm = state
        if state and AutoFarm.Enabled and AutoFarm.AutoFarmType == "Tween" then
            toggleLay(true)
        elseif not state and isLaying then
            toggleLay(false)
        end
    end
})

tweenSpeedInput = Tabs.Misc:Input({
    Title = "Farm Speed",
    Placeholder = "Speed for movement",
    Flag = "tweenSpeedInput",
    Value = "20",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            AutoFarm.TweenSpeed = num
        end
    end
})

teleportDelayInput = Tabs.Misc:Input({
    Title = "Teleport Delay (seconds)",
    Placeholder = "Too low = kick",
    Flag = "teleportDelayInput",
    Value = "2",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 then
            AutoFarm.TeleportDelay = num
        end
    end
})

CoinAura = Tabs.Misc:Toggle({
    Title = "Coin Aura",
    Value = false,
    Flag = "CoinAura",
    Callback = function(state)
        if state then
            StartCoinAura() 
        else
            StopCoinAura() 
        end
    end
})

ExpFarmToggle = Tabs.Misc:Toggle({
    Title = "Exp Farm",
    Flag = "ExpFarmToggle",
    Value = false,
    Callback = function(state)
        if state then
            startExpFarm()
        else
            stopExpFarm()
        end
    end
})

function getPlayerRole(playerName)
    return GetPlayerRole(playerName)
end

Tabs.Misc:Section({ Title = "Role Revealer", TextSize = 20 })
Tabs.Misc:Divider()

Tabs.Misc:Button({
    Title = "Reveal Murderer",
    Desc = "Reveal murderer in chat",
    Icon = "user-x",
    Callback = function()
        local textchannels = game:GetService("TextChatService"):WaitForChild("TextChannels"):GetChildren()
        for _, textchannel in ipairs(textchannels) do
            if textchannel.Name == "RBXSystem" then continue end
            local murd = GetMurderer()
            if murd then
                local message = string.format("%s Is Murderer", murd.Name)
                textchannel:SendAsync(message)
            else
                local message = "No Murderer Found"
                textchannel:SendAsync(message)
            end
        end
    end
})

Tabs.Misc:Button({
    Title = "Reveal Sheriff/Hero",
    Desc = "Reveal sheriff or hero in chat",
    Icon = "user-check",
    Callback = function()
        local textchannels = game:GetService("TextChatService"):WaitForChild("TextChannels"):GetChildren()
        for _, textchannel in ipairs(textchannels) do
            if textchannel.Name == "RBXSystem" then continue end
            local sher = GetSheriff()
            local hero = GetHero()
            if sher then 
                local message = string.format("%s Is Sheriff", sher.Name)
                textchannel:SendAsync(message)
            elseif hero then
                local message = string.format("%s Is Hero", hero.Name)
                textchannel:SendAsync(message)
            else
                local message = "No Sheriff/Hero Found"
                textchannel:SendAsync(message)
            end
        end
    end
})

Tabs.Misc:Button({
    Title = "Trade Helper",
    Compact = true,
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/8LDyigix"))()
        WindUI:Notify({ Title = "Trade Helper", Content = "Script loaded!", Duration = 3 })
    end
})

Tabs.Misc:Space()
BombDelay = 20
isBombCooldown = false
bombButton = nil
cooldownConnection = nil
startTime = 0

function hasFakeBomb()
    local player = LocalPlayer
    if player.Character and player.Character:FindFirstChild("FakeBomb") then
        return true
    end
    if player.Backpack:FindFirstChild("FakeBomb") then
        return true
    end
    local toys = player.Backpack:FindFirstChild("Toys")
    if toys and toys:FindFirstChild("FakeBomb") then
        return true
    end
    return false
end

function DropFakeBomb()
    local player = LocalPlayer
    local backpack = player.Backpack
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or not humanoid then return end

    local bomb = backpack:FindFirstChild("FakeBomb") or char:FindFirstChild("FakeBomb")
    if not bomb then
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes.Extras then
            remotes.Extras.ReplicateToy:InvokeServer("FakeBomb")
        end
        bomb = backpack:WaitForChild("FakeBomb", 2) or char:WaitForChild("FakeBomb", 2)
    end
    if not bomb then return end

    bomb.Parent = char
    if bomb:IsDescendantOf(char) and bomb.Remote then
        bomb.Remote:FireServer(root.CFrame * CFrame.new(0, -3, 0), 50)
        task.wait(0.05)
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        local oldJump = humanoid.JumpPower
        humanoid.JumpPower = 53
        task.wait(0.3)
        bomb.Parent = backpack
        humanoid.JumpPower = oldJump
    end
end

function startCooldown()
    if cooldownConnection then
        cooldownConnection:Disconnect()
    end
    startTime = tick()
    if bombButton then
        bombButton:SetText("Bomb cooldown " .. BombDelay .. "s")
    end
    cooldownConnection = RunService.Stepped:Connect(function()
        if isBombCooldown then
            local elapsed = tick() - startTime
            local remaining = BombDelay - elapsed
            if remaining <= 0 then
                isBombCooldown = false
                if bombButton then
                    bombButton:SetText("Bomb MLG")
                end
                if cooldownConnection then
                    cooldownConnection:Disconnect()
                    cooldownConnection = nil
                end
            else
                if bombButton then
                    bombButton:SetText("Bomb cooldown " .. math.ceil(remaining) .. "s")
                end
            end
        elseif cooldownConnection then
            cooldownConnection:Disconnect()
            cooldownConnection = nil
        end
    end)
end

bombButton = ButtonLib.Create:Button({
    Text = "Bomb MLG",
    Flag = "BombMLG",
    Visible = false,
    Callback = function()
        if isBombCooldown then return end
        if not hasFakeBomb() then
            bombButton:SetText("You Don't Have Fake Bomb")
            task.wait(3)
            bombButton:SetText("Bomb MLG")
            return
        end
        DropFakeBomb()
        isBombCooldown = true
        startCooldown()
    end
})
bombButton.Position = UDim2.new(0.5, -125, 0.35, 0)

ShowBombMLGButtonToggle = Tabs.Misc:Toggle({
    Title = "Show Bomb MLG Button",
    Flag = "ShowBombMLGButtonToggle",
    Value = false,
    Callback = function(state)
        if bombButton then
            bombButton:SetVisible(state)
        end
    end
})

FakeBombKeybind = Tabs.Misc:Keybind({
    Title = "Bomb MLG Keybind",
    Value = "",
    Flag = "FakeBombKeybind",
    Callback = function()
        if not hasFakeBomb() then
            WindUI:Notify({
                Title = "Fake Bomb",
                Content = "You don't have Fake Bomb",
                Duration = 3
            })
            return
        end
        if isBombCooldown then
            local remaining = BombDelay - (tick() - startTime)
            WindUI:Notify({
                Title = "Fake Bomb",
                Content = ("Bomb on cooldown " .. math.ceil(remaining) .. "s"),
                Duration = 3
            })
            return
        end
        DropFakeBomb()
        isBombCooldown = true
        startCooldown()
    end
})

Tabs.Utility:Space()
Tabs.Utility:Toggle({
    Title = "Disable Invisible Walls",
    Desc = "Disables collision on all invisible walls",
    Value = false,
    Callback = function(state)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Transparency >= 0.9 then
                obj.CanCollide = not state
            end
        end
    end
})

Tabs.Utility:Space()
Tabs.Utility:Button({
    Title = "Unlock all emote",
    Callback = function()
        for i in pairs(require(game:GetService("ReplicatedStorage").Database.Sync).Emotes) do firesignal(game:GetService("ReplicatedStorage").Remotes.Inventory.ChangeInventoryItem.OnClientEvent,  "Emotes", i, 1) end
end
})

local emoteInputValue = ""

Tabs.Utility:Space()
Tabs.Utility:Input({
    Title = "Emote Name",
    Placeholder = "Enter emote name",
    Callback = function(emoteName)
        emoteInputValue = emoteName
    end
})

Tabs.Utility:Button({
    Title = "Play Emote By Name",
    Callback = function()
        if emoteInputValue and emoteInputValue ~= "" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire(emoteInputValue)
        end
    end
})

local hiddenfling = false
local movel = 0.1
local flingPower = 1e35
local flingCoroutine = nil

function fling()
    local chr = LocalPlayer.Character
    if not chr then return end
    local hrp = chr:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    while hiddenfling and chr and hrp and hrp.Parent do
        local vel = hrp.Velocity
        hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
        RunService.RenderStepped:Wait()
        hrp.Velocity = vel
        RunService.Stepped:Wait()
        hrp.Velocity = vel + Vector3.new(0, movel, 0)
        movel = -movel
        RunService.Heartbeat:Wait()
    end
end

function startFling()
    if flingCoroutine then
        coroutine.close(flingCoroutine)
        flingCoroutine = nil
    end
    flingCoroutine = coroutine.create(fling)
    coroutine.resume(flingCoroutine)
end

function stopFling()
    if flingCoroutine then
        coroutine.close(flingCoroutine)
        flingCoroutine = nil
    end

    local chr = LocalPlayer.Character
    if chr then
        local hrp = chr:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end

Tabs.Utility:Space()
TouchFlingToggle = Tabs.Utility:Toggle({
    Title = "Touch Fling",
    Flag = "TouchFlingToggle",
    Value = false,
    Callback = function(state)
        hiddenfling = state
        if state then
            startFling()
        else
            stopFling()
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function(character)
    if hiddenfling then
        task.wait(1)
        startFling()
    else
        task.wait(0.5)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

Tabs.Utility:Input({
    Title = "Fling Power",
    Flag = "FlingPower",
    Placeholder = "Enter fling power (default: 1e35)",
    Callback = function(value)
        if value and value ~= "" then
            flingPower = tonumber(value) or 1e35
        end
    end
})

Tabs.Utility:Space()
Tabs.Utility:Button({
    Title = "Fling Tool",
    Icon = "rbxassetid://3836615692",
    Callback = function()
        local CharacterModel = LocalPlayer.Character
        local Humanoid = CharacterModel:WaitForChild("Humanoid")
        CharacterModel:WaitForChild("HumanoidRootPart")
        function FindPart(ParentModel, PartName, PartType)
            local FoundPart = nil
            pcall(function()
                local ParentModel = ParentModel
                local Iterator, Table, Key = pairs(ParentModel:GetChildren())
                while true do
                    local Value
                    Key, Value = Iterator(Table, Key)
                    if Key == nil then
                        break
                    end
                    if Value.Name == PartName and Value:IsA(PartType) then
                        FoundPart = Value
                        break
                    end
                end
            end)
            return FoundPart
        end
        local IsEnabled = false
        local RunService = game:GetService("RunService")
        local SteppedEvent = RunService.Stepped
        local HeartbeatEvent = RunService.Heartbeat
        local RenderSteppedEvent = RunService.RenderStepped
        local IsActive = true
        spawn(function()
            local Character = nil
            local Part = nil
            local VelocityMultiplier = 0.1
            while IsActive do
                HeartbeatEvent:Wait()
                if IsEnabled then
                    while IsEnabled and (IsActive and not (Character and (Character.Parent and (Part and Part.Parent)))) do
                        HeartbeatEvent:Wait()
                        Character = LocalPlayer.Character
                        Part = FindPart(Character, "HumanoidRootPart", "BasePart") or (FindPart(Character, "Torso", "BasePart") or FindPart(Character, "UpperTorso", "BasePart"))
                    end
                    if IsActive and IsEnabled then
                        local OriginalVelocity = Part.Velocity
                        Part.Velocity = OriginalVelocity * 100 + Vector3.new(10000, 10000, 0)
                        Part.CFrame = Part.CFrame * CFrame.new(0, 0.001, 0)
                        RenderSteppedEvent:Wait()
                        if Character and (Character.Parent and (Part and Part.Parent)) then
                            Part.Velocity = OriginalVelocity
                        end
                        SteppedEvent:Wait()
                        if Character and (Character.Parent and (Part and Part.Parent)) then
                            Part.Velocity = OriginalVelocity + Vector3.new(0, VelocityMultiplier, 0)
                            VelocityMultiplier = VelocityMultiplier * - 1
                        end
                    end
                end
            end
        end)
        if LocalPlayer.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
            AnimationId = "218504594"
        else
            AnimationId = "674871189"
        end
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://" .. AnimationId
        local LoadedAnimation = LocalPlayer.Character.Humanoid:LoadAnimation(Animation)
        local Tool = Instance.new("Tool", LocalPlayer.Backpack)
        Tool.RequiresHandle = false
        Tool.Name = "Punch Fling"
        Tool.TextureId = "rbxassetid://3836615692"
        Tool.Activated:Connect(function()
            LoadedAnimation:Play()
            IsEnabled = true
            wait(2)
            IsEnabled = false
        end)
        Humanoid.Died:Connect(function()
            IsActive = false
            Tool:Destroy()
            Animation:Destroy()
        end)
    end
})

local flingActive = false
local flingMode = 1
local currentInput = ""
local processedPlayers = {}
local roles = {}
local Murder = nil
local Sheriff = nil
local Hero = nil

function IsAlive(Player)
    for i, v in pairs(roles) do
        if Player.Name == i then
            if not v.Killed and not v.Dead then
                return true
            else
                return false
            end
        end
    end
    return false
end

function updateRoles()
    local success, result = pcall(GetPlayerData)
    if success and result then
        roles = result
        Murder = nil
        Sheriff = nil
        Hero = nil
        for i, v in pairs(roles) do
            if v.Role == "Murderer" then
                Murder = i
            elseif v.Role == 'Sheriff' then
                Sheriff = i
            elseif v.Role == 'Hero' then
                Hero = i
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    updateRoles()
end)

function sortPlayersAlphabetically(players)
    table.sort(players, function(a, b)
        return string.lower(a.Name) < string.lower(b.Name)
    end)
    return players
end

function getPlayers(input)
    local players = {}
    input = string.lower(input or "")

    if input == "all" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(players, player)
            end
        end
        players = sortPlayersAlphabetically(players)
    elseif input == "nonfriends" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local success, isFriend = pcall(function()
                    return player:IsFriendsWith(LocalPlayer.UserId)
                end)
                if not (success and isFriend) then
                    table.insert(players, player)
                end
            end
        end
        players = sortPlayersAlphabetically(players)
    elseif input == "murder" then
        if Murder then
            local murdererPlayer = Players:FindFirstChild(Murder)
            if murdererPlayer and murdererPlayer ~= LocalPlayer and murdererPlayer.Character and IsAlive(murdererPlayer) then
                table.insert(players, murdererPlayer)
            end
        end
    elseif input == "sheriff" or input == "hero" then
        if Sheriff then
            local sheriffPlayer = Players:FindFirstChild(Sheriff)
            if sheriffPlayer and sheriffPlayer ~= LocalPlayer and sheriffPlayer.Character and IsAlive(sheriffPlayer) then
                table.insert(players, sheriffPlayer)
            end
        end
        if Hero then
            local heroPlayer = Players:FindFirstChild(Hero)
            if heroPlayer and heroPlayer ~= LocalPlayer and heroPlayer.Character and IsAlive(heroPlayer) then
                table.insert(players, heroPlayer)
            end
        end
    else
        local searchTerms = {}
        for term in string.gmatch(input, "([^,]+)") do
            term = string.match(term, "^%s*(.-)%s*$")
            if term ~= "" then
                table.insert(searchTerms, term)
            end
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local playerName = string.lower(player.Name)
                local displayName = player.DisplayName and string.lower(player.DisplayName) or ""

                for _, term in ipairs(searchTerms) do
                    if string.find(playerName, term) or string.find(displayName, term) then
                        table.insert(players, player)
                        break
                    end
                end
            end
        end
    end

    return players
end

function SkidFling(TargetPlayer, duration)
    local startTime = tick()
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle

    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end

        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local SFBasePart = function(BasePart)
            local TimeToWait = duration or 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until not flingActive or BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or tick() > Time + TimeToWait
        end

        local previousDestroyHeight = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid

        repeat
            if Character and Humanoid and RootPart and getgenv().OldPos then
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                for _, x in pairs(Character:GetChildren()) do
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
            end
            task.wait()
        until not flingActive or (RootPart and getgenv().OldPos and (RootPart.Position - getgenv().OldPos.p).Magnitude < 25)
        workspace.FallenPartsDestroyHeight = previousDestroyHeight
    end
end

function shhhlol(TargetPlayer)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end

        if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

        function mmmm(comkid, Pos, Ang)
            RootPart.CFrame = CFrame.new(comkid.Position) * Pos * Ang
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        function wtf(comkid)
            local TimeToWait = 0.134
            local Time = tick()

            local Att1 = Instance.new("Attachment", RootPart)
            local Att2 = Instance.new("Attachment", comkid)

            repeat
                if RootPart and THumanoid then
                    if comkid.Velocity.Magnitude < 30 then
                        mmmm(
                            comkid,
                            CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * comkid.Velocity.Magnitude / 5,
                            CFrame.Angles(
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180)
                            )
                        )
                        task.wait()

                        mmmm(
                            comkid,
                            CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * comkid.Velocity.Magnitude / 1.25,
                            CFrame.Angles(
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180)
                            )
                        )
                        task.wait()

                        mmmm(
                            comkid,
                            CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * comkid.Velocity.Magnitude / 1.25,
                            CFrame.Angles(
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180)
                            )
                        )
                        task.wait()
                    else
                        mmmm(comkid, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(0), 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until comkid.Velocity.Magnitude > 1000 or 
                  comkid.Parent ~= TargetPlayer.Character or
                  TargetPlayer.Parent ~= Players or
                  not TargetPlayer.Character == TCharacter or
                  Humanoid.Health <= 0 or
                  tick() > Time + TimeToWait or
                  not flingActive

            Att1:Destroy()
            Att2:Destroy()
        end

        local previousDestroyHeight = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity")
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(-9e99, 9e99, -9e99)
        BV.MaxForce = Vector3.new(-9e9, 9e9, -9e9)

        local BodyGyro = Instance.new("BodyGyro")
        BodyGyro.CFrame = CFrame.new(RootPart.Position)
        BodyGyro.D = 9e8
        BodyGyro.MaxTorque = Vector3.new(-9e9, 9e9, -9e9)
        BodyGyro.P = -9e9

        local BodyPosition = Instance.new("BodyPosition")
        BodyPosition.Position = RootPart.Position
        BodyPosition.D = 9e8
        BodyPosition.MaxForce = Vector3.new(-9e9, 9e9, -9e9)
        BodyPosition.P = -9e9

        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                wtf(THead)
            else
                wtf(TRootPart)
            end
        elseif TRootPart and not THead then
            wtf(TRootPart)
        elseif not TRootPart and THead then
            wtf(THead)
        end

        BV:Destroy()
        BodyGyro:Destroy()
        BodyPosition:Destroy()

        repeat
            if Character and Humanoid and RootPart and getgenv().OldPos then
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                for _, x in pairs(Character:GetDescendants()) do
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
            end
            task.wait()
        until not flingActive or (RootPart and getgenv().OldPos and (RootPart.Position - getgenv().OldPos.p).Magnitude < 25)

        workspace.FallenPartsDestroyHeight = previousDestroyHeight
    end
end

function yeet(targetPlayer)
    local character = LocalPlayer.Character
    local targetCharacter = targetPlayer.Character

    if not character or not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then
        return false
    end

    if character.HumanoidRootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = character.HumanoidRootPart.CFrame
    end

    local existingForce = character.HumanoidRootPart:FindFirstChild("YeetForce")
    if existingForce then
        existingForce:Destroy()
    end

    local Thrust = Instance.new('BodyThrust', character.HumanoidRootPart)
    Thrust.Force = Vector3.new(9999, 9999, 9999)
    Thrust.Name = "YeetForce"

    local previousDestroyHeight = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = 0/0

    local startTime = tick()
    local duration = (currentInput == "all" or currentInput == "nonfriends") and 5 or math.huge

    local yeetConnection
    yeetConnection = RunService.Heartbeat:Connect(function()
        if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") or not flingActive or tick() > startTime + duration then
            yeetConnection:Disconnect()
            Thrust:Destroy()
            workspace.FallenPartsDestroyHeight = previousDestroyHeight

            if character and character.HumanoidRootPart and getgenv().OldPos then
                character.HumanoidRootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                character.Humanoid:ChangeState("GettingUp")
                for _, x in pairs(character:GetDescendants()) do
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
            end
            return
        end

        local targetHRP = targetCharacter.HumanoidRootPart
        local targetVelocity = targetHRP.Velocity
        local speed = targetVelocity.Magnitude
        local direction = targetVelocity.Unit

        local offsetPosition
        if speed > 0.1 then
            offsetPosition = targetHRP.Position + (direction * speed)
        else
            offsetPosition = targetHRP.Position + Vector3.new(0, 0, 0)
        end

        character.HumanoidRootPart.CFrame = CFrame.new(offsetPosition)

        Thrust.Location = targetHRP.Position
    end)

    return true
end

function flingPlayers()
    local players = {}
    for player, _ in pairs(processedPlayers) do
        if player and player.Character and player.Character.Parent ~= nil then
            table.insert(players, player)
        end
    end

    if currentInput == "all" or currentInput == "nonfriends" then
        players = sortPlayersAlphabetically(players)
    end

    for _, player in ipairs(players) do
        if not flingActive then break end

        if player and player.Character and player.Character.Parent ~= nil then
            local duration = (currentInput == "all" or currentInput == "nonfriends") and 1.5 or nil

            if flingMode == 1 then
                SkidFling(player, duration)
            elseif flingMode == 2 then
                shhhlol(player)
            elseif flingMode == 3 then
                yeet(player)
                if currentInput == "all" or currentInput == "nonfriends" then
                    task.wait(1.5)
                end
            end
        end
    end

    if flingActive then
        task.wait()
        flingPlayers()
    end
end

function addPlayerToProcessed(player)
    if not player or player == LocalPlayer then return end

    local matchesFilter = false
    local input = string.lower(currentInput)

    if input == "all" then
        matchesFilter = true
    elseif input == "nonfriends" then
        local success, isFriend = pcall(function()
            return player:IsFriendsWith(LocalPlayer.UserId)
        end)
        matchesFilter = not (success and isFriend)
    elseif input == "murder" then
        if Murder and player.Name == Murder then
            matchesFilter = IsAlive(player)
        end
    elseif input == "sheriff" or input == "hero" then
        if (Sheriff and player.Name == Sheriff) or (Hero and player.Name == Hero) then
            matchesFilter = IsAlive(player)
        end
    else
        local searchTerms = {}
        for term in string.gmatch(input, "([^,]+)") do
            term = string.match(term, "^%s*(.-)%s*$")
            if term ~= "" then
                table.insert(searchTerms, term)
            end
        end

        local playerName = string.lower(player.Name)
        local displayName = player.DisplayName and string.lower(player.DisplayName) or ""

        for _, term in ipairs(searchTerms) do
            if string.find(playerName, term) or string.find(displayName, term) then
                matchesFilter = true
                break
            end
        end
    end

    if matchesFilter then
        processedPlayers[player] = true
    end
end

local flingInputValue = ""

function FlingRole(RoleName)
    if flingActive then
        flingActive = false
        return
    end

    local playersWithRole = {}
    updateRoles()

    for playerName, playerData in pairs(roles) do
        if playerData.Role == RoleName then
            local player = Players:FindFirstChild(playerName)
            if player and player ~= LocalPlayer and player.Character and IsAlive(player) then
                table.insert(playersWithRole, player)
            end
        end
    end

    if #playersWithRole == 0 then
        WindUI:Notify({
            Title = "Fling Role",
            Content = "No " .. RoleName .. " found",
            Duration = 3
        })
        return false
    end

    currentInput = RoleName
    flingActive = true
    processedPlayers = {}

    for _, player in ipairs(playersWithRole) do
        processedPlayers[player] = true
    end

    local targetNames = ""
    for i, player in ipairs(playersWithRole) do
        targetNames = targetNames .. player.Name
        if i < #playersWithRole then
            targetNames = targetNames .. ", "
        end
    end

    WindUI:Notify({
        Title = "Fling Role",
        Content = "Flinging " .. RoleName .. ": " .. targetNames .. " for 10 seconds",
        Duration = 3
    })

    local stopTimer = 10
    local startTime = tick()

    coroutine.wrap(function()
        while flingActive and tick() - startTime < stopTimer do
            task.wait(1)
        end
        if flingActive then
            flingActive = false
            processedPlayers = {}
            if FlingToggle then
                FlingToggle:Set(false)
            end
        end
    end)()

    coroutine.wrap(flingPlayers)()
    return true
end

Tabs.Utility:Space()
FlingInput = Tabs.Utility:Input({
    Title = "Fling Target",
    Flag = "FlingInput",
    Placeholder = "nickname, all, nonfriends, murder, sheriff",
    Callback = function(value)
        flingInputValue = value
        currentInput = string.lower(value)
    end
})

FlingModeDropdown = Tabs.Utility:Dropdown({
    Title = "Fling Mode",
    Flag = "FlingModeDropdown",
    Values = {"SkidFling", "Shhhlol", "Yeet"},
    Value = "SkidFling",
    Callback = function(value)
        if value == "SkidFling" then
            flingMode = 1
        elseif value == "Shhhlol" then
            flingMode = 2
        elseif value == "Yeet" then
            flingMode = 3
        end
    end
})

FlingToggle = Tabs.Utility:Toggle({
    Title = "Fling Players",
    Flag = "FlingToggle",
    Value = false,
    Callback = function(state)
        flingActive = state

        if flingActive then
            currentInput = string.lower(flingInputValue or "")
            local players = getPlayers(currentInput)

            if #players == 0 then
                WindUI:Notify({
                    Title = "Fling Target",
                    Content = "Invalid Input: " .. currentInput,
                    Duration = 3
                })
                flingActive = false
                FlingToggle:Set(false)
                return
            end

            processedPlayers = {}
            for _, player in ipairs(players) do
                addPlayerToProcessed(player)
            end

            WindUI:Notify({
                Title = "Fling Target",
                Content = "Flinging " .. #players .. " players",
                Duration = 3
            })

            coroutine.wrap(flingPlayers)()
        else
            processedPlayers = {}
        end
    end
})

Tabs.Utility:Button({
    Title = "Fling Murderer",
    Callback = function()
        FlingRole("Murderer")
    end
})

Tabs.Utility:Button({
    Title = "Fling Sheriff/Hero",
    Callback = function()
        local sheriff = GetSheriff()
        local hero = GetHero()
        if sheriff then
            FlingRole("Sheriff")
        elseif hero then
            FlingRole("Hero")
        else
            WindUI:Notify({
                Title = "Fling Role",
                Content = "No Hero or Sheriff found",
                Duration = 3
            })
        end
    end
})

Players.PlayerAdded:Connect(function(player)
    if flingActive then
        addPlayerToProcessed(player)
        if player.Character then
            if flingMode == 1 then
                local duration = (currentInput == "all" or currentInput == "nonfriends") and 1.5 or nil
                SkidFling(player, duration)
            elseif flingMode == 2 then
                shhhlol(player)
            elseif flingMode == 3 then
                yeet(player)
            end
        else
            player.CharacterAdded:Connect(function()
                if flingActive then
                    addPlayerToProcessed(player)
                    if flingMode == 1 then
                        local duration = (currentInput == "all" or currentInput == "nonfriends") and 1.5 or nil
                        SkidFling(player, duration)
                    elseif flingMode == 2 then
                        shhhlol(player)
                    elseif flingMode == 3 then
                        yeet(player)
                    end
                end
            end)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if flingActive then
        task.wait(1)
        coroutine.wrap(flingPlayers)()
    end
end)

local antiVoidActive = false
local originalDestroyHeight = workspace.FallenPartsDestroyHeight

function enableAntiVoid()
    if antiVoidActive then return end
    antiVoidActive = true
    originalDestroyHeight = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = -math.huge
end

function disableAntiVoid()
    if not antiVoidActive then return end
    workspace.FallenPartsDestroyHeight = originalDestroyHeight
    antiVoidActive = false
end

Tabs.Utility:Space()
Tabs.Utility:Toggle({
    Title = "Anti Void Damage",
    Flag = "AntiVoid",
    Value = false,
    Callback = function(state)
        if state then
            enableAntiVoid()
        else
            disableAntiVoid()
        end
    end
})

local infinitePositionEnabled = false
local savedPosition = nil
local positionConnection = nil
local positionTolerance = 0.1

function lockPosition()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    if not savedPosition then
        savedPosition = hrp.CFrame
    end

    positionConnection = RunService.Heartbeat:Connect(function()
        if hrp and hrp.Parent and savedPosition then
            if (hrp.Position - savedPosition.Position).Magnitude > positionTolerance then
                hrp.CFrame = savedPosition
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

function unlockPosition()
    if positionConnection then
        positionConnection:Disconnect()
        positionConnection = nil
    end
    savedPosition = nil
end

Tabs.Utility:Space()
InfinitePositionToggle = Tabs.Utility:Toggle({
    Title = "Infinite Position Lock",
    Flag = "InfinitePositionToggle",
    Desc = "Lock your position in place",
    Value = false,
    Callback = function(state)
        infinitePositionEnabled = state
        if state then
            lockPosition()
            LocalPlayer.CharacterAdded:Connect(function()
                if infinitePositionEnabled then
                    task.wait(0.1)
                    lockPosition()
                end
            end)
        else
            unlockPosition()
        end
    end
})

Tabs.Utility:Space()
TimeChangerInput = Tabs.Utility:Input({
    Title = "Set Time (HH:MM)",
    Flag = "TimeChangerInput",
    Placeholder = "12:00",
    Callback = function(value)
        value = value:gsub("^%s*(.-)%s*$", "%1")

        local h_str, m_str = value:match("(%d+):(%d+)")
        if h_str and m_str then
            local h = tonumber(h_str)
            local m = tonumber(m_str)

            if h and m and h >= 0 and h <= 23 and m >= 0 and m <= 59 and #h_str <= 2 and #m_str <= 2 then
                local totalHours = h + (m / 60)
                Lighting.ClockTime = totalHours
            end
        end
    end
})

lagSwitchEnabled = false
lagDuration = 0.5
lagMethod = "CPU Cycle"
local isLagActive = false
local lagSystemLoaded = false

function lag()
    local duration = lagDuration or 0.5
    local method = lagMethod or "CPU Cycle"

    if method == "CPU Cycle" then pcall(function() setfflag("MaxMissedWorldStepsRemembered","1") end)
        local start = tick()
        while tick() - start < duration do
            local a = math.random(1, 1000000) * math.random(1, 1000000)
            a = a / math.random(1, 10000)
        end
    elseif method == "OS.ClockFFlag" then
        pcall(function() setfflag("MaxMissedWorldStepsRemembered","10000001000000") end)
        local start = os.clock()
        while os.clock() - start < duration do
        end
    end
end

function loadLagSystem()
    if lagSystemLoaded then return end
    lagSystemLoaded = true
end

function unloadLagSystem()
    if not lagSystemLoaded then return end
    lagSystemLoaded = false
    isLagActive = false
end

function checkLagState()
    local shouldLoad = lagSwitchEnabled

    if shouldLoad and not lagSystemLoaded then
        loadLagSystem()
    elseif not shouldLoad and lagSystemLoaded then
        unloadLagSystem()
    end
end

Tabs.Utility:Space()
ButtonLib.Create:Button({
    Text = "Lag Switch",
    Flag = "LagSwitch",
    Visible = false,
    Callback = function()
        isLagActive = task.spawn(lag)
    end
}).Position = UDim2.new(0.5, -125, 0.2, 0)

LagSwitchToggle = Tabs.Utility:Toggle({
    Title = "Lag Switch",
    Flag = "LagSwitchToggle",
    Icon = "zap",
    Value = false,
    Callback = function(state)
        lagSwitchEnabled = state

        if ButtonLib and ButtonLib.LagSwitch then
            ButtonLib.LagSwitch:SetVisible(state)
        end

        checkLagState()
    end
})

LagMethodDropdown = Tabs.Utility:Dropdown({
    Title = "Lag Method",
    Flag = "LagMethodDropdown",
    Values = {"CPU Cycle", "OS.ClockFFlag"},
    Value = "CPU Cycle",
    Callback = function(value)
        lagMethod = value
    end
})

LagDurationInput = Tabs.Utility:Input({
    Title = "Lag Duration (seconds)",
    Flag = "LagDurationInput",
    Placeholder = "0.5",
    Value = tostring(lagDuration),
    NumbersOnly = true,
    Callback = function(text)
        local n = tonumber(text)
        if n and n > 0 then
            lagDuration = n
        end
    end
})

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == LocalPlayer then
        unloadLagSystem()
    end
end)

checkLagState()

local originalGameGravity = workspace.Gravity
local CustomGravity = false
local GravityValue = originalGameGravity
local ShowGravityButton = false

Tabs.Utility:Space()

GravityToggle = Tabs.Utility:Toggle({
    Title = "Custom Gravity",
    Flag = "GravityToggle",
    Value = false,
    Callback = function(state)
        CustomGravity = state
        workspace.Gravity = state and GravityValue or originalGameGravity
    end
})

ButtonLib.Create:Toggle({
    Text = "Gravity",
    Flag = "GravityToggle",
    Default = false,
    Visible = false,
    Callback = function(s) 
        if GravityToggle then
            GravityToggle:Set(s)
        end
    end
}).Position = UDim2.new(0.5, -125, 0.4, 0)

ShowGravityButtonToggle = Tabs.Utility:Toggle({
    Title = "Show Gravity Button",
    Flag = "ShowGravityButton",
    Value = false,
    Callback = function(state)
        ShowGravityButton = state
        if ButtonLib and ButtonLib.GravityToggle then
            ButtonLib.GravityToggle:SetVisible(state)
        end
    end
})

GravityInput = Tabs.Utility:Input({
    Title = "Gravity Value",
    Flag = "GravityInput",
    Placeholder = tostring(originalGameGravity),
    Value = tostring(GravityValue),
    Callback = function(text)
        local num = tonumber(text)
        if num then
            GravityValue = num
            if CustomGravity then
                workspace.Gravity = num
            end
        else
            warn("Invalid gravity value entered!")
        end
    end
})

workspace.Gravity = CustomGravity and GravityValue or originalGameGravity

Gravity = Gravity or {
    CustomGravity = false,
    GravityValue = workspace.Gravity
}

Tabs.Utility:Space()
NoRenderToggle = Tabs.Utility:Toggle({
    Title = "No Render",
    Flag = "NoRenderToggle",
    Desc = "Disable 3D rendering for performance",
    Value = false,
    Callback = function(state)
        NoRender = state
        RunService:Set3dRenderingEnabled(not state)

        if state then
            local gui = Instance.new("ScreenGui")
            gui.Name = "NoRenderBackground"
            gui.IgnoreGuiInset = true
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.ResetOnSpawn = false

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = NoRenderColor
            frame.BorderSizePixel = 0
            frame.Parent = gui

            gui.Parent = PlayerGui
        else
            local gui = PlayerGui:FindFirstChild("NoRenderBackground")
            if gui then
                gui:Destroy()
            end
        end
    end
})

Tabs.Utility:Space()
NoRenderColorPicker = Tabs.Utility:Colorpicker({
    Title = "No Render Color",
    Flag = "NoRenderColorPicker",
    Desc = "Choose background color when No Render is enabled",
    Default = Color3.fromRGB(0, 0, 0),
    Transparency = 0,
    Callback = function(color)
        NoRenderColor = color

        if NoRender then
            local gui = PlayerGui:FindFirstChild("NoRenderBackground")
            if gui then
                local frame = gui:FindFirstChildOfClass("Frame")
                if frame then
                    frame.BackgroundColor3 = color
                end
            end
        end
    end
})

RemoveTextures = false

Tabs.Utility:Space()
RemoveTexturesButton = Tabs.Utility:Button({
Title = "Remove Textures",
Callback = function()
for _, part in ipairs(workspace:GetDescendants()) do
if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") or part:IsA("WedgePart") or part:IsA("CornerWedgePart") then
part.Material = Enum.Material.SmoothPlastic

if part:IsA("MeshPart") and part.TextureID ~= "" then
part.TextureID = ""
end

for _, texture in ipairs(part:GetChildren()) do
if texture:IsA("Texture") then
texture.Texture = "rbxassetid://0"
elseif texture:IsA("Decal") then
texture.Texture = "rbxassetid://0"
end
end
end
end

WindUI:Notify({
Title = "Textures Removed",
Content = "All textures and materials have been removed",
Duration = 3
})
end
})
Tabs.Utility:Button({
Title = "Clear MaterialService",
Desc = "Remove All Clear MaterialService Texture",
Callback = function()
local materialService = game:GetService("MaterialService")

for _, child in ipairs(materialService:GetChildren()) do
child:Destroy()
end

WindUI:Notify({
Title = "MaterialService Cleared",
Content = "All materials have been removed from MaterialService",
Duration = 3
})
end
})

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == LocalPlayer then
        RunService:Set3dRenderingEnabled(true)
    end
end)

Tabs.Utility:Space()
LowQualityButton = Tabs.Utility:Button({
    Title = "Low Quality",
    Desc = "Disable textures, effects, and optimize graphics",
    Callback = function()
        local ToDisable = {
            Textures = true,
            VisualEffects = true,
            Parts = true,
            Particles = true,
            Sky = true
        }

        local ToEnable = {
            FullBright = false
        }

        local Stuff = {}

        for _, v in next, game:GetDescendants() do
            if ToDisable.Parts then
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    table.insert(Stuff, 1, v)
                end
            end

            if ToDisable.Particles then
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
                    v.Enabled = false
                    table.insert(Stuff, 1, v)
                end
            end

            if ToDisable.VisualEffects then
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                    table.insert(Stuff, 1, v)
                end
            end

            if ToDisable.Textures then
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Texture = ""
                    table.insert(Stuff, 1, v)
                end
            end

            if ToDisable.Sky then
                if v:IsA("Sky") then
                    v.Parent = nil
                    table.insert(Stuff, 1, v)
                end
            end
        end

        if ToEnable.FullBright then
            local Lighting = game:GetService("Lighting")

            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            Lighting.FogEnd = math.huge
            Lighting.FogStart = math.huge
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 5
            Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Outlines = true
        end
    end
})

local antiFlingEnabled = false
local antiFlingConnection = nil

function setCanCollideOfModelDescendants(model, bval)
    if not model then return end
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = bval
        end
    end
end

function startAntiFling()
    if antiFlingConnection then return end

    antiFlingConnection = RunService.Stepped:Connect(function()
        if antiFlingEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    setCanCollideOfModelDescendants(player.Character, false)
                end
            end
        end
    end)
end

function stopAntiFling()
    if antiFlingConnection then
        antiFlingConnection:Disconnect()
        antiFlingConnection = nil
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            setCanCollideOfModelDescendants(player.Character, true)
        end
    end
end

Tabs.Utility:Space()
AntiFlingToggle = Tabs.Utility:Toggle({
    Title = "Disable Player Collisions",
    Flag = "AntiFlingToggle",
    Value = false,
    Callback = function(state)
        antiFlingEnabled = state
        if state then
            startAntiFling()
        else
            stopAntiFling()
        end
    end
})

local HitboxSettings = {
    Enabled = false,  
    Size = 10,
    ShowVisual = false,   
    VisualColor = Color3.new(1, 0, 0),  
    OriginalSizes = {},   
    VisualAdornments = {} 
}

local function ExpandHitboxes()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local chr = plr.Character
            if chr and HitboxSettings.Enabled then
                local root = chr:FindFirstChild("HumanoidRootPart")
                if root then
                    if HitboxSettings.OriginalSizes[plr] == nil then
                        HitboxSettings.OriginalSizes[plr] = root.Size
                    end
                    root.Size = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                end
            end
        end
    end
end

local function UpdateVisualHitboxes()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local chr = plr.Character
            local visual = HitboxSettings.VisualAdornments[plr]
            if chr and HitboxSettings.ShowVisual and HitboxSettings.Enabled then
                local root = chr:FindFirstChild("HumanoidRootPart")
                if root then
                    if not visual then
                        visual = Instance.new("BoxHandleAdornment")
                        visual.Adornee = root
                        visual.Size = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                        visual.Color3 = HitboxSettings.VisualColor
                        visual.Transparency = 0.3
                        visual.ZIndex = 10
                        visual.AlwaysOnTop = true
                        visual.Parent = root
                        HitboxSettings.VisualAdornments[plr] = visual
                    else
                        visual.Size = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                        visual.Color3 = HitboxSettings.VisualColor
                    end
                end
            elseif visual then
                visual:Destroy()
                HitboxSettings.VisualAdornments[plr] = nil
            end
        end
    end
end

local function ResetHitboxes()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local chr = plr.Character
            if chr then
                local root = chr:FindFirstChild("HumanoidRootPart")
                if root and HitboxSettings.OriginalSizes[plr] then
                    root.Size = HitboxSettings.OriginalSizes[plr]
                elseif root then
                    root.Size = Vector3.new(3, 3, 3) 
                end
            end
        end
    end
    HitboxSettings.OriginalSizes = {}
end

local function ClearVisualAdornments()
    for _, visual in pairs(HitboxSettings.VisualAdornments) do
        if visual then
            pcall(function() visual:Destroy() end)
        end
    end
    HitboxSettings.VisualAdornments = {}
end

Players.PlayerAdded:Connect(function(plr)
    if HitboxSettings.Enabled then
        task.wait(0.5)
        ExpandHitboxes()
        if HitboxSettings.ShowVisual then
            UpdateVisualHitboxes()
        end
    end
    plr.CharacterAdded:Connect(function()
        if HitboxSettings.Enabled then
            task.wait(0.5)
            ExpandHitboxes()
            if HitboxSettings.ShowVisual then
                UpdateVisualHitboxes()
            end
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    HitboxSettings.OriginalSizes[plr] = nil
    if HitboxSettings.VisualAdornments[plr] then
        HitboxSettings.VisualAdornments[plr]:Destroy()
        HitboxSettings.VisualAdornments[plr] = nil
    end
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function()
            if HitboxSettings.Enabled then
                task.wait(0.5)
                ExpandHitboxes()
                if HitboxSettings.ShowVisual then
                    UpdateVisualHitboxes()
                end
            end
        end)
    end
end

RunService.Heartbeat:Connect(function()
    if HitboxSettings.Enabled then
        ExpandHitboxes()
        if HitboxSettings.ShowVisual then
            UpdateVisualHitboxes()
        end
    end
end)

Tabs.Utility:Space()
Tabs.Utility:Toggle({
    Title = "Hitbox Expanding",
    Flag = "HRPscaler",
    Callback = function(state)
        HitboxSettings.Enabled = state
        if state then
            ExpandHitboxes()
            if HitboxSettings.ShowVisual then
                UpdateVisualHitboxes()
            end
        else
            ResetHitboxes()
            ClearVisualAdornments()
        end
    end
})

Tabs.Utility:Slider({
    Title = "Hitbox Size",
    Flag = "HRPsize",
    Value = {Min = 3, Max = 30, Default = 10},
    Callback = function(val)
        HitboxSettings.Size = val
        if HitboxSettings.Enabled then
            ExpandHitboxes()
            if HitboxSettings.ShowVisual then
                UpdateVisualHitboxes()
            end
        end
    end
})

Tabs.Utility:Toggle({
    Title = "Show Hitbox",
    Flag = "ShowHRP",
    Type = "Checkbox",
    Callback = function(state)
        HitboxSettings.ShowVisual = state
        if state and HitboxSettings.Enabled then
            UpdateVisualHitboxes()
        elseif not state then
            ClearVisualAdornments()
        end
    end
})

Tabs.Utility:Colorpicker({
    Title = "Hitbox Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        HitboxSettings.VisualColor = col
        if HitboxSettings.ShowVisual and HitboxSettings.Enabled then
            UpdateVisualHitboxes()
        end
    end
})

if a then
    local v1, v2, v3 = pairs(a)
    while true do
        local v4
        v3, v4 = v1(v2, v3)
        if v3 == nil then
            break
        end
        v4:Disconnect()
    end
    a = nil
end

repeat
    task.wait()
until LocalPlayer

vu5 = LocalPlayer
vu6 = nil
vu7 = nil
vu8 = nil
vu9 = false
vu10 = {}

function vu16()
    vu6 = vu5.Character or vu5.CharacterAdded:Wait()
    vu7 = vu6:WaitForChild("Humanoid")
    vu8 = vu6:WaitForChild("HumanoidRootPart")
    vu10 = {}
    local v11 = vu6
    local v12, v13, v14 = pairs(v11:GetDescendants())
    while true do
        local v15 = nil
        v14, v15 = v12(v13, v14)
        if v14 == nil then
            break
        end
        if v15:IsA("BasePart") and v15.Transparency == 0 then
            vu10[#vu10 + 1] = v15
        end
    end
end

function vu30()
    toggleElement = ButtonLib.Create:Toggle({
        Text = "INVISIBLE",
        Flag = "InvisibleToggle",
        Default = false,
        Visible = false,
        Callback = function(state)
            vu9 = state
            if vu9 then
                local v26, v27, v28 = pairs(vu10)
                while true do
                    local v29 = nil
                    v28, v29 = v26(v27, v28)
                    if v28 == nil then
                        break
                    end
                    v29.Transparency = v29.Transparency == 0 and 0.5 or 0
                end
            else
                local v26, v27, v28 = pairs(vu10)
                while true do
                    local v29 = nil
                    v28, v29 = v26(v27, v28)
                    if v28 == nil then
                        break
                    end
                    v29.Transparency = 0
                end
            end
        end
    })
    toggleElement.Position = UDim2.new(0.5, -125, 0.12, 0)

    InvisibleToggleElement = toggleElement
end

vu16()
vu30()

local v31 = {
    nil,
    nil
}
local v32 = vu5

v31[1] = vu5:GetMouse().KeyDown:Connect(function(p33)
    if p33 == "i" then
        vu9 = not vu9

        if ButtonLib and ButtonLib.InvisibleToggle then
            ButtonLib.InvisibleToggle:Set(vu9)
        end

        local v34, v35, v36 = pairs(vu10)
        while true do
            local v37 = nil
            v36, v37 = v34(v35, v36)
            if v36 == nil then
                break
            end
            if vu9 then
                v37.Transparency = v37.Transparency == 0 and 0.5 or 0
            else
                v37.Transparency = 0
            end
        end
    end
end)

v31[2] = RunService.Heartbeat:Connect(function()
    if vu9 then
        local v38 = vu8.CFrame
        local v39 = vu7.CameraOffset
        local v40 = v38 * CFrame.new(0, 50000, 0)
        local v41 = vu7
        local v42 = vu8
        local v43 = v40:ToObjectSpace(CFrame.new(v38.Position)).Position
        v42.CFrame = v40
        v41.CameraOffset = v43
        RunService.RenderStepped:Wait()
        local v44 = vu7
        vu8.CFrame = v38
        v44.CameraOffset = v39
    end
end)

vu5.CharacterAdded:Connect(function()
    vu9 = false

    if ButtonLib and ButtonLib.InvisibleToggle then
        ButtonLib.InvisibleToggle:Set(false)
    end

    vu16()
end)

Tabs.Utility:Space()
InvisibleGuiToggle = Tabs.Utility:Toggle({
    Title = "Invisible GUI",
    Flag = "InvisibleGuiToggle",
    Value = false,
    Callback = function(state)
        if ButtonLib and ButtonLib.InvisibleToggle then
            ButtonLib.InvisibleToggle:SetVisible(state)
        end
    end
})

Tabs.Settings:Section({ Title = "Config Manager", TextSize = 20 })
Tabs.Settings:Divider()

local ConfigManager = Window.ConfigManager

local CurrentConfigName = "default"
local AutoLoadConfig = "default"
local AutoLoadEnabled = false
local AutoSaveEnabled = false
local ConfigListDropdown = nil
local AutoSaveConnection = nil

function FileExists(path)
    if isfile then
        return pcall(readfile, path)
    end
    return false
end

function WriteFile(path, content)
    if writefile then
        return pcall(writefile, path, content)
    end
    return false
end

function ReadFile(path)
    if readfile then
        local success, content = pcall(readfile, path)
        if success then
            return content
        end
    end
    return ""
end

function loadAutoLoadSettings()
    local autoLoadFile = "Darahub/AutoLoad/Game/Murder-Mystery-2(Normal-Mode)/AutoLoad.json"

    if FileExists(autoLoadFile) then
        local content = ReadFile(autoLoadFile)

        if content ~= "" then
            local success, data = pcall(function()
                return HttpService:JSONDecode(content)
            end)

            if success and data then
                AutoLoadConfig = data.configName or "default"
                AutoLoadEnabled = data.enabled or false
                return true
            end
        end
    end

    AutoLoadConfig = "default"
    AutoLoadEnabled = false
    return false
end

function saveAutoLoadSettings()
    local autoLoadFile = "Darahub/AutoLoad/Game/Murder-Mystery-2(Normal-Mode)/AutoLoad.json"

    local success = WriteFile(autoLoadFile, "")
    if not success then
        if makefolder then
            pcall(function() makefolder("Darahub") end)
            pcall(function() makefolder("Darahub/AutoLoad") end)
            pcall(function() makefolder("Darahub/AutoLoad/Game") end)
            pcall(function() makefolder("Darahub/AutoLoad/Game/Murder-Mystery-2(Normal-Mode)") end)
        end
    end

    local data = {
        enabled = AutoLoadEnabled,
        configName = AutoLoadConfig
    }

    local success, json = pcall(function()
        return HttpService:JSONEncode(data)
    end)

    if success then
        WriteFile(autoLoadFile, json)
    end
end

loadAutoLoadSettings()

ConfigNameInput = Tabs.Settings:Input({
    Title = "Config Name",
    Flag = "ConfigNameInput",
    Desc = "Name for your config file",
    Icon = "file-cog",
    Placeholder = "default",
    Value = CurrentConfigName,
    Callback = function(value)
        if value ~= "" then
            CurrentConfigName = value
        end
    end
})

Tabs.Settings:Space()
AutoLoadToggle = Tabs.Settings:Toggle({
    Title = "Auto Load",
    Flag = "AutoLoadToggle",
    Desc = "Automatically load this config when script starts",
    Value = AutoLoadEnabled,
    Callback = function(state)
        AutoLoadEnabled = state
        if state then
            AutoLoadConfig = CurrentConfigName
            WindUI:Notify({
                Title = "Auto-Load",
                Content = "Config '" .. CurrentConfigName .. "' will load automatically on startup",
                Duration = 3
            })
        end
        saveAutoLoadSettings()
    end
})

AutoSaveToggle = Tabs.Settings:Toggle({
    Title = "Auto Save",
    Flag = "AutoSaveToggle",
    Desc = "Automatically save changes to config every second",
    Value = AutoSaveEnabled,
    Callback = function(state)
        AutoSaveEnabled = state

        if AutoSaveConnection then
            AutoSaveConnection:Disconnect()
            AutoSaveConnection = nil
        end

        if state then
            WindUI:Notify({
                Title = "Auto-Save",
                Content = "Config will save automatically every second",
                Duration = 2
            })

            AutoSaveConnection = RunService.Heartbeat:Connect(function()
                if AutoSaveEnabled and CurrentConfigName ~= "" then
                    task.spawn(function()
                        Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)
                        Window.CurrentConfig:Save()
                    end)
                end
                task.wait(1)
            end)
        else
            WindUI:Notify({
                Title = "Auto-Save",
                Content = "Auto-save disabled",
                Duration = 2
            })
        end
    end
})

Tabs.Settings:Space()

function refreshConfigList()
    local allConfigs = ConfigManager:AllConfigs() or {}

    if not table.find(allConfigs, "default") then
        local defaultConfig = ConfigManager:Config("default")
        if defaultConfig and defaultConfig.Save then
            defaultConfig:Save()
        end
        table.insert(allConfigs, 1, "default")
    end

    table.sort(allConfigs, function(a, b)
        return a:lower() < b:lower()
    end)

    local defaultValue = table.find(allConfigs, CurrentConfigName) and CurrentConfigName or "default"

    if ConfigListDropdown and ConfigListDropdown.Refresh then
        ConfigListDropdown:Refresh(allConfigs, defaultValue)
    end
end

ConfigListDropdown = Tabs.Settings:Dropdown({
    Title = "Existing Configs",
    Flag = "ConfigListDropdown",
    Desc = "Select from saved configs",
    Values = {"default"},
    Value = "default",
    Callback = function(value)
        CurrentConfigName = value
        ConfigNameInput:Set(value)

        if AutoLoadEnabled then
            AutoLoadConfig = value
            saveAutoLoadSettings()
        end

        local config = ConfigManager:GetConfig(value)
        if config then
            WindUI:Notify({
                Title = "Config Selected",
                Content = "Config '" .. value .. "' selected",
                Duration = 2
            })
        end
    end
})

Tabs.Settings:Space()

SaveConfigButton = Tabs.Settings:Button({
    Title = "Save Config",
    Desc = "Save current settings to config",
    Icon = "save",
    Callback = function()
        if CurrentConfigName == "" then
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a config name",
                Duration = 3
            })
            return
        end

        Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)

        local success = Window.CurrentConfig:Save()
        if success then
            WindUI:Notify({
                Title = "Config Saved",
                Content = "Config '" .. CurrentConfigName .. "' saved successfully",
                Duration = 3
            })

            if AutoLoadEnabled then
                AutoLoadConfig = CurrentConfigName
                saveAutoLoadSettings()
            end

            task.wait(0.5)
            refreshConfigList()
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Failed to save config",
                Duration = 3
            })
        end
    end
})

Tabs.Settings:Space()

LoadConfigButton = Tabs.Settings:Button({
    Title = "Load Config",
    Desc = "Load settings from selected config",
    Icon = "folder-open",
    Callback = function()
        if CurrentConfigName == "" then
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a config name",
                Duration = 3
            })
            return
        end

        Window.CurrentConfig = ConfigManager:CreateConfig(CurrentConfigName)

        local success = Window.CurrentConfig:Load()
        if success then
            WindUI:Notify({
                Title = "Config Loaded",
                Content = "Config '" .. CurrentConfigName .. "' loaded successfully",
                Duration = 3
            })

            if AutoLoadEnabled then
                AutoLoadConfig = CurrentConfigName
                saveAutoLoadSettings()
            end
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Config '" .. CurrentConfigName .. "' not found or empty",
                Duration = 3
            })
        end
    end
})

Tabs.Settings:Space()

DeleteConfigButton = Tabs.Settings:Button({
    Title = "Delete Config",
    Desc = "Delete selected config",
    Icon = "trash-2",
    Color = Color3.fromHex("#ff4830"),
    Callback = function()
        if CurrentConfigName == "default" then
            WindUI:Notify({
                Title = "Error",
                Content = "Cannot delete default config",
                Duration = 3
            })
            return
        end

        local success = ConfigManager:DeleteConfig(CurrentConfigName)
        if success then
            WindUI:Notify({
                Title = "Config Deleted",
                Content = "Config '" .. CurrentConfigName .. "' deleted",
                Duration = 3
            })

            CurrentConfigName = "default"
            ConfigNameInput:Set("default")

            if AutoLoadEnabled then
                AutoLoadConfig = "default"
                saveAutoLoadSettings()
            end

            task.wait(0.5)
            refreshConfigList()
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Failed to delete config or config doesn't exist",
                Duration = 3
            })
        end
    end
})

Tabs.Settings:Space()

RefreshConfigButton = Tabs.Settings:Button({
    Title = "Refresh Config List",
    Desc = "Update the list of available configs",
    Icon = "refresh-cw",
    Callback = function()
        refreshConfigList()
        WindUI:Notify({
            Title = "Config List Refreshed",
            Content = "Config list updated",
            Duration = 2
        })
    end
})

task.spawn(function()
    task.wait(0.5) 
    refreshConfigList()

    ConfigNameInput:Set("default")

    if AutoLoadEnabled then
        CurrentConfigName = AutoLoadConfig
        ConfigNameInput:Set(CurrentConfigName)

        task.wait(1)
        Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)

        if Window.CurrentConfig:Load() then
            WindUI:Notify({
                Title = "Auto-Loaded",
                Content = "Config '" .. CurrentConfigName .. "' loaded automatically",
                Duration = 3
            })
        end
    end
end)

if AutoSaveEnabled then
    task.spawn(function()
        task.wait(1)

        if AutoSaveEnabled then
            AutoSaveConnection = RunService.Heartbeat:Connect(function()
                if AutoSaveEnabled and CurrentConfigName ~= "" then
                    task.spawn(function()
                        Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)
                        Window.CurrentConfig:Save()
                    end)
                end
                task.wait(1)
            end)
        end
    end)
end

Tabs.Settings:Section({ Title = "Personalize", TextSize = 20 })
Tabs.Settings:Divider()

themes = {}

availableThemes = WindUI:GetThemes()

for themeName, _ in pairs(availableThemes) do
    table.insert(themes, themeName)
end
table.sort(themes)

ThemeDropdown = Tabs.Settings:Dropdown({
    Title = "Select Theme",
    Flag = "ThemeDropdown",
    Values = themes,
    SearchBarEnabled = true,
    MenuWidth = 280,
    Value = themes[1],
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})

TransparencySlider = Tabs.Settings:Slider({
    Title = "Window Transparency",
    Step = 0.01,
    Flag = "TransparencySlider",
    Value = { Min = 0, Max = 1, Default = WindUI.TransparencyValue },
    Callback = function(value)
        WindUI.TransparencyValue = tonumber(value)
        Window:ToggleTransparency(tonumber(value) > 0)
    end
})

Tabs.Settings:Section({ Title = "Keybinds" })
Tabs.Settings:Keybind({
    Flag = "Keybind",
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "RightControl",
    Callback = function(RightControl)
        Window:SetToggleKey(Enum.KeyCode[RightControl])
    end
})

Tabs.Settings:Space()
SpeedGlitchKeybind = Tabs.Settings:Keybind({
    Title = "Speed Glitch Toggle",
    Desc = "Keybind to toggle Speed Glitch",
    Value = "",
    Flag = "SpeedGlitchKeybind",
    Callback = function(v)
        if SpeedGlitchToggle then
            SpeedGlitchToggle:Set(not SpeedGlitchToggle.Value)
        end
    end
})

Tabs.Settings:Space()
FlyTogglekeybind = Tabs.Settings:Keybind({
    Title = "Fly Toggle",
    Desc = "Keybind to toggle Fly",
    Value = "",
    Flag = "FlyTogglekeybind",
    Callback = function(v)
        FlyToggle:Set(not FlyToggle.Value)
    end
})

Tabs.Settings:Space()

Tabs.Settings:Keybind({
    Title = "Invisible Toggle",
    Desc = "Keybind to toggle invisible mode",
    Value = "I",
    Callback = function(v)
        vu9 = not vu9

        if ButtonLib and ButtonLib.InvisibleToggle then
            ButtonLib.InvisibleToggle:Set(vu9)
        end

        for _, part in pairs(vu10) do
            part.Transparency = vu9 and 0.5 or 0
        end
    end
})

LagSwitchKeybind = Tabs.Settings:Keybind({
    Title = "Trigger Lag Switch",
    Desc = "Keybind to trigger lag switch",
    Value = "L",
    Flag = "LagSwitchKeybind",
    Callback = function(v)
        if lagSwitchEnabled and not isLagActive then
            isLagActive = true
            task.spawn(function()
                lag()
                isLagActive = false
            end)
        end
    end
})

Tabs.Settings:Space()

GravityKeybind = Tabs.Settings:Keybind({
    Title = "Toggle Gravity",
    Desc = "Keybind to toggle custom gravity",
    Value = "J",
    Flag = "GravityKeybind",
    Callback = function(v)
        GravityToggle:Set(not GravityToggle.Value)
    end
})

do
    local DarahubFolder = CoreGui:FindFirstChild("Darahub")

    if DarahubFolder and Tabs and Tabs.Settings then
        Tabs.Settings:Section({
            Title = "GUI Size"
        })
        local defaultScales = {}

        for _, Element in pairs(DarahubFolder:GetChildren()) do
            if Element:IsA("Frame") and Element:FindFirstChild("UIScale") then
                defaultScales[Element.Name] = Element.UIScale.Scale
            end
        end

        Tabs.Settings:Button({
            Title = "Reset All Scales",
            Description = "Reverts all buttons to their startup scale values",
            Callback = function()
                for _, Element in pairs(DarahubFolder:GetChildren()) do
                    if Element:IsA("Frame") and Element:FindFirstChild("UIScale") then
                        local original = defaultScales[Element.Name] or 1
                        Element.UIScale.Scale = original
                    end
                end
            end
        })

        for _, Element in pairs(DarahubFolder:GetChildren()) do
            if Element:IsA("Frame") and Element:FindFirstChild("UIScale") then
                local currentScale = tonumber(Element.UIScale.Scale) or 1

                Tabs.Settings:Slider({
                    Title = Element.Name .. " Scale",
                    Desc = "Adjust GUI scale",
                    Flag = "Scale_Slider_" .. Element.Name,
                    Step = 0.01,
                    Value = {
                        Min = 0.01,
                        Max = 4,
                        Default = currentScale
                    },
                    Callback = function(val)
                        if Element and Element:FindFirstChild("UIScale") then
                            Element.UIScale.Scale = tonumber(val)
                        end
                    end
                })
            end
        end
    end
end

Tabs.Settings:Space() 
local FPSCounter = CoreGui:FindFirstChild("FPSCounter")
if FPSCounter then
    FPSCounterToggle = Tabs.Settings:Toggle({
        Title = "Show FPS Counter",
        Flag = "FPSCounterToggle",
        Value = true,
        Callback = function(state)
            if FPSCounter then
                FPSCounter.Enabled = state
            else
                warn("Could Not Find \"FPSCounter\" in CoreGUI! Please Reload the script And try again.")
            end
        end
    })
else
    warn("No \"FPSCounter\" Found in CoreGUI")
end

Tabs.Settings:Section({ Title = "Sensitivity Controls", TextSize = 20 })
Tabs.Settings:Divider()

MouseSensitivityEnabled = false
MouseSensitivityValue = 1.0
MIN_SENSITIVITY = 0.1
MAX_SENSITIVITY = 20.0
DEFAULT_SENSITIVITY = 1.0
cameraInputModule = nil
mouseHookActive = false
touchHookActive = false

function setupSensitivityHook()
    if cameraInputModule then return true end

    local success = false

    pcall(function()
        local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
        if not playerScripts then return end
        local playerModule = playerScripts:FindFirstChild("PlayerModule")
        if not playerModule then return end
        local cameraModule = playerModule:FindFirstChild("CameraModule")
        if cameraModule then
            local cameraInput = cameraModule:FindFirstChild("CameraInput")
            if cameraInput then
                cameraInputModule = require(cameraInput)
                if cameraInputModule and cameraInputModule.getRotation then
                    local originalGetRotation = cameraInputModule.getRotation
                    cameraInputModule.getRotation = function(disableRotation)
                        local rotation = originalGetRotation(disableRotation)
                        local uis = game:GetService("UserInputService")
                        if MouseSensitivityEnabled and uis.MouseEnabled then
                            return rotation * MouseSensitivityValue
                        elseif TouchSensitivityEnabled and uis.TouchEnabled then
                            return rotation * TouchSensitivityValue
                        end
                        return rotation
                    end
                    success = true
                end
            end
        end
    end)

    return success
end

MouseSensitivityToggle = Tabs.Settings:Toggle({
    Title = "Mouse Sensitivity",
    Flag = "MouseSensitivityToggle",
    Desc = "Adjust mouse sensitivity",
    Value = false,
    Callback = function(state)
        MouseSensitivityEnabled = state
        if state then
            if not setupSensitivityHook() then
                WindUI:Notify({
                    Title = "Mouse Sensitivity",
                    Content = "Failed to hook system. Try rejoining.",
                    Duration = 3
                })
                MouseSensitivityToggle:Set(false)
                MouseSensitivityEnabled = false
            end
        end
    end
})

MouseSensitivitySlider = Tabs.Settings:Slider({
    Title = "Mouse Sensitivity Value",
    Flag = "MouseSensitivitySlider",
    Desc = "Lower = slower, Higher = faster (Max: 20)",
    Value = { Min = 0.1, Max = 20, Default = 1.0 },
    Step = 0.1,
    Callback = function(value)
        MouseSensitivityValue = value
    end
})

Tabs.Settings:Space()

TouchSensitivityToggle = Tabs.Settings:Toggle({
    Title = "Touch Sensitivity",
    Flag = "TouchSensitivityToggle",
    Desc = "Adjust touch/mobile sensitivity",
    Value = false,
    Callback = function(state)
        TouchSensitivityEnabled = state
        if state then
            if not setupSensitivityHook() then
                WindUI:Notify({
                    Title = "Touch Sensitivity",
                    Content = "Failed to hook system. Try rejoining.",
                    Duration = 3
                })
                TouchSensitivityToggle:Set(false)
                TouchSensitivityEnabled = false
            end
        end
    end
})

TouchSensitivitySlider = Tabs.Settings:Slider({
    Title = "Touch Sensitivity Value",
    Flag = "TouchSensitivitySlider",
    Desc = "Lower = slower, Higher = faster (Max: 20)",
    Value = { Min = 0.1, Max = 20, Default = 1.0 },
    Step = 0.1,
    Callback = function(value)
        TouchSensitivityValue = value
    end
})

Tabs.Settings:Space()

Tabs.Settings:Section({ Title = "Reset Controls", TextSize = 20 })
Tabs.Settings:Divider()

Tabs.Settings:Button({
    Title = "Reset Sensitivity Settings",
    Desc = "Reset both mouse and touch sensitivity to defaults",
    Icon = "refresh-cw",
    Color = Color3.fromHex("#FF3030"),
    Callback = function()
        MouseSensitivityEnabled = false
        MouseSensitivityValue = DEFAULT_SENSITIVITY
        TouchSensitivityEnabled = false
        TouchSensitivityValue = DEFAULT_SENSITIVITY
        cameraInputModule = nil
        mouseHookActive = false
        touchHookActive = false
        if MouseSensitivityToggle then 
            MouseSensitivityToggle:Set(false) 
        end
        if MouseSensitivitySlider then 
            MouseSensitivitySlider:Set(1.0) 
        end
        if TouchSensitivityToggle then 
            TouchSensitivityToggle:Set(false) 
        end
        if TouchSensitivitySlider then 
            TouchSensitivitySlider:Set(1.0) 
        end
        WindUI:Notify({
            Title = "Sensitivity Reset",
            Content = "All sensitivity settings reset to default",
            Duration = 3
        })
    end
})

local UniverseScriptsStuff = loadstring(game:HttpGet("https://darahub.pages.dev/Module/More-Scripts.Lua"))()
UniverseScriptsStuff(Tabs)