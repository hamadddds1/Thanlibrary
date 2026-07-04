--[[
	MadUI · v2.0.0
	Liquid Glass UI Library for Roblox
	Inspired by macOS Tahoe

	Load:
		local MadUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/hamaddddds/Tahoe-library/main/Tahoelibrary.luau"))()

	Quick Start:
		local Window = MadUI:CreateWindow({
			Title    = "My App",
			Subtitle = "v2.0",
			Theme    = "Dark",        -- Dark, Transparent, Midnight, Rose, Ocean
		})

		-- Tab Section (collapsible group in sidebar)
		local Combat = Window:CreateTabSection({ Name = "Combat" })
		local AimbotTab = Combat:CreateTab({ Name = "Aimbot", Icon = "crosshair" })
		local ESPTab    = Combat:CreateTab({ Name = "ESP",    Icon = "eye" })

		-- Direct Tab
		local General = Window:CreateTab({ Name = "General", Icon = "settings" })

		-- Content Section (collapsible component group)
		local Settings = General:CreateSection({ Name = "Settings" })
		Settings:CreateToggle({ Name = "Feature", Callback = function(v) end })
		Settings:CreateSlider({ Name = "Speed", Min = 0, Max = 100, Callback = function(v) end })

		-- Direct components
		General:CreateButton({ Name = "Execute", Callback = function() end })

		-- Icons (Lucide)
		MadUI.Icons:Register("myicon", "rbxassetid://12345")
		MadUI.Icons:BatchRegister({ sword = "rbxassetid://111", shield = "rbxassetid://222" })

		-- Notifications
		MadUI:Notify({ Title = "Done", Content = "Ready!", Duration = 3, Type = "success" })
]]

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInput    = game:GetService("UserInputService")
local player       = Players.LocalPlayer

-- ── Easing ──────────────────────────────────────────

local Ease = {
	smooth = TweenInfo.new(0.30, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	spring = TweenInfo.new(0.42, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
	quick  = TweenInfo.new(0.14, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out),
	slow   = TweenInfo.new(0.50, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	bounce = TweenInfo.new(0.28, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
	linear = function(d)
		return TweenInfo.new(d, Enum.EasingStyle.Linear)
	end,
}

-- ── Themes ──────────────────────────────────────────

local Themes = {
	Dark = {
		windowBg    = Color3.fromRGB(24, 24, 28),
		windowTrans = 0,
		sidebarBg   = Color3.fromRGB(30, 30, 35),
		sidebarTrans = 0.12,
		surface     = Color3.fromRGB(32, 32, 36),
		elevated    = Color3.fromRGB(42, 42, 48),
		hover       = Color3.fromRGB(54, 54, 60),
		accent      = Color3.fromRGB(10, 132, 255),
		accentDim   = Color3.fromRGB(8,  100, 200),
		text        = Color3.fromRGB(255, 255, 255),
		sub         = Color3.fromRGB(142, 142, 148),
		dim         = Color3.fromRGB(88,  88,  96),
		border      = Color3.fromRGB(52, 52, 58),
		glass       = Color3.fromRGB(255, 255, 255),
		red         = Color3.fromRGB(255, 69,  58),
		yellow      = Color3.fromRGB(255, 189, 46),
		green       = Color3.fromRGB(50,  205, 75),
	},
	Transparent = {
		windowBg    = Color3.fromRGB(12, 12, 16),
		windowTrans = 0.38,
		sidebarBg   = Color3.fromRGB(16, 16, 20),
		sidebarTrans = 0.42,
		surface     = Color3.fromRGB(20, 20, 24),
		elevated    = Color3.fromRGB(32, 32, 38),
		hover       = Color3.fromRGB(44, 44, 50),
		accent      = Color3.fromRGB(10, 132, 255),
		accentDim   = Color3.fromRGB(8,  100, 200),
		text        = Color3.fromRGB(255, 255, 255),
		sub         = Color3.fromRGB(142, 142, 148),
		dim         = Color3.fromRGB(88,  88,  96),
		border      = Color3.fromRGB(66, 66, 72),
		glass       = Color3.fromRGB(255, 255, 255),
		red         = Color3.fromRGB(255, 69,  58),
		yellow      = Color3.fromRGB(255, 189, 46),
		green       = Color3.fromRGB(50,  205, 75),
	},
	Midnight = {
		windowBg    = Color3.fromRGB(14, 14, 30),
		windowTrans = 0.06,
		sidebarBg   = Color3.fromRGB(18, 16, 36),
		sidebarTrans = 0.1,
		surface     = Color3.fromRGB(22, 20, 40),
		elevated    = Color3.fromRGB(34, 32, 54),
		hover       = Color3.fromRGB(46, 44, 66),
		accent      = Color3.fromRGB(138, 92, 255),
		accentDim   = Color3.fromRGB(110, 72, 210),
		text        = Color3.fromRGB(235, 235, 255),
		sub         = Color3.fromRGB(138, 136, 166),
		dim         = Color3.fromRGB(88,  86,  108),
		border      = Color3.fromRGB(54, 52, 74),
		glass       = Color3.fromRGB(200, 200, 255),
		red         = Color3.fromRGB(255, 69,  58),
		yellow      = Color3.fromRGB(255, 189, 46),
		green       = Color3.fromRGB(50,  205, 75),
	},
	Rose = {
		windowBg    = Color3.fromRGB(28, 18, 24),
		windowTrans = 0.04,
		sidebarBg   = Color3.fromRGB(34, 22, 28),
		sidebarTrans = 0.08,
		surface     = Color3.fromRGB(38, 26, 32),
		elevated    = Color3.fromRGB(52, 36, 44),
		hover       = Color3.fromRGB(66, 48, 56),
		accent      = Color3.fromRGB(255, 82, 120),
		accentDim   = Color3.fromRGB(210, 62, 100),
		text        = Color3.fromRGB(255, 242, 246),
		sub         = Color3.fromRGB(166, 136, 148),
		dim         = Color3.fromRGB(108, 86,  96),
		border      = Color3.fromRGB(68, 50, 58),
		glass       = Color3.fromRGB(255, 225, 238),
		red         = Color3.fromRGB(255, 69,  58),
		yellow      = Color3.fromRGB(255, 189, 46),
		green       = Color3.fromRGB(50,  205, 75),
	},
	Ocean = {
		windowBg    = Color3.fromRGB(14, 22, 28),
		windowTrans = 0.04,
		sidebarBg   = Color3.fromRGB(16, 28, 34),
		sidebarTrans = 0.08,
		surface     = Color3.fromRGB(20, 32, 38),
		elevated    = Color3.fromRGB(30, 46, 54),
		hover       = Color3.fromRGB(42, 58, 66),
		accent      = Color3.fromRGB(0, 210, 178),
		accentDim   = Color3.fromRGB(0, 168, 142),
		text        = Color3.fromRGB(235, 255, 250),
		sub         = Color3.fromRGB(126, 160, 152),
		dim         = Color3.fromRGB(76, 100, 94),
		border      = Color3.fromRGB(40, 60, 66),
		glass       = Color3.fromRGB(215, 255, 245),
		red         = Color3.fromRGB(255, 69,  58),
		yellow      = Color3.fromRGB(255, 189, 46),
		green       = Color3.fromRGB(50,  205, 75),
	},
}

local T = Themes.Dark -- active theme ref

-- ── Utility ─────────────────────────────────────────

local function make(class, props, children)
	local inst = Instance.new(class)
	for k, v in props do
		if k ~= "Parent" then
			(inst :: any)[k] = v
		end
	end
	if children then
		for _, ch in children do
			ch.Parent = inst
		end
	end
	if props.Parent then
		inst.Parent = props.Parent
	end
	return inst
end

local function tween(obj, info, goals)
	local tw = TweenService:Create(obj, info, goals)
	tw:Play()
	return tw
end

local function corner(parent, r)
	return make("UICorner", { CornerRadius = UDim.new(0, r), Parent = parent })
end

local function stroke(parent, col, trans, thick)
	return make("UIStroke", {
		Color           = col or T.glass,
		Transparency    = trans or 0.92,
		Thickness       = thick or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent          = parent,
	})
end

local function pad(parent, t, b, l, r)
	return make("UIPadding", {
		PaddingTop    = UDim.new(0, t),
		PaddingBottom = UDim.new(0, b),
		PaddingLeft   = UDim.new(0, l),
		PaddingRight  = UDim.new(0, r),
		Parent        = parent,
	})
end

local function lay(parent, dir, gap)
	return make("UIListLayout", {
		FillDirection = dir or Enum.FillDirection.Vertical,
		Padding       = UDim.new(0, gap or 4),
		SortOrder     = Enum.SortOrder.LayoutOrder,
		Parent        = parent,
	})
end

local function mergeTheme(base, over)
	local r = table.clone(base)
	for k, v in over do r[k] = v end
	return r
end

-- ── Icon System (Lucide-compatible) ─────────────────

local IconMap = {}
local FluentIcons = {}
pcall(function()
	FluentIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/src/Icons.lua"))().assets
end)

local ICON_TEXT = {
	["chevron-down"]  = "▾",  ["chevron-right"] = "▸",
	["chevron-up"]    = "▴",  ["chevron-left"]  = "◂",
	["x"]             = "✕",  ["plus"]          = "+",
	["minus"]         = "—",  ["check"]         = "✓",
	["settings"]      = "⚙",  ["home"]          = "⌂",
	["search"]        = "○",  ["menu"]          = "≡",
	["star"]          = "★",  ["heart"]         = "♥",
	["circle"]        = "●",  ["square"]        = "■",
	["eye"]           = "◉",  ["target"]        = "◎",
	["crosshair"]     = "⊕",  ["zap"]           = "⚡",
	["arrow-right"]   = "→",  ["arrow-left"]    = "←",
	["arrow-up"]      = "↑",  ["arrow-down"]    = "↓",
	["info"]          = "ℹ",  ["alert"]         = "⚠",
	["user"]          = "◯",  ["shield"]        = "◆",
	["lock"]          = "■",  ["globe"]         = "◎",
	["play"]          = "▶",  ["pause"]         = "❙❙",
	["refresh"]       = "↻",  ["copy"]          = "⧉",
	["edit"]          = "✎",  ["folder"]        = "▤",
	["file"]          = "▥",  ["download"]      = "↧",
	["upload"]        = "↥",  ["send"]          = "➤",
	["sword"]         = "†",  ["wand"]          = "✦",
	["gamepad"]       = "▣",  ["monitor"]       = "▢",
}

local IconsAPI = {}

function IconsAPI:Register(name, assetId)
	IconMap[name] = assetId
end

function IconsAPI:BatchRegister(map)
	for name, id in map do
		IconMap[name] = id
	end
end

function IconsAPI:Render(parent, name, size, color)
	if not name or name == "" then return nil end
	size  = size or 16
	color = color or T.sub

	local asset = IconMap[name] or FluentIcons[name] or FluentIcons["lucide-" .. name]
	if asset then
		return make("ImageLabel", {
			Size                 = UDim2.fromOffset(size, size),
			BackgroundTransparency = 1,
			Image                = asset,
			ImageColor3          = color,
			ScaleType            = Enum.ScaleType.Fit,
			Parent               = parent,
		})
	end

	-- check if name is already an rbxassetid
	if string.find(name, "rbxasset") then
		return make("ImageLabel", {
			Size                 = UDim2.fromOffset(size, size),
			BackgroundTransparency = 1,
			Image                = name,
			ImageColor3          = color,
			ScaleType            = Enum.ScaleType.Fit,
			Parent               = parent,
		})
	end

	local ch = ICON_TEXT[name] or string.upper(string.sub(name, 1, 1))
	return make("TextLabel", {
		Size                 = UDim2.fromOffset(size, size),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = math.floor(size * 0.78),
		TextColor3           = color,
		Text                 = ch,
		Parent               = parent,
	})
end

local function tween(obj, info, goals)
	local tw = TweenService:Create(obj, info, goals)
	tw:Play()
	return tw
end

local function corner(parent, r)
	return make("UICorner", { CornerRadius = UDim.new(0, r), Parent = parent })
end

local function stroke(parent, col, trans, thick)
	return make("UIStroke", {
		Color           = col or T.glass,
		Transparency    = trans or 0.92,
		Thickness       = thick or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent          = parent,
	})
end

local function pad(parent, t, b, l, r)
	return make("UIPadding", {
		PaddingTop    = UDim.new(0, t),
		PaddingBottom = UDim.new(0, b),
		PaddingLeft   = UDim.new(0, l),
		PaddingRight  = UDim.new(0, r),
		Parent        = parent,
	})
end

local function lay(parent, dir, gap)
	return make("UIListLayout", {
		FillDirection = dir or Enum.FillDirection.Vertical,
		Padding       = UDim.new(0, gap or 4),
		SortOrder     = Enum.SortOrder.LayoutOrder,
		Parent        = parent,
	})
end

local function mergeTheme(base, over)
	local r = table.clone(base)
	for k, v in over do r[k] = v end
	return r
end

-- ── Library State ───────────────────────────────────

local MadUI         = { Icons = IconsAPI }
local screenGui     = nil
local dropBackdrop  = nil
local notifHolder   = nil
local conns         = {}
local activeDropFn  = nil

local function initGui()
	if screenGui then return end

	screenGui = make("ScreenGui", {
		Name             = "MadUI",
		DisplayOrder     = 9999,
		ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn     = false,
		IgnoreGuiInset   = true,
	})

	pcall(function() if syn then syn.protect_gui(screenGui) end end)

	local ok = pcall(function()
		screenGui.Parent = game:GetService("CoreGui")
	end)
	if not ok then
		pcall(function() screenGui.Parent = player:WaitForChild("PlayerGui") end)
	end

	dropBackdrop = make("TextButton", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text    = "",
		ZIndex  = 50,
		Visible = false,
		Parent  = screenGui,
	})
	dropBackdrop.MouseButton1Click:Connect(function()
		if activeDropFn then activeDropFn(); activeDropFn = nil end
		dropBackdrop.Visible = false
	end)

	notifHolder = make("Frame", {
		Size                 = UDim2.new(0, 300, 1, -24),
		Position             = UDim2.new(1, -12, 0, 12),
		AnchorPoint          = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		ZIndex  = 100,
		Parent  = screenGui,
	})
	lay(notifHolder, Enum.FillDirection.Vertical, 8)
end

-- ── Row Factory ─────────────────────────────────────

local function createRow(parent, cfg, order)
	local hasDesc = cfg.Description and #cfg.Description > 0
	local h = hasDesc and 58 or 42

	local row = make("Frame", {
		Size                 = UDim2.new(1, 0, 0, h),
		BackgroundColor3     = T.elevated,
		BackgroundTransparency = 0.45,
		LayoutOrder          = order,
		ClipsDescendants     = true,
		Parent               = parent,
	})
	corner(row, 10)
	stroke(row, T.glass, 0.93, 1)

	row.MouseEnter:Connect(function()
		tween(row, Ease.quick, { BackgroundTransparency = 0.22 })
	end)
	row.MouseLeave:Connect(function()
		tween(row, Ease.quick, { BackgroundTransparency = 0.45 })
	end)

	make("TextLabel", {
		Size                 = UDim2.new(0.50, 0, 0, 18),
		Position             = UDim2.fromOffset(14, hasDesc and 10 or 12),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 13,
		TextColor3           = T.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextTruncate         = Enum.TextTruncate.AtEnd,
		Text                 = cfg.Name or "",
		Parent               = row,
	})

	if hasDesc then
		make("TextLabel", {
			Size                 = UDim2.new(0.60, 0, 0, 14),
			Position             = UDim2.fromOffset(14, 32),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.Gotham,
			TextSize             = 11,
			TextColor3           = T.sub,
			TextXAlignment       = Enum.TextXAlignment.Left,
			TextTruncate         = Enum.TextTruncate.AtEnd,
			Text                 = cfg.Description,
			Parent               = row,
		})
	end

	return row
end

-- ═══════════════════════════════════════════════════
-- Component Factories
-- ═══════════════════════════════════════════════════

local function _label(scroll, order, text)
	local lbl = make("TextLabel", {
		Size                 = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 12,
		TextColor3           = T.sub,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = text,
		LayoutOrder          = order,
		Parent               = scroll,
	})
	local obj = {}
	function obj:Set(t) lbl.Text = t end
	function obj:Destroy() lbl:Destroy() end
	return obj
end

local function _paragraph(scroll, order, cfg)
	local row = make("Frame", {
		Size                 = UDim2.new(1, 0, 0, 0),
		AutomaticSize        = Enum.AutomaticSize.Y,
		BackgroundColor3     = T.elevated,
		BackgroundTransparency = 0.45,
		LayoutOrder          = order,
		Parent               = scroll,
	})
	corner(row, 10)
	stroke(row, T.glass, 0.93, 1)
	pad(row, 12, 14, 14, 14)
	lay(row, Enum.FillDirection.Vertical, 6)

	local pTitle = make("TextLabel", {
		Size                 = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamBold,
		TextSize             = 13,
		TextColor3           = T.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = cfg.Title or "",
		LayoutOrder = 1,
		Parent      = row,
	})
	local pBody = make("TextLabel", {
		Size                 = UDim2.new(1, 0, 0, 0),
		AutomaticSize        = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Font                 = Enum.Font.Gotham,
		TextSize             = 11,
		TextColor3           = T.sub,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextWrapped          = true,
		Text                 = cfg.Content or "",
		LayoutOrder = 2,
		Parent      = row,
	})
	local obj = {}
	function obj:Set(c)
		if c.Title   then pTitle.Text = c.Title end
		if c.Content then pBody.Text  = c.Content end
	end
	function obj:Destroy() row:Destroy() end
	return obj
end

local function _button(scroll, order, cfg)
	local row = createRow(scroll, cfg, order)

	make("TextLabel", {
		Size                 = UDim2.fromOffset(16, 18),
		Position             = UDim2.new(1, -14, 0.5, 0),
		AnchorPoint          = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamBold,
		TextSize             = 16,
		TextColor3           = T.dim,
		Text                 = "›",
		Parent               = row,
	})

	local click = make("TextButton", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text    = "",
		AutoButtonColor = false,
		Parent  = row,
	})

	click.MouseButton1Click:Connect(function()
		tween(row, Ease.quick, { BackgroundTransparency = 0.06 })
		task.delay(0.1, function()
			tween(row, Ease.smooth, { BackgroundTransparency = 0.45 })
		end)
		if cfg.Callback then task.spawn(cfg.Callback) end
	end)

	local obj = {}
	function obj:Destroy() row:Destroy() end
	return obj
end

local function _toggle(scroll, order, cfg)
	local row = createRow(scroll, cfg, order)

	-- Track (pill)
	local track = make("Frame", {
		Size             = UDim2.fromOffset(42, 22),
		Position         = UDim2.new(1, -14, 0.5, 0),
		AnchorPoint      = Vector2.new(1, 0.5),
		BackgroundColor3 = T.hover,
		Parent           = row,
	})
	corner(track, 11)

	-- Inner glow track (shows when ON)
	local glow = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundColor3     = T.accent,
		BackgroundTransparency = 1,
		Parent               = track,
	})
	corner(glow, 11)
	make("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.6),
			NumberSequenceKeypoint.new(0.5, 0.3),
			NumberSequenceKeypoint.new(1, 0.6),
		}),
		Parent = glow,
	})

	-- Thumb
	local thumb = make("Frame", {
		Size             = UDim2.fromOffset(18, 18),
		Position         = UDim2.fromOffset(2, 2),
		BackgroundColor3 = T.text,
		Parent           = track,
	})
	corner(thumb, 9)
	local thumbStroke = stroke(thumb, Color3.new(0, 0, 0), 0.86, 1)

	local toggled = cfg.Default or false

	local function refresh(state, anim)
		toggled = state
		if anim == false then
			thumb.Position       = state and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
			track.BackgroundColor3 = state and T.accent or T.hover
			glow.BackgroundTransparency = state and 0 or 1
			thumbStroke.Color    = state and T.accent or Color3.new(0, 0, 0)
			thumbStroke.Transparency = state and 0.4 or 0.86
			return
		end

		-- Squish stretch → slide → snap back
		tween(thumb, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(22, 18),
		})
		tween(thumb, Ease.bounce, {
			Position = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2),
		})
		task.delay(0.14, function()
			tween(thumb, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(18, 18),
			})
		end)
		tween(track, Ease.smooth, { BackgroundColor3 = state and T.accent or T.hover })
		tween(glow, Ease.smooth, { BackgroundTransparency = state and 0 or 1 })
		tween(thumbStroke, Ease.smooth, {
			Color        = state and T.accent or Color3.new(0, 0, 0),
			Transparency = state and 0.4 or 0.86,
		})
	end

	refresh(toggled, false)

	local click = make("TextButton", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text    = "",
		AutoButtonColor = false,
		Parent  = row,
	})

	click.MouseButton1Click:Connect(function()
		refresh(not toggled, true)
		if cfg.Callback then task.spawn(cfg.Callback, toggled) end
	end)

	local obj = {}
	function obj:Set(v) refresh(v, true); if cfg.Callback then task.spawn(cfg.Callback, toggled) end end
	function obj:Get() return toggled end
	function obj:Destroy() row:Destroy() end
	return obj
end

local function _slider(scroll, order, cfg)
	local mn  = cfg.Min or 0
	local mx  = cfg.Max or 100
	local inc = cfg.Increment or 1
	local def = math.clamp(cfg.Default or mn, mn, mx)
	local hasDesc = cfg.Description and #cfg.Description > 0

	local row = createRow(scroll, cfg, order)
	row.Size = UDim2.new(1, 0, 0, hasDesc and 68 or 52)

	local valLbl = make("TextLabel", {
		Size                 = UDim2.fromOffset(52, 16),
		Position             = UDim2.new(1, -14, 0, hasDesc and 10 or 8),
		AnchorPoint          = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 12,
		TextColor3           = T.sub,
		TextXAlignment       = Enum.TextXAlignment.Right,
		Text                 = tostring(def),
		Parent               = row,
	})

	local trackY = hasDesc and 46 or 34
	local trackFrame = make("Frame", {
		Size             = UDim2.new(1, -28, 0, 4),
		Position         = UDim2.fromOffset(14, trackY),
		BackgroundColor3 = T.hover,
		Parent           = row,
	})
	corner(trackFrame, 2)

	local fill = make("Frame", {
		Size             = UDim2.fromScale(0, 1),
		BackgroundColor3 = T.accent,
		Parent           = trackFrame,
	})
	corner(fill, 2)

	local knob = make("Frame", {
		Size             = UDim2.fromOffset(14, 14),
		Position         = UDim2.fromScale(0, 0.5),
		AnchorPoint      = Vector2.new(0.5, 0.5),
		BackgroundColor3 = T.text,
		ZIndex           = 3,
		Parent           = trackFrame,
	})
	corner(knob, 7)
	stroke(knob, Color3.new(0, 0, 0), 0.84, 1)

	local value   = def
	local sliding = false

	local function update(pct, fire)
		pct = math.clamp(pct, 0, 1)
		local raw = mn + (mx - mn) * pct
		value = math.floor(raw / inc + 0.5) * inc
		value = math.clamp(value, mn, mx)
		local p = (value - mn) / (mx - mn)
		fill.Size     = UDim2.new(p, 0, 1, 0)
		knob.Position = UDim2.new(p, 0, 0.5, 0)
		valLbl.Text   = tostring(value)
		if fire and cfg.Callback then task.spawn(cfg.Callback, value) end
	end

	update((def - mn) / (mx - mn), false)

	trackFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliding = true
			update(math.clamp((input.Position.X - trackFrame.AbsolutePosition.X) / trackFrame.AbsoluteSize.X, 0, 1), true)
		end
	end)
	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
	end)
	table.insert(conns, UserInput.InputChanged:Connect(function(input)
		if not sliding then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		update(math.clamp((input.Position.X - trackFrame.AbsolutePosition.X) / trackFrame.AbsoluteSize.X, 0, 1), true)
	end))
	table.insert(conns, UserInput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
	end))

	local obj = {}
	function obj:Set(v) value = math.clamp(v, mn, mx); update((value - mn) / (mx - mn), false) end
	function obj:Get() return value end
	function obj:Destroy() row:Destroy() end
	return obj
end

local function _dropdown(scroll, order, cfg)
	local row = createRow(scroll, cfg, order)
	local options  = cfg.Options or {}
	local selected = cfg.Default or options[1] or ""

	local dropBtn = make("TextButton", {
		Size                 = UDim2.new(0.42, 0, 0, 24),
		Position             = UDim2.new(1, -14, 0.5, 0),
		AnchorPoint          = Vector2.new(1, 0.5),
		BackgroundColor3     = T.hover,
		BackgroundTransparency = 0.15,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 11,
		TextColor3           = T.text,
		Text                 = " " .. selected .. "  ▾",
		AutoButtonColor      = false,
		ClipsDescendants     = true,
		TextTruncate         = Enum.TextTruncate.AtEnd,
		Parent               = row,
	})
	corner(dropBtn, 8)
	stroke(dropBtn, T.border, 0.55, 1)
	pad(dropBtn, 0, 0, 8, 4)

	local popup = make("Frame", {
		BackgroundColor3     = T.surface,
		BackgroundTransparency = 0.04,
		Visible  = false,
		ZIndex   = 55,
		ClipsDescendants = true,
		Parent   = screenGui,
	})
	corner(popup, 10)
	stroke(popup, T.border, 0.4, 1)
	pad(popup, 4, 4, 4, 4)
	local popLay = lay(popup, Enum.FillDirection.Vertical, 2)

	local isOpen  = false
	local optBtns = {}
	local closeFn

	local function buildOpts()
		for _, b in optBtns do b:Destroy() end
		optBtns = {}
		for i, opt in options do
			local ob = make("TextButton", {
				Size                 = UDim2.new(1, 0, 0, 26),
				BackgroundColor3     = T.elevated,
				BackgroundTransparency = 0.5,
				Font                 = Enum.Font.GothamMedium,
				TextSize             = 11,
				TextColor3           = opt == selected and T.accent or T.text,
				Text                 = opt,
				AutoButtonColor      = false,
				LayoutOrder          = i,
				Parent               = popup,
			})
			corner(ob, 6)
			ob.MouseEnter:Connect(function() tween(ob, Ease.quick, { BackgroundTransparency = 0.12 }) end)
			ob.MouseLeave:Connect(function() tween(ob, Ease.quick, { BackgroundTransparency = 0.5 }) end)
			ob.MouseButton1Click:Connect(function()
				selected = opt
				dropBtn.Text = " " .. opt .. "  ▾"
				closeFn()
				if cfg.Callback then task.spawn(cfg.Callback, opt) end
			end)
			table.insert(optBtns, ob)
		end
	end

	closeFn = function()
		if not isOpen then return end
		isOpen = false
		tween(popup, Ease.quick, { Size = UDim2.fromOffset(popup.AbsoluteSize.X, 0) })
		task.delay(0.14, function() if not isOpen then popup.Visible = false end end)
		dropBackdrop.Visible = false
	end

	local function openFn()
		buildOpts()
		local ap, as = dropBtn.AbsolutePosition, dropBtn.AbsoluteSize
		popup.Position = UDim2.fromOffset(ap.X, ap.Y + as.Y + 4)
		popup.Size     = UDim2.fromOffset(math.max(as.X, 130), 0)
		popup.Visible  = true
		local tH = #options * 28 + math.max(#options - 1, 0) * 2 + 8
		tween(popup, Ease.spring, { Size = UDim2.fromOffset(math.max(as.X, 130), tH) })
		dropBackdrop.Visible = true
		isOpen = true
	end

	dropBtn.MouseButton1Click:Connect(function()
		if isOpen then
			closeFn()
		else
			if activeDropFn and activeDropFn ~= closeFn then activeDropFn() end
			activeDropFn = closeFn
			openFn()
		end
	end)

	local obj = {}
	function obj:Set(v) selected = v; dropBtn.Text = " " .. v .. "  ▾"; if cfg.Callback then task.spawn(cfg.Callback, v) end end
	function obj:Refresh(n) options = n; if not table.find(options, selected) then selected = options[1] or ""; dropBtn.Text = " " .. selected .. "  ▾" end end
	function obj:Get() return selected end
	function obj:Destroy() popup:Destroy(); row:Destroy() end
	return obj
end

local function _input(scroll, order, cfg)
	local row = createRow(scroll, cfg, order)

	local box = make("TextBox", {
		Size                 = UDim2.new(0.42, 0, 0, 24),
		Position             = UDim2.new(1, -14, 0.5, 0),
		AnchorPoint          = Vector2.new(1, 0.5),
		BackgroundColor3     = T.windowBg,
		BackgroundTransparency = 0.1,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 11,
		TextColor3           = T.text,
		PlaceholderText      = cfg.Placeholder or "Type...",
		PlaceholderColor3    = T.dim,
		Text                 = cfg.Default or "",
		ClearTextOnFocus     = false,
		ClipsDescendants     = true,
		Parent               = row,
	})
	corner(box, 8)
	local bxStroke = stroke(box, T.border, 0.5, 1)
	pad(box, 0, 0, 8, 8)

	box.Focused:Connect(function()
		tween(bxStroke, Ease.quick, { Color = T.accent, Transparency = 0.12 })
	end)
	box.FocusLost:Connect(function(enter)
		tween(bxStroke, Ease.quick, { Color = T.border, Transparency = 0.5 })
		if enter and cfg.Callback then task.spawn(cfg.Callback, box.Text) end
	end)

	local obj = {}
	function obj:Set(v) box.Text = v end
	function obj:Get() return box.Text end
	function obj:Destroy() row:Destroy() end
	return obj
end

local function _keybind(scroll, order, cfg)
	local row = createRow(scroll, cfg, order)
	local currentKey = cfg.Default
	local binding    = false

	local keyBtn = make("TextButton", {
		Size                 = UDim2.fromOffset(82, 24),
		Position             = UDim2.new(1, -14, 0.5, 0),
		AnchorPoint          = Vector2.new(1, 0.5),
		BackgroundColor3     = T.hover,
		BackgroundTransparency = 0.15,
		Font                 = Enum.Font.GothamMedium,
		TextSize             = 11,
		TextColor3           = T.sub,
		Text                 = currentKey and currentKey.Name or "None",
		AutoButtonColor      = false,
		Parent               = row,
	})
	corner(keyBtn, 8)
	stroke(keyBtn, T.border, 0.55, 1)

	keyBtn.MouseButton1Click:Connect(function()
		if binding then return end
		binding = true
		keyBtn.Text = "..."
		tween(keyBtn, Ease.quick, { BackgroundColor3 = T.accent, BackgroundTransparency = 0.55 })
		local c
		c = UserInput.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			c:Disconnect()
			binding = false
			tween(keyBtn, Ease.quick, { BackgroundColor3 = T.hover, BackgroundTransparency = 0.15 })
			if input.KeyCode == Enum.KeyCode.Escape then
				keyBtn.Text = currentKey and currentKey.Name or "None"
				return
			end
			currentKey  = input.KeyCode
			keyBtn.Text = currentKey.Name
			if cfg.Callback then task.spawn(cfg.Callback, currentKey) end
			if cfg.ChangedCallback then task.spawn(cfg.ChangedCallback, currentKey) end
		end)
	end)

	table.insert(conns, UserInput.InputBegan:Connect(function(input, gpe)
		if gpe or binding then return end
		if currentKey and input.KeyCode == currentKey then
			if cfg.Callback then task.spawn(cfg.Callback, currentKey) end
		end
	end))

	local obj = {}
	function obj:Set(k) currentKey = k; keyBtn.Text = k and k.Name or "None" end
	function obj:Get() return currentKey end
	function obj:Destroy() row:Destroy() end
	return obj
end

-- ═══════════════════════════════════════════════════
-- Component Mixins
-- ═══════════════════════════════════════════════════

local function attachBase(target, scroll, nextOrd)
	function target:CreateLabel(text)     return _label(scroll, nextOrd(), text) end
	function target:CreateParagraph(cfg)  return _paragraph(scroll, nextOrd(), cfg) end
	function target:CreateButton(cfg)     return _button(scroll, nextOrd(), cfg) end
	function target:CreateToggle(cfg)     return _toggle(scroll, nextOrd(), cfg) end
	function target:CreateSlider(cfg)     return _slider(scroll, nextOrd(), cfg) end
	function target:CreateDropdown(cfg)   return _dropdown(scroll, nextOrd(), cfg) end
	function target:CreateInput(cfg)      return _input(scroll, nextOrd(), cfg) end
	function target:CreateKeybind(cfg)    return _keybind(scroll, nextOrd(), cfg) end
end

local function attachAll(target, scroll, nextOrd)
	attachBase(target, scroll, nextOrd)

	function target:CreateSection(sCfg)
		sCfg = sCfg or {}
		local idx = nextOrd()

		local outer = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			AutomaticSize        = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder          = idx,
			Parent               = scroll,
		})
		lay(outer, Enum.FillDirection.Vertical, 0)

		-- Header
		local hdr = make("TextButton", {
			Size                 = UDim2.new(1, 0, 0, 32),
			BackgroundColor3     = T.elevated,
			BackgroundTransparency = 0.55,
			Text    = "",
			AutoButtonColor = false,
			LayoutOrder = 0,
			Parent  = outer,
		})
		corner(hdr, 10)

		local chevron = make("TextLabel", {
			Size                 = UDim2.fromOffset(14, 32),
			Position             = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamMedium,
			TextSize             = 10,
			TextColor3           = T.sub,
			Text                 = "▾",
			Parent               = hdr,
		})

		make("TextLabel", {
			Size                 = UDim2.new(1, -40, 1, 0),
			Position             = UDim2.fromOffset(26, 0),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamBold,
			TextSize             = 12,
			TextColor3           = T.text,
			TextXAlignment       = Enum.TextXAlignment.Left,
			Text                 = sCfg.Name or "Section",
			Parent               = hdr,
		})

		hdr.MouseEnter:Connect(function() tween(hdr, Ease.quick, { BackgroundTransparency = 0.35 }) end)
		hdr.MouseLeave:Connect(function() tween(hdr, Ease.quick, { BackgroundTransparency = 0.55 }) end)

		-- Clip wrapper
		local clip = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants     = true,
			LayoutOrder          = 1,
			Parent               = outer,
		})

		-- Content
		local content = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			AutomaticSize        = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent               = clip,
		})
		pad(content, 6, 2, 4, 0)
		local cLay = lay(content, Enum.FillDirection.Vertical, 5)

		local isOpen  = sCfg.Open ~= false
		local targetH = 0

		local function recalc()
			targetH = cLay.AbsoluteContentSize.Y + 12
			if isOpen then clip.Size = UDim2.new(1, 0, 0, targetH) end
		end
		cLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(recalc)
		task.defer(recalc)

		hdr.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			if isOpen then
				recalc()
				tween(clip, Ease.smooth, { Size = UDim2.new(1, 0, 0, targetH) })
				tween(chevron, Ease.smooth, { Rotation = 0 })
			else
				tween(clip, Ease.smooth, { Size = UDim2.new(1, 0, 0, 0) })
				tween(chevron, Ease.smooth, { Rotation = -90 })
			end
		end)

		if not isOpen then
			chevron.Rotation = -90
			clip.Size = UDim2.new(1, 0, 0, 0)
		end

		local Section = {}
		local sIdx = 0
		attachBase(Section, content, function() sIdx += 1; return sIdx end)
		function Section:Toggle()
			isOpen = not isOpen
			if isOpen then recalc(); tween(clip, Ease.smooth, { Size = UDim2.new(1, 0, 0, targetH) }); tween(chevron, Ease.smooth, { Rotation = 0 })
			else tween(clip, Ease.smooth, { Size = UDim2.new(1, 0, 0, 0) }); tween(chevron, Ease.smooth, { Rotation = -90 }) end
		end
		function Section:Destroy() outer:Destroy() end
		return Section
	end
end

-- ═══════════════════════════════════════════════════
-- Window
-- ═══════════════════════════════════════════════════

function MadUI:CreateWindow(config)
	initGui()

	config = config or {}
	local title     = config.Title or "MadUI"
	local subtitle  = config.Subtitle or "v2.0"
	local winW      = config.Size and config.Size.X.Offset or 580
	local winH      = config.Size and config.Size.Y.Offset or 400
	local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
	local sideW     = 158

	-- Resolve theme
	local themeCfg = config.Theme or "Dark"
	if type(themeCfg) == "string" then
		T = table.clone(Themes[themeCfg] or Themes.Dark)
	elseif type(themeCfg) == "table" then
		T = mergeTheme(Themes.Dark, themeCfg)
	end

	-- Canvas
	local canvas = make("CanvasGroup", {
		Size                 = UDim2.fromOffset(winW, winH),
		Position             = UDim2.fromScale(0.5, 0.5),
		AnchorPoint          = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		GroupTransparency    = 1,
		Parent               = screenGui,
	})

	-- Frame
	local frame = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundColor3     = T.windowBg,
		BackgroundTransparency = T.windowTrans,
		ClipsDescendants     = true,
		Parent               = canvas,
	})
	corner(frame, 14)
	stroke(frame, T.glass, 0.84, 1.5)

	-- Glass sheen
	local sheen = make("Frame", {
		Size                 = UDim2.fromScale(1, 1),
		BackgroundColor3     = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.97,
		Parent               = frame,
	})
	corner(sheen, 14)
	make("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0,    0.86),
			NumberSequenceKeypoint.new(0.3,  0.96),
			NumberSequenceKeypoint.new(0.65, 0.99),
			NumberSequenceKeypoint.new(1,    0.92),
		}),
		Rotation = 140,
		Parent   = sheen,
	})

	-- ── Sidebar ────────────────────────────────────

	local sidebar = make("Frame", {
		Size                 = UDim2.new(0, sideW, 1, 0),
		BackgroundColor3     = T.sidebarBg,
		BackgroundTransparency = T.sidebarTrans,
		BorderSizePixel      = 0,
		Parent               = frame,
	})
	corner(sidebar, 14)

	make("Frame", {
		Size                 = UDim2.new(0, 14, 1, 0),
		Position             = UDim2.new(1, -14, 0, 0),
		BackgroundColor3     = T.sidebarBg,
		BackgroundTransparency = T.sidebarTrans,
		BorderSizePixel      = 0,
		Parent               = sidebar,
	})

	make("Frame", {
		Size                 = UDim2.new(0, 1, 1, -16),
		Position             = UDim2.new(0, sideW, 0, 8),
		BackgroundColor3     = T.border,
		BackgroundTransparency = 0.3,
		BorderSizePixel      = 0,
		Parent               = frame,
	})

	-- Traffic lights
	local trafficArea = make("Frame", {
		Size                 = UDim2.fromOffset(60, 14),
		Position             = UDim2.fromOffset(16, 15),
		BackgroundTransparency = 1,
		Parent               = sidebar,
	})
	lay(trafficArea, Enum.FillDirection.Horizontal, 8)

	local lights = {}
	local function makeLight(color, sym)
		local btn = make("TextButton", {
			Size             = UDim2.fromOffset(12, 12),
			BackgroundColor3 = color,
			Text             = "",
			Font             = Enum.Font.GothamBold,
			TextSize         = 8,
			TextColor3       = Color3.fromRGB(0, 0, 0),
			TextTransparency = 0.3,
			AutoButtonColor  = false,
			Parent           = trafficArea,
		})
		corner(btn, 6)
		table.insert(lights, { btn = btn, sym = sym })
		return btn
	end

	local closeBtn = makeLight(T.red,    "✕")
	local minBtn   = makeLight(T.yellow, "–")
	makeLight(T.green, "+")

	trafficArea.MouseEnter:Connect(function()
		for _, l in lights do l.btn.Text = l.sym end
	end)
	trafficArea.MouseLeave:Connect(function()
		for _, l in lights do l.btn.Text = "" end
	end)

	-- Title
	local titleLabel = make("TextLabel", {
		Size                 = UDim2.new(1, -24, 0, 17),
		Position             = UDim2.fromOffset(16, 40),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamBold,
		TextSize             = 14,
		TextColor3           = T.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextTruncate         = Enum.TextTruncate.AtEnd,
		Text                 = title,
		Parent               = sidebar,
	})

	make("TextLabel", {
		Size                 = UDim2.new(1, -24, 0, 12),
		Position             = UDim2.fromOffset(16, 59),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.Gotham,
		TextSize             = 10,
		TextColor3           = T.dim,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = subtitle,
		Parent               = sidebar,
	})

	-- Tab scroll
	local tabScroll = make("ScrollingFrame", {
		Size                 = UDim2.new(1, -20, 1, -108),
		Position             = UDim2.fromOffset(10, 82),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		ScrollBarThickness   = 0,
		CanvasSize           = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize  = Enum.AutomaticSize.Y,
		Parent               = sidebar,
	})
	lay(tabScroll, Enum.FillDirection.Vertical, 3)

	-- Branding
	make("TextLabel", {
		Size                 = UDim2.new(1, -24, 0, 14),
		Position             = UDim2.new(0, 16, 1, -26),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.Gotham,
		TextSize             = 10,
		TextColor3           = T.dim,
		TextTransparency     = 0.4,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = "MadUI",
		Parent               = sidebar,
	})

	-- ── Content Area ───────────────────────────────

	local contentArea = make("Frame", {
		Size                 = UDim2.new(1, -sideW - 1, 1, 0),
		Position             = UDim2.fromOffset(sideW + 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants     = true,
		Parent               = frame,
	})

	-- ── Dragging ───────────────────────────────────

	local dragging, dragStart, startPos = false, Vector3.zero, UDim2.new()

	local dragZone = make("Frame", {
		Size                 = UDim2.new(1, 0, 0, 40),
		Position             = UDim2.fromOffset(sideW + 1, 0),
		BackgroundTransparency = 1,
		Parent               = frame,
	})

	dragZone.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = input.Position
			startPos  = canvas.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then 
					dragging = false 
					tween(canvas, Ease.smooth, { Rotation = 0 })
				end
			end)
		end
	end)

	local lastRot = 0
	table.insert(conns, UserInput.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local d = input.Position - dragStart
		
		-- Smooth position tween
		local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		tween(canvas, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos })
		
		-- Tilt effect based on drag velocity
		local deltaX = input.Delta.X
		local targetRot = math.clamp(deltaX * 0.15, -1.5, 1.5)
		lastRot = lastRot + (targetRot - lastRot) * 0.3
		tween(canvas, TweenInfo.new(0.1), { Rotation = lastRot })
	end))

	-- ── Open Animation ─────────────────────────────

	canvas.Size              = UDim2.fromOffset(winW * 0.91, winH * 0.91)
	canvas.GroupTransparency = 1
	task.defer(function()
		tween(canvas, Ease.spring, { Size = UDim2.fromOffset(winW, winH), GroupTransparency = 0 })
	end)

	-- ── Toggle Visibility ──────────────────────────

	local visible = true
	table.insert(conns, UserInput.InputBegan:Connect(function(input, gpe)
		if gpe or input.KeyCode ~= toggleKey then return end
		visible = not visible
		if visible then
			canvas.Visible = true
			tween(canvas, Ease.spring, { Size = UDim2.fromOffset(winW, winH), GroupTransparency = 0 })
		else
			local tw = tween(canvas, Ease.smooth, { Size = UDim2.fromOffset(winW * 0.94, winH * 0.94), GroupTransparency = 1 })
			tw.Completed:Connect(function() if not visible then canvas.Visible = false end end)
		end
	end))

	-- ── Close / Minimize ───────────────────────────

	closeBtn.MouseButton1Click:Connect(function()
		local tw = tween(canvas, Ease.smooth, { Size = UDim2.fromOffset(winW * 0.88, winH * 0.88), GroupTransparency = 1 })
		tw.Completed:Connect(function() canvas:Destroy() end)
	end)

	minBtn.MouseButton1Click:Connect(function()
		visible = false
		local tw = tween(canvas, Ease.smooth, { Size = UDim2.fromOffset(winW * 0.94, winH * 0.94), GroupTransparency = 1 })
		tw.Completed:Connect(function() if not visible then canvas.Visible = false end end)
	end)

	-- ═══════════════════════════════════════════════
	-- Tab System
	-- ═══════════════════════════════════════════════

	local Window      = {}
	local currentPage = nil
	local tabGlobalIdx = 0

	local function createTabCore(btnParent, tabCfg)
		tabCfg = tabCfg or {}
		tabGlobalIdx += 1
		local myIdx   = tabGlobalIdx
		local tabName = tabCfg.Name or "Tab"
		local tabIcon = tabCfg.Icon

		-- Sidebar button
		local tabBtn = make("TextButton", {
			Size                 = UDim2.new(1, 0, 0, 30),
			BackgroundColor3     = T.accent,
			BackgroundTransparency = 1,
			Text    = "",
			AutoButtonColor = false,
			Parent  = btnParent,
		})
		corner(tabBtn, 8)

		local hasIcon = tabIcon and #tabIcon > 0
		local iconEl
		if hasIcon then
			iconEl = IconsAPI:Render(tabBtn, tabIcon, 16, T.sub)
			if iconEl then iconEl.Position = UDim2.fromOffset(10, 7) end
		end

		local tabLabel = make("TextLabel", {
			Size                 = UDim2.new(1, hasIcon and -38 or -20, 1, 0),
			Position             = UDim2.fromOffset(hasIcon and 32 or 10, 0),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamMedium,
			TextSize             = 12,
			TextColor3           = T.sub,
			TextXAlignment       = Enum.TextXAlignment.Left,
			TextTruncate         = Enum.TextTruncate.AtEnd,
			Text                 = tabName,
			Parent               = tabBtn,
		})

		-- Content page
		local page = make("CanvasGroup", {
			Size                 = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			GroupTransparency    = 1,
			Visible              = false,
			Parent               = contentArea,
		})

		make("TextLabel", {
			Size                 = UDim2.new(1, -36, 0, 20),
			Position             = UDim2.fromOffset(20, 12),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamBold,
			TextSize             = 16,
			TextColor3           = T.text,
			TextXAlignment       = Enum.TextXAlignment.Left,
			Text                 = tabName,
			Parent               = page,
		})

		local scr = make("ScrollingFrame", {
			Size                 = UDim2.new(1, 0, 1, -46),
			Position             = UDim2.fromOffset(0, 46),
			BackgroundTransparency = 1,
			BorderSizePixel      = 0,
			ScrollBarThickness   = 3,
			ScrollBarImageColor3 = T.dim,
			ScrollBarImageTransparency = 0.35,
			CanvasSize           = UDim2.new(0, 0, 0, 0),
			TopImage             = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			MidImage             = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			BottomImage          = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			Parent               = page,
		})
		pad(scr, 0, 14, 20, 20)
		local scrLay = lay(scr, Enum.FillDirection.Vertical, 5)
		scrLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			scr.CanvasSize = UDim2.fromOffset(0, scrLay.AbsoluteContentSize.Y + 18)
		end)

		-- Slide + fade switching
		local function activate()
			local oldIdx = currentPage and currentPage.idx or myIdx
			local dir    = myIdx >= oldIdx and 1 or -1
			local slide  = 28

			if currentPage and currentPage.page ~= page then
				local old = currentPage
				tween(old.page, Ease.smooth, {
					GroupTransparency = 1,
					Position = UDim2.fromOffset(-slide * dir, 0),
				})
				tween(old.btn, Ease.quick, { BackgroundTransparency = 1 })
				tween(old.lbl, Ease.quick, { TextColor3 = T.sub })
				if old.icon then
					pcall(function()
						tween(old.icon, Ease.quick, { ImageColor3 = T.sub })
					end)
					pcall(function()
						tween(old.icon, Ease.quick, { TextColor3 = T.sub })
					end)
				end
				task.delay(0.28, function()
					if currentPage and currentPage.page ~= old.page then
						old.page.Visible  = false
						old.page.Position = UDim2.fromOffset(0, 0)
					end
				end)
			end

			page.Position         = UDim2.fromOffset(slide * dir, 0)
			page.Visible          = true
			page.GroupTransparency = 1
			tween(page, Ease.smooth, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) })
			tween(tabBtn, Ease.smooth, { BackgroundTransparency = 0.82 })
			tween(tabLabel, Ease.smooth, { TextColor3 = T.text })
			if iconEl then
				pcall(function() tween(iconEl, Ease.smooth, { ImageColor3 = T.text }) end)
				pcall(function() tween(iconEl, Ease.smooth, { TextColor3 = T.text }) end)
			end

			currentPage = { page = page, btn = tabBtn, lbl = tabLabel, idx = myIdx, icon = iconEl }
		end

		tabBtn.MouseButton1Click:Connect(activate)

		tabBtn.MouseEnter:Connect(function()
			if currentPage and currentPage.btn == tabBtn then return end
			tween(tabBtn, Ease.quick, { BackgroundTransparency = 0.9 })
		end)
		tabBtn.MouseLeave:Connect(function()
			if currentPage and currentPage.btn == tabBtn then return end
			tween(tabBtn, Ease.quick, { BackgroundTransparency = 1 })
		end)

		if not currentPage then task.defer(activate) end

		-- Build Tab API
		local Tab   = {}
		local cIdx  = 0
		attachAll(Tab, scr, function() cIdx += 1; return cIdx end)
		return Tab
	end

	-- ── Window API ─────────────────────────────────

	function Window:CreateTab(cfg)
		return createTabCore(tabScroll, cfg)
	end

	function Window:CreateTabSection(tsCfg)
		tsCfg = tsCfg or {}

		local outer = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			AutomaticSize        = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent               = tabScroll,
		})
		lay(outer, Enum.FillDirection.Vertical, 0)

		local hdr = make("TextButton", {
			Size                 = UDim2.new(1, 0, 0, 22),
			BackgroundColor3     = T.elevated,
			BackgroundTransparency = 1,
			Text    = "",
			AutoButtonColor = false,
			LayoutOrder = 0,
			Parent  = outer,
		})
		corner(hdr, 4)

		make("TextLabel", {
			Size                 = UDim2.new(1, -24, 1, 0),
			Position             = UDim2.fromOffset(6, 0),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamBold,
			TextSize             = 9,
			TextColor3           = T.dim,
			TextXAlignment       = Enum.TextXAlignment.Left,
			Text                 = string.upper(tsCfg.Name or "Section"),
			Parent               = hdr,
		})

		local chev = make("TextLabel", {
			Size                 = UDim2.fromOffset(10, 22),
			Position             = UDim2.new(1, -4, 0, 0),
			AnchorPoint          = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Font                 = Enum.Font.GothamMedium,
			TextSize             = 8,
			TextColor3           = T.dim,
			Text                 = "▾",
			Parent               = hdr,
		})

		hdr.MouseEnter:Connect(function() tween(hdr, Ease.quick, { BackgroundTransparency = 0.82 }) end)
		hdr.MouseLeave:Connect(function() tween(hdr, Ease.quick, { BackgroundTransparency = 1 }) end)

		local tabClip = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants     = true,
			LayoutOrder          = 1,
			Parent               = outer,
		})

		local tabContent = make("Frame", {
			Size                 = UDim2.new(1, 0, 0, 0),
			AutomaticSize        = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent               = tabClip,
		})
		pad(tabContent, 2, 2, 0, 0)
		local tcLay = lay(tabContent, Enum.FillDirection.Vertical, 2)

		local tsOpen  = tsCfg.Open ~= false
		local tsH     = 0

		local function tsRecalc()
			tsH = tcLay.AbsoluteContentSize.Y + 6
			if tsOpen then tabClip.Size = UDim2.new(1, 0, 0, tsH) end
		end
		tcLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(tsRecalc)
		task.defer(tsRecalc)

		hdr.MouseButton1Click:Connect(function()
			tsOpen = not tsOpen
			if tsOpen then
				tsRecalc()
				tween(tabClip, Ease.smooth, { Size = UDim2.new(1, 0, 0, tsH) })
				tween(chev, Ease.smooth, { Rotation = 0 })
			else
				tween(tabClip, Ease.smooth, { Size = UDim2.new(1, 0, 0, 0) })
				tween(chev, Ease.smooth, { Rotation = -90 })
			end
		end)

		if not tsOpen then chev.Rotation = -90 end

		local TabSection = {}
		function TabSection:CreateTab(cfg)
			return createTabCore(tabContent, cfg)
		end
		return TabSection
	end

	function Window:SetTitle(t) titleLabel.Text = t end

	function Window:Toggle()
		visible = not visible
		if visible then
			canvas.Visible = true
			tween(canvas, Ease.spring, { Size = UDim2.fromOffset(winW, winH), GroupTransparency = 0 })
		else
			local tw = tween(canvas, Ease.smooth, { Size = UDim2.fromOffset(winW * 0.94, winH * 0.94), GroupTransparency = 1 })
			tw.Completed:Connect(function() if not visible then canvas.Visible = false end end)
		end
	end

	function Window:Destroy()
		canvas:Destroy()
	end

	return Window
end

-- ═══════════════════════════════════════════════════
-- Notifications
-- ═══════════════════════════════════════════════════

function MadUI:Notify(nCfg)
	initGui()
	nCfg = nCfg or {}

	local typeCol = {
		info    = T.accent,
		success = T.green,
		warning = T.yellow,
		error   = T.red,
	}
	local accentCol = typeCol[nCfg.Type or "info"] or T.accent
	local dur       = nCfg.Duration or 3

	local notif = make("CanvasGroup", {
		Size                 = UDim2.new(1, 0, 0, 0),
		BackgroundColor3     = T.surface,
		GroupTransparency    = 1,
		ClipsDescendants     = true,
		ZIndex               = 100,
		Parent               = notifHolder,
	})
	corner(notif, 12)
	stroke(notif, T.glass, 0.84, 1)

	local bar = make("Frame", {
		Size                 = UDim2.new(0, 3, 1, -18),
		Position             = UDim2.fromOffset(10, 9),
		BackgroundColor3     = accentCol,
		ZIndex               = 101,
		Parent               = notif,
	})
	corner(bar, 2)

	make("TextLabel", {
		Size                 = UDim2.new(1, -40, 0, 15),
		Position             = UDim2.fromOffset(24, 12),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.GothamBold,
		TextSize             = 12,
		TextColor3           = T.text,
		TextXAlignment       = Enum.TextXAlignment.Left,
		Text                 = nCfg.Title or "Notification",
		ZIndex               = 101,
		Parent               = notif,
	})

	make("TextLabel", {
		Size                 = UDim2.new(1, -40, 0, 26),
		Position             = UDim2.fromOffset(24, 30),
		BackgroundTransparency = 1,
		Font                 = Enum.Font.Gotham,
		TextSize             = 10,
		TextColor3           = T.sub,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextYAlignment       = Enum.TextYAlignment.Top,
		TextWrapped          = true,
		Text                 = nCfg.Content or "",
		ZIndex               = 101,
		Parent               = notif,
	})

	local prog = make("Frame", {
		Size                 = UDim2.new(1, -20, 0, 2),
		Position             = UDim2.new(0, 10, 1, -7),
		BackgroundColor3     = accentCol,
		BackgroundTransparency = 0.4,
		ZIndex               = 101,
		Parent               = notif,
	})
	corner(prog, 1)

	tween(notif, Ease.spring, { Size = UDim2.new(1, 0, 0, 66), GroupTransparency = 0 })
	tween(prog, Ease.linear(dur), { Size = UDim2.new(0, 0, 0, 2) })

	task.delay(dur, function()
		tween(notif, Ease.smooth, { GroupTransparency = 1 })
		task.delay(0.28, function()
			tween(notif, Ease.smooth, { Size = UDim2.new(1, 0, 0, 0) })
			task.delay(0.28, function() notif:Destroy() end)
		end)
	end)
end

-- ═══════════════════════════════════════════════════
-- Cleanup
-- ═══════════════════════════════════════════════════

function MadUI:Destroy()
	for _, c in conns do
		if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
	end
	table.clear(conns)
	if screenGui then screenGui:Destroy(); screenGui = nil end
end

return MadUI
