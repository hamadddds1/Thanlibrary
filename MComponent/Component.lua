-- ============================================
-- CHLOE X UI LIBRARY - COMPLETE DOCUMENTATION
-- ============================================
-- (c) 2025 Chloe | Chloe X Development
-- Unauthorized redistribution prohibited.
-- ============================================

-- ============================================
-- PART 1: LOADING THE LIBRARY
-- ============================================

--[[
    CARA LOAD LIBRARY:
    - Gunakan loadstring untuk mengambil library dari URL
    - Simpan hasilnya ke variabel (biasanya 'Chloex')
]]

local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/hamadddds1/Thanlibrary/refs/heads/main/Mlibrary/ThanV2.lua"))()

-- ============================================
-- PART 2: WINDOW CREATION
-- ============================================

--[[
    FUNCTION: Chloex:Window()
    DESKRIPSI: Membuat window utama UI
    
    PARAMETERS:
    - Title (string): Judul utama yang muncul di kiri
    - Footer (string): Teks tambahan setelah title
    - Image (string): RbxAssetId untuk icon window
    - Color (Color3): Warna tema utama UI
    - Theme (number): RbxAssetId untuk background
    - Version (number): Versi config (auto-reset jika diubah)
    
    RETURN: Window object untuk menambah tabs
]]

local Window = Chloex:Window({
    Title   = "ThanHub |",              -- Judul utama
    Footer  = "99Night",                -- Teks setelah judul
    Image   = "85779221265543",        -- Asset ID icon
    Color   = Color3.fromRGB(0, 208, 255), -- Warna tema
    Theme   = 9542022979,               -- Asset ID background
    Version = 1,                        -- Versi config
})

-- ============================================
-- PART 3: NOTIFICATIONS
-- ============================================

--[[
    FUNCTION 1: Chloex:MakeNotify()
    DESKRIPSI: Membuat notifikasi popup
    
    PARAMETERS:
    - Title (string): Judul notifikasi
    - Description (string): Teks utama notifikasi
    - Content (string): Konten tambahan
    - Color (Color3): Warna notifikasi
    - Delay (number): Waktu auto-dismiss (detik)
]]

Chloex:MakeNotify({
    Title = "Chloe X",
    Description = "Notification",
    Content = "Contoh notifikasi",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})

--[[
    FUNCTION 2: chloex() / than()
    DESKRIPSI: Shorthand untuk membuat notifikasi cepat
    PARAMETER: message (string) - Pesan notifikasi
]]

chloex("Window loaded!")  -- Cara 1
than("Window loaded!")    -- Cara 2 (sama)

-- ============================================
-- PART 4: TAB CREATION
-- ============================================

--[[
    FUNCTION: Window:AddTab()
    DESKRIPSI: Menambah tab baru ke window
    
    PARAMETERS:
    - Name (string): Nama tab yang ditampilkan
    - Icon (string): RbxAssetId untuk icon tab
    
    RETURN: Tab object untuk menambah sections
]]

local Tabs = {
    Info = Window:AddTab({ 
        Name = "Info",      -- Nama tab
        Icon = "player"     -- Asset ID icon
    }),
    Main = Window:AddTab({ 
        Name = "Main", 
        Icon = "user" 
    }),
}

-- ============================================
-- PART 5: SECTION CREATION
-- ============================================

--[[
    FUNCTION: Tab:AddSection()
    DESKRIPSI: Membuat section yang bisa di-collapse
    
    PARAMETERS:
    - name (string): Judul section
    - alwaysOpen (boolean): 
        - false = bisa dibuka/tutup (default)
        - true = selalu terbuka (tidak bisa ditutup)
    
    RETURN: Section object untuk menambah UI elements
]]

-- Section normal (bisa ditutup)
local X1 = Tabs.Info:AddSection("Chloe X | Section")

-- Section selalu terbuka
local X2 = Tabs.Info:AddSection("Chloe X | Section", true)

-- ============================================
-- PART 6: UI ELEMENTS - PARAGRAPH
-- ============================================

--[[
    FUNCTION: Section:AddParagraph()
    DESKRIPSI: Menambah paragraf dengan optional button
    
    PARAMETERS:
    - Title (string): Judul paragraf
    - Content (string): Isi paragraf
    - Icon (string): Nama icon (star, discord, dll)
    - ButtonText (string): Teks button (optional)
    - ButtonCallback (function): Fungsi saat button diklik
]]

-- Paragraph tanpa button
X1:AddParagraph({
    Title = "Chloe X | Community",
    Content = "Chloe Chloe Chloe Chloe",
    Icon = "star",
})

-- Paragraph dengan button
X1:AddParagraph({
    Title = "Join Our Discord",
    Content = "Join Us!",
    Icon = "discord",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        local link = "https://discord.gg/chloex"
        if setclipboard then
            setclipboard(link)
            chloex("Successfully Copied!")
        end
    end
})

-- ============================================
-- PART 7: UI ELEMENTS - DIVIDER & SUBSECTION
-- ============================================

--[[
    FUNCTION: Section:AddDivider()
    DESKRIPSI: Menambah garis pemisah
    PARAMETER: None
]]

X1:AddDivider()

--[[
    FUNCTION: Section:AddSubSection()
    DESKRIPSI: Menambah sub-section (biasanya untuk grouping)
    PARAMETER: name (string) - Judul sub-section
]]

X1:AddSubSection("CHLOE CHLOE CHLOE")

-- ============================================
-- PART 8: UI ELEMENTS - PANEL
-- ============================================

--[[
    FUNCTION: Section:AddPanel()
    DESKRIPSI: Panel dengan 2 button dan optional input
    
    PARAMETERS:
    - Title (string): Judul panel
    - Content (string): Subtitle (optional)
    - Placeholder (string): Placeholder text untuk input
    - ButtonText (string): Teks button utama
    - ButtonCallback (function): Fungsi button utama
    - SubButtonText (string): Teks button kedua
    - SubButtonCallback (function): Fungsi button kedua
]]

local PanelSection = Tabs.Main:AddSection("Chloe X | Panel")

-- Panel dengan 2 button (tanpa input)
PanelSection:AddPanel({
    Title = "Chloe X | Discord",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        if setclipboard then
            setclipboard("https://discord.gg/chloex")
            chloex("Link Discord telah disalin ke clipboard.")
        end
    end,
    SubButtonText = "Open Discord",
    SubButtonCallback = function()
        game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/chloex")
    end
})

-- Panel dengan 2 button + input
PanelSection:AddPanel({
    Title = "Chloe X | Utility",
    Placeholder = "https://discord.com/api/webhooks/...",
    ButtonText = "Rejoin Server",
    ButtonCallback = function()
        chloex("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

-- Panel dengan webhook (2 button + input)
PanelSection:AddPanel({
    Title = "Chloe X | Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    ButtonText = "Simpan Webhook",
    ButtonCallback = function(url)
        if url == "" then
            chloex("Mohon isi URL webhook terlebih dahulu.")
            return
        end
        _G.ChloeWebhook = url
        ConfigData.WebhookURL = url
        SaveConfig()
        chloex("Webhook telah disimpan.")
    end,
    SubButtonText = "Test Webhook",
    SubButtonCallback = function()
        if not _G.ChloeWebhook or _G.ChloeWebhook == "" then
            chloex("Webhook belum diset.")
            return
        end
        chloex("Mengirim test webhook...")
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local data = { content = "Test webhook dari Chloe X." }
            pcall(function()
                HttpService:PostAsync(_G.ChloeWebhook, HttpService:JSONEncode(data))
            end)
        end)
    end
})

-- ============================================
-- PART 9: UI ELEMENTS - BUTTON
-- ============================================

--[[
    FUNCTION: Section:AddButton()
    DESKRIPSI: Button single atau double
    
    PARAMETERS:
    - Title (string): Teks button utama
    - SubTitle (string): Subtitle (optional)
    - Callback (function): Fungsi button utama
    - SubCallback (function): Fungsi button kedua (optional)
]]

local BtnSection = Tabs.Main:AddSection("Chloe X | Button")

-- Single Button
BtnSection:AddButton({
    Title = "Open Discord",
    Callback = function()
        chloex("Membuka Discord...")
        game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/chloex")
    end
})

-- Double Button
BtnSection:AddButton({
    Title = "Rejoin",
    SubTitle = "Server Hop",
    Callback = function()
        chloex("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
    SubCallback = function()
        chloex("Mencari server baru...")
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Servers = Http:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" ..
            game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in pairs(Servers.data) do
            if v.playing < v.maxPlayers then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
                return
            end
        end
        chloex("Tidak ada server kosong ditemukan.")
    end
})

-- ============================================
-- PART 10: UI ELEMENTS - TOGGLE
-- ============================================

--[[
    FUNCTION: Section:AddToggle()
    DESKRIPSI: Toggle switch
    
    PARAMETERS:
    - Title (string): Label utama toggle
    - Title2 (string): Label kedua (optional)
    - Content (string): Deskripsi
    - Default (boolean): State awal
    - Callback (function): Fungsi saat toggle berubah
]]

local ToggleSection = Tabs.Main:AddSection("Chloe X | Toggle")

-- Single Toggle
ToggleSection:AddToggle({
    Title = "Auto Fishing",
    Content = "Aktifkan auto fishing menggunakan Chloe X System.",
    Default = false,
    Callback = function(state)
        if state then
            chloex("Auto Fishing diaktifkan.")
            _G.AutoFish = true
        else
            chloex("Auto Fishing dimatikan.")
            _G.AutoFish = false
        end
    end
})

-- Toggle dengan Sub Title
ToggleSection:AddToggle({
    Title = "Auto Sell",
    Title2 = "Sell All Fish Automatically",
    Content = "Menjual semua ikan setelah menangkapnya.",
    Default = false,
    Callback = function(state)
        if state then
            chloex("Auto Sell aktif.")
            _G.AutoSell = true
        else
            chloex("Auto Sell nonaktif.")
            _G.AutoSell = false
        end
    end
})

-- ============================================
-- PART 11: UI ELEMENTS - SLIDER
-- ============================================

--[[
    FUNCTION: Section:AddSlider()
    DESKRIPSI: Slider untuk input angka
    
    PARAMETERS:
    - Title (string): Label slider
    - Content (string): Deskripsi
    - Min (number): Nilai minimum
    - Max (number): Nilai maximum
    - Increment (number): Step/kelipatan
    - Default (number): Nilai awal
    - Callback (function): Fungsi saat nilai berubah
]]

local SliderSection = Tabs.Main:AddSection("Chloe X | Slider")

SliderSection:AddSlider({
    Title = "Fishing Delay",
    Content = "Atur jeda waktu auto fishing.",
    Min = 0.1,
    Max = 5,
    Increment = 0.1,
    Default = 1,
    Callback = function(value)
        _G.Delay = value
        chloex("Delay diset ke: " .. tostring(value) .. " detik.")
    end
})

SliderSection:AddSlider({
    Title = "Sound Volume",
    Content = "Sesuaikan volume efek suara Chloe X.",
    Min = 0,
    Max = 100,
    Increment = 5,
    Default = 50,
    Callback = function(value)
        chloex("Volume diubah ke: " .. tostring(value) .. "%")
    end
})

SliderSection:AddSlider({
    Title = "Animation Speed",
    Content = "Atur kecepatan animasi antarmuka Chloe X.",
    Min = 0.5,
    Max = 2,
    Increment = 0.1,
    Default = 1,
    Callback = function(value)
        _G.AnimationSpeed = value
        chloex("Kecepatan animasi diset ke: " .. tostring(value) .. "x")
    end
})

-- ============================================
-- PART 12: UI ELEMENTS - INPUT
-- ============================================

--[[
    FUNCTION: Section:AddInput()
    DESKRIPSI: Text input field
    
    PARAMETERS:
    - Title (string): Label input
    - Content (string): Deskripsi
    - Default (string): Nilai awal
    - Callback (function): Fungsi saat input berubah
]]

local InputSection = Tabs.Main:AddSection("Chloe X | Input")

InputSection:AddInput({
    Title = "Username",
    Content = "Masukkan nama pengguna kamu untuk disimpan di konfigurasi.",
    Default = "",
    Callback = function(value)
        _G.ChloeUsername = value
        chloex("Username diset ke: " .. value)
    end
})

-- ============================================
-- PART 13: UI ELEMENTS - DROPDOWN
-- ============================================

--[[
    FUNCTION: Section:AddDropdown()
    DESKRIPSI: Dropdown selection
    
    PARAMETERS:
    - Title (string): Label dropdown
    - Content (string): Deskripsi
    - Options (table): Daftar pilihan
    - Multi (boolean): 
        - false = single select (default)
        - true = multi select
    - Default (string/table): Pilihan awal
    - Callback (function): Fungsi saat pilihan berubah
    
    METHODS:
    - SetValues(options, default): Update pilihan secara dinamis
]]

local DropdownSection = Tabs.Main:AddSection("Chloe X | Dropdown")

-- Single Select Dropdown
DropdownSection:AddDropdown({
    Title = "Select Theme",
    Content = "Pilih tema antarmuka untuk Chloe X.",
    Options = { "Celestial", "Seraphin", "Nebula", "Luna" },
    Default = "Celestial",
    Callback = function(value)
        _G.SelectedTheme = value
        chloex("Tema diubah ke: " .. value)
    end
})

-- Multi Select Dropdown
DropdownSection:AddDropdown({
    Title = "Select Features",
    Content = "Pilih beberapa fitur Chloe X yang ingin diaktifkan.",
    Multi = true,
    Options = { "Auto Fishing", "Auto Sell", "Auto Quest", "Webhook Notification" },
    Default = { "Auto Fishing" },
    Callback = function(selected)
        _G.ActiveFeatures = selected
        chloex("Fitur aktif: " .. table.concat(selected, ", "))
    end
})

-- Dynamic Dropdown (bisa di-update)
local DynamicDropdown = DropdownSection:AddDropdown({
    Title = "Select Bait",
    Content = "Pilih umpan yang akan digunakan.",
    Options = {},
    Default = nil,
    Callback = function(value)
        _G.SelectedBait = value
        chloex("Umpan dipilih: " .. value)
    end
})

-- Contoh update dynamic dropdown
task.spawn(function()
    task.wait(1)
    local baitList = { "Common Bait", "Rare Bait", "Mythic Bait", "Divine Bait" }
    DynamicDropdown:SetValues(baitList, "Common Bait")
end)

-- ============================================
-- PART 14: CONFIGURATION SYSTEM
-- ============================================

--[[
    CONFIGURATION SYSTEM:
    - Auto-save semua state UI elements
    - Disimpan berdasarkan Version number
    - Jika Version diubah, config akan reset
    
    CARA KERJA:
    1. Semua toggle, slider, input, dropdown otomatis tersimpan
    2. Data tersimpan di ConfigData global table
    3. SaveConfig() dipanggil otomatis saat ada perubahan
    4. Bisa juga dipanggil manual untuk custom data
]]

-- Contoh custom config
ConfigData.WebhookURL = "https://discord.com/api/webhooks/..."
ConfigData.PlayerName = "Player123"
SaveConfig() -- Simpan manual

-- ============================================
-- PART 15: GLOBAL VARIABLES (BEST PRACTICE)
-- ============================================

--[[
    GLOBAL VARIABLES (_G):
    - Digunakan untuk menyimpan state antar script
    - Bisa diakses dari mana saja
    - Lebih aman daripada menggunakan local variabel
]]

-- Contoh penggunaan _G untuk state management
_G.AutoFish = false
_G.AutoSell = false
_G.Delay = 1
_G.SelectedTheme = "Celestial"
_G.ActiveFeatures = { "Auto Fishing" }
_G.SelectedBait = "Common Bait"
_G.ChloeWebhook = ""
_G.ChloeUsername = ""
_G.AnimationSpeed = 1

-- ============================================
-- PART 16: COMPLETE WORKING EXAMPLE
-- ============================================

--[[
    CONTOH LENGKAP: UI untuk Auto Farm Game
]]

-- Load Library
local Chloex = loadstring(game:HttpGet("RAW"))()

-- Create Window
local Window = Chloex:Window({
    Title = "ChloeX |",
    Footer = "Auto Farm",
    Image = "136505615779937",
    Color = Color3.fromRGB(0, 208, 255),
    Theme = 9542022979,
    Version = 1
})

-- Create Tabs
local Tabs = {
    Farm = Window:AddTab({ Name = "Farming", Icon = "user" }),
    Settings = Window:AddTab({ Name = "Settings", Icon = "settings" })
}

-- === FARM TAB ===
local FarmSection = Tabs.Farm:AddSection("Chloe X | Auto Farm")

-- Toggle Auto Farm
FarmSection:AddToggle({
    Title = "Enable Auto Farm",
    Content = "Aktifkan auto farming otomatis",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        if state then
            chloex("Auto Farm Diaktifkan!")
            -- Start farming loop
            task.spawn(function()
                while _G.AutoFarm do
                    -- Farming logic here
                    task.wait(_G.FarmDelay or 1)
                end
            end)
        else
            chloex("Auto Farm Dimatikan!")
        end
    end
})

-- Slider Delay
FarmSection:AddSlider({
    Title = "Farm Delay",
    Content = "Atur jeda waktu farming",
    Min = 0.5,
    Max = 5,
    Increment = 0.5,
    Default = 1,
    Callback = function(value)
        _G.FarmDelay = value
    end
})

-- Dropdown Mode
FarmSection:AddDropdown({
    Title = "Farm Mode",
    Content = "Pilih mode farming",
    Options = { "Normal", "Fast", "Efficient" },
    Default = "Normal",
    Callback = function(value)
        _G.FarmMode = value
        chloex("Mode farming: " .. value)
    end
})

-- === SETTINGS TAB ===
local SettingsSection = Tabs.Settings:AddSection("Chloe X | Settings")

-- Button Rejoin
SettingsSection:AddButton({
    Title = "Rejoin Server",
    SubTitle = "Cari server baru",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
    SubCallback = function()
        -- Find new server logic
        chloex("Mencari server baru...")
    end
})

-- Input Webhook
SettingsSection:AddInput({
    Title = "Webhook URL",
    Content = "Untuk notifikasi Discord",
    Default = "",
    Callback = function(value)
        _G.WebhookURL = value
        ConfigData.WebhookURL = value
        SaveConfig()
    end
})

-- Notifikasi selesai
Chloex:MakeNotify({
    Title = "Chloe X",
    Description = "Auto Farm UI Loaded!",
    Content = "Selamat farming!",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 3
})

-- ============================================
-- PART 17: COMMON MISTAKES & TIPS
-- ============================================

--[[
    ❌ COMMON MISTAKES:
    
    1. LUPA MENYIMPAN CONFIG
       ❌ Salah: Hanya set _G tanpa SaveConfig
       ✅ Benar: ConfigData.KEY = value; SaveConfig()
    
    2. SALAH TIPE DATA
       ❌ Salah: Default = "true" (string)
       ✅ Benar: Default = true (boolean)
    
    3. LUPA CEK setclipboard
       ❌ Salah: Langsung panggil setclipboard
       ✅ Benar: if setclipboard then setclipboard(text) end
    
    4. LOOP INFINITE TANPA BREAK
       ❌ Salah: while true do end
       ✅ Benar: while _G.AutoFarm do end (bisa di-stop)
    
    5. SALAH MENGGUNAKAN MULTI DROPDOWN
       ❌ Salah: Default = "Option1"
       ✅ Benar: Default = { "Option1" }
    
    💡 PRO TIPS:
    
    1. Gunakan _G untuk state yang perlu diakses global
    2. Selalu gunakan pcall untuk HTTP requests
    3. Simpan semua config di ConfigData sebelum SaveConfig()
    4. Gunakan task.wait() bukan wait()
    5. Selalu beri notifikasi untuk feedback user
    6. Group UI elements dengan SubSection untuk organisasi
    7. Gunakan alwaysOpen = true untuk section penting
    8. Dynamic dropdown sangat berguna untuk data dari API
]]

-- ============================================
-- PART 18: QUICK REFERENCE CARD
-- ============================================

--[[
    QUICK REFERENCE:
    
    1. LOAD:      local Chloex = loadstring(game:HttpGet("RAW"))()
    2. WINDOW:    Chloex:Window({ Title, Footer, Image, Color, Theme, Version })
    3. NOTIFY:    Chloex:MakeNotify({ Title, Description, Content, Color, Delay })
    4. NOTIFY SH: chloex("text") or than("text")
    5. TAB:       Window:AddTab({ Name, Icon })
    6. SECTION:   Tab:AddSection("name", alwaysOpen)
    7. PARAGRAPH: Section:AddParagraph({ Title, Content, Icon, ButtonText, ButtonCallback })
    8. DIVIDER:   Section:AddDivider()
    9. SUBSECT:   Section:AddSubSection("name")
    10. PANEL:    Section:AddPanel({ Title, Placeholder, ButtonText, ButtonCallback, SubButtonText, SubButtonCallback })
    11. BUTTON:   Section:AddButton({ Title, SubTitle, Callback, SubCallback })
    12. TOGGLE:   Section:AddToggle({ Title, Title2, Content, Default, Callback })
    13. SLIDER:   Section:AddSlider({ Title, Content, Min, Max, Increment, Default, Callback })
    14. INPUT:    Section:AddInput({ Title, Content, Default, Callback })
    15. DROPDOWN: Section:AddDropdown({ Title, Content, Options, Multi, Default, Callback })
    16. DYN DROP: Dropdown:SetValues(options, default)
    17. CONFIG:   ConfigData.KEY = value; SaveConfig()
    18. GLOBAL:   _G.VariableName = value
]]

-- ============================================
-- PART 19: LOCK COMPONENT FEATURE
-- ============================================

--[[
    Library ini sekarang mendukung fitur "Lock" untuk komponen UI.
    Fitur ini berguna jika Anda ingin mendisable (membuat redup dan tidak bisa diklik)
    suatu komponen secara dinamis melalui script (misal: saat sedang proses auto-farm).
]]

local LockSection = MiscTab:AddSection("Lock Component Demo", true)

-- 1. Buat komponennya dan simpan di dalam variabel
local lock = LockSection:AddToggle({
    Title = "Toggle Terkunci",
    Content = "Contoh toggle yang sedang belum selesai dibuat.",
    Default = false,
    Callback = function(value) end
})

-- 2. Panggil fungsi Lock dengan memasukkan teks/alasan penguncian
lock:Lock("Not finish yet")

-- Catatan: Jika ingin membuka kuncinya kembali, gunakan `lock:Lock(false)`
-- Fitur :Lock() juga tersedia untuk AddSlider, AddInput, AddDropdown, dan AddButton!

-- ============================================
-- END OF DOCUMENTATION
-- ============================================
-- Library ini mendukung auto-save/load config,
-- sehingga semua pengaturan user tersimpan secara otomatis.
-- Selamat coding dengan Chloe X! 🚀
-- ============================================