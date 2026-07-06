<div align="center">
  <h1>🌟 Than Hub UI Library (Chloex)</h1>
  <p>A modern, responsive, and feature-rich Roblox UI Library designed to streamline Hub script creation. Packed with interactive components, robust notification support, auto-save configuration, and a dynamic Component Lock feature.</p>
</div>

## ✨ Key Features
- **Modern Dark Theme** with smooth micro-animations.
- **Top Bar Customization**: Beautifully stacked Title and Footer with built-in Lucide icon support and separators.
- **Tab Sections**: Create elegant nested dropdown tabs to categorize your features perfectly.
- **Auto-Save & Load Configuration**: User settings are persistent across sessions.
- **Sleek Notifications** with drop shadow effects.
- **Lock Component Feature**: Dynamically lock and disable components that are Work-In-Progress (WIP) or during auto-farming.
- **Lucide Icons Integration**: A massive library of built-in icons ready to use across the UI (Tabs, TabSections, Toggles, and Window Headers).

---

## 🚀 Initialization

To start using the library, load it via `loadstring` and initialize the main window.

```lua
-- 1. Load the Library
local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/hamadddds1/Thanlibrary/refs/heads/main/Mlibrary/ThanV2.lua"))()

-- 2. Create the Main Window
local Window = Chloex:Window({
    Title   = "ThanHub",               -- Main Window Title (automatically separated from Footer)
    Footer  = "99Night",                 -- Subtitle / Footer text (displays neatly below the title)
    Micon   = "85779221265543",          -- Floating Hide/Show Button Logo (rbxassetid or Lucide)
    Uicon   = "gamepad-2",               -- Top Bar Logo (rbxassetid or Lucide)
    Theme   = "Ruby",                    -- Custom Themes (e.g., "Dark", "Ruby", "Ocean") or a background Image ID
    Version = 1,                         -- Config Version (Resets config if changed)
})
```

### Window Configuration Explained:
- **`Title`**: The primary title text at the top-left of the UI.
- **`Footer`**: Secondary subtitle text that perfectly stacks below the Title.
- **`Micon`** (Main Icon): Controls the image used for the floating **Hide/Show UI button** on the screen. Accepts a Roblox Asset ID (e.g. `"85779221265543"`) or a Lucide icon string (e.g. `"gamepad-2"`).
- **`Uicon`** (UI Icon): Controls the logo displayed inside the **Top Bar** of the UI (next to the Title). Accepts a Roblox Asset ID or a Lucide icon string.
- **`Theme`**: You can enter a **Custom Theme Name** (e.g., `"Ruby"`, `"Ocean"`, `"Amethyst"`, `"Dark"`, `"Emerald"`, `"Sakura"`, `"Default"`) to automatically color the UI. Alternatively, you can input a custom Roblox Asset ID number for the background image.
- **`Color`** *(Optional)*: The primary accent color for the UI. If you are using a Custom Theme Name, you can omit this entirely!
- **`Version`**: Changing this number will automatically reset and clear old configurations for your users.

---

## 🚀 Tabs and Sections

Organize your user interface efficiently using Tabs, Sections, and SubSections.

```lua
-- Create a Tab
local MainTab = Window:AddTab({ Name = "Main", Icon = "home" }) -- Use any Lucide icon name!

-- Create a Tab Section (Expandable Dropdown for Tabs)
local TabGroup = Window:AddTabSection({ Name = "Farming", Icon = "swords" })

-- Create Nested Tabs inside the Tab Section
local LevelTab = TabGroup:AddTab({ Name = "Level Farm", Icon = "chevron-right" })
local BossTab = TabGroup:AddTab({ Name = "Boss Farm", Icon = "chevron-right" })

-- Create a Section inside a Tab
local Section = MainTab:AddSection("Basic Features", true)

-- Create a SubSection (Great for grouping related elements together inside a section)
local SubSection = Section:AddSubSection("Combat Settings")
```

---

## 🧩 Components API

Here is a comprehensive list of all the interactive elements you can add to your sections or subsections.

### 1. Button
A simple clickable button. It can optionally have a sub-button attached to it.
```lua
local MyButton = Section:AddButton({
    Title = "Click Me",
    SubTitle = "Optional secondary button", -- Remove if not needed
    Callback = function()
        print("Main button clicked!")
    end,
    SubCallback = function()
        print("Sub-button clicked!")
    end
})
```

### 2. Toggle (With Lucide Icon)
A switch used for boolean states (ON / OFF). You can use any icon name from [Lucide Icons](https://lucide.dev/icons/)!
```lua
local MyToggle = Section:AddToggle({
    Title = "Auto Farm",
    Content = "Automatically kill mobs",
    Icon = "swords", -- Just type the Lucide icon name!
    Default = false,
    Callback = function(state)
        print("Toggle is now:", state)
    end
})
```

### 3. Slider
A draggable slider for selecting a numeric value within a specific range.
```lua
local MySlider = Section:AddSlider({
    Title = "Walk Speed",
    Content = "Adjust player speed",
    Min = 16,
    Max = 100,
    Increment = 1,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})
```

### 4. Dropdown
A selectable list of options. Supports both single-selection and multi-selection.
```lua
local MyDropdown = Section:AddDropdown({
    Title = "Select Weapon",
    Content = "Choose your preferred weapon",
    Options = {"Sword", "Gun", "Bow"},
    Multi = false, -- Set to true to allow multiple selections
    Default = "Sword", -- Use a table e.g., {"Sword"} if Multi is true
    Callback = function(value)
        print("Selected:", value)
    end
})

-- Dynamic Dropdown (Update options dynamically later on)
MyDropdown:SetValues({"Axe", "Spear"}, "Axe")
```

### 5. Input (TextBox)
A text field allowing users to type custom strings or numbers.
```lua
local MyInput = Section:AddInput({
    Title = "Webhook URL",
    Content = "Enter your Discord Webhook",
    Default = "",
    Callback = function(value)
        print("Input received:", value)
    end
})
```

### 6. Additional Layout Elements
```lua
-- Paragraph: Display static text with an optional button
Section:AddParagraph({
    Title = "Information",
    Content = "Welcome to Than Hub. Enjoy your stay!",
    Icon = "rbxassetid://108483430622128",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        setclipboard("https://discord.gg/yourlink")
    end
})

-- Divider: A simple horizontal line to separate components
Section:AddDivider()
```

---

## 🔒 Lock Component Feature (WIP Indicator)

You can easily **disable / lock** any interactive component dynamically. This is extremely useful for showcasing features that are currently under development (Work-In-Progress) or temporarily disabling inputs while an automated task is running.

```lua
local lockedToggle = Section:AddToggle({
    Title = "Auto Boss (WIP)",
    Default = false,
    Callback = function(value) end
})

-- Lock the component and provide a reason!
lockedToggle:Lock("Not finish yet")
```
When locked, the component is covered by a dark overlay featuring a Padlock icon and the text **"Locked : Not finish yet"**. It becomes entirely unclickable. 
To unlock it later, simply call: `lockedToggle:Lock(false)`

*(Note: The `:Lock(reason)` method is supported on Toggles, Sliders, Dropdowns, Inputs, and Buttons!)*

---

## 🔔 Notifications

Trigger beautiful, non-intrusive popup notifications on the screen.

```lua
-- Detailed Notification
Chloex:MakeNotify({
    Title = "System",
    Description = "Loaded Successfully!",
    Content = "Enjoy using the script.",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 3 -- Time in seconds before it disappears
})

-- Short Notification (Quick Pop-up)
chloex("Welcome back!") 
-- alternatively: than("Welcome back!")
```

---

## ⚙️ Configuration System (Auto-Save)

The library automatically handles saving most component states. However, you can save custom data manually to the configuration file.

```lua
-- 1. Save data to the config table
ConfigData.MyCustomSetting = "Hello World"

-- 2. Call SaveConfig() to write it to the local file
SaveConfig()
```

*(Note: Changing the `Version` parameter during `Chloex:Window` initialization will automatically wipe and reset the configuration file for the user.)*

---
<div align="center">
  <b>Developed with ❤️ by Than</b>
</div>
