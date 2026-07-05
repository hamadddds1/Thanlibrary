--=========================================================
-- Anti-Cheat / Kick Bypass v1
--=========================================================
if setreadonly then
    for k, v in pairs(getgc(true)) do
        if pcall(function() return rawget(v, "indexInstance") end) 
        and type(rawget(v, "indexInstance")) == "table" 
        and rawget(v, "indexInstance")[1] == "kick" then
            if not isreadonly(v) then
                v.tvk = {"kick", function() return game.Workspace:WaitForChild("") end}
                task.wait(1.5)
            else
                setreadonly(v, false)
                v.tvk = {"kick", function() return game.Workspace:WaitForChild("") end}
                setreadonly(v, true)
                task.wait(1.5)
            end
        end
    end
end

--=========================================================
-- Services & Dependencies
--=========================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--=========================================================
-- Anti-Cheat Bypass
--=========================================================
local netFolder = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local netChildren = netFolder:GetChildren()

-- Deteksi nama hex hash (bukan nama plain)
local function isHex(name)
    local stripped = name:gsub("^R[FE]/", "")
    return #stripped > 16 and stripped:match("^%x+$") ~= nil
end

-- Build map: "ChargeFishingRod" -> actual hashed Instance
local remoteMap = {}
for i, child in ipairs(netChildren) do
    if not isHex(child.Name) then
        local nextChild = netChildren[i + 1]
        if nextChild and isHex(nextChild.Name) then
            local key = child.Name:gsub("^R[FE]/", "")
            remoteMap[key] = nextChild
        end
    end
end

local function RF(name) return remoteMap[name] end
local function RE(name) return remoteMap[name] end

-- Packages
local Net = require(ReplicatedStorage.Packages.Net)
local Promise = require(ReplicatedStorage.Packages.Promise)
local ReplionClient = require(ReplicatedStorage.Packages.Replion).Client

-- Controllers
local FishingController = require(ReplicatedStorage.Controllers.FishingController)
local AnimationController = require(ReplicatedStorage.Controllers.AnimationController)
local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local VendorController = require(ReplicatedStorage.Controllers.VendorController)
local CutsceneController = require(ReplicatedStorage.Controllers.CutsceneController)
local HUDController = require(ReplicatedStorage.Controllers.HUDController)
local NotificationController = require(ReplicatedStorage.Controllers.NotificationController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)

-- Modules & Shared
local InputControl = require(ReplicatedStorage.Modules.InputControl)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)

-- GUI Library
local TahoeUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/hamaddddds/Tahoe-library/main/main.lua"))()

--=========================================================
-- Global Variables
--=========================================================
_G.AutoFishing = false
_G.AutoEquipRod = false
_G.AutoSellFull = false
_G.IsAutoSelling = false
_G.DelayGo = 0.1
_G.DelayEnd = 0.1
_G.NotifPosition = "Right"
_G.TurnOffNotification = false
_G.NoCutscene = false
_G.ActiveNotifications = 0

--=========================================================
-- UI Initialization
--=========================================================
local Window = TahoeUI:CreateWindow({
    Title = "ThanHub |",
    Subtitle = "Fishit",
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:CTab({ Name = "Main", Icon = "user" }),
    Misc = Window:CTab({ Name = "Misc", Icon = "settings" }),
    Teleport = Window:CTab({ Name = "Teleport", Icon = "map" }),
    Player = Window:CTab({ Name = "Player", Icon = "user" })
}

-- Sections
local MainFarmSection = Tabs.Main:CSection({ Name = "Main farm" })
local MainAnimNotifSection = Tabs.Main:CSection({ Name = "Animation & Notification" })
local MiscWeatherSection = Tabs.Misc:CSection({ Name = "Weather" })
local MiscSellSection = Tabs.Misc:CSection({ Name = "Sell function" })
local TeleportSection = Tabs.Teleport:CSection({ Name = "Teleport island" })
local PlayerSection = Tabs.Player:CSection({ Name = "Player Settings" })

--=========================================================
-- Tab: Main -> Main Farm
--=========================================================
MainFarmSection:CToggle({
    Name = "Auto fishing",
    Description = "Enable auto fishing (Instant Catch)",
    Default = false,
    Callback = function(state)
        _G.AutoFishing = state
    end
})

MainFarmSection:CToggle({
    Name = "Auto equip rod",
    Description = "Equip rod instantly (Anti-Cheat Bypass)",
    Default = false,
    Callback = function(state)
        _G.AutoEquipRod = state
        
        task.spawn(function()
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                
                local function isRodEquipped()
                    return char:FindFirstChildOfClass("Tool") ~= nil
                end
                
                local function simulateHotbar()
                    pcall(function()
                        local mockInput = {
                            KeyCode = Enum.KeyCode.One,
                            UserInputType = Enum.UserInputType.Keyboard,
                            UserInputState = Enum.UserInputState.Begin
                        }
                        InputControl:_inputBegan(mockInput, false)
                        task.wait(0.05)
                        mockInput.UserInputState = Enum.UserInputState.End
                        InputControl:_inputEnded(mockInput, false)
                    end)
                end
                
                if state then
                    if not isRodEquipped() then simulateHotbar() end
                else
                    if isRodEquipped() then simulateHotbar() end
                end
            end)
        end)
    end
})

MainFarmSection:CInput({
    Name = "Delay go",
    Placeholder = "Delay before charge/cast (seconds). Use 0.2 for heavy maps.",
    Default = "0.1",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 then
            _G.DelayGo = num
        end
    end
})

MainFarmSection:CInput({
    Name = "Delay end",
    Placeholder = "Delay after catching fish (seconds). Use 0.2 for heavy maps.",
    Default = "0.1",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 then
            _G.DelayEnd = num
        end
    end
})

--=========================================================
-- Tab: Main -> Animation & Notification
--=========================================================

MainAnimNotifSection:CToggle({
    Name = "Turn off notification",
    Description = "Disable all item obtained popups",
    Default = false,
    Callback = function(state)
        _G.TurnOffNotification = state
    end
})

MainAnimNotifSection:CToggle({
    Name = "No cutscene",
    Description = "Disable Legendary/Secret cutscenes",
    Default = false,
    Callback = function(state)
        _G.NoCutscene = state
    end
})

MainAnimNotifSection:CToggle({
    Name = "No animation",
    Description = "Disable fishing rod animations",
    Default = false,
    Callback = function(state)
        _G.NoAnimation = state
    end
})

MainAnimNotifSection:CDropdown({
    Name = "Notification Position",
    Options = {"Left", "Bottom", "Right"},
    Default = "Right",
    Callback = function(value)
        _G.NotifPosition = value
        pcall(function()
            local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local notifGui = playerGui:FindFirstChild("Text Notifications")
                if notifGui and notifGui:FindFirstChild("Frame") then
                    local frame = notifGui.Frame
                    if value == "Left" then
                        frame.Position = UDim2.new(0, 20, 0.5, 0)
                        frame.AnchorPoint = Vector2.new(0, 0.5)
                    elseif value == "Right" then
                        frame.Position = UDim2.new(1, -20, 0.5, 0)
                        frame.AnchorPoint = Vector2.new(1, 0.5)
                    elseif value == "Bottom" then
                        frame.Position = UDim2.new(0.5, 0, 1, -150)
                        frame.AnchorPoint = Vector2.new(0.5, 1)
                    end
                end
            end
        end)
    end
})

MainAnimNotifSection:CDropdown({
    Name = "Rod Animation",
    Options = {
        "Default",
        "1x1x1x1 Ban Hammer",
        "Aether Monarch",
        "Aurelian Bow",
        "Binary Edge",
        "Blackhole Sword",
        "Bunny Summoner",
        "Butterfly Sword",
        "Candy Cane Trident",
        "Celestial Scythe",
        "Christmas Parasol",
        "Chromatic Katana",
        "Cloud Weaver",
        "Corruption Edge",
        "Crescendo Scythe",
        "Crimson Retribution",
        "Crimson Rose",
        "Cupid's Harp",
        "Dark Matter Scythe",
        "Divine Blade",
        "Divine Staff",
        "Draconic Soul",
        "Dragonmaster Scythe",
        "Easter Parasol",
        "Eclipse Katana",
        "Electric Guitar",
        "Empyrean Staff",
        "Energy Blaster",
        "Eternal Flower",
        "Ethereal Sword",
        "Frozen Krampus Scythe",
        "Galaxy Conqueror",
        "Gingerbread Katana",
        "Gingerbread Sword",
        "Golden Clockwork",
        "Heartbreaker Surge",
        "Heartfelt Blade",
        "Holy Trident",
        "Kitsune Greatsword",
        "Kitty Guitar",
        "Kraken Anchor",
        "Oceanic Harpoon",
        "Ornament Axe",
        "Overdrive",
        "Pink Present Lance",
        "Princess Parasol",
        "Reaver Scythe",
        "Royal Spider",
        "Serpent's Trident",
        "Soul Scythe",
        "Spirit Staff",
        "The Vanquisher",
        "Trick O' Treat",
        "Void Guitar",
        "Void Kraken",
        "Voidpunk Axe",
        "Wings of Everlove",
        "World Tour Football",
        "Xmas Tree Rod"
    },
    Default = "Default",
    Callback = function(value)
        _G.CustomRodAnimation = value
        
        -- Preload animations for smoothness!
        if value ~= "Default" then
            task.spawn(function()
                local success, err = pcall(function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local AnimationController = require(ReplicatedStorage.Controllers.AnimationController)
                    local ContentProvider = game:GetService("ContentProvider")
                    
                    local baseAnims = {
                        "EquipIdle", "RodThrow", "FishCaught", "ReelingIdle", 
                        "ReelStart", "ReelIntermission", "StartRodCharge", "LoopedRodCharge"
                    }
                    
                    local animsToPreload = {}
                    for _, animName in ipairs(baseAnims) do
                        local animData, _ = AnimationController:GetAnimationData(animName)
                        if animData and animData.Animation then
                            table.insert(animsToPreload, animData.Animation)
                        end
                    end
                    
                    if #animsToPreload > 0 then
                        ContentProvider:PreloadAsync(animsToPreload)
                    end
                end)
                if not success then warn("Preload Error: ", err) end
            end)
        end
    end
})

_G.NotificationDuration = 7

--=========================================================
-- Tab: Misc -> Weather
--=========================================================
local function format_price(n)
    if not n then return "0" end
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local AvailableWeathers = {}
local WeatherMap = {}
pcall(function()
    local event_modules = require(game:GetService("ReplicatedStorage"):WaitForChild("Events"))
    for event_name, event_info in pairs(event_modules) do
        if event_info.WeatherMachine and event_info.WeatherMachinePrice then
            local format_name = string.format("%s ($%s)", event_name, format_price(event_info.WeatherMachinePrice))
            table.insert(AvailableWeathers, format_name)
            WeatherMap[format_name] = event_name
        end
    end
end)

if #AvailableWeathers == 0 then
    AvailableWeathers = {"Cloudy", "Wind", "Storm", "Radiant", "Shark Hunt", "Treasure Hunt"}
    for _, name in ipairs(AvailableWeathers) do
        WeatherMap[name] = name
    end
end

local SelectedWeathers = {}

MiscWeatherSection:CDropdown({
    Name = "Weather",
    Multi = true,
    Options = AvailableWeathers,
    Default = {},
    Callback = function(selected)
        SelectedWeathers = selected
    end
})

local AutoBuyWeatherEnabled = false
MiscWeatherSection:CToggle({
    Name = "Auto Buy Weather",
    Description = "Automatically spam buy the selected weather",
    Default = false,
    Callback = function(state)
        AutoBuyWeatherEnabled = state
        if state then
            task.spawn(function()
                while AutoBuyWeatherEnabled do
                    for _, weatherDisplay in ipairs(SelectedWeathers) do
                        local weatherName = WeatherMap[weatherDisplay]
                        if weatherName and weatherName ~= "" then
                            pcall(function()
                                local actualEventId = string.gsub(weatherName, " ", "")
                                local realRemote = RF("PurchaseWeatherEvent")
                                if realRemote then
                                    realRemote:InvokeServer(actualEventId)
                                else
                                    local netWrapper = Net:RemoteFunction("PurchaseWeatherEvent")
                                    if netWrapper then netWrapper:InvokeServer(actualEventId) end
                                end
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

MiscWeatherSection:CButton({
    Name = "Buy Weather Once",
    Description = "Purchase the selected weather once",
    Callback = function()
        task.spawn(function()
            for _, weatherDisplay in ipairs(SelectedWeathers) do
                local weatherName = WeatherMap[weatherDisplay]
                if weatherName and weatherName ~= "" then
                    pcall(function()
                        local actualEventId = string.gsub(weatherName, " ", "")
                        local realRemote = RF("PurchaseWeatherEvent")
                        if realRemote then
                            realRemote:InvokeServer(actualEventId)
                        else
                            local netWrapper = Net:RemoteFunction("PurchaseWeatherEvent")
                            if netWrapper then netWrapper:InvokeServer(actualEventId) end
                        end
                    end)
                end
            end
        end)
    end
})

--=========================================================
-- Tab: Misc -> Sell Function
--=========================================================
local SellMethod = "Sell all"
local SellFilter = "By count"
local SellCount = 100
local SellTime = 10 -- in minutes
local lastSellTime = 0

MiscSellSection:CDropdown({
    Name = "Sell method",
    Options = {"Sell all", "Sell filters"},
    Default = "Sell all",
    Callback = function(value)
        SellMethod = value
    end
})

MiscSellSection:CDropdown({
    Name = "Sell filter",
    Options = {"By count", "By time"},
    Default = "By count",
    Callback = function(value)
        SellFilter = value
    end
})

MiscSellSection:CInput({
    Name = "Sell count",
    Placeholder = "Sell when inventory reaches this amount (e.g. 100)",
    Default = "100",
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            SellCount = math.floor(num)
        end
    end
})

MiscSellSection:CInput({
    Name = "Sell time (min)",
    Placeholder = "Sell every X minutes (e.g. 10)",
    Default = "10",
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            SellTime = num
        end
    end
})

MiscSellSection:CToggle({
    Name = "Auto sell",
    Description = "Automatically sell fish based on selected method",
    Default = false,
    Callback = function(state)
        _G.AutoSellFull = state
        if state then
            lastSellTime = tick()
        end
    end
})

-- Helper: Execute sell
local function doSellAll()
    if _G.IsAutoSelling then return end
    pcall(function()
        local oldFirePrompt = PromptController.FirePrompt
        PromptController.FirePrompt = function(self, text, ...)
            return Promise.resolve(true)
        end
        
        _G.IsAutoSelling = true
        VendorController:SellAllItems():finally(function()
            _G.IsAutoSelling = false
            PromptController.FirePrompt = oldFirePrompt
        end)
    end)
end

-- Auto Sell Loop
task.spawn(function()
    while task.wait(3) do
        if _G.AutoSellFull and not _G.IsAutoSelling then
            pcall(function()
                local PlayerData = ReplionClient:WaitReplion("Data")
                if not PlayerData then return end
                
                if SellMethod == "Sell all" then
                    -- Sell all: jual ketika inventory penuh
                    local items = PlayerData:GetExpect({ "Inventory", "Items" })
                    local maxSpace = PlayerData:GetExpect("MaxInventorySpace") or PlayerData:GetExpect("MaxCapacity") or 999
                    
                    local count = 0
                    for _ in pairs(items) do count = count + 1 end
                    
                    if count >= maxSpace then
                        doSellAll()
                    end
                    
                elseif SellMethod == "Sell filters" then
                    if SellFilter == "By count" then
                        -- By count: jual ketika jumlah ikan >= SellCount
                        local items = PlayerData:GetExpect({ "Inventory", "Items" })
                        local count = 0
                        for _ in pairs(items) do count = count + 1 end
                        
                        if count >= SellCount then
                            doSellAll()
                        end
                        
                    elseif SellFilter == "By time" then
                        -- By time: jual setiap SellTime menit
                        local elapsed = (tick() - lastSellTime) / 60
                        if elapsed >= SellTime then
                            lastSellTime = tick()
                            doSellAll()
                        end
                    end
                end
            end)
        end
    end
end)

--=========================================================
-- Tab: Teleport
--=========================================================
local Islands = {
    ["Kohana"] = Vector3.new(-644, 16, 603),
    ["Stingray shores"] = Vector3.new(-2132, 19, -905),
    ["Treasure room"] = Vector3.new(-3601, -279, -1591),
    ["sympisus statue"] = Vector3.new(-3677, -135, -903),
    ["Copper canyon"] = Vector3.new(-4219, 3, 625),
    ["Coral reels"] = Vector3.new(-3029, 3, 2260),
    ["Crater island"] = Vector3.new(954, 2, 5118),
    ["Pirate cove"] = Vector3.new(3318, 4, 3552),
    ["Crystal depth"] = Vector3.new(5729, -905, 15406),
}

local SelectedIsland = "Kohana"
local TeleportSpeed = 80
local IsTeleporting = false

TeleportSection:CDropdown({
    Name = "Select Island",
    Options = {"Kohana", "Stingray shores", "Treasure room", "sympisus statue", "Copper canyon", "Coral reels", "Crater island", "Pirate cove", "Crystal depth"},
    Default = "Kohana",
    Callback = function(value)
        SelectedIsland = value
    end
})

TeleportSection:CSlider({
    Name = "Teleport Speed",
    Description = "Default 80",
    Min = 0,
    Max = 90,
    Default = 80,
    Callback = function(value)
        TeleportSpeed = value
    end
})

local TeleportNoclipConnection = nil

local function StopTeleport()
    IsTeleporting = false
    if TeleportNoclipConnection then
        TeleportNoclipConnection:Disconnect()
        TeleportNoclipConnection = nil
    end
end

local function StartTeleport(destination)
    if IsTeleporting then 
        StopTeleport() 
        task.wait(0.1) 
    end
    
    IsTeleporting = true
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    

    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    
    humanoid.AutoRotate = false
    
    -- Noclip Connection
    local RunService = game:GetService("RunService")
    TeleportNoclipConnection = RunService.Stepped:Connect(function()
        if not IsTeleporting then
            if TeleportNoclipConnection then
                TeleportNoclipConnection:Disconnect()
                TeleportNoclipConnection = nil
            end
            return
        end
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
    
    local seat = Instance.new("Seat")
    seat.Name = "TeleportSeat"
    seat.Size = Vector3.new(1, 1, 1)
    seat.Transparency = 1
    seat.CanCollide = false
    seat.CFrame = hrp.CFrame
    seat.Parent = workspace
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = seat
    weld.Part1 = hrp
    weld.Parent = seat
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = seat
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = seat
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    local animTrack = nil
    
    if animator then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://507766388"
        animTrack = animator:LoadAnimation(anim)
        animTrack.Priority = Enum.AnimationPriority.Action
        animTrack:Play()
    end
    
    task.spawn(function()
        while IsTeleporting and seat.Parent and humanoid.SeatPart ~= seat do
            humanoid.Sit = true
            seat:Sit(humanoid)
            task.wait(0.05)
        end
    end)
    
    task.spawn(function()
        while IsTeleporting and seat.Parent and character.Parent do
            local currentPos = hrp.Position
            local distance = (destination - currentPos).Magnitude
            
            if distance < 10 then
                break 
            end
            
            local direction = (destination - currentPos).Unit
            bodyVelocity.Velocity = direction * TeleportSpeed
            bodyGyro.CFrame = CFrame.lookAt(currentPos, currentPos + direction)
            
            task.wait()
        end
        
        IsTeleporting = false
        if TeleportNoclipConnection then
            TeleportNoclipConnection:Disconnect()
            TeleportNoclipConnection = nil
        end
        
        if bodyVelocity then bodyVelocity.Velocity = Vector3.new(0, 0, 0) end
        if hrp then 
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) 
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0) 
        end
        task.wait(0.05)
        
        if humanoid then 
            humanoid.Sit = false 
            humanoid.AutoRotate = true
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        if seat then seat:Destroy() end
        if animTrack then animTrack:Stop() end
    end)
end

TeleportSection:CButton({
    Name = "Start Teleport",
    Description = "Fly to selected island",
    Callback = function()
        if Islands[SelectedIsland] then
            StartTeleport(Islands[SelectedIsland])
        end
    end
})

TeleportSection:CButton({
    Name = "Stop Teleport",
    Description = "Stop teleportation immediately",
    Callback = function()
        StopTeleport()
    end
})

--=========================================================
-- Core Hooks & Logic
--=========================================================

-- 1. Cutscene Hook
pcall(function()
    local oldPlay = CutsceneController.Play
    CutsceneController.Play = function(self, ...)
        if _G.NoCutscene then return end
        return oldPlay(self, ...)
    end
end)

-- 1.5 Animation Hook
pcall(function()
    local oldGetAnimationData = AnimationController.GetAnimationData
    AnimationController.GetAnimationData = function(self, animationName)
        if _G.NoAnimation then
            local blockedAnims = {
                ["StartRodCharge"] = true,
                ["LoopedRodCharge"] = true,
                ["RodThrow"] = true,
                ["ReelIntermission"] = true,
                ["ReelStart"] = true,
                ["ReelingIdle"] = true,
                ["FishCaught"] = true,
                ["FishingFailure"] = true
            }
            if blockedAnims[animationName] then
                return { Disabled = true }, animationName
            end
        end
        
        if _G.CustomRodAnimation and _G.CustomRodAnimation ~= "Default" then
            local oldGetItemData = ItemUtility.GetItemDataFromItemType
            ItemUtility.GetItemDataFromItemType = function(itemType, id)
                if itemType == "Fishing Rods" then
                    return { Data = { Name = _G.CustomRodAnimation } }
                end
                return oldGetItemData(itemType, id)
            end
            
            local animData, variantKey = oldGetAnimationData(self, animationName)
            ItemUtility.GetItemDataFromItemType = oldGetItemData
            return animData, variantKey
        end
        
        return oldGetAnimationData(self, animationName)
    end
end)

-- 2. Fishing Minigame Hooks (Instant Catch & Perfect Cast)
pcall(function()
    local oldMinigameChanged = FishingController.FishingMinigameChanged
    FishingController.FishingMinigameChanged = function(self, state, data)
        if _G.AutoFishing and data and type(data) == "table" then
            data.FishingClickPower = 100
            data.FishStrength = 0
            data.FishingResilience = 0
        end
        return oldMinigameChanged(self, state, data)
    end

    local oldSendRequest = FishingController.SendFishingRequestToServer
    FishingController.SendFishingRequestToServer = function(self, pos, power, ...)
        if _G.AutoFishing then
            power = 1
        end
        return oldSendRequest(self, pos, power, ...)
    end
end)

-- 3. HUD FOV Hook
if HUDController and type(HUDController.SetCameraFOV) == "function" then
    local oldSetFOV = HUDController.SetCameraFOV
    HUDController.SetCameraFOV = function(...)
        if _G.AutoFishing then
            return oldSetFOV(65)
        end
        return oldSetFOV(...)
    end
end

-- 4. GUI Visibility Hook
if GuiControl and type(GuiControl.SetHUDVisibility) == "function" then
    local oldSetHUD = GuiControl.SetHUDVisibility
    GuiControl.SetHUDVisibility = function(self, isVisible, ...)
        if _G.AutoFishing then
            isVisible = true
        end
        return oldSetHUD(self, isVisible, ...)
    end
end

-- 5. Instant Bobber (Bypass Hide Wait)
pcall(function()
    if debug and debug.getupvalues and debug.setupvalue then
        for i, v in pairs(debug.getupvalues(FishingController.Hide)) do
            if type(v) == "number" and (v == 1 or v == 0.3) then
                debug.setupvalue(FishingController.Hide, i, 0)
            end
        end
    end
end)

-- 6. Animation Bypass Removed (Handled by No Animation Toggle)

-- 7. Hide Vanilla UI
pcall(function()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local chargeUI = playerGui:WaitForChild("Charge")
    local fishingUI = playerGui:WaitForChild("Fishing")
    
    local oldUpdateCharge = FishingController._updateChargeFrame
    FishingController._updateChargeFrame = function(self, ...)
        oldUpdateCharge(self, ...)
        if _G.AutoFishing then
            if chargeUI:FindFirstChild("Main") then chargeUI.Main.Visible = false end
            if fishingUI:FindFirstChild("Main") then fishingUI.Main.Visible = false end
        else
            if chargeUI:FindFirstChild("Main") then chargeUI.Main.Visible = true end
            if fishingUI:FindFirstChild("Main") then fishingUI.Main.Visible = true end
        end
    end
end)

-- 8. Notification Hooks
pcall(function()
    for key, func in pairs(NotificationController) do
        if type(func) == "function" then
            if key == "PlaySmallItemObtained" then
                local oldFunc = func
                NotificationController[key] = function(self, ...)
                    if _G.TurnOffNotification or _G.AutoFishing then return end
                    _G.ActiveNotifications = _G.ActiveNotifications + 1
                    local result = {oldFunc(self, ...)}
                    _G.ActiveNotifications = math.max(0, _G.ActiveNotifications - 1)
                    return unpack(result)
                end
            elseif string.match(key, "Legendary") or string.match(key, "Mythic") or string.match(key, "Secret") or (string.match(key, "ItemObtained") and key ~= "PlaySmallItemObtained") then
                local oldFunc = func
                NotificationController[key] = function(self, ...)
                    if _G.TurnOffNotification or _G.NoCutscene then return end
                    if _G.AutoFishing then
                        _G.ActiveNotifications = _G.ActiveNotifications + 1
                        task.spawn(function()
                            task.wait(2)
                            _G.ActiveNotifications = math.max(0, _G.ActiveNotifications - 1)
                        end)
                    end
                    return oldFunc(self, ...)
                end
            end
        end
    end
end)

-- 9. Instant Perfect Catch Power (Guaranteed 100%)
pcall(function()
    local oldSendRequest = FishingController.SendFishingRequestToServer
    FishingController.SendFishingRequestToServer = function(self, pos, power, ...)
        if _G.AutoFishing then
            power = 1
        end
        return oldSendRequest(self, pos, power, ...)
    end
end)

-- 10. TextNotification Duration Override
pcall(function()
    local oldDeliver = TextNotificationController.DeliverNotification
    TextNotificationController.DeliverNotification = function(self, notificationData, ...)
        if type(notificationData) == "table" then
            if _G.NotificationDuration and _G.NotificationDuration > 1 then
                notificationData.CustomDuration = _G.NotificationDuration
            end
        end
        return oldDeliver(self, notificationData, ...)
    end
end)

-- 11. Block Manual Clicks/Stops from Canceling Auto Fishing
pcall(function()
    local oldCharge = FishingController.RequestChargeFishingRod
    FishingController.RequestChargeFishingRod = function(self, ...)
        if _G.AutoFishing and not _G.IsScriptCharging then
            return -- Abaikan charge manual
        end
        return oldCharge(self, ...)
    end

    local oldStop = FishingController.RequestClientStopFishing
    FishingController.RequestClientStopFishing = function(self, force, ...)
        if _G.AutoFishing and not _G.IsScriptStopping then
            return -- Abaikan cancel manual
        end
        return oldStop(self, force, ...)
    end
end)

--=========================================================
-- Auto Fishing Loop (Hold Screen Fallback Method)
--=========================================================
local InputControl = require(game:GetService("ReplicatedStorage").Modules.InputControl)

local mockClick = { 
    UserInputType = Enum.UserInputType.MouseButton1, 
    UserInputState = Enum.UserInputState.Begin, 
    Position = Vector3.new(0, 0, 0),
    KeyCode = Enum.KeyCode.Unknown
}

local isHoldingScreen = false
local holdStartTime = 0

local AutoFishingLoop = function()
    while task.wait(0.02) do
        if _G.AutoFishing then
            local currentMinigame = FishingController:GetCurrentGUID()
            if currentMinigame then
                -- Auto-Catch Minigame
                if type(FishingController.ConfirmClick) == "function" then
                    FishingController.ConfirmClick()
                end
                
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    local tapScreenHint = playerGui:FindFirstChild("TapScreenHint")
                    if tapScreenHint then tapScreenHint.Enabled = false end
                    local fishingGui = playerGui:FindFirstChild("Fishing")
                    if fishingGui then fishingGui.Enabled = false end
                end
                
                -- Reset hold state saat masuk minigame
                if isHoldingScreen then
                    isHoldingScreen = false
                    mockClick.UserInputState = Enum.UserInputState.End
                    _G.IsScriptCharging = true
                    pcall(function() InputControl:_inputEnded(mockClick, false) end)
                    _G.IsScriptCharging = false
                end
                
                -- Delay end: beri jeda setelah catch agar server sempat proses
                task.wait(_G.DelayEnd or 0.1)
            else
                local inputHandler = FishingController:GetFishingInput()
                local currentPower = FishingController:_getPower() or 0
                
                if inputHandler then
                    -- Sedang charging
                    if currentPower >= 0.97 then
                        -- Power sudah tercapai, lepaskan layar
                        if isHoldingScreen then
                            isHoldingScreen = false
                            mockClick.UserInputState = Enum.UserInputState.End
                            _G.IsScriptCharging = true
                            pcall(function() InputControl:_inputEnded(mockClick, false) end)
                            _G.IsScriptCharging = false
                        end
                    end
                else
                    -- Tidak sedang charging (stop / delay dari server)
                    if _G.AutoEquipRod then
                        local char = LocalPlayer.Character
                        if char and not char:FindFirstChildOfClass("Tool") then
                            pcall(function()
                                local mockEquip = { KeyCode = Enum.KeyCode.One, UserInputType = Enum.UserInputType.Keyboard, UserInputState = Enum.UserInputState.Begin }
                                InputControl:_inputBegan(mockEquip, false)
                                task.wait(0.05)
                                mockEquip.UserInputState = Enum.UserInputState.End
                                InputControl:_inputEnded(mockEquip, false)
                            end)
                            -- Tunggu rod selesai di-equip supaya server tidak mengirim Invalid Input
                            task.wait(1.5)
                        end
                    end
                    
                    -- Pastikan cooldown dari server sudah selesai sebelum melempar pancingan
                    local cooldownTime = LocalPlayer:GetAttribute("FishingCooldownTime") or 0
                    if workspace:GetServerTimeNow() < cooldownTime then
                        -- Masih cooldown, lewati frame ini
                        continue
                    end

                    if not isHoldingScreen then
                        -- Delay go: beri jeda sebelum mulai charge agar server sempat proses
                        task.wait(_G.DelayGo or 0.1)
                        isHoldingScreen = true
                        holdStartTime = tick()
                        mockClick.UserInputState = Enum.UserInputState.Begin
                        _G.IsScriptCharging = true
                        pcall(function() InputControl:_inputBegan(mockClick, false) end)
                        _G.IsScriptCharging = false
                    else

                        if tick() - holdStartTime > 2 then
                            isHoldingScreen = false
                            mockClick.UserInputState = Enum.UserInputState.End
                            _G.IsScriptCharging = true
                            pcall(function() InputControl:_inputEnded(mockClick, false) end)
                            _G.IsScriptCharging = false
                        end
                    end
                end
            end
        else
            -- Jika AutoFishing OFF, pastikan layar tidak terus-terusan di-"hold"
            if isHoldingScreen then
                isHoldingScreen = false
                mockClick.UserInputState = Enum.UserInputState.End
                _G.IsScriptCharging = true
                pcall(function() InputControl:_inputEnded(mockClick, false) end)
                _G.IsScriptCharging = false
                
                -- Paksa berhenti mancing agar bar charge hilang / minigame tertutup
                _G.IsScriptStopping = true
                pcall(function() FishingController:RequestClientStopFishing(true) end)
                _G.IsScriptStopping = false
            end
        end
    end
end
task.spawn(AutoFishingLoop)

--=========================================================
-- Avatar Change System
--=========================================================
local OriginalAvatarData = nil

local function ChangeAvatar(targetUsername)
    local character = LocalPlayer.Character
    if not character then return false end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end

    local successId, target_user_id = pcall(function()
        return Players:GetUserIdFromNameAsync(targetUsername)
    end)
    if not successId then return false end

    local body_part_map = {
        UpperTorso      = Enum.BodyPartR15.UpperTorso,
        LowerTorso      = Enum.BodyPartR15.LowerTorso,
        LeftUpperArm    = Enum.BodyPartR15.LeftUpperArm,
        LeftLowerArm    = Enum.BodyPartR15.LeftLowerArm,
        LeftHand        = Enum.BodyPartR15.LeftHand,
        RightUpperArm   = Enum.BodyPartR15.RightUpperArm,
        RightLowerArm   = Enum.BodyPartR15.RightLowerArm,
        RightHand       = Enum.BodyPartR15.RightHand,
        LeftUpperLeg    = Enum.BodyPartR15.LeftUpperLeg,
        LeftLowerLeg    = Enum.BodyPartR15.LeftLowerLeg,
        LeftFoot        = Enum.BodyPartR15.LeftFoot,
        RightUpperLeg   = Enum.BodyPartR15.RightUpperLeg,
        RightLowerLeg   = Enum.BodyPartR15.RightLowerLeg,
        RightFoot       = Enum.BodyPartR15.RightFoot,
    }

    if not OriginalAvatarData then
        OriginalAvatarData = {
            body_parts  = {},
            accessories = {},
            clothing    = {},
            face        = nil,
            head_mesh   = nil,
            body_colors = nil,
            scales      = {},
        }

        for part_name, _ in pairs(body_part_map) do
            local part = character:FindFirstChild(part_name)
            if part and part:IsA("BasePart") then
                OriginalAvatarData.body_parts[part_name] = part:Clone()
            end
        end

        local head_part = character:FindFirstChild("Head")
        if head_part and head_part:IsA("BasePart") then
            OriginalAvatarData.body_parts["Head"] = head_part:Clone()
        end

        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Accessory") then
                table.insert(OriginalAvatarData.accessories, child:Clone())
            elseif child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
                table.insert(OriginalAvatarData.clothing, child:Clone())
            elseif child:IsA("BodyColors") then
                OriginalAvatarData.body_colors = child:Clone()
            end
        end

        local head = character:FindFirstChild("Head")
        if head then
            for _, decal in ipairs(head:GetChildren()) do
                if decal:IsA("Decal") and (decal.Name == "face" or decal.Name == "Face") then
                    OriginalAvatarData.face = decal:Clone()
                    break
                end
            end

            local orig_mesh = head:FindFirstChildOfClass("SpecialMesh")
            if orig_mesh then
                OriginalAvatarData.head_mesh = {
                    MeshId    = orig_mesh.MeshId,
                    TextureId = orig_mesh.TextureId,
                    Scale     = orig_mesh.Scale,
                    Offset    = orig_mesh.Offset,
                }
            end

            OriginalAvatarData.head_size    = head.Size
            OriginalAvatarData.head_color   = head.Color
        end

        for scale_name, _ in pairs({ HeadScale = true, BodyDepthScale = true, BodyWidthScale = true, BodyHeightScale = true, BodyTypeScale = true, BodyProportionScale = true }) do
            local scale_value = humanoid:FindFirstChild(scale_name)
            if scale_value and scale_value:IsA("NumberValue") then
                OriginalAvatarData.scales[scale_name] = scale_value.Value
            end
        end
    end

    local create_success, target_model = pcall(function()
        return Players:CreateHumanoidModelFromUserIdAsync(target_user_id)
    end)

    if not create_success or not target_model then return false end

    local target_humanoid = target_model:FindFirstChildOfClass("Humanoid")
    if not target_humanoid then
        target_model:Destroy()
        return false
    end

    for part_name, body_part_enum in pairs(body_part_map) do
        local target_part = target_model:FindFirstChild(part_name)
        if target_part and target_part:IsA("BasePart") then
            pcall(function()
                humanoid:ReplaceBodyPartR15(body_part_enum, target_part:Clone())
            end)
        end
    end

    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") then
            child:Destroy()
        end
    end

    local my_head = character:FindFirstChild("Head")
    local target_head = target_model:FindFirstChild("Head")

    if my_head then
        for _, decal in ipairs(my_head:GetChildren()) do
            if decal:IsA("Decal") and (decal.Name == "face" or decal.Name == "Face") then
                decal:Destroy()
            end
        end
    end

    if my_head and target_head then
        for _, decal in ipairs(target_head:GetChildren()) do
            if decal:IsA("Decal") and (decal.Name == "face" or decal.Name == "Face") then
                decal:Clone().Parent = my_head
            end
        end

        local target_mesh = target_head:FindFirstChildOfClass("SpecialMesh")
        local my_mesh = my_head:FindFirstChildOfClass("SpecialMesh")
        if target_mesh and my_mesh then
            my_mesh.MeshId      = target_mesh.MeshId
            my_mesh.TextureId   = target_mesh.TextureId
            my_mesh.Scale       = target_mesh.Scale
            my_mesh.Offset      = target_mesh.Offset
        elseif target_mesh and not my_mesh then
            local new_mesh = target_mesh:Clone()
            new_mesh.Parent = my_head
        end

        my_head.Size  = target_head.Size
        my_head.Color = target_head.Color
    end

    for _, child in ipairs(target_model:GetChildren()) do
        if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
            child:Clone().Parent = character
        elseif child:IsA("BodyColors") then
            local existing = character:FindFirstChildOfClass("BodyColors")
            if existing then
                existing.HeadColor3      = child.HeadColor3
                existing.TorsoColor3     = child.TorsoColor3
                existing.LeftArmColor3   = child.LeftArmColor3
                existing.RightArmColor3  = child.RightArmColor3
                existing.LeftLegColor3   = child.LeftLegColor3
                existing.RightLegColor3  = child.RightLegColor3
            end
        end
    end

    for _, accessory in ipairs(target_model:GetChildren()) do
        if accessory:IsA("Accessory") then
            local cloned = accessory:Clone()
            local handle = cloned:FindFirstChild("Handle")
            if not handle then continue end

            local acc_attachment = handle:FindFirstChildOfClass("Attachment")

            for _, weld in ipairs(handle:GetChildren()) do
                if weld:IsA("Weld") or weld:IsA("Motor6D") or weld:IsA("WeldConstraint") then
                    weld:Destroy()
                end
            end

            local target_part = nil
            local target_attachment = nil

            if acc_attachment then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        for _, att in ipairs(part:GetChildren()) do
                            if att:IsA("Attachment") and att.Name == acc_attachment.Name then
                                target_part = part
                                target_attachment = att
                                break
                            end
                        end
                    end
                    if target_part then break end
                end
            end

            if not target_part then
                target_part = character:FindFirstChild("Head")
                    or character:FindFirstChild("UpperTorso")
                    or character:FindFirstChild("HumanoidRootPart")
                if not target_part then continue end
            end

            cloned.Parent = character

            local weld = Instance.new("Weld")
            weld.Part0 = target_part
            weld.Part1 = handle

            if target_attachment and acc_attachment then
                weld.C0 = target_attachment.CFrame
                weld.C1 = acc_attachment.CFrame
            else
                weld.C0 = CFrame.new(0, target_part.Size.Y / 2, 0)
                weld.C1 = acc_attachment and acc_attachment.CFrame or CFrame.new()
            end

            weld.Parent = handle
        end
    end

    local target_desc = target_humanoid:FindFirstChildOfClass("HumanoidDescription")
    if target_desc then
        for _, scale_name in ipairs({ "HeadScale", "BodyDepthScale", "BodyWidthScale", "BodyHeightScale", "BodyTypeScale", "BodyProportionScale" }) do
            local my_scale = humanoid:FindFirstChild(scale_name)
            local target_scale_val = target_model:FindFirstChild("Humanoid") and target_model:FindFirstChild("Humanoid"):FindFirstChild(scale_name)
            if my_scale and my_scale:IsA("NumberValue") and target_scale_val and target_scale_val:IsA("NumberValue") then
                my_scale.Value = target_scale_val.Value
            end
        end
    end

    target_model:Destroy()
    print("Avatar changed successfully to " .. targetUsername)
    return true
end

local function ResetAvatar()
    local character = LocalPlayer.Character
    if not character then return false end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end

    local saved = OriginalAvatarData
    if not saved then return false end

    local body_part_map = {
        UpperTorso      = Enum.BodyPartR15.UpperTorso,
        LowerTorso      = Enum.BodyPartR15.LowerTorso,
        LeftUpperArm    = Enum.BodyPartR15.LeftUpperArm,
        LeftLowerArm    = Enum.BodyPartR15.LeftLowerArm,
        LeftHand        = Enum.BodyPartR15.LeftHand,
        RightUpperArm   = Enum.BodyPartR15.RightUpperArm,
        RightLowerArm   = Enum.BodyPartR15.RightLowerArm,
        RightHand       = Enum.BodyPartR15.RightHand,
        LeftUpperLeg    = Enum.BodyPartR15.LeftUpperLeg,
        LeftLowerLeg    = Enum.BodyPartR15.LeftLowerLeg,
        LeftFoot        = Enum.BodyPartR15.LeftFoot,
        RightUpperLeg   = Enum.BodyPartR15.RightUpperLeg,
        RightLowerLeg   = Enum.BodyPartR15.RightLowerLeg,
        RightFoot       = Enum.BodyPartR15.RightFoot,
    }

    for part_name, body_part_enum in pairs(body_part_map) do
        local saved_part = saved.body_parts[part_name]
        if saved_part then
            pcall(function()
                humanoid:ReplaceBodyPartR15(body_part_enum, saved_part:Clone())
            end)
        end
    end

    local my_head = character:FindFirstChild("Head")
    if my_head and saved.head_mesh then
        local my_mesh = my_head:FindFirstChildOfClass("SpecialMesh")
        if my_mesh then
            my_mesh.MeshId    = saved.head_mesh.MeshId
            my_mesh.TextureId = saved.head_mesh.TextureId
            my_mesh.Scale     = saved.head_mesh.Scale
            my_mesh.Offset    = saved.head_mesh.Offset
        end
    end

    if my_head and saved.head_size then
        my_head.Size  = saved.head_size
    end

    if my_head and saved.head_color then
        my_head.Color = saved.head_color
    end

    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") then
            child:Destroy()
        end
    end

    if my_head then
        for _, decal in ipairs(my_head:GetChildren()) do
            if decal:IsA("Decal") and (decal.Name == "face" or decal.Name == "Face") then
                decal:Destroy()
            end
        end

        if saved.face then
            saved.face:Clone().Parent = my_head
        end
    end

    for _, clothing in ipairs(saved.clothing) do
        clothing:Clone().Parent = character
    end

    if saved.body_colors then
        local existing = character:FindFirstChildOfClass("BodyColors")
        if existing then
            existing.HeadColor3      = saved.body_colors.HeadColor3
            existing.TorsoColor3     = saved.body_colors.TorsoColor3
            existing.LeftArmColor3   = saved.body_colors.LeftArmColor3
            existing.RightArmColor3  = saved.body_colors.RightArmColor3
            existing.LeftLegColor3   = saved.body_colors.LeftLegColor3
            existing.RightLegColor3  = saved.body_colors.RightLegColor3
        end
    end

    for _, accessory in ipairs(saved.accessories) do
        local cloned = accessory:Clone()
        local handle = cloned:FindFirstChild("Handle")
        if not handle then continue end

        local acc_attachment = handle:FindFirstChildOfClass("Attachment")

        for _, weld in ipairs(handle:GetChildren()) do
            if weld:IsA("Weld") or weld:IsA("Motor6D") or weld:IsA("WeldConstraint") then
                weld:Destroy()
            end
        end

        local target_part = nil
        local target_attachment = nil

        if acc_attachment then
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    for _, att in ipairs(part:GetChildren()) do
                        if att:IsA("Attachment") and att.Name == acc_attachment.Name then
                            target_part = part
                            target_attachment = att
                            break
                        end
                    end
                end
                if target_part then break end
            end
        end

        if not target_part then
            target_part = character:FindFirstChild("Head")
                or character:FindFirstChild("UpperTorso")
                or character:FindFirstChild("HumanoidRootPart")
            if not target_part then continue end
        end

        cloned.Parent = character

        local weld = Instance.new("Weld")
        weld.Part0 = target_part
        weld.Part1 = handle

        if target_attachment and acc_attachment then
            weld.C0 = target_attachment.CFrame
            weld.C1 = acc_attachment.CFrame
        else
            weld.C0 = CFrame.new(0, target_part.Size.Y / 2, 0)
            weld.C1 = handle.CFrame
        end

        weld.Parent = handle
    end

    for scale_name, scale_value in pairs(saved.scales) do
        local my_scale = humanoid:FindFirstChild(scale_name)
        if my_scale and my_scale:IsA("NumberValue") then
            my_scale.Value = scale_value
        end
    end

    OriginalAvatarData = nil
    print("Avatar reset successfully")
    return true
end

local function ChangeName(newName)
    local char = LocalPlayer.Character
    if not char then return end

    pcall(function()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.DisplayName = newName
        end
    end)

    -- Also update any BillboardGui name labels (game-specific)
    pcall(function()
        local head = char:FindFirstChild("Head")
        if head then
            for _, gui in ipairs(head:GetDescendants()) do
                if gui:IsA("TextLabel") and (gui.Name == "NameLabel" or gui.Name == "DisplayName" or gui.Name == "PlayerName") then
                    gui.Text = newName
                end
            end
        end
    end)

    -- Update overhead name tags
    pcall(function()
        for _, desc in ipairs(char:GetDescendants()) do
            if desc:IsA("TextLabel") then
                if desc.Text == LocalPlayer.DisplayName or desc.Text == LocalPlayer.Name then
                    desc.Text = newName
                end
            end
        end
    end)
end

--=========================================================
-- Tab: Player
--=========================================================
local PrivacyEnabled = false
local OriginalNames = {}

PlayerSection:CToggle({
    Name = "Privacy mode",
    Description = "Hide all player usernames in-game",
    Default = false,
    Callback = function(state)
        PrivacyEnabled = state
        task.spawn(function()
            pcall(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    local char = player.Character
                    if char then
                        local head = char:FindFirstChild("Head")
                        if head then
                            local billboardGui = head:FindFirstChildOfClass("BillboardGui")
                            if billboardGui then
                                billboardGui.Enabled = not state
                            end
                        end
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            if state then
                                if not OriginalNames[player.UserId] then
                                    OriginalNames[player.UserId] = humanoid.DisplayName
                                end
                                humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                            else
                                humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                                if OriginalNames[player.UserId] then
                                    humanoid.DisplayName = OriginalNames[player.UserId]
                                end
                            end
                        end
                    end
                end
            end)
        end)
    end
})

PlayerSection:CInput({
    Name = "Load avatar",
    Placeholder = "Enter Roblox username to copy their avatar",
    Default = "",
    Callback = function(value)
        if value and value ~= "" then
            task.spawn(function()
                local success = ChangeAvatar(value)
                if not success then
                    warn("Failed to load avatar for: " .. value)
                end
            end)
        end
    end
})

PlayerSection:CInput({
    Name = "Change name",
    Placeholder = "Change your display name (client-side only)",
    Default = "",
    Callback = function(value)
        if value and value ~= "" then
            task.spawn(function()
                ChangeName(value)
            end)
        end
    end
})