# Than Hub UI Library (Chloex)

Sebuah UI Library Roblox modern, responsif, dan kaya fitur yang dikembangkan untuk mempermudah pembuatan script Hub di Roblox. Dilengkapi dengan berbagai komponen interaktif, dukungan notifikasi, auto-save konfigurasi, hingga fitur penguncian (*Lock Component*) dinamis.

## 🌟 Fitur Utama
- **Desain Modern & Gelap (Dark Theme)** dengan *smooth animations*.
- **Auto-Save & Load Configuration**: Pengaturan pengguna tidak akan hilang!
- **Notifikasi Keren** dengan *drop shadow*.
- **Mendukung Fitur Lock**: Kunci komponen dengan mudah jika fitur belum selesai (*WIP*) atau sedang *auto-farming*.
- **Mendukung Lucide Icons**: Banyak ikon bawaan yang bisa langsung dipakai.

---

## 🚀 Quick Start / Cara Penggunaan

Cukup salin script ini ke dalam executor Anda untuk melihat demo *Than Hub*:

```lua
-- 1. Load Library
local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/hamadddds1/Thanlibrary/refs/heads/main/Mlibrary/ThanV2.lua"))()

-- 2. Membuat Window Utama
local Window = Chloex:Window({
    Title   = "ThanHub |",              
    Footer  = "99Night",                
    Image   = "85779221265543",        
    Color   = Color3.fromRGB(0, 208, 255), 
    Theme   = 9542022979,  -- WAJIB MENGGUNAKAN ANGKA ASSET ID INI
    Version = 1,                        
})

-- 3. Membuat Tab & Section
local MainTab = Window:AddTab({ Name = "Demo", Icon = "rbxassetid://108483430622128" })
local Section = MainTab:AddSection("Fitur Dasar", true)

-- 4. Contoh Komponen (Toggle)
local myToggle = Section:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Status Toggle:", value)
    end
})
```

---

## 🔒 Fitur Lock Component (Baru!)

Kini Anda dapat dengan mudah **menonaktifkan / mengunci** sebuah komponen secara dinamis. Fitur ini sangat berguna untuk menampilkan bahwa suatu fitur masih dalam tahap pengerjaan (*Work in Progress / WIP*).

```lua
-- Buat Toggle
local myWIP_Toggle = Section:AddToggle({
    Title = "Fitur Rahasia",
    Default = false,
    Callback = function(value) end
})

-- Kunci toggle dengan memberikan alasan!
myWIP_Toggle:Lock("Not finish yet")
```

Saat dikunci, komponen akan diselimuti *overlay gelap* dengan logo Gembok (Lock) dan teks **"Locked : Not finish yet"** di atasnya. Komponen juga otomatis tidak bisa diklik!

---

## 📚 Dokumentasi Lebih Lanjut
Untuk melihat contoh script penggunaan seluruh komponen (Button, Slider, Input, Dropdown), silakan buka file [`MComponent/Component.lua`](https://github.com/hamadddds1/Thanlibrary/blob/main/MComponent/Component.lua) di repository ini.

**Developed with ❤️ by Than**
