<div align="center">
  <h1>TahoeUI ✦ Tahoe Edition</h1>
  <p><strong>A premium, Liquid-Glass UI Library for Roblox, inspired by macOS Tahoe.</strong></p>

  <img src="https://img.shields.io/badge/Roblox-Studio-00A2FF?style=for-the-badge&logo=roblox&logoColor=white" alt="Roblox" />
  <img src="https://img.shields.io/badge/Language-Luau-005571?style=for-the-badge&logo=lua&logoColor=white" alt="Luau" />
  <img src="https://img.shields.io/badge/UI-Liquid%20Glass-8A5CFF?style=for-the-badge" alt="Liquid Glass UI" />
  
  <br><br>
</div>

TahoeUI is a state-of-the-art UI library designed for modern Roblox script execution. Focused on **OCD-level pixel perfection**, buttery-smooth animations, and a rich *Liquid-Glass* aesthetic, TahoeUI guarantees a premium experience for your users.

## ✨ Features
- 🎨 **5 Premium Themes**: `Dark`, `Transparent`, `Midnight`, `Rose`, `Ocean`.
- 🧊 **Liquid Glass Aesthetics**: Advanced `CanvasGroup` clipping, precise corner radii, and drop-shadow styling.
- ⚡ **Buttery Smooth Animations**: Every component uses custom spring-driven physics for interactions.
- 📐 **Dynamic Window**: Supports elegant slide-to-side minimizing (ToggleKey/Minimize button) and draggable corner resizing.
- 🔒 **Component Locking**: Beautiful frosted-glass overlay for locking/unlocking components dynamically.
- 🏷️ **Sidebar Tags**: Display versioning or status using multiple customizable tags.
- 💬 **Modal Popups**: Built-in popup system for confirmations or important alerts.
- 📂 **Nested Layouts**: Supports `TabSections` (collapsible sidebars) and nested content `Sections`.
- 🔔 **Built-in Notification System**: Elegant, stacking toast notifications.
- 💎 **Lucide Icons API**: Effortlessly integrate any Lucide-compatible icon natively.

---

## 🚀 Getting Started

### 1. Bootstrapping the Library
To always ensure you are loading the absolute latest, cache-free version of TahoeUI, use our direct loader:

```lua
local TahoeUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/hamaddddds/Tahoe-library/main/main.lua"))()
```

### 2. Creating a Window
The Window is the core container of your UI.

```lua
local Window = TahoeUI:CreateWindow({
    Title     = "TahoeApp",
    Subtitle  = "Premium Edition v2.0",
    Theme     = "Transparent", -- Dark, Transparent, Midnight, Rose, Ocean
    Size      = UDim2.fromOffset(580, 400), -- Optional
    ToggleKey = Enum.KeyCode.RightControl -- Key to show/hide UI
})
```

### 3. Adding Sidebar Tags
You can add elegant, customizable tags to the bottom-left of the sidebar. They stack automatically!

```lua
local Tag1 = Window:Tag({
    Title = "v2.0",
    Color = Color3.fromHex("#facc15"), 
    Radius = 100
})

-- You can destroy them later:
-- Tag1:Destroy()
```

### 4. Spawning Popups
TahoeUI provides a built-in Modal Popup system for confirmations or alerts.

```lua
Window:Popup({
    Title = "Warning",
    Content = "Are you sure you want to delete this configuration?",
    Icon = "alert-triangle",
    Buttons = {
        {
            Name = "Cancel",
            Type = "Secondary",
            Callback = function() print("Cancelled") end
        },
        {
            Name = "Delete",
            Type = "Danger",
            Callback = function() print("Deleted!") end
        }
    }
})
```

---

## 📚 Documentation

> **💡 Variable Naming Convention**
> Throughout this documentation, we use short variable names to keep the code clean and easy to read:
> - `TSection` = Tab Section
> - `T` = Tab
> - `F` = Function (Content Section)
> - `C` = Component (Sliders, Buttons, etc.)

### 📑 Navigation (Tabs & Sections)

#### Creating a Tab Section
Tab Sections allow you to group multiple tabs under a collapsible header in the sidebar.

```lua
local TSection = Window:CTabSection({ Name = "Combat" })
```

#### Creating a Tab
Tabs hold your actual content. You can attach them to a `TabSection` or directly to the `Window`.

```lua
-- Attached to a TabSection:
local T = TSection:CTab({ Name = "Aimbot", Icon = "crosshair" })

-- Attached directly to the Window:
local T2 = Window:CTab({ Name = "Settings", Icon = "settings" })
```

#### Creating a Content Section
Inside a Tab, you can group components together inside a collapsible content section.

```lua
local F = T:CSection({ Name = "Main Features", Icon = "sword" })
```

---

### 🧩 Components

All components can be created inside a `Tab` or a `Section`.

> **🔒 Component Locking**
> Every interactive component (`Toggle`, `Slider`, `Dropdown`, `Input`, `Keybind`, `Button`) supports `.Lock(reason)` and `.Unlock()`. This adds a beautiful frosted-glass overlay with a padlock icon, disabling interaction until unlocked!
> ```lua
> local myBtn = F:CButton({ Name = "VIP Feature", Callback = function() end })
> myBtn:Lock("Requires VIP") -- Locks the button
> -- myBtn:Unlock() -- Unlocks it
> ```

#### Toggle
```lua
F:CToggle({ 
    Name = "Enable Aimbot", 
    Description = "Automatically aims at players", 
    Default = false, 
    Callback = function(Value) 
        print("Toggled:", Value) 
    end 
})
```

#### Slider
```lua
F:CSlider({ 
    Name = "FOV Size", 
    Description = "Size of the targeting circle",
    Min = 10, 
    Max = 360, 
    Default = 90, 
    Callback = function(Value) 
        print("Slider Value:", Value) 
    end 
})
```

#### Dropdown
```lua
F:CDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "Left Arm", "Right Arm"},
    Default = "Head",
    Callback = function(Value) 
        print("Selected:", Value) 
    end
})
```

#### Keybind
```lua
F:CKeybind({
    Name = "Lock Keybind",
    Default = Enum.KeyCode.E,
    Callback = function(Key) 
        print("Key pressed:", Key.Name) 
    end
})
```

#### Input (Textbox)
```lua
F:CInput({ 
    Name = "Config Name", 
    Placeholder = "Enter name here...",
    Callback = function(Text) 
        print("Input received:", Text) 
    end
})
```

#### Button
```lua
F:CButton({ 
    Name = "Execute Script", 
    Description = "Runs the main script",
    Callback = function() 
        print("Button clicked!") 
    end 
})
```

#### Paragraph & Label
```lua
-- Label (Single line text)
F:CLabel("This is a simple text label.")

-- Paragraph (Block of text)
F:CParagraph({
    Title = "Warning",
    Content = "Please use these features at your own risk. We are not responsible for bans."
})
```

---

### 🔔 Notifications
TahoeUI features a stunning, auto-stacking notification system. 

```lua
TahoeUI:Notify({
    Title    = "Success",
    Content  = "Configuration has been saved successfully!",
    Type     = "success", -- success, info, warning, error
    Duration = 3 -- Seconds before it fades out
})
```

---

### 🎭 Icons API (Lucide Integration)

TahoeUI natively supports Lucide icons. You can register your own custom `rbxassetid` icons if needed!

```lua
-- Register a single custom icon
TahoeUI.Icons:Register("custom-sword", "rbxassetid://12345678")

-- Batch register multiple
TahoeUI.Icons:BatchRegister({
    ["shield"] = "rbxassetid://111111",
    ["magic"]  = "rbxassetid://222222"
})
```
*Note: We automatically fetch the Fluent/Lucide icon mappings in the background, so standard icon names like `crosshair`, `settings`, `eye` work out of the box!*

---

<div align="center">
  <p>Crafted with ❤️ for the Roblox Scripting Community</p>
</div>
