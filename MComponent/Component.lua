-- ==========================================
-- THAN HUB UI LIBRARY - QUICK START GUIDE
-- ==========================================

-- 1. LOAD LIBRARY
local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/hamadddds1/Thanlibrary/refs/heads/main/Mlibrary/ThanV2.lua"))()

-- 2. CREATE WINDOW
local Window = Chloex:Window({
    Title   = "ThanHub",              
    Footer  = "99Night",
    Micon   = "85779221265543", -- Floating Hide/Show Button Icon (rbxassetid or Lucide)
    Uicon   = "gamepad-2",      -- Top Bar Icon (rbxassetid or Lucide)
    -- Color   = Color3.fromRGB(0, 208, 255), -- Not needed if using a custom theme
    Theme   = "Ruby", -- Custom themes: "Default", "Dark", "Ruby", "Emerald", "Amethyst", "Sakura", "Ocean"
    Version = 1,                        
})

-- 3. CREATE TABS
local MainTab = Window:AddTab({ Name = "Utama", Icon = "home" })
local SettingsTab = Window:AddTab({ Name = "Pengaturan", Icon = "settings" })

-- 4. CREATE TAB SECTION (Dropdown Tab)
local TabGroup = Window:AddTabSection({ Name = "Dungeon", Icon = "swords" })
local Dungeon1Tab = TabGroup:AddTab({ Name = "Level 1", Icon = "chevron-right" })
local Dungeon2Tab = TabGroup:AddTab({ Name = "Level 2", Icon = "chevron-right" })

-- ==========================================
-- CONTOH PENGGUNAAN KOMPONEN
-- ==========================================
local Section1 = MainTab:AddSection("Fitur Dasar", true)

-- BUTTON
local myButton = Section1:AddButton({
    Title = "Klik Saya",
    Icon = "chevron-right",
    Callback = function()
        chloex("Tombol berhasil diklik!")
    end
})

-- TOGGLE
local myToggle = Section1:AddToggle({
    Title = "Auto Farm",
    Icon = "swords", -- Menggunakan icon lucide
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

-- SLIDER
local mySlider = Section1:AddSlider({
    Title = "Kecepatan",
    Content = "Atur kecepatan jalan",
    Icon = "gamepad-2",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- DROPDOWN
local myDropdown = Section1:AddDropdown({
    Title = "Pilih Senjata",
    Content = "Senjata utama untuk farm",
    Icon = "player",
    Options = {"Pedang", "Pistol", "Busur"},
    Default = "Pedang",
    Callback = function(value)
        print("Senjata dipilih:", value)
    end
})

-- INPUT TEXT
local myInput = Section1:AddInput({
    Title = "Masukkan Nama",
    Default = "",
    Callback = function(value)
        print("Nama:", value)
    end
})

-- ==========================================
-- FITUR LOCK COMPONENT (WIP)
-- ==========================================
local SectionWIP = MainTab:AddSection("Fitur Belum Selesai", true)

local lockedToggle = SectionWIP:AddToggle({
    Title = "Auto Boss (WIP)",
    Default = false,
    Callback = function(value) end
})
-- Mengunci toggle dengan teks custom
lockedToggle:Lock("Not finish yet")

local lockedButton = SectionWIP:AddButton({
    Title = "Klaim Hadiah",
    Callback = function() end
})
-- Mengunci tombol
lockedButton:Lock("Coming Soon")